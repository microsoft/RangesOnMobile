library(plyr)
library(ggplot2)

#completion time - temperature

RT_r_min_temp.df <- RT_r.df

RT_r_min_temp.df$representation <- revalue(RT_r_min_temp.df$representation, c("Radial" = "R","Linear" = "L"))
RT_r_min_temp.df$task_name <- revalue(RT_r_min_temp.df$task_name, c("All Tasks" = "Overall",
                                                          "Locate Date" = "T1-LD",
                                                          "Read Value" = "T2-RV",
                                                          "Locate Min / Max" = "T3-LM",
                                                          "Compare Values" = "T4-CV",
                                                          "Compare Ranges" = "T5-CR"
                                                          ))

RT_r_min_temp.df <- RT_r_min_temp.df[RT_r_min_temp.df$task_name != "Overall" & RT_r_min_temp.df$datatype == 'Temperature', ]
# RT_r_min_temp.df <- RT_r_min_temp.df[RT_r_min_temp.df$task_name != "Overall" & RT_r_min_temp.df$facet != "All Granularities", ]
# 
# RT_r_min_temp.df$representation <- with(RT_r_min_temp.df, interaction(representation,facet))
# RT_r_min_temp.df$representation <- revalue(RT_r_min_temp.df$representation, c("L.Week" = "L-W",
#                                                                     "R.Week" = "R-W",
#                                                                     "L.Month" = "L-M",
#                                                                     "R.Month" = "R-M",
#                                                                     "L.Year" = "L-Y",
#                                                                     "R.Year" = "R-Y"
#                                                                     ))
# RT_r_min_temp.df$facet <- RT_r_min_temp.df$datatype 
# RT_r_min_temp.df <- RT_r_min_temp.df[with(RT_r_min_temp.df, order(facet,task_name,representation)),]

plot_RT_r_min_temp <- dualChart(RT_r_min_temp.df,RT_r_min_temp.df$representation,nbTechs = 2, ymin = 0, ymax = 9, "", "", 0, displayXLabels = F, displayYLabels = T, percentScale = F, displayFacetLabel = T)

ggsave(plot = plot_RT_r_min_temp, filename = "plot_RT_r_min_temp.pdf", device="pdf", width = 7.5, height = 2, units = "in", dpi = 300)

#completion time - sleep

RT_r_min_sleep.df <- RT_r.df

RT_r_min_sleep.df$representation <- revalue(RT_r_min_sleep.df$representation, c("Radial" = "R","Linear" = "L"))
RT_r_min_sleep.df$task_name <- revalue(RT_r_min_sleep.df$task_name, c("All Tasks" = "Overall",
                                                                    "Locate Date" = "T1-LD",
                                                                    "Read Value" = "T2-RV",
                                                                    "Locate Min / Max" = "T3-LM",
                                                                    "Compare Values" = "T4-CV",
                                                                    "Compare Ranges" = "T5-CR"
))

RT_r_min_sleep.df <- RT_r_min_sleep.df[RT_r_min_sleep.df$task_name != "Overall" & RT_r_min_sleep.df$datatype == 'Sleep', ]

plot_RT_r_min_sleep <- dualChart(RT_r_min_sleep.df,RT_r_min_sleep.df$representation,nbTechs = 2, ymin = 0, ymax = 9, "", "", 0, displayXLabels = T, displayYLabels = T, percentScale = F, displayFacetLabel = F)

ggsave(plot = plot_RT_r_min_sleep, filename = "plot_RT_r_min_sleep.pdf", device="pdf", width = 7.5, height = 2, units = "in", dpi = 300)



#error rate - temp

err_rate_r_min_temp.df <- err_rate_r.df

err_rate_r_min_temp.df$representation <- revalue(err_rate_r_min_temp.df$representation, c("Radial" = "R","Linear" = "L"))
err_rate_r_min_temp.df$task_name <- revalue(err_rate_r_min_temp.df$task_name, c("All Tasks" = "Overall",
                                                          "Locate Date" = "T1-LD",
                                                          "Read Value" = "T2-RV",
                                                          "Locate Min / Max" = "T3-LM",
                                                          "Compare Values" = "T4-CV",
                                                          "Compare Ranges" = "T5-CR"
))
err_rate_r_min_temp.df <- err_rate_r_min_temp.df[err_rate_r_min_temp.df$task_name != "Overall"  & err_rate_r_min_temp.df$datatype == 'Temperature',]

plot_err_rate_r_min_temp <- dualChart(err_rate_r_min_temp.df,err_rate_r_min_temp.df$representation,nbTechs = 2, ymin = 0, ymax = 0.6, "", "", 0, displayXLabels = F, displayYLabels = T, percentScale = T, displayFacetLabel = T)

ggsave(plot = plot_err_rate_r_min_temp, filename = "plot_err_rate_r_min_temp.pdf", device ="pdf", width = 7.5, height = 2, units = "in", dpi = 300)

#error rate - sleep

err_rate_r_min_sleep.df <- err_rate_r.df

err_rate_r_min_sleep.df$representation <- revalue(err_rate_r_min_sleep.df$representation, c("Radial" = "R","Linear" = "L"))
err_rate_r_min_sleep.df$task_name <- revalue(err_rate_r_min_sleep.df$task_name, c("All Tasks" = "Overall",
                                                                                "Locate Date" = "T1-LD",
                                                                                "Read Value" = "T2-RV",
                                                                                "Locate Min / Max" = "T3-LM",
                                                                                "Compare Values" = "T4-CV",
                                                                                "Compare Ranges" = "T5-CR"
))
err_rate_r_min_sleep.df <- err_rate_r_min_sleep.df[err_rate_r_min_sleep.df$task_name != "Overall"  & err_rate_r_min_sleep.df$datatype == 'Sleep',]

plot_err_rate_r_min_sleep <- dualChart(err_rate_r_min_sleep.df,err_rate_r_min_sleep.df$representation,nbTechs = 2, ymin = 0, ymax = 0.6, "", "", 0, displayXLabels = T, displayYLabels = T, percentScale = T, displayFacetLabel = F)

ggsave(plot = plot_err_rate_r_min_sleep, filename = "plot_err_rate_r_min_sleep.pdf", device ="pdf", width = 7.5, height = 2, units = "in", dpi = 300)


#error magnitude

err_r_min.df <- err_r.df

err_r_min.df$representation <- revalue(err_r_min.df$representation, c("Radial" = "R","Linear" = "L"))
err_r_min.df$task_name <- revalue(err_r_min.df$task_name, c("All Tasks" = "T1::T4",
                                                                      "Locate Date" = "T1-LD",
                                                                      "Read Value" = "T2-RV",
                                                                      "Locate Min / Max" = "T3-LM",
                                                                      "Compare Values" = "T4-CV"
))
err_r_min.df <- err_r_min.df[err_r_min.df$task_name == "T4-CV",]


plot_err_r_min <- dualChart(err_r_min.df,err_r_min.df$representation,nbTechs = 2, ymin = 0, ymax = 0.04, "", "Error Magnitude (% of data domain). Error Bars, 95% CIs", 0, displayXLabels = T, displayYLabels = T, percentScale = T, displayFacetLabel = F)

ggsave(plot = plot_err_r_min, filename = "plot_err_r_min.pdf", device ="pdf", width = 7.5, height = 0.625, units = "in", dpi = 300)

#compare between error

compare_between_err_r_min.df <- compare_between_err_r.df

compare_between_err_r_min.df$representation <- revalue(compare_between_err_r_min.df$representation, c("Radial" = "R","Linear" = "L"))
compare_between_err_r_min.df$task_name <- revalue(compare_between_err_r_min.df$task_name, c("Compare Ranges" = "T5-CR"))


plot_compare_between_err_r_min <- dualChart(compare_between_err_r_min.df,compare_between_err_r_min.df$representation,nbTechs = 2, ymin = 0, ymax = 0.6, "", "Error Magnitude (% of data domain). Error Bars, 95% CIs", 0, displayXLabels = T, displayYLabels = T, percentScale = T, displayFacetLabel = F)

ggsave(plot = plot_compare_between_err_r_min, filename = "plot_compare_between_err_r_min.pdf", device ="pdf", width = 7.5, height = 0.625, units = "in", dpi = 300)


#preference

preference_CI_min.df <- preference_CI.df

preference_CI_min.df$task_name <- revalue(preference_CI_min.df$task_name, c("Week" = "W",
                                                                            "Month" = "M",
                                                                            "Year" = "Y"
))
preference_CI_min.df$task_name <- ordered(preference_CI_min.df$task_name, levels = c("Y", "M", "W"))
preference_CI_min.df$mean <- preference_CI_min.df$mean / 100
preference_CI_min.df$lowerBound_CI <- preference_CI_min.df$lowerBound_CI / 100
preference_CI_min.df$upperBound_CI <- preference_CI_min.df$upperBound_CI / 100

preference_CI_min.df$representation <- revalue(preference_CI_min.df$representation, c("radial" = "R","linear" = "L"))
preference_CI_min.df$facet <- preference_CI_min.df$datatype

plot_pref_r_min <- dualChart(preference_CI_min.df,preference_CI_min.df$representation,nbTechs = 2, ymin = 0, ymax = 1, "", "", 0, displayXLabels = T, displayYLabels = T, percentScale = T, displayFacetLabel = T)

ggsave(plot = plot_pref_r_min, filename = "plot_pref_r_min.pdf", device ="pdf", width = 3.75, height = 1.5, units = "in", dpi = 300)


#confidence

conf_r_min.df <- conf_r.df

conf_r_min.df$task_name <- revalue(conf_r_min.df$task_name, c("Overall" = "All",
                                                              "Week" = "W",
                                                              "Month" = "M",
                                                              "Year" = "Y"
))
conf_r_min.df$representation <- revalue(conf_r_min.df$representation, c("Radial" = "R","Linear" = "L"))
conf_r_min.df$facet <- conf_r_min.df$datatype


conf_r_min.df <- conf_r_min.df[conf_r_min.df$task_name != "All",]
conf_r_min.df$task_name <- ordered(conf_r_min.df$task_name, levels = c("Y", "M", "W"))

plot_conf_r_min <- dualChart(conf_r_min.df,conf_r_min.df$representation,nbTechs = 2, ymin = 1, ymax = 4.75, "", "Self-Reported Confidence. Error Bars, 95% CIs", 1, displayXLabels = T, displayYLabels = T, percentScale = F, displayFacetLabel = T)

ggsave(plot = plot_conf_r_min, filename = "plot_conf_r_min.pdf", device ="pdf", width = 3.75, height = 1.5, units = "in", dpi = 300)

# completion time diff

RT_r_diff_min.df <- RT_r_diff.df

RT_r_diff_min.df$ratio <- revalue(RT_r_diff_min.df$ratio, c("Radial - Linear" = "R : L"))
RT_r_diff_min.df$task_name <- revalue(RT_r_diff_min.df$task_name, c("All Tasks" = "Overall",
                                                          "Locate Date" = "T1-LD",
                                                          "Read Value" = "T2-RV",
                                                          "Locate Min / Max" = "T3-LM",
                                                          "Compare Values" = "T4-CV",
                                                          "Compare Ranges" = "T5-CR"
))
RT_r_diff_min.df <- RT_r_diff_min.df[RT_r_diff_min.df$task_name != "Overall",]
RT_r_diff_min.df <- RT_r_diff_min.df[RT_r_diff_min.df$facet != "Week" & RT_r_diff_min.df$facet != "Month" & RT_r_diff_min.df$facet != "Year",]
RT_r_diff_min.df$facet <- RT_r_diff_min.df$datatype

# RT_r_diff_min.df <- RT_r_diff_min.df[RT_r_diff_min.df$task_name != "T1-LD" & RT_r_diff_min.df$task_name != "T5-CR",]

plot_RT_r_diff_min <- dualChart(RT_r_diff_min.df,RT_r_diff_min.df$ratio,nbTechs = 1, ymin = 0.975, ymax = 1.45, "", "Trial Completion Time Ratios. Error Bars, 95% CIs", 1, displayXLabels = T, displayYLabels = F, percentScale = F, displayFacetLabel = T)

ggsave(plot = plot_RT_r_diff_min, filename = "plot_RT_r_diff_min.pdf", device ="pdf", width = 3.75, height = 1.75, units = "in", dpi = 300)


# error rate diff

err_rate_r_diff_min.df <- err_rate_r_diff.df

err_rate_r_diff_min.df$ratio <- revalue(err_rate_r_diff_min.df$ratio, c("Radial - Linear" = "R-L"))
err_rate_r_diff_min.df$task_name <- revalue(err_rate_r_diff_min.df$task_name, c("All Tasks" = "Overall",
                                                                    "Locate Date" = "T1-LD",
                                                                    "Read Value" = "T2-RV",
                                                                    "Locate Min / Max" = "T3-LM",
                                                                    "Compare Values" = "T4-CV",
                                                                    "Compare Ranges" = "T5-CR"
))

err_rate_r_diff_min.df <- err_rate_r_diff_min.df[err_rate_r_diff_min.df$task_name != "Overall",]

err_rate_r_diff_min.df <- err_rate_r_diff_min.df[err_rate_r_diff_min.df$facet != "Week" & err_rate_r_diff_min.df$facet != "Month" & err_rate_r_diff_min.df$facet != "Year",]
err_rate_r_diff_min.df$facet <- err_rate_r_diff_min.df$datatype


plot_err_rate_r_diff_min <- dualChart(err_rate_r_diff_min.df,err_rate_r_diff_min.df$ratio,nbTechs = 1, ymin = -0.1, ymax = 0.215, "", "", 0, displayXLabels = T, displayYLabels = F, percentScale = T, displayFacetLabel = T)

ggsave(plot = plot_err_rate_r_diff_min, filename = "plot_err_rate_r_diff_min.pdf", device ="pdf", width = 3.75, height = 1.75, units = "in", dpi = 300)

# completion time shrink

RT_r_shrink.df <- RT_r_diff.df

RT_r_shrink.df <- RT_r_shrink.df[RT_r_shrink.df$task_name == "All Tasks",]
RT_r_shrink.df <- RT_r_shrink.df[RT_r_shrink.df$facet != "All Granularities",]
RT_r_shrink.df$task_name <- RT_r_shrink.df$facet
RT_r_shrink.df$ratio <- revalue(RT_r_shrink.df$ratio, c("Radial - Linear" = "R : L"))
RT_r_shrink.df$task_name <- revalue(RT_r_shrink.df$task_name, c("Week" = "W",
                                                                "Month" = "M",
                                                                "Year" = "Y"
))
RT_r_shrink.df$task_name <- ordered(RT_r_shrink.df$task_name, levels = c("Y", "M", "W"))
RT_r_shrink.df$facet <- RT_r_shrink.df$datatype

plot_RT_r_shrink <- dualChart(RT_r_shrink.df,RT_r_shrink.df$ratio,nbTechs = 1, ymin = 1, ymax = 1.45, "", "", 1, displayXLabels = T, displayYLabels = F, percentScale = F, displayFacetLabel = T)
ggsave(plot = plot_RT_r_shrink, filename = "plot_RT_r_shrink.pdf", device ="pdf", width = 3.75, height = 1.25, units = "in", dpi = 300)

# completion time g diff

# T1-LD

RT_g_diff_min_T1.df <- RT_g_diff.df

RT_g_diff_min_T1.df <- RT_g_diff_min_T1.df[RT_g_diff_min_T1.df$task_name == "Locate Date",]
RT_g_diff_min_T1.df <- RT_g_diff_min_T1.df[RT_g_diff_min_T1.df$facet == "Both Representations",]
RT_g_diff_min_T1.df$task_name <- revalue(RT_g_diff_min_T1.df$task_name, c("Locate Date" = "T1-LD"                                                                    ,
                                                                    "Read Value" = "T2-RV",
                                                                    "Locate Min / Max" = "T3-LM",
                                                                    "Compare Values" = "T4-CV",
                                                                    "Compare Ranges" = "T5-CR"
))
RT_g_diff_min_T1.df$ratio <- revalue(RT_g_diff_min_T1.df$ratio, c("Month - Week" = "M / W",
                                                            "Year - Month" = "Y / M",
                                                            "Year - Week" = "Y / W"
))

# RT_g_diff_min_T1.df$ratio <- ordered(RT_g_diff_min_T1.df$ratio, levels = c("Y / M", "Y / W", "M / W"))
RT_g_diff_min_T1.df$ratio <- factor(RT_g_diff_min_T1.df$ratio, levels = c("Y / M", "Y / W", "M / W"))
RT_g_diff_min_T1.df$facet <- RT_g_diff_min_T1.df$datatype


plot_RT_g_diff_min_T1 <- dualChart(RT_g_diff_min_T1.df,RT_g_diff_min_T1.df$ratio ,nbTechs = 3, ymin = 0.90, ymax = 2.5, "", "", 1, displayXLabels = F, displayYLabels = T, percentScale = F, displayFacetLabel = T)
ggsave(plot = plot_RT_g_diff_min_T1, filename = "plot_RT_g_diff_min_T1.pdf", device ="pdf", width = 3.75, height = 0.875, units = "in", dpi = 300)


# T2-RV

RT_g_diff_min_T2.df <- RT_g_diff.df

RT_g_diff_min_T2.df <- RT_g_diff_min_T2.df[RT_g_diff_min_T2.df$task_name == "Read Value",]
RT_g_diff_min_T2.df <- RT_g_diff_min_T2.df[RT_g_diff_min_T2.df$ratio == "Month - Week",]
RT_g_diff_min_T2.df <- RT_g_diff_min_T2.df[RT_g_diff_min_T2.df$facet == "Both Representations",]
RT_g_diff_min_T2.df$task_name <- revalue(RT_g_diff_min_T2.df$task_name, c("Locate Date" = "T1-LD"                                                                    ,
                                                                          "Read Value" = "T2-RV",
                                                                          "Locate Min / Max" = "T3-LM",
                                                                          "Compare Values" = "T4-CV",
                                                                          "Compare Ranges" = "T5-CR"
))
RT_g_diff_min_T2.df$ratio <- revalue(RT_g_diff_min_T2.df$ratio, c("Month - Week" = "M / W",
                                                                  "Year - Month" = "Y / M",
                                                                  "Year - Week" = "Y / W"
))

RT_g_diff_min_T2.df$ratio <- ordered(RT_g_diff_min_T2.df$ratio, levels = c("Y / M", "Y / W", "M / W"))
RT_g_diff_min_T2.df$facet <- RT_g_diff_min_T2.df$datatype


plot_RT_g_diff_min_T2 <- dualChart(RT_g_diff_min_T2.df,RT_g_diff_min_T2.df$ratio ,nbTechs = 1, ymin = 0.90, ymax = 2.5, "", "", 1, displayXLabels = F, displayYLabels = T, percentScale = F, displayFacetLabel = F)
ggsave(plot = plot_RT_g_diff_min_T2, filename = "plot_RT_g_diff_min_T2.pdf", device ="pdf", width = 3.75, height = 0.375, units = "in", dpi = 300)


# T3-LM

RT_g_diff_min_T3.df <- RT_g_diff.df

RT_g_diff_min_T3.df <- RT_g_diff_min_T3.df[RT_g_diff_min_T3.df$task_name == "Locate Min / Max",]
RT_g_diff_min_T3.df <- RT_g_diff_min_T3.df[RT_g_diff_min_T3.df$facet == "Both Representations",]
RT_g_diff_min_T3.df$task_name <- revalue(RT_g_diff_min_T3.df$task_name, c("Locate Date" = "T1-LD"                                                                    ,
                                                                          "Read Value" = "T2-RV",
                                                                          "Locate Min / Max" = "T3-LM",
                                                                          "Compare Values" = "T4-CV",
                                                                          "Compare Ranges" = "T5-CR"
))
RT_g_diff_min_T3.df$ratio <- revalue(RT_g_diff_min_T3.df$ratio, c("Month - Week" = "M / W",
                                                                  "Year - Month" = "Y / M",
                                                                  "Year - Week" = "Y / W"
))

RT_g_diff_min_T3.df$ratio <- ordered(RT_g_diff_min_T3.df$ratio, levels = c("Y / M", "Y / W", "M / W"))
RT_g_diff_min_T3.df$facet <- RT_g_diff_min_T3.df$datatype


plot_RT_g_diff_min_T3 <- dualChart(RT_g_diff_min_T3.df,RT_g_diff_min_T3.df$ratio ,nbTechs = 3, ymin = 0.90, ymax = 2.5, "", "", 1, displayXLabels = F, displayYLabels = T, percentScale = F, displayFacetLabel = F)
ggsave(plot = plot_RT_g_diff_min_T3, filename = "plot_RT_g_diff_min_T3.pdf", device ="pdf", width = 3.75, height = 0.625, units = "in", dpi = 300)

# T4-CV

RT_g_diff_min_T4.df <- RT_g_diff.df

RT_g_diff_min_T4.df <- RT_g_diff_min_T4.df[RT_g_diff_min_T4.df$task_name == "Compare Values",]
RT_g_diff_min_T4.df <- RT_g_diff_min_T4.df[RT_g_diff_min_T4.df$ratio == "Month - Week",]
RT_g_diff_min_T4.df <- RT_g_diff_min_T4.df[RT_g_diff_min_T4.df$facet == "Both Representations",]
RT_g_diff_min_T4.df$task_name <- revalue(RT_g_diff_min_T4.df$task_name, c("Locate Date" = "T1-LD"                                                                    ,
                                                                          "Read Value" = "T2-RV",
                                                                          "Locate Min / Max" = "T3-LM",
                                                                          "Compare Values" = "T4-CV",
                                                                          "Compare Ranges" = "T5-CR"
))
RT_g_diff_min_T4.df$ratio <- revalue(RT_g_diff_min_T4.df$ratio, c("Month - Week" = "M / W",
                                                                  "Year - Month" = "Y / M",
                                                                  "Year - Week" = "Y / W"
))

RT_g_diff_min_T4.df$ratio <- ordered(RT_g_diff_min_T4.df$ratio, levels = c("Y / M", "Y / W", "M / W"))
RT_g_diff_min_T4.df$facet <- RT_g_diff_min_T4.df$datatype


plot_RT_g_diff_min_T4 <- dualChart(RT_g_diff_min_T4.df,RT_g_diff_min_T4.df$ratio ,nbTechs = 1, ymin = 0.90, ymax = 2.5, "", "", 1, displayXLabels = F, displayYLabels = T, percentScale = F, displayFacetLabel = F)
ggsave(plot = plot_RT_g_diff_min_T4, filename = "plot_RT_g_diff_min_T4.pdf", device ="pdf", width = 3.75, height = 0.375, units = "in", dpi = 300)

# T5-LM

RT_g_diff_min_T5.df <- RT_g_diff.df

RT_g_diff_min_T5.df <- RT_g_diff_min_T5.df[RT_g_diff_min_T5.df$task_name == "Compare Ranges",]
RT_g_diff_min_T5.df <- RT_g_diff_min_T5.df[RT_g_diff_min_T5.df$facet == "Both Representations",]
RT_g_diff_min_T5.df$task_name <- revalue(RT_g_diff_min_T5.df$task_name, c("Locate Date" = "T1-LD"                                                                    ,
                                                                          "Read Value" = "T2-RV",
                                                                          "Locate Min / Max" = "T3-LM",
                                                                          "Compare Values" = "T4-CV",
                                                                          "Compare Ranges" = "T5-CR"
))
RT_g_diff_min_T5.df$ratio <- revalue(RT_g_diff_min_T5.df$ratio, c("Month - Week" = "M / W",
                                                                  "Year - Month" = "Y / M",
                                                                  "Year - Week" = "Y / W"
))

RT_g_diff_min_T5.df$ratio <- ordered(RT_g_diff_min_T5.df$ratio, levels = c("Y / M", "Y / W", "M / W"))
RT_g_diff_min_T5.df$facet <- RT_g_diff_min_T5.df$datatype


plot_RT_g_diff_min_T5 <- dualChart(RT_g_diff_min_T5.df,RT_g_diff_min_T5.df$ratio ,nbTechs = 3, ymin = 0.90, ymax = 2.5, "", "", 1, displayXLabels = T, displayYLabels = T, percentScale = F, displayFacetLabel = F)
ggsave(plot = plot_RT_g_diff_min_T5, filename = "plot_RT_g_diff_min_T5.pdf", device ="pdf", width = 3.75, height = 0.75, units = "in", dpi = 300)


# error rate g diff

# T1-LD

err_rate_g_diff_min_T1.df <- err_rate_g_diff.df

err_rate_g_diff_min_T1.df <- err_rate_g_diff_min_T1.df[err_rate_g_diff_min_T1.df$task_name == "Locate Date",]
err_rate_g_diff_min_T1.df <- err_rate_g_diff_min_T1.df[err_rate_g_diff_min_T1.df$facet == "Both Representations",]
err_rate_g_diff_min_T1.df$task_name <- revalue(err_rate_g_diff_min_T1.df$task_name, c("Locate Date" = "T1-LD"                                                                    ,
                                                                                "Read Value" = "T2-RV",
                                                                                "Locate Min / Max" = "T3-LM",
                                                                                "Compare Values" = "T4-CV",
                                                                                "Compare Ranges" = "T5-CR"
))
err_rate_g_diff_min_T1.df$ratio <- revalue(err_rate_g_diff_min_T1.df$ratio, c("Month - Week" = "M - W",
                                                                        "Year - Month" = "Y - M",
                                                                        "Year - Week" = "Y - W"
))

err_rate_g_diff_min_T1.df$ratio <- ordered(err_rate_g_diff_min_T1.df$ratio, levels = c("Y - M", "Y - W", "M - W"))
err_rate_g_diff_min_T1.df$facet <- err_rate_g_diff_min_T1.df$datatype


plot_err_rate_g_diff_min_T1 <- dualChart(err_rate_g_diff_min_T1.df,err_rate_g_diff_min_T1.df$ratio,nbTechs = 3, ymin = -0.175, ymax = 0.3, "", "Error Rate Pairwise Differences. Error Bars, 95% CIs", 0, displayXLabels = F, displayYLabels = T, percentScale = T, displayFacetLabel = T)

ggsave(plot = plot_err_rate_g_diff_min_T1, filename = "plot_err_rate_g_diff_min_T1.pdf", device ="pdf", width = 3.75, height = 0.875, units = "in", dpi = 300)


# T2-RV

err_rate_g_diff_min_T2.df <- err_rate_g_diff.df

err_rate_g_diff_min_T2.df <- err_rate_g_diff_min_T2.df[err_rate_g_diff_min_T2.df$task_name == "Read Value",]
err_rate_g_diff_min_T2.df <- err_rate_g_diff_min_T2.df[err_rate_g_diff_min_T2.df$facet == "Both Representations",]
err_rate_g_diff_min_T2.df$task_name <- revalue(err_rate_g_diff_min_T2.df$task_name, c("Locate Date" = "T1-LD"                                                                    ,
                                                                                      "Read Value" = "T2-RV",
                                                                                      "Locate Min / Max" = "T3-LM",
                                                                                      "Compare Values" = "T4-CV",
                                                                                      "Compare Ranges" = "T5-CR"
))
err_rate_g_diff_min_T2.df$ratio <- revalue(err_rate_g_diff_min_T2.df$ratio, c("Month - Week" = "M - W",
                                                                              "Year - Month" = "Y - M",
                                                                              "Year - Week" = "Y - W"
))

err_rate_g_diff_min_T2.df$ratio <- ordered(err_rate_g_diff_min_T2.df$ratio, levels = c("Y - M", "Y - W", "M - W"))
err_rate_g_diff_min_T2.df$facet <- err_rate_g_diff_min_T2.df$datatype


plot_err_rate_g_diff_min_T2 <- dualChart(err_rate_g_diff_min_T2.df,err_rate_g_diff_min_T2.df$ratio,nbTechs = 1, ymin = -0.175, ymax = 0.3, "", "Error Rate Pairwise Differences. Error Bars, 95% CIs", 0, displayXLabels = F, displayYLabels = T, percentScale = T, displayFacetLabel = F)

ggsave(plot = plot_err_rate_g_diff_min_T2, filename = "plot_err_rate_g_diff_min_T2.pdf", device ="pdf", width = 3.75, height = 0.375, units = "in", dpi = 300)


# T3-LM

err_rate_g_diff_min_T3.df <- err_rate_g_diff.df

err_rate_g_diff_min_T3.df <- err_rate_g_diff_min_T3.df[err_rate_g_diff_min_T3.df$task_name == "Locate Min / Max",]
err_rate_g_diff_min_T3.df <- err_rate_g_diff_min_T3.df[err_rate_g_diff_min_T3.df$facet == "Both Representations",]
err_rate_g_diff_min_T3.df$task_name <- revalue(err_rate_g_diff_min_T3.df$task_name, c("Locate Date" = "T1-LD"                                                                    ,
                                                                                      "Read Value" = "T2-RV",
                                                                                      "Locate Min / Max" = "T3-LM",
                                                                                      "Compare Values" = "T4-CV",
                                                                                      "Compare Ranges" = "T5-CR"
))
err_rate_g_diff_min_T3.df$ratio <- revalue(err_rate_g_diff_min_T3.df$ratio, c("Month - Week" = "M - W",
                                                                              "Year - Month" = "Y - M",
                                                                              "Year - Week" = "Y - W"
))

err_rate_g_diff_min_T3.df$ratio <- ordered(err_rate_g_diff_min_T3.df$ratio, levels = c("Y - M", "Y - W", "M - W"))
err_rate_g_diff_min_T3.df$facet <- err_rate_g_diff_min_T3.df$datatype


plot_err_rate_g_diff_min_T3 <- dualChart(err_rate_g_diff_min_T3.df,err_rate_g_diff_min_T3.df$ratio,nbTechs = 3, ymin = -0.175, ymax = 0.3, "", "Error Rate Pairwise Differences. Error Bars, 95% CIs", 0, displayXLabels = F, displayYLabels = T, percentScale = T, displayFacetLabel = F)

ggsave(plot = plot_err_rate_g_diff_min_T3, filename = "plot_err_rate_g_diff_min_T3.pdf", device ="pdf", width = 3.75, height = 0.625, units = "in", dpi = 300)


# T4-RV

err_rate_g_diff_min_T4.df <- err_rate_g_diff.df

err_rate_g_diff_min_T4.df <- err_rate_g_diff_min_T4.df[err_rate_g_diff_min_T4.df$task_name == "Compare Values",]
err_rate_g_diff_min_T4.df <- err_rate_g_diff_min_T4.df[err_rate_g_diff_min_T4.df$facet == "Both Representations",]
err_rate_g_diff_min_T4.df$task_name <- revalue(err_rate_g_diff_min_T4.df$task_name, c("Locate Date" = "T1-LD"                                                                    ,
                                                                                      "Read Value" = "T2-RV",
                                                                                      "Locate Min / Max" = "T3-LM",
                                                                                      "Compare Values" = "T4-CV",
                                                                                      "Compare Ranges" = "T5-CR"
))
err_rate_g_diff_min_T4.df$ratio <- revalue(err_rate_g_diff_min_T4.df$ratio, c("Month - Week" = "M - W",
                                                                              "Year - Month" = "Y - M",
                                                                              "Year - Week" = "Y - W"
))

err_rate_g_diff_min_T4.df$ratio <- ordered(err_rate_g_diff_min_T4.df$ratio, levels = c("Y - M", "Y - W", "M - W"))
err_rate_g_diff_min_T4.df$facet <- err_rate_g_diff_min_T4.df$datatype


plot_err_rate_g_diff_min_T4 <- dualChart(err_rate_g_diff_min_T4.df,err_rate_g_diff_min_T4.df$ratio,nbTechs = 1, ymin = -0.175, ymax = 0.3, "", "Error Rate Pairwise Differences. Error Bars, 95% CIs", 0, displayXLabels = F, displayYLabels = T, percentScale = T, displayFacetLabel = F)

ggsave(plot = plot_err_rate_g_diff_min_T4, filename = "plot_err_rate_g_diff_min_T4.pdf", device ="pdf", width = 3.75, height = 0.375, units = "in", dpi = 300)

# T5-CR

err_rate_g_diff_min_T5.df <- err_rate_g_diff.df

err_rate_g_diff_min_T5.df <- err_rate_g_diff_min_T5.df[err_rate_g_diff_min_T5.df$task_name == "Compare Ranges",]
err_rate_g_diff_min_T5.df <- err_rate_g_diff_min_T5.df[err_rate_g_diff_min_T5.df$facet == "Both Representations",]
err_rate_g_diff_min_T5.df$task_name <- revalue(err_rate_g_diff_min_T5.df$task_name, c("Locate Date" = "T1-LD"                                                                    ,
                                                                                      "Read Value" = "T2-RV",
                                                                                      "Locate Min / Max" = "T3-LM",
                                                                                      "Compare Values" = "T4-CV",
                                                                                      "Compare Ranges" = "T5-CR"
))
err_rate_g_diff_min_T5.df$ratio <- revalue(err_rate_g_diff_min_T5.df$ratio, c("Month - Week" = "M - W",
                                                                              "Year - Month" = "Y - M",
                                                                              "Year - Week" = "Y - W"
))

err_rate_g_diff_min_T5.df$ratio <- ordered(err_rate_g_diff_min_T5.df$ratio, levels = c("Y - M", "Y - W", "M - W"))
err_rate_g_diff_min_T5.df$facet <- err_rate_g_diff_min_T5.df$datatype


plot_err_rate_g_diff_min_T5 <- dualChart(err_rate_g_diff_min_T5.df,err_rate_g_diff_min_T5.df$ratio,nbTechs = 3, ymin = -0.175, ymax = 0.3, "", "Error Rate Pairwise Differences. Error Bars, 95% CIs", 0, displayXLabels = T, displayYLabels = T, percentScale = T, displayFacetLabel = F)

ggsave(plot = plot_err_rate_g_diff_min_T5, filename = "plot_err_rate_g_diff_min_T5.pdf", device ="pdf", width = 3.75, height = 0.75, units = "in", dpi = 300)



#error g diff

#T4-CV

err_diff_g_min_T4.df<- err_g_diff.df

err_diff_g_min_T4.df <- err_diff_g_min_T4.df[err_diff_g_min_T4.df$task_name == "Compare Values",]
err_diff_g_min_T4.df <- err_diff_g_min_T4.df[err_diff_g_min_T4.df$facet == "Both Representations",]
err_diff_g_min_T4.df$task_name <- revalue(err_diff_g_min_T4.df$task_name, c("Locate Date" = "T1-LD"                                                                    ,
                                                                      "Read Value" = "T2-RV",
                                                                      "Locate Min / Max" = "T3-LM",
                                                                      "Compare Values" = "T4-CV",
                                                                      "Compare Ranges" = "T5-CR"
))
err_diff_g_min_T4.df$ratio <- revalue(err_diff_g_min_T4.df$ratio, c("Month - Week" = "M - W",
                                                                        "Year - Month" = "Y - M",
                                                                        "Year - Week" = "Y - W"
))

err_diff_g_min_T4.df$ratio <- ordered(err_diff_g_min_T4.df$ratio, levels = c("Y - M", "Y - W", "M - W"))


plot_err_diff_g_min_T4 <- dualChart(err_diff_g_min_T4.df,err_diff_g_min_T4.df$ratio,nbTechs = 1, ymin = -0.02, ymax = 0.02, "", "Error Rate Pairwise Differences. Error Bars, 95% CIs", 0, displayXLabels = T, displayYLabels = T, percentScale = T, displayFacetLabel = T)

ggsave(plot = plot_err_diff_g_min_T4, filename = "plot_err_diff_g_min_T4.pdf", device ="pdf", width = 3.75, height = 0.5, units = "in", dpi = 300)

#T5-CR

err_diff_g_min_T5.df<- compare_between_err_g_diff.df

err_diff_g_min_T5.df <- err_diff_g_min_T5.df[err_diff_g_min_T5.df$facet == "Both Representations",]
err_diff_g_min_T5.df$task_name <- revalue(err_diff_g_min_T5.df$task_name, c("Locate Date" = "T1-LD"                                                                    ,
                                                                            "Read Value" = "T2-RV",
                                                                            "Locate Min / Max" = "T3-LM",
                                                                            "Compare Values" = "T4-CV",
                                                                            "Compare Ranges" = "T5-CR"
))
err_diff_g_min_T5.df$ratio <- revalue(err_diff_g_min_T5.df$ratio, c("Month - Week" = "M - W",
                                                                    "Year - Month" = "Y - M",
                                                                    "Year - Week" = "Y - W"
))

err_diff_g_min_T5.df$ratio <- ordered(err_diff_g_min_T5.df$ratio, levels = c("Y - M", "Y - W", "M - W"))

plot_err_diff_g_min_T5 <- dualChart(err_diff_g_min_T5.df,err_diff_g_min_T5.df$ratio,nbTechs = 3, ymin = -0.045, ymax = 0.425, "", "Error Rate Pairwise Differences. Error Bars, 95% CIs", 0, displayXLabels = T, displayYLabels = T, percentScale = T, displayFacetLabel = T)

ggsave(plot = plot_err_diff_g_min_T5, filename = "plot_err_diff_g_min_T5.pdf", device ="pdf", width = 3.75, height = 0.75, units = "in", dpi = 300)

#RT t diff T2

RT_t_diff_min_T2.df <- RT_t_diff.df
RT_t_diff_min_T2.df <- RT_t_diff_min_T2.df[RT_t_diff_min_T2.df$task_name == "Read Value",]
RT_t_diff_min_T2.df$ratio <- revalue(RT_t_diff_min_T2.df$ratio, c("Radial - Linear" = "R / L"))
RT_t_diff_min_T2.df$task_name <- revalue(RT_t_diff_min_T2.df$task_name, c("Read Value" = "T2-RV",
                                                                          "Locate Min / Max" = "T3-LM",
                                                                          "Compare Values" = "T4-CV"
))

RT_t_diff_min_T2.df$ratio <- RT_t_diff_min_T2.df$facet 
RT_t_diff_min_T2.df$ratio <- revalue(RT_t_diff_min_T2.df$ratio, c("Start of Range" = "Start",
                                                                  "End of Range" = "End",
                                                                  "Length of Range" = "Length"
))

RT_t_diff_min_T2.df$facet <- RT_t_diff_min_T2.df$datatype
RT_t_diff_min_T2.df <- RT_t_diff_min_T2.df[with(RT_t_diff_min_T2.df, order(facet,task_name)),]


plot_RT_t_diff_min_T2 <- dualChart(RT_t_diff_min_T2.df,RT_t_diff_min_T2.df$ratio ,nbTechs = 2, ymin = 0.925, ymax = 1.525, "", "Trial Completion Time Ratios. Error Bars, 95% CIs", 1, displayXLabels = F, displayYLabels = T, percentScale = F, displayFacetLabel = T)

ggsave(plot = plot_RT_t_diff_min_T2, filename = "plot_RT_t_diff_min_T2.pdf", device ="pdf", width = 3.75, height = 0.75, units = "in", dpi = 300)

#RT t diff T3

RT_t_diff_min_T3.df <- RT_t_diff.df
RT_t_diff_min_T3.df <- RT_t_diff_min_T3.df[RT_t_diff_min_T3.df$task_name == "Locate Min / Max",]
RT_t_diff_min_T3.df$ratio <- revalue(RT_t_diff_min_T3.df$ratio, c("Radial - Linear" = "R / L"))
RT_t_diff_min_T3.df$task_name <- revalue(RT_t_diff_min_T3.df$task_name, c("Read Value" = "T3-RV",
                                                                    "Locate Min / Max" = "T3-LM",
                                                                    "Compare Values" = "T4-CV"
))

RT_t_diff_min_T3.df$ratio <- RT_t_diff_min_T3.df$facet 
RT_t_diff_min_T3.df$ratio <- revalue(RT_t_diff_min_T3.df$ratio, c("Start of Range" = "Start",
                                                            "End of Range" = "End",
                                                            "Length of Range" = "Length"
))

RT_t_diff_min_T3.df$facet <- RT_t_diff_min_T3.df$datatype
RT_t_diff_min_T3.df <- RT_t_diff_min_T3.df[with(RT_t_diff_min_T3.df, order(facet,task_name)),]


plot_RT_t_diff_min_T3 <- dualChart(RT_t_diff_min_T3.df,RT_t_diff_min_T3.df$ratio ,nbTechs = 3, ymin = 0.925, ymax = 1.525, "", "Trial Completion Time Ratios. Error Bars, 95% CIs", 1, displayXLabels = F, displayYLabels = T, percentScale = F, displayFacetLabel = F)

ggsave(plot = plot_RT_t_diff_min_T3, filename = "plot_RT_t_diff_min_T3.pdf", device ="pdf", width = 3.75, height = 0.75, units = "in", dpi = 300)

#RT t diff T4

RT_t_diff_min_T4.df <- RT_t_diff.df
RT_t_diff_min_T4.df <- RT_t_diff_min_T4.df[RT_t_diff_min_T4.df$task_name == "Compare Values",]
RT_t_diff_min_T4.df$ratio <- revalue(RT_t_diff_min_T4.df$ratio, c("Radial - Linear" = "R / L"))
RT_t_diff_min_T4.df$task_name <- revalue(RT_t_diff_min_T4.df$task_name, c("Read Value" = "T4-RV",
                                                                          "Locate Min / Max" = "T4-LM",
                                                                          "Compare Values" = "T4-CV"
))

RT_t_diff_min_T4.df$ratio <- RT_t_diff_min_T4.df$facet 
RT_t_diff_min_T4.df$ratio <- revalue(RT_t_diff_min_T4.df$ratio, c("Start of Range" = "Start",
                                                                  "End of Range" = "End",
                                                                  "Length of Range" = "Length"
))

RT_t_diff_min_T4.df$facet <- RT_t_diff_min_T4.df$datatype
RT_t_diff_min_T4.df <- RT_t_diff_min_T4.df[with(RT_t_diff_min_T4.df, order(facet,task_name)),]


plot_RT_t_diff_min_T4 <- dualChart(RT_t_diff_min_T4.df,RT_t_diff_min_T4.df$ratio ,nbTechs = 2, ymin = 0.925, ymax = 1.525, "", "Trial Completion Time Ratios. Error Bars, 95% CIs", 1, displayXLabels = T, displayYLabels = T, percentScale = F, displayFacetLabel = F)

ggsave(plot = plot_RT_t_diff_min_T4, filename = "plot_RT_t_diff_min_T4.pdf", device ="pdf", width = 3.75, height = 0.625, units = "in", dpi = 300)

#err_rate t diff T2

err_rate_t_diff_min_T2.df <- err_rate_t_diff.df
err_rate_t_diff_min_T2.df <- err_rate_t_diff_min_T2.df[err_rate_t_diff_min_T2.df$task_name == "Read Value",]
err_rate_t_diff_min_T2.df$ratio <- revalue(err_rate_t_diff_min_T2.df$ratio, c("Radial - Linear" = "R / L"))
err_rate_t_diff_min_T2.df$task_name <- revalue(err_rate_t_diff_min_T2.df$task_name, c("Read Value" = "T2-RV",
                                                                          "Locate Min / Max" = "T3-LM",
                                                                          "Compare Values" = "T4-CV"
))

err_rate_t_diff_min_T2.df$ratio <- err_rate_t_diff_min_T2.df$facet 
err_rate_t_diff_min_T2.df$ratio <- revalue(err_rate_t_diff_min_T2.df$ratio, c("Start of Range" = "Start",
                                                                  "End of Range" = "End",
                                                                  "Length of Range" = "Length"
))

err_rate_t_diff_min_T2.df$facet <- err_rate_t_diff_min_T2.df$datatype
err_rate_t_diff_min_T2.df <- err_rate_t_diff_min_T2.df[with(err_rate_t_diff_min_T2.df, order(facet,task_name)),]


plot_err_rate_t_diff_min_T2 <- dualChart(err_rate_t_diff_min_T2.df,err_rate_t_diff_min_T2.df$ratio ,nbTechs = 2, ymin = -0.15, ymax = 0.15, "", "Trial Completion Time Ratios. Error Bars, 95% CIs", 0, displayXLabels = F, displayYLabels = T, percentScale = T, displayFacetLabel = T)

ggsave(plot = plot_err_rate_t_diff_min_T2, filename = "plot_err_rate_t_diff_min_T2.pdf", device ="pdf", width = 3.75, height = 0.75, units = "in", dpi = 300)

#err_rate t diff T3

err_rate_t_diff_min_T3.df <- err_rate_t_diff.df
err_rate_t_diff_min_T3.df <- err_rate_t_diff_min_T3.df[err_rate_t_diff_min_T3.df$task_name == "Locate Min / Max",]
err_rate_t_diff_min_T3.df$ratio <- revalue(err_rate_t_diff_min_T3.df$ratio, c("Radial - Linear" = "R / L"))
err_rate_t_diff_min_T3.df$task_name <- revalue(err_rate_t_diff_min_T3.df$task_name, c("Read Value" = "T3-RV",
                                                                          "Locate Min / Max" = "T3-LM",
                                                                          "Compare Values" = "T4-CV"
))

err_rate_t_diff_min_T3.df$ratio <- err_rate_t_diff_min_T3.df$facet 
err_rate_t_diff_min_T3.df$ratio <- revalue(err_rate_t_diff_min_T3.df$ratio, c("Start of Range" = "Start",
                                                                  "End of Range" = "End",
                                                                  "Length of Range" = "Length"
))

err_rate_t_diff_min_T3.df$facet <- err_rate_t_diff_min_T3.df$datatype
err_rate_t_diff_min_T3.df <- err_rate_t_diff_min_T3.df[with(err_rate_t_diff_min_T3.df, order(facet,task_name)),]


plot_err_rate_t_diff_min_T3 <- dualChart(err_rate_t_diff_min_T3.df,err_rate_t_diff_min_T3.df$ratio ,nbTechs = 3, ymin = -0.15, ymax = 0.15, "", "Trial Completion Time Ratios. Error Bars, 95% CIs", 0, displayXLabels = F, displayYLabels = T, percentScale = T, displayFacetLabel = F)

ggsave(plot = plot_err_rate_t_diff_min_T3, filename = "plot_err_rate_t_diff_min_T3.pdf", device ="pdf", width = 3.75, height = 0.75, units = "in", dpi = 300)

#err_rate t diff T4

err_rate_t_diff_min_T4.df <- err_rate_t_diff.df
err_rate_t_diff_min_T4.df <- err_rate_t_diff_min_T4.df[err_rate_t_diff_min_T4.df$task_name == "Compare Values",]
err_rate_t_diff_min_T4.df$ratio <- revalue(err_rate_t_diff_min_T4.df$ratio, c("Radial - Linear" = "R / L"))
err_rate_t_diff_min_T4.df$task_name <- revalue(err_rate_t_diff_min_T4.df$task_name, c("Read Value" = "T4-RV",
                                                                          "Locate Min / Max" = "T4-LM",
                                                                          "Compare Values" = "T4-CV"
))

err_rate_t_diff_min_T4.df$ratio <- err_rate_t_diff_min_T4.df$facet 
err_rate_t_diff_min_T4.df$ratio <- revalue(err_rate_t_diff_min_T4.df$ratio, c("Start of Range" = "Start",
                                                                  "End of Range" = "End",
                                                                  "Length of Range" = "Length"
))

err_rate_t_diff_min_T4.df$facet <- err_rate_t_diff_min_T4.df$datatype
err_rate_t_diff_min_T4.df <- err_rate_t_diff_min_T4.df[with(err_rate_t_diff_min_T4.df, order(facet,task_name)),]


plot_err_rate_t_diff_min_T4 <- dualChart(err_rate_t_diff_min_T4.df,err_rate_t_diff_min_T4.df$ratio ,nbTechs = 2, ymin = -0.15, ymax = 0.15, "", "Trial Completion Time Ratios. Error Bars, 95% CIs", 0, displayXLabels = T, displayYLabels = T, percentScale = T, displayFacetLabel = F)

ggsave(plot = plot_err_rate_t_diff_min_T4, filename = "plot_err_rate_t_diff_min_T4.pdf", device ="pdf", width = 3.75, height = 0.625, units = "in", dpi = 300)
