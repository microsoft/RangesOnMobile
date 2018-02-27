var d3 = require("d3");
var moment = require("moment");
var globals = require("./globals");
var initTasks = require("./initTasks");
var sandbox = require("./sandbox");
var menu = require("./menu");     
var consent = require("./consent");
var introduction = require("./introduction");
var locateDates = require("./tasks/locateDates");
var readValues = require("./tasks/readValues");
var locateMinMax = require("./tasks/locateMinMax");
var compareWithin = require("./tasks/compareWithin");
var compareBetween = require("./tasks/compareBetween");
var questionnaire = require("./questionnaire");

function setCookie (c_name, value, exdays)
{
  var exdate = new Date();
  exdate.setDate(exdate.getDate() + exdays);
  var c_value = escape(value) + ((exdays==null) ? "" : "; expires="+exdate.toUTCString());
  document.cookie = c_name + "=" + c_value;
}

function getCookie (c_name)
{
   var i,x,y,ARRcookies=document.cookie.split(";");
   for (i=0;i<ARRcookies.length;i++)
    {
       x=ARRcookies[i].substr(0,ARRcookies[i].indexOf("="));
          y=ARRcookies[i].substr(ARRcookies[i].indexOf("=")+1);
          x=x.replace(/^\s+|\s+$/g,"");
          if (x==c_name)
          {
              return unescape(y);
          }
    }
 }

// window.appInsights = appInsights;    

// appInsights.queue.push(function () {

//   appinsights.context.addTelemetryProcessor(function (envelope) {
//     console.log(envelope);

//   });

//   appInsights.context.addTelemetryInitializer(function (envelope) {

//     envelope.data.baseData.client_IP = 'censored';
//     envelope.data.baseData.clientip = 'censored';

//     // // To set custom properties:
//     envelope.data.baseData.properties = envelope.data.baseData.properties || {};
//     envelope.data.baseData.properties.clientWidth = window.innerWidth;
//     envelope.data.baseData.properties.clientHeight = window.innerHeight;

//     // // To set custom metrics:
//     // telemetryItem.measurements = telemetryItem.measurements || {};
//     // telemetryItem.measurements["globalMetric"] = 100;
//   });
// });

/* jshint ignore:end */

initTasks();

window.addEventListener('load', function() {    
  
  // appInsights.trackPageView('index.html');  
  
  hideAddressBar();   

  last_pause = new Date().valueOf();

  resumptions.push({
    'resumption_time': new Date().valueOf() + 1,
    'pause_time': last_pause,
    'pause_duration': 1
  }); //app resumed

  if (window.innerHeight < window.innerWidth) {
    
    d3.select('body').append('input')
    .attr('id','landscape_btn')
    .attr('type','button')
    .style('color','#111')
    .style('background','#ef5350')
    .style('border-color','#fff')
    .attr('value','Hold your phone in portrait mode.')
    .attr('title','Hold your phone in portrait mode.')
    .on('touchstart', function() {  
      d3.select('#landscape_btn').remove();
    }); 

    // appInsights.trackEvent("Load", { 
    //   "TimeStamp": new Date().valueOf(),
    //   "user_id": userID, 
    //   "Event":"Load",
    //   "Width": window.innerWidth, 
    //   "Height": window.innerHeight,
    //   "Mode": 'landscape' 
    // });

  }
  else {    

    // appInsights.trackEvent("Load", { 
    //   "TimeStamp": new Date().valueOf(),
    //   "Event": "Load",
    //   "user_id": userID, 
    //   "Width": window.innerWidth, 
    //   "Height": window.innerHeight,
    //   "Mode": 'portrait' 
    // });
  }

  // appInsights.trackEvent("InitTasks", { 
  //   "TimeStamp": new Date().valueOf(),
  //   "Event": "InitTasks",
  //   "user_id": userID, 
  //   "Datatype": locateDateTaskList[0].datatype, 
  //   "FirstRepresentation": locateDateTaskList[0].representation
  // });
  
});  

window.onfocus = function(e) {
  var r_time = new Date().valueOf();
  if (resumptions.length == 0 || last_pause > resumptions[resumptions.length - 1].resumption_time && window.innerHeight > window.innerWidth) {
    resumptions.push({
      'resumption_time': r_time,
      'pause_time': last_pause,
      'pause_type':'focus',
      'pause_duration': r_time - last_pause
    }); //app resumed
  }
  console.log(resumptions[resumptions.length - 1]);  
  // appInsights.trackEvent("InFocus", { 
  //   "TimeStamp": new Date().valueOf(),
  //   "user_id": userID, 
  //   "Event": "InFocus",
  //   "Focus": true ,
  //   'resumption_time': r_time,
  //   'pause_time': last_pause,
  //   'pause_type': 'focus',
  //   'pause_duration': r_time - last_pause
  // });
};

window.onblur = function(e) {
  if (resumptions.length == 0 || resumptions[resumptions.length - 1].resumption_time > last_pause) {
    last_pause = new Date().valueOf(); //app paused
  }
  console.log('FocusLoss'); 
  // appInsights.trackEvent("FocusLoss", { 
  //   "TimeStamp": new Date().valueOf(),
  //   "Event": "FocusLoss",
  //   "user_id": userID, 
  //   "Focus": false 
  // });
};

window.onbeforeunload = function() { return "Your work will be lost."; };

window.onresize = function(e) {
  
  d3.select('#landscape_btn').remove();

  if (document.getElementById('landscape_btn')) {
    document.getElementById('landscape_btn').remove();
  }
  hideAddressBar();

  if (window.innerHeight < window.innerWidth) {
    if (resumptions[resumptions.length - 1].resumption_time > last_pause) {
      last_pause = new Date().valueOf(); //app paused
    }
    console.log('Resized: landscape'); 
    // appInsights.trackEvent("Resized", { 
    //   "TimeStamp": new Date().valueOf(),
    //   "user_id": userID, 
    //   "Event": "Resized",
    //   "Width": window.innerWidth, 
    //   "Height": window.innerHeight,
    //   "Mode": 'landscape' 
    // });

    d3.select('body').append('input')
    .attr('id','landscape_btn')
    .attr('type','button')
    .style('color','#111')
    .style('background','#ef5350')
    .style('border-color','#fff')
    .attr('value','Hold your phone in portrait mode.')
    .attr('title','Hold your phone in portrait mode.')
    .on('touchstart', function() {  
      d3.select('#landscape_btn').remove();
    });        
    
  }
  else {
    d3.select('#landscape_btn').remove();
    if (document.getElementById('landscape_btn')) {
      document.getElementById('landscape_btn').remove();
    }
    var r_time = new Date().valueOf();
    if (last_pause > resumptions[resumptions.length - 1].resumption_time) {
      resumptions.push({
        'resumption_time': r_time,
        'pause_time': last_pause,
        'pause_type': 'orientation',
        'pause_duration': r_time - last_pause
      }); //app resumed
    }
    console.log(resumptions[resumptions.length - 1]); 
    // appInsights.trackEvent("Resized", { 
    //   "TimeStamp": new Date().valueOf(),
    //   "user_id": userID, 
    //   "Event": "Resized",
    //   "Width": window.innerWidth, 
    //   "Height": window.innerHeight,
    //   "Orientation": 'portrait',
    //   'resumption_time': r_time,
    //   'pause_time': last_pause,
    //   'pause_type': 'orientation',
    //   'pause_duration': r_time - last_pause
    // });

  }
};

d3.select("body")
.on("keydown", function () {    
  
  switch(d3.event.keyCode) {    

    case 27: // test override on 'Esc' and load menu
      test_override = true;
      if (document.getElementsByTagName('div')[0] != undefined) {      
        document.getElementsByTagName('div')[0].remove();      
        // appInsights.trackEvent("TestOverride_Load_Menu", { 
        //   "TimeStamp": new Date().valueOf(),
        //   "Event": "TestOverride_Load_Menu",
        //   "user_id": userID
        // });
        loadMenu();         
      }      
    break;

    case 83: // load sandbox
      test_override = true;
      // appInsights.trackEvent("SandBox_Open", { 
      //   "TimeStamp": new Date().valueOf(),
      //   "Event": "SandBox_Open",
      //   "user_id": userID
      // });
      document.getElementById('menu_div').remove();   
      sandbox();  
      hideAddressBar();      
    break;

    default:
      test_override = true;
      if (document.getElementsByTagName('div')[0] != undefined) {      
        document.getElementsByTagName('div')[0].remove();      
        // appInsights.trackEvent("LoadMenu", { 
        //   "TimeStamp": new Date().valueOf(),
        //   "Event": "LoadMenu",
        //   "user_id": userID
        // });
        loadMenu();         
      }
    break;
  }    

});

gotcha = function (caller,index) {

  // appInsights.trackEvent("Gotcha", { 
  //   "TimeStamp": new Date().valueOf(),
  //   "Event": "Gotcha",
  //   "user_id": userID,
  //   "caller": caller,
  //   "caller_index": index
  // });

  console.log({ 
    "TimeStamp": new Date().valueOf(),
    "Event": "Gotcha",
    "user_id": userID,
    "caller": caller,
    "caller_index": index
  });

  if (caller == 'readValues') {
    if (index == 4) {
      locateDates(locateDateTaskList[18],18,caller,index);  
    }
    else {
      locateDates(locateDateTaskList[19],19,caller,index);
    }
  }
  else if (caller == 'compareWithin') {
    if (index == 4) {
      locateDates(locateDateTaskList[20],20,caller,index);  
    }
    else {
      locateDates(locateDateTaskList[21],21,caller,index);
    }
  }
  else if (caller == 'compareBetween') {
    if (index == 4) {
      locateDates(locateDateTaskList[22],22,caller,index);  
    }
    else {
      locateDates(locateDateTaskList[23],23,caller,index);
    }
  }
};

resume = function (caller,index) {

  // appInsights.trackEvent("ResumeFromGotcha", { 
  //   "TimeStamp": new Date().valueOf(),
  //   "Event": "ResumeFromGotcha",
  //   "user_id": userID,
  //   "resuming_to": caller,
  //   "resume_index": index
  // });

  console.log({ 
    "TimeStamp": new Date().valueOf(),
    "Event": "ResumeFromGotcha",
    "user_id": userID,
    "resuming_to": caller,
    "resume_index": index
  });

  switch (caller) {
    
    case 'readValues':
      readValues(readValueTaskList[index],index);
      hideAddressBar();
    break;

    case 'compareWithin':
      compareWithin(compareWithinTaskList[index],index);  
      hideAddressBar();
    break;

    case 'compareBetween':
      compareBetween(compareBetweenTaskList[index],index); 
      hideAddressBar();
    break;
    
    default:
      document.getElementsByTagName('div')[0].remove();      
      // appInsights.trackEvent("LoadMenu", { 
      //   "TimeStamp": new Date().valueOf(),
      //   "Event": "LoadMenu",
      //   "user_id": userID
      // });
      loadMenu();
    break;
  }

};

loadMenu = function () {
  
  menu(); 

  d3.select('#consent_btn')
  .on('touchstart', function() {    
    if (test_override || !consent_complete) {
      document.getElementById('menu_div').remove();
      // appInsights.trackEvent("ConsentStart", { 
      //   "TimeStamp": new Date().valueOf(),
      //   "user_id": userID,
      //   "Event": "ConsentStart",
      //   "Scene": 0
      // });
      consent(0);
      hideAddressBar();
    }  
  });

  d3.select('#introduction_btn')
  .on('touchstart', function() {      
    if (test_override || (!introduction_complete && consent_complete)) {
      document.getElementById('menu_div').remove();
      // appInsights.trackEvent("IntroStart", { 
      //   "TimeStamp": new Date().valueOf(),
      //   "user_id": userID,
      //   "Event": "IntroStart",
      //   "Scene": 0
      // });
      introduction(0);
      hideAddressBar();
    }
  });
  
  d3.select('#locate_dates_btn')
  .on('touchstart', function() {     
    if (test_override || (!locateDate_complete && introduction_complete)) {
      document.getElementById('menu_div').remove();   
      // appInsights.trackEvent("locateDateStart", { 
      //   "TimeStamp": new Date().valueOf(),
      //   "Event": "locateDateStart",
      //   "user_id": userID
      // }); 
      locateDates(locateDateTaskList[0],0,'locateDates',0);  
      hideAddressBar();   
    } 
  });

  d3.select('#read_values_btn')
  .on('touchstart', function() {  
    if (test_override || (!readValue_complete && locateDate_complete)) {
      document.getElementById('menu_div').remove();   
      // appInsights.trackEvent("readValuesStart", { 
      //   "TimeStamp": new Date().valueOf(),
      //   "Event": "readValuesStart",
      //   "user_id": userID
      // }); 
      readValues(readValueTaskList[0],0);  
      hideAddressBar();
    }
  });

  d3.select('#locate_minmax_btn')
  .on('touchstart', function() {  
    if (test_override || (!locateMinMax_complete && readValue_complete)) {
      document.getElementById('menu_div').remove();  
      // appInsights.trackEvent("locateMinMaxStart", { 
      //   "TimeStamp": new Date().valueOf(),
      //   "Event": "locateMinMaxStart",
      //   "user_id": userID
      // }); 
      locateMinMax(locateMinMaxTaskList[0],0);  
      hideAddressBar();
    }
  });

  d3.select('#compare_within_btn')
  .on('touchstart', function() {  
    if (test_override || (!compareWithin_complete && locateMinMax_complete)) {
      document.getElementById('menu_div').remove();   
      // appInsights.trackEvent("compareWithinStart", { 
      //   "TimeStamp": new Date().valueOf(),
      //   "Event": "compareWithinStart",
      //   "user_id": userID
      // });
      compareWithin(compareWithinTaskList[0],0);  
      hideAddressBar();
    }
  });

  d3.select('#compare_between_btn')
  .on('touchstart', function() {  
    if (test_override || (!compareBetween_complete && compareWithin_complete)) {
      document.getElementById('menu_div').remove(); 
      // appInsights.trackEvent("compareBetweenStart", { 
      //   "TimeStamp": new Date().valueOf(),
      //   "Event": "compareBetweenStart",
      //   "user_id": userID
      // });
      compareBetween(compareBetweenTaskList[0],0);  
      hideAddressBar();
    }
  });

  d3.select('#questionnaire_btn')
  .on('touchstart', function() {  
    if (test_override || compareBetween_complete) {
      document.getElementById('menu_div').remove();
      // appInsights.trackEvent("SurveyStart", { 
      //   "TimeStamp": new Date().valueOf(),
      //   "user_id": userID,
      //   "Event": "SurveyStart",
      //   "Scene": 0
      // });
      questionnaire(0);
      hideAddressBar();
    }
  });

  d3.select('#secret_sandbox')
  .on('touchstart', function() {  
    test_override = true;
    // appInsights.trackEvent("SandBox_Open", { 
    //   "TimeStamp": new Date().valueOf(),
    //   "Event": "SandBox_Open",
    //   "user_id": userID
    // });
    document.getElementById('menu_div').remove();   
    sandbox();  
    hideAddressBar();   
  });
};

 if (getCookie('visited')) {
  // alert('You have already participated in this study.'); 
  // appInsights.trackEvent("RepeatParticipant", { 
  //   "TimeStamp": new Date().valueOf(),
  //   "Event": "RepeatParticipant",
  //   "user_id": userID
  // });
  loadMenu(); // comment out in production
 }
 else {
   setCookie('visited',1,365);
  //  appInsights.trackEvent("NewParticipant", { 
  //   "TimeStamp": new Date().valueOf(),
  //   "Event": "NewParticipant",
  //   "user_id": userID
  // });
  loadMenu();
 }

d3.select('body').append('svg')
.style('display','none')
.attr('xmlns','http://www.w3.org/2000/svg')
.attr('version','1.1')
.attr('height','0')
.append('filter')
.attr('id','myblurfilter')
.attr('width','110%')
.attr('height','110%')
.append('feGaussianBlur')
.attr('stdDeviation','30')
.attr('result','blur');
