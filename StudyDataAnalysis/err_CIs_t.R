##
## start
##

err_start.df <- err_r_CI(subset(rbind(
  read_value_test.df,
  locate_minmax_test.df,
  compare_within_test.df
),target=="start"),'RV + LM/M + CV')

#by task
err_start.df <- rbind(err_start.df,err_r_CI(subset(read_value_test.df,target=="start"),'Read Value'))
err_start.df <- rbind(err_start.df,err_r_CI(subset(locate_minmax_test.df,target=="start"),'Locate Min / Max'))
err_start.df <- rbind(err_start.df,err_r_CI(subset(compare_within_test.df,target=="start"),'Compare Values'))

err_start.df$facet <- 'Start of Range'

#effect size computation

# start
err_diff_start.df <- err_r_CI_diff(subset(rbind(
  read_value_test.df,
  locate_minmax_test.df,
  compare_within_test.df
),target=="start"),'RV + LM/M + CV')

#by task
err_diff_start.df <- rbind(err_diff_start.df,err_r_CI_diff(subset(read_value_test.df,target=="start"),'Read Value'))
err_diff_start.df <- rbind(err_diff_start.df,err_r_CI_diff(subset(locate_minmax_test.df,target=="start"),'Locate Min / Max'))
err_diff_start.df <- rbind(err_diff_start.df,err_r_CI_diff(subset(compare_within_test.df,target=="start"),'Compare Values'))

err_diff_start.df$facet <- 'Start of Range'

# start
err_rate_start.df <- err_rate_r_CI(subset(rbind(
  read_value_test.df,
  locate_minmax_test.df,
  compare_within_test.df
),target=="start"),'RV + LM/M + CV',26)

#by task

err_rate_start.df <- rbind(err_rate_start.df,err_rate_r_CI(subset(read_value_test.df,target=="start"),'Read Value',8))
err_rate_start.df <- rbind(err_rate_start.df,err_rate_r_CI(subset(locate_minmax_test.df,target=="start"),'Locate Min / Max',10))
err_rate_start.df <- rbind(err_rate_start.df,err_rate_r_CI(subset(compare_within_test.df,target=="start"),'Compare Values',8))

err_rate_start.df$facet <- 'Start of Range'

#effect size computation

# diff start
err_rate_diff_start.df <- err_rate_r_CI_diff(subset(rbind(
  read_value_test.df,
  locate_minmax_test.df,
  compare_within_test.df
),target=="start"),'RV + LM/M + CV',26)

#diff by task
err_rate_diff_start.df <- rbind(err_rate_diff_start.df,err_rate_r_CI_diff(subset(read_value_test.df,target=="start"),'Read Value',8))
err_rate_diff_start.df <- rbind(err_rate_diff_start.df,err_rate_r_CI_diff(subset(locate_minmax_test.df,target=="start"),'Locate Min / Max',10))
err_rate_diff_start.df <- rbind(err_rate_diff_start.df,err_rate_r_CI_diff(subset(compare_within_test.df,target=="start"),'Compare Values',8))

err_rate_diff_start.df$facet <- 'Start of Range'

##
## end
##

err_end.df <- err_r_CI(subset(rbind(
  read_value_test.df,
  locate_minmax_test.df,
  compare_within_test.df
),target=="end"),'RV + LM/M + CV')

#by task
err_end.df <- rbind(err_end.df,err_r_CI(subset(read_value_test.df,target=="end"),'Read Value'))
err_end.df <- rbind(err_end.df,err_r_CI(subset(locate_minmax_test.df,target=="end"),'Locate Min / Max'))
err_end.df <- rbind(err_end.df,err_r_CI(subset(compare_within_test.df,target=="end"),'Compare Values'))

err_end.df$facet <- 'End of Range'

#effect size computation

# end
err_diff_end.df <- err_r_CI_diff(subset(rbind(
  read_value_test.df,
  locate_minmax_test.df,
  compare_within_test.df
),target=="end"),'RV + LM/M + CV')

#by task
err_diff_end.df <- rbind(err_diff_end.df,err_r_CI_diff(subset(read_value_test.df,target=="end"),'Read Value'))
err_diff_end.df <- rbind(err_diff_end.df,err_r_CI_diff(subset(locate_minmax_test.df,target=="end"),'Locate Min / Max'))
err_diff_end.df <- rbind(err_diff_end.df,err_r_CI_diff(subset(compare_within_test.df,target=="end"),'Compare Values'))

err_diff_end.df$facet <- 'End of Range'

# end
err_rate_end.df <- err_rate_r_CI(subset(rbind(
  read_value_test.df,
  locate_minmax_test.df,
  compare_within_test.df
),target=="end"),'RV + LM/M + CV',26)

#by task
err_rate_end.df <- rbind(err_rate_end.df,err_rate_r_CI(subset(read_value_test.df,target=="end"),'Read Value',8))
err_rate_end.df <- rbind(err_rate_end.df,err_rate_r_CI(subset(locate_minmax_test.df,target=="end"),'Locate Min / Max',10))
err_rate_end.df <- rbind(err_rate_end.df,err_rate_r_CI(subset(compare_within_test.df,target=="end"),'Compare Values',8))

err_rate_end.df$facet <- 'End of Range'

#effect size computation

# diff end
err_rate_diff_end.df <- err_rate_r_CI_diff(subset(rbind(
  read_value_test.df,
  locate_minmax_test.df,
  compare_within_test.df
),target=="end"),'RV + LM/M + CV',26)

#diff by task
err_rate_diff_end.df <- rbind(err_rate_diff_end.df,err_rate_r_CI_diff(subset(read_value_test.df,target=="end"),'Read Value',8))
err_rate_diff_end.df <- rbind(err_rate_diff_end.df,err_rate_r_CI_diff(subset(locate_minmax_test.df,target=="end"),'Locate Min / Max',10))
err_rate_diff_end.df <- rbind(err_rate_diff_end.df,err_rate_r_CI_diff(subset(compare_within_test.df,target=="end"),'Compare Values',8))

err_rate_diff_end.df$facet <- 'End of Range'

##
## range
##

#by task
err_range.df <- err_r_CI(subset(locate_minmax_test.df,target=="range"),'Locate Min / Max')

err_range.df$facet <- 'Length of Range'

#effect size computation


#by task
err_diff_range.df <- err_r_CI_diff(subset(locate_minmax_test.df,target=="range"),'Locate Min / Max')

err_diff_range.df$facet <- 'Length of Range'


#by task
err_rate_range.df <- err_rate_r_CI(subset(locate_minmax_test.df,target=="range"),'Locate Min / Max',8)

err_rate_range.df$facet <- 'Length of Range'

#effect size computation

#diff by task
err_rate_diff_range.df <- err_rate_r_CI_diff(subset(locate_minmax_test.df,target=="range"),'Locate Min / Max',8)

err_rate_diff_range.df$facet <- 'Length of Range'

# recombine granularities for plotting

err_t.df <- rbind(err_start.df,err_end.df,err_range.df)
remove(err_start.df,err_end.df,err_range.df)
err_t.df$facet <- ordered(err_t.df$facet, levels = c('Start of Range', 'End of Range', 'Length of Range'))

err_t_diff.df <- rbind(err_diff_start.df,err_diff_end.df,err_diff_range.df)
remove(err_diff_start.df,err_diff_end.df,err_diff_range.df)
err_t_diff.df$facet <- ordered(err_t_diff.df$facet, levels = c('Start of Range', 'End of Range', 'Length of Range'))

err_rate_t.df <- rbind(err_rate_start.df,err_rate_end.df,err_rate_range.df)
remove(err_rate_start.df,err_rate_end.df,err_rate_range.df)
err_rate_t.df$facet <- ordered(err_rate_t.df$facet, levels = c('Start of Range', 'End of Range', 'Length of Range'))

err_rate_t_diff.df <- rbind(err_rate_diff_start.df,err_rate_diff_end.df,err_rate_diff_range.df)
remove(err_rate_diff_start.df,err_rate_diff_end.df,err_rate_diff_range.df)
err_rate_t_diff.df$facet <- ordered(err_rate_t_diff.df$facet, levels = c('Start of Range', 'End of Range', 'Length of Range'))
