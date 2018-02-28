#helper functions for calculating and plotting CIs
source('plot_CIs.R')
source('plot_CIs_both_datatypes.R')
source('bootCIs.R')

#load data

datatype <- "temperature" 
print(paste("processing ",datatype," datatype",sep=""))

source('processLogCSVs.R', encoding = 'UTF-8')

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

# get the names of the variables in the global environment
globalVariables <- ls(envir=.GlobalEnv)

for(.name in globalVariables){
  x <- get(.name,envir=.GlobalEnv)
  
  if(inherits(x,'data.frame')){
    newName <- paste(datatype,"_",.name,sep = "")
    # bind the value x to the new name in the global environment
    assign(newName,x,envir=.GlobalEnv)
    # delete the binding to the old name in the global environment
    rm(list=.name,envir=.GlobalEnv)
  }
  else if(inherits(x,'gg')){
    newName <- paste(datatype,"_",.name,sep = "")
    # bind the value x to the new name in the global environment
    assign(newName,x,envir=.GlobalEnv)
    # delete the binding to the old name in the global environment
    rm(list=.name,envir=.GlobalEnv)
  }
  else {
    print(.name)
  }
}

newName <- paste(datatype,"_excluded_participants",sep = "")
assign(newName,excluded_participants,envir=.GlobalEnv)
rm(excluded_participants)

#repeat for second datatype
first_datatype <- datatype
datatype <- "sleep" 
print(paste("processing ",datatype," datatype",sep=""))

source('processLogCSVs.R', encoding = 'UTF-8')

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

# get the names of the variables in the global environment
remove(x)
globalVariables <- ls(envir=.GlobalEnv)
globalVariables <- globalVariables[!(grepl(first_datatype,globalVariables))]

for(.name in globalVariables){
  x <- get(.name,envir=.GlobalEnv)
  
  if(inherits(x,'data.frame')){
    newName <- paste(datatype,"_",.name,sep = "")
    # bind the value x to the new name in the global environment
    assign(newName,x,envir=.GlobalEnv)
    # delete the binding to the old name in the global environment
    rm(list=.name,envir=.GlobalEnv)
  }
  else if(inherits(x,'gg')){
    newName <- paste(datatype,"_",.name,sep = "")
    # bind the value x to the new name in the global environment
    assign(newName,x,envir=.GlobalEnv)
    # delete the binding to the old name in the global environment
    rm(list=.name,envir=.GlobalEnv)
  }
  else {
    print(.name)
  }
}

newName <- paste(datatype,"_excluded_participants",sep = "")
assign(newName,excluded_participants,envir=.GlobalEnv)
rm(excluded_participants)

source('plot_export_both_datatypes.R') #confidence by representation x granularity
