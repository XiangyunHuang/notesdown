# 交互图形 {#chap-interactive-web-graphics}






[echarts4r](https://github.com/JohnCoene/echarts4r) 包基于 [Apache ECharts](https://github.com/apache/echarts)，ECharts 的 Python 接口 [pyecharts](https://github.com/pyecharts/pyecharts) 也非常受欢迎，基于 [apexcharts.js](https://github.com/apexcharts/apexcharts.js) 的 [apexcharter](https://github.com/dreamRs/apexcharter)。
[ECharts2Shiny](https://github.com/XD-DENG/ECharts2Shiny) 包将 ECharts 嵌入 shiny 框架中。


[leaflet](https://github.com/rstudio/leaflet) 提供 [leaflet](https://leafletjs.com/) 的 R 接口。[rAmCharts4](https://github.com/stla/rAmCharts4) 基于 [amCharts 4](https://github.com/amcharts/amcharts4/) 库， [apexcharter](https://github.com/dreamRs/apexcharter) 提供 [apexcharts.js](https://github.com/apexcharts/apexcharts.js) 的 R 接口。还有 [billboarder](https://github.com/dreamRs/billboarder) 等。更完整地，请看 Etienne Bacher 维护的 R 包列表 [r-js-adaptation](https://github.com/etiennebacher/r-js-adaptation) 。

<!-- 
https://github.com/stla/rAmCharts4
R 包 JavaScript 库 权限 网站 开发者 简短描述
-->




[plotly](https://github.com/ropensci/plotly) 是一个功能非常强大的绘制交互式图形的 R 包。它支持下载图片、添加水印、自定义背景图片、工具栏和注释[^plotly-annotation] 等一系列细节的自定义控制。下面结合 JavaScript 库 [plotly.js](https://github.com/plotly/plotly.js) 一起介绍，帮助文档 `?config` 没有太详细地介绍，所以我们看看 `config()` 函数中参数 `...` 和 JavaScript 库 [plot_config.js](https://github.com/plotly/plotly.js/blob/master/src/plot_api/plot_config.js) 中的功能函数是怎么对应的。图 中图片下载按钮对应 `toImageButtonOptions` 参数， 看 [toImageButtonOptions](https://github.com/plotly/plotly.js/blob/master/src/plot_api/plot_config.js#L311) 源代码，可知，它接受任意数据类型，对应到 R 里面就是列表。 `watermark` 和 `displaylogo` 都是传递布尔值（TRUE/FALSE），具体根据 JavaScript 代码中的 valType （参数值类型）决定，其它参数类似。另一个函数 [layout](https://plot.ly/r/reference/#Layout_and_layout_style_objects) 和函数 `config()` 是类似的，怎么传递参数值是根据 JavaScript 代码来的。

```js
toImageButtonOptions: {
    valType: 'any',
    dflt: {},
    description: [
        'Statically override options for toImage modebar button',
        'allowed keys are format, filename, width, height, scale',
        'see ../components/modebar/buttons.js'
    ].join(' ')
},
displaylogo: {
    valType: 'boolean',
    dflt: true,
    description: [
        'Determines whether or not the plotly logo is displayed',
        'on the end of the mode bar.'
    ].join(' ')
},
watermark: {
    valType: 'boolean',
    dflt: false,
    description: 'watermark the images with the company\'s logo'
},
```



[^plotly-annotation]: <https://plotly.com/r/reference/#layout-scene-annotations-items-annotation-font>


```r
library(plotly, warn.conflicts = FALSE)
plot_ly(diamonds,
  x = ~clarity, y = ~price,
  color = ~clarity, colors = "Set1", type = "box"
) %>%
  config(
    toImageButtonOptions = list(
      format = "svg", width = 450, height = 300,
      filename = paste("plot", Sys.Date(), sep = "_")
    ), 
    modeBarButtons = list(list("toImage")),
    watermark = FALSE,
    displaylogo = FALSE, 
    locale = "zh-CN", 
    staticPlot = TRUE,
    showLink = FALSE,
    modeBarButtonsToRemove = c(
      "hoverClosestCartesian", "hoverCompareCartesian", 
      "zoom2d", "zoomIn2d", "zoomOut2d", 
      "autoScale2d", "resetScale2d", "pan2d",
      "toggleSpikelines"
    )
  ) %>%
  layout(
    template = "plotly_dark",
    images = list(
      source = "https://images.plot.ly/language-icons/api-home/r-logo.png",
      xref = "paper",
      yref = "paper",
      x = 1.00,
      y = 0.25,
      sizex = 0.2,
      sizey = 0.2,
      opacity = 0.5
    ),
    annotations = list(
      text = "DRAFT",               # 水印文本
      textangle = -30,              # 逆时针旋转 30 度
      font = list(
        size = 40,                  # 字号
        color = "gray",             # 颜色
        family = "Times New Roman"  # 字族
      ),
      opacity = 0.2,                # 透明度
      xref = "paper",
      yref = "paper",
      x = 0.5,
      y = 0.5,
      showarrow = FALSE             # 去掉箭头指示
    )
  )
```

Table: (\#tab:plotly-config) 交互图形的设置函数 `config()` 各个参数及其作用（部分）

| 参数             | 作用                                            |
| :--------------- | :---------------------------------------------- |
| displayModeBar   | 是否显示交互图形上的工具条，默认显示 `TRUE`[^plotly-toolbar]。      |
| modeBarButtons   | 工具条上保留的工具，如下载 `"toImage"`，缩放 `"zoom2d"`[^modeBarButtons]。|
| modeBarButtonsToRemove  | 工具条上要移除的工具，如下载和缩放图片 `c("toImage", "zoom2d")`。  |
| toImageButtonOptions    | 工具条上下载图片的选项设置，包括名称、类型、尺寸等。[^toImageButtonOptions]|
| displaylogo             | 是否交显示互图形上 Plotly 的图标，默认显示 `TRUE`[^plotly-logo]。   |
| staticPlot              | 是否将交互图形转为静态图形，默认 `FALSE`。  |
| locale                  | 本土化语言设置，比如 `"zh-CN"` 表示中文。   |


[^plotly-logo]: <https://plotly.com/r/logos/>。
[^plotly-toolbar]: <https://plotly-r.com/control-modebar.html>。
[^modeBarButtons]: 完整的列表见 <https://github.com/plotly/plotly.js/blob/master/src/components/modebar/buttons.js>。
[^toImageButtonOptions]: 设置下载图片的尺寸，还可设置为 PNG 格式，SVG 格式图片，可借助 **rsvg** 的 `rsvg_pdf()` 函数转化为 PDF 格式 <https://github.com/ropensci/plotly/issues/1556#issuecomment-505833092>。


## 散点图 {#sec-plotly-scatter}


Table: (\#tab:plotly-scatter-functions) 散点图类型

| 类型             | 名称              |
| :--------------- | :---------------- |
| `scattercarpet`  | 地毯图            |
| `scatterternary` | 三元图            |
| `scatter3d`      | 三维散点图        |
| `scattergeo`     | 地图散点图        |
| `scattermapbox`  | 地图散点图 Mapbox |
| `scatter`        | 散点图            |
| `scattergl`      | 散点图 GL         |
| `scatterpolar`   | 极坐标散点图      |
| `scatterpolargl` | 极坐标散点图 GL   |

plotly.js 提供很多图层用于绘制各类图形 <https://github.com/plotly/plotly.js/tree/master/src/traces>


```r
# 折线图
plot_ly(Orange,
  x = ~age, y = ~circumference, color = ~Tree,
  type = "scatter", mode = "markers"
)
```

## 条形图 {#sec-plotly-barplot}

日常使用最多的图形无外乎散点图、柱形图（分组、堆积、百分比堆积等）


```r
# 简单条形图
library(data.table)
diamonds <- as.data.table(diamonds)

p11 <- diamonds[, .(cnt = .N), by = .(cut)] %>%
  plot_ly(x = ~cut, y = ~cnt, type = "bar") %>%
  add_text(
    text = ~ scales::comma(cnt), y = ~cnt,
    textposition = "top middle",
    cliponaxis = FALSE, showlegend = FALSE
  )
# 分组条形图
p12 <- plot_ly(diamonds,
  x = ~cut, color = ~clarity,
  colors = "Accent", type = "histogram"
) 
# 堆积条形图
p13 <- plot_ly(diamonds,
  x = ~cut, color = ~clarity,
  colors = "Accent", type = "histogram"
) %>%
  layout(barmode = "stack")
# 百分比堆积条形图
# p14 <- plot_ly(diamonds,
#   x = ~cut, color = ~clarity,
#   colors = "Accent", type = "histogram"
# ) %>%
#   layout(barmode = "stack", barnorm = "percent") %>%
#   config(displayModeBar = F)

# 推荐使用如下方式绘制堆积条形图
dat = diamonds[, .(cnt = length(carat)), by = .(clarity, cut)] %>%
  .[, pct := round(100 * cnt / sum(cnt), 2), by = .(cut)]

p14 <- plot_ly(
  data = dat, x = ~cut, y = ~pct, color = ~clarity,
  colors = "Set3", type = "bar"
) %>%
  layout(barmode = "stack")

htmltools::tagList(p11, p12, p13, p14)
```

## 折线图 {#sec-plotly-lineplot}

其它常见的图形还要折线图、直方图、箱线图和提琴图


```r
# 折线图
plot_ly(Orange,
  x = ~age, y = ~circumference, color = ~Tree,
  type = "scatter", mode = "markers+lines"
)
```


## 双轴图 {#sec-multiple-y-axes}

[双轴图](https://plotly.com/r/multiple-axes/)

模拟一组数据


```r
set.seed(2020)
dat <- data.frame(
  dt = seq(from = as.Date("2020-01-01"), to = as.Date("2020-01-31"), by = "day"),
  search_qv = sample(100000:1000000, size = 31, replace = T)
) %>%
  transform(valid_click_qv = sapply(search_qv, rbinom, n = 1, prob = 0.5)) %>%
  transform(qv_ctr = valid_click_qv / search_qv)
```

`hoverinfo = "text"` 表示 tooltips 使用指定的 text 映射，而 `visible = "legendonly"` 表示图层默认隐藏不展示，只在图例里显示，有时候很多条线，默认只是展示几条而已。举例如下


```r
plot_ly(data = dat) %>%
  add_bars(
    x = ~dt, y = ~search_qv, color = I("gray80"), name = "搜索 QV",
    text = ~ paste0(
      "日期：", dt, "<br>",
      "点击 QV：", format(valid_click_qv, big.mark = ","), "<br>",
      "搜索 QV：", format(search_qv, big.mark = ","), "<br>",
      "QV_CTR：", scales::percent(qv_ctr, accuracy = 0.01), "<br>"
    ),
    hoverinfo = "text"
  ) %>%
  add_bars(
    x = ~dt, y = ~valid_click_qv, color = I("gray60"), name = "点击 QV",
    text = ~ paste0(
      "日期：", dt, "<br>",
      "点击 QV：", format(valid_click_qv, big.mark = ","), "<br>",
      "搜索 QV：", format(search_qv, big.mark = ","), "<br>",
      "QV_CTR：", scales::percent(qv_ctr, accuracy = 0.01), "<br>"
    ), visible = "legendonly",
    hoverinfo = "text"
  ) %>%
  add_lines(
    x = ~dt, y = ~qv_ctr, name = "QV_CTR", yaxis = "y2", color = I("gray40"),
    text = ~ paste("QV_CTR：", scales::percent(qv_ctr, accuracy = 0.01), "<br>"), 
    hoverinfo = "text",
    line = list(shape = "spline", width = 3, dash = "line")
  ) %>%
  layout(
    title = "",
    yaxis2 = list(
      tickfont = list(color = "black"),
      overlaying = "y",
      side = "right",
      title = "QV_CTR（%）",
      # ticksuffix = "%", # 设置坐标轴单位
      tickformat = '.1%', # 设置坐标轴刻度
      showgrid = F, automargin = TRUE
    ),
    xaxis = list(title = "日期", showgrid = F, showline = F),
    yaxis = list(title = " ", showgrid = F, showline = F),
    margin = list(r = 20, autoexpand = T),
    legend = list(
      x = 0, y = 1, orientation = "h",
      title = list(text = " ")
    )
  )
```


## 直方图 {#sec-plotly-histogram}


```r
plot_ly(iris,
  x = ~Sepal.Length, colors = "Greys",
  color = ~Species, type = "histogram"
)
```

## 箱线图 {#sec-plotly-boxplot}


```r
# 箱线图
plot_ly(diamonds,
  x = ~clarity, y = ~price, colors = "Greys",
  color = ~clarity, type = "box"
)
```

## 提琴图 {#sec-plotly-violin}


```r
plot_ly(sleep,
  x = ~group, y = ~extra, split = ~group,
  type = "violin",
  box = list(visible = T),
  meanline = list(visible = T)
)
```

plotly 包含图层 27 种，见表 \@ref(tab:add-layer) 

\begin{table}

\caption{(\#tab:add-layer)图层}
\centering
\begin{tabular}[t]{l|l|l}
\hline
A & B & C\\
\hline
add\_annotations & add\_histogram & add\_polygons\\
\hline
add\_area & add\_histogram2d & add\_ribbons\\
\hline
add\_bars & add\_histogram2dcontour & add\_scattergeo\\
\hline
add\_boxplot & add\_image & add\_segments\\
\hline
add\_choropleth & add\_lines & add\_sf\\
\hline
add\_contour & add\_markers & add\_surface\\
\hline
add\_data & add\_mesh & add\_table\\
\hline
add\_fun & add\_paths & add\_text\\
\hline
add\_heatmap & add\_pie & add\_trace\\
\hline
\end{tabular}
\end{table}



## 气泡图 {#sec-plotly-bubble}

简单图形 scatter，分布图几类，其中 scatter、heatmap、scatterpolar 支持 WebGL 绘图引擎


```r
# https://plotly.com/r/bubble-charts/
dat <- diamonds[, .(
  carat = mean(carat),
  price = sum(price), 
  cnt = .N
), by = .(cut)]

plot_ly(
  data = dat, colors = "Greys",
  x = ~carat, y = ~price, color = ~cut, size = ~cnt,
  type = "scatter", mode = "markers",
  marker = list(
    symbol = "circle", sizemode = "diameter",
    line = list(width = 2, color = "#FFFFFF"), opacity = 0.4
  ),
  text = ~ paste(
    sep = " ", "重量：", round(carat, 2), "克拉",
    "<br>价格:", round(price / 10^6, 2), "百万"
  ),
  hoverinfo = 'text'
) %>%
  add_annotations(
    x = ~carat, y = ~price, text = ~cnt,
    showarrow = F, font = list(family = "sans")
  ) %>%
  layout(
    xaxis = list(hoverformat = ".2f"),
    yaxis = list(hoverformat = ".0f")
  )
```

## 曲线图 {#sec-plotly-spline}


```r
plot_ly(
  x = c(1, 2.2, 3), y = c(5.3, 6, 7), 
  type = "scatter", color = I("gray40"), 
  mode = "markers+lines", line = list(shape = "spline")
) %>%
  add_annotations(
    x = 2, y = 6, size = I(100),
    text = TeX("x_i \\sim N(\\mu, \\sigma)")
  ) %>% 
  layout(
    xaxis = list(showgrid = F, title = TeX("\\mu")),
    yaxis = list(showgrid = F, title = TeX("\\alpha"))
  ) %>% 
  config(mathjax = 'cdn')
```


## 堆积图 {#sec-plotly-tozeroy}


```r
plot_ly(
  data = PlantGrowth, y = ~weight,
  color = ~group, colors = "Greys",
  type = "scatter", line = list(shape = "spline"),
  mode = "lines", fill = "tozeroy"
)
```


## 热力图 {#sec-plotly-heatmap}

其他基础图形


```r
plot_ly(z = volcano, type = 'heatmap', colors = "Greys")
```




## 地图 I {#sec-plotly-map}

`plot_mapbox()` 使用 Mapbox 提供的地图服务，因此，需要注册一个账户，获取 MAPBOX_TOKEN


```r
data("quakes")
plot_mapbox(
  data = quakes, colors = "Greys",
  lon = ~long, lat = ~lat,
  color = ~mag, size = 2,
  type = "scattermapbox", 
  mode = "markers",
  marker = list(opacity = 0.5)
) %>%
  layout(
    title = "Fiji Earthquake",
    mapbox = list(
      zoom = 3,
      center = list(
        lat = ~ median(lat - 5),
        lon = ~ median(long)
      )
    )
  ) %>%
  config(
    mapboxAccessToken = Sys.getenv("MAPBOX_TOKEN")
  )
```


```r
plotly::plot_ly(
  data = quakes,
  lon = ~long, lat = ~lat,
  type = "scattergeo", mode = "markers",
  text = ~ paste0(
    "站点：", stations, "<br>",
    "震级：", mag
  ),
  marker = list(
    color = ~mag, 
    size = 10, opacity = 0.8,
    line = list(color = "white", width = 1)
  )
) %>%
  plotly::layout(geo = list(
    showland = TRUE,
    landcolor = plotly::toRGB("gray95"),
    subunitcolor = plotly::toRGB("gray85"),
    countrycolor = plotly::toRGB("gray85"),
    countrywidth = 0.5,
    subunitwidth = 0.5,
    lonaxis = list(
      showgrid = TRUE,
      gridwidth = 0.5,
      range = c(160, 190),
      dtick = 5
    ),
    lataxis = list(
      showgrid = TRUE,
      gridwidth = 0.5,
      range = c(-40, -10),
      dtick = 5
    )
  ))
```



```r
dat <- data.frame(state.x77,
  stats = rownames(state.x77),
  stats_abbr = state.abb
)

plotly::plot_ly(
  data = dat,
  type = "choropleth",
  locations = ~stats_abbr,
  locationmode = "USA-states",
  colorscale = "Viridis",
  z = ~Income
) |>
  plotly::layout(
    geo = list(scope = "usa"),
    title = "1974年美国各州的人均收入",
    legend = list(title = "收入")
  ) |>
  plotly::config(displayModeBar = FALSE)
```




## 拟合图 {#sec-plotly-fitted}


```r
plot_ly(economics,
  type = "scatter",
  x = ~date,
  y = ~uempmed,
  name = "observed unemployment",
  mode = "markers+lines",
  marker = list(
    color = "red"
  ),
  line = list(
    color = "red",
    dash = "dashed"
  )
) %>%
  add_trace(
    x = ~date,
    y = ~fitted(loess(uempmed ~ as.numeric(date))),
    name = "fitted unemployment",
    mode = "markers+lines",
    marker = list(
      color = "orange"
    ),
    line = list(
      color = "orange"
    )
  ) %>%
  layout(
    title = "失业时间",
    xaxis = list(
      title = "日期",
      showgrid = F
    ),
    yaxis = list(
      title = "失业时间（周）"
    ),
    legend = list(
      x = 0, y = 1, orientation = "v",
      title = list(text = "")
    )
  )
```


## 轨迹图 {#sec-plotly-rasterly}

[rasterly](https://github.com/plotly/rasterly) 百万量级的散点图


```r
library(rasterly)
plot_ly(quakes, x = ~long, y = ~lat) %>%
  add_rasterly_heatmap()

quakes %>%
  rasterly(mapping = aes(x = long, y = lat)) %>%
  rasterly_points()
```


```r
library(plotly)
# 读取数据
# uber 轨迹数据来自 https://github.com/plotly/rasterly
ridesDf <- readRDS(file = 'data/uber.rds')

ridesDf %>%
  rasterly(mapping = aes(x = Lat, y = Lon)) %>%
  rasterly_points()
```
\begin{figure}

{\centering \includegraphics[width=5.19in]{screenshots/rasterly-rides} 

}

\caption{轨迹数据}(\#fig:uber-rides)
\end{figure}


## 三维图 (plotly) {#sec-plotly-3d}



```r
plot_ly(z = ~volcano) %>%
  add_surface()

plot_ly(x = c(0, 0, 1), y = c(0, 1, 0), z = c(0, 0, 0)) %>%
  add_mesh()

# https://plot.ly/r/reference/#scatter3d
transform(mtcars, am = ifelse(am == 0, "Automatic", "Manual")) %>%
  plot_ly(x = ~wt, y = ~hp, z = ~qsec, 
          color = ~am, colors = c("#BF382A", "#0C4B8E")) %>%
  add_markers() %>%
  layout(scene = list(
    xaxis = list(title = "Weight"),
    yaxis = list(title = "Gross horsepower"),
    zaxis = list(title = "1/4 mile time")
  ))
```

## 甘特图 {#sec-plotly-gantt-charts}

项目管理必备，如图所示，本项目拆分成7个任务，一共使用3种项目资源

<!-- 转向管理必须学会做项目管理，从全局、全流程的角度思考问题 -->


```r
# https://plotly.com/r/gantt/
# 项目拆解为一系列任务，每个任务的开始时间，持续时间和资源类型
df <- data.frame(
  task = paste("Task", 1:8),
  start = as.Date(c(
    "2016-01-01", "2016-02-20", "2016-01-01",
    "2016-04-10", "2016-06-09", "2016-04-10",
    "2016-09-07", "2016-11-26"
  )),
  duration = c(50, 25, 100, 60, 30, 150, 80, 10),
  resource = c("A", "B", "C", "C", "C", "A", "B", "B")
) %>%
  transform(end = start + duration) %>%
  transform(y = 1:nrow(.))

plot_ly(data = df) %>%
  add_segments(
    x = ~start, xend = ~end,
    y = ~y, yend = ~y,
    color = ~resource,
    mode = "lines",
    colors = "Greys", 
    line = list(width = 20),
    showlegend = F,
    hoverinfo = "text",
    text = ~ paste(
      " 任务: ", task, "<br>",
      "启动时间: ", start, "<br>",
      "周期: ", duration, "天<br>",
      "资源: ", resource
    )
  ) %>%
  layout(
    xaxis = list(
      showgrid = F,
      title = list(text = "")
    ),
    yaxis = list(
      showgrid = F,
      title = list(text = ""),
      tickmode = "array",
      tickvals = 1:nrow(df),
      ticktext = unique(df$task),
      domain = c(0, 0.9)
    ),
    annotations = list(
      list(
        xref = "paper", yref = "paper",
        x = 0.80, y = 0.1,
        text = paste0(
          "项目周期: ", sum(df$duration), " 天<br>",
          "资源类型: ", length(unique(df$resource)), " 个<br>"
        ),
        font = list(size = 12),
        ax = 0, ay = 0,
        align = "left"
      ),
      list(
        xref = "paper", yref = "paper",
        x = 0.1, y = 1,
        xanchor = "left",
        text = "项目资源管理",
        font = list(size = 20),
        ax = 0, ay = 0,
        align = "left",
        showarrow = FALSE
      )
    )
  )
```

## 帕雷托图 {#sec-plotly-pareto-charts}

[帕雷托图](https://en.wikipedia.org/wiki/Pareto_chart) 20/80 法则


```r
# 数据来自 https://github.com/plotly/datasets 
dat <- data.frame(
  complaint = c(
    "Small portions", "Overpriced",
    "Wait time", "Food is tasteless", "No atmosphere", "Not clean",
    "Too noisy", "Food is too salty", "Unfriendly staff", "Food not fresh"
  ),
  count = c( 621L, 789L, 109L, 65L, 45L, 30L, 27L, 15L, 12L, 9L)
)

dat <- dat[order(-dat$count), ] %>%
  transform(cumulative = round(100 * cumsum(count) / sum(count), digits = 2))

# complaint 按 count 降序排列
dat$complaint <- reorder(x = dat$complaint, X = dat$count, FUN = function(x) 1/(1 + x))

plot_ly(data = dat) %>%
  add_bars(
    x = ~complaint, y = ~count,
    showlegend = F, color = I("gray60")
  ) %>%
  add_lines(
    x = ~complaint, y = ~cumulative, yaxis = "y2",
    showlegend = F, color = I("gray40")
  ) %>%
  layout(
    yaxis2 = list(
      tickfont = list(color = "black"),
      overlaying = "y",
      side = "right",
      title = "累积百分比（%）",
      showgrid = F
    ),
    xaxis = list(title = "投诉类型", showgrid = F, showline = F),
    yaxis = list(title = "数量", showgrid = F, showline = F)
  )
```

::: {.rmdtip data-latex="{提示}"}
`reorder()` 对 complaint 按照降序还是升序由 FUN 函数的单调性决定，单调增对应升序，单调减对应降序
:::


## 时间线 {#sec-plotly-vistime}



```r
library(vistime)

pres <- data.frame(
  Position = rep(c("President", "Vice"), each = 3),
  Name = c("Washington", rep(c("Adams", "Jefferson"), 2), "Burr"),
  start = c("1789-03-29", "1797-02-03", "1801-02-03"),
  end = c("1797-02-03", "1801-02-03", "1809-02-03"),
  color = c("#cbb69d", "#603913", "#c69c6e"),
  fontcolor = c("black", "white", "black")
)

vistime(pres, col.event = "Position", col.group = "Name")
```

## 漏斗图 {#sec-plotly-funnel}


```r
dat <- data.frame(
  category = c("访问", "下载", "潜客", "报价", "下单"),
  value = c(39, 27.4, 20.6, 11, 2)
) %>% 
  transform(percent = value / cumsum(value))

plot_ly(data = dat) %>%
  add_trace(
    type = "funnel",
    y = ~category,
    x = ~value,
    color = ~category, 
    colors = "Set2", 
    text = ~ paste0(value, "<br>", sprintf("%.2f%%", 100*percent)) ,
    hoverinfo = "text",
    showlegend = FALSE
  ) %>%
  layout(yaxis = list(
    categoryarray = ~category,
    title = ""
  ))
```



```r
plotly::plot_ly(data = dat) %>%
  plotly::add_trace(
    type = "funnel",
    y = ~category,
    x = ~value,
    marker = list(color = RColorBrewer::brewer.pal(n = 5, name = "Set2")),
    textposition = "auto",
    textinfo = "value+percent previous",
    hoverinfo = "none"
  ) %>%
  plotly::layout(yaxis = list(categoryarray = ~category, title = ""))
```

## 雷达图 {#sec-plotly-radar}


```r
plot_ly(
  type = "scatterpolar", mode = "markers", fill = "toself"
) %>%
  add_trace(
    r = c(39, 28, 8, 7, 28, 39), color = I("gray40"),
    theta = c("数学", "物理", "化学", "英语", "生物", "数学"),
    name = "学生 A"
  ) %>%
  add_trace(
    r = c(1.5, 10, 39, 31, 15, 1.5), color = I("gray80"),
    theta = c("数学", "物理", "化学", "英语", "生物", "数学"),
    name = "学生 B"
  ) %>%
  layout(
    polar = list(
      radialaxis = list(
        visible = T,
        range = c(0, 50)
      )
    )
  )
```


## 瀑布图 {#sec-plotly-waterfall}

盈亏图


```r
library(plotly)
library(dplyr)

dat <- data.frame(
  x = c(
    "销售", "咨询", "净收入",
    "购买", "其他费用", "税前利润"
  ),
  y = c(60, 80, 10, -40, -20, 0),
  measure = c(
    "relative", "relative", "relative",
    "relative", "relative", "total"
  )
) %>%
  mutate(text = case_when(
    y > 0 ~ paste0("+", y),
    y == 0 ~ "",
    y < 0 ~ as.character(y)
  )) %>%
  mutate(x = factor(x, levels = c(
    "销售", "咨询", "净收入",
    "购买", "其他费用", "税前利润"
  )))

n_rows <- nrow(dat)
dat[nrow(dat), "text"] <- "累计"

# measure 取值为 'relative'/'total'/'absolute'
plotly::plot_ly(dat,
  x = ~x, y = ~y, measure = ~measure, type = "waterfall",
  text = ~text, textposition = "outside", 
  name = "收支", hoverinfo = "final", 
  connector = list(line = list(color = "gray")),
  increasing = list(marker = list(color = "#66C2A5")),
  decreasing = list(marker = list(color = "#FC8D62")),
  totals = list(marker = list(color = "#8DA0CB"))
) %>%
  plotly::layout(
    title = "2018 年收支状态",
    xaxis = list(title = "业务"),
    yaxis = list(title = "金额"),
    showlegend = FALSE
  )
```

## 树状图 {#sec-plotly-treemap}

plotly 绘制 treemap 和 sunburst 图比较复杂，接口不友好， [plotme](https://github.com/yogevherz/plotme) 正好弥补不足。


## 旭日图 {#sec-plotly-sunburst}

[plotme](https://github.com/yogevherz/plotme)


## 调色板 {#sec-plotly-color-palette}


```r
plot_ly(iris,
  x = ~Petal.Length, y = ~Petal.Width,
  mode = "markers", type = "scatter",
  color = ~ Sepal.Length > 6, colors = c("#132B43", "#56B1F7")
)
plot_ly(iris,
  x = ~Petal.Length, y = ~Petal.Width, color = ~ Sepal.Length > 6,
  mode = "markers", type = "scatter"
)

plot_ly(iris,
  x = ~Petal.Length, y = ~Petal.Width, color = ~ Sepal.Length > 6,
  mode = "markers", type = "scatter", colors = "Set2"
)

plot_ly(iris,
  x = ~Petal.Length, y = ~Petal.Width, color = ~ Sepal.Length > 6,
  mode = "markers", type = "scatter", colors = "Set1"
)
```

构造 20 个类别 超出 Set1 调色板的范围，会触发警告说 Set1 没有那么多色块，但还是返回足够多的色块，也可以使用 `viridis`、`plasma`、`magma` 或 `inferno` 调色板


```r
dat <- data.frame(
  dt = rep(seq(
    from = as.Date("2021-01-01"),
    to = as.Date("2021-01-31"), by = "day"
  ), each = 20),
  bu = rep(LETTERS[1:20], 31),
  qv = rbinom(n = 20 * 31, size = 10000, prob = runif(20 * 31))
)
# viridis
plot_ly(dat,
  x = ~dt, y = ~qv, color = ~bu, 
  mode = "markers", type = "scatter", colors = "viridis"
)
```




## 导出静态图形 {#sec-export}

orca (Open-source Report Creator App) 软件针对 plotly.js 库渲染的图形具有很强的导出功能，[安装 orca](https://github.com/plotly/orca#installation) 后，`plotly::orca()` 函数可以将基于 htmlwidgets 的 plotly 图形对象导出为 PNG、PDF 和 SVG 等格式的高质量静态图片。


```r
p <- plot_ly(x = 1:10, y = 1:10, color = 1:10)
orca(p, "plot.svg")
```

## 静态图形转交互图形 {#sec-ggplotly}

函数 `ggplotly()`  将 ggplot 对象转化为交互式 plotly 对象


```r
gg <- ggplot(faithful, aes(x = eruptions, y = waiting)) +
  stat_density_2d(aes(fill = ..level..), geom = "polygon") +
  xlim(1, 6) +
  ylim(40, 100)
```

静态图形


```r
gg
```



\begin{center}\includegraphics{interactive-web-graphics_files/figure-latex/unnamed-chunk-6-1} \end{center}

转化为 plotly 对象


```r
ggplotly(gg)
```

添加动态点的注释，比如点横纵坐标、坐标文本，整个注释标签的样式（如背景色）


```r
ggplotly(gg, dynamicTicks = "y") %>%
  style(., hoveron = "points", hoverinfo = "x+y+text", 
        hoverlabel = list(bgcolor = "white"))
```



## 地图 II {#sec-echarts4r-map}

**leaflet** 包制作地图，斐济是太平洋上的一个岛国，处于板块交界处，经常发生地震，如下图所示，展示 1964 年来 1000 次震级大于 4 级的地震活动。


```r
library(leaflet)
data(quakes)
# Pop 提示
quakes$popup_text <- lapply(paste(
  "编号:", "<strong>", quakes$stations, "</strong>", "<br>",
  "震深:", quakes$depth, "<br>",
  "震级:", quakes$mag
), htmltools::HTML)
# 构造调色板
pal <- colorBin("Spectral", bins = pretty(quakes$mag), reverse = TRUE)
p <- leaflet(quakes) |>
  addProviderTiles(providers$CartoDB.Positron) |>
  addCircles(lng = ~long, lat = ~lat, color = ~ pal(mag), label = ~popup_text) |>
  addLegend("bottomright",
    pal = pal, values = ~mag,
    title = "地震震级"
  ) |>
  addScaleBar(position = c("bottomleft"))
p
```
\begin{figure}

{\centering \includegraphics[width=0.75\linewidth]{screenshots/leaflet-fiji} 

}

\caption{斐济地震带}(\#fig:fiji-quakes-latex)
\end{figure}

将上面的绘图部分保存为独立的 HTML 网页文件


```r
library(htmlwidgets)
# p 就是绘图部分的数据对象
saveWidget(p, "fiji-map.html", selfcontained = T)
```



```r
library(leaflet)
library(leaflet.extras)

quakes |>
  leaflet() |>
  addTiles() |>
  addProviderTiles(providers$OpenStreetMap.DE) |>
  addHeatmap(
    lng = ~long, lat = ~lat, intensity = ~mag,
    max = 100, radius = 20, blur = 10
  )
```
\begin{figure}

{\centering \includegraphics[width=0.75\linewidth]{screenshots/leaflet-heatmap} 

}

\caption{斐济地震带热力图}(\#fig:fiji-heatmap-latex)
\end{figure}

**leafletCN** 提供汉化


```r
# 地图默认放大倍数
zoom         <- 4
# 地图可以放大的倍数区间
minZoom      <- 1
maxZoom      <- 18

library(leaflet)
library(leafletCN)
library(maptools)
library(leaflet.extras)

# 热力图 heatmap
leaflet(res, options = leafletOptions(minZoom = minZoom, maxZoom = maxZoom)) |>
  amap() |>
  # setView(lng = mean(data$long), lat = mean(data$lat), zoom = zoom) |>
  setView(lng = 109, lat = 38, zoom = 4) |>
  addHeatmap(
    lng = ~long2, lat = ~lat2, intensity = ~uv, max = max(res$uv),
    blur = blur, minOpacity = minOpacity, radius = radius
  )

quakes$popup_text <- lapply(paste(
  "编号:", "<strong>", quakes$stations, "</strong>", "<br>",
  "震深:", quakes$depth, "<br>",
  "震级:", quakes$mag
), htmltools::HTML)
# 构造调色板
pal <- colorBin("Spectral", bins = pretty(quakes$mag), reverse = TRUE)

leaflet(quakes) |>
  addProviderTiles(providers$CartoDB.Positron) |>
  addCircles(
    lng = ~long, lat = ~lat,
    color = ~ pal(mag), label = ~popup_text
  ) |>
  setView(178, -20, 5) |>
  addHeatmap(
    lng = ~long, lat = ~lat, intensity = ~mag,
    blur = 20, max = 0.05, radius = 15
  ) |>
  addLegend("bottomright",
    pal = pal, values = ~mag,
    title = "地震震级"
  ) |>
  addScaleBar(position = c("bottomleft"))
```


## 动画 {#sec-echarts4r-animation}



```r
# https://d.cosx.org/d/422311
library(echarts4r)

data("gapminder", package = "gapminder")

titles <- lapply(unique(gapminder$year), function(x) {
  list(
    text = "Gapminder",
    left = "center"
  )
})

years <- lapply(unique(gapminder$year), function(x) {
  list(
    subtext = x,
    left = "center",
    top = "center",
    z = 0,
    subtextStyle = list(
      fontSize = 100,
      color = "rgb(170, 170, 170, 0.5)",
      fontWeight = "bolder"
    )
  )
})

# 添加一列颜色，各大洲和颜色的对应关系可自定义，调整 levels 或 labels 里面的顺序即可，也可不指定 levels ，调用其它调色板
gapminder <- within(gapminder, {
  color <- factor(
    continent,
    levels = c("Asia", "Africa", "Americas", "Europe", "Oceania"),
    labels = RColorBrewer::brewer.pal(n = 5, name = "Spectral")
  )
})

gapminder |>
  group_by(year) |>
  e_charts(x = gdpPercap, timeline = TRUE) |>
  e_scatter(
    serie = lifeExp, size = pop, bind = country,
    symbol_size = 5, name = ""
  ) |>
  e_add("itemStyle", color) |>
  e_y_axis(
    min = 20, max = 85, nameGap = 30,
    name = "Life Exp", nameLocation = "center"
  ) |>
  e_x_axis(
    type = "log", min = 100, max = 100000,
    nameGap = 30, name = "GDP / Cap", nameLocation = "center"
  ) |>
  e_timeline_serie(title = titles) |>
  e_timeline_serie(title = years, index = 2) |>
  e_timeline_opts(playInterval = 1000) |>
  e_grid(bottom = 100) |>
  e_tooltip()
```



## 网络图 {#sec-network-analysis}

[gephi](https://github.com/gephi/gephi) 探索和可视化网络图 GraphViz


```r
# library(igraph)
```

### networkD3 {#subsec-networkD3}

[networkD3](https://github.com/christophergandrud/networkD3) [D3](https://github.com/d3/d3) 非常适合绘制网络图，如网络、树状、桑基图


```r
library(networkD3)
data(MisLinks, MisNodes) # 加载数据
head(MisLinks) # 边
```

```
##   source target value
## 1      1      0     1
## 2      2      0     8
## 3      3      0    10
## 4      3      2     6
## 5      4      0     1
## 6      5      0     1
```

```r
head(MisNodes) # 节点
```

```
##              name group size
## 1          Myriel     1   15
## 2        Napoleon     1   20
## 3 Mlle.Baptistine     1   23
## 4    Mme.Magloire     1   30
## 5    CountessdeLo     1   11
## 6        Geborand     1    9
```

构造网络图


```r
forceNetwork(
  Links = MisLinks, Nodes = MisNodes, Source = "source",
  Target = "target", Value = "value", NodeID = "name",
  Group = "group", opacity = 0.4
)
```

### visNetwork {#subsec-visNetwork}

[visNetwork](https://github.com/datastorm-open/visNetwork) 使用 [vis-network.js](https://github.com/visjs/vis-network) 库绘制网络关系图 <https://datastorm-open.github.io/visNetwork>


```r
library(visNetwork)
```

调用函数 `visTree()` 可视化分类模型结果


```r
library(rpart)
library(sparkline) # 函数 visTree 需要导入 sparkline 包
res <- rpart(Species~., data=iris)
visTree(res, main = "鸢尾花分类树", width = "100%")
```



\begin{center}\includegraphics{interactive-web-graphics_files/figure-latex/unnamed-chunk-14-1} \end{center}

节点、边的属性都可以映射数据指标



### r2d3 {#subsec-r2d3}

[D3](https://d3js.org/) 是非常流行的 JavaScript 库，[r2d3](https://github.com/rstudio/r2d3) 提供了 R 接口

<!-- 介绍网络图的做法 -->


```r
library(r2d3)
```

更加具体的使用介绍，一个复杂的案例，如何从简单配置过来，以条形图为例， D3 是一个相当强大且成熟的库，提供的案例功能要覆盖 plotly

[r2d3](https://github.com/rstudio/r2d3) 提供了两个样例 JS 库 `baranims.js` 和 `barchart.js`


```r
list.files(system.file("examples/", package = "r2d3"))
```

```
## [1] "baranims.js" "barchart.js"
```


```r
library(r2d3)
r2d3(
  data = c(0.3, 0.6, 0.8, 0.95, 0.40, 0.20),
  script = system.file("examples/barchart.js", package = "r2d3")
)
```



```r
r2d3(
  data = c(0.3, 0.6, 0.8, 0.95, 0.40, 0.20),
  script = system.file("examples/baranims.js", package = "r2d3")
)
```


[提供一个 R 包和 HTML Widgets 小练习：给 roughViz.js 写个 R 包装 <https://d.cosx.org/d/421030-r-html-widgets-roughviz-js-r>
<https://github.com/XiangyunHuang/roughviz>]{.todo}


## 运行环境 {#sec-web-graphics-session}


```r
sessionInfo()
```

```
## R version 4.2.0 (2022-04-22)
## Platform: x86_64-pc-linux-gnu (64-bit)
## Running under: Ubuntu 20.04.4 LTS
## 
## Matrix products: default
## BLAS:   /usr/lib/x86_64-linux-gnu/blas/libblas.so.3.9.0
## LAPACK: /usr/lib/x86_64-linux-gnu/lapack/liblapack.so.3.9.0
## 
## locale:
##  [1] LC_CTYPE=en_US.UTF-8       LC_NUMERIC=C              
##  [3] LC_TIME=en_US.UTF-8        LC_COLLATE=en_US.UTF-8    
##  [5] LC_MONETARY=en_US.UTF-8    LC_MESSAGES=en_US.UTF-8   
##  [7] LC_PAPER=en_US.UTF-8       LC_NAME=C                 
##  [9] LC_ADDRESS=C               LC_TELEPHONE=C            
## [11] LC_MEASUREMENT=en_US.UTF-8 LC_IDENTIFICATION=C       
## 
## attached base packages:
## [1] stats     graphics  grDevices utils     datasets  methods   base     
## 
## other attached packages:
## [1] sparkline_2.0    rpart_4.1.16     visNetwork_2.1.0 networkD3_0.4   
## [5] r2d3_0.2.6       plotly_4.10.0    ggplot2_3.3.6   
## 
## loaded via a namespace (and not attached):
##  [1] tidyselect_1.1.2  xfun_0.31         purrr_0.3.4       colorspace_2.0-3 
##  [5] vctrs_0.4.1       generics_0.1.2    htmltools_0.5.2   viridisLite_0.4.0
##  [9] yaml_2.3.5        utf8_1.2.2        rlang_1.0.2       isoband_0.2.5    
## [13] pillar_1.7.0      glue_1.6.2        withr_2.5.0       DBI_1.1.2        
## [17] lifecycle_1.0.1   stringr_1.4.0     munsell_0.5.0     gtable_0.3.0     
## [21] htmlwidgets_1.5.4 evaluate_0.15     labeling_0.4.2    knitr_1.39       
## [25] callr_3.7.0       fastmap_1.1.0     ps_1.7.0          curl_4.3.2       
## [29] fansi_1.0.3       scales_1.2.0      webshot_0.5.3     jsonlite_1.8.0   
## [33] sysfonts_0.8.8    farver_2.1.0      png_0.1-7         digest_0.6.29    
## [37] stringi_1.7.6     processx_3.5.3    bookdown_0.26     dplyr_1.0.9      
## [41] grid_4.2.0        cli_3.3.0         tools_4.2.0       magrittr_2.0.3   
## [45] lazyeval_0.2.2    tibble_3.1.7      crayon_1.5.1      tidyr_1.2.0      
## [49] pkgconfig_2.0.3   ellipsis_0.3.2    MASS_7.3-57       data.table_1.14.2
## [53] assertthat_0.2.1  rmarkdown_2.14    httr_1.4.3        rstudioapi_0.13  
## [57] R6_2.5.1          igraph_1.3.1      compiler_4.2.0
```
