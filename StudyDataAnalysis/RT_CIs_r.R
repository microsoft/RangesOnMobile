RT_r_CI <- function(result.df,task_name) {
  
  print(c("RT_r_CI",nrow(result.df),task_name))
  
  result.df$response_time_secs <- result.df$response_time / 1000
  result.df$log_response_time <- log(result.df$response_time_secs)
  
  #compute mean for each user_id and representation
  RT_aggregate.df <- aggregate(abs(result.df$log_response_time), list(result.df$user_id,result.df$representation), mean)

  names(RT_aggregate.df) <- c("user_id","representation","log_response_time")
  
  RTlog_linear <- subset(RT_aggregate.df, representation=="linear")$log_response_time
  RTlog_radial <- subset(RT_aggregate.df, representation=="radial")$log_response_time
  
  n_RT_linear <- length(RTlog_linear)
  n_RT_radial <- length(RTlog_radial)
  
  ttest_RT_linear <- t.test(RTlog_linear, conf.level = 0.95)
  ttest_RT_radial <- t.test(RTlog_radial, conf.level = 0.95)
  
  mean_RT_linear = mean(RTlog_linear)
  mean_RT_radial = mean(RTlog_radial)
  
  cimax_RT_linear = exp(ttest_RT_linear$conf.int[2])
  cimax_RT_radial = exp(ttest_RT_radial$conf.int[2])
  
  cimin_RT_linear = exp(ttest_RT_linear$conf.int[1])
  cimin_RT_radial = exp(ttest_RT_radial$conf.int[1])
  
  mean_RT_linear = exp(mean_RT_linear)
  mean_RT_radial = exp(mean_RT_radial)
  
  RT_analysis = c()
  RT_analysis$ratio = c("Linear","Radial")
  RT_analysis$pointEstimate = c(mean_RT_linear,mean_RT_radial)
  RT_analysis$ci.max = c(cimax_RT_linear,cimax_RT_radial)
  RT_analysis$ci.min = c(cimin_RT_linear,cimin_RT_radial)
  RT_analysis$n = c(n_RT_linear,n_RT_radial)
  
  RT_analysis.df <- data.frame(task_name,factor(RT_analysis$ratio),RT_analysis$pointEstimate, RT_analysis$ci.max, RT_analysis$ci.min,RT_analysis$n)
  colnames(RT_analysis.df) <- c("task_name","representation", "mean", "upperBound_CI", "lowerBound_CI","n")
  
  return(RT_analysis.df)
}

RT_r_CI_diff <- function(result.df,task_name) {
  
  print(c("RT_r_CI_diff",nrow(result.df),task_name))
  
  result.df$response_time_secs <- result.df$response_time / 1000
  result.df$log_response_time <- log(result.df$response_time_secs)
  
  #compute mean for each user_id and representation
  RT_aggregate.df <- aggregate(abs(result.df$log_response_time), list(result.df$user_id,result.df$representation), mean)
  
  names(RT_aggregate.df) <- c("user_id","representation","log_response_time")
  
  RTlog_linear.df <- subset(RT_aggregate.df, representation=="linear")
  RTlog_radial.df <- subset(RT_aggregate.df, representation=="radial" & user_id %in% RTlog_linear.df$user_id)
  RTlog_linear.df <- subset(RTlog_linear.df, user_id %in% RTlog_radial.df$user_id)
  
  RTlog_linear <- RTlog_linear.df$log_response_time
  RTlog_radial <- RTlog_radial.df$log_response_time
  
  RTdiff <- RTlog_radial - RTlog_linear
  
  n_RTdiff <- length(RTdiff)

  ttest_RT_r_diff <- t.test(RTdiff, conf.level = 0.95)

  mean_RT_r_diff <- exp(mean(RTdiff))

  cimax_RT_r_diff <- exp(ttest_RT_r_diff$conf.int[2])
  cimin_RT_r_diff <- exp(ttest_RT_r_diff$conf.int[1])

  RT_r_diff_analysis = c()
  RT_r_diff_analysis$ratio = c("Radial - Linear")
  RT_r_diff_analysis$pointEstimate = c(mean_RT_r_diff)
  RT_r_diff_analysis$ci.max = c(cimax_RT_r_diff)
  RT_r_diff_analysis$ci.min = c(cimin_RT_r_diff)
  RT_r_diff_analysis$n = c(n_RTdiff)

  RT_r_diff_analysis.df <- data.frame(task_name,factor(RT_r_diff_analysis$ratio),RT_r_diff_analysis$pointEstimate, RT_r_diff_analysis$ci.max, RT_r_diff_analysis$ci.min, RT_r_diff_analysis$n)
  colnames(RT_r_diff_analysis.df) <- c("task_name","ratio", "mean", "lowerBound_CI", "upperBound_CI","n")
  
  return(RT_r_diff_analysis.df)
}

#CI computationt

# combined
RT_r.df <- RT_r_CI(rbind(
  locate_date_test.df,
  read_value_test.df,
  locate_minmax_test.df,
  compare_within_test.df,
  compare_between_test.df
  ),'All Tasks')

#by task
RT_r.df <- rbind(RT_r.df,RT_r_CI(locate_date_test.df,'Locate Date'))
RT_r.df <- rbind(RT_r.df,RT_r_CI(read_value_test.df,'Read Value'))
RT_r.df <- rbind(RT_r.df,RT_r_CI(locate_minmax_test.df,'Locate Min / Max'))
RT_r.df <- rbind(RT_r.df,RT_r_CI(compare_within_test.df,'Compare Values'))
RT_r.df <- rbind(RT_r.df,RT_r_CI(compare_between_test.df,'Compare Ranges'))

RT_r.df$facet <- 'All Granularities'

# effect size computation

# combined
RT_r_diff.df <- RT_r_CI_diff(rbind(
  locate_date_test.df,
  read_value_test.df,
  locate_minmax_test.df,
  compare_within_test.df,
  compare_between_test.df
),'All Tasks')

#by task
RT_r_diff.df <- rbind(RT_r_diff.df,RT_r_CI_diff(locate_date_test.df,'Locate Date'))
RT_r_diff.df <- rbind(RT_r_diff.df,RT_r_CI_diff(read_value_test.df,'Read Value'))
RT_r_diff.df <- rbind(RT_r_diff.df,RT_r_CI_diff(locate_minmax_test.df,'Locate Min / Max'))
RT_r_diff.df <- rbind(RT_r_diff.df,RT_r_CI_diff(compare_within_test.df,'Compare Values'))
RT_r_diff.df <- rbind(RT_r_diff.df,RT_r_CI_diff(compare_between_test.df,'Compare Ranges'))

RT_r_diff.df$facet <- 'All Granularities'

#week granularity

# combined
RT_week.df <- RT_r_CI(subset(rbind(
  locate_date_test.df,
  read_value_test.df,
  locate_minmax_test.df,
  compare_within_test.df,
  compare_between_test.df
),granularity=="week"),'All Tasks')

#by task
RT_week.df <- rbind(RT_week.df,RT_r_CI(subset(locate_date_test.df,granularity=="week"),'Locate Date'))
RT_week.df <- rbind(RT_week.df,RT_r_CI(subset(read_value_test.df,granularity=="week"),'Read Value'))
RT_week.df <- rbind(RT_week.df,RT_r_CI(subset(locate_minmax_test.df,granularity=="week"),'Locate Min / Max'))
RT_week.df <- rbind(RT_week.df,RT_r_CI(subset(compare_within_test.df,granularity=="week"),'Compare Values'))
RT_week.df <- rbind(RT_week.df,RT_r_CI(subset(compare_between_test.df,granularity=="week"),'Compare Ranges'))

RT_week.df$facet <- 'Week'

# effect size computation

# combined
RT_diff_week.df <- RT_r_CI_diff(subset(rbind(
  locate_date_test.df,
  read_value_test.df,
  locate_minmax_test.df,
  compare_within_test.df,
  compare_between_test.df
),granularity=="week"),'All Tasks')

#by task
RT_diff_week.df <- rbind(RT_diff_week.df,RT_r_CI_diff(subset(locate_date_test.df,granularity=="week"),'Locate Date'))
RT_diff_week.df <- rbind(RT_diff_week.df,RT_r_CI_diff(subset(read_value_test.df,granularity=="week"),'Read Value'))
RT_diff_week.df <- rbind(RT_diff_week.df,RT_r_CI_diff(subset(locate_minmax_test.df,granularity=="week"),'Locate Min / Max'))
RT_diff_week.df <- rbind(RT_diff_week.df,RT_r_CI_diff(subset(compare_within_test.df,granularity=="week"),'Compare Values'))
RT_diff_week.df <- rbind(RT_diff_week.df,RT_r_CI_diff(subset(compare_between_test.df,granularity=="week"),'Compare Ranges'))

RT_diff_week.df$facet <- 'Week'

#month granularity

# combined
RT_month.df <- RT_r_CI(subset(rbind(
  locate_date_test.df,
  read_value_test.df,
  locate_minmax_test.df,
  compare_within_test.df,
  compare_between_test.df
),granularity=="month"),'All Tasks')

#by task
RT_month.df <- rbind(RT_month.df,RT_r_CI(subset(locate_date_test.df,granularity=="month"),'Locate Date'))
RT_month.df <- rbind(RT_month.df,RT_r_CI(subset(read_value_test.df,granularity=="month"),'Read Value'))
RT_month.df <- rbind(RT_month.df,RT_r_CI(subset(locate_minmax_test.df,granularity=="month"),'Locate Min / Max'))
RT_month.df <- rbind(RT_month.df,RT_r_CI(subset(compare_within_test.df,granularity=="month"),'Compare Values'))
RT_month.df <- rbind(RT_month.df,RT_r_CI(subset(compare_between_test.df,granularity=="month"),'Compare Ranges'))

RT_month.df$facet <- 'Month'

# effect size computation

# combined
RT_diff_month.df <- RT_r_CI_diff(subset(rbind(
  locate_date_test.df,
  read_value_test.df,
  locate_minmax_test.df,
  compare_within_test.df,
  compare_between_test.df
),granularity=="month"),'All Tasks')

#by task
RT_diff_month.df <- rbind(RT_diff_month.df,RT_r_CI_diff(subset(locate_date_test.df,granularity=="month"),'Locate Date'))
RT_diff_month.df <- rbind(RT_diff_month.df,RT_r_CI_diff(subset(read_value_test.df,granularity=="month"),'Read Value'))
RT_diff_month.df <- rbind(RT_diff_month.df,RT_r_CI_diff(subset(locate_minmax_test.df,granularity=="month"),'Locate Min / Max'))
RT_diff_month.df <- rbind(RT_diff_month.df,RT_r_CI_diff(subset(compare_within_test.df,granularity=="month"),'Compare Values'))
RT_diff_month.df <- rbind(RT_diff_month.df,RT_r_CI_diff(subset(compare_between_test.df,granularity=="month"),'Compare Ranges'))

RT_diff_month.df$facet <- 'Month'

#year granularity

# combined
RT_year.df <- RT_r_CI(subset(rbind(
  locate_date_test.df,
  read_value_test.df,
  locate_minmax_test.df,
  compare_within_test.df,
  compare_between_test.df
),granularity=="year"),'All Tasks')

#by task
RT_year.df <- rbind(RT_year.df,RT_r_CI(subset(locate_date_test.df,granularity=="year"),'Locate Date'))
RT_year.df <- rbind(RT_year.df,as.data.frame(list(task_name='Read Value',representation='Linear',mean=NA,upperBound_CI=NA,lowerBound_CI=NA,n=length(levels(read_value_test.df$user_id))))) #year not tested
RT_year.df <- rbind(RT_year.df,as.data.frame(list(task_name='Read Value',representation='Radial',mean=NA,upperBound_CI=NA,lowerBound_CI=NA,n=length(levels(read_value_test.df$user_id))))) #year not tested
RT_year.df <- rbind(RT_year.df,RT_r_CI(subset(locate_minmax_test.df,granularity=="year"),'Locate Min / Max'))
RT_year.df <- rbind(RT_year.df,as.data.frame(list(task_name='Compare Values',representation='Linear',mean=NA,upperBound_CI=NA,lowerBound_CI=NA,n=length(levels(compare_within_test.df$user_id))))) #year not tested
RT_year.df <- rbind(RT_year.df,as.data.frame(list(task_name='Compare Values',representation='Radial',mean=NA,upperBound_CI=NA,lowerBound_CI=NA,n=length(levels(compare_within_test.df$user_id))))) #year not tested
RT_year.df <- rbind(RT_year.df,RT_r_CI(subset(compare_between_test.df,granularity=="year"),'Compare Ranges'))

RT_year.df$facet <- 'Year'

# effect size computation

# combined
RT_diff_year.df <- RT_r_CI_diff(subset(rbind(
  locate_date_test.df,
  read_value_test.df,
  locate_minmax_test.df,
  compare_within_test.df,
  compare_between_test.df
),granularity=="year"),'All Tasks')

#by task
RT_diff_year.df <- rbind(RT_diff_year.df,RT_r_CI_diff(subset(locate_date_test.df,granularity=="year"),'Locate Date'))
RT_diff_year.df <- rbind(RT_diff_year.df,as.data.frame(list(task_name='Read Value',ratio='Radial - Linear',mean=NA,upperBound_CI=NA,lowerBound_CI=NA,n=length(levels(read_value_test.df$user_id))))) #year not tested
RT_diff_year.df <- rbind(RT_diff_year.df,RT_r_CI_diff(subset(locate_minmax_test.df,granularity=="year"),'Locate Min / Max'))
RT_diff_year.df <- rbind(RT_diff_year.df,as.data.frame(list(task_name='Compare Values',ratio='Radial - Linear',mean=NA,upperBound_CI=NA,lowerBound_CI=NA,n=length(levels(compare_within_test.df$user_id))))) #year not tested
RT_diff_year.df <- rbind(RT_diff_year.df,RT_r_CI_diff(subset(compare_between_test.df,granularity=="year"),'Compare Ranges'))

RT_diff_year.df$facet <- 'Year'

# recombine granularities for plotting

RT_x_r_g.df <- rbind(RT_week.df,RT_month.df,RT_year.df)
remove(RT_week.df,RT_month.df,RT_year.df)

RT_r.df <- rbind(RT_r.df,RT_x_r_g.df)
remove(RT_x_r_g.df)

RT_r.df$facet <- ordered(RT_r.df$facet, levels = c("All Granularities","Week", "Month", "Year"))

RT_x_r_g_diff.df <- rbind(RT_diff_week.df,RT_diff_month.df,RT_diff_year.df)
remove(RT_diff_week.df,RT_diff_month.df,RT_diff_year.df)

RT_r_diff.df <- rbind(RT_r_diff.df,RT_x_r_g_diff.df)
remove(RT_x_r_g_diff.df)

RT_r_diff.df$facet <- ordered(RT_r_diff.df$facet, levels = c("All Granularities","Week", "Month", "Year"))