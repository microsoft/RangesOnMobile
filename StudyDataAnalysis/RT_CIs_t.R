
#target = start

# combined
RT_start.df <- RT_r_CI(subset(rbind(
  read_value_test.df,
  locate_minmax_test.df,
  compare_within_test.df
),target=="end"),'RV + LM/M + CV')

#by task
RT_start.df <- rbind(RT_start.df,RT_r_CI(subset(read_value_test.df,target=="start"),'Read Value'))
RT_start.df <- rbind(RT_start.df,RT_r_CI(subset(locate_minmax_test.df,target=="start"),'Locate Min / Max'))
RT_start.df <- rbind(RT_start.df,RT_r_CI(subset(compare_within_test.df,target=="start"),'Compare Values'))

RT_start.df$facet <- 'Start of Range'

# effect size computation

# combined
RT_diff_start.df <- RT_r_CI_diff(subset(rbind(
  read_value_test.df,
  locate_minmax_test.df,
  compare_within_test.df
),target=="end"),'RV + LM/M + CV')

#by task
RT_diff_start.df <- rbind(RT_diff_start.df,RT_r_CI_diff(subset(read_value_test.df,target=="start"),'Read Value'))
RT_diff_start.df <- rbind(RT_diff_start.df,RT_r_CI_diff(subset(locate_minmax_test.df,target=="start"),'Locate Min / Max'))
RT_diff_start.df <- rbind(RT_diff_start.df,RT_r_CI_diff(subset(compare_within_test.df,target=="start"),'Compare Values'))

RT_diff_start.df$facet <- 'Start of Range'

#target = end

# combined
RT_end.df <- RT_r_CI(subset(rbind(
  read_value_test.df,
  locate_minmax_test.df,
  compare_within_test.df
),target=="end"),'RV + LM/M + CV')

#by task
RT_end.df <- rbind(RT_end.df,RT_r_CI(subset(read_value_test.df,target=="end"),'Read Value'))
RT_end.df <- rbind(RT_end.df,RT_r_CI(subset(locate_minmax_test.df,target=="end"),'Locate Min / Max'))
RT_end.df <- rbind(RT_end.df,RT_r_CI(subset(compare_within_test.df,target=="end"),'Compare Values'))

RT_end.df$facet <- 'End of Range'

# effect size computation

# combined
RT_diff_end.df <- RT_r_CI_diff(subset(rbind(
  read_value_test.df,
  locate_minmax_test.df,
  compare_within_test.df
),target=="end"),'RV + LM/M + CV')

#by task
RT_diff_end.df <- rbind(RT_diff_end.df,RT_r_CI_diff(subset(read_value_test.df,target=="end"),'Read Value'))
RT_diff_end.df <- rbind(RT_diff_end.df,RT_r_CI_diff(subset(locate_minmax_test.df,target=="end"),'Locate Min / Max'))
RT_diff_end.df <- rbind(RT_diff_end.df,RT_r_CI_diff(subset(compare_within_test.df,target=="end"),'Compare Values'))

RT_diff_end.df$facet <- 'End of Range'

#target = range (locate min / max task only)
RT_range.df <- RT_r_CI(subset(locate_minmax_test.df,target=="range"),'Locate Min / Max')

RT_range.df$facet <- 'Length of Range'

# effect size computation

#by task
RT_diff_range.df <- RT_r_CI_diff(subset(locate_minmax_test.df,target=="end"),'Locate Min / Max')

RT_diff_range.df$facet <- 'Length of Range'

# recombine granularities for plotting

RT_t.df <- rbind(RT_start.df,RT_end.df,RT_range.df)
remove(RT_start.df,RT_end.df,RT_range.df)

RT_t.df$facet <- ordered(RT_t.df$facet, levels = c('Start of Range', 'End of Range', 'Length of Range'))

RT_t_diff.df <- rbind(RT_diff_start.df,RT_diff_end.df,RT_diff_range.df)
remove(RT_diff_start.df,RT_diff_end.df,RT_diff_range.df)

RT_t_diff.df$facet <- ordered(RT_t_diff.df$facet, levels = c('Start of Range', 'End of Range', 'Length of Range'))