var d3 = require("d3");
var globals = require("./globals");

function consent (scene) {  
  
  /** INIT **/
  
  d3.select('body').append('div')
  .attr('id','consent_div')
  .attr('tabindex',0);  

  var consent_content_div = d3.select('#consent_div').append('div')
  .attr('class','toolbar')
  .style('width','100%')
  .style('height',(window.innerHeight - 50) + 'px')
  .attr('id','consent_content_div');  

  switch (scene) {

    case 0:

      consent_content_div.append('span')
      .attr('class','consent_text')
      .html('<span class="instruction_emphasis">MICROSOFT RESEARCH<br>Study Participation Consent Form</span><br>' +
      '<span style="text-align:left; font-size:0.9em;"><p>Thank you for deciding to volunteer in a Microsoft Research study. The researchers are studying how different chart designs help with respect to the perception of quantitative ranges over time. Please note that you have no obligation to participate and you may decide to terminate your participation at any time. What follows is a description of the research project, and your consent to participate. Please read this information carefully.</p></span>');    
      
      d3.select('#consent_div')
      .style('visibility','visible');

    break;
    
    case 1:

      consent_content_div.append('span')
      .attr('class','consent_text')
      .html(
        '<span class="instruction_emphasis">Title of Research Project:</span><br>' +
        '<span style="text-align:left; font-size:0.9em;"><p><em>The Visual Comparison of Ranges Over Time on Mobile Displays</em></p></span>' +
        '<span class="instruction_emphasis">Benefits and Risks:</span><br>' +
        '<span style="text-align:left; font-size:0.9em;"><p>This study will inform the design of charts that show quantitative ranges over time.</p></span>'
        
      );    
      
      d3.select('#consent_div')
      .style('visibility','visible');

    break;

    case 2:
    
      consent_content_div.append('span')
      .attr('class','consent_text')
      .html(         
        '<span class="instruction_emphasis">Procedure:</span><br>' +
        '<span style="text-align:left; font-size:0.9em;"><p>The experiment will take approximately <span class="instruction_emphasis">30 minutes</span> to complete and will involve interacting with six chart designs to perform a series of tasks. Sessions will be logged anonymously to calculate accuracy and response times. The study procedure is as follows:</p>' +
        '<ol>' +
        '<li> An introductory tutorial;' +
        '<li> <span class="instruction_emphasis">5 tasks</span>, with <span class="instruction_emphasis">up to 32 trials</span> for each task; each trial is expected to take a few seconds to complete;' +
        '<li> A survey containing <span class="instruction_emphasis">9</span> questions.' +
       
        '</ol></span>'
        
      );    
      
      d3.select('#consent_div')
      .style('visibility','visible');

    break;

    case 3:
    
      consent_content_div.append('span')
      .attr('class','consent_text')
      .html(         
        '<span class="instruction_emphasis">Research Data:</span><br>' +
        '<span style="text-align:left; font-size:0.9em;"><p>In this study, we will <span class="instruction_emphasis">NOT</span> be collecting any personal information about you.</p></span>' + 
        '<span style="text-align:left; font-size:0.7em;"><p>You give your permission to our research team at Microsoft Research to collect information about your participation in the research project in the formats and medium ("Data") described previously. Microsoft shall control all Data in connection with the research project. You may also provide suggestions, comments or other feedback ("Feedback") to Microsoft with respect to the research project. Feedback is entirely voluntary and the research team at Microsoft shall be free to use, disclose, license, or otherwise distribute, and exploit the Feedback and Data as authorized by the research participant. If you work for Microsoft, no Data or Feedback collected from you will be shared directly with anyone in your management chain.</p>' + '</span>'        
      );    
      
      d3.select('#consent_div')
      .style('visibility','visible');

    break;

    case 4:
    
      consent_content_div.append('span')
      .attr('class','consent_text')
      .html(         
        '<span class="instruction_emphasis">Your Authority to Participate:</span><br>' +
        '<span style="text-align:left; font-size:0.7em;"><p>You represent that you have the full right and authority to agree to this statement, and if you are a minor that you have the consent (as indicated below) of your legal guardian to sign and acknowledge this form. You assume the full risk of any injuries, damages, or losses you may sustain as a result of your participation in the project. In addition, you agree to release and hold harmless Microsoft and its affiliates from any and all claims that you may have now or in the future related to or arising from your participation in the research project, and you hereby waive all such claims. Microsoft will not be liable for any damages related to your participation in the project. By agreeing below, you confirm that you understand what the project is about and how and why it is being done. Should you have any questions concerning this project, please contact the supervising researcher, Bongshin Lee (bongshin@microsoft.com).</p></span>' + '<span style="text-align:left; font-size:0.9em;"><p>Please confirm your acceptance by tapping the "<span class="instruction_emphasis">I AGREE</span>" button below.</p></span>'        
      );    
      
      d3.select('#consent_div')
      .style('visibility','visible');

    break;
    
    default: // return to main menu

      d3.select('#consent_div').remove();
      if (document.getElementById('consent_div') != undefined) {      
        document.getElementById('consent_div').remove(); 
      }
      // appInsights.trackEvent("ConsentComplete", { 
      //   "TimeStamp": new Date().valueOf(),
      //   "Event": "ConsentComplete",
      //   "user_id": userID
      // });
      
      consent_complete = true;
      loadMenu();
      hideAddressBar();   

    break;
  }
  
  d3.select('#consent_div').append('input')
  .attr('class', 'menu_btn_enabled')
  .attr('id','submit_btn')
  .attr('type','button')
  .attr('value', scene == 4 ? 'I AGREE' : 'NEXT')
  .attr('title', scene == 4 ? 'I AGREE' : 'NEXT')
  .on('touchstart', function() {    
    
    d3.select('#consent_div').remove();
    if (document.getElementById('consent_div') != undefined) {      
      document.getElementById('consent_div').remove(); 
    }

    // appInsights.trackEvent("Consent", { 
    //   "TimeStamp": new Date().valueOf(),
    //   "user_id": userID,
    //   "Event": "Consent",
    //   "Scene": scene + 1
    // });
    consent(scene + 1);
  });
 
}

module.exports = consent;
