var d3 = require("d3");
var moment = require("moment");
var globals = require("../globals");
var rangeChart = require("../rangeChart");
var temperatureData = require("../data/temperatureData");
var sleepData = require("../data/sleepData");

function compareBetween (task,index) {  

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

    d3.select('.overlay').on('touchstart', function(){
      d3.selectAll('.specified_date_region').style('stroke-width','2px');
      task.response_value = undefined;
      d3.select('#submit_btn_done')
      .attr('disabled',true)
      .attr('class', 'menu_btn_disabled')
      .style('color','gold')
      .style('background','#444');
      d3.selectAll('.data_element').selectAll('rect').style('opacity',1);
    });

    var target_width = range_chart.granularity() == 'year' ? (366 / 31) : range_chart.granularity() == 'month' ? (31 / 3) : 7;
    
    if (range_chart.representation() == 'linear') {

      d3.select('#chart_g').append('rect')
      .attr('class','specified_date_region')
      .attr('id','target_1')
      .style('fill','transparent')
      .attr('stroke-dasharray',"0.5em")
      .attr("x",(-1 / 2) * chart_dim  / target_width)      
      .attr("width",(chart_dim  / target_width))
      .attr('y', (0 - inner_padding + 2))
      .attr('height', (chart_dim + 2 * inner_padding - 4))
      .attr("transform",function(){        
        var chron_scale = range_chart.chron_scale( );
        chron_pos = chron_scale( (range_chart.granularity() == 'week' ) ? task.target_1 : (task.target_1 + 1) );                
        return "translate(" + chron_pos + ",0)";              
      })
      .on('touchstart', function(){
        d3.select('#target_1').style('stroke-width','4px');
        d3.select('#target_2').style('stroke-width','2px');        
        task.response_value = 'target_1';
        d3.select('#submit_btn_done')
        .attr('disabled',null)
        .attr('class','menu_btn_enabled')
        .style('color','#111')
        .style('background','aquamarine');
      });

      d3.select('#chart_g').append('rect')
      .attr('class','specified_date_region')
      .attr('id','target_2')
      .style('fill','transparent')
      .style('stroke','#ec407a')
      .attr('stroke-dasharray',"0.5em")
      .attr("x",(-1 / 2) * chart_dim  / target_width)      
      .attr("width",(chart_dim  / target_width))
      .attr('y', (0 - inner_padding + 2))
      .attr('height', (chart_dim + 2 * inner_padding - 4))
      .attr("transform",function(){        
        var chron_scale = range_chart.chron_scale( );
        chron_pos = chron_scale( (range_chart.granularity() == 'week' ) ? task.target_2 : (task.target_2 + 1) );                
        return "translate(" + chron_pos + ",0)";              
      })
      .on('touchstart', function(){ 
        d3.select('#target_1').style('stroke-width','2px');
        d3.select('#target_2').style('stroke-width','4px');        
        task.response_value = 'target_2';
        d3.select('#submit_btn_done')
        .attr('disabled',null)
        .attr('class','menu_btn_enabled')
        .style('color','#111')
        .style('background','#ec407a');
      });

    }
    else {

      d3.select('#chart_g').append('path')
      .attr('class','specified_date_region')
      .attr('id','target_1')
      .style('fill','transparent')
      .attr('stroke-dasharray',"0.5em")
      .attr('d',d3.arc()
        .innerRadius( chart_dim / 14 )
        .outerRadius(chart_dim * 0.5 + inner_padding + 2)
        .startAngle(0 - 0.5 * (Math.PI * 2 / target_width))
        .endAngle(0 + 0.5 * (Math.PI * 2 / target_width))
      )
      .attr("transform",function(){
        if (range_chart.representation() == "linear") {
          var chron_scale = range_chart.chron_scale( );
          chron_pos = chron_scale( (range_chart.granularity() == 'week' ) ? task.target_1 : (task.target_1 + 1) );                
          return "translate(" + chron_pos + ",0)";
        }
        else { //representation == "radial"
          var rotation = 0;
          if (range_chart.granularity() == "week"){
            rotation += (task.target_1) / 7 * 360;
          }
          else if (range_chart.granularity() == "month"){
            rotation += (task.target_1) / 31 * 360;
          }
          else if (range_chart.granularity() == "year"){
            rotation += (task.target_1) / 366 * 360;
          }
          return "translate(" + (chart_dim / 2) + "," + (chart_dim / 2) + ")rotate(" + rotation + ")";
        }          
      })
      .on('touchstart', function(){
        d3.select('#target_1').style('stroke-width','4px');
        d3.select('#target_2').style('stroke-width','2px');        
        task.response_value = 'target_1';
        d3.select('#submit_btn_done')
        .attr('disabled',null)
        .attr('class','menu_btn_enabled')
        .style('color','#111')
        .style('background','aquamarine');
      });

      d3.select('#chart_g').append('path')
      .attr('class','specified_date_region')
      .attr('id','target_2')
      .style('stroke','#ec407a')
      .style('fill','transparent')
      .attr('stroke-dasharray',"0.5em")
      .attr('d',d3.arc()
        .innerRadius( chart_dim / 14 )
        .outerRadius(chart_dim * 0.5 + inner_padding + 2)
        .startAngle(0 - 0.5 * (Math.PI * 2 / target_width))
        .endAngle(0 + 0.5 * (Math.PI * 2 / target_width))
      )
      .attr("transform",function(){
        if (range_chart.representation() == "linear") {
          var chron_scale = range_chart.chron_scale( );
          chron_pos = chron_scale( (range_chart.granularity() == 'week' ) ? task.target_1 : (task.target_1 + 1) );                
          return "translate(" + chron_pos + ",0)";
        }
        else { //representation == "radial"
          var rotation = 0;
          if (range_chart.granularity() == "week"){
            rotation += (task.target_2) / 7 * 360;
          }
          else if (range_chart.granularity() == "month"){
            rotation += (task.target_2) / 31 * 360;
          }
          else if (range_chart.granularity() == "year"){
            rotation += (task.target_2) / 366 * 360;
          }
          return "translate(" + (chart_dim / 2) + "," + (chart_dim / 2) + ")rotate(" + rotation + ")";
        }          
      })      
      .on('touchstart', function(){ 
        d3.select('#target_1').style('stroke-width','2px');
        d3.select('#target_2').style('stroke-width','4px');        
        task.response_value = 'target_2';
        d3.select('#submit_btn_done')
        .attr('disabled',null)
        .attr('class','menu_btn_enabled')
        .style('background','#ec407a')
        .style('color','#111');
      });

    }   

    var barrier = chart_g.append('rect')
    .attr('id','barrier')
    .style('opacity',0)
    .attr('width',svg_dim)
    .attr('height',svg_dim)
    .attr('x',-inner_padding)
    .attr('y',-inner_padding);  

    var quant_scale = range_chart.quant_scale( );

    task.abs_diff_target_1 = 0;
    task.abs_diff_target_2 = 0;
    task.pixel_diff_target_1 = 0;
    task.pixel_diff_target_2 = 0;
    
    d3.selectAll('.data_element').each(function (d){

      switch (task.granularity) {
        
        case 'week':
          if (d.weekday == task.target_1 + 1) {
            task.abs_diff_target_1 = task.abs_diff_target_1 + Math.abs(d.start - d.start_baseline) + Math.abs(d.end - d.end_baseline);
            task.pixel_diff_target_1 = task.pixel_diff_target_1 + Math.abs(quant_scale(d.start) - quant_scale(d.start_baseline)) + Math.abs(quant_scale(d.end) - quant_scale(d.end_baseline));
          }
          else if (d.weekday == task.target_2 + 1) {
            task.abs_diff_target_2 = task.abs_diff_target_2 + Math.abs(d.start - d.start_baseline) + Math.abs(d.end - d.end_baseline);
            task.pixel_diff_target_2 = task.pixel_diff_target_2 + Math.abs(quant_scale(d.start) - quant_scale(d.start_baseline)) + Math.abs(quant_scale(d.end) - quant_scale(d.end_baseline));
          }      
        break;
  
        case 'month':
          if (d.day > task.target_1 + 1 - 2 && d.day < task.target_1 + 1 + 2) {
            task.abs_diff_target_1 = task.abs_diff_target_1 + Math.abs(d.start - d.start_baseline) + Math.abs(d.end - d.end_baseline);
            task.pixel_diff_target_1 = task.pixel_diff_target_1 + Math.abs(quant_scale(d.start) - quant_scale(d.start_baseline)) + Math.abs(quant_scale(d.end) - quant_scale(d.end_baseline));
          }
          else if (d.day > task.target_2 + 1 - 2 && d.day < task.target_2 + 1 + 2) {
            task.abs_diff_target_2 = task.abs_diff_target_2 + Math.abs(d.start - d.start_baseline) + Math.abs(d.end - d.end_baseline);
            task.pixel_diff_target_2 = task.pixel_diff_target_2 + Math.abs(quant_scale(d.start) - quant_scale(d.start_baseline)) + Math.abs(quant_scale(d.end) - quant_scale(d.end_baseline));
          }
          break;
  
        case 'year':
          if (d.day_of_year > task.target_1 + 1 - 15 && d.day_of_year < task.target_1 + 1 + 15) {
            task.abs_diff_target_1 = task.abs_diff_target_1 + Math.abs(d.start - d.start_baseline) + Math.abs(d.end - d.end_baseline);
            task.pixel_diff_target_1 = task.pixel_diff_target_1 + Math.abs(quant_scale(d.start) - quant_scale(d.start_baseline)) + Math.abs(quant_scale(d.end) - quant_scale(d.end_baseline));
          }
          else if (d.day_of_year > task.target_2 + 1 - 15 && d.day_of_year < task.target_2 + 1 + 15) {
            task.abs_diff_target_2 = task.abs_diff_target_2 + Math.abs(d.start - d.start_baseline) + Math.abs(d.end - d.end_baseline);
            task.pixel_diff_target_2 = task.pixel_diff_target_2 + Math.abs(quant_scale(d.start) - quant_scale(d.start_baseline)) + Math.abs(quant_scale(d.end) - quant_scale(d.end_baseline));
          }
        break;
  
        default:
          task.abs_diff_target_1 += 0;
          task.abs_diff_target_2 += 0;
          task.pixel_diff_target_1 += 0;
          task.pixel_diff_target_2 += 0;
        break;        
      }

    });

    task.normalized_pixel_diff_target_1 = task.pixel_diff_target_1 / (task.representation == 'linear' ? chart_dim : chart_dim / 2);
    task.normalized_pixel_diff_target_2 = task.pixel_diff_target_2 / (task.representation == 'linear' ? chart_dim : chart_dim / 2);    
    
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

  var instruction_text = instruction_div.append('span')
  .attr('id','instruction_text')
  .style('visibility','hidden')
  .html((task.training ? '<span class="instruction_emphasis">PRACTICE TRIAL</span>:<br>' : '') + 'Which'  + (task.granularity == 'week' ?  (task.datatype == 'temperature' ?' temperature range ' : ' sleeping time ') : (task.datatype == 'temperature' ? ' span of temperature ranges ' : ' span of sleeping times ')) + '<span class="instruction_emphasis">'+ (task.datatype == 'temperature' ? 'is more closely aligned with' : 'more closely follows') + '</span> <span class="instruction_emphasis" style="background-color: #555">' + (task.datatype == 'temperature' ? 'the expected temperature range' : 'the recommended sleeping time') + '</span>?');
  
  loadData();    

  d3.select('#task_div').append('input')
  .attr('class', 'menu_btn_disabled')
  .attr('id','submit_btn_done')
  .attr('disabled',true)
  .style('visibility','hidden')
  .attr('type','button')
  .attr('value','DONE')
  .attr('title', 'DONE')
  .on('touchstart', function() {  
    
  });

  d3.select('#task_div').append('input')
  .attr('class', 'menu_btn_disabled')
  .attr('id','submit_btn_equal')
  .attr('disabled',true)
  .style('visibility','hidden')
  .attr('type','button')
  .attr('value','EQUALLY ALIGNED')
  .attr('title', 'EQUALLY ALIGNED')
  .on('touchstart', function() {  
    task.response_value = 'equal';
    endTask();
  });

  task.load_time = new Date().valueOf();
  task.reading_interruptions = 0;
  task.reading_interruption_time = 0;

  function startTask () {

    d3.select('#instruction_text').style('visibility','visible');    
    d3.select('#submit_btn_done').style('visibility','visible');
    d3.select('#submit_btn_equal').style('visibility','visible');

    task.task_name = "CompareBetween";
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

    d3.select('#submit_btn_done')
    .attr('disabled',true)
    .style('background','#444')
    .attr('value','DONE')
    .attr('title', 'DONE')
    .on('touchstart', function() {  
      if (d3.select(this).attr('class') == 'menu_btn_enabled') {
        endTask();
      }
    });

    d3.select('#submit_btn_equal')
    .attr('disabled',null)
    .attr('class','menu_btn_enabled')
    .style('background','#444')
    .attr('value','EQUALLY ALIGNED')
    .attr('title', 'EQUALLY ALIGNED')
    .on('touchstart', function() {  
      if (d3.select(this).attr('class') == 'menu_btn_enabled') {
        task.response_value = 'equal';
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

    if (task.abs_diff_target_1 < task.abs_diff_target_2) {
      if (task.response_value == 'target_1') {        
        task.quant_error = 0;
        task.quant_distance = 0;
        task.normalized_quant_distance = 0;
        task.binary_error = false;
      }
      else {
        task.quant_error = Math.abs(task.abs_diff_target_1 - task.abs_diff_target_2);
        task.quant_distance = Math.abs(task.pixel_diff_target_1 - task.pixel_diff_target_2);
        task.normalized_quant_distance = Math.abs(task.normalized_pixel_diff_target_1 - task.normalized_pixel_diff_target_2);
        task.binary_error = true;
      }
    }
    else if (task.abs_diff_target_2 < task.abs_diff_target_1) {
      if (task.response_value == 'target_2') {        
        task.quant_error = 0;
        task.quant_distance = 0;
        task.normalized_quant_distance = 0;
        task.binary_error = false;
      }
      else {
        task.quant_error = Math.abs(task.abs_diff_target_2 - task.abs_diff_target_1);
        task.quant_distance = Math.abs(task.pixel_diff_target_2 - task.pixel_diff_target_1);
        task.normalized_quant_distance = Math.abs(task.normalized_pixel_diff_target_2 - task.normalized_pixel_diff_target_1);
        task.binary_error = true;     
      }
    }
    else { // task.abs_diff_target_2 == task.abs_diff_target_1
      if (task.response_value == 'equal') {
        task.quant_error = 0;
        task.quant_distance = 0;
        task.normalized_quant_distance = 0;
        task.binary_error = false;             
      }
      else {
        task.quant_error = Math.abs(task.abs_diff_target_2 - task.abs_diff_target_1);
        task.quant_distance = Math.abs(task.pixel_diff_target_2 - task.pixel_diff_target_1);
        task.normalized_quant_distance = Math.abs(task.normalized_pixel_diff_target_2 - task.normalized_pixel_diff_target_1);
        task.binary_error = true;
      }      
    }

    console.log(task);
    
    // appInsights.trackEvent("CompareBetween", { 
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
    //   "target_1": task.target_1,
    //   "target_2": task.target_2,
    //   "abs_diff_target_1": task.abs_diff_target_1,
    //   "abs_diff_target_2": task.abs_diff_target_2,    
    //   "pixel_diff_target_1": task.pixel_diff_target_1,
    //   "pixel_diff_target_2": task.pixel_diff_target_2,
    //   "normalized_pixel_diff_target_1": task.normalized_pixel_diff_target_1,
    //   "normalized_pixel_diff_target_2": task.normalized_pixel_diff_target_2,  
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

      d3.select('#submit_btn_done')
      .attr('disabled',true)
      .style('color','gold')
      .style('background','#444')
      .attr('class', 'menu_btn_disabled');

      d3.select('#submit_btn_equal')
      .attr('disabled',true)
      .attr('class', 'menu_btn_disabled');

      if (!task.binary_error) {
        
        d3.select('#main_svg').attr('class','blurme');
        d3.select('#instruction_text').remove();   
        d3.select('#submit_btn_done').remove();
        d3.select('#submit_btn_equal').remove();     
        
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
            compareBetween(compareBetweenTaskList[index+1],index+1); 
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

          d3.selectAll('.specified_date_region').style('stroke-width','2px');
          task.response_value = undefined;
          d3.select('#submit_btn_done')
          .attr('disabled',true)
          .style('background','#444')
          .style('color','gold')
          .attr('class', 'menu_btn_disabled');
          d3.selectAll('.data_element').selectAll('rect').style('opacity',1);

          d3.select('#feedback_btn').remove();   
          d3.select('#barrier').remove();
          attempts++;
          d3.select('#main_svg').attr('class',null);
          d3.select('.focus').style('display','none');     
          
          d3.select('#submit_btn_equal')
          .attr('disabled',null)
          .attr('class', 'menu_btn_enabled');

          if (attempts > 2) {

            d3.selectAll('.data_element').selectAll('rect')
            .style('opacity',function(d) {
              var rect_opacity;
              switch (task.granularity) {
                
                case 'week':
                  rect_opacity = (d.weekday == task.target_1 + 1 || d.weekday == task.target_2 + 1) ? 1 : 0.25;
                break;
          
                case 'month':
                  rect_opacity = ((d.day > task.target_1 + 1 - 2 && d.day < task.target_1 + 1 + 2) || (d.day > task.target_2 + 1 - 2 && d.day < task.target_2 + 1 + 2)) ? 1 : 0.25;
                break;
          
                case 'year':
                  rect_opacity = ((d.day_of_year > task.target_1 + 1 - 15 && d.day_of_year < task.target_1 + 1 + 15) || (d.day_of_year > task.target_2 + 1 - 15 && d.day_of_year < task.target_2 + 1 + 15)) ? 1 : 0.25;
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
      if (index+1 == compareBetweenTaskList.length) {
        suppress_touch_feedback = false;
        suppress_touch_val_feedback = false;
        compareBetween_complete = true;
        // appInsights.trackEvent("compareBetweenComplete", { 
        //   "TimeStamp": new Date().valueOf(),
        //   "Event": "compareBetweenComplete",
        //   "user_id": userID
        // });
        loadMenu();
        hideAddressBar();   
      }
      else {
        if (index == 4 || index == 14) { //gotcha
          gotcha('compareBetween',index);
        } 
        else {
          //next task
          compareBetween(compareBetweenTaskList[index+1],index+1); 
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
    .html('<span class="instruction_emphasis">Comparing Ranges Task</span>:<br>Which ' + (task.datatype == 'temperature' ? ' temperature range <span class="instruction_emphasis">is more closely aligned with</span>' : ' sleeping time <span class="instruction_emphasis">more closely follows</span>') + ' <span class="instruction_emphasis" style="background-color: #555"> the ' + (task.datatype == 'temperature' ? 'expected temperature range' : 'recommended sleeping time ') + '</span>?');
    
    var task_instruction_svg = task_instruction_screen.append('svg')
    .attr('id','task_instruction_svg')
    .style('height', (0.95 * svg_dim) + 'px')
    .style('width', (0.95 * svg_dim) +'px');

    task_instruction_svg.append('svg:image')
    .attr('class','instruction_svg')
    .attr("xlink:href", task.datatype == 'temperature' ? "assets/compare_bw_temp.svg" : "assets/compare_bw_sleep.svg")
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
        .attr("xlink:href", task.datatype == 'temperature' ? "assets/compare_bw_temp.svg" : "assets/compare_bw_sleep.svg");
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
      .html('Tap to Start ' + (task.training ? '<span class="instruction_emphasis">PRACTICE</span> Trial' : ('Trial <span class="instruction_emphasis">' + (index + 1) + '</span> of <span class="instruction_emphasis">' + compareBetweenTaskList.length + '</span>')) + '<br><span style="font-size:0.7em; font-weight:400;">' + 'Which'  + (task.granularity == 'week' ?  (task.datatype == 'temperature' ? ' temperature range ' : ' sleeping time ') : (task.datatype == 'temperature' ? ' set of temperature ranges ' : ' set of sleeping times ')) + '<span class="instruction_emphasis">' + (task.datatype == 'temperature' ? 'is more closely aligned with' : 'more closely follows') + '</span> <span class="instruction_emphasis" style="background-color: #555">' + (task.datatype == 'temperature' ? ' the expected temperature range' : ' recommended sleeping time') + '</span>?');
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
    .html('Tap to Start ' + (task.training ? '<span class="instruction_emphasis">PRACTICE</span> Trial' : ('Trial <span class="instruction_emphasis">' + (index + 1) + '</span> of <span class="instruction_emphasis">' + compareBetweenTaskList.length + '</span>')) + '<br><span style="font-size:0.7em; font-weight:400;">' + 'Which'  + (task.granularity == 'week' ?  (task.datatype == 'temperature' ? ' temperature range ' : ' sleeping time ') : (task.datatype == 'temperature' ? ' set of temperature ranges ' : ' set of sleeping times ')) + '<span class="instruction_emphasis">' + (task.datatype == 'temperature' ? 'is more closely aligned with' : 'more closely follows') + '</span> <span class="instruction_emphasis" style="background-color: #555">' + (task.datatype == 'temperature' ? 'the expected temperature range' : 'the recommended sleeping time') + '</span>?');
  }
}

module.exports = compareBetween;
