library(shiny)
library(shinydashboard)
library(bslib)
library(ggplot2)
library(DT)

load("movies.RData")  

ui <- dashboardPage(
    dashboardHeader(),
    dashboardSidebar(
        selectInput(
            inputId = "y",
            label = "Y-axis:",
            choices = c("imdb_rating", "imdb_num_votes", "critics_score", "audience_score", "runtime"),
            selected = "audience_score"
        ),
        selectInput(
            inputId = "x",
            label = "X-axis:",
            choices = c("imdb_rating", "imdb_num_votes", "critics_score", "audience_score", "runtime"),
            selected = "critics_score"
        ),
        sliderInput(
            inputId = "slider",
            label = "alpha",
            min = 10, max = 150,
            value = 75
        ),
        checkboxInput(
            inputId = "show_data",
            label = "Show data table", 
            value = TRUE
        )
    ),
    dashboardBody(
        fluidRow(
            box(
                plotOutput(outputId = "scatterplot")
            ),
            box(
                plotOutput(outputId = "densityplot")
            ),
            box(
                DT::dataTableOutput(outputId = "moviestable")
            )
        )
    )
)

server <- function(input, output, session) {

    output$scatterplot <- renderPlot({
        ggplot(data = movies, aes_string(x = input$x, y = input$y)) +
        geom_point(alpha = input$slider )
    })

    output$moviestable <- renderDataTable({
        if (input$show_data) {
            DT::datatable(
                data = movies %>% select(1:7),
                options = list(pageLength = 10),
                rownames = FALSE
            )
        }
    })

    output$densityplot <- renderPlot({
        ggplot(data = movies, aes_string(x = input$x)) +
        geom_density()
    })

}

shinyApp(ui, server)
