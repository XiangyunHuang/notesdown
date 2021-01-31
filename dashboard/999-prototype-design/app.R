
library(shiny)
library(ggplot2)
library(magrittr)
# library(DT) # 与 shiny 提供的 dataTableOutput, renderDataTable 冲突，故而从命名空间导入
library(plotly)

set.seed(2020)
dat <- data.frame(dt = seq(from = as.Date("2020-01-01"), to = Sys.Date(), by = "day")) %>%
  transform(search_qv = sample(100000:1000000, size = nrow(.), replace = T)) %>%
  transform(search_uv = sample(10000:100000, size = nrow(.), replace = T)) %>%
  transform(click_qv = sapply(search_qv, rbinom, n = 1, prob = 0.2)) %>%
  transform(click_uv = sapply(search_uv, rbinom, n = 1, prob = 0.4)) %>%
  transform(qv_ctr = click_qv / search_qv) %>%
  transform(uv_ctr = click_uv / search_uv)

options(DT.options = list(
  language = list(url = "//cdn.datatables.net/plug-ins/1.10.11/i18n/Chinese.json"),
  paging = T,
  dom = "Bfrtip",
  buttons = c("copy", "excel", "print"), # 复制、导出和打印
  autoWidth = TRUE # 自动页面宽度
))

ui <- fluidPage(
  titlePanel("产品设计"),
  column(
    width = 6,
    dateRangeInput("date_range", "日期范围",
      start = Sys.Date() - 30,
      end = Sys.Date(),
      min = "2020-01-01",
      max = Sys.Date()
    )
  ),
  column(
    width = 6,
    selectInput("idx", "指标范围",
      selected = c("搜索 QV", "点击 QV", "QV_CTR"), multiple = TRUE,
      choices = c("搜索 QV", "点击 QV", "QV_CTR", "搜索 UV", "点击 UV", "UV_CTR"), selectize = TRUE
    )
  ),
  column(
    width = 12,
    plotlyOutput("multiple_axes")
  ),
  column(
    width = 12,
    DT::dataTableOutput("tmp_table")
  )
)

server <- function(input, output) {
  # 输入指标
  datasetInput <- reactive({
    if (is.null(input$idx)) {
      c("搜索 QV" = "search_qv", "点击 QV" = "click_qv", "QV_CTR" = "qv_ctr")
    } else {
      c("搜索 QV" = "search_qv", "点击 QV" = "click_qv", "QV_CTR" = "qv_ctr",
        "搜索 UV" = "search_uv", "点击 UV" = "click_uv", "UV_CTR" = "uv_ctr" )[input$idx]
    }
  })

  get_data <- reactive({
    data <- subset(dat, subset = dt >= input$date_range[1] & dt <= input$date_range[2], select = c("dt", datasetInput()))
    data
  })

  # 根据选择的指标决定，批量绘制条形图、曲线图
  # 数据结构上，指标作为一列，指标是绝对数还是占比

  output$multiple_axes <- renderPlotly({
    # 双轴图
    tmp = get_data()
    plot_ly(data = tmp) %>%
      add_bars(
        x = ~dt, y = ~search_qv, name = "搜索 QV",
        text = ~ paste("搜索 QV：", format(search_qv, big.mark = ","), "<br>",
                       "点击 QV：", format(click_qv, big.mark = ","), "<br>",
                       "QV_CTR：", round(100*qv_ctr, 2), "%"),
        hoverinfo = "text"
      ) %>%
      add_bars(
        x = ~dt, y = ~click_qv, name = "点击 QV", visible = "legendonly",
        text = ~ paste("搜索 QV：", format(search_qv, big.mark = ","), "<br>",
                       "点击 QV：", format(click_qv, big.mark = ","), "<br>",
                       "QV_CTR：", round(100 * qv_ctr, 2), "%"),
        hoverinfo = "text"
      ) %>%
      # add_bars(
      #   x = ~dt, y = ~search_uv, name = "搜索 UV", visible = "legendonly",
      #   text = ~ paste("搜索 QV：", format(search_qv, big.mark = ","), "<br>",
      #                  "点击 QV：", format(click_qv, big.mark = ","), "<br>",
      #                  "QV_CTR：", round(100 * qv_ctr, 2), "%"),
      #   hoverinfo = "text"
      # ) %>%
      # add_bars(
      #   x = ~dt, y = ~click_uv, name = "点击 UV", visible = "legendonly",
      #   text = ~ paste("搜索 QV：", format(search_qv, big.mark = ","), "<br>",
      #                  "点击 QV：", format(click_qv, big.mark = ","), "<br>",
      #                  "QV_CTR：", round(100 * qv_ctr, 2), "%"),
      #   hoverinfo = "text"
      # ) %>%
      add_lines(
        x = ~dt, y = ~100 *qv_ctr, name = "QV_CTR（%）", yaxis = "y2",
        text = ~ paste("搜索 QV：", format(search_qv, big.mark = ","), "<br>",
                       "点击 QV：", format(click_qv, big.mark = ","), "<br>",
                       "QV_CTR：", round(100 * qv_ctr, 2), "%"),
        hoverinfo = "text",
        line = list(shape = "spline", width = 1.5, dash = "line")
      ) %>%
      # add_lines(
      #   x = ~dt, y = ~100 *uv_ctr, name = "UV_CTR（%）", yaxis = "y2",
      #   text = ~ paste("搜索 QV：", format(search_qv, big.mark = ","), "<br>",
      #                  "点击 QV：", format(click_qv, big.mark = ","), "<br>",
      #                  "QV_CTR：", round(100 * qv_ctr, 2), "%"),
      #   hoverinfo = "text",
      #   line = list(shape = "spline", width = 1.5, dash = "line")
      # ) %>%
      layout(
        title = "",
        yaxis2 = list(
          tickfont = list(color = "black"),
          overlaying = "y",
          side = "right",
          title = "",
          showgrid = F, automargin = TRUE
        ),
        xaxis = list(title = "", showgrid = F, showline = F),
        yaxis = list(title = "", showgrid = F, showline = F),
        margin = list(r = 20, autoexpand = T),
        legend = list(
          x = 0, y = 1, orientation = "h"
        )
      ) %>%
      config(displayModeBar = F)
  })

  output$tmp_table <- DT::renderDataTable(
    {
      tmp_data <- get_data()
      # 最近的日期显示在前面
      tmp_data <- tmp_data[order(tmp_data$dt, decreasing = TRUE), ]
      DT::datatable(tmp_data, rownames = FALSE, colnames = c("日期", input$idx),
                    extensions = c("Buttons")) %>%
        DT::formatPercentage(grepl("*_ctr$", colnames(tmp_data)), 2)
    },
    server = TRUE
  )
}

# 运行应用
shinyApp(ui = ui, server = server)
