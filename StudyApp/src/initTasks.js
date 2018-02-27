var d3 = require("d3");
var moment = require("moment");
var globals = require("./globals");

function initTasks() {

    //generate array of weeks, omitting the first and last weeks of the year.
    var weeks =  [],    
        months = [],        
        first_datatype = 'sleep',
        // first_datatype = Math.random() < 0.5 ? 'temperature' : 'sleep',
        // first_representation = 'linear',
        first_representation = Math.random() < 0.5 ? 'linear' : 'radial',
        second_datatype = first_datatype == 'temperature' ? 'sleep' : 'temperature', 
        second_representation = first_representation == 'linear' ? 'radial' : 'linear',        
        first_granularity = "week",
        second_granularity = "month",
        third_granularity = "year",
        trial,
        i; 

    // console.log({
    //   "user_id": userID, 
    //   "Datatype": first_datatype, 
    //   "FirstRepresentation": first_representation
    // });           

    function resetDateArrays () {
      weeks =  Array.apply(null, {length: 53}).map(Number.call, Number).splice(2);    
      months = Array.apply(null, {length: 12}).map(Number.call, Number);    
    }

    function assignGranularities (num_granularities) {
        if (num_granularities == 2) {
            first_granularity = Math.random() < 0.5 ? 'week' : 'month';
            second_granularity = first_granularity == 'week' ? 'month' : 'week';

            // console.log({
            //     "user_id": userID, 
            //     "first_granularity": first_granularity, 
            //     "second_granularity": second_granularity
            // }); 
        }
        else {
            var seed = Math.random();
            first_granularity = seed < 0.333 ? 'week' : seed < 0.667 ? 'month' : 'year';
            switch (first_granularity) {
                case 'week':
                second_granularity = Math.random() < 0.5 ? 'month' : 'year';
                third_granularity = second_granularity == 'month' ? 'year' : 'month';
                break;

                case 'month':
                second_granularity = Math.random() < 0.5 ? 'week' : 'year';
                third_granularity = second_granularity == 'week' ? 'year' : 'week';
                break;

                case 'year':
                second_granularity = Math.random() < 0.5 ? 'week' : 'month';
                third_granularity = second_granularity == 'week' ? 'month' : 'week';
                break;

                default:
                second_granularity = 'month';
                third_granularity = 'year';
            }      
            
            // console.log({
            //     "user_id": userID, 
            //     "first_granularity": first_granularity, 
            //     "second_granularity": second_granularity,
            //     "third_granularity": third_granularity
            // }); 
        }
    }

    resetDateArrays();

    /** 
     * 
     * INIT locateDateTask
     *
    **/

    function locateDateBatch (batch_granularity,batch_representation,batch_datatype,batch_gotcha) {

        var granule_index = 0,
            selected_granule = 0,
            batch_range = 7;

        if (batch_granularity == 'week') {
            batch_range = 7; //weekdays
        }
        else if (batch_granularity == 'month') {
            batch_range = 28; //account for february
        }
        else {
            batch_range = 365; // days of the year
        }

        if (!batch_gotcha) {
            //one tutorial trial
            if (batch_granularity == 'week') {
                granule_index = Math.floor(Math.random() * weeks.length);
                selected_granule = weeks[granule_index]; // which granule is used for the trial? 
                weeks.splice(granule_index,1); // remove the granule from the array
            }
            else if (batch_granularity == 'month') {
                granule_index = Math.floor(Math.random() * months.length);
                selected_granule = months[granule_index]; // which granule is used for the trial? 
                months.splice(granule_index,1); // remove the granule from the array
            }
            
            trial = {
                granularity: batch_granularity,
                representation: batch_representation,
                datatype: batch_datatype,
                index: selected_granule,
                year: (batch_datatype == 'temperature') ? 2015 : 2012,
                target: Math.ceil(Math.random() * batch_range),
                training: true
            };
    
            locateDateTaskList.push(trial); // add the trial to the list
            granule_index = 0;
            selected_granule = 0;
        }

        var num_trials = batch_gotcha ? 3 : 2;

        //test: 2 test trials (or 3 gotchas)
        for (i = 0; i < num_trials; i++) {        
            
            if (batch_granularity == 'week') {
                granule_index = Math.floor(Math.random() * weeks.length);
                selected_granule = weeks[granule_index]; // which granule is used for the trial? 
                weeks.splice(granule_index,1); // remove the granule from the array
            }
            else if (batch_granularity == 'month') {
                granule_index = Math.floor(Math.random() * months.length);
                selected_granule = months[granule_index]; // which granule is used for the trial? 
                months.splice(granule_index,1); // remove the granule from the array
            }

            trial = {
                granularity: batch_granularity,
                representation: batch_representation,
                datatype: batch_datatype,
                index: selected_granule,
                year: (batch_datatype == 'temperature') ? 2015 : 2012,
                target: Math.ceil(Math.random() * batch_range),
                training: false
            };
            locateDateTaskList.push(trial); // add the trial to the list
        }
    }       

    assignGranularities(3);
    //first_granularity:     
    locateDateBatch(first_granularity,first_representation,first_datatype,false); 
    locateDateBatch(first_granularity,second_representation,first_datatype,false); 
    resetDateArrays(); //repopulate the date arrays for second datatype
    // locateDateBatch(first_granularity,first_representation,second_datatype); 
    // locateDateBatch(first_granularity,second_representation,second_datatype); 

    //second_granularity: 
    locateDateBatch(second_granularity,first_representation,first_datatype,false); 
    locateDateBatch(second_granularity,second_representation,first_datatype,false); 
    resetDateArrays(); //repopulate the date arrays for second datatype
    // locateDateBatch(second_granularity,first_representation,second_datatype); 
    // locateDateBatch(second_granularity,second_representation,second_datatype); 
    
    //third_granularity: 
    locateDateBatch(third_granularity,first_representation,first_datatype,false); 
    locateDateBatch(third_granularity,second_representation,first_datatype,false); 
    resetDateArrays(); //repopulate the date arrays for second datatype
    // locateDateBatch(third_granularity,first_representation,second_datatype); 
    // locateDateBatch(third_granularity,second_representation,second_datatype); 

    //weeks (gotcha): 
    locateDateBatch('week',first_representation,first_datatype,true); 
    locateDateBatch('week',second_representation,first_datatype,true); 
    resetDateArrays(); //repopulate the date arrays for second datatype
    // locateDateBatch(first_granularity,first_representation,second_datatype); 
    // locateDateBatch(first_granularity,second_representation,second_datatype);     

    //alternate radial / linear gotcha questions 
    function gotchaSwap (el1,el2) {
      var locateDateGotcha = locateDateTaskList[el1];
      locateDateTaskList[el1] = locateDateTaskList[el2];
      locateDateTaskList[el2] = locateDateGotcha;
    }

    gotchaSwap(19,22);

    /** 
     * 
     * INIT readValue
     *
    **/

    function readValueBatch (batch_granularity,batch_representation,batch_datatype) {
        
        var granule_index = 0,
            selected_granule = 0,
            batch_range = 7,
            trial_attribute = Math.random() < 0.5 ? 'start' : 'end';

        if (batch_granularity == 'week') {
            batch_range = 7; //weekdays
        }
        else if (batch_granularity == 'month') {
            batch_range = 28; //account for february
        }
        else {
            batch_range = 365; // days of the year
        }

        //one tutorial trial
        if (batch_granularity == 'week') {
            granule_index = Math.floor(Math.random() * weeks.length);
            selected_granule = weeks[granule_index]; // which granule is used for the trial? 
            weeks.splice(granule_index,1); // remove the granule from the array
        }
        else if (batch_granularity == 'month') {
            granule_index = Math.floor(Math.random() * months.length);
            selected_granule = months[granule_index]; // which granule is used for the trial? 
            months.splice(granule_index,1); // remove the granule from the array
        }
        
        trial = {
            granularity: batch_granularity,
            representation: batch_representation,
            datatype: batch_datatype,
            index: selected_granule,
            target_attribute: trial_attribute,
            target_value_label: ((batch_datatype == 'temperature') ? ('Daily ' + ((trial_attribute == 'start') ? 'Low' : 'High') + ' Temperature ') : (((trial_attribute == 'start') ? 'Bedt' : 'Waking T') + 'ime')),            
            year: (batch_datatype == 'temperature') ? 2015 : 2012,
            target: Math.ceil(Math.random() * batch_range),
            training: true
        };

        readValueTaskList.push(trial); // add the trial to the list

        granule_index = 0;
        selected_granule = 0;
        var previous_trial = trial_attribute;

        //test: 2 test trials
        for (i = 0; i < 4; i++) {      
            
            trial_attribute = (previous_trial == 'end') ? 'start' : 'end';
            
            if (batch_granularity == 'week') {
                granule_index = Math.floor(Math.random() * weeks.length);
                selected_granule = weeks[granule_index]; // which granule is used for the trial? 
                weeks.splice(granule_index,1); // remove the granule from the array
            }
            else if (batch_granularity == 'month') {
                granule_index = Math.floor(Math.random() * months.length);
                selected_granule = months[granule_index]; // which granule is used for the trial? 
                months.splice(granule_index,1); // remove the granule from the array
            }

            trial = {
                granularity: batch_granularity,
                representation: batch_representation,
                datatype: batch_datatype,
                index: selected_granule,
                target_attribute: trial_attribute,
                target_value_label: ((batch_datatype == 'temperature') ? ('Daily ' + ((trial_attribute == 'start') ? 'Low' : 'High') + ' Temperature ') : (((trial_attribute == 'start') ? 'Bedt' : 'Waking T') + 'ime')),
                year: (batch_datatype == 'temperature') ? 2015 : 2012,
                target: Math.ceil(Math.random() * batch_range),
                training: false
            };
            readValueTaskList.push(trial); // add the trial to the list
            previous_trial = trial_attribute;   
        }
    }       

    assignGranularities(2);
    //first_granularity: 
    readValueBatch(first_granularity,first_representation,first_datatype); 
    readValueBatch(first_granularity,second_representation,first_datatype); 
    resetDateArrays(); //repopulate the date arrays for second datatype
    // readValueBatch(first_granularity,first_representation,second_datatype); 
    // readValueBatch(first_granularity,second_representation,second_datatype); 

    //second_granularity: 
    readValueBatch(second_granularity,first_representation,first_datatype); 
    readValueBatch(second_granularity,second_representation,first_datatype); 
    resetDateArrays(); //repopulate the date arrays for second datatype
    // readValueBatch(second_granularity,first_representation,second_datatype); 
    // readValueBatch(second_granularity,second_representation,second_datatype); 
    
    //third_granularity: 
    // readValueBatch(third_granularity,first_representation,first_datatype); 
    // readValueBatch(third_granularity,second_representation,first_datatype); 
    // resetDateArrays(); //repopulate the date arrays for second datatype
    // readValueBatch(third_granularity,first_representation,second_datatype); 
    // readValueBatch(third_granularity,second_representation,second_datatype); 
       

    /** 
     * 
     * INIT locateMinMax
     *
    **/

    function locateMinMaxBatch (batch_granularity,batch_representation,batch_datatype) {
        
        var granule_index = 0,
            selected_granule = 0,
            trial_value = Math.random() < 0.5 ? 'start' : 'end';

        var trial_minmax = (trial_value == 'end') ? 'maximum' : 'minimum';
        
        
        //one tutorial trial
        if (batch_granularity == 'week') {
            granule_index = Math.floor(Math.random() * weeks.length);
            selected_granule = weeks[granule_index]; // which granule is used for the trial? 
            weeks.splice(granule_index,1); // remove the granule from the array
        }
        else if (batch_granularity == 'month') {
            granule_index = Math.floor(Math.random() * months.length);
            selected_granule = months[granule_index]; // which granule is used for the trial? 
            months.splice(granule_index,1); // remove the granule from the array
        }
        
        trial = {
            granularity: batch_granularity,
            representation: batch_representation,
            datatype: batch_datatype,
            index: selected_granule,
            year: (batch_datatype == 'temperature') ? 2015 : 2012,
            minmax: trial_minmax,
            value: trial_value,
            training: true
        };

        if (batch_granularity != 'year') {
            locateMinMaxTaskList.push(trial); // add the trial to the list
        }

        var previous_trial = trial_value;

        granule_index = 0;
        selected_granule = 0;       

        //test: 2 test trials
        for (i = 0; i < (batch_granularity == 'year' ? 2 : 6); i++) {  
            
            if (i == 4 && batch_granularity == 'month' && batch_representation == second_representation) {
                resetDateArrays();
            }
            
            if (batch_granularity == 'year') {
                trial_value = (previous_trial == 'start') ? 'end' : 'start';               
            }
            else {
                if (i < 4) {
                    trial_value = (previous_trial == 'start') ? 'end' : 'start';
                }
                else {
                    trial_value = 'range';
                }
            }
            trial_minmax = (trial_value == 'end' || trial_value == 'range') ? 'maximum' : 'minimum';

            
            if (batch_granularity == 'week') {
                granule_index = Math.floor(Math.random() * weeks.length);
                selected_granule = weeks[granule_index]; // which granule is used for the trial? 
                weeks.splice(granule_index,1); // remove the granule from the array
            }
            else if (batch_granularity == 'month') {
                granule_index = Math.floor(Math.random() * months.length);
                selected_granule = months[granule_index]; // which granule is used for the trial? 
                months.splice(granule_index,1); // remove the granule from the array
            }

            trial = {
                granularity: batch_granularity,
                representation: batch_representation,
                datatype: batch_datatype,
                index: selected_granule,
                year: (batch_datatype == 'temperature') ? 2015 : 2012,
                minmax: trial_minmax,
                value: trial_value,
                training: false
            };
            locateMinMaxTaskList.push(trial); // add the trial to the list
            previous_trial = trial_value;
            
        }
    }

    assignGranularities(3);

    //first_granularity: 
    locateMinMaxBatch(first_granularity,first_representation,first_datatype);
    locateMinMaxBatch(first_granularity,second_representation,first_datatype);
    resetDateArrays(); //repopulate the date arrays for second datatype
    // locateMinMaxBatch(first_granularity,first_representation,second_datatype);
    // locateMinMaxBatch(first_granularity,second_representation,second_datatype);

    //second_granularity: 
    locateMinMaxBatch(second_granularity,first_representation,first_datatype);
    locateMinMaxBatch(second_granularity,second_representation,first_datatype);
    resetDateArrays(); //repopulate the date arrays for second datatype
    // locateMinMaxBatch(second_granularity,first_representation,second_datatype);
    // locateMinMaxBatch(second_granularity,second_representation,second_datatype);
    
    //third_granularity: 
    locateMinMaxBatch(third_granularity,first_representation,first_datatype);
    locateMinMaxBatch(third_granularity,second_representation,first_datatype);
    resetDateArrays(); //repopulate the date arrays for second datatype
    // locateMinMaxBatch(third_granularity,first_representation,second_datatype);
    // locateMinMaxBatch(third_granularity,second_representation,second_datatype);

    /** 
     * 
     * INIT compareWithin
     *
    **/

    function compareWithinBatch (batch_granularity,batch_representation,batch_datatype) {
        
        var granule_index = 0,
            selected_granule = 0,
            batch_range = 7,
            trial_attribute = Math.random() < 0.5 ? 'start' : 'end';

        if (batch_granularity == 'week') {
            batch_range = 7; //weekdays
        }
        else if (batch_granularity == 'month') {
            batch_range = 28; //account for february
        }
        else {
            batch_range = 365; // days of the year
        }

        //one tutorial trial
        if (batch_granularity == 'week') {
            granule_index = Math.floor(Math.random() * weeks.length);
            selected_granule = weeks[granule_index]; // which granule is used for the trial? 
            weeks.splice(granule_index,1); // remove the granule from the array
        }
        else if (batch_granularity == 'month') {
            granule_index = Math.floor(Math.random() * months.length);
            selected_granule = months[granule_index]; // which granule is used for the trial? 
            months.splice(granule_index,1); // remove the granule from the array
        }
        
        trial = {
            granularity: batch_granularity,
            representation: batch_representation,
            datatype: batch_datatype,
            index: selected_granule,
            target_attribute: trial_attribute,
            year: (batch_datatype == 'temperature') ? 2015 : 2012,
            target: Math.ceil(Math.random() * batch_range),
            training: true
        };

        compareWithinTaskList.push(trial); // add the trial to the list
        var previous_trial = trial_attribute;

        granule_index = 0;
        selected_granule = 0;

        //test: 4 test trials
        for (i = 0; i < 4; i++) {      
            
            trial_attribute = (previous_trial == 'end') ? 'start' : 'end';
            
            if (batch_granularity == 'week') {
                granule_index = Math.floor(Math.random() * weeks.length);
                selected_granule = weeks[granule_index]; // which granule is used for the trial? 
                weeks.splice(granule_index,1); // remove the granule from the array
            }
            else if (batch_granularity == 'month') {
                granule_index = Math.floor(Math.random() * months.length);
                selected_granule = months[granule_index]; // which granule is used for the trial? 
                months.splice(granule_index,1); // remove the granule from the array
            }

            trial = {
                granularity: batch_granularity,
                representation: batch_representation,
                datatype: batch_datatype,
                index: selected_granule,
                target_attribute: trial_attribute,
                year: (batch_datatype == 'temperature') ? 2015 : 2012,
                target: Math.ceil(Math.random() * batch_range),
                training: false
            };
            compareWithinTaskList.push(trial); // add the trial to the list
            previous_trial = trial_attribute;
        }
    }       

    assignGranularities(2);
    //first_granularity: 
    compareWithinBatch(first_granularity,first_representation,first_datatype); 
    compareWithinBatch(first_granularity,second_representation,first_datatype); 
    resetDateArrays(); //repopulate the date arrays for second datatype
    // compareWithinBatch(first_granularity,first_representation,second_datatype); 
    // compareWithinBatch(first_granularity,second_representation,second_datatype); 

    //second_granularity: 
    compareWithinBatch(second_granularity,first_representation,first_datatype); 
    compareWithinBatch(second_granularity,second_representation,first_datatype); 
    resetDateArrays(); //repopulate the date arrays for second datatype
    // readValueBatch(second_granularity,first_representation,second_datatype); 
    // readValueBatch(second_granularity,second_representation,second_datatype); 
    
    //third_granularity: 
    // compareWithinBatch(third_granularity,first_representation,first_datatype); 
    // compareWithinBatch(third_granularity,second_representation,first_datatype); 
    // resetDateArrays(); //repopulate the date arrays for second datatype
    // compareWithinBatch(third_granularity,first_representation,second_datatype); 
    // compareWithinBatch(third_granularity,second_representation,second_datatype); 
       

    /** 
     * 
     * INIT compareBetween
     *
    **/

    function compareBetweenBatch (batch_granularity,batch_representation,batch_datatype) {
        
        var granule_index = 0,
            selected_granule = 0,
            batch_range = 7,
            days = [],
            days_1 = [],
            days_2 = [],
            selected_target_1_index = 0,
            selected_target_2_index = 0,
            selected_target_1 = 0,
            selected_target_2 = 0,
            tmp = 0,
            day_offset = 0;

        if (batch_granularity == 'week') {
            batch_range = 7; //weekdays
            day_offset = 2;
        }
        else if (batch_granularity == 'month') {
            batch_range = 27; //account for february
            day_offset = 6;
        }
        else {
            batch_range = 365; // days of the year
            day_offset = 54;
        }

        days = Array.apply(null, {length: batch_range}).map(Number.call, Number);     

        
        //one tutorial trial
        if (batch_granularity == 'week') {
            granule_index = Math.floor(Math.random() * weeks.length);
            selected_granule = weeks[granule_index]; // which granule is used for the trial? 
            weeks.splice(granule_index,1); // remove the granule from the array
        }
        else if (batch_granularity == 'month') {
            granule_index = Math.floor(Math.random() * months.length);
            selected_granule = months[granule_index]; // which granule is used for the trial? 
            months.splice(granule_index,1); // remove the granule from the array
        }

        selected_target_1_index = Math.floor(Math.random() * (days.length - 2 * day_offset)) + day_offset;
        selected_target_1 = days[selected_target_1_index];
        days.splice(selected_target_1_index - day_offset, 2 * day_offset);        

        selected_target_2_index = Math.floor(Math.random() * (days.length - 2 * day_offset)) + day_offset;
        selected_target_2 = days[selected_target_2_index];

        if (selected_target_2 < selected_target_1) {
            tmp = selected_target_1;
            selected_target_1 = selected_target_2;
            selected_target_2 = tmp;
        }                    
        
        trial = {
            granularity: batch_granularity,
            representation: batch_representation,
            datatype: batch_datatype,
            index: selected_granule,
            year: (batch_datatype == 'temperature') ? 2015 : 2012,
            target_1: selected_target_1,
            target_2: selected_target_2,
            training: true
        };

        compareBetweenTaskList.push(trial); // add the trial to the list

        granule_index = 0;
        selected_granule = 0;

        //test: 2 test trials
        for (i = 0; i < 2; i++) {  

            days = Array.apply(null, {length: batch_range}).map(Number.call, Number);     

            if (batch_granularity == 'week') {
                granule_index = Math.floor(Math.random() * weeks.length);
                selected_granule = weeks[granule_index]; // which granule is used for the trial? 
                weeks.splice(granule_index,1); // remove the granule from the array
            }
            else if (batch_granularity == 'month') {
                granule_index = Math.floor(Math.random() * months.length);
                selected_granule = months[granule_index]; // which granule is used for the trial? 
                months.splice(granule_index,1); // remove the granule from the array
            }

            selected_target_1_index = Math.floor(Math.random() * (days.length - 2 * day_offset)) + day_offset;
            selected_target_1 = days[selected_target_1_index];
            days.splice(selected_target_1_index - day_offset, 2 * day_offset);        
    
            selected_target_2_index = Math.floor(Math.random() * (days.length - 2 * day_offset)) + day_offset;
            selected_target_2 = days[selected_target_2_index];

            if (selected_target_2 < selected_target_1) {
                tmp = selected_target_1;
                selected_target_1 = selected_target_2;
                selected_target_2 = tmp;
            }                        

            trial = {
                granularity: batch_granularity,
                representation: batch_representation,
                datatype: batch_datatype,
                index: selected_granule,
                year: (batch_datatype == 'temperature') ? 2015 : 2012,
                target_1: selected_target_1,
                target_2: selected_target_2,
                training: false
            };
            compareBetweenTaskList.push(trial); // add the trial to the list
        }
    }       

    assignGranularities(3);

    //first_granularity: 
    compareBetweenBatch(first_granularity,first_representation,first_datatype); 
    compareBetweenBatch(first_granularity,second_representation,first_datatype); 
    resetDateArrays(); //repopulate the date arrays for second datatype
    // compareWithinBatch(first_granularity,first_representation,second_datatype); 
    // compareWithinBatch(first_granularity,second_representation,second_datatype); 

    //second_granularity: 
    compareBetweenBatch(second_granularity,first_representation,first_datatype); 
    compareBetweenBatch(second_granularity,second_representation,first_datatype); 
    resetDateArrays(); //repopulate the date arrays for second datatype
    // readValueBatch(second_granularity,first_representation,second_datatype); 
    // readValueBatch(second_granularity,second_representation,second_datatype); 
    
    //third_granularity: 
    compareBetweenBatch(third_granularity,first_representation,first_datatype); 
    compareBetweenBatch(third_granularity,second_representation,first_datatype); 
    resetDateArrays(); //repopulate the date arrays for second datatype
    // compareWithinBatch(third_granularity,first_representation,second_datatype); 
    // compareWithinBatch(third_granularity,second_representation,second_datatype); 
       
}

module.exports = initTasks;