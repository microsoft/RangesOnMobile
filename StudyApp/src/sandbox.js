var d3 = require("d3");
var moment = require("moment");
var globals = require("./globals");
var rangeChart = require("./rangeChart");
var temperatureData = require("./data/temperatureData");
var sleepData = require("./data/sleepData");

function sandbox () {

  data_unit = 'temperature';
  suppress_touch_val_feedback = false;
  suppress_touch_feedback = false;
  
  var range_chart,
      checkExist;    
  
  function getDims() {
    height = window.innerHeight;
    width = window.innerWidth;
    svg_dim = d3.min([height,width]) - 2;
    inner_padding = svg_dim * 0.125;
    chart_dim = svg_dim * 0.75;
  }
  
  function redraw() {
  
    getDims();
        
    d3.select('#main_svg')
    .style('height',svg_dim + 'px')
    .style('width',svg_dim + 'px');
    
    chart_g.attr('transform','translate(' + inner_padding + ',' + inner_padding + ')');
  
    if (first_date.isBefore(min_date)) {
      first_date = min_date;
    }   
    else if (first_date.isAfter(max_date)) {
      first_date = max_date;
    } 
  
    selected_week = first_date.endOf('week').week();
    selected_month = first_date.month();
    selected_year = first_date.year();
  
    d3.selectAll('.guide').remove();
    chart_g.call(range_chart);
    chart_g.call(range_chart);
  
    d3.selectAll('.toolbar')
    .style('float', function(){
      return height < width ? 'left' : 'inherit';
    })
    .style('width', function(){
      return height < width ? (height / 5) + 'px'  : width + 'px';
    })
    .style('height', function(){
      return height < width ? height + 'px'  : (width / 5) + 'px';
    });
  
    d3.selectAll('.img_btn_enabled')
    .style('margin', function(){
      return height < width ? '0px' : '2px';
    })
    .attr('height', function(){
      return height < width ? (height / 5 - 6) : (width / 5 - 6);
    })
    .attr('width', function (){
      return width < height ? (width / 5 - 6) : (height / 5 - 6);
    });
  
    d3.select('#date_indicator')
    .attr('transform', function () {
      return 'translate(' + (svg_dim - inner_padding + 15) + ',' + (svg_dim) + ')';
    })
    .text(function () {
      var date_inidator_text = "";
      switch (range_chart.granularity()) {
  
        case 'week':
          date_inidator_text = first_date.format('YYYY') + ' W' + first_date.startOf('week').week();
        break;
  
        case 'month':
          date_inidator_text = first_date.format('MMM YYYY');
        break;
  
        case 'year':
          date_inidator_text = first_date.format('YYYY');
        break;
  
        default:
          date_inidator_text = "";
        break;
  
      }
      return date_inidator_text;
    });    

    // console.log("min_start_indices " + min_start_indices);
    // console.log("max_end_indices " + max_end_indices);
    // console.log("max_range_indices " + max_range_indices);  

    var quant_scale = range_chart.quant_scale( );

    console.log({        
        "index": range_chart.granularity() == 'week' ? selected_week : range_chart.granularity() == 'month' ? selected_month : 0, 
        "domain_0": quant_scale.domain()[0],
        "domain_1": quant_scale.domain()[1],
        "max_error": quant_scale.domain()[1] - quant_scale.domain()[0]
    });

  }  
  
  function toggleLinRad () {
    if (range_chart.representation() == "radial") {
      range_chart.representation("linear");
      // console.log("linear representation");
    }
    else if (range_chart.representation() == "linear") {
      range_chart.representation("radial"); 
      // console.log("radial representation!");
    }
    redraw();
    // appInsights.trackEvent("SandBoxEvent", { 
    //   "TimeStamp": new Date().valueOf(),
    //   "user_id": userID, 
    //   "Event": "SandBoxEvent",
    //   "EventType": "toggleLinRad", 
    //   "DataType": data_unit,
    //   "Representation": range_chart.representation(), 
    //   "Granularity": range_chart.granularity(),
    //   "Week": selected_week,
    //   "Month": selected_month,
    //   "Year": selected_year
    // });
    document.getElementById('sandbox_div').focus();
  }
  
  function loadData () {     

    checkExist = setInterval(function() {
      if (all_data != undefined) {
        first_date = moment(all_data[0].date_val);
        min_date = first_date;
        max_date = moment(all_data[all_data.length - 1].date_val);
        selected_week = first_date.endOf('week').week();
        selected_month = first_date.month();
        selected_year = first_date.year();
        chart_g.datum(all_data);
        redraw();    
        
        hideAddressBar();

        d3.select('#sandbox_div')
        .style('visibility','visible');

        // appInsights.trackEvent("SandBoxEvent", { 
        //   "TimeStamp": new Date().valueOf(),
        //   "user_id": userID, 
        //   "Event": "SandBoxEvent",
        //   "EventType": "loadData", 
        //   "DataType": data_unit,
        //   "Representation": range_chart.representation(), 
        //   "Granularity": range_chart.granularity(),
        //   "Week": selected_week,
        //   "Month": selected_month,
        //   "Year": selected_year
        // });

        clearInterval(checkExist);
      }
    }, 100); // check every 100ms

    range_chart = rangeChart();
    range_chart.granularity("week");
  
    main_svg = d3.select('#main_svg').remove();
  
    main_svg = d3.select('#sandbox_div').append('svg')
    .attr('id','main_svg');  
  
    defs = d3.select('#main_svg').append('defs');
  
    chart_g = main_svg.append('g')
    .attr('id','chart_g');
  
    date_indicator = main_svg.append('text')
    .attr('id','date_indicator')  
    .attr('text-anchor', "middle")
    .attr('alignment-baseline','middle')
    .attr('dy','-1em')
    .text('');     
    
    document.getElementById('sandbox_div').focus();
  }
  
  function navEarlier () {
    range_chart.exit_direction("right");
    // console.log("move backward in time");
  
    if (range_chart.granularity() == "week" &&  first_date.endOf('week').subtract(1,'weeks').isAfter(min_date)){
      first_date = first_date.endOf('week').subtract(1,'weeks');
    }
    else if (range_chart.granularity() == "month" && first_date.startOf('month').subtract(1,'months').isAfter(min_date)){
      first_date = first_date.startOf('month').subtract(1,'months');
    }
    else if (range_chart.granularity() == "year" && first_date.startOf('year').subtract(1,'years').isAfter(min_date)){
      first_date = first_date.startOf('year').subtract(1,'years');
    } 
    
    if (first_date.isBefore(min_date)) {
      // console.log("min date exceeded");
      first_date = min_date;
    }
  
    redraw();
    // appInsights.trackEvent("SandBoxEvent", { 
    //   "TimeStamp": new Date().valueOf(),
    //   "user_id": userID, 
    //   "Event": "SandBoxEvent",
    //   "EventType": "navEarlier", 
    //   "DataType": data_unit,
    //   "Representation": range_chart.representation(), 
    //   "Granularity": range_chart.granularity(),
    //   "Week": selected_week,
    //   "Month": selected_month,
    //   "Year": selected_year
    // });
    document.getElementById('sandbox_div').focus();
  }
  
  function navLater () {
    range_chart.exit_direction("left");
    // console.log("move forward in time");
  
    var temp_min_date = min_date;
  
    if (range_chart.granularity() == "week"){
      first_date = first_date.endOf('week').add(1,'weeks');
    }
    else if (range_chart.granularity() == "month"){
      first_date = first_date.startOf('month').add(1,'months');
    }
    else if (range_chart.granularity() == "year"){
      first_date = first_date.startOf('year').add(1,'years');
    }
  
    if (first_date.isAfter(max_date)) {
      // console.log("max date exceeded");
      first_date = temp_min_date;
    }
  
    redraw();
    // appInsights.trackEvent("SandBoxEvent", { 
    //   "TimeStamp": new Date().valueOf(),
    //   "user_id": userID, 
    //   "Event": "SandBoxEvent",
    //   "EventType": "navLater", 
    //   "DataType": data_unit,
    //   "Representation": range_chart.representation(), 
    //   "Granularity": range_chart.granularity(),
    //   "Week": selected_week,
    //   "Month": selected_month,
    //   "Year": selected_year
    // });
    document.getElementById('sandbox_div').focus();
  }
  
  function navUp () {
    range_chart.exit_direction("left");
    // console.log("larger granularity");
  
    if (range_chart.granularity() == "week"){
      range_chart.granularity("month");
      first_date = first_date.startOf('month');
    }
    else if (range_chart.granularity() == "month"){
      range_chart.granularity("year");
      first_date = first_date.startOf('year');
    }
  
    if (first_date.isBefore(min_date)) {
      first_date = min_date;
    }
  
    d3.selectAll('.element_date tspan').text("");
    redraw();
    // appInsights.trackEvent("SandBoxEvent", { 
    //   "TimeStamp": new Date().valueOf(),
    //   "user_id": userID, 
    //   "Event": "SandBoxEvent",
    //   "EventType": "navUp", 
    //   "DataType": data_unit,
    //   "Representation": range_chart.representation(), 
    //   "Granularity": range_chart.granularity(),
    //   "Week": selected_week,
    //   "Month": selected_month,
    //   "Year": selected_year
    // });
    document.getElementById('sandbox_div').focus();
  }
  
  function navDown () {
    range_chart.exit_direction("right");
    // console.log("smaller granularity");
  
    if (range_chart.granularity() == "month"){
      range_chart.granularity("week");
    }
    else if (range_chart.granularity() == "year"){
      range_chart.granularity("month");
    }
  
    if (first_date.startOf('month').isBefore(min_date)) {
      first_date = min_date;
    }
    else {
      first_date = first_date.startOf('month');
    }
  
    d3.selectAll('.element_date tspan').text("");
    redraw();
    // appInsights.trackEvent("SandBoxEvent", { 
    //   "TimeStamp": new Date().valueOf(),
    //   "user_id": userID, 
    //   "Event": "SandBoxEvent",
    //   "EventType": "navDown", 
    //   "DataType": data_unit,
    //   "Representation": range_chart.representation(), 
    //   "Granularity": range_chart.granularity(),
    //   "Week": selected_week,
    //   "Month": selected_month,
    //   "Year": selected_year
    // });
    document.getElementById('sandbox_div').focus();
  }
  
  
  /** INIT **/
  
  d3.select('body').append('div')
  .attr('id','sandbox_div')
  .attr('tabindex',0);
  
  var menubar = d3.select('#sandbox_div').append('div')
  .attr('class','toolbar')
  .attr('id','menubar');
  
  menubar.append("input")
  .attr('class', 'img_btn_enabled')
  .attr('type','image')
  .attr('name','Representation')
  .attr('title', 'Representation')
  .attr('src', 'assets/linear.png')
  .on('touchstart', function() {
    toggleLinRad();  
  });
  
  var source_type_rb = menubar.selectAll("g")
  .data(["temperature","sleep"])
  .enter();
  
  var source_type_rb_label = source_type_rb.append("label")
  .attr("class", "menu_rb");
  
  source_type_rb_label.append("input")
  .attr('type','radio')
  .attr('name','source_type_rb')
  .attr('value', function(d) {
    return d;
  })
  .property("disabled",false)
  .property("checked", function (d) {
    return d == "temperature";
  });
  
  source_type_rb_label.append("img")
  .attr('class', 'img_btn_enabled')
  .attr('title', function(d){
    return d;
  })
  .attr('src', function(d){
    var src = "";
    switch(d) {
      case 'temperature':
        src = "assets/temperature.png";
      break;
      case 'sleep':
         src = "assets/sleep.png";
      break;      
      default:
        src = "assets/default.png";
      break;
    }
    return src;
  });
  
  menubar.selectAll("input[name=source_type_rb]").on("change", function() { 
    // console.log("loading: " + this.value);
  
    data_unit = this.value;
  
    switch (this.value) {
      case 'temperature':
      all_data = temperatureData;     
      break;
  
      case 'sleep':
      all_data = sleepData; 
      break;
  
      default:
      all_data = sleepData; 
      break;
    }      
  
    loadData();
  
  });
  
  var navbar = d3.select('#sandbox_div').append('div')
  .attr('class','toolbar')
  .attr('id','navbar');
  
  navbar.append("input")
  .attr('class', 'img_btn_enabled')
  .attr('type','image')
  .attr('name','Prev')
  .attr('title', 'Prev')
  .attr('src', 'assets/prev.png')
  .on('touchstart', function() {  
    navEarlier();
  });
  
  navbar.append("input")
  .attr('class', 'img_btn_enabled')
  .attr('type','image')
  .attr('name','Next')
  .attr('title', 'Prev')
  .attr('src', 'assets/next.png')
  .on('touchstart', function() {  
    navLater();
  });
  
  navbar.append("input")
  .attr('class', 'img_btn_enabled')
  .attr('type','image')
  .attr('name','Up')
  .attr('title', 'Up')
  .attr('src', 'assets/up.png')
  .on('touchstart', function() {  
    navUp();
  });
  
  navbar.append("input")
  .attr('class', 'img_btn_enabled')
  .attr('type','image')
  .attr('name','Down')
  .attr('title', 'Down')
  .attr('src', 'assets/down.png')
  .on('touchstart', function() {  
    navDown();
  });
  
  navbar.append("input")
  .attr('class', 'img_btn_enabled')
  .attr('type','image')
  .attr('name','Exit')
  .attr('title', 'Exit')
  .attr('src', 'assets/fullscreen.png')
  .on('touchstart', function() {  
    // console.log('remove sandbox');
    // appInsights.trackEvent("SandBox_Closed", { 
    //   "TimeStamp": new Date().valueOf(),
    //   "Event": "SandBox_Closed",
    //   "user_id": userID
    // });
    document.getElementById('sandbox_div').remove();
    loadMenu();
    hideAddressBar();   
  });  

  all_data = temperatureData;     
  loadData();

}

module.exports = sandbox;
