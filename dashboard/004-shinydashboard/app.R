library(shiny)
# library(bs4Dash)
library(shinydashboard)

# A dashboard body with a row of infoBoxes and valueBoxes, and two rows of boxes
body <- dashboardBody(

  # infoBoxes
  fluidRow(
    infoBox(
      "订单量", uiOutput("orderNum2"), "副标题",
      icon = icon("credit-card")
    ),
    infoBox(
      "访购率", "60%",
      icon = icon("line-chart"), color = "green",
      fill = TRUE
    ),
    infoBox(
      "进度", uiOutput("progress2"),
      icon = icon("users"), color = "purple"
    )
  ),

  # valueBoxes
  fluidRow(
    valueBox(
      uiOutput("orderNum"), "新订单",
      icon = icon("credit-card"),
      href = "https://bookdown.org/"
    ),
    valueBox(
      tagList("60", tags$sup(style = "font-size: 20px", "%")),
      "访购率",
      icon = icon("line-chart"), color = "green"
    ),
    valueBox(
      htmlOutput("progress"), "进度",
      icon = icon("users"), color = "purple"
    )
  ),

  # Boxes
  fluidRow(
    box(
      status = "primary",
      sliderInput("orders", "订单", min = 1, max = 2000, value = 650),
      selectInput("progress", "进度",
        choices = c(
          "0%" = 0, "20%" = 20, "40%" = 40, "60%" = 60, "80%" = 80,
          "100%" = 100
        )
      )
    ),
    box(
      title = "直方图",
      status = "warning", solidHeader = TRUE, collapsible = TRUE,
      plotOutput("plot", height = 250)
    )
  ),

  # Boxes with solid color, using `background`
  fluidRow(
    # Box with textOutput
    box(
      title = "状态汇总",
      background = "green",
      width = 4,
      textOutput("status")
    ),

    # Box with HTML output, when finer control over appearance is needed
    box(
      title = "状态汇总 2",
      width = 4,
      background = "red",
      uiOutput("status2")
    ),

    box(
      width = 4,
      background = "light-blue",
      p("This is content. The background color is set to light-blue")
    )
  )
)



# A dashboard header with 3 dropdown menus
header <- dashboardHeader(
  title = "公司仪表盘",

  # Dropdown menu for messages
  dropdownMenu(
    type = "messages", badgeStatus = "success",
    messageItem("Support Team",
      "This is the content of a message.",
      time = "5 mins"
    ),
    messageItem("Support Team",
      "This is the content of another message.",
      time = "2 hours"
    ),
    messageItem("New User",
      "Can I get some help?",
      time = "Today"
    )
  ),

  # Dropdown menu for notifications
  dropdownMenu(
    type = "notifications", badgeStatus = "warning",
    notificationItem(
      icon = icon("users"), status = "info",
      "5 new members joined today"
    ),
    notificationItem(
      icon = icon("warning"), status = "danger",
      "Resource usage near limit."
    ),
    notificationItem(
      icon = icon("shopping-cart", lib = "glyphicon"),
      status = "success", "25 sales made"
    ),
    notificationItem(
      icon = icon("user", lib = "glyphicon"),
      status = "danger", "You changed your username"
    )
  ),

  # 下拉菜单 进度条 Dropdown menu for tasks, with progress bar
  dropdownMenu(
    type = "tasks", badgeStatus = "danger",
    taskItem(
      value = 20, color = "aqua",
      "重构代码"
    ),
    taskItem(
      value = 40, color = "green",
      "新布局设计"
    ),
    taskItem(
      value = 60, color = "yellow",
      "另一个任务"
    ),
    taskItem(
      value = 80, color = "red",
      "写文档"
    )
  )
)

sidebar <- dashboardSidebar(
  sidebarMenu(
    menuItem("面板1", tabName = "dashboard", icon = icon("dashboard")),
    menuItem("面板2", tabName = "widgets", icon = icon("th"))
  )
)


server <- function(input, output) {
  output$orderNum <- renderText({
    prettyNum(input$orders, big.mark = ",")
  })

  output$orderNum2 <- renderText({
    prettyNum(input$orders, big.mark = ",")
  })

  output$progress <- renderUI({
    tagList(input$progress, tags$sup(style = "font-size: 20px", "%"))
  })

  output$progress2 <- renderUI({
    paste0(input$progress, "%")
  })

  output$status <- renderText({
    paste0(
      "There are ", input$orders,
      " orders, and so the current progress is ", input$progress, "%."
    )
  })

  output$status2 <- renderUI({
    iconName <- switch(input$progress,
      "100" = "ok",
      "0" = "remove",
      "road"
    )
    p("Current status is: ", icon(iconName, lib = "glyphicon"))
  })


  output$plot <- renderPlot({
    hist(rnorm(input$orders))
  })
}

shinyApp(
  ui = dashboardPage(
    header = header,
    sidebar = sidebar,
    body = body,
    title = "可视化系统"
  ),
  server = server
)
