library(dplyr)
library(jsonlite)
library(ggplot2)

loadData <- function(path) { 
  files <- dir(path, pattern = '\\.csv', full.names = TRUE)
  tables <- lapply(files, function(i) read.csv(file = i,col.names = FALSE,stringsAsFactors = FALSE))
  do.call(rbind, tables)
}

participant_data <- loadData(datatype)

#----------------------------------
# PHONE DIMS
#---------------------------------

load_data <- participant_data[grepl("\"Load\"",participant_data[,1]),] %>% data.frame()

load_data <- sapply(load_data[,1],function(x){as.character(x)})
load_data <- lapply(load_data,function(x){fromJSON(x)})

#convert to proper names
load_data <- lapply(load_data,function(x){x[names(load_data[[1]])]})

# load_data <- lapply(load_data,function(x){unlist(x)})

#attempt to re-order temp values
phone_dims.df <- do.call(rbind,load_data) %>% 
  apply(2,function(x){unlist(x)}) %>%
  as.data.frame(stringsAsFactors=F)

remove(load_data)

# #numeric variables
phone_dims.df$TimeStamp <- phone_dims.df$TimeStamp %>% as.numeric()
phone_dims.df$Height <- phone_dims.df$Height %>% as.numeric()
phone_dims.df$Width <- phone_dims.df$Width %>% as.numeric()

# #categorical variables
phone_dims.df$Mode <- phone_dims.df$Mode %>% as.factor()
phone_dims.df$Event <- phone_dims.df$Event %>% as.factor()
phone_dims.df$user_id <- phone_dims.df$user_id %>% as.factor()

#----------------------------------
# QUANTITATIVE SCALE DOMAINS BY WEEK/MONTH/YEAR INDEX FOR QUANT_ERROR CORRECTION
#---------------------------------

quant_domains.df <- read.csv(file="quant_domains.csv")
quant_domains.df$representation <- quant_domains.df$representation %>% as.factor()
quant_domains.df$granularity <- quant_domains.df$granularity %>% as.factor()
quant_domains.df$datatype <- quant_domains.df$datatype %>% as.character()
quant_domains.df$granularity <- ordered(quant_domains.df$granularity, levels = c("week", "month", "year"))

quant_domains.df$index <- quant_domains.df$index %>% as.numeric()
quant_domains.df$domain0 <- quant_domains.df$domain0 %>% as.numeric()
quant_domains.df$domain1 <- quant_domains.df$domain1 %>% as.numeric()
quant_domains.df$max_error <- quant_domains.df$max_error %>% as.numeric()

#----------------------------------
# STUDY APP INITILIZATION
#---------------------------------

init_data <- participant_data[grepl("\"InitTasks\"",participant_data[,1]),] %>% data.frame()

init_data <- sapply(init_data[,1],function(x){as.character(x)})
init_data <- lapply(init_data,function(x){fromJSON(x)})

#convert to proper names
init_data <- lapply(init_data,function(x){x[names(init_data[[1]])]})

# init_data <- lapply(init_data,function(x){unlist(x)})

#attempt to re-order temp values
init.df <- do.call(rbind,init_data) %>% 
  apply(2,function(x){unlist(x)}) %>%
  as.data.frame(stringsAsFactors=F)

remove(init_data)

# #numeric variables
init.df$TimeStamp <- init.df$TimeStamp %>% as.numeric()

# #categorical variables
init.df$Datatype <- init.df$Datatype %>% as.factor()
init.df$Event <- init.df$Event %>% as.factor()
init.df$FirstRepresentation <- init.df$FirstRepresentation %>% as.factor()
init.df$user_id <- init.df$user_id %>% as.factor()

participant_metadata.df <- read.csv(file=paste(datatype,"_metadata.csv",sep = ""))

names(participant_metadata.df)[names(participant_metadata.df) == 'ï..user_id'] <- 'user_id'

drops <- c("TimeStamp","Event")

init.df <- init.df[,!(names(init.df) %in% drops)]
phone_dims.df <- phone_dims.df[,!(names(phone_dims.df) %in% drops)]

participant_metadata.df <- inner_join(participant_metadata.df,init.df,by = 'user_id')

participant_metadata.df <- inner_join(participant_metadata.df, phone_dims.df,by = 'user_id')

participant_metadata.df$chart_dim <- apply(data.frame(participant_metadata.df$Width,participant_metadata.df$Height),1,FUN=min)
participant_metadata.df$chart_dim <- participant_metadata.df$chart_dim - 2
participant_metadata.df$chart_dim <- participant_metadata.df$chart_dim * 0.75

chart_dims.df <- data.frame(participant_metadata.df$user_id,participant_metadata.df$chart_dim)
names(chart_dims.df) <- c('user_id','chart_dim')

remove(init.df,phone_dims.df)
remove(drops)

#----------------------------------
# TASK: LOCATE DATE
#---------------------------------

locate_date_data <- participant_data[grepl("task_name.*LocateDate",participant_data[,1]),] %>% data.frame()

locate_date_data <- sapply(locate_date_data[,1],function(x){as.character(x)})
locate_date_data <- lapply(locate_date_data,function(x){fromJSON(x)})

#convert to proper names
locate_date_data <- lapply(locate_date_data,function(x){x[names(locate_date_data[[1]])]})

#attempt to re-order temp values
locate_date.df <- do.call(rbind,locate_date_data) %>%
  apply(2,function(x){unlist(x)}) %>%
  as.data.frame(stringsAsFactors=F)

remove(locate_date_data)

#numeric variables
locate_date.df$attempts <- locate_date.df$attempts %>% as.numeric()
locate_date.df$chron_distance <- locate_date.df$chron_distance %>% as.numeric()
locate_date.df$chron_error <- locate_date.df$chron_error %>% as.numeric()
locate_date.df$end_time <- locate_date.df$end_time %>% as.numeric()
locate_date.df$index <- locate_date.df$index %>% as.numeric()
locate_date.df$interruption_time <- locate_date.df$interruption_time %>% as.numeric()
locate_date.df$interruptions <- locate_date.df$interruptions %>% as.numeric()
locate_date.df$load_time <- locate_date.df$load_time %>% as.numeric()
locate_date.df$normalized_chron_distance <- locate_date.df$normalized_chron_distance %>% as.numeric()
locate_date.df$reading_interruption_time <- locate_date.df$reading_interruption_time %>% as.numeric()
locate_date.df$reading_interruptions <- locate_date.df$reading_interruptions %>% as.numeric()
locate_date.df$reading_time <- locate_date.df$reading_time %>% as.numeric()
locate_date.df$response_time <- locate_date.df$response_time %>% as.numeric()
locate_date.df$response_value <- locate_date.df$response_value %>% as.numeric()
locate_date.df$start_time <- locate_date.df$start_time %>% as.numeric()
locate_date.df$target <- locate_date.df$target %>% as.numeric()
names(locate_date.df)[names(locate_date.df) == 'target'] <- 'target_value'

#categorical variables
locate_date.df$datatype <- locate_date.df$datatype %>% as.factor()
locate_date.df$granularity <- locate_date.df$granularity %>% as.factor()
locate_date.df$granularity <- ordered(locate_date.df$granularity, levels = c("week", "month", "year"))
locate_date.df$representation <- locate_date.df$representation %>% as.factor()
locate_date.df$task_name <- locate_date.df$task_name %>% as.factor()
locate_date.df$user_id <- locate_date.df$user_id %>% as.factor()
locate_date.df$year <- locate_date.df$year %>% as.factor()

#binary variables
locate_date.df$binary_error <- locate_date.df$binary_error %>% as.logical()
locate_date.df$training <- locate_date.df$training %>% as.logical()
locate_date.df$gotcha <- locate_date.df$gotcha %>% as.logical()

#join with chart_dims
locate_date.df <- inner_join(locate_date.df,chart_dims.df,by='user_id')

#corrected normalized error
locate_date.df$max_error <- 0
locate_date.df[locate_date.df$granularity == 'week',]$max_error <- 6
locate_date.df[locate_date.df$granularity == 'month',]$max_error <- 30
locate_date.df[locate_date.df$granularity == 'year',]$max_error <- 365
locate_date.df$corrected_normalized_error <- locate_date.df$chron_error / locate_date.df$max_error

#remove participants who got the weekly gotcha questions wrong
gotcha.df <- locate_date.df[locate_date.df$gotcha == T & locate_date.df$granularity == 'week' & locate_date.df$binary_error == T,]
excluded_participants <- levels(droplevels(gotcha.df$user_id))
participant_metadata.df$excluded <- participant_metadata.df$user_id %in% excluded_participants

#subset to non-excluded participants
locate_date.df <- locate_date.df[!(locate_date.df$user_id %in% excluded_participants),]
locate_date.df$user_id <- factor(locate_date.df$user_id)

#remove trials where the chron_response_value is NA (subject touched just outside of chart dim and pressed 'done')
locate_date.df <- locate_date.df[!is.na(locate_date.df$response_value),]

#correct inverse scale mapping bug for monthly and yearly ganularities when chron_error = 0
locate_date.df$chron_distance[locate_date.df$chron_distance < 0] <- 0
locate_date.df$normalized_chron_distance[locate_date.df$normalized_chron_distance < 0] <- 0

#subset to test_data
locate_date_test.df <- locate_date.df[locate_date.df$training == F & locate_date.df$gotcha == F,]

locate_date_outliers.df <- locate_date_test.df[locate_date_test.df$response_time > mean(locate_date_test.df$response_time) + 3 * sd(locate_date_test.df$response_time),]

#remove RT outliers (mean + 3 * SD)
locate_date_test.df <- locate_date_test.df[locate_date_test.df$response_time < mean(locate_date_test.df$response_time) + 3 * sd(locate_date_test.df$response_time),]

#response time data frame
locate_date_RT.df <- aggregate(log(locate_date_test.df$response_time/1000), list(locate_date_test.df$user_id,
                                                                       locate_date_test.df$datatype,
                                                                       locate_date_test.df$representation, 
                                                                       locate_date_test.df$granularity), mean)

names(locate_date_RT.df) <- c("user_id","datatype","representation","granularity","response_time")


#error data frame
locate_date_err.df <- aggregate(abs(locate_date_test.df$corrected_normalized_error), list(locate_date_test.df$user_id,
                                                                                    locate_date_test.df$datatype,
                                                                                    locate_date_test.df$representation, 
                                                                                    locate_date_test.df$granularity), mean)

names(locate_date_err.df) <- c("user_id","datatype","representation","granularity","error")

locate_date_test.df <- locate_date_test.df[c('user_id','response_time','corrected_normalized_error','granularity','representation','datatype','binary_error','task_name')]
names(locate_date_test.df) <- c('user_id','response_time','error','granularity','representation','datatype','binary_error','task_name')
locate_date_test.df$target <- NA
locate_date_test.df$binary_error <- as.numeric(locate_date_test.df$binary_error) 

#plot all trials per participant
# plot_locate_date_RT_temperature <- ggplot(locate_date.df[locate_date.df$gotcha == F & locate_date.df$training == F & locate_date.df$datatype == 'temperature',], aes(y=granularity,x=response_time,color=binary_error)) + geom_jitter(size=3,position=position_jitter(height = 0,width = 0)) + facet_grid(user_id ~ representation) +
#   geom_vline(aes(xintercept=mean(response_time)),show.legend = F,color="red") +
#   geom_vline(aes(xintercept=(mean(response_time) + 3 * sd(response_time))),show.legend = F,color="blue")
# plot_locate_date_RT_sleep <- ggplot(locate_date.df[locate_date.df$gotcha == F & locate_date.df$training == F & locate_date.df$datatype == 'sleep',], aes(y=granularity,x=response_time,color=binary_error)) + geom_jitter(size=3,position=position_jitter(height = 0,width = 0)) + facet_grid(user_id ~ representation) +
#   geom_vline(aes(xintercept=mean(response_time)),show.legend = F,color="red") +
#   geom_vline(aes(xintercept=(mean(response_time) + 3 * sd(response_time))),show.legend = F,color="blue")
# plot_locate_date_err_temperature <- ggplot(locate_date.df[locate_date.df$gotcha == F & locate_date.df$training == F & locate_date.df$datatype == 'temperature',], aes(y=granularity,x=corrected_normalized_error,color=binary_error)) + geom_jitter(size=3,position=position_jitter(height = 0,width = 0)) + facet_grid(user_id ~ representation) +
#   geom_vline(aes(xintercept=mean(corrected_normalized_error)),show.legend = F,color="red") +
#   geom_vline(aes(xintercept=(mean(corrected_normalized_error) + 3 * sd(corrected_normalized_error))),show.legend = F,color="blue")
# plot_locate_date_err_sleep <- ggplot(locate_date.df[locate_date.df$gotcha == F & locate_date.df$training == F & locate_date.df$datatype == 'sleep',], aes(y=granularity,x=corrected_normalized_error,color=binary_error)) + geom_jitter(size=3,position=position_jitter(height = 0,width = 0)) + facet_grid(user_id ~ representation) +
#   geom_vline(aes(xintercept=mean(corrected_normalized_error)),show.legend = F,color="red") +
#   geom_vline(aes(xintercept=(mean(corrected_normalized_error) + 3 * sd(corrected_normalized_error))),show.legend = F,color="blue")
# 
# plot_locate_date_RT_hist <- ggplot(locate_date.df[locate_date.df$gotcha == F & locate_date.df$training == F,], aes(x = response_time)) + geom_histogram(binwidth = 500) + facet_grid(. ~ datatype) + 
#   geom_vline(aes(xintercept=mean(response_time)),show.legend = F,color="red") +
#   geom_vline(aes(xintercept=(mean(response_time) + 3 * sd(response_time))),show.legend = F,color="blue")
# plot_locate_date_err_hist <- ggplot(locate_date.df[locate_date.df$gotcha == F & locate_date.df$training == F,], aes(x = corrected_normalized_error)) + geom_histogram(binwidth = 0.025) + facet_grid(. ~ datatype) + 
#   geom_vline(aes(xintercept=mean(corrected_normalized_error)),show.legend = F,color="red") +
#   geom_vline(aes(xintercept=(mean(corrected_normalized_error)) + 3 * sd(corrected_normalized_error)),show.legend = F,color="blue")

#----------------------------------
# TASK: READ VALUE
#---------------------------------

read_value_data <- participant_data[grepl("task_name.*ReadValue",participant_data[,1]),] %>% data.frame()

read_value_data <- sapply(read_value_data[,1],function(x){as.character(x)})
read_value_data <- lapply(read_value_data,function(x){fromJSON(x)})

#convert to proper names
read_value_data <- lapply(read_value_data,function(x){x[names(read_value_data[[1]])]})

#attempt to re-order temp values
read_value.df <- do.call(rbind,read_value_data) %>% 
  apply(2,function(x){unlist(x)}) %>%
  as.data.frame(stringsAsFactors=F)

remove(read_value_data)

#numeric variables
read_value.df$attempts <- read_value.df$attempts %>% as.numeric()
read_value.df$end_time <- read_value.df$end_time %>% as.numeric()
read_value.df$index <- read_value.df$index %>% as.numeric()
read_value.df$interruption_time <- read_value.df$interruption_time %>% as.numeric()
read_value.df$interruptions <- read_value.df$interruptions %>% as.numeric()
read_value.df$load_time <- read_value.df$load_time %>% as.numeric()
read_value.df$normalized_quant_distance <- read_value.df$normalized_quant_distance %>% as.numeric()
read_value.df$quant_distance <- read_value.df$quant_distance %>% as.numeric()
read_value.df$quant_error <- read_value.df$quant_error %>% as.numeric()
read_value.df$quant_error <- abs(read_value.df$quant_error)
read_value.df$reading_interruptions <- read_value.df$reading_interruptions %>% as.numeric()
read_value.df$reading_interruption_time <- read_value.df$reading_interruption_time %>% as.numeric()
read_value.df$reading_time <- read_value.df$reading_time %>% as.numeric()
read_value.df$response_time <- read_value.df$response_time %>% as.numeric()
read_value.df$response_value <- read_value.df$response_value %>% as.numeric()
read_value.df$start_time <- read_value.df$start_time %>% as.numeric()
read_value.df$target <- read_value.df$target %>% as.numeric()
names(read_value.df)[names(read_value.df) == 'target'] <- 'day_index'
read_value.df$target_value <- read_value.df$target_value %>% as.numeric()

#categorical variables
read_value.df$granularity <- read_value.df$granularity %>% as.factor()
read_value.df$granularity <- ordered(read_value.df$granularity, levels = c("week", "month", "year"))
read_value.df$representation <- read_value.df$representation %>% as.factor()
read_value.df$target_attribute <- read_value.df$target_attribute %>% as.factor()
read_value.df$task_name <- read_value.df$task_name %>% as.factor()
read_value.df$user_id <- read_value.df$user_id %>% as.factor()
read_value.df$year <- read_value.df$year %>% as.factor()

#binary variables
read_value.df$binary_error <- read_value.df$binary_error %>% as.logical()
read_value.df$training <- read_value.df$training %>% as.logical()

#join with chart_dims
read_value.df <- inner_join(read_value.df,chart_dims.df,by='user_id')

#corrected normalized error
read_value.df <- inner_join(read_value.df, quant_domains.df, by = c("representation", "granularity", "datatype", "index"))
read_value.df$datatype <- read_value.df$datatype %>% as.factor()
read_value.df$corrected_normalized_error <- read_value.df$quant_error / read_value.df$max_error

# #corrected normalized error
# read_value.df$corrected_normalized_error <- 0
# read_value.df[read_value.df$representation == 'linear',]$corrected_normalized_error <- read_value.df[read_value.df$representation == 'linear',]$quant_distance / read_value.df[read_value.df$representation == 'linear',]$chart_dim
# read_value.df[read_value.df$representation == 'radial',]$corrected_normalized_error <- read_value.df[read_value.df$representation == 'radial',]$quant_distance / (read_value.df[read_value.df$representation == 'radial',]$chart_dim * 0.5)

#subset to non-excluded participants
read_value.df <- read_value.df[!(read_value.df$user_id %in% excluded_participants),]
read_value.df$user_id <- factor(read_value.df$user_id)

#subset to test_data
read_value_test.df <- read_value.df[read_value.df$training == F,]

read_value_outliers.df <- read_value_test.df[read_value_test.df$response_time > mean(read_value_test.df$response_time) + 3 * sd(read_value_test.df$response_time),]

#remove RT outliers (mean + 3 * SD)
read_value_test.df <- read_value_test.df[read_value_test.df$response_time < mean(read_value_test.df$response_time) + 3 * sd(read_value_test.df$response_time),]

#response time data frame
read_value_RT.df <- aggregate(log(read_value_test.df$response_time/1000), list(read_value_test.df$user_id,
                                                                      read_value_test.df$datatype,
                                                                      read_value_test.df$representation, 
                                                                      read_value_test.df$granularity), mean)

names(read_value_RT.df) <- c("user_id","datatype","representation","granularity","response_time")

#error data frame
read_value_err.df <- aggregate(abs(read_value_test.df$corrected_normalized_error), list(read_value_test.df$user_id,
                                                                                        read_value_test.df$datatype,
                                                                                        read_value_test.df$representation, 
                                                                                        read_value_test.df$granularity), mean)

names(read_value_err.df) <- c("user_id","datatype","representation","granularity","error")

read_value_test.df <- read_value_test.df[c('user_id','response_time','corrected_normalized_error','granularity','representation','datatype','binary_error','task_name','target_attribute')]
names(read_value_test.df) <- c('user_id','response_time','error','granularity','representation','datatype','binary_error','task_name','target')
read_value_test.df$binary_error <- as.numeric(read_value_test.df$binary_error)

#plot all trials per participant
# plot_read_value_RT_temperature <- ggplot(read_value.df[read_value.df$training == F & read_value.df$datatype == 'temperature',], aes(y=granularity,x=response_time,color=binary_error,shape=target_attribute)) + geom_jitter(size=3,position=position_jitter(height = 0,width = 0)) + facet_grid(user_id ~ representation) +
#   geom_vline(aes(xintercept=mean(response_time)),show.legend = F,color="red") +
#   geom_vline(aes(xintercept=(mean(response_time) + 3 * sd(response_time))),show.legend = F,color="blue")
# plot_read_value_RT_sleep <- ggplot(read_value.df[read_value.df$training == F & read_value.df$datatype == 'sleep',], aes(y=granularity,x=response_time,color=binary_error,shape=target_attribute)) + geom_jitter(size=3,position=position_jitter(height = 0,width = 0)) + facet_grid(user_id ~ representation) +
#   geom_vline(aes(xintercept=mean(response_time)),show.legend = F,color="red") +
#   geom_vline(aes(xintercept=(mean(response_time) + 3 * sd(response_time))),show.legend = F,color="blue")
# plot_read_value_err_temperature <- ggplot(read_value.df[read_value.df$training == F & read_value.df$datatype == 'temperature',], aes(y=granularity,x=corrected_normalized_error,color=binary_error,shape=target_attribute)) + geom_jitter(size=3,position=position_jitter(height = 0,width = 0)) + facet_grid(user_id ~ representation) +
#   geom_vline(aes(xintercept=mean(corrected_normalized_error)),show.legend = F,color="red") +
#   geom_vline(aes(xintercept=(mean(corrected_normalized_error) + 3 * sd(corrected_normalized_error))),show.legend = F,color="blue")
# plot_read_value_err_sleep <- ggplot(read_value.df[read_value.df$training == F & read_value.df$datatype == 'sleep',], aes(y=granularity,x=corrected_normalized_error,color=binary_error,shape=target_attribute)) + geom_jitter(size=3,position=position_jitter(height = 0,width = 0)) + facet_grid(user_id ~ representation) + 
#   geom_vline(aes(xintercept=mean(corrected_normalized_error)),show.legend = F,color="red") +
#   geom_vline(aes(xintercept=(mean(corrected_normalized_error) + 3 * sd(corrected_normalized_error))),show.legend = F,color="blue")
# 
# plot_read_value_RT_hist <- ggplot(read_value.df[read_value.df$training == F,], aes(x = response_time)) + geom_histogram(binwidth = 500) + facet_grid(. ~ datatype) + 
#   geom_vline(aes(xintercept=mean(response_time)),show.legend = F,color="red") +
#   geom_vline(aes(xintercept=(mean(response_time) + 3 * sd(response_time))),show.legend = F,color="blue")
# plot_read_value_err_hist <- ggplot(read_value.df[read_value.df$training == F,], aes(x = corrected_normalized_error)) + geom_histogram(binwidth = 0.025) + facet_grid(. ~ datatype) + 
#   geom_vline(aes(xintercept=mean(corrected_normalized_error)),show.legend = F,color="red") +
#   geom_vline(aes(xintercept=(mean(corrected_normalized_error)) + 3 * sd(corrected_normalized_error)),show.legend = F,color="blue")

#----------------------------------
# TASK: LOCATE MIN / MAx
#---------------------------------

locate_minmax_data <- participant_data[grepl("task_name.*LocateMinMax",participant_data[,1]),] %>% data.frame()

locate_minmax_data <- sapply(locate_minmax_data[,1],function(x){as.character(x)})
locate_minmax_data <- lapply(locate_minmax_data,function(x){fromJSON(x)})

#convert to proper names
locate_minmax_data <- lapply(locate_minmax_data,function(x){x[names(locate_minmax_data[[1]])]})

#attempt to re-order temp values
locate_minmax.df <- do.call(rbind,locate_minmax_data) %>% 
  apply(2,function(x){unlist(x)}) %>%
  as.data.frame(stringsAsFactors=F)

remove(locate_minmax_data)

#numeric variables
locate_minmax.df$attempts <- locate_minmax.df$attempts %>% as.numeric()
locate_minmax.df$chron_distance <- locate_minmax.df$chron_distance %>% as.numeric()
locate_minmax.df$chron_error <- locate_minmax.df$chron_error %>% as.numeric()
locate_minmax.df$chron_response_value <- locate_minmax.df$chron_response_value %>% as.numeric()
locate_minmax.df$chron_target <- locate_minmax.df$chron_target %>% as.numeric()
locate_minmax.df$end_time <- locate_minmax.df$end_time %>% as.numeric()
locate_minmax.df$index <- locate_minmax.df$index %>% as.numeric()
locate_minmax.df$interruption_time <- locate_minmax.df$interruption_time %>% as.numeric()
locate_minmax.df$interruptions <- locate_minmax.df$interruptions %>% as.numeric()
locate_minmax.df$load_time <- locate_minmax.df$load_time %>% as.numeric()
locate_minmax.df$normalized_chron_distance <- locate_minmax.df$normalized_chron_distance %>% as.numeric()
locate_minmax.df$normalized_quant_distance <- locate_minmax.df$normalized_quant_distance %>% as.numeric()
locate_minmax.df$quant_distance <- locate_minmax.df$quant_distance %>% as.numeric()
locate_minmax.df$quant_error <- locate_minmax.df$quant_error %>% as.numeric()
locate_minmax.df$reading_interruption_time <- locate_minmax.df$reading_interruption_time %>% as.numeric()
locate_minmax.df$reading_interruptions <- locate_minmax.df$reading_interruptions %>% as.numeric()
locate_minmax.df$reading_time <- locate_minmax.df$reading_time %>% as.numeric()
locate_minmax.df$response_time <- locate_minmax.df$response_time %>% as.numeric()
locate_minmax.df$response_value <- locate_minmax.df$response_value %>% as.numeric()
locate_minmax.df$start_time <- locate_minmax.df$start_time %>% as.numeric()
locate_minmax.df$target_value <- locate_minmax.df$target_value %>% as.numeric()

#categorical variables
locate_minmax.df$datatype <- locate_minmax.df$datatype %>% as.factor()
locate_minmax.df$granularity <- locate_minmax.df$granularity %>% as.factor()
locate_minmax.df$granularity <- ordered(locate_minmax.df$granularity, levels = c("week", "month", "year"))
locate_minmax.df$minmax <- locate_minmax.df$minmax %>% as.factor()
locate_minmax.df$representation <- locate_minmax.df$representation %>% as.factor()
locate_minmax.df$task_name <- locate_minmax.df$task_name %>% as.factor()
locate_minmax.df$user_id <- locate_minmax.df$user_id %>% as.factor()
locate_minmax.df$value <- locate_minmax.df$value %>% as.factor()
names(locate_minmax.df)[names(locate_minmax.df) == 'value'] <- 'target_attribute'
locate_minmax.df$year <- locate_minmax.df$year %>% as.factor()

#binary variables
locate_minmax.df$binary_error <- locate_minmax.df$binary_error %>% as.logical()
locate_minmax.df$training <- locate_minmax.df$training %>% as.logical()

#join with chart_dims
locate_minmax.df <- inner_join(locate_minmax.df,chart_dims.df,by='user_id')

#corrected normalized error
locate_minmax.df$max_error <- 0
locate_minmax.df[locate_minmax.df$granularity == 'week',]$max_error <- 6
locate_minmax.df[locate_minmax.df$granularity == 'month',]$max_error <- 30
locate_minmax.df[locate_minmax.df$granularity == 'year',]$max_error <- 365
locate_minmax.df$corrected_normalized_error <- locate_minmax.df$chron_error / locate_minmax.df$max_error

#subset to non-excluded participants
locate_minmax.df <- locate_minmax.df[!(locate_minmax.df$user_id %in% excluded_participants),]
locate_minmax.df$user_id <- factor(locate_minmax.df$user_id)

#remove trials where the chron_response_value is NA (subject touched just outside of chart dim and pressed 'done')
locate_minmax.df <- locate_minmax.df[!is.na(locate_minmax.df$chron_response_value),]

#correct inverse scale mapping bug for monthly and yearly ganularities when chron_error = 0
locate_minmax.df$chron_distance[locate_minmax.df$chron_distance < 0] <- 0
locate_minmax.df$normalized_chron_distance[locate_minmax.df$normalized_chron_distance < 0] <- 0

#subset to test_data
locate_minmax_test.df <- locate_minmax.df[locate_minmax.df$training == F,]

locate_minmax_outliers.df <- locate_minmax_test.df[locate_minmax_test.df$response_time > mean(locate_minmax_test.df$response_time) + 3 * sd(locate_minmax_test.df$response_time),]

#remove RT outliers (mean + 3 * SD)
locate_minmax_test.df <- locate_minmax_test.df[locate_minmax_test.df$response_time < mean(locate_minmax_test.df$response_time) + 3 * sd(locate_minmax_test.df$response_time),]

#response time data frame
locate_minmax_RT.df <- aggregate(log(locate_minmax_test.df$response_time/1000), list(locate_minmax_test.df$user_id,
                                                                                     locate_minmax_test.df$datatype,
                                                                                     locate_minmax_test.df$representation, 
                                                                                     locate_minmax_test.df$granularity), mean)

names(locate_minmax_RT.df) <- c("user_id","datatype","representation","granularity","response_time")

#error data frame
locate_minmax_err.df <- aggregate(abs(locate_minmax_test.df$corrected_normalized_error), list(locate_minmax_test.df$user_id,
                                                                                              locate_minmax_test.df$datatype,
                                                                                              locate_minmax_test.df$representation, 
                                                                                              locate_minmax_test.df$granularity), mean)

names(locate_minmax_err.df) <- c("user_id","datatype","representation","granularity","error")

locate_minmax_test.df <-locate_minmax_test.df[c('user_id','response_time','corrected_normalized_error','granularity','representation','datatype','binary_error','task_name','target_attribute')]
names(locate_minmax_test.df) <- c('user_id','response_time','error','granularity','representation','datatype','binary_error','task_name','target')
locate_minmax_test.df$binary_error <- as.numeric(locate_minmax_test.df$binary_error)
# 
# #plot all trials per participant
# plot_locate_minmax_RT_temperature <- ggplot(locate_minmax.df[locate_minmax.df$training == F & locate_minmax.df$datatype == 'temperature',], aes(y=granularity,x=response_time,color=binary_error,shape=target_attribute)) + geom_jitter(size=3,position=position_jitter(height = 0,width = 0)) + facet_grid(user_id ~ representation) +
#   geom_vline(aes(xintercept=mean(response_time)),show.legend = F,color="red") +
#   geom_vline(aes(xintercept=(mean(response_time) + 3 * sd(response_time))),show.legend = F,color="blue")
# plot_locate_minmax_RT_sleep <- ggplot(locate_minmax.df[locate_minmax.df$training == F & locate_minmax.df$datatype == 'sleep',], aes(y=granularity,x=response_time,color=binary_error,shape=target_attribute)) + geom_jitter(size=3,position=position_jitter(height = 0,width = 0)) + facet_grid(user_id ~ representation) + 
#   geom_vline(aes(xintercept=mean(response_time)),show.legend = F,color="red") +
#   geom_vline(aes(xintercept=(mean(response_time) + 3 * sd(response_time))),show.legend = F,color="blue")
# plot_locate_minmax_err_temperature <- ggplot(locate_minmax.df[locate_minmax.df$training == F & locate_minmax.df$datatype == 'temperature',], aes(y=granularity,x=corrected_normalized_error,color=binary_error,shape=target_attribute)) + geom_jitter(size=3,position=position_jitter(height = 0,width = 0)) + facet_grid(user_id ~ representation) +
#   geom_vline(aes(xintercept=mean(corrected_normalized_error)),show.legend = F,color="red") +
#   geom_vline(aes(xintercept=(mean(corrected_normalized_error) + 3 * sd(corrected_normalized_error))),show.legend = F,color="blue")
# plot_locate_minmax_err_sleep <- ggplot(locate_minmax.df[locate_minmax.df$training == F & locate_minmax.df$datatype == 'sleep',], aes(y=granularity,x=corrected_normalized_error,color=binary_error,shape=target_attribute)) + geom_jitter(size=3,position=position_jitter(height = 0,width = 0)) + facet_grid(user_id ~ representation) +
#   geom_vline(aes(xintercept=mean(corrected_normalized_error)),show.legend = F,color="red") +
#   geom_vline(aes(xintercept=(mean(corrected_normalized_error) + 3 * sd(corrected_normalized_error))),show.legend = F,color="blue")
# 
# plot_locate_minmax_RT_hist <- ggplot(locate_minmax.df[locate_minmax.df$training == F,], aes(x = response_time)) + geom_histogram(binwidth = 500) + facet_grid(. ~ datatype) + 
#   geom_vline(aes(xintercept=mean(response_time)),show.legend = F,color="red") +
#   geom_vline(aes(xintercept=(mean(response_time) + 3 * sd(response_time))),show.legend = F,color="blue")
# plot_locate_minmax_err_hist <- ggplot(locate_minmax.df[locate_minmax.df$training == F,], aes(x = corrected_normalized_error)) + geom_histogram(binwidth = 0.025) + facet_grid(. ~ datatype) + 
#   geom_vline(aes(xintercept=mean(corrected_normalized_error)),show.legend = F,color="red") +
#   geom_vline(aes(xintercept=(mean(corrected_normalized_error)) + 3 * sd(corrected_normalized_error)),show.legend = F,color="blue")
# 

#----------------------------------
# TASK: COMPARE WITHIN
#---------------------------------

compare_within_data <- participant_data[grepl("task_name.*CompareWithin",participant_data[,1]),] %>% data.frame()

compare_within_data <- sapply(compare_within_data[,1],function(x){as.character(x)})
compare_within_data <- lapply(compare_within_data,function(x){fromJSON(x)})

#convert to proper names
compare_within_data <- lapply(compare_within_data,function(x){x[names(compare_within_data[[1]])]})

#attempt to re-order temp values
compare_within.df <- do.call(rbind,compare_within_data) %>% 
  apply(2,function(x){unlist(x)}) %>%
  as.data.frame(stringsAsFactors=F)

remove(compare_within_data)

# #numeric variables
compare_within.df$attempts <- compare_within.df$attempts %>% as.numeric()
compare_within.df$end_time <- compare_within.df$end_time %>% as.numeric()
compare_within.df$index <- compare_within.df$index %>% as.numeric()
compare_within.df$interruption_time <- compare_within.df$interruption_time %>% as.numeric()
compare_within.df$interruptions <- compare_within.df$interruptions %>% as.numeric()
compare_within.df$load_time <- compare_within.df$load_time %>% as.numeric()
compare_within.df$normalized_quant_distance <- compare_within.df$normalized_quant_distance %>% as.numeric()
compare_within.df$quant_distance <- compare_within.df$quant_distance %>% as.numeric()
compare_within.df$quant_error <- compare_within.df$quant_error %>% as.numeric()
compare_within.df$quant_error <- abs(compare_within.df$quant_error)
compare_within.df$reading_interruption_time <- compare_within.df$reading_interruption_time %>% as.numeric()
compare_within.df$reading_interruptions <- compare_within.df$reading_interruptions %>% as.numeric()
compare_within.df$reading_time <- compare_within.df$reading_time %>% as.numeric()
compare_within.df$response_time <- compare_within.df$response_time %>% as.numeric()
compare_within.df$start_time <- compare_within.df$start_time %>% as.numeric()
compare_within.df$target <- compare_within.df$target %>% as.numeric()
names(compare_within.df)[names(compare_within.df) == 'target'] <- 'day_index'

#categorical variables
compare_within.df$granularity <- compare_within.df$granularity %>% as.factor()
compare_within.df$granularity <- ordered(compare_within.df$granularity, levels = c("week", "month", "year"))
compare_within.df$representation <- compare_within.df$representation %>% as.factor()
compare_within.df$response_value <- compare_within.df$response_value %>% as.factor()
compare_within.df$target_attribute <- compare_within.df$target_attribute %>% as.factor()
compare_within.df$task_name <- compare_within.df$task_name %>% as.factor()
compare_within.df$user_id <- compare_within.df$user_id %>% as.factor()
compare_within.df$year <- compare_within.df$year %>% as.factor()

#binary variables
compare_within.df$binary_error <- compare_within.df$binary_error %>% as.logical()
compare_within.df$training <- compare_within.df$training %>% as.logical

#join with chart_dims
compare_within.df <- inner_join(compare_within.df,chart_dims.df,by='user_id')

#corrected normalized error
compare_within.df <- inner_join(compare_within.df, quant_domains.df, by = c("representation", "granularity", "datatype", "index"))
compare_within.df$datatype <- compare_within.df$datatype %>% as.factor()
compare_within.df$corrected_normalized_error <- compare_within.df$quant_error / compare_within.df$max_error

# #corrected normalized error
# compare_within.df$corrected_normalized_error <- 0
# compare_within.df[compare_within.df$representation == 'linear',]$corrected_normalized_error <- compare_within.df[compare_within.df$representation == 'linear',]$quant_distance / compare_within.df[compare_within.df$representation == 'linear',]$chart_dim
# compare_within.df[compare_within.df$representation == 'radial',]$corrected_normalized_error <- compare_within.df[compare_within.df$representation == 'radial',]$quant_distance / (compare_within.df[compare_within.df$representation == 'radial',]$chart_dim * 0.5)

#subset to non-excluded participants
compare_within.df <- compare_within.df[!(compare_within.df$user_id %in% excluded_participants),]
compare_within.df$user_id <- factor(compare_within.df$user_id)

#subset to test_data
compare_within_test.df <- compare_within.df[compare_within.df$training == F,]

compare_within_outliers.df <- compare_within_test.df[compare_within_test.df$response_time > mean(compare_within_test.df$response_time) + 3 * sd(compare_within_test.df$response_time),]

#remove RT outliers (mean + 3 * SD)
compare_within_test.df <- compare_within_test.df[compare_within_test.df$response_time < mean(compare_within_test.df$response_time) + 3 * sd(compare_within_test.df$response_time),]

#response time data frame
compare_within_RT.df <- aggregate(log(compare_within_test.df$response_time/1000), list(compare_within_test.df$user_id,
                                                                                       compare_within_test.df$datatype,
                                                                                       compare_within_test.df$representation, 
                                                                                       compare_within_test.df$granularity), mean)

names(compare_within_RT.df) <- c("user_id","datatype","representation","granularity","response_time")

#error data frame
compare_within_err.df <- aggregate(abs(compare_within_test.df$corrected_normalized_error), list(compare_within_test.df$user_id,
                                                                                                compare_within_test.df$datatype,
                                                                                                compare_within_test.df$representation, 
                                                                                                compare_within_test.df$granularity), mean)

names(compare_within_err.df) <- c("user_id","datatype","representation","granularity","error")

compare_within_test.df <- compare_within_test.df[c('user_id','response_time','corrected_normalized_error','granularity','representation','datatype','binary_error','task_name','target_attribute')]
names(compare_within_test.df) <- c('user_id','response_time','error','granularity','representation','datatype','binary_error','task_name','target')
compare_within_test.df$binary_error <- as.numeric(compare_within_test.df$binary_error)
# 
# #plot all trials per participant
# plot_compare_within_RT_temperature <- ggplot(compare_within.df[compare_within.df$training == F & compare_within.df$datatype == 'temperature',], aes(y=granularity,x=response_time,color=binary_error,shape=target_attribute)) + geom_jitter(size=3,position=position_jitter(height = 0,width = 0)) + facet_grid(user_id ~ representation) +
#   geom_vline(aes(xintercept=mean(response_time)),show.legend = F,color="red") +
#   geom_vline(aes(xintercept=(mean(response_time) + 3 * sd(response_time))),show.legend = F,color="blue")
# plot_compare_within_RT_sleep <- ggplot(compare_within.df[compare_within.df$training == F & compare_within.df$datatype == 'sleep',], aes(y=granularity,x=response_time,color=binary_error,shape=target_attribute)) + geom_jitter(size=3,position=position_jitter(height = 0,width = 0)) + facet_grid(user_id ~ representation) +
#   geom_vline(aes(xintercept=mean(response_time)),show.legend = F,color="red") +
#   geom_vline(aes(xintercept=(mean(response_time) + 3 * sd(response_time))),show.legend = F,color="blue")
# plot_compare_within_err_temperature <- ggplot(compare_within.df[compare_within.df$training == F & compare_within.df$datatype == 'temperature',], aes(y=granularity,x=corrected_normalized_error,color=binary_error,shape=target_attribute)) + geom_jitter(size=3,position=position_jitter(height = 0,width = 0)) + facet_grid(user_id ~ representation) +
#   geom_vline(aes(xintercept=mean(corrected_normalized_error)),show.legend = F,color="red") +
#   geom_vline(aes(xintercept=(mean(corrected_normalized_error) + 3 * sd(corrected_normalized_error))),show.legend = F,color="blue")
# plot_compare_within_err_sleep <- ggplot(compare_within.df[compare_within.df$training == F & compare_within.df$datatype == 'sleep',], aes(y=granularity,x=corrected_normalized_error,color=binary_error,shape=target_attribute)) + geom_jitter(size=3,position=position_jitter(height = 0,width = 0)) + facet_grid(user_id ~ representation) +
#   geom_vline(aes(xintercept=mean(corrected_normalized_error)),show.legend = F,color="red") +
#   geom_vline(aes(xintercept=(mean(corrected_normalized_error) + 3 * sd(corrected_normalized_error))),show.legend = F,color="blue")
# 
# plot_compare_within_RT_hist <- ggplot(compare_within.df[compare_within.df$training == F,], aes(x = response_time)) + geom_histogram(binwidth = 500) + facet_grid(. ~ datatype) + 
#   geom_vline(aes(xintercept=mean(response_time)),show.legend = F,color="red") +
#   geom_vline(aes(xintercept=(mean(response_time) + 3 * sd(response_time))),show.legend = F,color="blue")
# plot_compare_within_err_hist <- ggplot(compare_within.df[compare_within.df$training == F,], aes(x = corrected_normalized_error)) + geom_histogram(binwidth = 0.025) + facet_grid(. ~ datatype) + 
#   geom_vline(aes(xintercept=mean(corrected_normalized_error)),show.legend = F,color="red") +
#   geom_vline(aes(xintercept=(mean(corrected_normalized_error)) + 3 * sd(corrected_normalized_error)),show.legend = F,color="blue")


#----------------------------------
# TASK: COMPARE BETWEEN
#---------------------------------

compare_between_data <- participant_data[grepl("task_name.*CompareBetween",participant_data[,1]),] %>% data.frame()

compare_between_data <- sapply(compare_between_data[,1],function(x){as.character(x)})
compare_between_data <- lapply(compare_between_data,function(x){fromJSON(x)})

#convert to proper names
compare_between_data <- lapply(compare_between_data,function(x){x[names(compare_between_data[[1]])]})

#attempt to re-order temp values
compare_between.df <- do.call(rbind,compare_between_data) %>% 
  apply(2,function(x){unlist(x)}) %>%
  as.data.frame(stringsAsFactors=F)

remove(compare_between_data)

# #numeric variables
compare_between.df$abs_diff_target_1 <- compare_between.df$abs_diff_target_1 %>% as.numeric()
compare_between.df$abs_diff_target_2 <- compare_between.df$abs_diff_target_2 %>% as.numeric()
compare_between.df$attempts <- compare_between.df$attempts %>% as.numeric()
compare_between.df$end_time <- compare_between.df$end_time %>% as.numeric()
compare_between.df$index <- compare_between.df$index %>% as.numeric()
compare_between.df$interruption_time <- compare_between.df$interruption_time %>% as.numeric()
compare_between.df$interruptions <- compare_between.df$interruptions %>% as.numeric()
compare_between.df$load_time <- compare_between.df$load_time %>% as.numeric()
compare_between.df$normalized_pixel_diff_target_1 <- compare_between.df$normalized_pixel_diff_target_1 %>% as.numeric()
compare_between.df$normalized_pixel_diff_target_2 <- compare_between.df$normalized_pixel_diff_target_2 %>% as.numeric()
compare_between.df$normalized_quant_distance <- compare_between.df$normalized_quant_distance %>% as.numeric()
compare_between.df$pixel_diff_target_1 <- compare_between.df$pixel_diff_target_1 %>% as.numeric()
compare_between.df$pixel_diff_target_2 <- compare_between.df$pixel_diff_target_2 %>% as.numeric()
compare_between.df$quant_distance <- compare_between.df$quant_distance %>% as.numeric()
compare_between.df$quant_error <- compare_between.df$quant_error %>% as.numeric()
compare_between.df$quant_error <- abs(compare_between.df$quant_error)
compare_between.df$reading_interruption_time <- compare_between.df$reading_interruption_time %>% as.numeric()
compare_between.df$reading_interruptions <- compare_between.df$reading_interruptions %>% as.numeric()
compare_between.df$reading_time <- compare_between.df$reading_time %>% as.numeric()
compare_between.df$response_time <- compare_between.df$response_time %>% as.numeric()
compare_between.df$start_time <- compare_between.df$start_time %>% as.numeric()
compare_between.df$target_1 <- compare_between.df$target_1 %>% as.numeric()
names(compare_between.df)[names(compare_between.df) == 'target_1'] <- 'day_index_1'
compare_between.df$target_2 <- compare_between.df$target_2 %>% as.numeric()
names(compare_between.df)[names(compare_between.df) == 'target_2'] <- 'day_index_2'

#categorical variables
compare_between.df$granularity <- compare_between.df$granularity %>% as.factor()
compare_between.df$granularity <- ordered(compare_between.df$granularity, levels = c("week", "month", "year"))
compare_between.df$representation <- compare_between.df$representation %>% as.factor()
compare_between.df$task_name <- compare_between.df$task_name %>% as.factor()
compare_between.df$response_value <- compare_between.df$response_value %>% as.factor()
compare_between.df$user_id <- compare_between.df$user_id %>% as.factor()
compare_between.df$year <- compare_between.df$year %>% as.factor()

#binary variables
compare_between.df$binary_error <- compare_between.df$binary_error %>% as.logical()
compare_between.df$training <- compare_between.df$training %>% as.logical()

#join with chart_dims
compare_between.df <- inner_join(compare_between.df,chart_dims.df,by='user_id')

#corrected normalized error
compare_between.df <- inner_join(compare_between.df, quant_domains.df, by = c("representation", "granularity", "datatype", "index"))
compare_between.df$datatype <- compare_between.df$datatype %>% as.factor()
compare_between.df$corrected_normalized_error <- compare_between.df$quant_error / compare_between.df$max_error

# compare_between.df$corrected_normalized_error <- 0
# compare_between.df[compare_between.df$representation == 'linear',]$corrected_normalized_error <- compare_between.df[compare_between.df$representation == 'linear',]$quant_distance / compare_between.df[compare_between.df$representation == 'linear',]$chart_dim
# compare_between.df[compare_between.df$representation == 'radial',]$corrected_normalized_error <- compare_between.df[compare_between.df$representation == 'radial',]$quant_distance / (compare_between.df[compare_between.df$representation == 'radial',]$chart_dim * 0.5)

#subset to non-excluded participants
compare_between.df <- compare_between.df[!(compare_between.df$user_id %in% excluded_participants),]
compare_between.df$user_id <- factor(compare_between.df$user_id)

#subset to test_data
compare_between_test.df <- compare_between.df[compare_between.df$training == F,]

compare_between_outliers.df <- compare_between_test.df[compare_between_test.df$response_time > mean(compare_between_test.df$response_time) + 3 * sd(compare_between_test.df$response_time),]

#remove RT outliers (mean + 3 * SD)
compare_between_test.df <- compare_between_test.df[compare_between_test.df$response_time < mean(compare_between_test.df$response_time) + 3 * sd(compare_between_test.df$response_time),]

#response time data frame
compare_between_RT.df <- aggregate(log(compare_between_test.df$response_time/1000), list(compare_between_test.df$user_id,
                                                                              compare_between_test.df$datatype,
                                                                              compare_between_test.df$representation, 
                                                                              compare_between_test.df$granularity), mean)

names(compare_between_RT.df) <- c("user_id","datatype","representation","granularity","response_time")

#error data frame
compare_between_err.df <- aggregate(abs(compare_between_test.df$corrected_normalized_error), list(compare_between_test.df$user_id,
                                                                                               compare_between_test.df$datatype,
                                                                                               compare_between_test.df$representation, 
                                                                                               compare_between_test.df$granularity), mean)

names(compare_between_err.df) <- c("user_id","datatype","representation","granularity","error")

compare_between_test.df <-compare_between_test.df[c('user_id','response_time','corrected_normalized_error','granularity','representation','datatype','binary_error','task_name')]
names(compare_between_test.df) <- c('user_id','response_time','error','granularity','representation','datatype','binary_error','task_name')
compare_between_test.df$target <- NA
compare_between_test.df$binary_error <- as.numeric(compare_between_test.df$binary_error)
# 
# #plot all trials per participant
# plot_compare_between_RT_temperature <- ggplot(compare_between.df[compare_between.df$training == F & compare_between.df$datatype == 'temperature',], aes(y=granularity,x=response_time,color=binary_error)) + geom_jitter(size=3,position=position_jitter(height = 0,width = 0)) + facet_grid(user_id ~ representation) +
#   geom_vline(aes(xintercept=mean(response_time)),show.legend = F,color="red") +
#   geom_vline(aes(xintercept=(mean(response_time) + 3 * sd(response_time))),show.legend = F,color="blue")
# plot_compare_between_RT_sleep <- ggplot(compare_between.df[compare_between.df$training == F & compare_between.df$datatype == 'sleep',], aes(y=granularity,x=response_time,color=binary_error)) + geom_jitter(size=3,position=position_jitter(height = 0,width = 0)) + facet_grid(user_id ~ representation) +
#   geom_vline(aes(xintercept=mean(response_time)),show.legend = F,color="red") +
#   geom_vline(aes(xintercept=(mean(response_time) + 3 * sd(response_time))),show.legend = F,color="blue")
# plot_compare_between_err_temperature <- ggplot(compare_between.df[compare_between.df$training == F & compare_between.df$datatype == 'temperature',], aes(y=granularity,x=corrected_normalized_error,color=binary_error)) + geom_jitter(size=3,position=position_jitter(height = 0,width = 0)) + facet_grid(user_id ~ representation) +
#   geom_vline(aes(xintercept=mean(corrected_normalized_error)),show.legend = F,color="red") +
#   geom_vline(aes(xintercept=(mean(corrected_normalized_error) + 3 * sd(corrected_normalized_error))),show.legend = F,color="blue")
# plot_compare_between_err_sleep <- ggplot(compare_between.df[compare_between.df$training == F & compare_between.df$datatype == 'sleep',], aes(y=granularity,x=corrected_normalized_error,color=binary_error)) + geom_jitter(size=3,position=position_jitter(height = 0,width = 0)) + facet_grid(user_id ~ representation) +
#   geom_vline(aes(xintercept=mean(corrected_normalized_error)),show.legend = F,color="red") +
#   geom_vline(aes(xintercept=(mean(corrected_normalized_error) + 3 * sd(corrected_normalized_error))),show.legend = F,color="blue")
# 
# plot_compare_between_RT_hist <- ggplot(compare_between.df[compare_between.df$training == F,], aes(x = response_time)) + geom_histogram(binwidth = 500) + facet_grid(. ~ datatype) + 
#   geom_vline(aes(xintercept=mean(response_time)),show.legend = F,color="red") +
#   geom_vline(aes(xintercept=(mean(response_time) + 3 * sd(response_time))),show.legend = F,color="blue")
# plot_compare_between_err_hist <- ggplot(compare_between.df[compare_between.df$training == F,], aes(x = corrected_normalized_error)) + geom_histogram(binwidth = 0.025) + facet_grid(. ~ datatype) + 
#   geom_vline(aes(xintercept=mean(corrected_normalized_error)),show.legend = F,color="red") +
#   geom_vline(aes(xintercept=(mean(corrected_normalized_error)) + 3 * sd(corrected_normalized_error)),show.legend = F,color="blue")


#----------------------------------
# PREFERENCE
#---------------------------------

preference_data <- participant_data[grepl("Preference",participant_data[,1]),] %>% data.frame()

preference_data <- sapply(preference_data[,1],function(x){as.character(x)})
preference_data <- lapply(preference_data,function(x){fromJSON(x)})

#convert to proper names
preference_data <- lapply(preference_data,function(x){x[names(preference_data[[1]])]})

#attempt to re-order temp values
preference.df <- do.call(rbind,preference_data) %>% 
  apply(2,function(x){unlist(x)}) %>%
  as.data.frame(stringsAsFactors=F)

remove(preference_data)

#numeric variables
preference.df$TimeStamp <- preference.df$TimeStamp %>% as.numeric()

# #categorical variables
preference.df$Event <- preference.df$Event %>% as.factor()
preference.df$granularity <- preference.df$granularity %>% as.factor()
preference.df$granularity <- ordered(preference.df$granularity, levels = c("week", "month", "year"))
preference.df$Question <- preference.df$Question %>% as.factor()
preference.df$representation <- preference.df$representation %>% as.factor()
preference.df$user_id <- preference.df$user_id %>% as.factor()

preference.df <- preference.df[!(preference.df$user_id %in% excluded_participants),]
preference.df$user_id <- factor(preference.df$user_id)

# plot_preferences <- ggplot(preference.df, aes(granularity)) +
#   geom_bar(aes(fill = representation), position = "dodge", stat="count")

#----------------------------------
# CONFIDENCE
#---------------------------------

confidence_data <- participant_data[grepl("Confidence",participant_data[,1]),] %>% data.frame()

confidence_data <- sapply(confidence_data[,1],function(x){as.character(x)})
confidence_data <- lapply(confidence_data,function(x){fromJSON(x)})

#convert to proper names
confidence_data <- lapply(confidence_data,function(x){x[names(confidence_data[[1]])]})

#attempt to re-order temp values
confidence.df <- do.call(rbind,confidence_data) %>% 
  apply(2,function(x){unlist(x)}) %>%
  as.data.frame(stringsAsFactors=F)

remove(confidence_data)

#numeric variables
confidence.df$TimeStamp <- confidence.df$TimeStamp %>% as.numeric()
confidence.df$Response <- confidence.df$Response %>% as.numeric()

# #categorical variables
confidence.df$Event <- confidence.df$Event %>% as.factor()
confidence.df$granularity <- confidence.df$granularity %>% as.factor()
confidence.df$granularity <- ordered(confidence.df$granularity, levels = c("week", "month", "year"))
confidence.df$Question <- confidence.df$Question %>% as.factor()
confidence.df$representation <- confidence.df$representation %>% as.factor()
confidence.df$user_id <- confidence.df$user_id %>% as.factor()

confidence.df <- confidence.df[!(confidence.df$user_id %in% excluded_participants),]
confidence.df$user_id <- factor(confidence.df$user_id)

# plot_confidence <- ggplot(confidence.df, aes(x=granularity,y=Response)) + 
#   geom_violin() + 
#   facet_wrap(~ representation)

remove(chart_dims.df)
