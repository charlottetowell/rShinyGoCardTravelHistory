library(shiny)

server = function(input, output){    
  
  # server code
}

ui = fluidPage(
  
  fluidRow( class="top banner row",
            column(
              8,
              wellPanel(p("File Input")),
            ),
            column(
              3,
              wellPanel(p("Submit Button"))
            )
  ),
  fluidRow( class = "body",
            column(8, #left side
                   fluidRow(
                     #trips per week bar chart
                     wellPanel(p("Trips per week"))
                   ),
                   fluidRow(
                     column(9,
                            #frequent trips table
                            wellPanel(p("Frequent Trips Table"))
                     ),
                     column(3,
                            #avg daily fare table (by day of week)
                            wellPanel(p("Avg Daily Fare"))
                     )
                   )
            ),
            
            column(4, #right side
                   fluidRow(
                     #modes of transport pie chart
                     wellPanel(p("Modes of Transport pie"))
                   ),
                   fluidRow(
                     #modes of transport pie chart table
                     wellPanel(p("Modes of Transport table"))
                   ),
                   fluidRow(
                     #departure time by time of day
                     wellPanel(p("Departure by time of day"))
                   )
            )
  )
)

shinyApp(ui = ui, server = server)