library(plotly)
library(DT)

myUR <- fluidPage(
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
    column(8, #left side
           fluidRow(
             #trips per week bar chart
             style='height:40vh',
             plotlyOutput("tripsPerWeek")
           ),
           fluidRow(
             column(9,
                    #frequent trips table
                    DT::dataTableOutput("frequentTrips"),style = "height:500px; overflow-y: scroll;overflow-x: scroll;"
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
             style='height:30vh',
             plotlyOutput("modesofTransportPie")
           ),
           fluidRow(
             #departure time by time of day
           )
    )
  )
  
)