library(shiny)
library(markdown)
library(shinythemes)
library(ggplot2)
library(formattable)
library(equatiomatic)

# Cairo 包的 PNG 设备似乎无法显示中文字符，强制使用 R 自身的 png() 设备
options(shiny.usecairo = FALSE)
# 追踪模式：默认关闭，如果想启用就不要注释下一行
# options(shiny.trace = TRUE)

# 中文解决方案来自
# https://github.com/rstudio/shiny-examples/tree/master/022-unicode-chinese
# 请忽略以下代码，它只是为了解决 ShinyApps 上没有中文字体的问题
# font_home <- function(path = "") file.path("~", ".fonts", path)
# if (Sys.info()[["sysname"]] == "Linux" &&
#   system("locate wqy-zenhei.ttc") != 0 &&
#   !file.exists(font_home("wqy-zenhei.ttc"))) {
#   if (!file.exists("wqy-zenhei.ttc")) {
#     curl::curl_download(
#       "https://github.com/rstudio/shiny-examples/releases/download/v0.10.1/wqy-zenhei.ttc",
#       "wqy-zenhei.ttc"
#     )
#   }
#   dir.create(font_home())
#   file.copy("wqy-zenhei.ttc", font_home())
#   system2("fc-cache", paste("-f", font_home()))
# }
# rm(font_home)


if (.Platform$OS.type == "windows") {
  if (!grepl("Chinese", Sys.getlocale())) {
    warning(
      "You probably want Chinese locale on Windows for this app",
      "to render correctly. See ",
      "https://github.com/rstudio/shiny/issues/1053#issuecomment-167011937"
    )
  }
}

# 线性回归
fit_lm <- lm(dist ~ speed, data = cars)

# 多项式回归
fit_poly <- lm(dist ~ poly(speed, 3), data = cars)
# 等价于 fit_poly <- mgcv::gam(dist ~ poly(speed, 3), data = cars)

# 局部多项式回归
fit_loess <- loess(dist ~ speed, data = cars, degree = 2, control = loess.control(surface = "direct"))

# 样条回归 mgcv splines


# 前端
ui <- navbarPage(
  "1920s 汽车数据 cars",
  theme = shinytheme("united"),
  tabPanel(
    "数据",
    sidebarLayout(
      sidebarPanel(
        radioButtons(
          "plotType", "绘图类型：",
          c("散点图" = "p", "折线图" = "l")
        ),
        radioButtons("filetype", "文件类型：",
          choices = c("csv", "tsv")
        ),
        downloadButton("downloadData", "下载")
      ),
      mainPanel(
        h2("图形"),
        plotOutput("plot"),
        br(),
        h2("数据"),
        fluidRow(
          column(6, DT::dataTableOutput("naive_table")),
          column(6, DT::dataTableOutput("color_table"))
        ),
        br()
      )
    )
  ),

  tabPanel(
    "模型",
    sidebarLayout(
      sidebarPanel(
        selectInput(
          "modelType", "模型类型",
          c("线性回归" = "lm", "三阶多项式回归" = "poly", "局部多项式回归" = "loess"),
          selected = "lm", multiple = FALSE
        )
      ),
      mainPanel(
        plotOutput("model"),
        h2("线性回归模型输出"),
        DT::dataTableOutput("model_table_lm"),
        h2("三阶多项式回归模型输出"),
        DT::dataTableOutput("model_table_poly"),
        # h2("局部多项式回归模型输出"),
        # DT::dataTableOutput("model_table_loess"),
        h2("模型评估：RMSE"),
        DT::dataTableOutput("model_table_rmse"),
      )
    )
  ),

  navbarMenu(
    "更多",
    tabPanel(
      "关于",
      fluidRow(
        column(6, includeMarkdown("about.md"), uiOutput("model_formula")),
        column(
          6, img(
            class = "img-polaroid",
            src = paste0(
              "http://upload.wikimedia.org/",
              "wikipedia/commons/9/92/",
              "1919_Ford_Model_T_Highboy_Coupe.jpg"
            ), height = "100%", width = "100%"
          ),
          tags$small(
            "Source: Photographed at the Bay State Antique ",
            "Automobile Club's July 10, 2005 show at the ",
            "Endicott Estate in Dedham, MA by ",
            a(
              href = "http://commons.wikimedia.org/wiki/User:Sfoskett",
              "User:Sfoskett"
            )
          )
        )
      )
    )
  )
)


# 后端
server <- function(input, output, session) {
  p1 <- ggplot(data = cars, aes(x = speed, y = dist)) +
    geom_point() +
    theme_minimal(base_size = 16) +
    labs(x = "速度（英里/小时）", y = "车程（英尺）")

  output$plot <- renderPlot({
    switch(input$plotType,
      p = p1, # 散点图
      l = p1 + geom_line()
    )
  })

  output$downloadData <- downloadHandler(

    # This function returns a string which tells the client
    # browser what name to use when saving the file.
    filename = function() {
      paste("cars", input$filetype, sep = ".")
    },

    # This function should write data to a file given to it by
    # the argument 'file'.
    content = function(file) {
      sep <- switch(input$filetype, "csv" = ",", "tsv" = "\t")

      # Write to a file specified by the 'file' argument
      write.table(cars, file,
        sep = sep,
        row.names = FALSE
      )
    }
  )

  # https://stackoverflow.com/questions/11949331/adding-a-3rd-order-polynomial-and-its-equation-to-a-ggplot-in-r
  output$model <- renderPlot({
    switch(input$modelType,
      lm = p1 + geom_smooth(method = "lm") +
        ggtitle("线性回归"),
      poly = p1 + geom_smooth(method = "lm", formula = y ~ poly(x, 3, raw = TRUE)) +
        ggtitle("三阶多项式回归"),
      loess = p1 + geom_smooth(method = "loess", method.args = list(degree = 2)) +
        ggtitle("局部多项式回归") # degree = 0,1,2
    )

    # plot(cars,
    #   type = "p", col = "black",
    #   xlab = "速度（英里/小时）", ylab = "车程（英尺）"
    # )
    #
    # if ("lm" %in% input$modelType) {
    #   # 线性回归
    #   abline(fit_lm, col = "green")
    # }
    #
    # if ("lowess" %in% input$modelType) {
    #   # 局部平滑
    #   within(cars, {
    #     lines(fit_lowess, col = "red")
    #   })
    # }
    #
    # if ("poly" %in% input$modelType) {
    #   # 三阶多项式回归
    #
    #   d <- seq(0, 25, length.out = 200)
    #   lines(d, predict(fit_poly, data.frame(speed = d)), col = "blue")
    # }
  })



  output$model_table_lm <- DT::renderDataTable(
    {
      DT::datatable(round(coef(summary(fit_lm)), digits = 4))
    },
    server = FALSE
  )

  output$model_table_poly <- DT::renderDataTable(
    {
      DT::datatable(round(coef(summary(fit_poly)), digits = 4))
    },
    server = FALSE
  )

  output$model_table_rmse <- DT::renderDataTable(
    {
      # 随机误差的方差估计的平方根 RMSE
      DT::datatable(data.frame(
        model = c("线性回归", "三阶多项式回归", "局部多项式回归"),
        rmse = c(
          round(summary(fit_lm)$sigma, digits = 4),
          round(summary(fit_poly)$sigma, digits = 4),
          round(summary(fit_loess)$s, digits = 4)
        )
      ), colnames = c("模型", "均方根误差"))
    },
    server = FALSE
  )

  output$color_table <- DT::renderDataTable(
    {
      as.datatable(formattable(cars, list(
        speed = normalize_bar("pink", 0.2),
        dist = color_tile("white", "springgreen4")
      )))
    },
    server = FALSE
  )

  output$naive_table <- DT::renderDataTable(
    {
      DT::datatable(cars)
    },
    server = FALSE
  )

  output$model_formula <- renderUI({
    withMathJax(helpText(
      paste("Linear Model: $$", equatiomatic::extract_eq(fit_lm, use_coefs = TRUE), "$$")
    ))
  })
}


# 执行
shinyApp(ui = ui, server = server)
