function checkMissingDay(index) {  
    
    if ((index + 1) < all_data.length){
  
      if ( moment(all_data[index].date_val).add(1,'d').isBefore(max_date) && moment(all_data[index].date_val).add(1,'d').isBefore(moment(all_data[index + 1].date_val)) ){
    
        var missing_day_date_val = moment(all_data[index].date_val).add(1,'d');
        console.log("missing day: " + missing_day_date_val.format('YYYY-MM-DD'));
        var missing_day = {
          "date_val": missing_day_date_val.format('YYYY-MM-DD') + 'T12:00:00.000Z',
          "year": missing_day_date_val.year(),
          "month": missing_day_date_val.month(),
          "weekday": missing_day_date_val.day() + 1,
          "week_of_year": missing_day_date_val.week(),
          "day": missing_day_date_val.date(),
          "day_of_year": missing_day_date_val.dayOfYear(),
          "start": undefined,
          "start_label": undefined,
          "end": undefined,
          "end_label": undefined,
          "start_baseline": undefined,
          "start_baseline_label": undefined,
          "end_baseline": undefined,
          "end_baseline_label": undefined
        };      
        
        all_data.splice(index+1,0,missing_day); 
      }
      checkMissingDay(index + 1);    
    }
  }