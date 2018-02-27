var d3 = require("d3");
var moment = require("moment");
var globals = require("./globals");
var rangeChart = require("./rangeChart");
var temperatureData = require("./data/temperatureData");
var sleepData = require("./data/sleepData");

function introduction (scene) {

  data_unit = locateDateTaskList[0].datatype;
  suppress_touch_feedback = true;
  suppress_touch_val_feedback = true;
  
  var range_chart = rangeChart(),
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
    
    if (scene < 10) {
      d3.selectAll(".baseline_value").style('opacity', 0);
      d3.selectAll(".baseline_start").style('opacity', 0);
      d3.selectAll(".baseline_end").style('opacity', 0);
    }
    
    if (scene == 9) {
      d3.selectAll(".element_date").style('opacity', function (d,i) {
        return d.weekday == 4 ? 1 : 0.1;
      });

      d3.selectAll('.observed_value').style('opacity', function (d,i) {
          return d.weekday == 4 ? 1 : 0.1;
      });
    }
      
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

        d3.select('#introduction_div')
        .style('visibility','visible');       

        clearInterval(checkExist);
      }
    }, 100); // check every 100ms
  
    main_svg = d3.select('#main_svg').remove();
  
    main_svg = d3.select('#introduction_div').append('svg')
    .attr('id','main_svg');  
  
    defs = d3.select('#main_svg').append('defs');
  
    chart_g = main_svg.append('g')
    .attr('id','chart_g'); 
        
    document.getElementById('introduction_div').focus();
  }
  
  /** INIT **/
  
  d3.select('body').append('div')
  .attr('id','introduction_div')
  .attr('tabindex',0);  

  var instruction_div = d3.select('#introduction_div').append('div')
  .attr('class','toolbar')
  .attr('id','instruction_div');

  var instruction_text = instruction_div.append('span')
  .attr('id','instruction_text');  

  switch (scene) {

    case 0:

      instruction_text.html('Please review the following protocols before beginning the study.');    
      d3.select('#introduction_div')
      .style('visibility','visible');

      break;  

    case 1:

      instruction_text.html('1. For the duration of this study, hold your phone in <span class="instruction_emphasis">portrait mode</span>.');    
      d3.select('#introduction_div')
      .style('visibility','visible'); 

      getDims();

      main_svg = d3.select('#introduction_div').append('svg')
      .attr('id','main_svg')
      .style('height',svg_dim + 'px')
      .style('width',svg_dim + 'px');

      main_svg.append('svg:image')
      .attr('class','instruction_svg')
      .attr("xlink:href", "assets/portrait.svg")
      .attr("width", chart_dim)
      .attr("height", chart_dim)
      .attr("x", inner_padding)
      .attr("y", inner_padding);
          
      document.getElementById('introduction_div').focus();

      break;

    case 2:
  
      instruction_text.html('2. Hold your phone with your non-dominant hand or lay it flat on a surface; use the <span class="instruction_emphasis">index finger on your dominant hand</span> to touch your phone.');    
      d3.select('#introduction_div')
      .style('visibility','visible'); 

      getDims();

      main_svg = d3.select('#introduction_div').append('svg')
      .attr('id','main_svg')
      .style('height',svg_dim + 'px')
      .style('width',svg_dim + 'px');

      main_svg.append('svg:image')
      .attr('class','instruction_svg')
      .attr("xlink:href", "assets/holdingphone.svg")
      .attr("width", chart_dim)
      .attr("height", chart_dim)
      .attr("x", inner_padding)
      .attr("y", inner_padding);
          
      document.getElementById('introduction_div').focus();

      break;

    case 3:
    
      instruction_text.html('3. Make sure that your phone\'s <span class="instruction_emphasis">brightness</span> level is set to <span class="instruction_emphasis">maximum</span>.');    
      d3.select('#introduction_div')
      .style('visibility','visible'); 

      getDims();

      main_svg = d3.select('#introduction_div').append('svg')
      .attr('id','main_svg')
      .style('height',svg_dim + 'px')
      .style('width',svg_dim + 'px');

      main_svg.append('svg:image')
      .attr('class','instruction_svg')
      .attr("xlink:href", "assets/brightness.svg")
      .attr("width", chart_dim)
      .attr("height", chart_dim)
      .attr("x", inner_padding)
      .attr("y", inner_padding);
          
      document.getElementById('introduction_div').focus();

      break;
    
    case 4:
    
      instruction_text.html('4. Ensure a stable <span class="instruction_emphasis">WiFi</span> network and sufficient <span class="instruction_emphasis">battery power</span> for approximately <span class="instruction_emphasis">30 minutes</span>.');    
      d3.select('#introduction_div')
      .style('visibility','visible'); 

      getDims();

      main_svg = d3.select('#introduction_div').append('svg')
      .attr('id','main_svg')
      .style('height',svg_dim + 'px')
      .style('width',svg_dim + 'px');

      main_svg.append('svg:image')
      .attr('class','instruction_svg')
      .attr("xlink:href", "assets/wifi.svg")
      .attr("width", chart_dim)
      .attr("height", chart_dim)
      .attr("x", inner_padding)
      .attr("y", inner_padding);
          
      document.getElementById('introduction_div').focus();

      break; 
      
    case 5:
    
      instruction_text.html('5. <span class="instruction_emphasis">DO NOT</span> tap your browser\'s back or refresh buttons at any time.');    
      d3.select('#introduction_div')
      .style('visibility','visible'); 

      getDims();

      main_svg = d3.select('#introduction_div').append('svg')
      .attr('id','main_svg')
      .style('height',svg_dim + 'px')
      .style('width',svg_dim + 'px');

      main_svg.append('svg:image')
      .attr('class','instruction_svg')
      .attr("xlink:href", "assets/nonav.svg")
      .attr("width", chart_dim)
      .attr("height", chart_dim)
      .attr("x", inner_padding)
      .attr("y", inner_padding);
          
      document.getElementById('introduction_div').focus();

      break; 

    case 6:
      
      instruction_text.html('<span class="instruction_emphasis">RANGE CHARTS: A TUTORIAL</span><br>Now let\'s consider <span class="instruction_emphasis">quantitative ranges</span> and how they are visually represented.');    
      d3.select('#introduction_div')
      .style('visibility','visible');

      break;

    case 7:
    
      instruction_text.html('A <span class="instruction_emphasis">quantitative range</span> is a difference between a <span class="instruction_emphasis_low">low</span> and a <span class="instruction_emphasis_high">high</span> value. In this study, the ranges are ' + (data_unit == 'temperature' ? "a city's <span class='instruction_emphasis_low'>daily low</span> and <span class='instruction_emphasis_high'>daily high</span> temperatures" : "a person's daily <span class='instruction_emphasis_low'>bedtimes</span> and <span class='instruction_emphasis_high'>waking times</span>") + '</span>.');    
      d3.select('#introduction_div')
      .style('visibility','visible'); 

      getDims();

      main_svg = d3.select('#introduction_div').append('svg')
      .attr('id','main_svg')
      .style('height',svg_dim + 'px')
      .style('width',svg_dim + 'px');

      main_svg.append('svg:image')
      .attr('class','instruction_svg')
      .attr("xlink:href", (data_unit == 'temperature' ? "assets/cold.svg" : "assets/sleep.svg"))
      .attr("width", svg_dim / 2)
      .attr("height", svg_dim / 2)
      .attr("x", 0)
      .attr("y", svg_dim / 4);

      main_svg.append('svg:image')
      .attr('class','instruction_svg')
      .attr("xlink:href", (data_unit == 'temperature' ? "assets/hot.svg" : "assets/sunrise.svg"))
      .attr("width", svg_dim / 2)
      .attr("height", svg_dim / 2)
      .attr("x", svg_dim / 2)
      .attr("y", svg_dim / 4);
          
      document.getElementById('introduction_div').focus();

      break;          

    case 8: 

      all_data = data_unit == 'temperature' ? temperatureData : sleepData;     
      instruction_text.html('This chart allows you to compare ' + (data_unit == 'temperature' ? "daily <span class='instruction_emphasis_low'>low</span> and <span class='instruction_emphasis_high'>high</span> temperatures" : "daily <span class='instruction_emphasis_low'>bedtimes</span> and <span class='instruction_emphasis_high'>waking times</span>") + ' over the course of one week.');    
      
      range_chart.granularity("week"); 
      loadData();  

      break;

    case 9: 
      
      all_data = data_unit == 'temperature' ? temperatureData : sleepData;     
      instruction_text.html((data_unit == 'temperature' ? "<span class='instruction_emphasis_low'>Colder</span> temperatures are closer to the <span class='instruction_emphasis_low'>bottom</span> and are more <span class='instruction_emphasis_low'>blue</span>, while <span class='instruction_emphasis_high'>warmer</span> temperatures are closer to the <span class='instruction_emphasis_high'>top</span> and are more <span class='instruction_emphasis_high'>red</span>." : "<span class='instruction_emphasis_low'>Earlier</span> bedtimes are closer to the <span class='instruction_emphasis_low'>top</span> and are more <span class='instruction_emphasis_low'>blue</span>, while <span class='instruction_emphasis_high'>later</span> waking times are closer to the <span class='instruction_emphasis_high'>bottom</span> and are more <span class='instruction_emphasis_high'>red</span>."));    
      
      range_chart.granularity("week"); 
      loadData();  

      main_svg.append('svg:image')
      .attr('class','instruction_svg')
      .attr("xlink:href", (data_unit == 'temperature' ? "assets/temperature_orientation.svg" : "assets/sleep_orientation.svg"))
      .attr("width", chart_dim)
      .attr("height", chart_dim)
      .attr("x", inner_padding)
      .attr("y", inner_padding);
          
      break;

    case 10: 
      
      all_data = data_unit == 'temperature' ? temperatureData : sleepData;     
      instruction_text.html('These ranges can also be <span class="instruction_emphasis" style="background-color: #555; padding:2px;">superimposed over</span> ' + (data_unit == 'temperature' ? 'expected temperature ranges for those days' : 'recommended sleeping times') + ', like this:');    
      
      range_chart.granularity("week"); 
      loadData();          

      break;

    case 11: 
      
      all_data = data_unit == 'temperature' ? temperatureData : sleepData;     
      instruction_text.html('These ranges can also be drawn <span class="instruction_emphasis">radially</span>. ' + (data_unit == 'temperature' ? "<span class='instruction_emphasis_low'>Lower</span> temperatures are closer to the <span class='instruction_emphasis_low'>center</span>, while <span class='instruction_emphasis_high'>higher</span> temperatures are closer to the <span class='instruction_emphasis_high'>periphery</span>." : "<span class='instruction_emphasis_low'>Earlier</span> times are closer to the <span class='instruction_emphasis_low'>center</span>, while <span class='instruction_emphasis_high'>later</span> times are closer to the <span class='instruction_emphasis_high'>periphery</span>."));    
      
      range_chart.granularity("week"); 
      range_chart.representation("radial");
      loadData();

      break;

    case 12: 
        
      all_data = data_unit == 'temperature' ? temperatureData : sleepData;     
      instruction_text.html('In this study, you will be asked to compare ranges at <span class="instruction_emphasis">different spans of time</span>, such as over the course of an entire month.');    
     
      first_date = first_date.endOf('week').add(1,'weeks');
      range_chart.granularity("month");
      first_date = first_date.startOf('month');
      loadData();

      break;

      case 13: 
      
        all_data = data_unit == 'temperature' ? temperatureData : sleepData;     
        instruction_text.html('Or over the course of an entire year; note that you won\'t be able to zoom in on the chart during this study.');    
      
        first_date = first_date.endOf('week').add(1,'weeks');
        range_chart.granularity("year");
        first_date = first_date.startOf('year');
        loadData();

        break;

      case 14: 
      
        all_data = data_unit == 'temperature' ? temperatureData : sleepData;     
        instruction_text.html('Here is the same year of ranges, <span class="instruction_emphasis">drawn radially</span>.');    
       
        first_date = first_date.endOf('week').add(1,'weeks');
        range_chart.granularity("year");
        first_date = first_date.startOf('year');
        range_chart.representation("radial");
        loadData();

        break;

      case 15: 
      
        all_data = data_unit == 'temperature' ? temperatureData : sleepData;     
        instruction_text.html('While this chart shows a month of ranges, <span class="instruction_emphasis">drawn radially</span>.');    
        
        first_date = first_date.endOf('week').add(1,'weeks');
        range_chart.granularity("month");
        first_date = first_date.startOf('month');
        range_chart.representation("radial");
        loadData();

        break;

      case 16:

        d3.select('#instruction_div').remove();
        
        var intro_content_div = d3.select('#introduction_div')
        .append('div')
        .attr('class','toolbar')
        .style('width','100%')
        .style('height',(window.innerHeight - 50) + 'px')
        .attr('id','intro_content_div');        

        intro_content_div.append('span')
        .attr('class','consent_text')
        .html('<span style="text-align:left; font-size:0.9em;"><p>You are now <span class="instruction_emphasis">ready to begin</span> the study, where you will perform several tasks using range charts. </p> ' + 
        '<p>The remainder of the study will proceed as follows:</p>' + 
        '<ol>' +
        '<li> <span class="instruction_emphasis">5 tasks:</span>' + 
        '<ul>' +
        '<li>Take a short break between each task if you need one.' +
        '<li>Each task contains <span class="instruction_emphasis">up to 6 practice trials</span> and <span class="instruction_emphasis">up to 26 timed trials</span>.' +
        '<li>The <span class="instruction_emphasis">practice trials</span> are spread throughout each task.' +
        '<li>Each trial is expected to take a few seconds to complete.' + 
        '<li>The trial instruction will always be shown above the chart.' +
        '</ul><li> A <span class="instruction_emphasis">survey</span> containing <span class="instruction_emphasis">9</span> questions.' +
       
        '</ol></span>'
        );    

        d3.select('#introduction_div')
        .style('visibility','visible');        
  
        break;
    
    default: // return to main menu

      d3.select('#introduction_div').remove();
      if (document.getElementById('introduction_div') != undefined) {      
        document.getElementById('introduction_div').remove(); 
      }
      // appInsights.trackEvent("IntroComplete", { 
      //   "TimeStamp": new Date().valueOf(),
      //   "Event": "IntroComplete",
      //   "user_id": userID
      // });

      introduction_complete = true;
      suppress_touch_feedback = false;
      suppress_touch_val_feedback = false;
      loadMenu();
      hideAddressBar();   

      break;
  }
  
  d3.select('#introduction_div').append('input')
  .attr('class', 'menu_btn_enabled')
  .attr('id','submit_btn')
  .attr('type','button')
  .attr('value', scene == 16 ? 'BEGIN' : 'NEXT')
  .attr('title', scene == 16 ? 'BEGIN' : 'NEXT')
  .on('touchstart', function() {    
    
    d3.select('#introduction_div').remove();
    if (document.getElementById('introduction_div') != undefined) {      
      document.getElementById('introduction_div').remove(); 
    }

    // appInsights.trackEvent("Intro", { 
    //   "TimeStamp": new Date().valueOf(),
    //   "user_id": userID,
    //   "Event": "Intro",
    //   "Scene": scene + 1
    // });
    introduction(scene + 1);
  });
 
}

module.exports = introduction;
