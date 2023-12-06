library(plotly)
library(DT)

myUI <- fluidPage(
  bootstrap = TRUE,
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
  
  fluidRow( class="top banner row",
          style = "background-color:white;",
    column(6,
    h2("Go Card Travel History", align = "left")),
    column(4,
    fileInput("inputFile", "Upload travel history csv", accept = ".csv")),
    column(2,
    actionButton(
      inputId = "submit_file",
      label = "Submit"
    ))
  ),
  fluidRow(class = "spacer", HTML("<br>")),
  fluidRow( class = "body",
    column(style='border-left: 10px solid #F9F6EE; border-right: 5px solid #F9F6EE;',
           8, #left side
           fluidRow(
             h6("Trips per week", align = 'Center'),
             style = "background-color:white;"
           ),
           fluidRow(
             #trips per week bar chart
             style='height:40vh',
             plotlyOutput("tripsPerWeek")
           ),
           fluidRow(
             column(style='border-right: 5px solid #F9F6EE;',
                    9,
                    #frequent trips table
                    fluidRow(
                      h6("Frequent Trips", align = 'Center'),
                      style = "background-color:white;"
                    ),
                    DT::dataTableOutput("frequentTrips"),style = "overflow-y: scroll;overflow-x: scroll;font-size:80%"
             ),
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