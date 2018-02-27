
#error magnitude
err_r_CI <- function(result.df,task_name) {
  
  print(c("err_r_CI",nrow(result.df),task_name))
  
  #compute mean for each user_id and representation
  err_aggregate.df <- aggregate(abs(result.df$error), list(result.df$user_id,result.df$representation), mean)
  
  names(err_aggregate.df) <- c("user_id","representation","error")
  
  err_linear <- subset(err_aggregate.df, representation=="linear")$error
  err_radial <- subset(err_aggregate.df, representation=="radial")$error
  
  n_err_linear <- length(err_linear)
  n_err_radial <- length(err_radial)
  
  if (sum(err_linear) == 0) {
    err_ci_linear <- c(0,0,0)
  }
  else {
    err_ci_linear <- bootstrapMeanCI(err_linear)
  }
  if (sum(err_radial) == 0) {
    err_ci_radial <- c(0,0,0)
  }
  else {
    err_ci_radial <- bootstrapMeanCI(err_radial)
  }

  err_analysis = c()
  err_analysis$ratio = c("Linear","Radial")
  err_analysis$pointEstimate = c(err_ci_linear[1],err_ci_radial[1])
  err_analysis$ci.max = c(err_ci_linear[3],err_ci_radial[3])
  err_analysis$ci.min = c(err_ci_linear[2],err_ci_radial[2])
  err_analysis$n = c(n_err_linear,n_err_radial)
  
  err_analysis.df <- data.frame(task_name,factor(err_analysis$ratio),err_analysis$pointEstimate, err_analysis$ci.max, err_analysis$ci.min,err_analysis$n)
  colnames(err_analysis.df) <- c("task_name","representation", "mean", "lowerBound_CI", "upperBound_CI","n")
  
  return(err_analysis.df)
}

err_r_CI_diff <- function(result.df,task_name) {
  
  print(c("err_r_CI",nrow(result.df),task_name))
  
  #compute mean for each user_id and representation
  err_aggregate.df <- aggregate(abs(result.df$error), list(result.df$user_id,result.df$representation), mean)
  
  names(err_aggregate.df) <- c("user_id","representation","error")
  
  err_linear.df <- subset(err_aggregate.df, representation=="linear")
  err_radial.df <- subset(err_aggregate.df, representation=="radial" & user_id %in% err_linear.df$user_id)
  err_linear.df <- subset(err_linear.df, user_id %in% err_radial.df$user_id)
  
  err_linear <- subset(err_linear.df, representation=="linear")$error
  err_radial <- subset(err_radial.df, representation=="radial")$error
  
  err_diff <- err_radial - err_linear
  n_err_diff <- length(err_diff)
  
  if (sum(err_radial) == 0 || sum(err_linear) == 0) {
    err_ci_diff <- c(NA,NA,NA)
  }
  else {
    err_ci_diff <- bootstrapMeanCI(err_diff)
  }
  
  err_diff_analysis = c()
  err_diff_analysis$ratio = c("Radial - Linear")
  err_diff_analysis$pointEstimate = c(err_ci_diff[1])
  err_diff_analysis$ci.max = c(err_ci_diff[3])
  err_diff_analysis$ci.min = c(err_ci_diff[2])
  err_diff_analysis$n = c(n_err_diff)
  
  err_diff_analysis.df <- data.frame(task_name,factor(err_diff_analysis$ratio),err_diff_analysis$pointEstimate, err_diff_analysis$ci.max, err_diff_analysis$ci.min,err_diff_analysis$n)
  colnames(err_diff_analysis.df) <- c("task_name","ratio", "mean", "lowerBound_CI", "upperBound_CI","n")
  
  return(err_diff_analysis.df)
}

#error as a percentage of # of trials

err_rate_r_CI <- function(result.df,task_name,trial_count) {
  
  print(c("err_rate_r_CI",nrow(result.df),task_name))
  
  #compute sum for each user_id and representation
  err_aggregate.df <- aggregate(abs(result.df$binary_error), list(result.df$user_id,result.df$representation), sum)
  
  names(err_aggregate.df) <- c("user_id","representation","error")
  
  err_aggregate.df$error <- err_aggregate.df$error / trial_count
  
  err_linear <- subset(err_aggregate.df, representation=="linear")$error
  err_radial <- subset(err_aggregate.df, representation=="radial")$error
  
  n_err_linear <- length(err_linear)
  n_err_radial <- length(err_radial)
  
  if (sum(err_linear) == 0) {
    err_ci_linear <- c(0,0,0)
  }
  else {
    err_ci_linear <- bootstrapMeanCI(err_linear)
  }
  if (sum(err_radial) == 0) {
    err_ci_radial <- c(0,0,0)
  }
  else {
    err_ci_radial <- bootstrapMeanCI(err_radial)
  }
  
  err_analysis = c()
  err_analysis$ratio = c("Linear","Radial")
  err_analysis$pointEstimate = c(err_ci_linear[1],err_ci_radial[1])
  err_analysis$ci.max = c(err_ci_linear[3],err_ci_radial[3])
  err_analysis$ci.min = c(err_ci_linear[2],err_ci_radial[2])
  err_analysis$n = c(n_err_linear,n_err_radial)
  
  err_analysis.df <- data.frame(task_name,factor(err_analysis$ratio),err_analysis$pointEstimate, err_analysis$ci.max, err_analysis$ci.min,err_analysis$n)
  colnames(err_analysis.df) <- c("task_name","representation", "mean", "lowerBound_CI", "upperBound_CI","n")
  
  return(err_analysis.df)
}

err_rate_r_CI_diff <- function(result.df,task_name,trial_count) {
  
  print(c("err_rate_r_CI_diff",nrow(result.df),task_name))
  
  #compute sum for each user_id and representation
  err_aggregate.df <- aggregate(abs(result.df$binary_error), list(result.df$user_id,result.df$representation), sum)
  
  names(err_aggregate.df) <- c("user_id","representation","error")
  
  err_aggregate.df$error <- err_aggregate.df$error / trial_count
  
  err_linear.df <- subset(err_aggregate.df, representation=="linear")
  err_radial.df <- subset(err_aggregate.df, representation=="radial" & user_id %in% err_linear.df$user_id)
  err_linear.df <- subset(err_linear.df, user_id %in% err_radial.df$user_id)
  
  err_linear <- subset(err_linear.df, representation=="linear")$error
  err_radial <- subset(err_radial.df, representation=="radial")$error
  
  err_diff <- err_radial - err_linear
  n_err_diff <- length(err_diff)
  
  if (sum(err_radial) == 0 || sum(err_linear) == 0) {
    err_ci_diff <- c(NA,NA,NA)
  }
  else {
    err_ci_diff <- bootstrapMeanCI(err_diff)
  }
  
  err_diff_analysis = c()
  err_diff_analysis$ratio = c("Radial - Linear")
  err_diff_analysis$pointEstimate = c(err_ci_diff[1])
  err_diff_analysis$ci.max = c(err_ci_diff[3])
  err_diff_analysis$ci.min = c(err_ci_diff[2])
  err_diff_analysis$n = c(n_err_diff)
  
  err_diff_analysis.df <- data.frame(task_name,factor(err_diff_analysis$ratio),err_diff_analysis$pointEstimate, err_diff_analysis$ci.max, err_diff_analysis$ci.min,err_diff_analysis$n)
  colnames(err_diff_analysis.df) <- c("task_name","ratio", "mean", "lowerBound_CI", "upperBound_CI","n")
  
  return(err_diff_analysis.df)
}

# combined
err_r.df <- err_r_CI(rbind(
  locate_date_test.df,
  read_value_test.df,
  locate_minmax_test.df,
  compare_within_test.df
),'All Tasks')

#by task
err_r.df <- rbind(err_r.df,err_r_CI(locate_date_test.df,'Locate Date'))
err_r.df <- rbind(err_r.df,err_r_CI(read_value_test.df,'Read Value'))
err_r.df <- rbind(err_r.df,err_r_CI(locate_minmax_test.df,'Locate Min / Max'))
err_r.df <- rbind(err_r.df,err_r_CI(compare_within_test.df,'Compare Values'))
compare_between_err_r.df <- err_r_CI(compare_between_test.df,'Compare Ranges')

err_r.df$facet <- 'All Granularities'
compare_between_err_r.df$facet <- 'All Granularities'

#effect size computation

# combined
err_r_diff.df <- err_r_CI_diff(rbind(
  locate_date_test.df,
  read_value_test.df,
  locate_minmax_test.df,
  compare_within_test.df
),'All Tasks')

#by task
err_r_diff.df <- rbind(err_r_diff.df,err_r_CI_diff(locate_date_test.df,'Locate Date'))
err_r_diff.df <- rbind(err_r_diff.df,err_r_CI_diff(read_value_test.df,'Read Value'))
err_r_diff.df <- rbind(err_r_diff.df,err_r_CI_diff(locate_minmax_test.df,'Locate Min / Max'))
err_r_diff.df <- rbind(err_r_diff.df,err_r_CI_diff(compare_within_test.df,'Compare Values'))
compare_between_err_r_diff.df <- err_r_CI_diff(compare_between_test.df,'Compare Ranges')

err_r_diff.df$facet <- 'All Granularities'
compare_between_err_r_diff.df$facet <- 'All Granularities'

# combined
err_rate_r.df <- err_rate_r_CI(rbind(
  locate_date_test.df,
  read_value_test.df,
  locate_minmax_test.df,
  compare_within_test.df,
  compare_between_test.df
),'All Tasks',42)

#by task
err_rate_r.df <- rbind(err_rate_r.df,err_rate_r_CI(locate_date_test.df,'Locate Date',6))
err_rate_r.df <- rbind(err_rate_r.df,err_rate_r_CI(read_value_test.df,'Read Value',8))
err_rate_r.df <- rbind(err_rate_r.df,err_rate_r_CI(locate_minmax_test.df,'Locate Min / Max',14))
err_rate_r.df <- rbind(err_rate_r.df,err_rate_r_CI(compare_within_test.df,'Compare Values',8))
err_rate_r.df <- rbind(err_rate_r.df,err_rate_r_CI(compare_between_test.df,'Compare Ranges',6))

err_rate_r.df$facet <- 'All Granularities'

#effect size computation

# diff combined
err_rate_r_diff.df <- err_rate_r_CI_diff(rbind(
  locate_date_test.df,
  read_value_test.df,
  locate_minmax_test.df,
  compare_within_test.df,
  compare_between_test.df
),'All Tasks',42)

#diff by task
err_rate_r_diff.df <- rbind(err_rate_r_diff.df,err_rate_r_CI_diff(locate_date_test.df,'Locate Date',6))
err_rate_r_diff.df <- rbind(err_rate_r_diff.df,err_rate_r_CI_diff(read_value_test.df,'Read Value',8))
err_rate_r_diff.df <- rbind(err_rate_r_diff.df,err_rate_r_CI_diff(locate_minmax_test.df,'Locate Min / Max',14))
err_rate_r_diff.df <- rbind(err_rate_r_diff.df,err_rate_r_CI_diff(compare_within_test.df,'Compare Values',8))
err_rate_r_diff.df <- rbind(err_rate_r_diff.df,err_rate_r_CI_diff(compare_between_test.df,'Compare Ranges',6))

err_rate_r_diff.df$facet <- 'All Granularities'

##
## week
##

err_week.df <- err_r_CI(subset(rbind(
  locate_date_test.df,
  read_value_test.df,
  locate_minmax_test.df,
  compare_within_test.df
),granularity=="week"),'All Tasks')

#by task
err_week.df <- rbind(err_week.df,err_r_CI(subset(locate_date_test.df,granularity=="week"),'Locate Date'))
err_week.df <- rbind(err_week.df,err_r_CI(subset(read_value_test.df,granularity=="week"),'Read Value'))
err_week.df <- rbind(err_week.df,err_r_CI(subset(locate_minmax_test.df,granularity=="week"),'Locate Min / Max'))
err_week.df <- rbind(err_week.df,err_r_CI(subset(compare_within_test.df,granularity=="week"),'Compare Values'))
compare_between_err_week.df <- err_r_CI(subset(compare_between_test.df,granularity=="week"),'Compare Ranges')

err_week.df$facet <- 'Week'
compare_between_err_week.df$facet <- 'Week'

#effect size computation

# week
err_diff_week.df <- err_r_CI_diff(subset(rbind(
  locate_date_test.df,
  read_value_test.df,
  locate_minmax_test.df,
  compare_within_test.df
),granularity=="week"),'All Tasks')

#by task
err_diff_week.df <- rbind(err_diff_week.df,err_r_CI_diff(subset(locate_date_test.df,granularity=="week"),'Locate Date'))
err_diff_week.df <- rbind(err_diff_week.df,err_r_CI_diff(subset(read_value_test.df,granularity=="week"),'Read Value'))
err_diff_week.df <- rbind(err_diff_week.df,err_r_CI_diff(subset(locate_minmax_test.df,granularity=="week"),'Locate Min / Max'))
err_diff_week.df <- rbind(err_diff_week.df,err_r_CI_diff(subset(compare_within_test.df,granularity=="week"),'Compare Values'))
compare_between_err_diff_week.df <- err_r_CI_diff(subset(compare_between_test.df,granularity=="week"),'Compare Ranges')

err_diff_week.df$facet <- 'Week'
compare_between_err_diff_week.df$facet <- 'Week'

# week
err_rate_week.df <- err_rate_r_CI(subset(rbind(
  locate_date_test.df,
  read_value_test.df,
  locate_minmax_test.df,
  compare_within_test.df,
  compare_between_test.df
),granularity=="week"),'All Tasks',18)

#by task

err_rate_week.df <- rbind(err_rate_week.df,err_rate_r_CI(subset(locate_date_test.df,granularity=="week"),'Locate Date',2))
err_rate_week.df <- rbind(err_rate_week.df,err_rate_r_CI(subset(read_value_test.df,granularity=="week"),'Read Value',4))
err_rate_week.df <- rbind(err_rate_week.df,err_rate_r_CI(subset(locate_minmax_test.df,granularity=="week"),'Locate Min / Max',6))
err_rate_week.df <- rbind(err_rate_week.df,err_rate_r_CI(subset(compare_within_test.df,granularity=="week"),'Compare Values',4))
err_rate_week.df <- rbind(err_rate_week.df,err_rate_r_CI(subset(compare_between_test.df,granularity=="week"),'Compare Ranges',2))

err_rate_week.df$facet <- 'Week'

#effect size computation

# diff week
err_rate_diff_week.df <- err_rate_r_CI_diff(subset(rbind(
  locate_date_test.df,
  read_value_test.df,
  locate_minmax_test.df,
  compare_within_test.df,
  compare_between_test.df
),granularity=="week"),'All Tasks',18)

#diff by task
err_rate_diff_week.df <- rbind(err_rate_diff_week.df,err_rate_r_CI_diff(subset(locate_date_test.df,granularity=="week"),'Locate Date',2))
err_rate_diff_week.df <- rbind(err_rate_diff_week.df,err_rate_r_CI_diff(subset(read_value_test.df,granularity=="week"),'Read Value',4))
err_rate_diff_week.df <- rbind(err_rate_diff_week.df,err_rate_r_CI_diff(subset(locate_minmax_test.df,granularity=="week"),'Locate Min / Max',6))
err_rate_diff_week.df <- rbind(err_rate_diff_week.df,err_rate_r_CI_diff(subset(compare_within_test.df,granularity=="week"),'Compare Values',4))
err_rate_diff_week.df <- rbind(err_rate_diff_week.df,err_rate_r_CI_diff(subset(compare_between_test.df,granularity=="week"),'Compare Ranges',2))

err_rate_diff_week.df$facet <- 'Week'

##
## month
##

err_month.df <- err_r_CI(subset(rbind(
  locate_date_test.df,
  read_value_test.df,
  locate_minmax_test.df,
  compare_within_test.df
),granularity=="month"),'All Tasks')

#by task
err_month.df <- rbind(err_month.df,err_r_CI(subset(locate_date_test.df,granularity=="month"),'Locate Date'))
err_month.df <- rbind(err_month.df,err_r_CI(subset(read_value_test.df,granularity=="month"),'Read Value'))
err_month.df <- rbind(err_month.df,err_r_CI(subset(locate_minmax_test.df,granularity=="month"),'Locate Min / Max'))
err_month.df <- rbind(err_month.df,err_r_CI(subset(compare_within_test.df,granularity=="month"),'Compare Values'))
compare_between_err_month.df <- err_r_CI(subset(compare_between_test.df,granularity=="month"),'Compare Ranges')

err_month.df$facet <- 'Month'
compare_between_err_month.df$facet <- 'Month'

#effect size computation

# month
err_diff_month.df <- err_r_CI_diff(subset(rbind(
  locate_date_test.df,
  read_value_test.df,
  locate_minmax_test.df,
  compare_within_test.df
),granularity=="month"),'All Tasks')

#by task
err_diff_month.df <- rbind(err_diff_month.df,err_r_CI_diff(subset(locate_date_test.df,granularity=="month"),'Locate Date'))
err_diff_month.df <- rbind(err_diff_month.df,err_r_CI_diff(subset(read_value_test.df,granularity=="month"),'Read Value'))
err_diff_month.df <- rbind(err_diff_month.df,err_r_CI_diff(subset(locate_minmax_test.df,granularity=="month"),'Locate Min / Max'))
err_diff_month.df <- rbind(err_diff_month.df,err_r_CI_diff(subset(compare_within_test.df,granularity=="month"),'Compare Values'))
compare_between_err_diff_month.df <- err_r_CI_diff(subset(compare_between_test.df,granularity=="month"),'Compare Ranges')

err_diff_month.df$facet <- 'Month'
compare_between_err_diff_month.df$facet <- 'Month'

# month
err_rate_month.df <- err_rate_r_CI(subset(rbind(
  locate_date_test.df,
  read_value_test.df,
  locate_minmax_test.df,
  compare_within_test.df,
  compare_between_test.df
),granularity=="month"),'All Tasks',18)

#by task
err_rate_month.df <- rbind(err_rate_month.df,err_rate_r_CI(subset(locate_date_test.df,granularity=="month"),'Locate Date',2))
err_rate_month.df <- rbind(err_rate_month.df,err_rate_r_CI(subset(read_value_test.df,granularity=="month"),'Read Value',4))
err_rate_month.df <- rbind(err_rate_month.df,err_rate_r_CI(subset(locate_minmax_test.df,granularity=="month"),'Locate Min / Max',6))
err_rate_month.df <- rbind(err_rate_month.df,err_rate_r_CI(subset(compare_within_test.df,granularity=="month"),'Compare Values',4))
err_rate_month.df <- rbind(err_rate_month.df,err_rate_r_CI(subset(compare_between_test.df,granularity=="month"),'Compare Ranges',2))

err_rate_month.df$facet <- 'Month'

#effect size computation

# diff month
err_rate_diff_month.df <- err_rate_r_CI_diff(subset(rbind(
  locate_date_test.df,
  read_value_test.df,
  locate_minmax_test.df,
  compare_within_test.df,
  compare_between_test.df
),granularity=="month"),'All Tasks',18)

#diff by task
err_rate_diff_month.df <- rbind(err_rate_diff_month.df,err_rate_r_CI_diff(subset(locate_date_test.df,granularity=="month"),'Locate Date',2))
err_rate_diff_month.df <- rbind(err_rate_diff_month.df,err_rate_r_CI_diff(subset(read_value_test.df,granularity=="month"),'Read Value',4))
err_rate_diff_month.df <- rbind(err_rate_diff_month.df,err_rate_r_CI_diff(subset(locate_minmax_test.df,granularity=="month"),'Locate Min / Max',6))
err_rate_diff_month.df <- rbind(err_rate_diff_month.df,err_rate_r_CI_diff(subset(compare_within_test.df,granularity=="month"),'Compare Values',4))
err_rate_diff_month.df <- rbind(err_rate_diff_month.df,err_rate_r_CI_diff(subset(compare_between_test.df,granularity=="month"),'Compare Ranges',2))

err_rate_diff_month.df$facet <- 'Month'

##
## year
##

err_year.df <- err_r_CI(subset(rbind(
  locate_date_test.df,
  read_value_test.df,
  locate_minmax_test.df,
  compare_within_test.df
),granularity=="year"),'All Tasks')

#by task
err_year.df <- rbind(err_year.df,err_r_CI(subset(locate_date_test.df,granularity=="year"),'Locate Date'))
err_year.df <- rbind(err_year.df,as.data.frame(list(task_name='Read Value',representation='Linear',mean=NA,upperBound_CI=NA,lowerBound_CI=NA,n=length(levels(read_value_test.df$user_id))))) #year not tested
err_year.df <- rbind(err_year.df,as.data.frame(list(task_name='Read Value',representation='Radial',mean=NA,upperBound_CI=NA,lowerBound_CI=NA,n=length(levels(read_value_test.df$user_id))))) #year not tested
err_year.df <- rbind(err_year.df,err_r_CI(subset(locate_minmax_test.df,granularity=="year"),'Locate Min / Max'))
err_year.df <- rbind(err_year.df,as.data.frame(list(task_name='Compare Values',representation='Linear',mean=NA,upperBound_CI=NA,lowerBound_CI=NA,n=length(levels(compare_within_test.df$user_id))))) #year not tested
err_year.df <- rbind(err_year.df,as.data.frame(list(task_name='Compare Values',representation='Radial',mean=NA,upperBound_CI=NA,lowerBound_CI=NA,n=length(levels(compare_within_test.df$user_id))))) #year not tested
compare_between_err_year.df <- err_r_CI(subset(compare_between_test.df,granularity=="year"),'Compare Ranges')

err_year.df$facet <- 'Year'
compare_between_err_year.df$facet <- 'Year'

#effect size computation

# year
err_diff_year.df <- err_r_CI_diff(subset(rbind(
  locate_date_test.df,
  read_value_test.df,
  locate_minmax_test.df,
  compare_within_test.df
),granularity=="year"),'All Tasks')

#by task
err_diff_year.df <- rbind(err_diff_year.df,err_r_CI_diff(subset(locate_date_test.df,granularity=="year"),'Locate Date'))
err_diff_year.df <- rbind(err_diff_year.df,as.data.frame(list(task_name='Read Value',ratio='Radial - Linear',mean=NA,upperBound_CI=NA,lowerBound_CI=NA,n=length(levels(read_value_test.df$user_id))))) #year not tested
err_diff_year.df <- rbind(err_diff_year.df,err_r_CI_diff(subset(locate_minmax_test.df,granularity=="year"),'Locate Min / Max'))
err_diff_year.df <- rbind(err_diff_year.df,as.data.frame(list(task_name='Compare Values',ratio='Radial - Linear',mean=NA,upperBound_CI=NA,lowerBound_CI=NA,n=length(levels(compare_within_test.df$user_id))))) #year not tested
compare_between_err_diff_year.df <- err_r_CI_diff(subset(compare_between_test.df,granularity=="year"),'Compare Ranges')

err_diff_year.df$facet <- 'Year'
compare_between_err_diff_year.df$facet <- 'Year'

# year
err_rate_year.df <- err_rate_r_CI(subset(rbind(
  locate_date_test.df,
  read_value_test.df,
  locate_minmax_test.df,
  compare_within_test.df,
  compare_between_test.df
),granularity=="year"),'All Tasks',6)

#by task
err_rate_year.df <- rbind(err_rate_year.df,err_rate_r_CI(subset(locate_date_test.df,granularity=="year"),'Locate Date',2))
err_rate_year.df <- rbind(err_rate_year.df,as.data.frame(list(task_name='Read Value',representation='Linear',mean=NA,upperBound_CI=NA,lowerBound_CI=NA,n=length(levels(read_value_test.df$user_id))))) #year not tested
err_rate_year.df <- rbind(err_rate_year.df,as.data.frame(list(task_name='Read Value',representation='Radial',mean=NA,upperBound_CI=NA,lowerBound_CI=NA,n=length(levels(read_value_test.df$user_id))))) #year not tested
err_rate_year.df <- rbind(err_rate_year.df,err_rate_r_CI(subset(locate_minmax_test.df,granularity=="year"),'Locate Min / Max',2))
err_rate_year.df <- rbind(err_rate_year.df,as.data.frame(list(task_name='Compare Values',representation='Linear',mean=NA,upperBound_CI=NA,lowerBound_CI=NA,n=length(levels(compare_within_test.df$user_id))))) #year not tested
err_rate_year.df <- rbind(err_rate_year.df,as.data.frame(list(task_name='Compare Values',representation='Radial',mean=NA,upperBound_CI=NA,lowerBound_CI=NA,n=length(levels(compare_within_test.df$user_id))))) #year not tested
err_rate_year.df <- rbind(err_rate_year.df,err_rate_r_CI(subset(compare_between_test.df,granularity=="year"),'Compare Ranges',2))

err_rate_year.df$facet <- 'Year'

#effect size computation

# diff year
err_rate_diff_year.df <- err_rate_r_CI_diff(subset(rbind(
  locate_date_test.df,
  read_value_test.df,
  locate_minmax_test.df,
  compare_within_test.df,
  compare_between_test.df
),granularity=="year"),'All Tasks',6)

#diff by task
err_rate_diff_year.df <- rbind(err_rate_diff_year.df,err_rate_r_CI_diff(subset(locate_date_test.df,granularity=="year"),'Locate Date',2))
err_rate_diff_year.df <- rbind(err_rate_diff_year.df,as.data.frame(list(task_name='Read Value',ratio='Radial - Linear',mean=NA,upperBound_CI=NA,lowerBound_CI=NA,n=length(levels(read_value_test.df$user_id))))) #year not tested
err_rate_diff_year.df <- rbind(err_rate_diff_year.df,err_rate_r_CI_diff(subset(locate_minmax_test.df,granularity=="year"),'Locate Min / Max',2))
err_rate_diff_year.df <- rbind(err_rate_diff_year.df,as.data.frame(list(task_name='Compare Values',ratio='Radial - Linear',mean=NA,upperBound_CI=NA,lowerBound_CI=NA,n=length(levels(compare_within_test.df$user_id))))) #year not tested
err_rate_diff_year.df <- rbind(err_rate_diff_year.df,err_rate_r_CI_diff(subset(compare_between_test.df,granularity=="year"),'Compare Ranges',2))

err_rate_diff_year.df$facet <- 'Year'

# recombine granularities for plotting

err_x_r_g.df <- rbind(err_week.df,err_month.df,err_year.df)
remove(err_week.df,err_month.df,err_year.df)

err_r.df <- rbind(err_r.df,err_x_r_g.df)
remove(err_x_r_g.df)
err_r.df$facet <- ordered(err_r.df$facet, levels = c("All Granularities","Week", "Month", "Year"))

err_x_r_g_diff.df <- rbind(err_diff_week.df,err_diff_month.df,err_diff_year.df)
remove(err_diff_week.df,err_diff_month.df,err_diff_year.df)

err_r_diff.df <- rbind(err_r_diff.df,err_x_r_g_diff.df)
remove(err_x_r_g_diff.df)
err_r_diff.df$facet <- ordered(err_r_diff.df$facet, levels = c("All Granularities","Week", "Month", "Year"))

compare_between_err_x_r_g.df <- rbind(compare_between_err_week.df,compare_between_err_month.df,compare_between_err_year.df)
remove(compare_between_err_week.df,compare_between_err_month.df,compare_between_err_year.df)

compare_between_err_r.df <- rbind(compare_between_err_r.df,compare_between_err_x_r_g.df)
remove(compare_between_err_x_r_g.df)
compare_between_err_r.df$facet <- ordered(compare_between_err_r.df$facet, levels = c("All Granularities","Week", "Month", "Year"))

compare_between_err_x_r_g_diff.df <- rbind(compare_between_err_diff_week.df,compare_between_err_diff_month.df,compare_between_err_diff_year.df)
remove(compare_between_err_diff_week.df,compare_between_err_diff_month.df,compare_between_err_diff_year.df)

compare_between_err_r_diff.df <- rbind(compare_between_err_r_diff.df,compare_between_err_x_r_g_diff.df)
remove(compare_between_err_x_r_g_diff.df)
compare_between_err_r_diff.df$facet <- ordered(compare_between_err_r_diff.df$facet, levels = c("All Granularities","Week", "Month", "Year"))

err_rate_x_r_g.df <- rbind(err_rate_week.df,err_rate_month.df,err_rate_year.df)
remove(err_rate_week.df,err_rate_month.df,err_rate_year.df)

err_rate_r.df <- rbind(err_rate_r.df,err_rate_x_r_g.df)
remove(err_rate_x_r_g.df)
err_rate_r.df$facet <- ordered(err_rate_r.df$facet, levels = c("All Granularities","Week", "Month", "Year"))

err_rate_x_r_g_diff.df <- rbind(err_rate_diff_week.df,err_rate_diff_month.df,err_rate_diff_year.df)
remove(err_rate_diff_week.df,err_rate_diff_month.df,err_rate_diff_year.df)

err_rate_r_diff.df <- rbind(err_rate_r_diff.df,err_rate_x_r_g_diff.df)
remove(err_rate_x_r_g_diff.df)
err_rate_r_diff.df$facet <- ordered(err_rate_r_diff.df$facet, levels = c("All Granularities","Week", "Month", "Year"))

