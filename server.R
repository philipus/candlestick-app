library(shiny)
library(plotly)
library(tidyquant)
library(dplyr)
library(xts)
library(quantmod)
library(TTR)
source(file="LagFunctions.R")
source(file="CSPEngulfinger.R")
####
symb <-c("AMZN","GOOGL","FB","MSFT","AAPL")
patterns <- c("bullish_engulf","bearish_engulf")


getSymbols(symb, from = '2020-01-01',
           to = "2021-04-02",warnings = FALSE,
           auto.assign = TRUE)

###

shinyServer(function(input, output) {
  output$candlePlot <- renderPlotly({
    df <- data.frame(Date=index(eval(parse(text = input$symbSelector))),
                     coredata(eval(parse(text = input$symbSelector))))
    colnames(df) <- c("date", "open", "high", "low", "close", "volume", "adjusted")
    
    BullBear_Engulfing <- CSPEngulfinger(eval(parse(text = input$symbSelector)))
    
    annotations_bearish_engulf <- BullBear_Engulfing[BullBear_Engulfing$Bear.Engulfing]
    annotations_bearish_engulf <- data.frame(date=as.Date(rownames(as.data.frame(annotations_bearish_engulf)))) %>% 
      dplyr::mutate(txt = "bearish_engulf")
    annotations_bearish_engulf <- annotations_bearish_engulf %>% left_join(df)
    
    annotations_bullish_engulf <- BullBear_Engulfing[BullBear_Engulfing$Bull.Engulfing]
    annotations_bullish_engulf <- data.frame(date=as.Date(rownames(as.data.frame(annotations_bullish_engulf)))) %>% 
      dplyr::mutate(txt = "bullish_engulf")
    annotations_bullish_engulf <- annotations_bullish_engulf %>% left_join(df)
    ##
    fig <- df %>% plot_ly(x = ~date, type="candlestick",
                          open = ~open, close = ~close,
                          high = ~high, low = ~low)
    

    if( input$pattern == "bullish_engulf") {
      
      fig <- fig %>% add_annotations(x=annotations_bullish_engulf$date,y=annotations_bullish_engulf$high,
                                     text=annotations_bullish_engulf$txt) %>% 
        layout(title = "Basic Candlestick Chart with bullish engulfing pattern annotations",
               xaxis = list(rangeslider = list(visible = F)))
      
    } else {
      fig <- fig %>% add_annotations(x=annotations_bearish_engulf$date,y=annotations_bearish_engulf$high,
                                     text=annotations_bearish_engulf$txt) %>%
        layout(title = "Basic Candlestick Chart with bearish engulfing pattern annotations",
               xaxis = list(rangeslider = list(visible = F)))
    }
    
  })
})
