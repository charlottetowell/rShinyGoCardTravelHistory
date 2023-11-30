library(plotly)

myUR <- fluidPage(
  
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
    column(
      8,
      fileInput("inputFile", "Upload travel history csv", accept = ".csv"),
    ),
    column(
      3,
      actionButton(
        inputId = "submit_file",
        label = "Submit"
      )
    )
  ),
  fluidRow( class = "body",
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