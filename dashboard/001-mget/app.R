library(shiny)
library(data.table)
library(magrittr)
library(reactable)

options(reactable.language = reactableLang(
  pageSizeOptions = "\u663e\u793a {rows}",
  pageInfo = "{rowStart} \u81f3 {rowEnd} \u9879\u7ed3\u679c,\u5171 {rows} \u9879",
  pagePrevious = "\u4e0a\u9875",
  pageNext = "\u4e0b\u9875"
))

orange_pal <- function(x) rgb(colorRamp(c("#ffe4cc", "#ffb54d"))(x), maxColorValue = 255)

ui <- fluidPage(
  fluidRow(
    column(
      12,
      selectInput("input_vars",
        label = "变量",
        choices = c(agegp = "agegp", alcgp = "alcgp", tobgp = "tobgp"),
        selected = "agegp",
        multiple = TRUE
      ),
      reactableOutput("output_table")
    )
  )
)


esoph <- as.data.table(esoph)

server <- function(input, output, session) {
  output$output_table <- renderReactable({
    req(input$input_vars)
    esoph[, .(ncases = sum(ncases), ncontrols = sum(ncontrols), rate = sum(ncases) / sum(ncases + ncontrols)), by = mget(input$input_vars)] %>%
      reactable(
        filterable = TRUE, # 过滤
        searchable = TRUE, # 搜索
        showPageSizeOptions = TRUE, # 页面大小
        pageSizeOptions = c(5, 10, 15), # 页面大小可选项
        defaultPageSize = 10, # 默认显示10行
        highlight = TRUE, # 高亮选择
        striped = TRUE, # 隔行高亮
        bordered = TRUE,
        fullWidth = FALSE, # 默认不要全宽填充，适应数据框的宽度
        columns = list(
          rate = colDef(format = colFormat(percent = TRUE, digits = 2)), # 指标 rate 以保留两位小数的百分比方式展示
          agegp = colDef(footer = "总计"),
          ncases = colDef(
            footer = JS("function(colInfo) {
                var values = colInfo.data.map(function(row) { return row[colInfo.column.id] })
                var total = values.reduce(function(a, b) { return a + b }, 0)
                return total.toFixed(0)
              }")
          ),
          ncontrols = colDef(
            footer = JS("function(colInfo) {
                var values = colInfo.data.map(function(row) { return row[colInfo.column.id] })
                var total = values.reduce(function(a, b) { return a + b }, 0)
                return total.toFixed(0)
              }")
          )
        )
      )
  })
}

shinyApp(ui = ui, server = server)
