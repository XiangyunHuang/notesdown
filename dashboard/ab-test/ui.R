
library(shiny)

shinyUI(fluidPage(

  titlePanel(title = "A/B 测试工具"),
  tabsetPanel(
    tabPanel(
      title = "样本量预估",
      br(),
      sidebarLayout(
        sidebarPanel = sidebarPanel(
          numericInput("raw_rate", "原始转化率(%)", 2, min = 0, max = 100),
          numericInput("opt_rate", "优化后转化率(%)", 2.5, min = 0, max = 100),
          sliderInput("sig", "显著性", 95, min = 0, max = 100, post = "%"),
          p("0% ~ 90%：没有显著差异"),
          p("90% ~ 95%：显著差异存疑问"),
          p("95% ~ 100%：有显著差异"),
          sliderInput("power", "效能,一般不需要调整", 80, min = 0, max = 100, post = "%"),
          p("0% ~ 80%：可信度较差"),
          p("80% ~ 100%：可信度较高")
        ),
        mainPanel = mainPanel(
          h3("每组所需的样本量为"),
          h4(textOutput("sample_size"), style = "color:blue"),
          h3("计算结果"),
          verbatimTextOutput("result")
        )
      )
    ),
    tabPanel(
      title = "结果分析",
      br(),
      sidebarLayout(
        sidebarPanel = sidebarPanel(
          numericInput("total_A", "对照组总样本量(对照组为原始实验)", 1000, min = 0),
          numericInput("pos_A", "对照组转化样本量", 40, min = 0),
          numericInput("total_B", "测试组总样本量(测试组为新实验)", 1000, min = 0),
          numericInput("pos_B", "测试组转化样本量", 50, min = 0)
        ),
        mainPanel = mainPanel(
          h3("计算结果"),
          tableOutput("ab_table"),
          uiOutput("ab_test"),
          h3("计算过程"),
          verbatimTextOutput("ab_process")
        )
      )
    ),
    tabPanel(
      title = "使用说明",
      br(),
      includeMarkdown("README.md")
    )
  )
))
