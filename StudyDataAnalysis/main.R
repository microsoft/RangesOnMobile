#load data
source('processLogCSVs.R', encoding = 'UTF-8')

#helper functions for calculating and plotting CIs
source('plot_CIs.R')
source('bootCIs.R')

#RT CIs
source('RT_CIs_r.R') #by representation
source('RT_CIs_g.R') #by granularity
source('RT_CIs_t.R') #by target (start / end / range)

#err CIs
source('err_CIs_r.R') #by representation
source('err_CIs_g.R') #by granularity
source('err_CIs_t.R') #by target (start / end / range)

#confidence
source('confidence_CIs.R') #confidence by representation x granularity

#preference
source('preference_CIs.R') #confidence by representation x granularity

#export plots
source('plot_export.R') #confidence by representation x granularity
