var d3 = require("d3");
var moment = require("moment");
var globals = require("../globals");
var rangeChart = require("../rangeChart");
var temperatureData = require("../data/temperatureData");
var sleepData = require("../data/sleepData");

function readValues (task,index) {  

  suppress_touch_feedback = true;
  suppress_touch_val_feedback = false;
 
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
  .html((task.training ? '<span class="instruction_emphasis">PRACTICE TRIAL</span>:<br>' : '') + 'Contain the ' + (task.target_attribute == 'start' ? '<span class="instruction_emphasis_low">' : '<span class="instruction_emphasis_high">') + task.target_value_label + '</span> for<br><span class="instruction_emphasis" style="color:aquamarine;">' + target_date.format('dddd, MMMM Do') + '</span>.');
       
  loadData();  
  
  task.load_time = new Date().valueOf();
  task.reading_interruptions = 0;
  task.reading_interruption_time = 0;

  d3.select('#task_div').append('input')
  .attr('class', 'menu_btn_disabled')
  .attr('id','submit_btn')
  .attr('disabled',true)
  .attr('type','button')
  .attr('value','')
  .attr('title', '')
  .on('touchstart', function() {  
    
  });

  function startTask () {

    d3.select('#instruction_text').style('visibility','visible');

    task.task_name = "ReadValue";
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

    d3.select('#submit_btn')
    .attr('disabled',true)
    .attr('value','DONE')
    .attr('title', 'DONE')
    .on('touchstart', function() {  
      if (d3.select(this).attr('class') == 'menu_btn_enabled') {
        endTask();
      }
    });
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
    task.target_value = (task.target_attribute == 'start') ? d3.select('#data_element_' + target_date.format('YYYY-MM-DD')).data()[0].start : d3.select('#data_element_' + target_date.format('YYYY-MM-DD')).data()[0].end;
    task.response_value = touch_value;
    task.quant_error = task.response_value - task.target_value;
    var quant_scale = range_chart.quant_scale( );
    task.quant_distance = Math.abs(quant_scale(task.response_value) - quant_scale(task.target_value));
    task.normalized_quant_distance = task.quant_distance / (task.representation == 'linear' ? chart_dim : chart_dim / 2);
    task.binary_error = task.quant_distance > (chart_dim / (task.representation == 'linear' ? 20 : 40));

    console.log(task);
    
    // appInsights.trackEvent("ReadValue", { 
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
    //   "target_value": task.target_value,
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

      var barrier = chart_g.append('rect')
      .attr('id','barrier')
      .style('opacity',0)
      .attr('width',svg_dim)
      .attr('height',svg_dim)
      .attr('x',-inner_padding)
      .attr('y',-inner_padding);

      d3.select('#submit_btn')
      .attr('disabled',true)
      .attr('class', 'menu_btn_disabled');

      if (!task.binary_error) {

        d3.select('#main_svg').attr('class','blurme');   
        d3.select('#instruction_text').remove();        
        d3.select('#submit_btn').remove();
        
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
            readValues(readValueTaskList[index+1],index+1); 
          });        
  
          timed_trial_warning.append('span')
          .attr('id','button_text')
          .style('font-weight','400')
          .html('The next trials will be timed. Complete each trial as <span class="instruction_emphasis">quickly</span> as you can while <span class="instruction_emphasis">ensuring that the specified value is contained between the dashed yellow lines</span>. You will not be told if your responses are correct. <br><span class="instruction_emphasis">Tap here to continue</span>.');   
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
          if (attempts > 2) {

            var quant_scale = range_chart.quant_scale( );

            if (task.representation == 'linear') {

              d3.select('#chart_g').append('line')
              .attr('x1',0 - inner_padding)
              .attr('x2',chart_dim + inner_padding)
              .attr('y1', quant_scale (task.target_value))
              .attr('y2', quant_scale (task.target_value))
              .attr('class','hint')
              .style('stroke-width','2px')
              .attr('stroke-dasharray',"0.5em");              
            }
            else {
              d3.select('#chart_g').append('circle')
              .attr('class','hint')
              .attr("cx",chart_dim / 2)
              .attr("cy",chart_dim / 2)
              .attr('r', quant_scale (task.target_value))
              .style('fill','none')
              .attr('stroke-dasharray',"0.5em")
              .style('stroke-width','2px');
            }
          }
          task.start_time = new Date().valueOf();
        });  

        incorrect_feedback_btn.append('span')
        .attr('id','button_text')
        .style('color','#111')
        .style('font-weight','400')
        .html(function() {
          return (attempts > 1) ? '<span class="correct_incorrect">INCORRECT</span><br>Tap here to see a hint.' : '<span class="correct_incorrect">INCORRECT</span><br>Tap here to try again.';
        }); 
        
      }
    }
    else {
      d3.select('#task_div').remove();
      if (index+1 == readValueTaskList.length) {
        suppress_touch_feedback = false;
        readValue_complete = true;
        // appInsights.trackEvent("readValuesComplete", { 
        //   "TimeStamp": new Date().valueOf(),
        //   "Event": "readValuesComplete",
        //   "user_id": userID
        // });
        loadMenu();
        hideAddressBar();   
      }
      else {        
        if (index == 4 || index == 14) { //gotcha
          gotcha('readValues',index);
        }        
        else { //next task
          readValues(readValueTaskList[index+1],index+1); 
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
    .html('<span class="instruction_emphasis">Reading Values Task</span>:<br>Contain the <span class="instruction_emphasis_low">' + (task.datatype == 'temperature' ? 'Daily Low Temperature' : 'Bedtime') + '</span> or <span class="instruction_emphasis_high">' + (task.datatype == 'temperature' ? 'Daily High Temperature' : 'Waking Time') + '</span> for the <span class="instruction_emphasis" style="color:aquamarine;">specified date</span> (<span class="instruction_emphasis" style="color:aquamarine;">marked with a ▼</span>) between the <span class="instruction_emphasis">two dashed yellow lines</span>:');

    var task_instruction_svg = task_instruction_screen.append('svg')
    .attr('id','task_instruction_svg')
    .style('height', (0.95 * svg_dim) + 'px')
    .style('width', (0.95 * svg_dim) +'px');

    task_instruction_svg.append('svg:image')
    .attr('class','instruction_svg')
    .attr("xlink:href", task.datatype == 'temperature' ? "assets/read_temp.svg" : "assets/read_sleep.svg")
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
        .attr("xlink:href", task.datatype == 'temperature' ? "assets/read_temp.svg" : "assets/read_sleep.svg");
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
      .html('Tap to Start ' + (task.training ? '<span class="instruction_emphasis">PRACTICE</span> Trial' : ('Trial <span class="instruction_emphasis">' + (index + 1) + '</span> of <span class="instruction_emphasis">' + readValueTaskList.length + '</span>')) + '<br><span style="font-size:0.7em; font-weight:400;">' + 'Contain the ' + (task.target_attribute == 'start' ? '<span class="instruction_emphasis_low">' : '<span class="instruction_emphasis_high">') + task.target_value_label + '</span> for<br><span class="instruction_emphasis" style="color:aquamarine;">' + target_date.format('dddd, MMMM Do') + '</span>.');
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
    .html('Tap to Start ' + (task.training ? '<span class="instruction_emphasis">PRACTICE</span> Trial' : ('Trial <span class="instruction_emphasis">' + (index + 1) + '</span> of <span class="instruction_emphasis">' + readValueTaskList.length + '</span>')) + '<br><span style="font-size:0.7em; font-weight:400;">' + 'Contain the ' + (task.target_attribute == 'start' ? '<span class="instruction_emphasis_low">' : '<span class="instruction_emphasis_high">') + task.target_value_label + '</span> for<br><span class="instruction_emphasis" style="color:aquamarine;">' + target_date.format('dddd, MMMM Do') + '</span>.');
  }
}

module.exports = readValues;
