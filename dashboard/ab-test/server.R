
library(shiny)
# library(scales)
library(pwr)
library(magrittr)

#
# library(data.table)
# library(DT)
# library(reactable)
# library(gt)

# 依赖检查时间 2020-11-22
# library(plotly, warn.conflicts = FALSE) # plotly 图形库太重，渲染速度慢，依赖很多 81 个
# library(highcharter) # 渲染速度快，依赖也很多，52 个，商业协议
# library(apexcharter) # 72 个依赖
# library(echarts4r) # 59 个依赖
# 依赖分析
# tools::package_dependencies('echarts4r', recursive = T)

## 字体颜色
# color_font <- function(text, col) {
#   as.character(span(text, style = sprintf("color:%s", col)))
# }

# 文字上色
colorize <- function(x, color) {
  as.character(span(x, style = sprintf("color:%s", color)))
}

# 小数转化为百分数
percent <- function(x) paste0(100 * round(x, 4), "%")

shinyServer(function(input, output) {
  # 计算样本量
  output$sample_size <- renderText({
    # browser()
    r <- power.prop.test(
      p1 = input$ctr_old / 100,
      p2 = input$ctr_new / 100,
      sig.level = 1 - input$sig_level / 100,
      power = input$power / 100,
      alternative = "one.sided", strict = T
    )
    # print(r)
    as.character(round(r$n))
  })
  # 计算比例检验的功效
  output$result <- renderPrint({
    power.prop.test(
      p1 = input$ctr_old / 100,
      p2 = input$ctr_new / 100,
      sig.level = 1 - input$sig_level / 100,
      power = input$power / 100,
      alternative = "one.sided", strict = T
    )
  })
  # A/B 实验数据
  ab_data <- reactive({
    data.frame(`总样本量` = c(input$total_A, input$total_B),
               `转化量` = c(input$pos_A, input$pos_B),
               row.names = c("对照组", "测试组")) %>%
      transform(`转化率` = `转化量` / `总样本量`)
  })

  # 卡方检验
  chisq_test <- reactive({
    m <- matrix(c(input$total_A - input$pos_A, input$pos_A,
                  input$total_B - input$pos_B, input$pos_B),
                nrow = 2, byrow = TRUE)
    sig_p <- chisq.test(m, correct = TRUE)
    sig_p
  })

  # 卡方检验的功效
  power_test <- reactive({
    om <- ab_data()
    chisq <- chisq_test()
    # 功效检验
    power <- pwr.2p2n.test(
      h = ES.h(
        om$转化率[1],
        om$转化率[2]
      ),
      n1 = input$total_A,
      n2 = input$total_B,
      # sig.level = chisq$p.value,
      sig.level = 0.05,
      alternative = ifelse(om$转化率[2] < om$转化率[1], "greater", "less")
    )
    power
  })

  # 输出统计表格
  output$ab_table <- renderTable(
    {
      ab_data() %>%
        transform(`转化率` = percent(x = `转化率`))
    },
    rownames = TRUE
  )

  output$ab_test <- renderUI({
    # browser()
    sig_p <- chisq_test()
    p <- round(sig_p$p.value, 4)
    om <- ab_data()

    change <- ifelse(om$转化率[2] >= om$转化率[1], "提升", "下降")

    power <- power_test()

    if (is.na(power$power)) {
      power$power <- 1 # 样本量过大的时候，功效=NA，赋值为1
    }
    if (power$power > 0.8) {
      power_tag <- HTML(sprintf("可信度 %s, 可信度较高", colorize(percent(power$power), "red"), change))

    } else {
      r <- power.prop.test(
        p1 = om$转化率[1],
        p2 = om$转化率[2],
        sig.level = 0.05, # 显著性水平
        # sig.level = p,
        power = 0.8,
        alternative = "one.sided", strict = T
      )
      min_sample_size <- round(r$n)
      power_tag <- HTML(sprintf(
        "可信度 %s ，可信度不高，建议增加样本量: 每组最低样本量 %s", colorize(percent(power$power), "red"),
        colorize(min_sample_size, "red")
      ))
    }

    if (p >= 0.05) {
      text <- sprintf("但是 p = %s >= 0.05，从统计角度来说，%s效果不显著。", colorize(p, "red"), change)
    } else {
      text <- sprintf("p = %s < 0.05，从统计角度来说，%s效果显著。", colorize(p, "red"), change)
    }

    tagList(
      HTML(sprintf(
        "测试组转化率 %s，相比对照组%s : %s",
        colorize(percent(om$转化率[2]), "red"),
        change,
        colorize(percent(abs(om$转化率[2] - om$转化率[1]) / om$转化率[1]), "red")
      )),
      br(),
      HTML(text),
      br(),
      power_tag
    )
  })

  # output$power_picture <- plotly::renderPlotly({
  #   om <- ab_data()
  #   chisq <- chisq_test()
  #   # browser()
  #   r <- power.prop.test(
  #     p1 = om$转化率[1],
  #     p2 = om$转化率[2],
  #     sig.level = 0.05,
  #     power = 0.8,
  #     alternative = c("one.sided"), strict = T
  #   )
  #   min_sample_size <- round(r$n)
  # })

  # 计算过程
  output$ab_process <- renderPrint({
    chisq <- chisq_test()
    power <- power_test()
    list(卡方检验 = chisq, 功效检验 = power)
  })
})
