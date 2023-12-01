source("travel_history_dataframe.R")
library(stringr)
library(shiny)
library(dplyr)
library(lubridate)
library(plotly)

myserver <- function(input, output, session) {
  
  # process file
  filePath <- reactive({
    req(input$inputFile)
    input$inputFile$datapath
  })
  
  data <- reactiveVal()
  
  observeEvent(
    eventExpr = input[["submit_file"]],
    handlerExpr = {
      data(travel_history_dataframe(filePath()))
      
      #trips per week
      tripsperweek <- data() %>%
        group_by(WeekEnding, WeekEnd) %>%
        summarize(
          numTrips = n_distinct(index)
        )
      output$tripsPerWeek <- renderPlotly({
        plot_ly(tripsperweek,
                x = ~WeekEnding,
                y = ~numTrips,
                color = ~WeekEnd,
                type = 'bar') %>% 
          layout(barmode = 'stack',
                 height = input$dimension[2]*0.4,
                 paper_bgcolor='rgba(0,0,0,0)',
                 plot_bgcolor='rgba(0,0,0,0)',
                 title="Trips per week",
                 xaxis = list(title = ""),
                 yaxis = list(title = ""))
      })
      
      #frequent trips
      output$frequentTrips <- renderDataTable({
        data() %>%
          group_by(From, To) %>% 
          summarize(
            numTrips = n_distinct(index)
            ,ModeOfTransport = first(ModeOfTransport)
            ,AvgTripDuration = round(mean(TripDuration), 2)
          ) %>%
          arrange(desc(numTrips)) 
      })
      
      
      # Avg Fares by Day Of Week
      output$AvgDailyFare <- renderTable({
        avgFar <- data() %>%
          group_by(Date) %>% 
          summarize(
            DayOfWeek = first(DayOfWeek)
            ,DayOfWeekNum = first(DayOfWeekNum)
            ,TotalDailyFare = sum(Fare)
          ) %>%
          group_by(DayOfWeek) %>%
          summarize(
            AvgDailyFare = mean(TotalDailyFare)
            ,DayOfWeekNum = first(DayOfWeekNum)
          ) %>%
          arrange(DayOfWeekNum)
        
        avgFar %>% select(DayOfWeek, AvgDailyFare)
      })
      
      #modes of transport pie chart
      pieModeOfTransport = data() %>% 
        group_by(ModeOfTransport) %>%
        summarize(
          numTrips = n_distinct(index)
        )
      output$modesofTransportPie <- renderPlotly({
        plot_ly(pieModeOfTransport,
                labels = ~ModeOfTransport,
                values = ~numTrips,
                type = 'pie') %>%
          layout(
            height = input$dimension[2]*0.3,
            paper_bgcolor='rgba(0,0,0,0)',
            plot_bgcolor='rgba(0,0,0,0)',
            title="Trips by Mode of Transport"
          )
        })
      
    }
  )
  
  
  
}