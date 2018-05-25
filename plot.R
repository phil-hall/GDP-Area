source("processData.R")

library(plotly)

totalLine <- plot_ly(data, x = ~data$Date, y = ~data$GDPArea, name = 'GDP per acre', type = 'scatter', mode = 'lines')

Trend5yr$val <- "neg"
Trend5yr$val[Trend5yr$GDPAreaQ >= 0] <- "pos"

Bars <- plot_ly() %>% 
  add_bars(data = Trend5yr, x = ~Date, y = ~GDPAreaQ, color = ~val, colors = c("red","blue")) %>%
  layout(showlegend = FALSE, xaxis = list(dtick = 0.25))

Bars

totalLine

postCrash <- plot_ly(sinceCrash, x = ~Date, y = ~GDPArea, name = 'GDP per acre', type = 'scatter', mode = 'lines')

upturn <- min(sinceCrash[sinceCrash$GDPAreaQ > 0 & sinceCrash$Date != peak,"Date"])
drop <- max(sinceCrash[sinceCrash$Date < upturn,"GDPArea"]) - min(sinceCrash[sinceCrash$Date < upturn,"GDPArea"]) 

sinceCrash$recovery <- sinceCrash$GDPArea - min(sinceCrash[sinceCrash$Date < upturn,"GDPArea"])
sinceCrash$recovery_perc <- sinceCrash$recovery / drop * 100

crashTrend <- plot_ly(sinceCrash, x = ~Date, y = ~GDPAreaY, type = 'scatter', mode = 'lines')
crashTrend