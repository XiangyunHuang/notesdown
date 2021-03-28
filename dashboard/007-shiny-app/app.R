
library(shiny)
library(reactable)
library(KernSmooth)
library(magrittr)

ui <- fluidPage(
  titlePanel("老忠实间歇泉喷发规律"),

  sidebarLayout(
    sidebarPanel(
      sliderInput("x_bins",
        "水平方向的窗宽:",
        min = 0,
        max = 1,
        value = 0.7
      ),
      sliderInput("y_bins",
        "垂直方向的窗宽:",
        min = 1,
        max = 10,
        value = 7
      )
    ),
    mainPanel(
      plotly::plotlyOutput("heatmap")
    )
  )
)


server <- function(input, output) {
  output$heatmap <- plotly::renderPlotly({
    den <- bkde2D(x = faithful, bandwidth = c(input$x_bins, input$y_bins))

    plotly::plot_ly(x = den$x1, y = den$x2, z = den$fhat) %>%
      plotly::add_heatmap() %>%
      plotly::layout(
        xaxis = list(showgrid = F, title = "喷发时间（分钟）"),
        yaxis = list(showgrid = F, title = "等待时间（分钟）")
      ) %>%
      plotly::config(displayModeBar = FALSE)
  })
}


shinyApp(ui = ui, server = server)
