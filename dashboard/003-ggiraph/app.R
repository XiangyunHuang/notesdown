library(shiny)
library(ggplot2)
library(ggiraph)
library(shinythemes)

ui <- fluidPage( title = "interactive with iris data",
  titlePanel("Edgar Anderson 的鸢尾花数据"),
  theme = shinytheme("cerulean"),
  sidebarLayout(
    sidebarPanel(
      selectInput(
        inputId = "iris_x", label = "横坐标： ",
        choices = colnames(iris)[-5], selected = "Sepal.Length",
        multiple = FALSE
      ),
      selectInput(
        inputId = "iris_y", label = "纵坐标： ",
        choices = colnames(iris)[-5], selected = "Sepal.Width",
        multiple = FALSE
      )
    ),
    mainPanel(
      h2("ggiraph 图形"),
      girafeOutput("scatter_plot"),
      h2("Plotly 图形"),
      plotly::plotlyOutput(outputId = "scatter_plotly")
    ),
    position = "left"
  )
)

server <- function(input, output, session) {
  # 相互依赖的数据选择操作
  # https://stackoverflow.com/questions/34080629/dynamic-selectinput-in-r-shiny
  observe({
    choice_x <- setdiff(colnames(iris)[-5], input$iris_x)
    choice_y <- setdiff(colnames(iris)[-5], input$iris_y)

    updateSelectInput(session, "iris_x", choices = choice_y, selected = input$iris_x)
    updateSelectInput(session, "iris_y", choices = choice_x, selected = input$iris_y)
  })

  output$scatter_plot <- renderGirafe({
    # aes_string() equal to get()
    p <- ggplot(data = iris, aes_string(x = input$iris_x, y = input$iris_y)) +
      geom_point_interactive(aes(color = Species, tooltip = Species)) +
      labs(x = input$iris_x, y = input$iris_y) +
      theme_minimal()

    girafe(ggobj = p, width_svg = 6, height_svg = 4)
  })

  output$scatter_plotly <- plotly::renderPlotly({
    # aes_string() equal to get()
    p <- ggplot(data = iris, aes_string(x = input$iris_x, y = input$iris_y)) +
      geom_point(aes(color = Species)) +
      labs(x = input$iris_x, y = input$iris_y) +
      theme_minimal()

    plotly::ggplotly(p)
  })
}

# 执行
shinyApp(ui = ui, server = server)
