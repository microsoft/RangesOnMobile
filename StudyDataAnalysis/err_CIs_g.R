#error magnitude

err_g_CI <- function(result.df,task_name) {
  
  print(c("err_g_CI",nrow(result.df),task_name))
  
  #compute mean for each user_id and granularity
  err_aggregate.df <- aggregate(abs(result.df$error), list(result.df$user_id,result.df$granularity), mean)
  
  names(err_aggregate.df) <- c("user_id","granularity","error")
  
  err_week <- subset(err_aggregate.df, granularity=="week")$error
  err_month <- subset(err_aggregate.df, granularity=="month")$error
  n_err_week <- length(err_week)
  n_err_month <- length(err_month)
  if (task_name != 'Read Value' && task_name != 'Compare Values') {
    err_year <- subset(err_aggregate.df, granularity=="year")$error
    n_err_year <- length(err_year)
  }
  
  if (sum(err_week) == 0) {
    err_ci_week <- c(0,0,0)
  }
  else {
    err_ci_week <- bootstrapMeanCI(err_week)
  }
  if (sum(err_month) == 0) {
    err_ci_month <- c(0,0,0)
  }
  else {
    err_ci_month <- bootstrapMeanCI(err_month)
  }
  if (task_name != 'Read Value' && task_name != 'Compare Values' && sum(err_year) != 0) {
    err_ci_year <- bootstrapMeanCI(err_year)
  }
  else {
    err_ci_year <- c(0,0,0)
  }
  
  err_analysis = c()
  if (task_name != 'Read Value' && task_name != 'Compare Values') {
    err_analysis$ratio = c("Week","Month","Year")
    err_analysis$pointEstimate = c(err_ci_week[1],err_ci_month[1],err_ci_year[1])
    err_analysis$ci.max = c(err_ci_week[3],err_ci_month[3],err_ci_year[3])
    err_analysis$ci.min = c(err_ci_week[2],err_ci_month[2],err_ci_year[2])
    err_analysis$n = c(n_err_week,n_err_month,n_err_year)
  }
  else {
    err_analysis$ratio = c("Week","Month")
    err_analysis$pointEstimate = c(err_ci_week[1],err_ci_month[1])
    err_analysis$ci.max = c(err_ci_week[3],err_ci_month[3])
    err_analysis$ci.min = c(err_ci_week[2],err_ci_month[2])
    err_analysis$n = c(n_err_week,n_err_month)
  }
  
  err_analysis.df <- data.frame(task_name,factor(err_analysis$ratio),err_analysis$pointEstimate, err_analysis$ci.max, err_analysis$ci.min,err_analysis$n)
  colnames(err_analysis.df) <- c("task_name","granularity", "mean", "lowerBound_CI", "upperBound_CI","n")
  
  return(err_analysis.df)
}

err_g_CI_diff <- function(result.df,task_name) {
  
  print(c("err_g_CI_diff",nrow(result.df),task_name))
  
  #compute mean for each user_id and granularity
  err_aggregate.df <- aggregate(abs(result.df$error), list(result.df$user_id,result.df$granularity), mean)
  
  names(err_aggregate.df) <- c("user_id","granularity","error")
  
  err_week.df <- subset(err_aggregate.df, granularity=="week")
  err_month.df <- subset(err_aggregate.df, granularity=="month" & user_id %in% err_week.df$user_id)
  err_week.df <- subset(err_week.df, user_id %in% err_month.df$user_id)
  
  if (task_name != 'Read Value' && task_name != 'Compare Values') {
    err_year.df <-subset(err_aggregate.df, granularity=="year" & user_id %in% err_month.df$user_id)
    err_week.df <- subset(err_week.df, user_id %in% err_year.df$user_id)
    err_month.df <- subset(err_month.df, user_id %in% err_year.df$user_id)
    
    err_year <- err_year.df$error
  }
  
  err_week <- err_week.df$error
  err_month <- err_month.df$error
  
  err_month_week_diff <- err_month - err_week
  n_err_month_week_diff <- length(err_month_week_diff)
  if (task_name != 'Read Value' && task_name != 'Compare Values') {
    err_year_month_diff <- err_year - err_month
    n_err_year_month_diff <- length(err_year_month_diff)
    err_year_week_diff <- err_year - err_week
    n_err_year_week_diff <- length(err_year_week_diff)
  }
  err_ci_month_week_diff <- bootstrapMeanCI(err_month_week_diff)
  if (task_name != 'Read Value' && task_name != 'Compare Values') {
    err_ci_year_month_diff <- bootstrapMeanCI(err_year_month_diff)
    err_ci_year_week_diff <- bootstrapMeanCI(err_year_week_diff)
  }
  
  err_diff_analysis = c()
  if (task_name != 'Read Value' && task_name != 'Compare Values') {
    err_diff_analysis$ratio = c("Month - Week","Year - Month",'Year - Week')
    err_diff_analysis$pointEstimate = c(err_ci_month_week_diff[1],err_ci_year_month_diff[1],err_ci_year_week_diff[1])
    err_diff_analysis$ci.max = c(err_ci_month_week_diff[3],err_ci_year_month_diff[3],err_ci_year_week_diff[3])
    err_diff_analysis$ci.min = c(err_ci_month_week_diff[2],err_ci_year_month_diff[2],err_ci_year_week_diff[2])
    err_diff_analysis$n = c(n_err_month_week_diff,n_err_year_month_diff,n_err_year_week_diff)
  }
  else {
    err_diff_analysis$ratio = c("Month - Week")
    err_diff_analysis$pointEstimate = c(err_ci_month_week_diff[1])
    err_diff_analysis$ci.max = c(err_ci_month_week_diff[3])
    err_diff_analysis$ci.min = c(err_ci_month_week_diff[2])
    err_diff_analysis$n = c(n_err_month_week_diff)
  }
  
  err_diff_analysis.df <- data.frame(task_name,factor(err_diff_analysis$ratio),err_diff_analysis$pointEstimate, err_diff_analysis$ci.max, err_diff_analysis$ci.min,err_diff_analysis$n)
  colnames(err_diff_analysis.df) <- c("task_name","ratio", "mean", "lowerBound_CI", "upperBound_CI","n")
  
  return(err_diff_analysis.df)
}

#error rate

err_rate_g_CI <- function(result.df,task_name,week_count,month_count,year_count) {
  
  print(c("err_rate_g_CI",nrow(result.df),task_name))
  
  #compute mean for each user_id and granularity
  err_aggregate.df <- aggregate(abs(result.df$binary_error), list(result.df$user_id,result.df$granularity), sum)
  
  
  names(err_aggregate.df) <- c("user_id","granularity","error")
  
  err_week <- subset(err_aggregate.df, granularity=="week")$error
  err_week <- err_week / week_count
  err_month <- subset(err_aggregate.df, granularity=="month")$error
  err_month <- err_month / month_count
  n_err_week <- length(err_week)
  n_err_month <- length(err_month)
  if (task_name != 'Read Value' && task_name != 'Compare Values') {
    err_year <- subset(err_aggregate.df, granularity=="year")$error
    err_year <- err_year / year_count
    n_err_year <- length(err_year)
  }
  
  if (sum(err_week) == 0) {
    err_ci_week <- c(0,0,0)
  }
  else {
    err_ci_week <- bootstrapMeanCI(err_week)
  }
  if (sum(err_month) == 0) {
    err_ci_month <- c(0,0,0)
  }
  else {
    err_ci_month <- bootstrapMeanCI(err_month)
  }
  if (task_name != 'Read Value' && task_name != 'Compare Values' && sum(err_year) != 0) {
    err_ci_year <- bootstrapMeanCI(err_year)
  }
  else {
    err_ci_year <- c(0,0,0)
  }
  
  err_analysis = c()
  if (task_name != 'Read Value' && task_name != 'Compare Values') {
    err_analysis$ratio = c("Week","Month","Year")
    err_analysis$pointEstimate = c(err_ci_week[1],err_ci_month[1],err_ci_year[1])
    err_analysis$ci.max = c(err_ci_week[3],err_ci_month[3],err_ci_year[3])
    err_analysis$ci.min = c(err_ci_week[2],err_ci_month[2],err_ci_year[2])
    err_analysis$n = c(n_err_week,n_err_month,n_err_year)
  }
  else {
    err_analysis$ratio = c("Week","Month")
    err_analysis$pointEstimate = c(err_ci_week[1],err_ci_month[1])
    err_analysis$ci.max = c(err_ci_week[3],err_ci_month[3])
    err_analysis$ci.min = c(err_ci_week[2],err_ci_month[2])
    err_analysis$n = c(n_err_week,n_err_month)
  }
  
  err_analysis.df <- data.frame(task_name,factor(err_analysis$ratio),err_analysis$pointEstimate, err_analysis$ci.max, err_analysis$ci.min,err_analysis$n)
  colnames(err_analysis.df) <- c("task_name","granularity", "mean", "lowerBound_CI", "upperBound_CI","n")
  
  return(err_analysis.df)
}

err_rate_g_CI_diff <- function(result.df,task_name,week_count,month_count,year_count) {
  
  print(c("err_rate_g_CI_diff",nrow(result.df),task_name))
  
  #compute mean for each user_id and granularity
  err_aggregate.df <- aggregate(abs(result.df$binary_error), list(result.df$user_id,result.df$granularity), sum)
  
  names(err_aggregate.df) <- c("user_id","granularity","error")
  
  err_week.df <- subset(err_aggregate.df, granularity=="week")
  err_month.df <- subset(err_aggregate.df, granularity=="month" & user_id %in% err_week.df$user_id)
  err_week.df <- subset(err_week.df, user_id %in% err_month.df$user_id)
  
  if (task_name != 'Read Value' && task_name != 'Compare Values') {
    err_year.df <-subset(err_aggregate.df, granularity=="year" & user_id %in% err_month.df$user_id)
    err_week.df <- subset(err_week.df, user_id %in% err_year.df$user_id)
    err_month.df <- subset(err_month.df, user_id %in% err_year.df$user_id)
    
    err_year <- err_year.df$error
    err_year <- err_year / year_count
  }
  
  err_week <- err_week.df$error
  err_week <- err_week / week_count
  err_month <- err_month.df$error
  err_month <- err_month / month_count
  
  err_month_week_diff <- err_month - err_week
  n_err_month_week_diff <- length(err_month_week_diff)
  if (task_name != 'Read Value' && task_name != 'Compare Values') {
    err_year_month_diff <- err_year - err_month
    n_err_year_month_diff <- length(err_year_month_diff)
    err_year_week_diff <- err_year - err_week
    n_err_year_week_diff <- length(err_year_week_diff)
  }
  err_ci_month_week_diff <- bootstrapMeanCI(err_month_week_diff)
  if (task_name != 'Read Value' && task_name != 'Compare Values') {
    err_ci_year_month_diff <- bootstrapMeanCI(err_year_month_diff)
    err_ci_year_week_diff <- bootstrapMeanCI(err_year_week_diff)
  }
  
  err_diff_analysis = c()
  if (task_name != 'Read Value' && task_name != 'Compare Values') {
    err_diff_analysis$ratio = c("Month - Week","Year - Month",'Year - Week')
    err_diff_analysis$pointEstimate = c(err_ci_month_week_diff[1],err_ci_year_month_diff[1],err_ci_year_week_diff[1])
    err_diff_analysis$ci.max = c(err_ci_month_week_diff[3],err_ci_year_month_diff[3],err_ci_year_week_diff[3])
    err_diff_analysis$ci.min = c(err_ci_month_week_diff[2],err_ci_year_month_diff[2],err_ci_year_week_diff[2])
    err_diff_analysis$n = c(n_err_month_week_diff,n_err_year_month_diff,n_err_year_week_diff)
  }
  else {
    err_diff_analysis$ratio = c("Month - Week")
    err_diff_analysis$pointEstimate = c(err_ci_month_week_diff[1])
    err_diff_analysis$ci.max = c(err_ci_month_week_diff[3])
    err_diff_analysis$ci.min = c(err_ci_month_week_diff[2])
    err_diff_analysis$n = c(n_err_month_week_diff)
  }
  
  err_diff_analysis.df <- data.frame(task_name,factor(err_diff_analysis$ratio),err_diff_analysis$pointEstimate, err_diff_analysis$ci.max, err_diff_analysis$ci.min,err_diff_analysis$n)
  colnames(err_diff_analysis.df) <- c("task_name","ratio", "mean", "lowerBound_CI", "upperBound_CI","n")
  
  return(err_diff_analysis.df)
}

# combined
err_g.df <- err_g_CI(rbind(
  locate_date_test.df,
  read_value_test.df,
  locate_minmax_test.df,
  compare_within_test.df
),'All Tasks')

#by task
err_g.df <- rbind(err_g.df,err_g_CI(locate_date_test.df,'Locate Date'))
err_g.df <- rbind(err_g.df,err_g_CI(read_value_test.df,'Read Value'))
err_g.df <- rbind(err_g.df,c('Read Value','Year',NA,NA,NA,length(levels(read_value_test.df$user_id)))) #year not tested
err_g.df <- rbind(err_g.df,err_g_CI(locate_minmax_test.df,'Locate Min / Max'))
err_g.df <- rbind(err_g.df,err_g_CI(compare_within_test.df,'Compare Values'))
err_g.df <- rbind(err_g.df,c('Compare Values','Year',NA,NA,NA,length(levels(compare_within_test.df$user_id)))) #year not tested
compare_between_err_g.df <- err_g_CI(compare_between_test.df,'Compare Ranges')

err_g.df$mean <- as.numeric(err_g.df$mean)
err_g.df$lowerBound_CI <- as.numeric(err_g.df$lowerBound_CI)
err_g.df$upperBound_CI <- as.numeric(err_g.df$upperBound_CI)

compare_between_err_g.df$mean <- as.numeric(compare_between_err_g.df$mean)
compare_between_err_g.df$lowerBound_CI <- as.numeric(compare_between_err_g.df$lowerBound_CI)
compare_between_err_g.df$upperBound_CI <- as.numeric(compare_between_err_g.df$upperBound_CI)

err_g.df$facet <- 'Both Representations'
compare_between_err_g.df$facet <- 'Both Representations'

#effect size computation

# combined
err_g_diff.df <- err_g_CI_diff(rbind(
  locate_date_test.df,
  read_value_test.df,
  locate_minmax_test.df,
  compare_within_test.df
),'All Tasks')

#by task
err_g_diff.df <- rbind(err_g_diff.df,err_g_CI_diff(locate_date_test.df,'Locate Date'))
err_g_diff.df <- rbind(err_g_diff.df,err_g_CI_diff(read_value_test.df,'Read Value'))
err_g_diff.df <- rbind(err_g_diff.df,c('Read Value','Year - Month',NA,NA,NA,length(levels(read_value_test.df$user_id)))) #year-month not tested
err_g_diff.df <- rbind(err_g_diff.df,c('Read Value','Year - Week',NA,NA,NA,length(levels(read_value_test.df$user_id)))) #year-month not tested
err_g_diff.df <- rbind(err_g_diff.df,err_g_CI_diff(locate_minmax_test.df,'Locate Min / Max'))
err_g_diff.df <- rbind(err_g_diff.df,err_g_CI_diff(compare_within_test.df,'Compare Values'))
err_g_diff.df <- rbind(err_g_diff.df,c('Compare Values','Year - Month',NA,NA,NA,length(levels(compare_within_test.df$user_id)))) #year-month not tested
err_g_diff.df <- rbind(err_g_diff.df,c('Compare Values','Year - Week',NA,NA,NA,length(levels(compare_within_test.df$user_id)))) #year-month not tested
compare_between_err_g_diff.df <- err_g_CI_diff(compare_between_test.df,'Compare Ranges')

err_g_diff.df$mean <- as.numeric(err_g_diff.df$mean)
err_g_diff.df$lowerBound_CI <- as.numeric(err_g_diff.df$lowerBound_CI)
err_g_diff.df$upperBound_CI <- as.numeric(err_g_diff.df$upperBound_CI)

err_g_diff.df$facet <- 'Both Representations'

compare_between_err_g_diff.df$mean <- as.numeric(compare_between_err_g_diff.df$mean)
compare_between_err_g_diff.df$lowerBound_CI <- as.numeric(compare_between_err_g_diff.df$lowerBound_CI)
compare_between_err_g_diff.df$upperBound_CI <- as.numeric(compare_between_err_g_diff.df$upperBound_CI)

compare_between_err_g_diff.df$facet <- 'Both Representations'

# combined
err_rate_g.df <- err_rate_g_CI(rbind(
  locate_date_test.df,
  read_value_test.df,
  locate_minmax_test.df,
  compare_within_test.df,
  compare_between_test.df
),'All Tasks',36,36,12)

#by task
err_rate_g.df <- rbind(err_rate_g.df,err_rate_g_CI(locate_date_test.df,'Locate Date',4,4,4))
err_rate_g.df <- rbind(err_rate_g.df,err_rate_g_CI(read_value_test.df,'Read Value',8,8,0))
err_rate_g.df <- rbind(err_rate_g.df,c('Read Value','Year',NA,NA,NA,length(levels(read_value_test.df$user_id)))) #year-month not tested
err_rate_g.df <- rbind(err_rate_g.df,err_rate_g_CI(locate_minmax_test.df,'Locate Min / Max',12,12,4))
err_rate_g.df <- rbind(err_rate_g.df,err_rate_g_CI(compare_within_test.df,'Compare Values',8,8,0))
err_rate_g.df <- rbind(err_rate_g.df,c('Compare Values','Year',NA,NA,NA,length(levels(compare_within_test.df$user_id)))) #year-month not tested
err_rate_g.df <- rbind(err_rate_g.df,err_rate_g_CI(compare_between_test.df,'Compare Ranges',4,4,4))

err_rate_g.df$mean <- as.numeric(err_rate_g.df$mean)
err_rate_g.df$lowerBound_CI <- as.numeric(err_rate_g.df$lowerBound_CI)
err_rate_g.df$upperBound_CI <- as.numeric(err_rate_g.df$upperBound_CI)

err_rate_g.df$facet <- 'Both Representations'

#effect size computation

# diff combined
err_rate_g_diff.df <- err_rate_g_CI_diff(rbind(
  locate_date_test.df,
  read_value_test.df,
  locate_minmax_test.df,
  compare_within_test.df,
  compare_between_test.df
),'All Tasks',36,36,12)

#diff by task
err_rate_g_diff.df <- rbind(err_rate_g_diff.df,err_rate_g_CI_diff(locate_date_test.df,'Locate Date',4,4,4))
err_rate_g_diff.df <- rbind(err_rate_g_diff.df,err_rate_g_CI_diff(read_value_test.df,'Read Value',8,8,0))
err_rate_g_diff.df <- rbind(err_rate_g_diff.df,c('Read Value','Year - Month',NA,NA,NA,length(levels(read_value_test.df$user_id)))) #year-month not tested
err_rate_g_diff.df <- rbind(err_rate_g_diff.df,c('Read Value','Year - Week',NA,NA,NA,length(levels(read_value_test.df$user_id)))) #year-month not tested
err_rate_g_diff.df <- rbind(err_rate_g_diff.df,err_rate_g_CI_diff(locate_minmax_test.df,'Locate Min / Max',12,12,4))
err_rate_g_diff.df <- rbind(err_rate_g_diff.df,err_rate_g_CI_diff(compare_within_test.df,'Compare Values',8,8,0))
err_rate_g_diff.df <- rbind(err_rate_g_diff.df,c('Compare Values','Year - Month',NA,NA,NA,length(levels(compare_within_test.df$user_id)))) #year-month not tested
err_rate_g_diff.df <- rbind(err_rate_g_diff.df,c('Compare Values','Year - Week',NA,NA,NA,length(levels(compare_within_test.df$user_id)))) #year-month not tested
err_rate_g_diff.df <- rbind(err_rate_g_diff.df,err_rate_g_CI_diff(compare_between_test.df,'Compare Ranges',4,4,4))

err_rate_g_diff.df$mean <- as.numeric(err_rate_g_diff.df$mean)
err_rate_g_diff.df$lowerBound_CI <- as.numeric(err_rate_g_diff.df$lowerBound_CI)
err_rate_g_diff.df$upperBound_CI <- as.numeric(err_rate_g_diff.df$upperBound_CI)

err_rate_g_diff.df$facet <- 'Both Representations'

##
## linear
##

# linear
err_linear.df <- err_g_CI(subset(rbind(
  locate_date_test.df,
  read_value_test.df,
  locate_minmax_test.df,
  compare_within_test.df
),representation=="linear"),'All Tasks')

#by task
err_linear.df <- rbind(err_linear.df,err_g_CI(subset(locate_date_test.df,representation=="linear"),'Locate Date'))
err_linear.df <- rbind(err_linear.df,err_g_CI(subset(read_value_test.df,representation=="linear"),'Read Value'))
err_linear.df <- rbind(err_linear.df,c('Read Value','Year',NA,NA,NA,length(levels(read_value_test.df$user_id)))) #year not tested
err_linear.df <- rbind(err_linear.df,err_g_CI(subset(locate_minmax_test.df,representation=="linear"),'Locate Min / Max'))
err_linear.df <- rbind(err_linear.df,err_g_CI(subset(compare_within_test.df,representation=="linear"),'Compare Values'))
err_linear.df <- rbind(err_linear.df,c('Compare Values','Year',NA,NA,NA,length(levels(compare_within_test.df$user_id)))) #year not tested
compare_between_err_linear.df <- err_g_CI(subset(compare_between_test.df,representation=="linear"),'Compare Ranges')

err_linear.df$mean <- as.numeric(err_linear.df$mean)
err_linear.df$lowerBound_CI <- as.numeric(err_linear.df$lowerBound_CI)
err_linear.df$upperBound_CI <- as.numeric(err_linear.df$upperBound_CI)

err_linear.df$facet <- 'Linear'

compare_between_err_linear.df$mean <- as.numeric(compare_between_err_linear.df$mean)
compare_between_err_linear.df$lowerBound_CI <- as.numeric(compare_between_err_linear.df$lowerBound_CI)
compare_between_err_linear.df$upperBound_CI <- as.numeric(compare_between_err_linear.df$upperBound_CI)

compare_between_err_linear.df$facet <- 'Linear'

#effect size computation

# linear
err_diff_linear.df <- err_g_CI_diff(subset(rbind(
  locate_date_test.df,
  read_value_test.df,
  locate_minmax_test.df,
  compare_within_test.df
),representation=="linear"),'All Tasks')

#by task
err_diff_linear.df <- rbind(err_diff_linear.df,err_g_CI_diff(subset(locate_date_test.df,representation=="linear"),'Locate Date'))
err_diff_linear.df <- rbind(err_diff_linear.df,err_g_CI_diff(subset(read_value_test.df,representation=="linear"),'Read Value'))
err_diff_linear.df <- rbind(err_diff_linear.df,c('Read Value','Year - Month',NA,NA,NA,length(levels(read_value_test.df$user_id)))) #year-month not tested
err_diff_linear.df <- rbind(err_diff_linear.df,c('Read Value','Year - Week',NA,NA,NA,length(levels(read_value_test.df$user_id)))) #year-month not tested
err_diff_linear.df <- rbind(err_diff_linear.df,err_g_CI_diff(subset(locate_minmax_test.df,representation=="linear"),'Locate Min / Max'))
err_diff_linear.df <- rbind(err_diff_linear.df,err_g_CI_diff(subset(compare_within_test.df,representation=="linear"),'Compare Values'))
err_diff_linear.df <- rbind(err_diff_linear.df,c('Compare Values','Year - Month',NA,NA,NA,length(levels(compare_within_test.df$user_id)))) #year-month not tested
err_diff_linear.df <- rbind(err_diff_linear.df,c('Compare Values','Year - Week',NA,NA,NA,length(levels(compare_within_test.df$user_id)))) #year-month not tested
compare_between_err_diff_linear.df <- err_g_CI_diff(subset(compare_between_test.df,representation=="linear"),'Compare Ranges')

err_diff_linear.df$mean <- as.numeric(err_diff_linear.df$mean)
err_diff_linear.df$lowerBound_CI <- as.numeric(err_diff_linear.df$lowerBound_CI)
err_diff_linear.df$upperBound_CI <- as.numeric(err_diff_linear.df$upperBound_CI)

err_diff_linear.df$facet <- 'Linear'

compare_between_err_diff_linear.df$mean <- as.numeric(compare_between_err_diff_linear.df$mean)
compare_between_err_diff_linear.df$lowerBound_CI <- as.numeric(compare_between_err_diff_linear.df$lowerBound_CI)
compare_between_err_diff_linear.df$upperBound_CI <- as.numeric(compare_between_err_diff_linear.df$upperBound_CI)

compare_between_err_diff_linear.df$facet <- 'Linear'

#error as a percentage of # of trials

# linear
err_rate_linear.df <- err_rate_g_CI(subset(rbind(
  locate_date_test.df,
  read_value_test.df,
  locate_minmax_test.df,
  compare_within_test.df,
  compare_between_test.df
),representation=="linear"),'All Tasks',18,18,6)

#by task
err_rate_linear.df <- rbind(err_rate_linear.df,err_rate_g_CI(subset(locate_date_test.df,representation=="linear"),'Locate Date',2,2,2))
err_rate_linear.df <- rbind(err_rate_linear.df,err_rate_g_CI(subset(read_value_test.df,representation=="linear"),'Read Value',4,4,0))
err_rate_linear.df <- rbind(err_rate_linear.df,c('Read Value','Year',NA,NA,NA,length(levels(read_value_test.df$user_id)))) #year-month not tested
err_rate_linear.df <- rbind(err_rate_linear.df,err_rate_g_CI(subset(locate_minmax_test.df,representation=="linear"),'Locate Min / Max',6,6,2))
err_rate_linear.df <- rbind(err_rate_linear.df,err_rate_g_CI(subset(compare_within_test.df,representation=="linear"),'Compare Values',4,4,0))
err_rate_linear.df <- rbind(err_rate_linear.df,c('Compare Values','Year',NA,NA,NA,length(levels(compare_within_test.df$user_id)))) #year-month not tested
err_rate_linear.df <- rbind(err_rate_linear.df,err_rate_g_CI(subset(compare_between_test.df,representation=="linear"),'Compare Ranges',2,2,2))

err_rate_linear.df$mean <- as.numeric(err_rate_linear.df$mean)
err_rate_linear.df$lowerBound_CI <- as.numeric(err_rate_linear.df$lowerBound_CI)
err_rate_linear.df$upperBound_CI <- as.numeric(err_rate_linear.df$upperBound_CI)

err_rate_linear.df$facet <- 'Linear'

#effect size computation

# diff linear
err_rate_diff_linear.df <- err_rate_g_CI_diff(subset(rbind(
  locate_date_test.df,
  read_value_test.df,
  locate_minmax_test.df,
  compare_within_test.df,
  compare_between_test.df
),representation=="linear"),'All Tasks',18,18,6)

#diff by task
err_rate_diff_linear.df <- rbind(err_rate_diff_linear.df,err_rate_g_CI_diff(subset(locate_date_test.df,representation=="linear"),'Locate Date',2,2,2))
err_rate_diff_linear.df <- rbind(err_rate_diff_linear.df,err_rate_g_CI_diff(subset(read_value_test.df,representation=="linear"),'Read Value',4,4,0))
err_rate_diff_linear.df <- rbind(err_rate_diff_linear.df,c('Read Value','Year - Month',NA,NA,NA,length(levels(read_value_test.df$user_id)))) #year-month not tested
err_rate_diff_linear.df <- rbind(err_rate_diff_linear.df,c('Read Value','Year - Week',NA,NA,NA,length(levels(read_value_test.df$user_id)))) #year-month not tested
err_rate_diff_linear.df <- rbind(err_rate_diff_linear.df,err_rate_g_CI_diff(subset(locate_minmax_test.df,representation=="linear"),'Locate Min / Max',6,6,2))
err_rate_diff_linear.df <- rbind(err_rate_diff_linear.df,err_rate_g_CI_diff(subset(compare_within_test.df,representation=="linear"),'Compare Values',4,4,0))
err_rate_diff_linear.df <- rbind(err_rate_diff_linear.df,c('Compare Values','Year - Month',NA,NA,NA,length(levels(compare_within_test.df$user_id)))) #year-month not tested
err_rate_diff_linear.df <- rbind(err_rate_diff_linear.df,c('Compare Values','Year - Week',NA,NA,NA,length(levels(compare_within_test.df$user_id)))) #year-month not tested
err_rate_diff_linear.df <- rbind(err_rate_diff_linear.df,err_rate_g_CI_diff(subset(compare_between_test.df,representation=="linear"),'Compare Ranges',2,2,2))

err_rate_diff_linear.df$mean <- as.numeric(err_rate_diff_linear.df$mean)
err_rate_diff_linear.df$lowerBound_CI <- as.numeric(err_rate_diff_linear.df$lowerBound_CI)
err_rate_diff_linear.df$upperBound_CI <- as.numeric(err_rate_diff_linear.df$upperBound_CI)

err_rate_diff_linear.df$facet <- 'Linear'

##
## radial
##

# radial
err_radial.df <- err_g_CI(subset(rbind(
  locate_date_test.df,
  read_value_test.df,
  locate_minmax_test.df,
  compare_within_test.df
),representation=="radial"),'All Tasks')

#by task
# err_radial.df <- rbind(err_radial.df,as.data.frame(list(task_name='Locate Date',granularity='Week',mean=NA,upperBound_CI=NA,lowerBound_CI=NA,n=length(levels(locate_date.df$user_id))))) #no errors
# err_radial.df <- rbind(err_radial.df,c('Locate Date','Month',NA,NA,NA,length(levels(locate_date.df$user_id)))) #no errors
# err_radial.df <- rbind(err_radial.df,c('Locate Date','Year',NA,NA,NA,length(levels(locate_date.df$user_id)))) #no errors
err_radial.df <- rbind(err_radial.df,err_g_CI(subset(locate_date_test.df,representation=="radial"),'Locate Date'))
err_radial.df <- rbind(err_radial.df,err_g_CI(subset(read_value_test.df,representation=="radial"),'Read Value'))
err_radial.df <- rbind(err_radial.df,c('Read Value','Year',NA,NA,NA,length(levels(read_value_test.df$user_id)))) #year not tested
err_radial.df <- rbind(err_radial.df,err_g_CI(subset(locate_minmax_test.df,representation=="radial"),'Locate Min / Max'))
err_radial.df <- rbind(err_radial.df,err_g_CI(subset(compare_within_test.df,representation=="radial"),'Compare Values'))
err_radial.df <- rbind(err_radial.df,c('Compare Values','Year',NA,NA,NA,length(levels(compare_within_test.df$user_id)))) #year not tested
compare_between_err_radial.df <- err_g_CI(subset(compare_between_test.df,representation=="radial"),'Compare Ranges')

err_radial.df$mean <- as.numeric(err_radial.df$mean)
err_radial.df$lowerBound_CI <- as.numeric(err_radial.df$lowerBound_CI)
err_radial.df$upperBound_CI <- as.numeric(err_radial.df$upperBound_CI)

err_radial.df$facet <- 'Radial'

compare_between_err_radial.df$mean <- as.numeric(compare_between_err_radial.df$mean)
compare_between_err_radial.df$lowerBound_CI <- as.numeric(compare_between_err_radial.df$lowerBound_CI)
compare_between_err_radial.df$upperBound_CI <- as.numeric(compare_between_err_radial.df$upperBound_CI)

compare_between_err_radial.df$facet <- 'Radial'

#effect size computation

# radial
err_diff_radial.df <- err_g_CI_diff(subset(rbind(
  locate_date_test.df,
  read_value_test.df,
  locate_minmax_test.df,
  compare_within_test.df
),representation=="radial"),'All Tasks')

#by task
err_diff_radial.df <- rbind(err_diff_radial.df,err_g_CI_diff(subset(locate_date_test.df,representation=="radial"),'Locate Date'))
err_diff_radial.df <- rbind(err_diff_radial.df,err_g_CI_diff(subset(read_value_test.df,representation=="radial"),'Read Value'))
err_diff_radial.df <- rbind(err_diff_radial.df,c('Read Value','Year - Month',NA,NA,NA,length(levels(read_value_test.df$user_id)))) #year-month not tested
err_diff_radial.df <- rbind(err_diff_radial.df,c('Read Value','Year - Week',NA,NA,NA,length(levels(read_value_test.df$user_id)))) #year-month not tested
err_diff_radial.df <- rbind(err_diff_radial.df,err_g_CI_diff(subset(locate_minmax_test.df,representation=="radial"),'Locate Min / Max'))
err_diff_radial.df <- rbind(err_diff_radial.df,err_g_CI_diff(subset(compare_within_test.df,representation=="radial"),'Compare Values'))
err_diff_radial.df <- rbind(err_diff_radial.df,c('Compare Values','Year - Month',NA,NA,NA,length(levels(compare_within_test.df$user_id)))) #year-month not tested
err_diff_radial.df <- rbind(err_diff_radial.df,c('Compare Values','Year - Week',NA,NA,NA,length(levels(compare_within_test.df$user_id)))) #year-month not tested
compare_between_err_diff_radial.df <- err_g_CI_diff(subset(compare_between_test.df,representation=="radial"),'Compare Ranges')

err_diff_radial.df$mean <- as.numeric(err_diff_radial.df$mean)
err_diff_radial.df$lowerBound_CI <- as.numeric(err_diff_radial.df$lowerBound_CI)
err_diff_radial.df$upperBound_CI <- as.numeric(err_diff_radial.df$upperBound_CI)

err_diff_radial.df$facet <- 'Radial'

compare_between_err_diff_radial.df$mean <- as.numeric(compare_between_err_diff_radial.df$mean)
compare_between_err_diff_radial.df$lowerBound_CI <- as.numeric(compare_between_err_diff_radial.df$lowerBound_CI)
compare_between_err_diff_radial.df$upperBound_CI <- as.numeric(compare_between_err_diff_radial.df$upperBound_CI)

compare_between_err_diff_radial.df$facet <- 'Radial'

#error as a percentage of # of trials

# radial
err_rate_radial.df <- err_rate_g_CI(subset(rbind(
  locate_date_test.df,
  read_value_test.df,
  locate_minmax_test.df,
  compare_within_test.df,
  compare_between_test.df
),representation=="radial"),'All Tasks',18,18,6)

#by task

# err_rate_radial.df <- rbind(err_rate_radial.df,as.data.frame(list(task_name='Locate Date',granularity='Week',mean=NA,upperBound_CI=NA,lowerBound_CI=NA,n=length(levels(locate_date.df$user_id))))) #no errors
# err_rate_radial.df <- rbind(err_rate_radial.df,c('Locate Date','Month',NA,NA,NA,length(levels(locate_date.df$user_id)))) #no errors
# err_rate_radial.df <- rbind(err_rate_radial.df,c('Locate Date','Year',NA,NA,NA,length(levels(locate_date.df$user_id)))) #no errors
err_rate_radial.df <- rbind(err_rate_radial.df,err_rate_g_CI(subset(locate_date_test.df,representation=="radial"),'Locate Date',2,2,2))
err_rate_radial.df <- rbind(err_rate_radial.df,err_rate_g_CI(subset(read_value_test.df,representation=="radial"),'Read Value',4,4,0))
err_rate_radial.df <- rbind(err_rate_radial.df,c('Read Value','Year',NA,NA,NA,length(levels(read_value_test.df$user_id)))) #year-month not tested
err_rate_radial.df <- rbind(err_rate_radial.df,err_rate_g_CI(subset(locate_minmax_test.df,representation=="radial"),'Locate Min / Max',6,6,2))
err_rate_radial.df <- rbind(err_rate_radial.df,err_rate_g_CI(subset(compare_within_test.df,representation=="radial"),'Compare Values',4,4,0))
err_rate_radial.df <- rbind(err_rate_radial.df,c('Compare Values','Year',NA,NA,NA,length(levels(compare_within_test.df$user_id)))) #year-month not tested
err_rate_radial.df <- rbind(err_rate_radial.df,err_rate_g_CI(subset(compare_between_test.df,representation=="radial"),'Compare Ranges',2,2,2))

err_rate_radial.df$mean <- as.numeric(err_rate_radial.df$mean)
err_rate_radial.df$lowerBound_CI <- as.numeric(err_rate_radial.df$lowerBound_CI)
err_rate_radial.df$upperBound_CI <- as.numeric(err_rate_radial.df$upperBound_CI)

err_rate_radial.df$facet <- 'Radial'

#effect size computation

# diff radial
err_rate_diff_radial.df <- err_rate_g_CI_diff(subset(rbind(
  locate_date_test.df,
  read_value_test.df,
  locate_minmax_test.df,
  compare_within_test.df,
  compare_between_test.df
),representation=="radial"),'All Tasks',18,18,6)

#diff by task
err_rate_diff_radial.df <- rbind(err_rate_diff_radial.df,err_rate_g_CI_diff(subset(locate_date_test.df,representation=="radial"),'Locate Date',2,2,2))
err_rate_diff_radial.df <- rbind(err_rate_diff_radial.df,err_rate_g_CI_diff(subset(read_value_test.df,representation=="radial"),'Read Value',4,4,0))
err_rate_diff_radial.df <- rbind(err_rate_diff_radial.df,c('Read Value','Year - Month',NA,NA,NA,length(levels(read_value_test.df$user_id)))) #year-month not tested
err_rate_diff_radial.df <- rbind(err_rate_diff_radial.df,c('Read Value','Year - Week',NA,NA,NA,length(levels(read_value_test.df$user_id)))) #year-month not tested
err_rate_diff_radial.df <- rbind(err_rate_diff_radial.df,err_rate_g_CI_diff(subset(locate_minmax_test.df,representation=="radial"),'Locate Min / Max',6,6,2))
err_rate_diff_radial.df <- rbind(err_rate_diff_radial.df,err_rate_g_CI_diff(subset(compare_within_test.df,representation=="radial"),'Compare Values',4,4,0))
err_rate_diff_radial.df <- rbind(err_rate_diff_radial.df,c('Compare Values','Year - Month',NA,NA,NA,length(levels(compare_within_test.df$user_id)))) #year-month not tested
err_rate_diff_radial.df <- rbind(err_rate_diff_radial.df,c('Compare Values','Year - Week',NA,NA,NA,length(levels(compare_within_test.df$user_id)))) #year-month not tested
err_rate_diff_radial.df <- rbind(err_rate_diff_radial.df,err_rate_g_CI_diff(subset(compare_between_test.df,representation=="radial"),'Compare Ranges',2,2,2))

err_rate_diff_radial.df$mean <- as.numeric(err_rate_diff_radial.df$mean)
err_rate_diff_radial.df$lowerBound_CI <- as.numeric(err_rate_diff_radial.df$lowerBound_CI)
err_rate_diff_radial.df$upperBound_CI <- as.numeric(err_rate_diff_radial.df$upperBound_CI)

err_rate_diff_radial.df$facet <- 'Radial'

err_x_g_r.df <- rbind(err_linear.df,err_radial.df)
remove(err_linear.df,err_radial.df)

err_g.df <- rbind(err_g.df,err_x_g_r.df)
remove(err_x_g_r.df)

err_x_g_r_diff.df <- rbind(err_diff_linear.df,err_diff_radial.df)
remove(err_diff_linear.df,err_diff_radial.df)

err_g_diff.df <- rbind(err_g_diff.df,err_x_g_r_diff.df)
remove(err_x_g_r_diff.df)

compare_between_err_x_g_r.df <- rbind(compare_between_err_linear.df,compare_between_err_radial.df)
remove(compare_between_err_linear.df,compare_between_err_radial.df)

compare_between_err_g.df <- rbind(compare_between_err_g.df,compare_between_err_x_g_r.df)
remove(compare_between_err_x_g_r.df)

compare_between_err_x_g_r_diff.df <- rbind(compare_between_err_diff_linear.df,compare_between_err_diff_radial.df)
remove(compare_between_err_diff_linear.df,compare_between_err_diff_radial.df)

compare_between_err_g_diff.df <- rbind(compare_between_err_g_diff.df,compare_between_err_x_g_r_diff.df)
remove(compare_between_err_x_g_r_diff.df)

err_rate_x_g_r.df <- rbind(err_rate_linear.df,err_rate_radial.df)
remove(err_rate_linear.df,err_rate_radial.df)

err_rate_g.df <- rbind(err_rate_g.df,err_rate_x_g_r.df)
remove(err_rate_x_g_r.df)

err_rate_x_g_r_diff.df <- rbind(err_rate_diff_linear.df,err_rate_diff_radial.df)
remove(err_rate_diff_linear.df,err_rate_diff_radial.df)

err_rate_g_diff.df <- rbind(err_rate_g_diff.df,err_rate_x_g_r_diff.df)
remove(err_rate_x_g_r_diff.df)
