library(plyr)

temperature_RT_r.df$datatype = "Temperature"
temperature_RT_r_diff.df$datatype = "Temperature"
temperature_RT_g.df$datatype = "Temperature"
temperature_RT_g_diff.df$datatype = "Temperature"
temperature_RT_t.df$datatype = "Temperature"
temperature_RT_t_diff.df$datatype = "Temperature"

temperature_err_rate_r.df$datatype = "Temperature"
temperature_err_rate_r_diff.df$datatype = "Temperature"
temperature_err_rate_g.df$datatype = "Temperature"
temperature_err_rate_g_diff.df$datatype = "Temperature"
temperature_err_rate_t.df$datatype = "Temperature"
temperature_err_rate_t_diff.df$datatype = "Temperature"

temperature_err_r.df$datatype = "Temperature"
temperature_err_r_diff.df$datatype = "Temperature"
temperature_err_g.df$datatype = "Temperature"
temperature_err_g_diff.df$datatype = "Temperature"
temperature_err_t.df$datatype = "Temperature"
temperature_err_t_diff.df$datatype = "Temperature"

temperature_compare_between_err_r.df$datatype = "Temperature"
temperature_compare_between_err_r_diff.df$datatype = "Temperature"
temperature_compare_between_err_g.df$datatype = "Temperature"
temperature_compare_between_err_g_diff.df$datatype = "Temperature"

temperature_preference_CI.df$datatype = "Temperature"
temperature_conf_r.df$datatype = "Temperature"
temperature_conf_r_diff.df$datatype = "Temperature"

sleep_RT_r.df$datatype = "Sleep"
sleep_RT_r_diff.df$datatype = "Sleep"
sleep_RT_g.df$datatype = "Sleep"
sleep_RT_g_diff.df$datatype = "Sleep"
sleep_RT_t.df$datatype = "Sleep"
sleep_RT_t_diff.df$datatype = "Sleep"

sleep_err_rate_r.df$datatype = "Sleep"
sleep_err_rate_r_diff.df$datatype = "Sleep"
sleep_err_rate_g.df$datatype = "Sleep"
sleep_err_rate_g_diff.df$datatype = "Sleep"
sleep_err_rate_t.df$datatype = "Sleep"
sleep_err_rate_t_diff.df$datatype = "Sleep"

sleep_err_r.df$datatype = "Sleep"
sleep_err_r_diff.df$datatype = "Sleep"
sleep_err_g.df$datatype = "Sleep"
sleep_err_g_diff.df$datatype = "Sleep"
sleep_err_t.df$datatype = "Sleep"
sleep_err_t_diff.df$datatype = "Sleep"

sleep_compare_between_err_r.df$datatype = "Sleep"
sleep_compare_between_err_r_diff.df$datatype = "Sleep"
sleep_compare_between_err_g.df$datatype = "Sleep"
sleep_compare_between_err_g_diff.df$datatype = "Sleep"

sleep_preference_CI.df$datatype = "Sleep"
sleep_conf_r.df$datatype = "Sleep"
sleep_conf_r_diff.df$datatype = "Sleep"

RT_r.df <- rbind(temperature_RT_r.df,sleep_RT_r.df)
RT_r_diff.df <- rbind(temperature_RT_r_diff.df,sleep_RT_r_diff.df) 
RT_g.df <- rbind(temperature_RT_g.df,sleep_RT_g.df) 
RT_g_diff.df <- rbind(temperature_RT_g_diff.df,sleep_RT_g_diff.df) 
RT_t.df <- rbind(temperature_RT_t.df,sleep_RT_t.df) 
RT_t_diff.df <- rbind(temperature_RT_t_diff.df,sleep_RT_t_diff.df) 

err_rate_r.df <- rbind(temperature_err_rate_r.df,sleep_err_rate_r.df) 
err_rate_r_diff.df <- rbind(temperature_err_rate_r_diff.df,sleep_err_rate_r_diff.df) 
err_rate_g.df <- rbind(temperature_err_rate_g.df,sleep_err_rate_g.df) 
err_rate_g_diff.df <- rbind(temperature_err_rate_g_diff.df,sleep_err_rate_g_diff.df) 
err_rate_t.df <- rbind(temperature_err_rate_t.df,sleep_err_rate_t.df) 
err_rate_t_diff.df <- rbind(temperature_err_rate_t_diff.df,sleep_err_rate_t_diff.df) 

err_r.df <- rbind(temperature_err_r.df,sleep_err_r.df) 
err_r_diff.df <- rbind(temperature_err_r_diff.df,sleep_err_r_diff.df) 
err_g.df <- rbind(temperature_err_g.df,sleep_err_g.df) 
err_g_diff.df <- rbind(temperature_err_g_diff.df,sleep_err_g_diff.df) 
err_t.df <- rbind(temperature_err_t.df,sleep_err_t.df) 
err_t_diff.df <- rbind(temperature_err_t_diff.df,sleep_err_t_diff.df) 

compare_between_err_r.df <- rbind(temperature_compare_between_err_r.df,sleep_compare_between_err_r.df) 
compare_between_err_r_diff.df <- rbind(temperature_compare_between_err_r_diff.df,sleep_compare_between_err_r_diff.df) 
compare_between_err_g.df <- rbind(temperature_compare_between_err_g.df,sleep_compare_between_err_g.df) 
compare_between_err_g_diff.df <- rbind(temperature_compare_between_err_g_diff.df,sleep_compare_between_err_g_diff.df) 

preference_CI.df <- rbind(temperature_preference_CI.df,sleep_preference_CI.df) 
conf_r.df <- rbind(temperature_conf_r.df,sleep_conf_r.df) 
conf_r_diff.df <- rbind(temperature_conf_r_diff.df,sleep_conf_r_diff.df) 

plot_RT_r <- dualChart(RT_r.df,RT_r.df$representation,nbTechs = 2, ymin = 2, ymax = 9, "", "Trial Completion Time in Seconds. Error Bars, 95% CIs", 0)
plot_RT_r_diff <- dualChart(RT_r_diff.df,RT_r_diff.df$ratio,nbTechs = 1, ymin = 0.85, ymax = 1.75, "", "Trial Completion Time Ratios. Error Bars, 95% CIs", 1)
plot_RT_g <- dualChart(RT_g.df,RT_g.df$granularity,nbTechs = 3, ymin = 2, ymax = 9, "", "Trial Completion Time in Seconds. Error Bars, 95% CIs", 0)
plot_RT_g_diff <- dualChart(RT_g_diff.df,RT_g_diff.df$ratio ,nbTechs = 3, ymin = 0.7, ymax = 2.7, "", "Trial Completion Time Ratios. Error Bars, 95% CIs", 1)
plot_RT_t <- dualChart(RT_t.df,RT_t.df$representation,nbTechs = 2, ymin = 2, ymax = 7.5, "", "Trial Completion Time in Seconds. Error Bars, 95% CIs", 0)
plot_RT_t_diff <- dualChart(RT_t_diff.df,RT_t_diff.df$ratio ,nbTechs = 1, ymin = 0.9, ymax = 1.6, "", "Trial Completion Time Ratios. Error Bars, 95% CIs", 1)

plot_err_rate_r <- dualChart(err_rate_r.df,err_rate_r.df$representation,nbTechs = 2, ymin = 0, ymax = 0.6, "", "Error Rate. Error Bars, 95% CIs", 0)
plot_err_rate_r_diff <- dualChart(err_rate_r_diff.df,err_rate_r_diff.df$ratio,nbTechs = 1, ymin = -0.19, ymax = 0.45, "", "Error Rate Pairwise Differences. Error Bars, 95% CIs", 0)
plot_err_rate_g <- dualChart(err_rate_g.df,err_rate_g.df$granularity,nbTechs = 3, ymin = 0, ymax = 0.6, "", "Error Rate. Error Bars, 95% CIs", 0)
plot_err_rate_g_diff <- dualChart(err_rate_g_diff.df,err_rate_g_diff.df$ratio,nbTechs = 3, ymin = -0.2, ymax = 0.4, "", "Error Rate Pairwise Differences. Error Bars, 95% CIs", 0)
plot_err_rate_t <- dualChart(err_rate_t.df,err_rate_t.df$representation,nbTechs = 2, ymin = 0, ymax = 0.25, "", "Error Rate. Error Bars, 95% CIs", 0)
plot_err_rate_t_diff <- dualChart(err_rate_t_diff.df,err_rate_t_diff.df$ratio,nbTechs = 1, ymin = -0.15, ymax = 0.15, "", "Error Rate Pairwise Differences. Error Bars, 95% CIs", 0)

plot_err_r <- dualChart(err_r.df,err_r.df$representation,nbTechs = 2, ymin = 0, ymax = 0.21, "", "Error Magnitude (% of data domain). Error Bars, 95% CIs", 0)
plot_err_r_diff <- dualChart(err_r_diff.df,err_r_diff.df$ratio,nbTechs = 1, ymin = -0.1, ymax = 0.06, "", "Error Magnitude Pairwise Differences. Error Bars, 95% CIs", 0)
plot_err_g <- dualChart(err_g.df,err_g.df$granularity,nbTechs = 3, ymin = 0, ymax = 0.21, "", "Error Magnitude (% of data domain). Error Bars, 95% CIs", 0)
plot_err_g_diff <- dualChart(err_g_diff.df,err_g_diff.df$ratio,nbTechs = 3, ymin = -0.08, ymax = 0.17, "", "Error Magnitude Pairwise Differences. Error Bars, 95% CIs", 0)
plot_err_t <- dualChart(err_t.df,err_t.df$representation,nbTechs = 2, ymin = 0, ymax = 0.17, "", "Error Magnitude (% of data domain). Error Bars, 95% CIs", 0)
plot_err_t_diff <- dualChart(err_t_diff.df,err_t_diff.df$ratio,nbTechs = 1, ymin = -0.1, ymax = 0.055,  "", "Error Magnitude Pairwise Differences. Error Bars, 95% CIs", 0)

plot_compare_between_err_r <- dualChart(compare_between_err_r.df,compare_between_err_r.df$representation,nbTechs = 2, ymin = 0, ymax = 0.6, "", "Error Magnitude (% of data domain). Error Bars, 95% CIs", 0)
plot_compare_between_err_r_diff <- dualChart(compare_between_err_r_diff.df,compare_between_err_r_diff.df$ratio,nbTechs = 1, ymin = -0.33, ymax = 0.1, "", "Error Magnitude Pairwise Differences. Error Bars, 95% CIs", 0)
plot_compare_between_err_g <- dualChart(compare_between_err_g.df,compare_between_err_g.df$granularity,nbTechs = 3, ymin = 0, ymax = 0.6, "", "Error Magnitude (% of data domain). Error Bars, 95% CIs", 0)
plot_compare_between_err_g_diff <- dualChart(compare_between_err_g_diff.df,compare_between_err_g_diff.df$ratio,nbTechs = 3, ymin = -0.01, ymax = 0.6, "", "Error Magnitude Pairwise Differences. Error Bars, 95% CIs", 0)

plot_pref_r <- dualChart(preference_CI.df,preference_CI.df$representation,nbTechs = 2, ymin = 0, ymax = 100, "", "Preference: Linear vs Radial. Error Bars, 95% CIs", 0)
plot_conf_r <- dualChart(conf_r.df,conf_r.df$representation,nbTechs = 2, ymin = 2, ymax = 5, "", "Self-Reported Confidence. Error Bars, 95% CIs", 0)
plot_conf_r_diff <- dualChart(conf_r_diff.df,conf_r_diff.df$ratio,nbTechs = 1, ymin = -1.5, ymax = 0, "", "Confidence pairwise differences. Error Bars, 95% CIs", 0)

ggsave(plot = plot_RT_r, filename = "plot_RT_r.png", device ="png", width = 8, height = 4, units = "in", dpi = 300)
print("plot_RT_r.png")
ggsave(plot = plot_RT_r_diff, filename = "plot_RT_r_diff.png", device ="png", width = 8, height = 4, units = "in", dpi = 300)
print("plot_RT_r_diff.png")
ggsave(plot = plot_RT_g, filename = "plot_RT_g.png", device ="png", width = 8, height = 4, units = "in", dpi = 300)
print("plot_RT_g.png")
ggsave(plot = plot_RT_g_diff, filename = "plot_RT_g_diff.png", device ="png", width = 8, height = 4, units = "in", dpi = 300)
print("plot_RT_g_diff.png")
ggsave(plot = plot_RT_t, filename = "plot_RT_t.png", device ="png", width = 8, height = 4, units = "in", dpi = 300)
print("plot_RT_t_diff.png")
ggsave(plot = plot_RT_t_diff, filename = "plot_RT_t_diff.png", device ="png", width = 8, height = 4, units = "in", dpi = 300)
print("plot_RT_t_diff.png")
ggsave(plot = plot_err_r, filename = "plot_err_r.png", device ="png", width = 8, height = 4, units = "in", dpi = 300)
print("plot_err_r.png")
ggsave(plot = plot_err_r_diff, filename = "plot_err_r_diff.png", device ="png", width = 8, height = 4, units = "in", dpi = 300)
print("plot_err_r_diff.png")
ggsave(plot = plot_err_rate_r, filename = "plot_err_rate_r.png", device ="png", width = 8, height = 4, units = "in", dpi = 300)
print("plot_err_rate_r.png")
ggsave(plot = plot_err_rate_r_diff, filename = "plot_err_rate_r_diff.png", device ="png", width = 8, height = 4, units = "in", dpi = 300)
print("plot_err_rate_r_diff.png")
ggsave(plot = plot_err_g, filename = "plot_err_g.png", device ="png", width = 8, height = 4, units = "in", dpi = 300)
print("plot_err_g.png")
ggsave(plot = plot_err_g_diff, filename = "plot_err_g_diff.png", device ="png", width = 8, height = 4, units = "in", dpi = 300)
print("plot_err_g_diff.png")
ggsave(plot = plot_err_rate_g, filename = "plot_err_rate_g.png", device ="png", width = 8, height = 4, units = "in", dpi = 300)
print("plot_err_rate_g.png")
ggsave(plot = plot_err_rate_g_diff, filename = "plot_err_rate_g_diff.png", device ="png", width = 8, height = 4, units = "in", dpi = 300)
print("plot_err_rate_g_diff.png")
ggsave(plot = plot_err_t, filename = "plot_err_t.png", device ="png", width = 8, height = 4, units = "in", dpi = 300)
print("plot_err_t.png")
ggsave(plot = plot_err_t_diff, filename = "plot_err_t_diff.png", device ="png", width = 8, height = 4, units = "in", dpi = 300)
print("plot_err_t_diff.png")
ggsave(plot = plot_err_rate_t, filename = "plot_err_rate_t.png", device ="png", width = 8, height = 4, units = "in", dpi = 300)
print("plot_err_rate_t.png")
ggsave(plot = plot_err_rate_t_diff, filename = "plot_err_rate_t_diff.png", device ="png", width = 8, height = 4, units = "in", dpi = 300)
print("plot_err_rate_t_diff.png")

ggsave(plot = plot_compare_between_err_r, filename = "plot_compare_between_err_r.png", device ="png", width = 8, height = 1.5, units = "in", dpi = 300)
print("plot_compare_between_err_r.png")
ggsave(plot = plot_compare_between_err_r_diff, filename = "plot_compare_between_err_r_diff.png", device ="png", width = 8, height = 1.5, units = "in", dpi = 300)
print("plot_compare_between_err_r_diff.png")
ggsave(plot = plot_compare_between_err_g, filename = "plot_compare_between_err_g.png", device ="png", width = 8, height = 1.5, units = "in", dpi = 300)
print("plot_compare_between_err_g.png")
ggsave(plot = plot_compare_between_err_g_diff, filename = "plot_compare_between_err_g_diff.png", device ="png", width = 8, height = 1.5, units = "in", dpi = 300)
print("plot_compare_between_err_g_diff.png")

ggsave(plot = plot_pref_r, filename = "plot_pref_r.png", device ="png", width = 8, height = 2, units = "in", dpi = 300)
print("plot_pref_r.png")
ggsave(plot = plot_conf_r, filename = "plot_conf_r.png", device ="png", width = 8, height = 2, units = "in", dpi = 300)
print("plot_conf_r.png")
ggsave(plot = plot_conf_r_diff, filename = "plot_conf_r_diff.png", device ="png", width = 8, height = 2, units = "in", dpi = 300)
print("plot_conf_r_diff.png")

ggsave(plot = plot_RT_r, filename = "plot_RT_r.pdf", device ="pdf", width = 8, height = 4, units = "in", dpi = 300)
print("plot_RT_r.pdf")
ggsave(plot = plot_RT_r_diff, filename = "plot_RT_r_diff.pdf", device ="pdf", width = 8, height = 4, units = "in", dpi = 300)
print("plot_RT_r_diff.pdf")
ggsave(plot = plot_RT_g, filename = "plot_RT_g.pdf", device ="pdf", width = 8, height = 4, units = "in", dpi = 300)
print("plot_RT_g.pdf")
ggsave(plot = plot_RT_g_diff, filename = "plot_RT_g_diff.pdf", device ="pdf", width = 8, height = 4, units = "in", dpi = 300)
print("plot_RT_g_diff.pdf")
ggsave(plot = plot_RT_t, filename = "plot_RT_t.pdf", device ="pdf", width = 8, height = 4, units = "in", dpi = 300)
print("plot_RT_t_diff.pdf")
ggsave(plot = plot_RT_t_diff, filename = "plot_RT_t_diff.pdf", device ="pdf", width = 8, height = 4, units = "in", dpi = 300)
print("plot_RT_t_diff.pdf")
ggsave(plot = plot_err_r, filename = "plot_err_r.pdf", device ="pdf", width = 8, height = 4, units = "in", dpi = 300)
print("plot_err_r.pdf")
ggsave(plot = plot_err_r_diff, filename = "plot_err_r_diff.pdf", device ="pdf", width = 8, height = 4, units = "in", dpi = 300)
print("plot_err_r_diff.pdf")
ggsave(plot = plot_err_rate_r, filename = "plot_err_rate_r.pdf", device ="pdf", width = 8, height = 4, units = "in", dpi = 300)
print("plot_err_rate_r.pdf")
ggsave(plot = plot_err_rate_r_diff, filename = "plot_err_rate_r_diff.pdf", device ="pdf", width = 8, height = 4, units = "in", dpi = 300)
print("plot_err_rate_r_diff.pdf")
ggsave(plot = plot_err_g, filename = "plot_err_g.pdf", device ="pdf", width = 8, height = 4, units = "in", dpi = 300)
print("plot_err_g.pdf")
ggsave(plot = plot_err_g_diff, filename = "plot_err_g_diff.pdf", device ="pdf", width = 8, height = 4, units = "in", dpi = 300)
print("plot_err_g_diff.pdf")
ggsave(plot = plot_err_rate_g, filename = "plot_err_rate_g.pdf", device ="pdf", width = 8, height = 4, units = "in", dpi = 300)
print("plot_err_rate_g.pdf")
ggsave(plot = plot_err_rate_g_diff, filename = "plot_err_rate_g_diff.pdf", device ="pdf", width = 8, height = 4, units = "in", dpi = 300)
print("plot_err_rate_g_diff.pdf")
ggsave(plot = plot_err_t, filename = "plot_err_t.pdf", device ="pdf", width = 8, height = 4, units = "in", dpi = 300)
print("plot_err_t.pdf")
ggsave(plot = plot_err_t_diff, filename = "plot_err_t_diff.pdf", device ="pdf", width = 8, height = 4, units = "in", dpi = 300)
print("plot_err_t_diff.pdf")
ggsave(plot = plot_err_rate_t, filename = "plot_err_rate_t.pdf", device ="pdf", width = 8, height = 4, units = "in", dpi = 300)
print("plot_err_rate_t.pdf")
ggsave(plot = plot_err_rate_t_diff, filename = "plot_err_rate_t_diff.pdf", device ="pdf", width = 8, height = 4, units = "in", dpi = 300)
print("plot_err_rate_t_diff.pdf")

ggsave(plot = plot_compare_between_err_r, filename = "plot_compare_between_err_r.pdf", device ="pdf", width = 8, height = 1.5, units = "in", dpi = 300)
print("plot_compare_between_err_r.pdf")
ggsave(plot = plot_compare_between_err_r_diff, filename = "plot_compare_between_err_r_diff.pdf", device ="pdf", width = 8, height = 1.5, units = "in", dpi = 300)
print("plot_compare_between_err_r_diff.pdf")
ggsave(plot = plot_compare_between_err_g, filename = "plot_compare_between_err_g.pdf", device ="pdf", width = 8, height = 1.5, units = "in", dpi = 300)
print("plot_compare_between_err_g.pdf")
ggsave(plot = plot_compare_between_err_g_diff, filename = "plot_compare_between_err_g_diff.pdf", device ="pdf", width = 8, height = 1.5, units = "in", dpi = 300)
print("plot_compare_between_err_g_diff.pdf")

ggsave(plot = plot_pref_r, filename = "plot_pref_r.pdf", device ="pdf", width = 8, height = 2, units = "in", dpi = 300)
print("plot_pref_r.pdf")
ggsave(plot = plot_conf_r, filename = "plot_conf_r.pdf", device ="pdf", width = 8, height = 2, units = "in", dpi = 300)
print("plot_conf_r.pdf")
ggsave(plot = plot_conf_r_diff, filename = "plot_conf_r_diff.pdf", device ="pdf", width = 8, height = 2, units = "in", dpi = 300)
print("plot_conf_r_diff.pdf")
