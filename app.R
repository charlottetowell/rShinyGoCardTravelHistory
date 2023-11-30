library(shiny)
source('ui.R', local = TRUE)
source('server.R')


shinyApp(
  ui = myUI,
  server = myserver
)