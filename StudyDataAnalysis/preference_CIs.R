percentCI <- function(datapoints, granularity, value) {
  nvalue <- length(datapoints[datapoints == value])
  total <- length(datapoints)
  percent <- 100 * nvalue / total
  proportionCI <- midPci(x = nvalue, n = total, conf.level = 0.95)
  percentCIlow <- 100 * proportionCI$conf.int[1]
  percentCIhigh <- 100 * proportionCI$conf.int[2]
  analysis.df <- data.frame(granularity,value,percent, percentCIlow, percentCIhigh)
  colnames(analysis.df) <- c("task_name","representation", "mean", "lowerBound_CI", "upperBound_CI")
  return (analysis.df)
}

preference_CI.df <- percentCI(subset(preference.df,granularity=="week")$representation,'Week','linear')
preference_CI.df <- rbind(preference_CI.df,percentCI(subset(preference.df,granularity=="week")$representation,'Week','radial'))
preference_CI.df <- rbind(preference_CI.df,percentCI(subset(preference.df,granularity=="month")$representation,'Month','linear'))
preference_CI.df <- rbind(preference_CI.df,percentCI(subset(preference.df,granularity=="month")$representation,'Month','radial'))
preference_CI.df <- rbind(preference_CI.df,percentCI(subset(preference.df,granularity=="year")$representation,'Year','linear'))
preference_CI.df <- rbind(preference_CI.df,percentCI(subset(preference.df,granularity=="year")$representation,'Year','radial'))
preference_CI.df$facet <- 'Overall'