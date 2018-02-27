#confidence
conf_r_CI <- function(result.df,granularity) {
  
  #compute mean for each user_id and representation
  conf_aggregate.df <- aggregate(abs(result.df$Response), list(result.df$user_id,result.df$representation), mean)
  
  names(conf_aggregate.df) <- c("user_id","representation","Response")
  
  conf_linear <- subset(conf_aggregate.df, representation=="linear")$Response
  conf_radial <- subset(conf_aggregate.df, representation=="radial")$Response
  
  conf_ci_linear <- bootstrapMeanCI(conf_linear)
  conf_ci_radial <- bootstrapMeanCI(conf_radial)
  
  conf_analysis = c()
  conf_analysis$ratio = c("Linear","Radial")
  conf_analysis$pointEstimate = c(conf_ci_linear[1],conf_ci_radial[1])
  conf_analysis$ci.max = c(conf_ci_linear[3],conf_ci_radial[3])
  conf_analysis$ci.min = c(conf_ci_linear[2],conf_ci_radial[2])
  
  conf_analysis.df <- data.frame(granularity,factor(conf_analysis$ratio),conf_analysis$pointEstimate, conf_analysis$ci.max, conf_analysis$ci.min)
  colnames(conf_analysis.df) <- c("task_name","representation", "mean", "lowerBound_CI", "upperBound_CI")
  
  return(conf_analysis.df)
}

conf_r_CI_diff <- function(result.df,granularity) {
  
  #compute mean for each user_id and representation
  conf_aggregate.df <- aggregate(abs(result.df$Response), list(result.df$user_id,result.df$representation), mean)
  
  names(conf_aggregate.df) <- c("user_id","representation","Response")
  
  conf_linear <- subset(conf_aggregate.df, representation=="linear")$Response
  conf_radial <- subset(conf_aggregate.df, representation=="radial")$Response
  
  conf_diff <- conf_radial - conf_linear
  conf_ci_diff <- bootstrapMeanCI(conf_diff)
  
  conf_diff_analysis = c()
  conf_diff_analysis$ratio = c("Radial - Linear")
  conf_diff_analysis$pointEstimate = c(conf_ci_diff[1])
  conf_diff_analysis$ci.max = c(conf_ci_diff[3])
  conf_diff_analysis$ci.min = c(conf_ci_diff[2])
  
  conf_diff_analysis.df <- data.frame(granularity,factor(conf_diff_analysis$ratio),conf_diff_analysis$pointEstimate, conf_diff_analysis$ci.max, conf_diff_analysis$ci.min)
  colnames(conf_diff_analysis.df) <- c("task_name","ratio", "mean", "lowerBound_CI", "upperBound_CI")
  
  return(conf_diff_analysis.df)
}

# combined
conf_r.df <- conf_r_CI(confidence.df,'Overall')

#by granularity
conf_r.df <- rbind(conf_r.df,conf_r_CI(subset(confidence.df,granularity=="week"),'Week'))
conf_r.df <- rbind(conf_r.df,conf_r_CI(subset(confidence.df,granularity=="month"),'Month'))
conf_r.df <- rbind(conf_r.df,conf_r_CI(subset(confidence.df,granularity=="year"),'Year'))

conf_r.df$facet <- 'Overall'

#effect size computation

# combined
conf_r_diff.df <- conf_r_CI_diff(confidence.df,'Overall')

#by granularity
conf_r_diff.df <- rbind(conf_r_diff.df,conf_r_CI_diff(subset(confidence.df,granularity=="week"),'Week'))
conf_r_diff.df <- rbind(conf_r_diff.df,conf_r_CI_diff(subset(confidence.df,granularity=="month"),'Month'))
conf_r_diff.df <- rbind(conf_r_diff.df,conf_r_CI_diff(subset(confidence.df,granularity=="year"),'Year'))

conf_r_diff.df$facet <- 'Overall'
