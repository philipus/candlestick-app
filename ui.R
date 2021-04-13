#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(plotly)
library(markdown)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Bullish & Baerish Engulf candelstik pattern for GAFAM stock in 2020 - today"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
       #sliderInput("bins",
      #             "Number of bins:",
      #             min = 1,
      #             max = 50,
      #             value = 30),
      selectInput("symbSelector", "Stock Symbol:", 
                   c("Amazon"="AMZN",
                     "Google"="GOOGL",
                     "Facebook"="FB",
                     "Microsoft"="MSFT",
                     "Apple"="AAPL")),
      selectInput("pattern", "candlestick Pattern:", 
                  c("Bullish Engulf"="bullish_engulf",
                    "Bearish Engulf"="bearish_engulf")
      )
      
    ),
  
    # Show a plot of the generated distribution
    mainPanel(
      tabsetPanel(
        tabPanel("Plot", plotlyOutput("candlePlot")), 
        tabPanel("Documentation", includeMarkdown("doc.md"))
      )
    )
  )
))
