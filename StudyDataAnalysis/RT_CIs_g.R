RT_g_CI <- function(result.df,task_name) {
  
  print(c("RT_g_CI",nrow(result.df),task_name))
  
  result.df$response_time_secs <- result.df$response_time / 1000
  result.df$log_response_time <- log(result.df$response_time_secs)
  
  #compute mean for each user_id and granularity
  RT_g_aggregate.df <- aggregate(abs(result.df$log_response_time), list(result.df$user_id,result.df$granularity), mean)
  
  names(RT_g_aggregate.df) <- c("user_id","granularity","log_response_time")
  
  RT_g_log_week <- subset(RT_g_aggregate.df, granularity=="week")$log_response_time
  RT_g_log_month <- subset(RT_g_aggregate.df, granularity=="month")$log_response_time
  n_RT_week <- length(RT_g_log_week)
  n_RT_month <- length(RT_g_log_month)
  if (task_name != 'Read Value' && task_name != 'Compare Values') {
    RT_g_log_year <-subset(RT_g_aggregate.df, granularity=="year")$log_response_time
    n_RT_year <- length(RT_g_log_year)
  }
  
  ttest_RT_g_week <- t.test(RT_g_log_week, conf.level = 0.95)
  ttest_RT_g_month <- t.test(RT_g_log_month, conf.level = 0.95)
  if (task_name != 'Read Value' && task_name != 'Compare Values') {
    ttest_RT_g_year <- t.test(RT_g_log_year, conf.level = 0.95)
  }
  
  mean_RT_g_week = mean(RT_g_log_week)
  mean_RT_g_month = mean(RT_g_log_month)
  
  cimax_RT_g_week = exp(ttest_RT_g_week$conf.int[2])
  cimax_RT_g_month = exp(ttest_RT_g_month$conf.int[2])
  
  cimin_RT_g_week = exp(ttest_RT_g_week$conf.int[1])
  cimin_RT_g_month = exp(ttest_RT_g_month$conf.int[1])
  
  mean_RT_g_week = exp(mean_RT_g_week)
  mean_RT_g_month = exp(mean_RT_g_month)
  
  if (task_name != 'Read Value' && task_name != 'Compare Values') {
    mean_RT_g_year = mean(RT_g_log_year)
    cimax_RT_g_year = exp(ttest_RT_g_year$conf.int[2])
    cimin_RT_g_year = exp(ttest_RT_g_year$conf.int[1])
    mean_RT_g_year = exp(mean_RT_g_year)
  }
  
  RT_g_analysis = c()
  if (task_name != 'Read Value' && task_name != 'Compare Values') {
    RT_g_analysis$ratio = c("Week","Month","Year")
    RT_g_analysis$pointEstimate = c(mean_RT_g_week,mean_RT_g_month,mean_RT_g_year)
    RT_g_analysis$ci.max = c(cimax_RT_g_week,cimax_RT_g_month,cimax_RT_g_year)
    RT_g_analysis$ci.min = c(cimin_RT_g_week,cimin_RT_g_month,cimin_RT_g_year)
    RT_g_analysis$n = c(n_RT_week,n_RT_month,n_RT_year)
  }
  else {
    RT_g_analysis$ratio = c("Week","Month")
    RT_g_analysis$pointEstimate = c(mean_RT_g_week,mean_RT_g_month)
    RT_g_analysis$ci.max = c(cimax_RT_g_week,cimax_RT_g_month)
    RT_g_analysis$ci.min = c(cimin_RT_g_week,cimin_RT_g_month)
    RT_g_analysis$n = c(n_RT_week,n_RT_month)
  }
  
  RT_g_analysis.df <- data.frame(task_name,factor(RT_g_analysis$ratio),RT_g_analysis$pointEstimate, RT_g_analysis$ci.max, RT_g_analysis$ci.min, RT_g_analysis$n)
  colnames(RT_g_analysis.df) <- c("task_name","granularity", "mean", "upperBound_CI", "lowerBound_CI","n")
  
  return(RT_g_analysis.df)
}

RT_g_CI_diff <- function(result.df,task_name) {
  
  print(c("RT_g_CI_diff",nrow(result.df),task_name))
  
  result.df$response_time_secs <- result.df$response_time / 1000
  result.df$log_response_time <- log(result.df$response_time_secs)
  
  #compute mean for each user_id and granularity
  RT_g_aggregate.df <- aggregate(abs(result.df$log_response_time), list(result.df$user_id,result.df$granularity), mean)
  
  names(RT_g_aggregate.df) <- c("user_id","granularity","log_response_time")
  
  RT_g_log_week.df <- subset(RT_g_aggregate.df, granularity=="week")
  RT_g_log_month.df <- subset(RT_g_aggregate.df, granularity=="month" & user_id %in% RT_g_log_week.df$user_id)
  RT_g_log_week.df <- subset(RT_g_log_week.df, user_id %in% RT_g_log_month.df$user_id)
  
  if (task_name != 'Read Value' && task_name != 'Compare Values') {
    RT_g_log_year.df <-subset(RT_g_aggregate.df, granularity=="year" & user_id %in% RT_g_log_month.df$user_id)
    RT_g_log_week.df <- subset(RT_g_log_week.df, user_id %in% RT_g_log_year.df$user_id)
    RT_g_log_month.df <- subset(RT_g_log_month.df, user_id %in% RT_g_log_year.df$user_id)
    
    RT_g_log_year <- RT_g_log_year.df$log_response_time
  }
  
  RT_g_log_week <- RT_g_log_week.df$log_response_time
  RT_g_log_month <- RT_g_log_month.df$log_response_time
  
  RT_g_diff_monthweek <- RT_g_log_month - RT_g_log_week
  n_g_diff_monthweek <- length(RT_g_diff_monthweek)
  if (task_name != 'Read Value' && task_name != 'Compare Values') {
    RT_g_diff_yearmonth <- RT_g_log_year - RT_g_log_month
    n_g_diff_yearmonth <- length(RT_g_diff_yearmonth)
    RT_g_diff_yearweek <- RT_g_log_year - RT_g_log_week
    n_g_diff_yearweek <- length(RT_g_diff_yearweek)
  }
  
  ttest_RT_g_diff_monthweek <- t.test(RT_g_diff_monthweek, conf.level = 0.95)
  
  mean_RT_g_diff_monthweek <- exp(mean(RT_g_diff_monthweek))
  
  cimax_RT_g_diff_monthweek <- exp(ttest_RT_g_diff_monthweek$conf.int[2])
  cimin_RT_g_diff_monthweek <- exp(ttest_RT_g_diff_monthweek$conf.int[1])
  
  if (task_name != 'Read Value' && task_name != 'Compare Values') {
    ttest_RT_g_diff_yearmonth <- t.test(RT_g_diff_yearmonth, conf.level = 0.95)
    
    mean_RT_g_diff_yearmonth <- exp(mean(RT_g_diff_yearmonth))
    
    cimax_RT_g_diff_yearmonth <- exp(ttest_RT_g_diff_yearmonth$conf.int[2])
    cimin_RT_g_diff_yearmonth <- exp(ttest_RT_g_diff_yearmonth$conf.int[1])
    
    ttest_RT_g_diff_yearweek <- t.test(RT_g_diff_yearweek, conf.level = 0.95)
    
    mean_RT_g_diff_yearweek <- exp(mean(RT_g_diff_yearweek))
    
    cimax_RT_g_diff_yearweek <- exp(ttest_RT_g_diff_yearweek$conf.int[2])
    cimin_RT_g_diff_yearweek <- exp(ttest_RT_g_diff_yearweek$conf.int[1])
  }
  
  RT_g_diff_analysis = c()
  if (task_name != 'Read Value' && task_name != 'Compare Values') {
    RT_g_diff_analysis$ratio = c("Month - Week","Year - Month","Year - Week")
    RT_g_diff_analysis$pointEstimate = c(mean_RT_g_diff_monthweek,mean_RT_g_diff_yearmonth,mean_RT_g_diff_yearweek)
    RT_g_diff_analysis$ci.max = c(cimax_RT_g_diff_monthweek,cimax_RT_g_diff_yearmonth,cimax_RT_g_diff_yearweek)
    RT_g_diff_analysis$ci.min = c(cimin_RT_g_diff_monthweek,cimin_RT_g_diff_yearmonth,cimin_RT_g_diff_yearweek)
    RT_g_diff_analysis$n = c(n_g_diff_monthweek,n_g_diff_yearmonth,n_g_diff_yearweek)
  }
  else {
    RT_g_diff_analysis$ratio = c("Month - Week")
    RT_g_diff_analysis$pointEstimate = c(mean_RT_g_diff_monthweek)
    RT_g_diff_analysis$ci.max = c(cimax_RT_g_diff_monthweek)
    RT_g_diff_analysis$ci.min = c(cimin_RT_g_diff_monthweek)
    RT_g_diff_analysis$n = c(n_g_diff_monthweek)
  }
  
  RT_g_diff_analysis.df <- data.frame(task_name,factor(RT_g_diff_analysis$ratio),RT_g_diff_analysis$pointEstimate, RT_g_diff_analysis$ci.max, RT_g_diff_analysis$ci.min,RT_g_diff_analysis$n)
  colnames(RT_g_diff_analysis.df) <- c("task_name","ratio", "mean", "lowerBound_CI", "upperBound_CI","n")
  
  return(RT_g_diff_analysis.df)
}

#CI computationt

# combined
RT_g.df <- RT_g_CI(rbind(
  locate_date_test.df,
  read_value_test.df,
  locate_minmax_test.df,
  compare_within_test.df,
  compare_between_test.df
),'All Tasks')

#by task
RT_g.df <- rbind(RT_g.df,RT_g_CI(locate_date_test.df,'Locate Date'))
RT_g.df <- rbind(RT_g.df,RT_g_CI(read_value_test.df,'Read Value'))
RT_g.df <- rbind(RT_g.df,c('Read Value','Year',NA,NA,NA,length(levels(read_value_test.df$user_id)))) #year not tested
RT_g.df <- rbind(RT_g.df,RT_g_CI(locate_minmax_test.df,'Locate Min / Max'))
RT_g.df <- rbind(RT_g.df,RT_g_CI(compare_within_test.df,'Compare Values'))
RT_g.df <- rbind(RT_g.df,c('Compare Values','Year',NA,NA,NA,length(levels(compare_within_test.df$user_id)))) #year not tested
RT_g.df <- rbind(RT_g.df,RT_g_CI(compare_between_test.df,'Compare Ranges'))

RT_g.df$mean <- as.numeric(RT_g.df$mean)
RT_g.df$lowerBound_CI <- as.numeric(RT_g.df$lowerBound_CI)
RT_g.df$upperBound_CI <- as.numeric(RT_g.df$upperBound_CI)

RT_g.df$facet <- 'Both Representations'

# effect size computation

# combined
RT_g_diff.df <- RT_g_CI_diff(rbind(
  locate_date_test.df,
  read_value_test.df,
  locate_minmax_test.df,
  compare_within_test.df,
  compare_between_test.df
),'All Tasks')

#by task
RT_g_diff.df <- rbind(RT_g_diff.df,RT_g_CI_diff(locate_date_test.df,'Locate Date'))
RT_g_diff.df <- rbind(RT_g_diff.df,RT_g_CI_diff(read_value_test.df,'Read Value'))
RT_g_diff.df <- rbind(RT_g_diff.df,c('Read Value','Year - Month',NA,NA,NA,length(levels(read_value_test.df$user_id)))) #year-month not tested
RT_g_diff.df <- rbind(RT_g_diff.df,c('Read Value','Year - Week',NA,NA,NA,length(levels(read_value_test.df$user_id)))) #year-month not tested
RT_g_diff.df <- rbind(RT_g_diff.df,RT_g_CI_diff(locate_minmax_test.df,'Locate Min / Max'))
RT_g_diff.df <- rbind(RT_g_diff.df,RT_g_CI_diff(compare_within_test.df,'Compare Values'))
RT_g_diff.df <- rbind(RT_g_diff.df,c('Compare Values','Year - Month',NA,NA,NA,length(levels(compare_within_test.df$user_id)))) #year-month not tested
RT_g_diff.df <- rbind(RT_g_diff.df,c('Compare Values','Year - Week',NA,NA,NA,length(levels(compare_within_test.df$user_id)))) #year-month not tested
RT_g_diff.df <- rbind(RT_g_diff.df,RT_g_CI_diff(compare_between_test.df,'Compare Ranges'))

RT_g_diff.df$mean <- as.numeric(RT_g_diff.df$mean)
RT_g_diff.df$lowerBound_CI <- as.numeric(RT_g_diff.df$lowerBound_CI)
RT_g_diff.df$upperBound_CI <- as.numeric(RT_g_diff.df$upperBound_CI)

RT_g_diff.df$facet <- 'Both Representations'

#linear

# combined
RT_linear.df <- RT_g_CI(subset(rbind(
  locate_date_test.df,
  read_value_test.df,
  locate_minmax_test.df,
  compare_within_test.df,
  compare_between_test.df
),representation=="linear"),'All Tasks')

#by task
RT_linear.df <- rbind(RT_linear.df,RT_g_CI(subset(locate_date_test.df,representation=="linear"),'Locate Date'))
RT_linear.df <- rbind(RT_linear.df,RT_g_CI(subset(read_value_test.df,representation=="linear"),'Read Value'))
RT_linear.df <- rbind(RT_linear.df,c('Read Value','Year',NA,NA,NA,length(levels(read_value_test.df$user_id)))) #year not tested
RT_linear.df <- rbind(RT_linear.df,RT_g_CI(subset(locate_minmax_test.df,representation=="linear"),'Locate Min / Max'))
RT_linear.df <- rbind(RT_linear.df,RT_g_CI(subset(compare_within_test.df,representation=="linear"),'Compare Values'))
RT_linear.df <- rbind(RT_linear.df,c('Compare Values','Year',NA,NA,NA,length(levels(compare_within_test.df$user_id)))) #year not tested
RT_linear.df <- rbind(RT_linear.df,RT_g_CI(subset(compare_between_test.df,representation=="linear"),'Compare Ranges'))

RT_linear.df$mean <- as.numeric(RT_linear.df$mean)
RT_linear.df$lowerBound_CI <- as.numeric(RT_linear.df$lowerBound_CI)
RT_linear.df$upperBound_CI <- as.numeric(RT_linear.df$upperBound_CI)

RT_linear.df$facet <- 'Linear'


# effect size computation

# combined
RT_diff_linear.df <- RT_g_CI_diff(subset(rbind(
  locate_date_test.df,
  read_value_test.df,
  locate_minmax_test.df,
  compare_within_test.df,
  compare_between_test.df
),representation=="linear"),'All Tasks')

#by task
RT_diff_linear.df <- rbind(RT_diff_linear.df,RT_g_CI_diff(subset(locate_date_test.df,representation=="linear"),'Locate Date'))
RT_diff_linear.df <- rbind(RT_diff_linear.df,RT_g_CI_diff(subset(read_value_test.df,representation=="linear"),'Read Value'))
RT_diff_linear.df <- rbind(RT_diff_linear.df,c('Read Value','Year - Month',NA,NA,NA,length(levels(read_value_test.df$user_id)))) #year-month not tested
RT_diff_linear.df <- rbind(RT_diff_linear.df,c('Read Value','Year - Week',NA,NA,NA,length(levels(read_value_test.df$user_id)))) #year-month not tested
RT_diff_linear.df <- rbind(RT_diff_linear.df,RT_g_CI_diff(subset(locate_minmax_test.df,representation=="linear"),'Locate Min / Max'))
RT_diff_linear.df <- rbind(RT_diff_linear.df,RT_g_CI_diff(subset(compare_within_test.df,representation=="linear"),'Compare Values'))
RT_diff_linear.df <- rbind(RT_diff_linear.df,c('Compare Values','Year - Month',NA,NA,NA,length(levels(compare_within_test.df$user_id)))) #year-month not tested
RT_diff_linear.df <- rbind(RT_diff_linear.df,c('Compare Values','Year - Week',NA,NA,NA,length(levels(compare_within_test.df$user_id)))) #year-month not tested
RT_diff_linear.df <- rbind(RT_diff_linear.df,RT_g_CI_diff(subset(compare_between_test.df,representation=="linear"),'Compare Ranges'))

RT_diff_linear.df$mean <- as.numeric(RT_diff_linear.df$mean)
RT_diff_linear.df$lowerBound_CI <- as.numeric(RT_diff_linear.df$lowerBound_CI)
RT_diff_linear.df$upperBound_CI <- as.numeric(RT_diff_linear.df$upperBound_CI)

RT_diff_linear.df$facet <- 'Linear'

#radial

# combined
RT_radial.df <- RT_g_CI(subset(rbind(
  locate_date_test.df,
  read_value_test.df,
  locate_minmax_test.df,
  compare_within_test.df,
  compare_between_test.df
),representation=="radial"),'All Tasks')

#by task
RT_radial.df <- rbind(RT_radial.df,RT_g_CI(subset(locate_date_test.df,representation=="radial"),'Locate Date'))
RT_radial.df <- rbind(RT_radial.df,RT_g_CI(subset(read_value_test.df,representation=="radial"),'Read Value'))
RT_radial.df <- rbind(RT_radial.df,c('Read Value','Year',NA,NA,NA,length(levels(read_value_test.df$user_id)))) #year not tested
RT_radial.df <- rbind(RT_radial.df,RT_g_CI(subset(locate_minmax_test.df,representation=="radial"),'Locate Min / Max'))
RT_radial.df <- rbind(RT_radial.df,RT_g_CI(subset(compare_within_test.df,representation=="radial"),'Compare Values'))
RT_radial.df <- rbind(RT_radial.df,c('Compare Values','Year',NA,NA,NA,length(levels(compare_within_test.df$user_id)))) #year not tested
RT_radial.df <- rbind(RT_radial.df,RT_g_CI(subset(compare_between_test.df,representation=="radial"),'Compare Ranges'))

RT_radial.df$mean <- as.numeric(RT_radial.df$mean)
RT_radial.df$lowerBound_CI <- as.numeric(RT_radial.df$lowerBound_CI)
RT_radial.df$upperBound_CI <- as.numeric(RT_radial.df$upperBound_CI)

RT_radial.df$facet <- 'Radial'


# effect size computation

# combined
RT_diff_radial.df <- RT_g_CI_diff(subset(rbind(
  locate_date_test.df,
  read_value_test.df,
  locate_minmax_test.df,
  compare_within_test.df,
  compare_between_test.df
),representation=="radial"),'All Tasks')

#by task
RT_diff_radial.df <- rbind(RT_diff_radial.df,RT_g_CI_diff(subset(locate_date_test.df,representation=="radial"),'Locate Date'))
RT_diff_radial.df <- rbind(RT_diff_radial.df,RT_g_CI_diff(subset(read_value_test.df,representation=="radial"),'Read Value'))
RT_diff_radial.df <- rbind(RT_diff_radial.df,c('Read Value','Year - Month',NA,NA,NA,length(levels(read_value_test.df$user_id)))) #year-month not tested
RT_diff_radial.df <- rbind(RT_diff_radial.df,c('Read Value','Year - Week',NA,NA,NA,length(levels(read_value_test.df$user_id)))) #year-month not tested
RT_diff_radial.df <- rbind(RT_diff_radial.df,RT_g_CI_diff(subset(locate_minmax_test.df,representation=="radial"),'Locate Min / Max'))
RT_diff_radial.df <- rbind(RT_diff_radial.df,RT_g_CI_diff(subset(compare_within_test.df,representation=="radial"),'Compare Values'))
RT_diff_radial.df <- rbind(RT_diff_radial.df,c('Compare Values','Year - Month',NA,NA,NA,length(levels(compare_within_test.df$user_id)))) #year-month not tested
RT_diff_radial.df <- rbind(RT_diff_radial.df,c('Compare Values','Year - Week',NA,NA,NA,length(levels(compare_within_test.df$user_id)))) #year-month not tested
RT_diff_radial.df <- rbind(RT_diff_radial.df,RT_g_CI_diff(subset(compare_between_test.df,representation=="radial"),'Compare Ranges'))

RT_diff_radial.df$mean <- as.numeric(RT_diff_radial.df$mean)
RT_diff_radial.df$lowerBound_CI <- as.numeric(RT_diff_radial.df$lowerBound_CI)
RT_diff_radial.df$upperBound_CI <- as.numeric(RT_diff_radial.df$upperBound_CI)

RT_diff_radial.df$facet <- 'Radial'

RT_x_g_r.df <- rbind(RT_linear.df,RT_radial.df)
remove(RT_linear.df,RT_radial.df)

RT_g.df <- rbind(RT_g.df,RT_x_g_r.df)
remove(RT_x_g_r.df)

RT_x_g_r_diff.df <- rbind(RT_diff_linear.df,RT_diff_radial.df)
remove(RT_diff_linear.df,RT_diff_radial.df)

RT_g_diff.df <- rbind(RT_g_diff.df,RT_x_g_r_diff.df)
remove(RT_x_g_r_diff.df)
