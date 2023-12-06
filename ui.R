library(plotly)
library(DT)

myUI <- fluidPage(
  style = "background-color: #F9F6EE;",
  
  title = "Go Card Travel History",
  
  #to get window size
  tags$head(tags$script('
                                var dimension = [0, 0];
                                $(document).on("shiny:connected", function(e) {
                                    dimension[0] = window.innerWidth;
                                    dimension[1] = window.innerHeight;
                                    Shiny.onInputChange("dimension", dimension);
                                });
                                $(window).resize(function(e) {
                                    dimension[0] = window.innerWidth;
                                    dimension[1] = window.innerHeight;
                                    Shiny.onInputChange("dimension", dimension);
                                });
                            ')),
  
  fluidRow( #header row
          style = "background-color:white;",
    column(6,
    div(style = "height:10vh;",
    h2("Go Card Travel History", align = "left"))
    ),
    column(4,
    div(style = "height:10vh;",
    fileInput("inputFile", "Upload travel history csv", accept = ".csv"))
    ),
    column(2,
    div(style = "height:10vh;",
    actionButton(
      inputId = "submit_file",
      label = "Submit")
    ))
  ),
  fluidRow(class = "spacer", div(style = "height:1vh;")),
  fluidRow( #body
    column(style='border-left: 10px solid #F9F6EE; border-right: 5px solid #F9F6EE;',
           8, #left side
           div(style = "height:45vh;",
           fluidRow(
             h6("Trips per week", align = 'Center'),
             style = "background-color:white;"
           ),
           fluidRow(
             #trips per week bar chart
             plotlyOutput("tripsPerWeek"))
           ),
           fluidRow(
             column(style='border-right: 5px solid #F9F6EE;',
                    9,
                    div(style="height=44vh",
                    #frequent trips table
                    fluidRow(
                      h6("Frequent Trips", align = 'Center'),
                      style = "background-color:white;"
                    ),
                    DT::dataTableOutput("frequentTrips", height = "44vh"),
                    style = "overflow-y: scroll;overflow-x: scroll;font-size:60%;",
                    options = list(paging=F)
             )),
             column(style='border-left: 5px solid #F9F6EE;',
                    3,
                    #avg daily fare table (by day of week)
                    fluidRow(
                      h6("Avg. Daily Fare", align = 'Center'),
                      style = "background-color:white;"
                    ),
                    fluidRow(
                    tableOutput("AvgDailyFare"))
             )
           )
    ),
    
    column(style='border-right: 10px solid #F9F6EE; border-left: 5px solid #F9F6EE;',
           4, #right side
           fluidRow(
             h6("Modes of Transport", align = 'Center'),
             style = "background-color:white;"
           ),
           fluidRow(
             #modes of transport pie chart
             style='height:30vh',
             plotlyOutput("modesofTransportPie")
           ),
           fluidRow(
             h6("Departure Times Frequency", align = 'Center'),
             style = "background-color:white;"
           ),
           fluidRow(
             #departure time by time of day
           )
    )
  )
  
)