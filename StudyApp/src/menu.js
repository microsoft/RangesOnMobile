var d3 = require("d3");
var globals = require("./globals");

function menu () {
    
  /** INIT **/
  
  d3.select('body').append('div')
  .attr('id','menu_div')
  .attr('tabindex',0);  

  var instruction_div = d3.select('#menu_div').append('div')
  .attr('class','toolbar')
  .attr('id','instruction_div')
  .style('height','50px');  

  instruction_div.append('span')
  .attr('id','instruction_text')
  .html('<span class="instruction_emphasis"><span class="instruction_emphasis" id="secret_sandbox">VISUALIZING</span> RANGES ON MOBILE DEVICES</span>');
  
  var navbar = d3.select('#menu_div').append('div')
  .attr('class','toolbar')
  .attr('id','navbar');

  navbar.append("input")
  .attr('class', test_override || !consent_complete ? 'menu_btn_enabled' : 'menu_btn_disabled')
  .attr('disabled', test_override || !consent_complete ? null : true)
  .attr('id','consent_btn')    
  .attr('type','button')
  .attr('value','1. Consent to Participate')
  .attr('title', '1. Consent to Participate');

  navbar.append("input")
  .attr('class', test_override || (!introduction_complete && consent_complete) ? 'menu_btn_enabled' : 'menu_btn_disabled')
  .attr('disabled', test_override || (!introduction_complete && consent_complete) ? null : true)
  .attr('id','introduction_btn')    
  .attr('type','button')
  .attr('value','2. Introduction to the Study')
  .attr('title', '2. Introduction to the Study');
  
  navbar.append("input")
  .attr('class', test_override || (!locateDate_complete && introduction_complete) ? 'menu_btn_enabled' : 'menu_btn_disabled')
  .attr('disabled', test_override || (!locateDate_complete && introduction_complete) ? null : true)
  .attr('id','locate_dates_btn')
  .attr('type','button')
  .attr('value','3. Locating Dates')
  .attr('title', '3. Locating Dates');

  navbar.append("input")
  .attr('class', test_override || (!readValue_complete && locateDate_complete) ? 'menu_btn_enabled' : 'menu_btn_disabled')
  .attr('disabled', test_override || (!readValue_complete && locateDate_complete) ? null : true)
  .attr('id','read_values_btn')
  .attr('type','button')
  .attr('value','4. Reading Values')
  .attr('title', '4. Reading Values');
  
  navbar.append("input")
  .attr('class', test_override || (!locateMinMax_complete && readValue_complete) ? 'menu_btn_enabled' : 'menu_btn_disabled')
  .attr('disabled', test_override || (!locateMinMax_complete && readValue_complete) ? null : true)
  .attr('id','locate_minmax_btn')
  .attr('type','button')
  .attr('value','5. Locating Minimums & Maximums')
  .attr('title', '5. Locating Minimums & Maximums');
  
  navbar.append("input")
  .attr('class', test_override || (!compareWithin_complete && locateMinMax_complete) ? 'menu_btn_enabled' : 'menu_btn_disabled')
  .attr('disabled', test_override || (!compareWithin_complete && locateMinMax_complete) ? null : true)
  .attr('id','compare_within_btn')  
  .attr('type','button')
  .attr('value','6. Comparing Daily Values')
  .attr('title', '6. Comparing Daily Values');

  navbar.append("input")
  .attr('class', test_override || (!compareBetween_complete && compareWithin_complete) ? 'menu_btn_enabled' : 'menu_btn_disabled')
  .attr('disabled', test_override || (!compareBetween_complete && compareWithin_complete) ? null : true)
  .attr('id','compare_between_btn')  
  .attr('type','button')
  .attr('value','7. Comparing Ranges')
  .attr('title', '7. Comparing Ranges');

  navbar.append("input")
  .attr('class', test_override || compareBetween_complete ? 'menu_btn_enabled' : 'menu_btn_disabled')
  .attr('disabled', test_override || compareBetween_complete ? null : true)
  .attr('id','questionnaire_btn')    
  .attr('type','button')
  .attr('value','8. Survey & Conclusion')
  .attr('title', '8. Survey & Conclusion');

  // navbar.append("input")
  // .attr('id','sandbox_btn')
  // .attr('class', 'menu_btn_enabled')
  // .attr('type','button')
  // .attr('value','( sandbox for testing )')
  // .attr('title', '( sandbox for testing )');  
}

module.exports = menu;
