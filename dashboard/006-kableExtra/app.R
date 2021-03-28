library(shiny)

ui <- fluidPage(
  titlePanel("mtcars"),
  sidebarLayout(
    sidebarPanel(
      sliderInput("mpg", "mpg Limit",
        min = 11, max = 33, value = 20
      )
    ),
    mainPanel(
      tableOutput("mtcars_kable")
    )
  )
)

server <- function(input, output) {
  library(kableExtra)
  output$mtcars_kable <- function() {
    req(input$mpg)
    mtcars %>%
      subset(mpg <= input$mpg) %>%
      knitr::kable("html") %>%
      kable_styling("striped", full_width = F) %>%
      add_header_above(c(" ", "Group 1" = 5, "Group 2" = 6))
  }
}

# Run the application
shinyApp(ui = ui, server = server)
