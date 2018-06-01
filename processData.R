source("getData.R")

library(zoo)
library(data.table)

GDPCap <- getONSData("PN2","IHXW")
GDP <- getONSData("PN2","ABMI")

data <- merge(GDPCap,GDP[c("label","value")],by="label")

names(data) <- c("Date","Year","Quarter","GDPCap","GDP")

data$GDPCap <- as.numeric(data$GDPCap)
data$GDP <- as.numeric(data$GDP)
data$Year <- as.numeric(data$Year)

data$Date <- as.yearqtr(data$Date)

data$GDPArea <- data$GDP / (data$GDP / data$GDPCap)^2

data$lastYear <- data$Date - 1
data$lastQuarter <- data$Date - 1/4

timeShift <- function(data,match) {

  varlist <- c("GDPCap","GDP","GDPArea")

  data <- merge(data,data[c("Date",varlist)],by.x = match, by.y = "Date")

  setnames(data,paste0(varlist,".x"),varlist)
  setnames(data,paste0(varlist,".y"),paste0(varlist,"_",match))
  
  return(data)
  
}

data <- timeShift(data,"lastYear")
data <- timeShift(data,"lastQuarter")

data$GDPAreaY <- (data$GDPArea / data$GDPArea_lastYear - 1) * 100
data$GDPAreaQ <- (data$GDPArea / data$GDPArea_lastQuarter - 1) * 100

shortTrend <- data[data$Date >= max(data$Date) - 2.5,]

peak <- data[data$GDPArea == max(data$GDPArea),"Date"]

sinceCrash <- data[data$Date >= peak,]
