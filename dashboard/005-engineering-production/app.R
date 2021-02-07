
library(shiny)
library(shinydashboardPlus)
library(bslib)
library(thematic)
library(shinyWidgets)

library(ggplot2)
library(magrittr)
library(data.table)
library(dygraphs)
library(reactable)
# library(kableExtra)
# library(DT)
# library(gt)
library(formattable)
library(echarts4r)
# library(highcharter)
# library(apexcharter)
library(sparkline)
library(leaflet)

set.seed(2020)
dat <- data.frame(dt = seq(from = as.Date("2020-01-01"), to = Sys.Date(), by = "day")) %>%
  transform(search_qv = sample(100000:1000000, size = nrow(.), replace = T)) %>%
  transform(search_uv = sample(10000:100000, size = nrow(.), replace = T)) %>%
  transform(click_qv = sapply(search_qv, rbinom, n = 1, prob = 0.2)) %>%
  transform(click_uv = sapply(search_uv, rbinom, n = 1, prob = 0.4)) %>%
  transform(qv_ctr = click_qv / search_qv) %>%
  transform(uv_ctr = click_uv / search_uv)

shinyApp(
  ui = dashboardPagePlus(
    header = dashboardHeaderPlus(
      enable_rightsidebar = TRUE,
      rightSidebarIcon = "gears"
    ),
    sidebar = shinydashboard::dashboardSidebar(),
    body = shinydashboard::dashboardBody(),
    rightsidebar = rightSidebar(
      background = "dark",
      rightSidebarTabContent(
        id = 1,
        title = "Tab 1",
        icon = "desktop",
        active = TRUE,
        sliderInput(
          "obs",
          "Number of observations:",
          min = 0, max = 1000, value = 500
        )
      ),
      rightSidebarTabContent(
        id = 2,
        title = "Tab 2",
        textInput("caption", "Caption", "Data Summary")
      ),
      rightSidebarTabContent(
        id = 3,
        icon = "paint-brush",
        title = "Tab 3",
        numericInput("obs", "Observations:", 10, min = 1, max = 100)
      )
    ),
    title = "Right Sidebar"
  ),
  server = function(input, output) { }
)
