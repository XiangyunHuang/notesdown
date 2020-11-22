
library(shiny)
library(scales)
library(pwr)

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
color_font <- function(text, col) {
  as.character(span(text, style = sprintf("color:%s", col)))
}

shinyServer(function(input, output) {
  # 计算样本量
  output$sample_size <- renderText({
    # browser()
    r <- power.prop.test(
      p1 = input$raw_rate / 100,
      p2 = input$opt_rate / 100,
      sig.level = 1 - input$sig / 100,
      power = input$power / 100,
      alternative = "one.sided", strict = T
    )
    # print(r)
    as.character(round(r$n))
  })
  # 计算功效
  output$result <- renderPrint({
    power.prop.test(
      p1 = input$raw_rate / 100,
      p2 = input$opt_rate / 100,
      sig.level = 1 - input$sig / 100,
      power = input$power / 100,
      alternative = c("one.sided"), strict = T
    )
  })
  # A/B 实验数据
  ab_data <- reactive({
    om <- matrix(c(input$total_A, input$pos_A, input$total_B, input$pos_B), nrow = 2, byrow = TRUE)
    rownames(om) <- c("对照组", "测试组")
    colnames(om) <- c("总量", "转化量")
    om <- as.data.frame(om)
    om <- transform(om, 转化率 = 转化量 / 总量)
    om
  })

  # 卡方检验
  chisq_test <- reactive({
    m <- matrix(c(input$total_A - input$pos_A, input$pos_A, input$total_B - input$pos_B, input$pos_B),
                nrow = 2, byrow = TRUE)
    sig_p <- chisq.test(m, correct = TRUE)
    sig_p
  })

  # 功效检验
  power_test <- reactive({
    om <- ab_data()
    chisq <- chisq_test()
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


  output$ab_table <- renderTable(
    {
      om <- ab_data()
      om <- transform(om, 转化率 = percent(转化率))
      om
    },
    rownames = TRUE
  )

  output$ab_test <- renderUI({
    # browser()
    sig_p <- chisq_test()
    p <- round(sig_p$p.value, 4)
    om <- ab_data()

    if (om$转化率[2] >= om$转化率[1]) {
      change <- "提升"
    } else {
      change <- "下降"
    }

    power <- power_test()

    if (is.na(power$power)) {
      power$power <- 1 # 样本量过大的时候，功效=NA，赋值为1
    }
    if (power$power > 0.8) {
      power_tag <- HTML(sprintf("可信度 %s , 可信度较高", color_font(percent(power$power), "red"), change))

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
        "可信度 %s ， 可信度不高，建议增加样本量:
                                 每组最低样本量 %s
                                 ", color_font(percent(power$power), "red"),
        color_font(min_sample_size, "red")
      ))
    }

    if (p >= 0.05) {
      text <- sprintf("但是 p = %s >=0.05，从统计角度来说，%s效果不显著。
                           ", color_font(p, "red"), change)
    } else {
      text <- sprintf("
                            p = %s <0.05，从统计角度来说，%s效果显著。
                           ", color_font(p, "red"), change)
    }

    tagList(
      HTML(sprintf(
        "测试组转化率 %s,相比对照组%s : %s",
        color_font(percent(om$转化率[2]), "red"),
        change,
        color_font(percent(abs(om$转化率[2] - om$转化率[1]) / om$转化率[1]), "red")
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
