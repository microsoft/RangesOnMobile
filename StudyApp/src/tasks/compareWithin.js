var d3 = require("d3");
var moment = require("moment");
var globals = require("../globals");
var rangeChart = require("../rangeChart");
var temperatureData = require("../data/temperatureData");
var sleepData = require("../data/sleepData");

function compareWithin (task,index) {  

  suppress_touch_feedback = true;
  suppress_touch_val_feedback = true;

  var attempts = 1;

  data_unit = task.datatype;
  all_data = (task.datatype == 'temperature') ? temperatureData : sleepData;
  
  var range_chart,
      checkExist,
      svgExist,
      i = 0;    
  
  function getDims() {
    height = window.innerHeight;
    width = window.innerWidth;
    svg_dim = d3.min([height,width]) - 2;
    inner_padding = svg_dim * 0.125;
    chart_dim = svg_dim * 0.75;
  }
  
  function draw() {
  
    getDims();
  
    d3.select('#main_svg')
    .style('height',svg_dim + 'px')
    .style('width',svg_dim + 'px');
    
    chart_g.attr('transform','translate(' + inner_padding + ',' + inner_padding + ')');
  
    d3.selectAll('.guide').remove();
    chart_g.call(range_chart); //enter
    chart_g.call(range_chart); //update      
    
    var specified_date = d3.select('#chart_g').append('g')
    .attr('class','specified_date')
    .attr('transform', function(d){
      if (range_chart.representation() == "linear") {
        return "translate(0,0)";
      }
      else {
        return "translate(" + (chart_dim / 2) + "," + (chart_dim / 2) + ")";
      }
    });

    specified_date.append('path')
    .attr('d',d3.symbol()
      .type(d3.symbolTriangle)
      .size(50)
    )
    .attr("transform",function(){
      var quant_scale = range_chart.quant_scale( );      

      if (range_chart.representation() == "linear") {
        var chron_scale = range_chart.chron_scale( );
        chron_pos = chron_scale( (range_chart.granularity() == 'week' ) ? (task.target - 1) : task.target );                
        return "translate(" + chron_pos + "," + (0 - inner_padding + 5) + ")rotate(180)";
      }
      else { //representation == "radial"    
      
        var radial_scale = d3.scaleLinear();
        radial_scale.range([0,2 * Math.PI]);

        var rotation = -180,
        x_pos = 0,
        y_pos = 0;

        if (range_chart.granularity() == "week") {
          radial_scale.domain([0,7]);
          rotation += (task.target - 1) / 7 * 360;
        }
        else if (range_chart.granularity() == "month") {
          radial_scale.domain([0,31]);
          rotation += (task.target - 1) / 31 * 360;
        }
        else if (range_chart.granularity() == "year") {
          radial_scale.domain([0,366]);
          rotation += (task.target - 1) / 366 * 360;
        }
        
        x_pos = (chart_dim / 2 + 15) * Math.sin(radial_scale(task.target - 1));
        y_pos = -1 * (chart_dim / 2 + 15) * Math.cos(radial_scale(task.target - 1));
        
        return "translate(" + x_pos + "," + y_pos + ")rotate(" + rotation + ")";
      }          
    });    

    var barrier = chart_g.append('rect')
    .attr('id','barrier')
    .style('opacity',0)
    .attr('width',svg_dim)
    .attr('height',svg_dim)
    .attr('x',-inner_padding)
    .attr('y',-inner_padding);    

    task.target_start = d3.select('#data_element_' + target_date.format('YYYY-MM-DD')).data()[0].start;
    task.target_start_baseline = d3.select('#data_element_' + target_date.format('YYYY-MM-DD')).data()[0].start_baseline;
    task.target_end = d3.select('#data_element_' + target_date.format('YYYY-MM-DD')).data()[0].end;
    task.target_end_baseline = d3.select('#data_element_' + target_date.format('YYYY-MM-DD')).data()[0].end_baseline;
      
  } 
    
  function loadData () {     

    checkExist = setInterval(function() {
      if (all_data != undefined) {
        selected_week = (task.granularity == 'week') ? task.index : null;
        selected_month = (task.granularity == 'month') ? task.index : null;
        selected_year = task.year;
        chart_g.datum(all_data);
        draw();       
        
        hideAddressBar();   

        d3.select('#task_div')
        .style('visibility','visible');

        clearInterval(checkExist);
      }
    }, 100); // check every 100ms

    range_chart = rangeChart()
    .granularity(task.granularity)
    .representation(task.representation);
  
    main_svg = d3.select('#main_svg').remove();
  
    main_svg = d3.select('#task_div').append('svg')
    .attr('id','main_svg')
    .attr('class','blurme');  
  
    defs = d3.select('#main_svg').append('defs');
  
    chart_g = main_svg.append('g')
    .attr('id','chart_g');
    
    document.getElementById('task_div').focus();
  }
    
  /** INIT **/
  
  d3.select('body').append('div')
  .attr('id','task_div')
  .attr('tabindex',0);    

  var instruction_div = d3.select('#task_div').append('div')
  .attr('class','toolbar')
  .attr('id','instruction_div');

  var target_date = "";
  var jan1 = task.year.toString() + '-01-01';

  switch (task.granularity) {

    case 'week':
    target_date = moment(jan1).startOf('week').add(task.index - 1,'weeks').add(task.target - 1,'days');
    break;

    case 'month':
    target_date = moment(jan1).add(task.index,'months').add(task.target - 1,'days');
    if (target_date.weekday() == 0 || target_date.date() == 1) {
      if (task.target < 24) {
        task.target = task.target + 1;
        target_date = target_date.add(1,'days');
      }
      else {
        task.target = task.target - 1;
        target_date = target_date.subtract(1,'days');
      }
      if (target_date.date() > 27) {
        task.target = task.target - 7;
        target_date = target_date.subtract(7,'days');
      }
    }
    break;

    case 'year':
    target_date = moment(jan1).add(task.target - 1,'days');
    if (target_date.date() == 1) {
      task.target = task.target + 1;
      target_date = target_date.add(1,'days');
    }
    break;

    default:
    target_date = "";
  }

  var instruction_text = instruction_div.append('span')
  .attr('id','instruction_text')
  .style('visibility','hidden')
  .html((task.training ? '<span class="instruction_emphasis">PRACTICE TRIAL</span>:<br>' : '') + 'Is the ' + (task.target_attribute == 'start' ? (task.datatype == 'temperature' ? '<span class="instruction_emphasis_low">Daily Low</span>' : '<span class="instruction_emphasis_low">Bedtime</span>') : (task.datatype == 'temperature' ? '<span class="instruction_emphasis_high">Daily High</span>' : '<span class="instruction_emphasis_high">Waking Time</span>')) + '<span class="instruction_emphasis">' + (task.datatype == 'temperature' ? ' Cooler' : ' Earlier') + '</span>,  <span class="instruction_emphasis">' + (task.datatype == 'temperature' ? 'Warmer' : 'Later') + '</span>, or <span class="instruction_emphasis">Equal</span> to the <span class="instruction_emphasis" style="color:white; background-color: #555;">' + (task.datatype == 'temperature' ? 'Expected ' : 'Recommended ') + (task.target_attribute == 'start' ? (task.datatype == 'temperature' ? 'Daily Low' : 'Bedtime') : (task.datatype == 'temperature' ? 'Daily High' : 'Waking Time')) + '</span> on <span class="instruction_emphasis" style="color:aquamarine;">' + target_date.format('ddd, MMM Do') + '</span>?');
  
  d3.select('#task_div').append('input')
  .attr('class', 'menu_btn_disabled')
  .attr('id','submit_btn_a')
  .style('visibility','hidden')
  .attr('disabled',true)
  .attr('type','button')
  .attr('value', (task.datatype == 'temperature') ? 'COOLER' : 'EARLIER')   
  .attr('title', (task.datatype == 'temperature') ? 'COOLER' : 'EARLIER')
  .on('touchstart', function() {  
    task.response_value = 'lower';
    endTask();
  });

  d3.select('#task_div').append('input')
  .attr('class', 'menu_btn_disabled')
  .attr('id','submit_btn_b')
  .style('visibility','hidden')
  .attr('disabled',true)
  .attr('type','button') 
  .attr('title', (task.datatype == 'temperature') ? 'WARMER' : 'LATER')
  .attr('value', (task.datatype == 'temperature') ? 'WARMER' : 'LATER')
  .on('touchstart', function() {  
    task.response_value = 'higher';      
    endTask();
  });

  d3.select('#task_div').append('input')
  .attr('class', 'menu_btn_disabled')
  .attr('id','submit_btn_c')
  .style('visibility','hidden')
  .attr('disabled',true)
  .attr('type','button') 
  .attr('title', 'EQUAL')
  .attr('value', 'EQUAL')
  .on('touchstart', function() {  
    task.response_value = 'equal';      
    endTask();
  });

  loadData();    

  task.load_time = new Date().valueOf();
  task.reading_interruptions = 0;
  task.reading_interruption_time = 0;

  function startTask () {

    d3.select('#instruction_text').style('visibility','visible');
    d3.select('#submit_btn_a').style('visibility','visible');
    d3.select('#submit_btn_b').style('visibility','visible');
    d3.select('#submit_btn_c').style('visibility','visible');    

    task.task_name = "CompareWithin";
    task.user_id = userID;

    task.interruptions = 0;
    task.interruption_time = 0;
    task.start_time = new Date().valueOf();
    
    if (resumptions.length > 0 ) {      
      var i = resumptions.length - 1;
      while (resumptions[i].resumption_time > task.load_time && i >= 0) {
        task.reading_interruptions++;
        task.reading_interruption_time += resumptions[i].pause_duration;
        i--;
      }
    }

    task.reading_time = task.start_time - task.load_time - task.reading_interruption_time;
    
    d3.select('#start_btn').remove();
    d3.select('#barrier').remove();
    d3.select('#main_svg').attr('class',null);

    d3.select('#submit_btn_a')
    .attr('class', 'menu_btn_enabled')    
    .attr('disabled',null);

    d3.select('#submit_btn_b')
    .attr('class', 'menu_btn_enabled')
    .attr('disabled',null);

    d3.select('#submit_btn_c')
    .attr('class', 'menu_btn_enabled')
    .attr('disabled',null);
  }

  function endTask () {

    if (resumptions.length > 0 ) {
      var i = resumptions.length - 1;
      while (resumptions[i].resumption_time > task.start_time && i >= 0) {
        task.interruptions++;
        task.interruption_time += resumptions[i].pause_duration;
        i--;
      }
    }

    task.end_time = new Date().valueOf();
    task.attempts = attempts;
    task.response_time = task.end_time - task.start_time - task.interruption_time;       
    var quant_scale = range_chart.quant_scale( );
    
    if (task.target_attribute == 'start') {
      if (task.target_start < task.target_start_baseline) {
        if (task.response_value == 'lower') {
          task.quant_error = 0;
          task.quant_distance = 0;
          task.binary_error = false;
        }
        else {
          task.quant_error = task.target_start_baseline - task.target_start;
          task.quant_distance = Math.abs(quant_scale(task.target_start_baseline) - quant_scale(task.target_start));          
          task.binary_error = true;
        }
      } 
      else if  (task.target_start > task.target_start_baseline) {
        if (task.response_value == 'higher') {
          task.quant_error = 0;
          task.quant_distance = 0;
          task.binary_error = false;
        }
        else {
          task.quant_error = task.target_start_baseline - task.target_start;
          task.quant_distance = Math.abs(quant_scale(task.target_start_baseline) - quant_scale(task.target_start));          
          task.binary_error = true;
        }
      }
      else { // task.target_start == task.target_start_baseline
        if (task.response_value == 'equal') {
          task.quant_error = 0;
          task.quant_distance = 0;
          task.binary_error = false;
        }
        else {
          task.quant_error = task.target_start_baseline - task.target_start;
          task.quant_distance = Math.abs(quant_scale(task.target_start_baseline) - quant_scale(task.target_start));          
          task.binary_error = true;
        }
        
      }
      
    }
    else { //task.target_attribute == 'end'
      if (task.target_end < task.target_end_baseline) {
        if (task.response_value == 'lower') {
          task.quant_error = 0;
          task.quant_distance = 0;
          task.binary_error = false;
        }
        else {
          task.quant_error = task.target_end_baseline - task.target_end;
          task.quant_distance = Math.abs(quant_scale(task.target_end_baseline) - quant_scale(task.target_end));          
          task.binary_error = true;
        }
      }
      else if  (task.target_end > task.target_end_baseline) {
        if (task.response_value == 'higher') {
          task.quant_error = 0;
          task.quant_distance = 0;
          task.binary_error = false;
        }
        else {
          task.quant_error = task.target_end_baseline - task.target_end;
          task.quant_distance = Math.abs(quant_scale(task.target_end_baseline) - quant_scale(task.target_end));          
          task.binary_error = true;
        }
      }
      else { // task.target_end == task.target_end_baseline
        if (task.response_value == 'equal') {
          task.quant_error = 0;
          task.quant_distance = 0;
          task.binary_error = false;
        }
        else {
          task.quant_error = task.target_start_baseline - task.target_start;
          task.quant_distance = Math.abs(quant_scale(task.target_start_baseline) - quant_scale(task.target_start));          
          task.binary_error = true;
        }
      }   
      
    } 
    
    task.normalized_quant_distance = task.quant_distance / (task.representation == 'linear' ? chart_dim : chart_dim / 2);

    console.log(task);
    
    // appInsights.trackEvent("CompareWithin", { 
    //   "start_time": task.start_time,
    //   "end_time": task.end_time,
    //   "user_id": task.user_id, 
    //   "task_name": task.task_name, 
    //   "datatype": task.datatype,
    //   "representation": task.representation, 
    //   "granularity": task.granularity,
    //   "index": task.index,
    //   "year": task.year,
    //   "training": task.training,
    //   "target": task.target,
    //   "target_attribute": task.target_attribute,
    //   "response_time": task.response_time,
    //   "response_value": task.response_value,
    //   "quant_error": task.quant_error,
    //   "quant_distance": task.quant_distance,
    //   "normalized_quant_distance": task.normalized_quant_distance,
    //   "binary_error": task.binary_error,
    //   "attempts": task.attempts,
    //   "load_time": task.load_time,
    //   "reading_time":task.reading_time,
    //   "reading_interruptions": task.reading_interruptions,
    //   "reading_interruption_time": task.reading_interruption_time,
    //   "interruptions": task.interruptions,
    //   "interruption_time": task.interruption_time           
    // });

    if (task.training) {

      d3.select('#submit_btn_a')
      .attr('disabled',true)
      .attr('class', 'menu_btn_disabled');

      d3.select('#submit_btn_b')
      .attr('disabled',true)
      .attr('class', 'menu_btn_disabled');

      d3.select('#submit_btn_c')
      .attr('disabled',true)
      .attr('class', 'menu_btn_disabled');

      var barrier = chart_g.append('rect')
      .attr('id','barrier')
      .style('opacity',0)
      .attr('width',svg_dim)
      .attr('height',svg_dim)
      .attr('x',-inner_padding)
      .attr('y',-inner_padding);      

      if (!task.binary_error) {

        d3.select('#main_svg').attr('class','blurme');   
        d3.select('#instruction_text').remove();      
        d3.select('#submit_btn_a').remove();
        d3.select('#submit_btn_b').remove();
        d3.select('#submit_btn_c').remove();  
        
        var correct_feedback_btn = d3.select('#task_div').append('div')
        .attr('class', 'feedback_btn_enabled')
        .attr('id','feedback_btn')
        .style('background','#8bc34a')
        .style('border-color','#fff')
        .on('touchstart', function() { 
          d3.select('#feedback_btn').remove(); 
          var timed_trial_warning = d3.select('#task_div').append('div')
          .attr('class', 'feedback_btn_enabled')
          .attr('id','timed_trial_warning')
          .style('border-color','#fff')
          .on('touchstart', function() {              
            d3.select('#task_div').remove();
            compareWithin(compareWithinTaskList[index+1],index+1); 
          });        
  
          timed_trial_warning.append('span')
          .attr('id','button_text')
          .style('font-weight','400')
          .html('The next trials will be timed. Complete each trial as <span class="instruction_emphasis">quickly</span> as you can. You will not be told if your responses are correct. <br><span class="instruction_emphasis">Tap here to continue</span>.');   
        });        

        correct_feedback_btn.append('span')
        .attr('id','button_text')
        .style('color','#111')
        .style('font-weight','400')
        .html('<span class="correct_incorrect">CORRECT</span><br>Tap here to continue.<br>');  
      
      }
      
      else {

        d3.select('#main_svg').attr('class','blurme');

        var incorrect_feedback_btn =  d3.select('#task_div').append('div')
        .attr('class', 'feedback_btn_enabled')
        .attr('id','feedback_btn')
        .style('background','#ef5350')
        .style('border-color','#fff')
        .on('touchstart', function() {  
          d3.select('#feedback_btn').remove();   
          d3.select('#barrier').remove();
          attempts++;
          d3.select('#main_svg').attr('class',null);
          d3.select('.focus').style('display','none');

          d3.select('#submit_btn_a')
          .attr('disabled',null)
          .attr('class','menu_btn_enabled');

          d3.select('#submit_btn_b')
          .attr('disabled',null)
          .attr('class','menu_btn_enabled');

          d3.select('#submit_btn_c')
          .attr('disabled',null)
          .attr('class','menu_btn_enabled');

          if (attempts > 2) {

            d3.selectAll('.data_element').selectAll('rect')
            .style('opacity',function(d) {
              var rect_opacity;
              switch (task.granularity) {
                
                case 'week':
                  rect_opacity = (d.weekday == task.target) ? 1 : 0.25;
                break;
          
                case 'month':
                  rect_opacity = (d.day == task.target) ? 1 : 0.25;
                break;
          
                case 'year':
                  rect_opacity = (d.day_of_year == task.target) ? 1 : 0.25;
                break;
          
                default:
                  rect_opacity = 1;
                break;        
              }
              
              return rect_opacity;
            });
            
          }
          task.start_time = new Date().valueOf();
        });  

        incorrect_feedback_btn.append('span')
        .attr('id','button_text')
        .style('color','#111')
        .style('font-weight','400')
        .html('<span class="correct_incorrect">INCORRECT</span><br>Tap here to try again.'); 
        
      }
    }
    else {
      d3.select('#task_div').remove();
      if (index+1 == compareWithinTaskList.length) {
        suppress_touch_feedback = false;
        suppress_touch_val_feedback = false;
        compareWithin_complete = true;
        // appInsights.trackEvent("compareWithinComplete", { 
        //   "TimeStamp": new Date().valueOf(),
        //   "Event": "compareWithinComplete",
        //   "user_id": userID
        // });
        loadMenu();
        hideAddressBar();   
      }
      else {        
        if (index == 4 || index == 14) { //gotcha
          gotcha('compareWithin',index);
        } 
        else { //next task
          compareWithin(compareWithinTaskList[index+1],index+1); 
        }
      }
    }
  }

  if (index == 0) {
    var task_instruction_screen = d3.select('#task_div').append('div')
    .attr('id','task_instruction_screen');        
    
    getDims();

    task_instruction_screen.append('span')
    .attr('class','task_instruction_span')
    .html('<span class="instruction_emphasis">Comparing Daily Values Task</span>:<br>Is the <span class="instruction_emphasis_low">' + (task.datatype == 'temperature' ? 'Daily Low' : 'Bed') + '</span> / ' + '<span class="instruction_emphasis_high">' + (task.datatype == 'temperature' ? 'High</span> ' : 'Waking</span> Time ') + '<span class="instruction_emphasis">' + (task.datatype == 'temperature' ? 'Cooler' : 'Earlier') + '</span>' + ', <span class="instruction_emphasis">' + (task.datatype == 'temperature' ? 'Warmer' : 'Later') + '</span>, or <span class="instruction_emphasis">Equal</span> to the <span class="instruction_emphasis" style="color:white; background-color: #555;">' + (task.datatype == 'temperature' ? 'Expected ' : 'Recommended ') + (task.datatype == 'temperature' ? 'Value' : 'Time') + '</span> on the <span class="instruction_emphasis" style="color:aquamarine;">specified date</span> <span class="instruction_emphasis" style="color:aquamarine;">(▼)</span>?');
    
    var task_instruction_svg = task_instruction_screen.append('svg')
    .attr('id','task_instruction_svg')
    .style('height', (0.95 * svg_dim) + 'px')
    .style('width', (0.95 * svg_dim) +'px');

    task_instruction_svg.append('svg:image')
    .attr('class','instruction_svg')
    .attr("xlink:href", task.datatype == 'temperature' ? "assets/compare_temp.svg" : "assets/compare_sleep.svg")
    .attr("width", (0.90 * (0.95 * svg_dim)))
    .attr("height", (0.90 * (0.95 * svg_dim)))
    .attr("x", (0.05 * (0.95 * svg_dim)))
    .attr("y", (0.05 * (0.95 * svg_dim)));

    svgExist = setInterval(function() {  
      if (i == 10) {            
        clearInterval(svgExist);        
      }
      else {
        i++;

        d3.select('.instruction_svg')
        .attr("xlink:href", task.datatype == 'temperature' ? "assets/compare_temp.svg" : "assets/compare_sleep.svg");
      }
    }, 100); // check every 100ms

    var task_instruction_dismiss_btn = task_instruction_screen.append('div')
    .attr('class', 'task_instruction_dismiss_btn')
    .on('touchstart', function() {      
      d3.select('#task_instruction_screen').remove();
      var trial_start_btn = d3.select('#task_div').append('div')
      .attr('class', 'feedback_btn_enabled')
      .attr('id','start_btn')
      .on('touchstart', function() {      
        startTask();
      });
      trial_start_btn.append('span')
      .attr('id','button_text')
      .html('Tap to Start ' + (task.training ? '<span class="instruction_emphasis">PRACTICE</span> Trial' : ('Trial <span class="instruction_emphasis">' + (index + 1) + '</span> of <span class="instruction_emphasis">' + compareWithinTaskList.length + '</span>')) + '<br><span style="font-size:0.7em; font-weight:400;">Is the ' + (task.target_attribute == 'start' ? (task.datatype == 'temperature' ? '<span class="instruction_emphasis_low">Daily Low</span>' : '<span class="instruction_emphasis_low">Bed</span>') : (task.datatype == 'temperature' ? '<span class="instruction_emphasis_high">Daily High</span>' : '<span class="instruction_emphasis_high">Waking </span>Time')) + '<span class="instruction_emphasis">' + (task.datatype == 'temperature' ? ' Cooler' : ' Earlier') + '</span>,  <span class="instruction_emphasis">' + (task.datatype == 'temperature' ? 'Warmer' : 'Later') + '</span>, or <span class="instruction_emphasis">Equal</span> to the <span class="instruction_emphasis" style="color:white; background-color: #555;">' + (task.datatype == 'temperature' ? 'Expected ' : 'Recommended ') +  (task.target_attribute == 'start' ? (task.datatype == 'temperature' ? 'Daily Low' : 'Bedtime') : (task.datatype == 'temperature' ? 'Daily High' : 'Waking Time')) + '</span> on <span class="instruction_emphasis" style="color:aquamarine;">' + target_date.format('ddd, MMM Do') + '</span>?');
    });

    task_instruction_dismiss_btn.append('span')
    .attr('class','task_instruction_span')
    .style('color','gold')
    .style('margin-top','8px')
    .html('Tap here to begin this task.');
      
  }
  else {
    var trial_start_btn = d3.select('#task_div').append('div')
    .attr('class', 'feedback_btn_enabled')
    .attr('id','start_btn')
    .on('touchstart', function() {      
      startTask();
    });

    trial_start_btn.append('span')
    .attr('id','button_text')
    .html('Tap to Start ' + (task.training ? '<span class="instruction_emphasis">PRACTICE</span> Trial' : ('Trial <span class="instruction_emphasis">' + (index + 1) + '</span> of <span class="instruction_emphasis">' + compareWithinTaskList.length + '</span>')) + '<br><span style="font-size:0.7em; font-weight:400;">Is the ' + (task.target_attribute == 'start' ? (task.datatype == 'temperature' ? '<span class="instruction_emphasis_low">Daily Low</span>' : '<span class="instruction_emphasis_low">Bedtime</span>') : (task.datatype == 'temperature' ? '<span class="instruction_emphasis_high">Daily High</span>' : '<span class="instruction_emphasis_high">Waking Time</span>')) + '<span class="instruction_emphasis">' + (task.datatype == 'temperature' ? ' Cooler' : ' Earlier') + '</span>,  <span class="instruction_emphasis">' + (task.datatype == 'temperature' ? 'Warmer' : 'Later') + '</span>, or <span class="instruction_emphasis">Equal</span> to the <span class="instruction_emphasis" style="color:white; background-color: #555;">' + (task.datatype == 'temperature' ? 'Expected ' : 'Recommended ') + (task.target_attribute == 'start' ? (task.datatype == 'temperature' ? 'Daily Low' : 'Bedtime') : (task.datatype == 'temperature' ? 'Daily High' : 'Waking Time')) + '</span> on <span class="instruction_emphasis" style="color:aquamarine;">' + target_date.format('ddd, MMM Do') + '</span>?');
  }
}

module.exports = compareWithin;
