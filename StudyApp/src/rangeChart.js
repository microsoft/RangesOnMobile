var d3 = require("d3");
var moment = require("moment");
var globals = require("./globals");

d3.rangeChart = function () {  

  /**

  GLOBAL VARIABLES

  **/
  
  var chron_scale = d3.scaleLinear(),
      quant_scale = d3.scaleLinear(),
      guide_scale = d3.scaleLinear(),
      color_scale = d3.scaleLinear(),
      representation = "linear",
      granularity,
      exit_direction = "left",
      update_path,
      enter_path;

  function rangeChart (selection) {
    selection.each(function (data){

      d3.select(this).select('.focus').remove();

      var filtered_data = data.filter(function(d) {
        if (granularity == "week"){
          return moment(d.date_val).week() == selected_week && moment(d.date_val).endOf('week').year() == selected_year;
        }
        else if (granularity == "month"){
          return moment(d.date_val).month() == selected_month && moment(d.date_val).year() == selected_year;
        }
        else if (granularity == "year"){
          return moment(d.date_val).year() == selected_year;
        } 

      });

      var date_guide_data = filtered_data.filter(function(d) {
        if (granularity == "week"){
          return true;
        }
        else if (granularity == "month"){
          return moment(d.date_val).weekday() == 0;
        }
        else if (granularity == "year"){
          return moment(d.date_val).date() == 1;
        } 

      });

      min_start = d3.min(filtered_data, function(d) {
        return d.start;
      });

      var min_start_dates = filtered_data.filter(function (d){
        return d.start == min_start;
      });

      min_start_indices = min_start_dates.map(function(d) {
        if (granularity == 'week') {
          return d.weekday;  
        }
        else if (granularity == 'month') {
          return d.day;  
        }
        else {
          return d.day_of_year;
        }
      });

      max_start = d3.max(filtered_data, function(d) {
        return d.start;
      });

      var max_start_dates = filtered_data.filter(function (d){
        return d.start == max_start;
      });     
      
      max_start_indices = max_start_dates.map(function(d) {
        if (granularity == 'week') {
          return d.weekday;  
        }
        else if (granularity == 'month') {
          return d.day;  
        }
        else {
          return d.day_of_year;
        }
      });

      min_end = d3.min(filtered_data, function(d) {
        return d.end;
      });

      var min_end_dates = filtered_data.filter(function (d){
        return d.end == min_end;
      });    
      
      min_end_indices = min_end_dates.map(function(d) {
        if (granularity == 'week') {
          return d.weekday;  
        }
        else if (granularity == 'month') {
          return d.day;  
        }
        else {
          return d.day_of_year;
        }
      });

      max_end = d3.max(filtered_data, function(d) {
        return d.end;
      });

      var max_end_dates = filtered_data.filter(function (d){
        return d.end == max_end;
      });

      max_end_indices = max_end_dates.map(function(d) {
        if (granularity == 'week') {
          return d.weekday;  
        }
        else if (granularity == 'month') {
          return d.day;  
        }
        else {
          return d.day_of_year;
        }
      });

      min_range = d3.min(filtered_data, function(d) {
        return d.end - d.start;
      });

      var min_range_dates = filtered_data.filter(function (d){
        return (d.end - d.start) == min_range;
      });    
      
      min_range_indices = min_range_dates.map(function(d) {
        if (granularity == 'week') {
          return d.weekday;  
        }
        else if (granularity == 'month') {
          return d.day;  
        }
        else {
          return d.day_of_year;
        }
      });

      max_range = d3.max(filtered_data, function(d) {
        return d.end - d.start;
      });

      var max_range_dates = filtered_data.filter(function (d){
        return (d.end - d.start) == max_range;
      });

      max_range_indices = max_range_dates.map(function(d) {
        if (granularity == 'week') {
          return d.weekday;  
        }
        else if (granularity == 'month') {
          return d.day;  
        }
        else {
          return d.day_of_year;
        }
      });
      

      /**

      SCALES

      **/
      

      //update chronological time scale, map to time range

      chron_scale.range([0,chart_dim]);

      // update chron_scale domain
      if (granularity == "week"){
        chron_scale.domain([0,6]);
      }
      else if (granularity == "month"){
        chron_scale.domain([1,31]);
      }
      else if (granularity == "year"){
        chron_scale.domain([1,366]);
      }

      //update quantiatative scale, map to duration range

      //update quant_scale range
      if (representation == "linear") {
        if (data_unit == 'temperature') {
          quant_scale.range([chart_dim,0]);
        }
        else {
          quant_scale.range([0,chart_dim]);
        }
      }
      //update quant_scale range
      else {
        quant_scale.range([0,chart_dim * 0.6]);
      }

      var start_extent = d3.extent(filtered_data, function(d) {
        return d3.min([d.start,d.start_baseline]);
      });

      var end_extent = d3.extent(filtered_data, function(d) {
        return d3.max([d.end,d.end_baseline]);
      });

      var range_extent = d3.extent(filtered_data, function(d) {
        return d3.max([d.end,d.end_baseline]) - d3.min([d.start,d.start_baseline]);
      });

      quant_extent = d3.extent(start_extent.concat(end_extent));

      var quant_buffer = (quant_extent[1] - quant_extent[0]) * 0.1;

      var range_buffer = (range_extent[1] - range_extent[0]) * 0.1;      
      
      if (representation == "radial") {
        if (data_unit == 'sleep') {
          quant_scale.domain([2,26]);
        }
        else {
          quant_scale.domain([quant_extent[0] - 3 * quant_buffer,quant_extent[1] + quant_buffer]);
        }
      }
      else {
        if (data_unit == 'sleep') {
          quant_scale.domain([7,23]);
        }
        else {
          quant_scale.domain([quant_extent[0],quant_extent[1] + quant_buffer]);            
        }
      }

      quant_scale.nice();          
      
      //update quant_scale range
      if (representation == "linear") {
        guide_scale.range([chart_dim,0]);
      }
      //update quant_scale range
      else {
        guide_scale.range([0,chart_dim * 0.6]);
      }
      
      guide_scale.domain([quant_extent[0],quant_extent[1]]);

      guide_scale.nice();

      quant_scale.nice();
      
      color_scale.domain([quant_extent[0],(quant_extent[0] + quant_extent[1]) / 2,quant_extent[1]])
      // .range([d3.lab("#67a9cf"),d3.lab("#f7f7f7"),d3.lab("#ef8a62")])
      .range([d3.lab("#91bfdb"),d3.lab("#ffffbf"),d3.lab("#fc8d59")])
      .interpolate(d3.interpolateLab);

      /** DEFS **/      

      var defs = d3.select('#main_svg').select('defs');

      // var solid_text = defs.append('filter')
      // .attr('x','-10%')
      // .attr('y','-10%')
      // .attr('width','120%')
      // .attr('height','120%')
      // .attr('filterUnits','objectBoundingBox')
      // .attr('id','solid');

      // solid_text.append('feFlood')
      // .attr('flood-opacity',1)
      // .attr('result','flood')
      // .attr('flood-color','#ccc');

      // solid_text.append('feComposite')
      // .attr('in','SourceGraphic')
      // .attr('in2','BackgroundImage')
      // .attr('result','comp')
      // .attr('operator','over');
      
      var linear_gradient = defs.selectAll('.linear_gradient')
      .data(filtered_data, function(d) {
        return d.date_val;
      });

      var linear_gradient_enter = linear_gradient.enter()
      .append('linearGradient')
      .attr('class','linear_gradient')
      .attr('id', function(d) {
        return "linear_gradient_" + d.date_val;
      })
      .attr("x1", "0%")
      .attr("y1", "0%")
      .attr("x2", "0%")
      .attr("y2", "100%");

      linear_gradient_enter.append('stop')
      .attr('class','linear_gradient_start')
      .attr('offset', '0%')
      .attr('stop-color', function(d){
        return representation == 'radial' ? color_scale( d.start ) : data_unit == 'sleep' ? color_scale( d.start ) : color_scale( d.end );
      });

      linear_gradient_enter.append('stop')
      .attr('class','linear_gradient_end')
      .attr('offset', '100%')
      .attr('stop-color', function(d){
        return representation == 'radial' ? color_scale( d.end ) : data_unit == 'sleep' ? color_scale( d.end ) : color_scale( d.start );
      });
      

      var linear_gradient_update = defs.selectAll('.linear_gradient');
      // .transition();
      // .duration(transition_time)
      // .ease(d3.easeCubicInOut);    

      linear_gradient_update.select('.linear_gradient_start')
      .attr('stop-color', function(d){
        return representation == 'radial' ? color_scale( d.start ) : data_unit == 'sleep' ? color_scale( d.start ) : color_scale( d.end );
      });

      linear_gradient_update.select('.linear_gradient_end')
      .attr('stop-color', function(d){
        return representation == 'radial' ? color_scale( d.end ) : data_unit == 'sleep' ? color_scale( d.end ) : color_scale( d.start );
      });    

      var linear_gradient_exit = linear_gradient.exit()
      // .transition()
      // .duration(transition_time)
      .remove();     

      var start_icon = d3.select(this).selectAll('.start_icon')
      .data([null]);

      var start_icon_enter = start_icon.enter()
      .append("svg:image")
      .attr('class','start_icon');

      var start_icon_update = d3.select('#main_svg').selectAll('.start_icon')
      .attr("xlink:href", (data_unit == 'temperature' ? "assets/cold.svg" : "assets/sleep.svg"))
      .attr("width", 25)
      .attr("height", 25)
      .attr("x", (representation == 'linear' ? chart_dim + inner_padding - 30 : chart_dim / 2 - 12.5))
      .attr("y", (representation == 'linear' ? data_unit == 'sleep' ? 0 - inner_padding + 5 : chart_dim + inner_padding - 30 : chart_dim / 2 - 12.5));

      var start_icon_exit = start_icon.exit()
      .remove();      

      var end_icon = d3.select(this).selectAll('.end_icon')
      .data([null]);

      var end_icon_enter = end_icon.enter()
      .append("svg:image")
      .attr('class','end_icon');

      var end_icon_update = d3.select('#main_svg').selectAll('.end_icon')
      .attr("xlink:href", (data_unit == 'temperature' ? "assets/hot.svg" : "assets/sunrise.svg"))
      .attr("width", 25)
      .attr("height", 25)
      .attr("x", (representation == 'linear' ? chart_dim + inner_padding - 30 : 0 - inner_padding + 5))
      .attr("y", (representation == 'linear' ? data_unit == 'sleep' ? chart_dim + inner_padding - 30 : 0 - inner_padding + 5 : chart_dim + inner_padding - 30));

      var end_icon_exit = end_icon.exit()
      .remove();
    
      /** 
       * 
       * DATE GUIDE ELEMENT ENTER 
       * 
       **/

      var date_guide_elements = d3.select(this).selectAll(".date_guide_element")
      .data(date_guide_data, function(d) {
        return d.date_val;
      });      

      var date_guide_element_enter = date_guide_elements.enter()
      .append("g")
      .attr("class","date_guide_element")
      .attr("id", function (d) {
        return "date_guide_element_" + d.date_val.substr(0,d.date_val.indexOf('T'));
      });        
      // .attr("transform", function() {
      //   if (exit_direction == "right") {
      //     return "translate(" + (-2 * inner_padding) + ",0)";
      //   }
      //   else {
      //     return "translate(" + svg_dim + ",0)";
      //   }
      // }); 

      date_guide_element_enter.append("line")
      .attr('class','date_line')
      .attr("x1",0)
      .attr("x2",0)
      .attr("y1",0)
      .attr("y2",chart_dim);  

      var element_date = date_guide_element_enter.append("text")      
      .attr('text-anchor', "middle")
      .attr('alignment-baseline','middle')
      .attr("class","element_date");
      
      element_date.append("tspan")
      .attr('class','element_date_top')
      .attr('text-anchor', "middle")
      .attr('alignment-baseline','middle')
      .attr('x',0)
      .text("");
      
      element_date.append("tspan")
      .attr('class','element_date_bottom')
      .attr('text-anchor', "middle")
      .attr('alignment-baseline','middle')
      .attr('x',0)
      .attr('dy','1.2em')    
      .text("");

      /**

      DATA ELEMENT ENTER

      **/

      var data_elements = d3.select(this).selectAll(".data_element")
      .data(filtered_data, function(d) {
        return d.date_val;
      });

      var data_element_enter = data_elements.enter()
      .append("g")
      .attr("class","data_element")
      .attr("id", function (d) {
        return "data_element_" + d.date_val.substr(0,d.date_val.indexOf('T'));
      });  
      // .attr("transform", function() {
      //   if (exit_direction == "right") {
      //     return "translate(" + (-2 * inner_padding) + ",0)";
      //   }
      //   else {
      //     return "translate(" + svg_dim + ",0)";
      //   }
      // });  

      data_element_enter.append("rect")
      .attr('class','baseline_value')
      .attr("height", 0)  
      .attr("y",function(d) {
        if (d.start_baseline == undefined) {
          return chart_dim + inner_padding;
        }        
        else {
          return representation == 'radial' ? quant_scale( 0 ) : data_unit == 'sleep' ? quant_scale( d.start_baseline ) : quant_scale( d.end_baseline );
        }
      })             
      .attr("ry", function(d) {
        if (granularity == "week"){
          return chart_dim  / 7 / 8;
        }
        else if (granularity == "month"){
          return chart_dim  / 31 / 8;
        }
        else if (granularity == "year"){
          return chart_dim  / 366 / 8;
        }          
      });

      data_element_enter.append("rect")
      .attr('class','observed_value')
      .style("fill", function(d) { 
        return "url(#linear_gradient_" + d.date_val +")"; 
      })
      .attr("height", 0)        
      .attr("y",function(d) {
        if (d.start == undefined) {
          return chart_dim + inner_padding;
        }       
        else { 
          return representation == 'radial' ? quant_scale( d.start ) : data_unit == 'sleep' ? quant_scale( d.start ) : quant_scale( d.end );
        }
      })       
      .attr("ry", function(d) {
        if (granularity == "week"){
          return chart_dim  / 7 / 8;
        }
        else if (granularity == "month"){
          return chart_dim  / 31 / 8;
        }
        else if (granularity == "year"){
          return chart_dim  / 366 / 8;
        }          
      });     

      data_element_enter.append("line")
      .attr('class','baseline_start');

      data_element_enter.append("line")
      .attr('class','baseline_end');
      
      /** DATE GUIDE ELEMENT UPDATE (Stage 1) */

      var date_guide_element_update = date_guide_elements;

      date_guide_element_update.attr("transform",function(d,i){
        if (representation == "linear") {
          var chron_pos = 0;
          if (granularity == "week"){
            chron_pos = chron_scale( moment(d.date_val).weekday() );
          }
          else if (granularity == "month"){
            chron_pos = chron_scale( moment(d.date_val).date() );
          }
          else if (granularity == "year"){
            chron_pos = chron_scale( moment(d.date_val).dayOfYear() );
          }
          return "translate(" + chron_pos + ",0)";
        }
        else { //representation == "radial"
          var rotation = -180;
          if (granularity == "week"){
            rotation += moment(d.date_val).weekday() / 7 * 360;
          }
          else if (granularity == "month"){
            rotation += (moment(d.date_val).date() - 1) / 31 * 360;
          }
          else if (granularity == "year"){
            rotation += (moment(d.date_val).dayOfYear() - 1) / 366 * 360;
          }
          return "translate(" + (chart_dim / 2) + "," + (chart_dim / 2) + ")rotate(" + rotation + ")";
        }          
      });

      date_guide_element_update.selectAll(".date_line")
      .attr('y1', function(){
        return representation == 'linear' ? 0 : (data_unit == 'sleep' ? quant_scale( 8 ) : quant_scale( guide_scale.ticks(5)[0] ));
      })
      .attr('y2', function(){
        return representation == 'linear' ? (chart_dim + chart_dim * 0.05) : quant_scale( quant_scale.domain()[1] ) * 0.95;
      })      
      .style("opacity", 0.5)
      .style("stroke",  "#ccc");  

      date_guide_element_update.select(".element_date")      
      .attr("transform", function(d){          
        if (representation == "radial") {
          var rotation = -180;
          if (granularity == "week"){
            rotation += moment(d.date_val).weekday() / 7 * 360;
          }
          else if (granularity == "month"){
            rotation += (moment(d.date_val).date() - 1) / 31 * 360;
          }
          else if (granularity == "year"){
            rotation += (moment(d.date_val).dayOfYear() - 1) / 366 * 360;
          }
          if (rotation < -90 || rotation > 90) {
            rotation = 180;
          }
          else {
            rotation = 0;
          }
          return ("translate(0," + (quant_scale( quant_scale.domain()[1] )) + ")rotate(" + rotation + ")");
        }
        else {
          return ("translate(0," + (-inner_padding + 25) + ")");
        }
      })
      .attr("dy", function(d){
        var dy_offset = 0;
        var rotation = 0;
        if (representation == "radial" && granularity == "week") {     
          rotation = moment(d.date_val).weekday() / 7 * 360;  
          if (rotation < 270 && rotation > 90) {
            dy_offset = "0em";
          }  
          else {
            dy_offset = "-1em";
          }
        }
        else if (representation == "radial" && granularity == "month") {     
          rotation = (moment(d.date_val).date() - 1) / 31 * 360;  
          if (rotation < 270 && rotation > 90) {
            dy_offset = "0em";
          }  
          else {
            dy_offset = "-1em";
          }
        }
        return dy_offset;
      });

      /**

      DATA ELEMENT UPDATE (STAGE 1)

      **/

      var data_element_update = data_elements;
      // .transition()
      // .delay(function(d,i){
      //   if (exit_direction == "right") {
      //     return (filtered_data.length - i) * transition_time * 0.5 / filtered_data.length;
      //   }
      //   else {
      //     return i * transition_time * 0.5 / filtered_data.length;
      //   }
      // })
      // .duration(transition_time)
      // .ease(d3.easeCubicIn);        

      data_element_update.attr("transform",function(d,i){
        if (representation == "linear") {
          var chron_pos = 0;          
          if (granularity == "week"){
            chron_pos = chron_scale( moment(d.date_val).weekday() );
          }
          else if (granularity == "month"){
            chron_pos = chron_scale( moment(d.date_val).date() );
          }
          else if (granularity == "year"){
            chron_pos = chron_scale( moment(d.date_val).dayOfYear() );
          }
          return "translate(" + chron_pos + ",0)";
        }
        else { //representation == "radial"
          var rotation = -180;         
          if (granularity == "week"){
            rotation += moment(d.date_val).weekday() / 7 * 360;
          }
          else if (granularity == "month"){
            rotation += (moment(d.date_val).date() - 1) / 31 * 360;
          }
          else if (granularity == "year"){
            rotation += (moment(d.date_val).dayOfYear() - 1) / 366 * 360;
          }
          return "translate(" + (chart_dim / 2) + "," + (chart_dim / 2) + ")rotate(" + rotation + ")";
        }          
      });

      data_element_update.selectAll('rect.baseline_value')   
      .attr("width", function(d) {
          if (granularity == "week"){
            return representation == 'linear' ? d3.max([2,chart_dim  / 7]) : d3.max([3,chart_dim  / 7 * 1.25]);
          }
          else if (granularity == "month"){
            return representation == 'linear' ? d3.max([2,chart_dim  / 31]) : d3.max([3,chart_dim  / 31 * 1.25]);
          }
          else if (granularity == "year"){
            return representation == 'linear' ? d3.max([1,chart_dim  / 366]) : d3.max([1,chart_dim  / 366]);
          }  
      })
      .attr("x", function(d) {
        if (granularity == "week"){
          return representation == 'linear' ? (-1 / 2) * chart_dim  / 7 : (- 0.625) * chart_dim  / 7;
        }
        else if (granularity == "month"){
          return representation == 'linear' ? (-1 / 2) * chart_dim  / 31 : (- 0.625) * chart_dim  / 31;
        }
        else if (granularity == "year"){
          return representation == 'linear' ? (-1 / 2) * chart_dim  / 366 : (- 0.5) * chart_dim  / 366;
        }  
      })
      .attr("ry", function(d) {
        if (granularity == "week"){
          return chart_dim  / 7 / 8;
        }
        else if (granularity == "month"){
          return chart_dim  / 31 / 8;
        }
        else if (granularity == "year"){
          return chart_dim  / 366 / 8;
        }          
      });

      data_element_update.selectAll('rect.observed_value')   
      .attr("width", function(d) {
        if (representation == 'linear') {
          if (granularity == "week"){
            return  d3.max([1.5,chart_dim  / 7 / 2]);
          }
          else if (granularity == "month"){
            return  d3.max([1.5,chart_dim  / 31 / 2]);
          }
          else if (granularity == "year"){
            return d3.max([1,chart_dim  / 366 / 2]);
          }       
        }
        else {
          if (granularity == "week"){
            return  d3.max([1.875,chart_dim  / 7 / 1.25]);
          }
          else if (granularity == "month"){
            return  d3.max([1.875,chart_dim  / 31 / 1.25]);
          }
          else if (granularity == "year"){
            return d3.max([1,chart_dim  / 366 / 2]);
          } 
        }
      })
      .attr("x", function(d) {
        if (representation == 'linear') {
          if (granularity == "week"){
            return (-1 / 2) * chart_dim  / 7 / 2;
          }
          else if (granularity == "month"){
            return (-1 / 2) * chart_dim  / 31 / 2;
          }
          else if (granularity == "year"){
            return (-1 / 2) * chart_dim  / 366 / 2;
          }    
        }
        else {
          if (granularity == "week"){
            return (-0.625) * chart_dim  / 7 / 1.5;
          }
          else if (granularity == "month"){
            return (-0.625) * chart_dim  / 31 / 1.5;
          }
          else if (granularity == "year"){
            return (-0.5) * chart_dim  / 366 / 2;
          } 
        }
      })
      .attr("ry", function(d) {
        if (granularity == "week"){
          return chart_dim  / 7 / 8;
        }
        else if (granularity == "month"){
          return chart_dim  / 31 / 8;
        }
        else if (granularity == "year"){
          return chart_dim  / 366 / 8;
        }          
      });     

      data_element_update.selectAll('line.baseline_start')
      .attr('x1', function(d){
        if (representation == 'linear') {
          if (granularity == "week"){
            return (-1 / 2) * chart_dim  / 7 / 2;
          }
          else if (granularity == "month"){
            return (-1 / 2) * chart_dim  / 31 / 2;
          }
          else if (granularity == "year"){
            return (-1 / 2) * chart_dim  / 366 / 2;
          }    
        }
        else {
          if (granularity == "week"){
            return (-0.625) * chart_dim  / 7 / 1.5;
          }
          else if (granularity == "month"){
            return (-0.625) * chart_dim  / 31 / 1.5;
          }
          else if (granularity == "year"){
            return (-0.5) * chart_dim  / 366 / 2;
          } 
        }
      })
      .attr('x2',function(d){
        if (representation == 'linear') {
          if (granularity == "week"){
            return  (-1 / 2) * chart_dim  / 7 / 2 + d3.max([1.5,chart_dim  / 7 / 2]);
          }
          else if (granularity == "month"){
            return (-1 / 2) * chart_dim  / 31 / 2 + d3.max([1.5,chart_dim  / 31 / 2]);
          }
          else if (granularity == "year"){
            return (-1 / 2) * chart_dim  / 366 / 2 + d3.max([1.5,chart_dim  / 366 / 2]);
          }       
        }
        else {
          if (granularity == "week"){
            return (-0.625) * chart_dim  / 7 / 1.5 + d3.max([1.875,chart_dim  / 7 / 1.25]);
          }
          else if (granularity == "month"){
            return (-0.625) * chart_dim  / 31 / 1.5 + d3.max([1.875,chart_dim  / 31 / 1.25]);
          }
          else if (granularity == "year"){
            return (-0.5) * chart_dim  / 366 / 2 + d3.max([1.5,chart_dim  / 366 / 2]);
          } 
        }
      })
      .attr('y1', function(d){
        if (d.start == undefined) {
          return chart_dim + inner_padding;
        }        
        else { 
          return representation == 'radial' ? quant_scale( d.end_baseline ) - 0.5 : data_unit == 'sleep' ? quant_scale( d.start_baseline ) + 0.5 : quant_scale( d.end_baseline ) + 0.5;
        }
      })
      .attr('y2',function(d){
        if (d.start == undefined) {
          return chart_dim + inner_padding;
        }        
        else { 
          return representation == 'radial' ? quant_scale( d.end_baseline ) - 0.5 : data_unit == 'sleep' ? quant_scale( d.start_baseline ) + 0.5 : quant_scale( d.end_baseline ) + 0.5;
        }
      });

      // .attr('height',function(d){
      //   return representation == 'radial' ? d3.max([quant_scale( d.end )  - quant_scale( d.start ),1]) : d3.max([Math.abs( quant_scale( d.end )  - quant_scale( d.start ) ),1]);
      // })      
      // .attr("y",function(d) {
      //   if (d.start == undefined) {
      //     return chart_dim + inner_padding;
      //   }
      //   
      //   else { 
      //     return representation == 'radial' ? quant_scale( d.start ) : quant_scale( d.end );
      //   }
      // })

      data_element_update.selectAll('line.baseline_end')
      .attr('x1',function(d){
        if (representation == 'linear') {
          if (granularity == "week"){
            return (-1 / 2) * chart_dim  / 7 / 2;
          }
          else if (granularity == "month"){
            return (-1 / 2) * chart_dim  / 31 / 2;
          }
          else if (granularity == "year"){
            return (-1 / 2) * chart_dim  / 366 / 2;
          }    
        }
        else {
          if (granularity == "week"){
            return (-0.625) * chart_dim  / 7 / 1.5;
          }
          else if (granularity == "month"){
            return (-0.625) * chart_dim  / 31 / 1.5;
          }
          else if (granularity == "year"){
            return (-0.5) * chart_dim  / 366 / 2;
          } 
        }
      })
      .attr('x2',function(d){
        if (representation == 'linear') {
          if (granularity == "week"){
            return (-1 / 2) * chart_dim  / 7 / 2 + d3.max([1.5,chart_dim  / 7 / 2]);
          }
          else if (granularity == "month"){
            return (-1 / 2) * chart_dim  / 31 / 2 + d3.max([1.5,chart_dim  / 31 / 2]);
          }
          else if (granularity == "year"){
            return (-1 / 2) * chart_dim  / 366 / 2 + d3.max([1.5,chart_dim  / 366 / 2]);
          }       
        }
        else {
          if (granularity == "week"){
            return (-0.625) * chart_dim  / 7 / 1.5 + d3.max([1.875,chart_dim  / 7 / 1.25]);
          }
          else if (granularity == "month"){
            return (-0.625) * chart_dim  / 31 / 1.5 + d3.max([1.875,chart_dim  / 31 / 1.25]);
          }
          else if (granularity == "year"){
            return (-0.5) * chart_dim  / 366 / 2 + d3.max([1.5,chart_dim  / 366 / 2]);
          } 
        }
      })
      .attr('y1', function(d){
        if (d.start == undefined) {
          return chart_dim + inner_padding;
        }       
        else { 
          return representation == 'radial' ? quant_scale( d.start_baseline ) : data_unit == 'sleep' ? quant_scale( d.start_baseline ) - 0.5 + d3.max([Math.abs( quant_scale( d.end_baseline ) - quant_scale( d.start_baseline ) ),1]) : quant_scale( d.end_baseline ) - 0.5 + d3.max([Math.abs( quant_scale( d.end_baseline )  - quant_scale( d.start_baseline ) ),1]);
        }
      })
      .attr('y2',function(d){
        if (d.start == undefined) {
          return chart_dim + inner_padding;
        }        
        else { 
          return representation == 'radial' ? quant_scale( d.start_baseline ) : data_unit == 'sleep' ? quant_scale( d.start_baseline ) - 0.5 + d3.max([Math.abs( quant_scale( d.end_baseline ) - quant_scale( d.start_baseline ) ),1]) : quant_scale( d.end_baseline ) - 0.5 + d3.max([Math.abs( quant_scale( d.end_baseline )  - quant_scale( d.start_baseline ) ),1]);
        }
      });

      /**

      DATE GUIDE ELEMENT UPDATE (STAGE 2)

      **/

      var date_guide_element_second_update = date_guide_elements;

      date_guide_element_second_update.select(".element_date_top")
      .text(function(d){   
        var date_label = "";
        switch (granularity) {

          case "week":            
            date_label = moment(d.date_val).format('ddd');
          break;

          case "month":
            date_label = moment(d.date_val).weekday() == 0 ? moment(d.date_val).format('ddd') : "";
          break;

          case "year":
            date_label = moment(d.date_val).format('MMM');
          break;

          default:
            date_label = "";
          break;
        }
        return date_label;  
      });
      
      date_guide_element_second_update.select(".element_date_bottom")
      .text(function(d){   
        var date_label = "";
        switch (granularity) {

          case "week":            
            date_label = moment(d.date_val).format('MMM D');
          break;         
          
          case "month":
            date_label = moment(d.date_val).weekday() == 0 ? moment(d.date_val).format('MMM D') : "";
          break;

          default:
            date_label = "";
          break;
        }
        return date_label;  
      });

      /**

      DATA ELEMENT UPDATE (STAGE 2)

      **/

      var data_element_second_update = data_elements;
      // .transition()
      // .delay(function(d,i){
      //   return transition_time * 1.5 + i * transition_time * 0.5 / filtered_data.length;
      // })
      // .duration(transition_time * 0.5)
      // .ease(d3.easeCubicInOut);

      data_element_second_update.select('rect.baseline_value')
      .attr('height',function(d){
        return d3.max([Math.abs( quant_scale( d.end_baseline )  - quant_scale( d.start_baseline ) ),1]);        
      })
      .attr("y",function(d) {
        if (d.start_baseline == undefined) {
          return chart_dim + inner_padding;
        }        
        else { 
          return representation == 'radial' ? quant_scale( d.start_baseline ) : data_unit == 'sleep' ? quant_scale( d.start_baseline ) : quant_scale( d.end_baseline );
        }
      });      

      data_element_second_update.select('rect.observed_value')
      .attr('height',function(d){
        return representation == 'radial' ? d3.max([quant_scale( d.end )  - quant_scale( d.start ),1]) : d3.max([Math.abs( quant_scale( d.end )  - quant_scale( d.start ) ),1]);
      })
      .style("fill", function(d) { 
        return "url(#linear_gradient_" + d.date_val +")";  
      })
      .attr("y",function(d) {
        if (d.start == undefined) {
          return chart_dim + inner_padding;
        }        
        else { 
          return representation == 'radial' ? quant_scale( d.start ) : data_unit == 'sleep' ? quant_scale( d.start ) : quant_scale( d.end );
        }
      });         
      
      /**

      DATA (GUIDE) ELEMENT EXIT

      **/

      date_guide_elements.exit()
      .remove();
      
      data_elements.exit()
      // .transition()
      // .duration(transition_time)
      // .attr("transform", function() {
      //   if (exit_direction == "right") {
      //     return "translate(" + svg_dim + ",0)";
      //   }
      //   else {
      //     return "translate(" + -svg_dim + ",0)";
      //   }

      // }) 
      .remove();      

      /** GUIDE ENTER **/

      var guide_bounds = data_unit == 'sleep' ? [8,15,22] : guide_scale.ticks(5);
      // guide_bounds = guide_bounds.concat(guide_scale.ticks(5)[guide_scale.ticks(5).length - 1]); 
      
      var guide = d3.select(this).selectAll(".guide")
      .data(guide_bounds, function(d,i) {
        return d;
      });

      var guide_enter = guide.enter()
      .append('g')
      .attr('class','guide')
      .attr('id', function(d) {
        return 'guide_' + d;
      });

      guide_enter.append('line')
      .attr('class','guide_line')
      .style('opacity', 0);

      guide_enter.append('circle')
      .attr('class','guide_circle')
      .style('opacity', 0);

      guide_enter.append('text')
      .attr('class','guide_label')
      // .attr('filter','url(#solid)')
      .style('opacity', 0);

      /** GUIDE UPDATE **/

      var guide_update = guide;
      // .transition()
      // .duration(transition_time)
      // .ease(d3.easeCubicInOut);

      guide_update.selectAll('.guide_line')
      .attr('x1',0)
      .attr('x2',chart_dim)
      .attr('y1', function(d) {
        return quant_scale(d);
      })
      .attr('y2', function(d) {
        return quant_scale(d);
      })
      .style('opacity', function(d,i){
        return (representation == 'linear') ? 0.5 : 0;
      });

      guide_update.selectAll('.guide_circle')
      .attr('cx',chart_dim / 2)
      .attr('cy',chart_dim / 2)
      .attr('r', function(d) {
        return quant_scale(d);
      })
      .style('opacity', function(d,i){
        return (representation == 'radial') ? 0.5 : 0;
      });

      guide_update.selectAll('.guide_label')
      .attr('x', function(d){       
        return representation == 'radial' ? chart_dim / 2 : 0 - inner_padding + 15;
      })
      .attr('y', function(d){
        return representation == 'radial' ? chart_dim / 2 + quant_scale(d) : quant_scale(d);
      })
      .attr('text-anchor', "middle")
      .attr('alignment-baseline','middle')
      .style('opacity', 1)
      .text(function(d,i){
        if (d == 0) {
          return "";
        }
        else {          
          var label = "";
          switch (data_unit) {
            
            case 'temperature':
              label = d + "°F"; 
            break;

            case 'sleep':
              if (d < 0) {
                label = "";
              }
              else if (d == 12) {
                label = d + " AM";
              }
              else if (d == 24) {
                label = (d - 12) + "PM";
              }
              else if (d > 24) {
                label = (d - 24) + "PM";
              }
              else {
                label = d > 12 ? (d - 12) + " AM" : d + " PM";
              }
            break;            

            default:
              label = d;
            break;

          }
          return label;
        }
      });

      /** GUIDE EXIT **/

      var guide_exit = guide.exit()
      // .transition()
      // .duration(transition_time)
      .remove();

      /** 
       * 
       * OVERLAY ENTER 
       * 
      **/
      
      d3.selectAll('.overlay').remove();
      
      d3.select(this).append('rect')
      .attr('class','overlay')
      .attr('width',svg_dim)
      .attr('height',svg_dim)
      .attr('x',-inner_padding)
      .attr('y',-inner_padding)
      .on('touchstart',touchdown)  
      .on('touchmove',touchdown)
      .on('touchend',touchend);
      
      /** 
      
      INTERACTION 
      
      **/

      var focus = d3.select(this).append("g")
      .attr("class", "focus")
      .style("display", "none");

      focus.append("line")
      .attr('class','focus_line')
      .attr('id','focus_line_lower')
      .attr('stroke-dasharray',"0.5em")
      .attr('x1',0 - inner_padding)
      .attr('x2',chart_dim + inner_padding)
      .attr('y1',0)
      .attr('y2',0)
      .style('opacity',0);  

      focus.append("line")
      .attr('class','focus_line')
      .attr('id','focus_line_upper')      
      .attr('stroke-dasharray',"0.5em")
      .attr('x1',0 - inner_padding)
      .attr('x2',chart_dim + inner_padding)
      .attr('y1',0)
      .attr('y2',0)
      .style('opacity',0);  

      focus.append("circle")
      .attr('class','focus_circle')
      .attr('id','focus_circle_inner')      
      .attr('stroke-dasharray',"0.5em")
      .attr('cx',chart_dim / 2)
      .attr('cy',chart_dim / 2)
      .attr("r", 0)
      .style('opacity',0);

      focus.append("circle")
      .attr('class','focus_circle')
      .attr('id','focus_circle_outer')
      .attr('stroke-dasharray',"0.5em")
      .attr('cx',chart_dim / 2)
      .attr('cy',chart_dim / 2)
      .attr("r", 0)
      .style('opacity',0);

      var focus_width = granularity == 'year' ? (366 / 31) : granularity == 'month' ? (31 / 3) : 7; 

      if (representation == 'linear') {
        focus.append('rect')
        .attr('class','touch_line')
        .attr('stroke-dasharray',"0.5em")
        .attr("x",(-1 / 2) * chart_dim  / focus_width)      
        .attr("width",(chart_dim  / focus_width))
        .attr('y', function(){
          return representation == 'linear' ? (0 - inner_padding + 2) : 0;
        })
        .attr('height', function(){
          return representation == 'linear' ? (chart_dim + 2 * inner_padding - 4) : chart_dim;
        });
      }
      else {        
        focus.append('path')
        .attr('class','touch_line')
        .attr('stroke-dasharray',"0.5em")
        .attr('d',d3.arc()
          .innerRadius( chart_dim / 14 )
          .outerRadius(chart_dim * 0.5 + inner_padding + 2)
          .startAngle(0 - 0.5 * (Math.PI * 2 / focus_width))
          .endAngle(0 + 0.5 * (Math.PI * 2 / focus_width))
          // .startAngle(-180 + (1 * (Math.PI * 2 / focus_width)))
          // .endAngle(-180 + (2 * (Math.PI * 2 / focus_width)))
        );
      }      
      
      focus.append('rect')
      .attr('width',inner_padding * 2.5)
      .attr('ry',5)
      .attr('height',25)
      .attr('id','touch_line_rect')
      .attr('class','focus_rect')
      .attr("x", -inner_padding * 0.75)
      .attr("y", "-3.625em");

      focus.append("text")
      .attr('class','touch_line_text')
      .attr('text-anchor', "middle")
      .attr('alignment-baseline','middle')
      .attr("dy", "-4em"); 

      focus.append('rect')
      .attr('id','touch_rect')
      .attr('width',inner_padding)
      .attr('ry',5)
      .attr('height',25)
      .attr('class','focus_rect')
      .attr("x", -inner_padding * 0.5)
      .attr("y", -12.5);
      
      focus.append("text")
      .attr('class','focus_text')
      .attr('text-anchor', "middle")
      .attr('alignment-baseline','middle')
      .attr("dy", "0em"); 

      function touchdown() {

        d3.selectAll('.hint').remove();      
        
        d3.event.preventDefault();
        d3.event.stopPropagation();
        var d = d3.touches(this);
        var x = d[0][0];
        var y = d[0][1];
        var r = 0;        

        focus.style('display',null);

        focus.select('.touch_line_text')
        .style('display',(suppress_touch_val_feedback || suppress_touch_feedback) ? 'none' : null)
        .attr("transform", "translate(" + x + "," + y + ")");
        
        var touch_data = "";
        touch_day = NaN;             

        if (representation == 'linear') {  
          if (granularity == 'week') {
            touch_day = x < chart_dim + chart_dim / 7 && x > 0 - chart_dim / 7 ? Math.round(chron_scale.invert(x)) : NaN;
          }       
          else if (granularity == 'month') {
            touch_day = x < chart_dim && x > 0 - chart_dim / 31 ? Math.floor(chron_scale.invert(x)) : NaN;
          }
          else {
            touch_day = x < chart_dim && x > 0 - chart_dim / 366 ? Math.floor(chron_scale.invert(x)) : NaN;
          }
        }
        else {
          adjusted_x = x - ( chart_dim / 2 );
          adjusted_y = y - ( chart_dim / 2 );
          r = Math.sqrt( ( adjusted_x * adjusted_x ) + ( adjusted_y * adjusted_y ) );
          angle = Math.atan2( adjusted_y, adjusted_x );
          angle_in_degrees = ( Math.atan2( adjusted_y, adjusted_x ) + ( Math.PI / 2 ) ) * ( 360 / ( Math.PI * 2 ) );
                    
          switch (granularity) {
            case 'week':
              if (angle_in_degrees < -360 / 14) {
                angle_in_degrees += 360;
              }
              else {
                angle_in_degrees = Math.abs(angle_in_degrees);
              }
              touch_day = Math.round(angle_in_degrees / 360 * 7 + 1);
            break;

            case 'month':
              if (angle_in_degrees < -360 / 62) {
                angle_in_degrees += 360;
              }
              else {
                angle_in_degrees = Math.abs(angle_in_degrees);
              }
              touch_day = Math.round(angle_in_degrees / 360 * 31);
            break;

            case 'year':
              if (angle_in_degrees < -360 / 732) {
                angle_in_degrees += 360;
              }
              else {
                angle_in_degrees = Math.abs(angle_in_degrees);
              }
              touch_day = Math.round(angle_in_degrees / 360 * 366);
            break;

            default: 
              touch_day = Math.round(angle_in_degrees);
            break;
          }
        }

        if (suppress_touch_val_feedback && suppress_touch_feedback && introduction_complete && !compareBetween_complete) {
          d3.select('#submit_btn')
          .attr('disabled',true)
          .attr('class','menu_btn_disabled');
        }               
        else if (!isNaN(touch_day)) {
          d3.select('#submit_btn')
          .attr('disabled',null)
          .attr('class','menu_btn_enabled');
        }
        else {
          d3.select('#submit_btn')
          .attr('disabled',true)
          .attr('class','menu_btn_disabled');
        }

        focus.select('#touch_line_rect')
        .style("display", function() {
          return (!isNaN(touch_day) && !(suppress_touch_val_feedback || suppress_touch_feedback)) ? null : "none";
        })
        .attr("transform", "translate(" + (x - inner_padding / 2) + "," + y + ")");

        var touch_val = representation == 'linear' ? y : r;
        touch_value = quant_scale.invert(touch_val);

        focus.select('#touch_rect')
        .style("display", function() {
          return (!isNaN(touch_day) && !(suppress_touch_val_feedback || suppress_touch_feedback)) ? null : "none";
        })
        .attr("transform", function() {
          return representation == 'linear' ? "translate(" + (0 - inner_padding * 0.5 ) + "," + y + ")" : "translate(" + (chart_dim / 2) + "," + (chart_dim / 2 + r) + ")";
        });

        focus.select('.focus_text')
        .style('display',(suppress_touch_val_feedback || suppress_touch_feedback) ? 'none' : null)
        .attr("transform", function() {
          return representation == 'linear' ? "translate(" + (0 - inner_padding + 20) + "," + y + ")" : "translate(" + (chart_dim / 2) + "," + (chart_dim / 2 + r) + ")";
        }); 
        
        switch (data_unit) {
          
          case 'temperature': 
            touch_data = Math.round(quant_scale.invert(touch_val)) + "°F"; 
          break;

          case 'sleep':
            if (Math.floor(quant_scale.invert(touch_val)) < 0 || Math.round(quant_scale.invert(touch_val)) >= 36) {
              touch_data = "";
            }
            else if (Math.round(quant_scale.invert(touch_val)) == 12) {
              touch_data = Math.round(quant_scale.invert(touch_val)) + " AM";
            }
            else if (Math.round(quant_scale.invert(touch_val)) == 24) {
              touch_data = (Math.round(quant_scale.invert(touch_val)) - 12) + " PM";
            }
            else if (Math.round(quant_scale.invert(touch_val)) > 24) {
              touch_data = (Math.round(quant_scale.invert(touch_val)) - 24) + " PM";
            }
            else {
              touch_data = Math.round(quant_scale.invert(touch_val)) > 12 ? (Math.round(quant_scale.invert(touch_val)) - 12) + " AM" : Math.round(quant_scale.invert(touch_val)) + " PM";
            }
          break;

          default:
            touch_data = Math.round(quant_scale.invert(touch_val));
          break;
        }

        switch (granularity) {

          case 'week':
            d3.selectAll('.data_element').each(function(d) {
                  
              touch_date = moment(filtered_data[0].date_val).startOf('week').add(representation == 'linear' ? touch_day : touch_day - 1,'d').format('ddd MMM D YYYY');
              if (moment(d.date_val).format('ddd MMM D YYYY') == touch_date) {
                touch_day_start_end = {
                  'start':d.start,
                  'end':d.end
                };
              }
            });               
            
          break;

          case 'month':
            touch_date = moment(filtered_data[0].date_val).startOf('month').add(touch_day,'d').format('ddd MMM D YYYY');
            d3.selectAll('.data_element').each(function(d) {
              if (moment(d.date_val).format('ddd MMM D YYYY') == touch_date) {
                touch_day_start_end = {
                  'start':d.start,
                  'end':d.end
                };
              }
            }); 
          break;

          case 'year':
            touch_date = moment(filtered_data[0].date_val).startOf('year').add(touch_day,'d').format('ddd MMM D YYYY');
            d3.selectAll('.data_element').each(function(d) {
              if (moment(d.date_val).format('ddd MMM D YYYY') == touch_date) {
                touch_day_start_end = {
                  'start':d.start,
                  'end':d.end
                };
              }
            });
          break;

          default:
            touch_date = touch_day; 
          break;
        }


        focus.select('.touch_line')
        .style('stroke',function(){
          return (!isNaN(touch_day) && !suppress_touch_feedback) ? 'gold' : 'transparent';
        })
        .attr("transform",function(){
          if (representation == "linear") {
            var chron_pos = 0;
            if (granularity == "week"){
              chron_pos = chron_scale( moment(filtered_data[0].date_val).startOf('week').add(touch_day,'d').weekday() );
            }
            else if (granularity == "month"){
              chron_pos = chron_scale( moment(filtered_data[0].date_val).startOf('month').add(touch_day,'d').date() );
            }
            else if (granularity == "year"){
              chron_pos = chron_scale( moment(filtered_data[0].date_val).startOf('year').add(touch_day,'d').dayOfYear() );
            }
            return "translate(" + chron_pos + ",0)";
          }
          else { //representation == "radial"
            var rotation = 0;
            if (granularity == "week"){
              rotation += moment(filtered_data[0].date_val).startOf('week').add(touch_day - 1,'d').weekday() / 7 * 360;
            }
            else if (granularity == "month"){
              rotation += moment(filtered_data[0].date_val).startOf('month').add(touch_day - 1,'d').date() / 31 * 360;
            }
            else if (granularity == "year"){
              rotation += moment(filtered_data[0].date_val).startOf('year').add(touch_day - 1,'d').dayOfYear() / 366 * 360;
            }
            return "translate(" + (chart_dim / 2) + "," + (chart_dim / 2) + ")rotate(" + rotation + ")";
          }          
        });

        focus.select(".touch_line_text").text(function(){
          return !isNaN(touch_day) ? touch_date : "";
        });

        focus.select(".focus_text").text(function(){
          return !isNaN(touch_day) ? touch_data : "";
        });

        if (representation == 'linear') {
          focus.select('#focus_line_lower')
          .attr('y1',touch_val - chart_dim / 20 -2) 
          .attr('y2',touch_val - chart_dim / 20 - 2)
          .style('opacity',suppress_touch_val_feedback ? 0 : 1);

          focus.select('#focus_line_upper')
          .attr('y1',touch_val + chart_dim / 20 + 2)
          .attr('y2',touch_val + chart_dim / 20 + 2)
          .style('opacity',suppress_touch_val_feedback ? 0 : 1);
        }
        else {
          focus.select('#focus_circle_inner')
          .attr('r',d3.max([chart_dim / 40 + chart_dim / 40,touch_val - chart_dim / 40]) - 2)
          .style('opacity',suppress_touch_val_feedback ? 0 : 1);

          focus.select('#focus_circle_outer')
          .attr('r',d3.max([chart_dim / 20 + chart_dim / 20,touch_val + chart_dim / 40]) + 2)
          .style('opacity',suppress_touch_val_feedback ? 0 : 1);
        }
        
      }   

      function touchend() {

        focus.select('.touch_line_text')
        .style('display','none');

        focus.select('#touch_line_rect')
        .style('display','none');

        focus.select('#touch_rect')
        .style('display', 'none');

        focus.select('.focus_text')
        .style('display', 'none');

        focus.selectAll('.focus_line')
        .style('opacity', (suppress_touch_feedback && representation == 'linear') ? (suppress_touch_val_feedback ? 0: 1) : 0);
        
        focus.selectAll('.focus_circle')
        .style('opacity', (suppress_touch_feedback && representation == 'radial') ? (suppress_touch_val_feedback ? 0: 1) : 0);

        d3.event.preventDefault();
        d3.event.stopPropagation();
        // focus.style("display", 'none');
      }
      
    });
  }

  /**

  PRIVATE HELPER FUNCTIONS

  **/

  /**

  PUBLIC HELPER FUNCTIONS

  **/

  /**

  GETTER / SETTER FUNCTIONS

  **/  

  //getter / setter for radial / linear representation
  rangeChart.representation = function (x) {
    if (!arguments.length) {
      return representation;
    }
    representation = x;
    return rangeChart;
  };

  //getter / setter for temporal granularity
  rangeChart.granularity = function (x) {
    if (!arguments.length) {
      return granularity;
    }
    granularity = x;
    return rangeChart;
  };

  //getter / setter for exit_direction
  rangeChart.exit_direction = function (x) {
    if (!arguments.length) {
      return exit_direction;
    }
    exit_direction = x;
    return rangeChart;
  };

  //getter / setter for chron_scale
  rangeChart.chron_scale = function (x) {
    if (!arguments.length) {
      return chron_scale;
    }
    chron_scale = x;
    return rangeChart;
  };

  //getter / setter for quant_scale
  rangeChart.quant_scale = function (x) {
    if (!arguments.length) {
      return quant_scale;
    }
    quant_scale = x;
    return rangeChart;
  };

  //getter / setter for guide_scale
  rangeChart.guide_scale = function (x) {
    if (!arguments.length) {
      return guide_scale;
    }
    guide_scale = x;
    return rangeChart;
  };

  return rangeChart;

};

/**
 * Returns a number if not-nan, 0 otherwise
 * @param {number} num The number to unnan
 * @returns {number} The number or 0 if the number is NaN
 */
function unNaN(num) {
  return (isNaN(num) ? 0 : num) || 0;
}

module.exports = d3.rangeChart;