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
          layout(barmode = 'stack')
      })
      
      #frequent trips
      output$frequentTrips <- renderTable({
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
      pieModeOfTransport = table(data()$ModeOfTransport) 
      pie_labels <- paste0(names(pieModeOfTransport), ": ", round(100 * pieModeOfTransport/sum(pieModeOfTransport), 2), "% (", pieModeOfTransport, ")")
      output$modesofTransportPie <- renderPlot({pie(pieModeOfTransport, labels=pie_labels)})
      
    }
  )
  
  
  
}