var u;

var globals = {
  width: 0,
  height: 0,
  svg_dim: u,
  inner_padding: u,
  chart_dim: u,
  padding: 0,
  main_svg: u,
  defs: u,
  userID: u,
  chart_g: u,
  date_indicator: u,
  // appInsights: u,
  all_data: u,  
  min_date: u,
  max_date: u,
  first_date: u,
  selected_week: u,
  selected_month: u,
  selected_year: u,
  last_date: u,
  data_unit: u,
  hideAddressBar: u,
  locateDateTaskList: u,
  readValueTaskList: u,
  locateMinMaxTaskList: u,
  compareWithinTaskList: u,
  compareBetweenTaskList: u,
  consent_complete: u,
  introduction_complete: u,
  locateDate_complete: u,
  readValue_complete: u,
  locateMinMax_complete: u,
  compareWithin_complete: u,
  compareBetween_complete: u,
  test_override: u,
  min_start: u,
  min_range: u,
  min_end: u,
  max_start: u,
  max_end: u,
  max_range: u,
  min_start_indices: u,
  max_start_indices: u,
  min_range_indices: u,
  min_end_indices: u,
  max_end_indices: u,
  max_range_indices: u,
  touch_date: u,
  touch_day: u,
  touch_value: u,
  touch_day_start_end: u,
  suppress_touch_feedback: u,
  suppress_touch_val_feedback: u,
  last_pause: u,
  resumptions: u
  // socket: u  
};

locateDateTaskList = [];
locateMinMaxTaskList = [];
readValueTaskList = [];
compareWithinTaskList = [];
compareBetweenTaskList = [];
test_override = false;
consent_complete = false;
introduction_complete = false;
locateDate_complete = false;
readValue_complete = false;
locateMinMax_complete = false;
compareWithin_complete = false;
compareBetween_complete = false;
resumptions = [];
suppress_touch_feedback = false;
suppress_touch_val_feedback = false;
touch_value = null;

userID = 'Dev_' + new Date().valueOf();
// userID = 'MT_' + new Date().valueOf();
last_pause = new Date().valueOf();

// globals.socket = io({ transports: ["websocket"] });

/* jshint ignore:start */
// appInsights = window.appInsights || function (config) {    
//   function i(config) {
//     t[config] = function() {
//       var i = arguments;
//       t.queue.push( function () {
//         t[config].apply(t,i);
//       });
//     };
//   }
//   var t = {config:config},
//       u = document,
//       e = window,
//       o = "script",
//       s = "AuthenticatedUserContext",
//       h = "start",
//       c = "stop",
//       l = "Track",
//       a = l + "Event",
//       v = l + "Page",
//       y = u.createElement(o),
//       r,
//       f;
//       y.src = config.url || "https://az416426.vo.msecnd.net/scripts/a/ai.0.js";
//       u.getElementsByTagName(o)[0].parentNode.appendChild(y);
      
//       try{
//         t.cookie=u.cookie;
//       }
//       catch(p){

//       }
//       for(t.queue = [],t.version="1.0",r=["Event","Exception","Metric","PageView","Trace","Dependency"]; r.length;)
//         i("track"+r.pop());
//       return i("set"+s),i("clear"+s),i(h+a),i(c+a),i(h+v),i(c+v),i("flush"),
//       config.disableExceptionTracking || (r="onerror",i("_"+r),f=e[r],e[r] = function (config,i,u,e,o){
//         var s=f&&f(config,i,u,e,o);
//         return s!==!0&&t["_"+r](config,i,u,e,o),s;
//       }),t;
// }
// ({        
//   instrumentationKey:"ADD YOUR APP INSIGHTS KEY HERE"
// });      

hideAddressBar = function () {
  
  setTimeout(function(){
    // Hide the address bar!
		window.scrollTo(0, 1);
  }, 0);

  var lastTouchY = 0;
  
  var touchstartHandler = function(e) {
    if (e.touches.length != 1) return;
    lastTouchY = e.touches[0].clientY;
  };
  
  var touchmoveHandler = function(e) {
    var touchY = e.touches[0].clientY;
    var touchYDelta = touchY - lastTouchY;
    lastTouchY = touchY;

    e.preventDefault();
    return;
  };

  document.addEventListener('touchstart', touchstartHandler, {passive: false });
  document.addEventListener('touchmove', touchmoveHandler, {passive: false });

};

module.exports = globals;

