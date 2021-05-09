dat <- data.frame(
  a1 = rep(c("A", "B"), each = 10),
  a2 = rep(c("A1", "A2", "B1", "B2"), each = 5),
  a3 = c(
    rep("A11", 2), rep("A12", 3), rep("A21", 2), rep("A22", 3),
    rep("B11", 2), rep("B12", 3), rep("B21", 2), rep("B22", 3)
  )
)

library(shiny)

shinyApp(
  ui = fluidPage(
    selectInput(inputId = "cate_one", label = "一级品类：", choices = dat$a1, selected = "A"),
    selectInput(inputId = "cate_two", label = "二级品类：", choices = dat$a2, selected = "A1"),
    selectInput(inputId = "cate_three", label = "三级品类：", choices = dat$a3, selected = "A11"),
    actionButton("button", label = "执行", icon = icon("refresh"), class = "btn-success"),
    textOutput("result")
  ),
  server = function(input, output, session) {
    # 相互依赖的数据选择操作
    # https://stackoverflow.com/questions/34080629/dynamic-selectinput-in-r-shiny
    observe({
      choice_cate_one <- dat[, "a1"]
      choice_cate_two <- dat[dat$a1 == input$cate_one, "a2"]
      choice_cate_three <- dat[dat$a1 == input$cate_one & dat$a2 == input$cate_two, "a3"]

      updateSelectInput(session, "cate_one", choices = choice_cate_one, selected = input$cate_one)
      updateSelectInput(session, "cate_two", choices = choice_cate_two, selected = input$cate_two)
      updateSelectInput(session, "cate_three", choices = choice_cate_three, selected = input$cate_three)
    })
    # 获取参数向量
    df <- eventReactive(input$button, {
      c(input$cate_one, input$cate_two, input$cate_three)
    })

    output$result <- renderText({
      # 按钮有作用
      paste("You chose", df()[1])
      # 按钮没作用
      paste("You chose", input$cate_one)
    })
  }
)
