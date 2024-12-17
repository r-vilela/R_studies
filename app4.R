library(shiny)
library(bslib)
library(ggplot2)

load("movies.RData")

ui <- page_fluid(

  textInput(
    inputId = "custom_text",
    label = "Input some text here: "
  ),

  strong("Text is shown below:"),

  textOutput(outputId = "user_text")

)

server <- function(input, output, sessino) {
    output$user_text <- renderText({ input$custom_text })
}

shinyApp(ui, server)