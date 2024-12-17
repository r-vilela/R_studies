library(shiny)
library(shinydashboard)
library(maps)
library(mapproj)

source("helpers.R")

counties <- readRDS("data/counties.rds")


ui <- dashboardPage(
    dashboardHeader(title = "Basic dashboard"),
    dashboardSidebar(
        sidebarMenu(
            menuItem("Dashboard", tabName="dashboard", icon=icon("dashboard")),
            menuItem("Widgets", tabName="widgets", icon=icon("th"))
        )
    ),
    dashboardBody(
        tabItems(

            tabItem(
                tabName = "dashboard",
                fluidRow(
                    valueBox(
                        10 * 2,
                        "New Orders",
                        icon = icon("credit-card"),
                        width="2"
                    ),

                    valueBoxOutput("progressBoxValue", width="2"),

                    valueBoxOutput("approvalBoxValue", width="2"),

                    box(
                        infoBox("New Orders", 10*2, icon=icon("credit-card")),
                        infoBoxOutput("progressBox"),
                        infoBoxOutput("approvalBox")
                    ),
                    box(
                        title="Histogram",
                        background="maroon",
                        solidHeader=TRUE,
                        plotOutput("plot1", height = 250)
                    ),

                    box(
                        title="Controls",
                        background="navy",
                        solidHeader=TRUE,
                        "Box content here", br(), "More box content",
                        sliderInput("slider", "Number of observations:", 1, 100, 50)
                    ),
                    box(
                        title="Map",
                        background="navy",
                        width=12,                        
                        #percent_map(counties$white, "darkgreen", "% White")
                    )
                )
            ),
            tabItem(
                tabName = "widgets",
                h2("Widgets tab content")
            )
        )

    )
)

server <- function(input, output) {
    output$progressBoxValue <- renderValueBox({
        valueBox(
            paste0(25 , "%"), 
            "Progress", 
            icon=icon("list"),
            color="purple"
        )
    })

    output$approvalBoxValue <- renderValueBox({
        valueBox(
            "80%", "Approval", icon=icon("list"),
            color="yellow"
        )
    })
    
    output$progressBox <- renderInfoBox({
        infoBox(
            "Progress", paste0(25 , "%"), icon=icon("list"),
            color="purple"
        )
    })

    output$approvalBox <- renderInfoBox({
        infoBox(
            "Approval", "80%", icon=icon("thumbs-up", lib="glyphicon"),
            color="yellow"
        )
    })

    set.seed(122)
    histdata <- rnorm(500)

    output$plot1 <- renderPlot({
        data <- histdata[seq_len(input$slider)]
        hist(data)
    })
}

shinyApp(ui, server)