library(plyr)

#completion time

RT_r_min.df <- RT_r.df

RT_r_min.df$representation <- revalue(RT_r_min.df$representation, c("Radial" = "R","Linear" = "L"))
RT_r_min.df$task_name <- revalue(RT_r_min.df$task_name, c("All Tasks" = "Overall",
                                                          "Locate Date" = "T1-LD",
                                                          "Read Value" = "T2-RV",
                                                          "Locate Min / Max" = "T3-LM",
                                                          "Compare Values" = "T4-CV",
                                                          "Compare Ranges" = "T5-CR"
                                                          ))

plot_RT_r_min <- dualChart(RT_r_min.df,RT_r_min.df$representation,nbTechs = 2, ymin = 2, ymax = 9, "", "", 0)

ggsave(plot = plot_RT_r_min, filename = "plot_RT_r_min.pdf", device ="pdf", width = 7.5, height = 3.5, units = "in", dpi = 300)

#error rate

err_rate_r_min.df <- err_rate_r.df

err_rate_r_min.df$representation <- revalue(err_rate_r_min.df$representation, c("Radial" = "R","Linear" = "L"))
err_rate_r_min.df$task_name <- revalue(err_rate_r_min.df$task_name, c("All Tasks" = "Overall",
                                                          "Locate Date" = "T1-LD",
                                                          "Read Value" = "T2-RV",
                                                          "Locate Min / Max" = "T3-LM",
                                                          "Compare Values" = "T4-CV",
                                                          "Compare Ranges" = "T5-CR"
))

plot_err_rate_r_min <- dualChart(err_rate_r_min.df,err_rate_r_min.df$representation,nbTechs = 2, ymin = 0, ymax = 0.6, "", "", 0)

ggsave(plot = plot_err_rate_r_min, filename = "plot_err_rate_r_min.pdf", device ="pdf", width = 7.5, height = 3.5, units = "in", dpi = 300)

#error magnitude

err_r_min.df <- err_r.df

err_r_min.df$representation <- revalue(err_r_min.df$representation, c("Radial" = "R","Linear" = "L"))
err_r_min.df$task_name <- revalue(err_r_min.df$task_name, c("All Tasks" = "T1::T4",
                                                                      "Locate Date" = "T1-LD",
                                                                      "Read Value" = "T2-RV",
                                                                      "Locate Min / Max" = "T3-LM",
                                                                      "Compare Values" = "T4-CV"
))

plot_err_r_min <- dualChart(err_r_min.df,err_r_min.df$representation,nbTechs = 2, ymin = 0, ymax = 0.21, "", "Error Magnitude (% of data domain). Error Bars, 95% CIs", 0)

ggsave(plot = plot_err_r_min, filename = "plot_err_r_min.pdf", device ="pdf", width = 7.5, height = 3, units = "in", dpi = 300)

#compare between error

compare_between_err_r_min.df <- compare_between_err_r.df

compare_between_err_r_min.df$representation <- revalue(compare_between_err_r_min.df$representation, c("Radial" = "R","Linear" = "L"))
compare_between_err_r_min.df$task_name <- revalue(compare_between_err_r_min.df$task_name, c("Compare Ranges" = "T5-CR"))


plot_compare_between_err_r_min <- dualChart(compare_between_err_r_min.df,compare_between_err_r_min.df$representation,nbTechs = 2, ymin = 0, ymax = 0.6, "", "Error Magnitude (% of data domain). Error Bars, 95% CIs", 0)

ggsave(plot = plot_compare_between_err_r_min, filename = "plot_compare_between_err_r_min.pdf", device ="pdf", width = 7.5, height = 0.75, units = "in", dpi = 300)


#preference

preference_CI_min.df <- preference_CI.df

preference_CI_min.df$task_name <- revalue(preference_CI_min.df$task_name, c("Week" = "W",
                                                                            "Month" = "M",
                                                                            "Year" = "Y"
))
preference_CI_min.df$mean <- preference_CI_min.df$mean / 100
preference_CI_min.df$lowerBound_CI <- preference_CI_min.df$lowerBound_CI / 100
preference_CI_min.df$upperBound_CI <- preference_CI_min.df$upperBound_CI / 100

preference_CI_min.df$representation <- revalue(preference_CI_min.df$representation, c("radial" = "R","linear" = "L"))

plot_pref_r_min <- dualChart(preference_CI_min.df,preference_CI_min.df$representation,nbTechs = 2, ymin = 0, ymax = 100, "", "", 0)

ggsave(plot = plot_pref_r_min, filename = "plot_pref_r_min.pdf", device ="pdf", width = 3.75, height = 1.25, units = "in", dpi = 300)


#confidence

conf_r_min.df <- conf_r.df

conf_r_min.df$task_name <- revalue(conf_r_min.df$task_name, c("Overall" = "All",
                                                              "Week" = "W",
                                                              "Month" = "M",
                                                              "Year" = "Y"
))
conf_r_min.df$representation <- revalue(conf_r_min.df$representation, c("Radial" = "R","Linear" = "L"))

conf_r_min.df <- conf_r_min.df[conf_r_min.df$task_name != "All",]

plot_conf_r_min <- dualChart(conf_r_min.df,conf_r_min.df$representation,nbTechs = 2, ymin = 2.25, ymax = 4.75, "", "Self-Reported Confidence. Error Bars, 95% CIs", 0)

ggsave(plot = plot_conf_r_min, filename = "plot_conf_r_min.pdf", device ="pdf", width = 3.75, height = 1.25, units = "in", dpi = 300)

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

# RT_r_diff_min.df <- RT_r_diff_min.df[RT_r_diff_min.df$task_name != "T1-LD" & RT_r_diff_min.df$task_name != "T5-CR",]
RT_r_diff_min.df <- RT_r_diff_min.df[RT_r_diff_min.df$facet != "Week" & RT_r_diff_min.df$facet != "Month" & RT_r_diff_min.df$facet != "Year",]

plot_RT_r_diff_min <- dualChart(RT_r_diff_min.df,RT_r_diff_min.df$ratio,nbTechs = 1, ymin = 0.95, ymax = 1.45, "", "Trial Completion Time Ratios. Error Bars, 95% CIs", 1)

ggsave(plot = plot_RT_r_diff_min, filename = "plot_RT_r_diff_min.pdf", device ="pdf", width = 3.75, height = 2, units = "in", dpi = 300)


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

err_rate_r_diff_min.df <- err_rate_r_diff_min.df[err_rate_r_diff_min.df$facet != "Week" & err_rate_r_diff_min.df$facet != "Month" & err_rate_r_diff_min.df$facet != "Year",]

plot_err_rate_r_diff_min <- dualChart(err_rate_r_diff_min.df,err_rate_r_diff_min.df$ratio,nbTechs = 1, ymin = -0.1, ymax = 0.215, "", "", 0)

ggsave(plot = plot_err_rate_r_diff_min, filename = "plot_err_rate_r_diff_min.pdf", device ="pdf", width = 3.75, height = 2, units = "in", dpi = 300)

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
RT_r_shrink.df$facet <- ""

plot_RT_r_shrink <- dualChart(RT_r_shrink.df,RT_r_shrink.df$ratio,nbTechs = 1, ymin = 0.95, ymax = 1.45, "", "", 1)
ggsave(plot = plot_RT_r_shrink, filename = "plot_RT_r_shrink.pdf", device ="pdf", width = 3.75, height = 1, units = "in", dpi = 300)

# completion time g diff

RT_g_diff_min.df <- RT_g_diff.df

RT_g_diff_min.df <- RT_g_diff_min.df[RT_g_diff_min.df$task_name == "All Tasks" | RT_g_diff_min.df$task_name == "Locate Min / Max",]
RT_g_diff_min.df <- RT_g_diff_min.df[RT_g_diff_min.df$facet == "Both Representations",]
RT_g_diff_min.df$task_name <- revalue(RT_g_diff_min.df$task_name, c("All Tasks" = "Overall",
                                                                    "Locate Min / Max" = "T3-LM"
))
RT_g_diff_min.df$ratio <- revalue(RT_g_diff_min.df$ratio, c("Month - Week" = "M : W",
                                                            "Year - Month" = "Y : M",
                                                            "Year - Week" = "Y : W"
))

plot_RT_g_diff_min <- dualChart(RT_g_diff_min.df,RT_g_diff_min.df$ratio ,nbTechs = 3, ymin = 0.95, ymax = 2.5, "", "", 1)
ggsave(plot = plot_RT_g_diff_min, filename = "plot_RT_g_diff_min.pdf", device ="pdf", width = 3.75, height = 1.75, units = "in", dpi = 300)


# error rate g diff

err_rate_g_diff_min.df <- err_rate_g_diff.df

err_rate_g_diff_min.df <- err_rate_g_diff_min.df[err_rate_g_diff_min.df$task_name == "All Tasks" | err_rate_g_diff_min.df$task_name == "Locate Min / Max",]
err_rate_g_diff_min.df <- err_rate_g_diff_min.df[err_rate_g_diff_min.df$facet == "Both Representations",]
err_rate_g_diff_min.df$task_name <- revalue(err_rate_g_diff_min.df$task_name, c("All Tasks" = "Overall",
                                                                                "Locate Min / Max" = "T3-LM"
))
err_rate_g_diff_min.df$ratio <- revalue(err_rate_g_diff_min.df$ratio, c("Month - Week" = "M-W",
                                                                        "Year - Month" = "Y-M",
                                                                        "Year - Week" = "Y-W"
))

plot_err_rate_g_diff_min <- dualChart(err_rate_g_diff_min.df,err_rate_g_diff_min.df$ratio,nbTechs = 3, ymin = -0.25, ymax = 0.25, "", "Error Rate Pairwise Differences. Error Bars, 95% CIs", 0)

ggsave(plot = plot_err_rate_g_diff_min, filename = "plot_err_rate_g_diff_min.pdf", device ="pdf", width = 3.75, height = 1.75, units = "in", dpi = 300)


#error g diff

err_diff_g_min.df<- err_g_diff.df

err_diff_g_min.df <- err_diff_g_min.df[err_diff_g_min.df$task_name == "All Tasks",]
err_diff_g_min.df <- err_diff_g_min.df[err_diff_g_min.df$facet == "Both Representations",]
err_diff_g_min.df$task_name <- revalue(err_diff_g_min.df$task_name, c("All Tasks" = "Overall"
))
err_diff_g_min.df$ratio <- revalue(err_diff_g_min.df$ratio, c("Month - Week" = "M-W",
                                                                        "Year - Month" = "Y-M",
                                                                        "Year - Week" = "Y-W"
))

plot_err_diff_g_min <- dualChart(err_diff_g_min.df,err_diff_g_min.df$ratio,nbTechs = 3, ymin = -0.06, ymax = 0.06, "", "Error Rate Pairwise Differences. Error Bars, 95% CIs", 0)

ggsave(plot = plot_err_diff_g_min, filename = "plot_err_diff_g_min.pdf", device ="pdf", width = 3.75, height = 1, units = "in", dpi = 300)


#RT t diff

RT_t_diff_min.df <- RT_t_diff.df
RT_t_diff_min.df <- RT_t_diff_min.df[RT_t_diff_min.df$task_name != "RV + LM/M + CV",]
RT_t_diff_min.df$ratio <- revalue(RT_t_diff_min.df$ratio, c("Radial - Linear" = "R : L"))
RT_t_diff_min.df$task_name <- revalue(RT_t_diff_min.df$task_name, c("Read Value" = "T2-RV",
                                                                    "Locate Min / Max" = "T3-LM",
                                                                    "Compare Values" = "T4-CV"
))

plot_RT_t_diff_min <- dualChart(RT_t_diff_min.df,RT_t_diff_min.df$ratio ,nbTechs = 1, ymin = 0.925, ymax = 1.525, "", "Trial Completion Time Ratios. Error Bars, 95% CIs", 1)

ggsave(plot = plot_RT_t_diff_min, filename = "plot_RT_t_diff_min.pdf", device ="pdf", width = 3.75, height = 1.5, units = "in", dpi = 300)


#error rate t diff

err_rate_t_diff_min.df <- err_rate_t_diff.df
err_rate_t_diff_min.df <- err_rate_t_diff_min.df[err_rate_t_diff_min.df$task_name != "RV + LM/M + CV",]
err_rate_t_diff_min.df$ratio <- revalue(err_rate_t_diff_min.df$ratio, c("Radial - Linear" = "R-L"))
err_rate_t_diff_min.df$task_name <- revalue(err_rate_t_diff_min.df$task_name, c("Read Value" = "T2-RV",
                                                                    "Locate Min / Max" = "T3-LM",
                                                                    "Compare Values" = "T4-CV"
))

plot_err_rate_t_diff_min <- dualChart(err_rate_t_diff_min.df,err_rate_t_diff_min.df$ratio ,nbTechs = 1, ymin = -0.15, ymax = 0.15, "", "", 0)

ggsave(plot = plot_err_rate_t_diff_min, filename = "plot_err_rate_t_diff_min.pdf", device ="pdf", width = 3.75, height = 1.5, units = "in", dpi = 300)
