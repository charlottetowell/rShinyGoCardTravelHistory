library(plotly)

myUR <- fluidPage(
  
  title = "Go Card Travel History",
  
  fluidRow( #top/banner row
    column(
      8,
      fileInput("inputFile", "Upload travel history csv", accept = ".csv"),
    ),
    column(
      4,
      actionButton(
        inputId = "submit_file",
        label = "Submit"
      )
    )
  ),
  fluidRow( #entire body
    column(8, #left side
           fluidRow(
             #trips per week bar chart
             plotlyOutput("tripsPerWeek")
           ),
           fluidRow(
             column(9,
                    #frequent trips table
                    tableOutput("frequentTrips")
             ),
             column(3,
                    #avg daily fare table (by day of week)
                    tableOutput("AvgDailyFare")
             )
           )
    ),
    
    column(4, #right side
           fluidRow(
             #modes of transport pie chart
             plotOutput("modesofTransportPie")
           ),
           fluidRow(
             #departure time by time of day
           )
    )
  )
  
)