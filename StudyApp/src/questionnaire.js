var d3 = require("d3");
var moment = require("moment");
var Clipboard = require("clipboard");
var globals = require("./globals");
var rangeChart = require("./rangeChart");
var temperatureData = require("./data/temperatureData");
var sleepData = require("./data/sleepData");

function questionnaire (scene) {

  data_unit = locateDateTaskList[0].datatype;
  suppress_touch_feedback = true;
  suppress_touch_val_feedback = true;

  var range_chart = rangeChart(),
      checkExist,
      i = 0,
      likert_rb;   

  var clip = new Clipboard('.btn'); 

  clip.on("success", function(e) {
    console.log('copied: ' + e.text);    
  });
  clip.on("error", function(e) {
    console.error('Action:', e.action);
    console.error('Trigger:', e.trigger);   
  });

  d3.select('#questionnaire_div').remove();
  if (document.getElementById('questionnaire_div') != undefined) {      
    document.getElementById('questionnaire_div').remove(); 
  }

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
  
          d3.select('#questionnaire_div')
          .style('visibility','visible');       
  
          clearInterval(checkExist);
        }
      }, 100); // check every 100ms
      
      main_svg = d3.select('#main_svg').remove();
    
      main_svg = d3.select('#questionnaire_div').append('svg')
      .attr('id','main_svg');  
    
      defs = d3.select('#main_svg').append('defs');
    
      chart_g = main_svg.append('g')
      .attr('id','chart_g'); 
          
      document.getElementById('questionnaire_div').focus();
    }
  
  /** INIT **/
  
  d3.select('body').append('div')
  .attr('id','questionnaire_div')
  .attr('tabindex',0);  

  var instruction_div = d3.select('#questionnaire_div').append('div')
  .attr('class','toolbar')
  .style('height','80px')
  .attr('id','instruction_div');

  var instruction_text = instruction_div.append('span')
  .attr('id','instruction_text');  

  switch (scene) {

    case 0:

      instruction_text.html('<span class="instruction_emphasis">Congratulations!</span><br>You have completed the study tasks. Please take a moment to respond to the following set of questions about the chart designs used in this study.');    

      d3.select('#questionnaire_div').append('input')
      .attr('class', 'menu_btn_enabled')
      .attr('id','submit_btn')
      .attr('type','button')
      .attr('value','NEXT')
      .attr('title', 'NEXT')
      .on('touchstart', function() {      
        
        // appInsights.trackEvent("Survey", { 
        //   "TimeStamp": new Date().valueOf(),
        //   "user_id": userID,
        //   "Event": "Survey",
        //   "Scene": scene + 1
        // });

        questionnaire(scene + 1);        
        
      });

      break;  

    case 1:
    
      instruction_text.html('1. If you were to visually represent a <span class="instruction_emphasis">week</span> of ' + (data_unit == 'temperature' ? "<span class='instruction_emphasis'>temperature ranges</span>" : "<span class='instruction_emphasis'>sleeping times</span>") + ' on your phone, which chart design would you use? (Tap on one of the charts).');    
      
      getDims();

      main_svg = d3.select('#questionnaire_div').append('svg')
      .attr('id','main_svg')
      .style('border','1px solid transparent')
      .style('height',svg_dim + 'px')
      .style('width',svg_dim + 'px');

      main_svg.append('text')
      .attr('class','instruction_svg_title')
      .attr('dy','-1em')
      .attr("x", svg_dim / 4)
      .attr("y", svg_dim / 4)
      .attr('text-anchor', "middle")
      .attr('alignment-baseline','middle')
      .text('LINEAR');

      main_svg.append('rect')
      .attr('class','instruction_svg_frame')
      .style('fill','transparent')
      .style('stroke','gold')
      .attr("width", svg_dim / 2)
      .attr("height", svg_dim / 2)
      .attr("x", 0)
      .attr("y", svg_dim / 4);

      main_svg.append('svg:image')
      .attr('class','instruction_svg')
      .attr('id','instruction_svg_linear')
      .attr("xlink:href", (data_unit == 'temperature' ? "assets/linear_week_temp.svg" : "assets/linear_week_sleep.svg"))
      .attr("width", svg_dim / 2 - 2)
      .attr("height", svg_dim / 2 - 2)
      .attr("x", 0 + 1)
      .attr("y", svg_dim / 4 + 1)
      .on('touchstart', function() {      
        
        // appInsights.trackEvent("Survey", { 
        //   "TimeStamp": new Date().valueOf(),
        //   "Question": "Preference",
        //   "granularity": "week",
        //   "representation": "linear",
        //   "Event": "Survey",
        //   "user_id": userID
        // });

        questionnaire(scene + 1);
        
      });

      main_svg.append('text')
      .attr('class','instruction_svg_title')
      .attr('dy','-1em')
      .attr("x", svg_dim * 3 / 4)
      .attr("y", svg_dim / 4)
      .attr('text-anchor', "middle")
      .attr('alignment-baseline','middle')
      .text('RADIAL');

      main_svg.append('rect')
      .attr('class','instruction_svg_frame')
      .style('fill','transparent')
      .style('stroke','gold')
      .attr("width", svg_dim / 2)
      .attr("height", svg_dim / 2)
      .attr("x", svg_dim / 2)
      .attr("y", svg_dim / 4);

      main_svg.append('svg:image')
      .attr('class','instruction_svg')
      .attr('id','instruction_svg_radial')
      .attr("xlink:href", (data_unit == 'temperature' ? "assets/radial_week_temp.svg" : "assets/radial_week_sleep.svg"))
      .attr("width", svg_dim / 2 - 2)
      .attr("height", svg_dim / 2 - 2)
      .attr("x", svg_dim / 2 + 1)
      .attr("y", svg_dim / 4 + 1)
      .on('touchstart', function() {      
        
        // appInsights.trackEvent("Survey", { 
        //   "TimeStamp": new Date().valueOf(),
        //   "Question": "Preference",
        //   "granularity": "week",
        //   "representation": "radial",
        //   "Event": "Survey",
        //   "user_id": userID
        // });

        questionnaire(scene + 1);
        
      });

      checkExist = setInterval(function() {  
        if (i == 10) {            
          clearInterval(checkExist);        
        }
        else {
          i++;

          d3.select('#instruction_svg_linear')
          .attr("xlink:href", (data_unit == 'temperature' ? "assets/linear_week_temp.svg" : "assets/linear_week_sleep.svg"));

          d3.select('#instruction_svg_radial')
          .attr("xlink:href", (data_unit == 'temperature' ? "assets/radial_week_temp.svg" : "assets/radial_week_sleep.svg"));
        }
      }, 100); // check every 100ms
        
      break;

    case 2:
    
      instruction_text.html('2. When a <span class="instruction_emphasis">week</span> of ' + (data_unit == 'temperature' ? "<span class='instruction_emphasis'>temperature ranges</span>" : "<span class='instruction_emphasis'>sleeping times</span>") + ' was drawn <span class="instruction_emphasis">linearly</span>, how would you rate your overall performance across all 5 study tasks from <span class="instruction_emphasis">1</span> (poor) to <span class="instruction_emphasis">5</span> (great)?.');    
      
      all_data = data_unit == 'temperature' ? temperatureData : sleepData;   
      range_chart.granularity("week"); 
      loadData();  

      likert_rb = d3.select('#questionnaire_div').selectAll(".menu_btn_enabled")
      .data([1,2,3,4,5])
      .enter();     

      likert_rb.append('input')
      .attr('class', 'menu_btn_enabled')
      .style('width','18%')
      .style('margin-left','1%')      
      .style('margin-right','1%')
      .style('transform','translate(0,0)')
      .attr('type','button')
      .attr('value',function(d){
        return(d);
      })
      .attr('title', function(d){
        return(d);
      })
      .on('touchstart', function(d) {      
        
        // appInsights.trackEvent("Survey", { 
        //   "TimeStamp": new Date().valueOf(),
        //   "user_id": userID,
        //   "Event": "Survey",
        //   "Question": "Confidence",
        //   "representation": "linear",
        //   "granularity":"week",
        //   "Response": d
        // });

        questionnaire(scene + 1);        
        
      });           

      break;
      
    case 3:
    
      instruction_text.html('3. When a <span class="instruction_emphasis">week</span> of ' + (data_unit == 'temperature' ? "<span class='instruction_emphasis'>temperature ranges</span>" : "<span class='instruction_emphasis'>sleeping times</span>") + ' was drawn <span class="instruction_emphasis">radially</span>, how would you rate your overall performance across the 5 tasks from <span class="instruction_emphasis">1</span> (poor) to <span class="instruction_emphasis">5</span> (great)?.');    
      
      all_data = data_unit == 'temperature' ? temperatureData : sleepData;  
      range_chart.granularity("week"); 
      range_chart.representation("radial");
      loadData();  

      likert_rb = d3.select('#questionnaire_div').selectAll(".menu_btn_enabled")
      .data([1,2,3,4,5])
      .enter();     

      likert_rb.append('input')
      .attr('class', 'menu_btn_enabled')
      .style('width','18%')
      .style('margin-left','1%')      
      .style('margin-right','1%')
      .style('transform','translate(0,0)')
      .attr('type','button')
      .attr('value',function(d){
        return(d);
      })
      .attr('title', function(d){
        return(d);
      })
      .on('touchstart', function(d) {      
        
        // appInsights.trackEvent("Survey", { 
        //   "TimeStamp": new Date().valueOf(),
        //   "user_id": userID,
        //   "Event": "Survey",
        //   "Question": "Confidence",
        //   "representation": "radial",
        //   "granularity":"week",
        //   "Response": d
        // });

        questionnaire(scene + 1);        
        
      });           

      break;

    case 4:
    
      instruction_text.html('4. If you were to visually represent a <span class="instruction_emphasis">month</span> of ' + (data_unit == 'temperature' ? "<span class='instruction_emphasis'>temperature ranges</span>" : "<span class='instruction_emphasis'>sleeping times</span>") + ' on your phone, which chart design would you use? (Tap on one of the charts).');    
      
      getDims();

      main_svg = d3.select('#questionnaire_div').append('svg')
      .attr('id','main_svg')
      .style('border','1px solid transparent')
      .style('height',svg_dim + 'px')
      .style('width',svg_dim + 'px');

      main_svg.append('text')
      .attr('class','instruction_svg_title')
      .attr('dy','-1em')
      .attr("x", svg_dim / 4)
      .attr("y", svg_dim / 4)
      .attr('text-anchor', "middle")
      .attr('alignment-baseline','middle')
      .text('LINEAR');

      main_svg.append('rect')
      .attr('class','instruction_svg_frame')
      .style('fill','transparent')
      .style('stroke','gold')
      .attr("width", svg_dim / 2)
      .attr("height", svg_dim / 2)
      .attr("x", 0)
      .attr("y", svg_dim / 4);

      main_svg.append('svg:image')
      .attr('class','instruction_svg')
      .attr('id','instruction_svg_linear')
      .attr("xlink:href", (data_unit == 'temperature' ? "assets/linear_month_temp.svg" : "assets/linear_month_sleep.svg"))
      .attr("width", svg_dim / 2 - 2)
      .attr("height", svg_dim / 2 - 2)
      .attr("x", 0 + 1)
      .attr("y", svg_dim / 4 + 1)
      .on('touchstart', function() {      
        
        // appInsights.trackEvent("Survey", { 
        //   "TimeStamp": new Date().valueOf(),
        //   "Question": "Preference",
        //   "granularity": "month",
        //   "representation": "linear",
        //   "Event": "Survey",
        //   "user_id": userID
        // });

        questionnaire(scene + 1);
        
      });

      main_svg.append('text')
      .attr('class','instruction_svg_title')
      .attr('dy','-1em')
      .attr("x", svg_dim * 3 / 4)
      .attr("y", svg_dim / 4)
      .attr('text-anchor', "middle")
      .attr('alignment-baseline','middle')
      .text('RADIAL');

      main_svg.append('rect')
      .attr('class','instruction_svg_frame')
      .style('fill','transparent')
      .style('stroke','gold')
      .attr("width", svg_dim / 2)
      .attr("height", svg_dim / 2)
      .attr("x", svg_dim / 2)
      .attr("y", svg_dim / 4);

      main_svg.append('svg:image')
      .attr('class','instruction_svg')
      .attr('id','instruction_svg_radial')
      .attr("xlink:href", (data_unit == 'temperature' ? "assets/radial_month_temp.svg" : "assets/radial_month_sleep.svg"))
      .attr("width", svg_dim / 2 - 2)
      .attr("height", svg_dim / 2 - 2)
      .attr("x", svg_dim / 2 + 1)
      .attr("y", svg_dim / 4 + 1)
      .on('touchstart', function() {      
        
        // appInsights.trackEvent("Survey", { 
        //   "TimeStamp": new Date().valueOf(),
        //   "Question": "Preference",
        //   "granularity": "month",
        //   "representation": "radial",
        //   "Event": "Survey",
        //   "user_id": userID
        // });

        questionnaire(scene + 1);
        
      });

      checkExist = setInterval(function() {  
        if (i == 10) {            
          clearInterval(checkExist);        
        }
        else {
          i++;

          d3.select('#instruction_svg_linear')
          .attr("xlink:href", (data_unit == 'temperature' ? "assets/linear_month_temp.svg" : "assets/linear_month_sleep.svg"));

          d3.select('#instruction_svg_radial')
          .attr("xlink:href", (data_unit == 'temperature' ? "assets/radial_month_temp.svg" : "assets/radial_month_sleep.svg"));
        }
      }, 100); // check every 100ms
        
      break;

    case 5:
    
      instruction_text.html('5. When a <span class="instruction_emphasis">month</span> of ' + (data_unit == 'temperature' ? "<span class='instruction_emphasis'>temperature ranges</span>" : "<span class='instruction_emphasis'>sleeping times</span>") + ' was drawn <span class="instruction_emphasis">linearly</span>, how would you rate your overall performance across the 5 tasks from <span class="instruction_emphasis">1</span> (poor) to <span class="instruction_emphasis">5</span> (great)?.');    
      
      all_data = data_unit == 'temperature' ? temperatureData : sleepData;   
      first_date = first_date.endOf('week').add(1,'weeks');
      range_chart.granularity("month");
      first_date = first_date.startOf('month');
      loadData();  

      likert_rb = d3.select('#questionnaire_div').selectAll(".menu_btn_enabled")
      .data([1,2,3,4,5])
      .enter();     

      likert_rb.append('input')
      .attr('class', 'menu_btn_enabled')
      .style('width','18%')
      .style('margin-left','1%')      
      .style('margin-right','1%')
      .style('transform','translate(0,0)')
      .attr('type','button')
      .attr('value',function(d){
        return(d);
      })
      .attr('title', function(d){
        return(d);
      })
      .on('touchstart', function(d) {      
        
        // appInsights.trackEvent("Survey", { 
        //   "TimeStamp": new Date().valueOf(),
        //   "user_id": userID,
        //   "Event": "Survey",
        //   "Question": "Confidence",
        //   "representation": "linear",
        //   "granularity":"month",
        //   "Response": d
        // });

        questionnaire(scene + 1);        
        
      });           

      break;
      
    case 6:
    
      instruction_text.html('6. When a <span class="instruction_emphasis">month</span> of ' + (data_unit == 'temperature' ? "<span class='instruction_emphasis'>temperature ranges</span>" : "<span class='instruction_emphasis'>sleeping times</span>") + ' was drawn <span class="instruction_emphasis">radially</span>, how would you rate your overall performance across the 5 tasks from <span class="instruction_emphasis">1</span> (poor) to <span class="instruction_emphasis">5</span> (great)?.');    
      
      all_data = data_unit == 'temperature' ? temperatureData : sleepData;  
      first_date = first_date.endOf('week').add(1,'weeks');
      range_chart.granularity("month");
      first_date = first_date.startOf('month');
      range_chart.representation("radial");
      loadData();  

      likert_rb = d3.select('#questionnaire_div').selectAll(".menu_btn_enabled")
      .data([1,2,3,4,5])
      .enter();     

      likert_rb.append('input')
      .attr('class', 'menu_btn_enabled')
      .style('width','18%')
      .style('margin-left','1%')      
      .style('margin-right','1%')
      .style('transform','translate(0,0)')
      .attr('type','button')
      .attr('value',function(d){
        return(d);
      })
      .attr('title', function(d){
        return(d);
      })
      .on('touchstart', function(d) {      
        
        // appInsights.trackEvent("Survey", { 
        //   "TimeStamp": new Date().valueOf(),
        //   "user_id": userID,
        //   "Event": "Survey",
        //   "Question": "Confidence",
        //   "representation": "radial",
        //   "granularity":"month",
        //   "Response": d
        // });

        questionnaire(scene + 1);        
        
      });           

      break;

    case 7:
    
      instruction_text.html('7. If you were to visually represent a <span class="instruction_emphasis">year</span> of ' + (data_unit == 'temperature' ? "<span class='instruction_emphasis'>temperature ranges</span>" : "<span class='instruction_emphasis'>sleeping times</span>") + ' on your phone, which chart design would you use? (Tap on one of the charts).');    
      
      getDims();

      main_svg = d3.select('#questionnaire_div').append('svg')
      .attr('id','main_svg')
      .style('border','1px solid transparent')
      .style('height',svg_dim + 'px')
      .style('width',svg_dim + 'px');

      main_svg.append('text')
      .attr('class','instruction_svg_title')
      .attr('dy','-1em')
      .attr("x", svg_dim / 4)
      .attr("y", svg_dim / 4)
      .attr('text-anchor', "middle")
      .attr('alignment-baseline','middle')
      .text('LINEAR');

      main_svg.append('rect')
      .attr('class','instruction_svg_frame')
      .style('fill','transparent')
      .style('stroke','gold')
      .attr("width", svg_dim / 2)
      .attr("height", svg_dim / 2)
      .attr("x", 0)
      .attr("y", svg_dim / 4);

      main_svg.append('svg:image')
      .attr('class','instruction_svg')
      .attr('id','instruction_svg_linear')
      .attr("xlink:href", (data_unit == 'temperature' ? "assets/linear_year_temp.svg" : "assets/linear_year_sleep.svg"))
      .attr("width", svg_dim / 2 - 2)
      .attr("height", svg_dim / 2 - 2)
      .attr("x", 0 + 1)
      .attr("y", svg_dim / 4 + 1)
      .on('touchstart', function() {      
        
        // appInsights.trackEvent("Survey", { 
        //   "TimeStamp": new Date().valueOf(),
        //   "Question": "Preference",
        //   "granularity": "year",
        //   "representation": "linear",
        //   "Event": "Survey",
        //   "user_id": userID
        // });

        questionnaire(scene + 1);
        
      });

      main_svg.append('text')
      .attr('class','instruction_svg_title')
      .attr('dy','-1em')
      .attr("x", svg_dim * 3 / 4)
      .attr("y", svg_dim / 4)
      .attr('text-anchor', "middle")
      .attr('alignment-baseline','middle')
      .text('RADIAL');

      main_svg.append('rect')
      .attr('class','instruction_svg_frame')
      .style('fill','transparent')
      .style('stroke','gold')
      .attr("width", svg_dim / 2)
      .attr("height", svg_dim / 2)
      .attr("x", svg_dim / 2)
      .attr("y", svg_dim / 4);

      main_svg.append('svg:image')
      .attr('class','instruction_svg')
      .attr('id','instruction_svg_radial')
      .attr("xlink:href", (data_unit == 'temperature' ? "assets/radial_year_temp.svg" : "assets/radial_year_sleep.svg"))
      .attr("width", svg_dim / 2 - 2)
      .attr("height", svg_dim / 2 - 2)
      .attr("x", svg_dim / 2 + 1)
      .attr("y", svg_dim / 4 + 1)
      .on('touchstart', function() {      
        
        // appInsights.trackEvent("Survey", { 
        //   "TimeStamp": new Date().valueOf(),
        //   "Question": "Preference",
        //   "granularity": "year",
        //   "representation": "radial",
        //   "Event": "Survey",
        //   "user_id": userID
        // });

        questionnaire(scene + 1);
        
      });

      checkExist = setInterval(function() {  
        if (i == 10) {            
          clearInterval(checkExist);        
        }
        else {
          i++;

          d3.select('#instruction_svg_linear')
          .attr("xlink:href", (data_unit == 'temperature' ? "assets/linear_year_temp.svg" : "assets/linear_year_sleep.svg"));

          d3.select('#instruction_svg_radial')
          .attr("xlink:href", (data_unit == 'temperature' ? "assets/radial_year_temp.svg" : "assets/radial_year_sleep.svg"));
        }
      }, 100); // check every 100ms
        
      break;

    case 8:
    
      instruction_text.html('8. When a <span class="instruction_emphasis">year</span> of ' + (data_unit == 'temperature' ? "<span class='instruction_emphasis'>temperature ranges</span>" : "<span class='instruction_emphasis'>sleeping times</span>") + ' was drawn <span class="instruction_emphasis">linearly</span>, how would you rate your overall performance across the 5 tasks from <span class="instruction_emphasis">1</span> (poor) to <span class="instruction_emphasis">5</span> (great)?.');    
      
      all_data = data_unit == 'temperature' ? temperatureData : sleepData;   
      first_date = first_date.endOf('week').add(1,'weeks');
      range_chart.granularity("year");
      first_date = first_date.startOf('year');
      loadData();  

      likert_rb = d3.select('#questionnaire_div').selectAll(".menu_btn_enabled")
      .data([1,2,3,4,5])
      .enter();     

      likert_rb.append('input')
      .attr('class', 'menu_btn_enabled')
      .style('width','18%')
      .style('margin-left','1%')      
      .style('margin-right','1%')
      .style('transform','translate(0,0)')
      .attr('type','button')
      .attr('value',function(d){
        return(d);
      })
      .attr('title', function(d){
        return(d);
      })
      .on('touchstart', function(d) {      
        
        // appInsights.trackEvent("Survey", { 
        //   "TimeStamp": new Date().valueOf(),
        //   "user_id": userID,
        //   "Event": "Survey",
        //   "Question": "Confidence",
        //   "representation": "linear",
        //   "granularity":"year",
        //   "Response": d
        // });

        questionnaire(scene + 1);        
        
      });           

      break;
      
    case 9:
    
      instruction_text.html('9. When a <span class="instruction_emphasis">year</span> of ' + (data_unit == 'temperature' ? "<span class='instruction_emphasis'>temperature ranges</span>" : "<span class='instruction_emphasis'>sleeping times</span>") + ' was drawn <span class="instruction_emphasis">radially</span>, how would you rate your overall performance across the 5 tasks from <span class="instruction_emphasis">1</span> (poor) to <span class="instruction_emphasis">5</span> (great)?.');    
      
      all_data = data_unit == 'temperature' ? temperatureData : sleepData;  
      first_date = first_date.endOf('week').add(1,'weeks');
      range_chart.granularity("year");
      first_date = first_date.startOf('year');
      range_chart.representation("radial");
      loadData();  

      likert_rb = d3.select('#questionnaire_div').selectAll(".menu_btn_enabled")
      .data([1,2,3,4,5])
      .enter();     

      likert_rb.append('input')
      .attr('class', 'menu_btn_enabled')
      .style('width','18%')
      .style('margin-left','1%')      
      .style('margin-right','1%')
      .style('transform','translate(0,0)')
      .attr('type','button')
      .attr('value',function(d){
        return(d);
      })
      .attr('title', function(d){
        return(d);
      })
      .on('touchstart', function(d) {      
        
        // appInsights.trackEvent("Survey", { 
        //   "TimeStamp": new Date().valueOf(),
        //   "user_id": userID,
        //   "Event": "Survey",
        //   "Question": "Confidence",
        //   "representation": "radial",
        //   "granularity":"year",
        //   "Response": d
        // });

        questionnaire(scene + 1);        
        
      });           

      break;
    
    default: // return to main menu
          
      d3.select('#instruction_div').remove();
      
      var questionnaire_content_div = d3.select('#questionnaire_div')
      .append('div')
      .attr('class','toolbar')
      .style('width','100%')
      .style('height',(window.innerHeight - 50) + 'px')
      .attr('id','intro_content_div');        

      questionnaire_content_div.append('span')
      .attr('class','consent_text')
      .html('<span class="instruction_emphasis">Thank you!</span><br>You have completed the survey and the study. Copy your completion code below. This code will remain valid for 30 minutes:<br><br><span class="instruction_emphasis" id="copy_code" style="user-select:all;">7479906172</span>'
      );          

      d3.select('#questionnaire_div').append('input')
      .attr('class', 'btn')
      .attr('id','submit_btn')
      .attr('type','button')
      .attr('value','Copy 7479906172')
      .attr('title', 'Copy 7479906172')
      .attr('data-clipboard-target','#copy_code')
      .attr('data-clipboard-text', '7479906172');
      
      // appInsights.trackEvent("SurveyComplete", { 
      //   "TimeStamp": new Date().valueOf(),
      //   "Event": "SurveyComplete",
      //   "user_id": userID
      // });        

      questionnaire_complete = true;

      break;
  }

  d3.select('#questionnaire_div')
  .style('visibility','visible');

  document.getElementById('questionnaire_div').focus();  
  
}

module.exports = questionnaire;
