library(jsonlite)
library(httr)

getONSData <- function(dataset,series) {

  url  <- "https://api.ons.gov.uk"
  path <- paste0("dataset/",dataset,"/timeseries/",series,"/data")
  
  raw.result <- GET(url = url, path = path)
  raw.content <- rawToChar(raw.result$content)
  content <- fromJSON(raw.content)
  
  data <- as.data.frame(content$quarters)
  
  keep <- c("label","year","quarter","value")
  
  data <- data[keep]
  
  return(data)

}