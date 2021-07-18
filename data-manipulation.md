# 数据操作 {#chap:data-manipulation}


```r
library(magrittr)
```

[data.table](https://github.com/Rdatatable/data.table) 大大加强了 [Base R](https://github.com/wch/r-source) 提供的数据操作，[poorman](https://github.com/nathaneastwood/poorman) 提供最常用的数据操作，但是不依赖 dplyr，[openxlsx](https://github.com/ycphs/openxlsx) 可以读写 XLSX 文档，[fst](https://github.com/fstpackage/fst)，[arrow](https://github.com/apache/arrow/tree/master/r) 和 [feather](https://github.com/wesm/feather/tree/master/R) 提供更加高效的数据读写性能。

更多参考材料见[A data.table and dplyr tour](https://atrebas.github.io/post/2019-03-03-datatable-dplyr/)，
[Big Data in Economics: Data cleaning and wrangling](https://raw.githack.com/uo-ec510-2020-spring/lectures/master/05-datatable/05-datatable.html) 和 [DataCamp’s data.table cheatsheet](https://s3.amazonaws.com/assets.datacamp.com/img/blog/data+table+cheat+sheet.pdf)

\begin{figure}

{\centering \includegraphics[width=0.75\linewidth]{diagrams/tidyverse-vs-base-r} 

}

\caption{Tidyverse 和 Base R 的关系}(\#fig:tidyverse-vs-base-r)
\end{figure}

## apply 族 {#sec:apply-family}

| 函数 |  输入 |  输出 |
|:------ |:------------------ |:------------------ |
| apply  |  矩阵、数据框      | 向量               |
| lapply |  向量、列表        | 列表               |
| sapply |  向量、列表        | 向量、矩阵         |
| mapply |  多个向量          | 列表               |
| tapply |  数据框、数组      | 向量               |
| vapply |  列表              | 矩阵               |
| eapply |   列表             | 列表               |
| rapply |  嵌套列表          | 嵌套列表           |

除此之外，还有 `dendrapply()` 专门处理层次聚类或分类回归树型结构， 而函数 `kernapply()` 用于时间序列的平滑处理


```r
# Reproduce example 10.4.3 from Brockwell and Davis (1991) [@Brockwell_1991_Time]
spectrum(sunspot.year, kernel = kernel("daniell", c(11,7,3)), log = "no")
```

\begin{figure}

{\centering \includegraphics{data-manipulation_files/figure-latex/spectrum-sunspot-year-1} 

}

\caption{太阳黑子的频谱}(\#fig:spectrum-sunspot-year)
\end{figure}

<!-- https://design.tidyverse.org/cs-mapply-pmap.html -->

将函数应用到多个向量，返回一个列表，生成四组服从正态分布 $\mathcal{N}(\mu_i,\sigma_i)$ 的随机数，它们的均值和方差依次是 $\mu_i = \sigma_i = 1 \ldots 4$


```r
means <- 1:4
sds <- 1:4
set.seed(2020)
samples <- mapply(rnorm, mean = means, sd = sds, MoreArgs = list(n = 50), SIMPLIFY = FALSE)
samples
```

```
## [[1]]
##  [1]  1.37697212  1.30154837 -0.09802317 -0.13040590 -1.79653432  1.72057350
##  [7]  1.93912102  0.77062225  2.75913135  1.11736679  0.14687718  1.90925918
## [13]  2.19637296  0.62841610  0.87673977  2.80004312  2.70399588 -2.03876461
## [19] -1.28897495  1.05830349  3.17436525  2.09818265  1.31822032  0.92685244
## [25]  1.83426874  1.19875064  2.29784138  1.93671831  0.85256681  1.11043199
## [31]  0.18749534  0.25629783  2.09534507  3.43537371  1.38811847  1.29062767
## [37]  0.71440171  1.07601472  0.43970140  1.44718837  1.90850113  0.49494040
## [43]  0.69899599  0.27396402 -0.18007703  1.25307471  0.62928870  1.02217956
## [49]  1.66004412  1.48879364
## 
## [[2]]
##  [1]  1.62242017  3.20271904  0.65247989  2.95210048  2.23750646  2.24245257
##  [7]  1.62790641 -0.65654238  0.86615410  3.15766787  5.81807446  2.50151409
## [13] -1.19663012  8.40326349  3.91047075  2.73728923  3.84583814  1.58895731
## [19]  2.18593340  2.33652436  3.59167825  5.29201121 -1.43384863  1.36331379
## [25]  0.19172006  0.59201441 -1.55619892  0.55548967  2.09230842  2.48731604
## [31]  3.25666261  1.95072284  6.62830662  2.35442051 -0.04882953  6.54936260
## [37] -1.77811333  4.18790320  5.69233405  3.04206535 -1.06592422 -1.87872994
## [43]  2.97383308  4.49047338  1.56545315  0.44081377  2.69774900  3.36344850
## [49]  0.93707723  0.64521316
## 
## [[3]]
##  [1] -2.18635182  0.02621703  1.24348331  4.15056524  5.23999476  0.21473726
##  [7]  1.98547111  7.63534205  3.79952663  3.89860180  2.03159394  7.30604230
## [13]  6.01958161 -2.15824091  3.89676139  0.52582309 -0.59876950 -0.82916135
## [19]  2.63046580  9.49782660  2.06315108  4.10231768  6.80831778 -3.79456152
## [25] -0.86954973  3.56365781  5.25492857  8.35404401  7.52481521  0.14051487
## [31]  3.31026822  1.18331851  2.70719812  2.62965568 -0.13403855  2.77538898
## [37]  8.28040600 -1.29635876 10.98660308 -0.87357460  3.04530532  2.88095828
## [43]  9.57432097 -2.92931265  4.39099699  2.21336353 -0.40714352  3.63389844
## [49]  3.29828378 -6.17005096
## 
## [[4]]
##  [1]  2.6114534 -3.7865046  3.1356934 -1.7967859  5.3817362  4.7528096
##  [7] -0.5114111  4.2018014  1.2692036  6.5922153  6.4414579  1.9493723
## [13]  7.0176236  4.7524199 -3.7131425  8.9432854  5.3131093  0.5803420
## [19] -3.5827529  7.3867697  8.9761004  4.9450398  0.9572258  7.0888838
## [25]  6.6462270 -2.3749335 -4.7613877 -0.7070158  8.2000205  3.9771877
## [31]  2.8959507  7.3940852 -0.1957386 -2.9343453 13.6565563  3.2174329
## [37]  7.7071478  1.1461455 -1.1989669  7.5371856  8.8025661 -0.6813591
## [43]  7.0458875  7.4803610  1.0910292  6.5064829 -0.3657709  1.9356219
## [49]  4.0677359  6.6439628
```

我们借用图\@ref(fig:mapply-lapply)来看一下 mapply 的效果，多组随机数生成非常有助于快速模拟。


```r
par(mfrow = c(2, 2), mar = c(2, 2, 2, 2))
invisible(lapply(samples, function(x) {
  plot(x, pch = 16, col = "grey")
  abline(h = mean(x), lwd = 2, col = "darkorange")
}))
```

\begin{figure}

{\centering \includegraphics{data-manipulation_files/figure-latex/mapply-lapply-1} 

}

\caption{ lapply 函数}(\#fig:mapply-lapply)
\end{figure}

分别计算每个样本的平均值


```r
sapply(samples, mean)
```

```
## [1] 1.125622 2.184323 2.731533 3.432760
```

分别计算每个样本的1，2，3 分位点


```r
lapply(samples, quantile, probs = 1:3/4)
```

```
## [[1]]
##       25%       50%       75% 
## 0.6286342 1.1580587 1.8899430 
## 
## [[2]]
##       25%       50%       75% 
## 0.6470298 2.2399795 3.2431767 
## 
## [[3]]
##        25%        50%        75% 
## 0.05479149 2.74129355 4.33088906 
## 
## [[4]]
##          25%          50%          75% 
## -0.001718463  4.022461769  6.924774426
```

仅用 `sapply()` 函数替换上面的 `lapply()`，我们可以得到一个矩阵，值得注意的是函数 `quantile()` 和 `fivenum()` 算出来的结果有一些差异


```r
sapply(samples, quantile, probs = 1:3/4)
```

```
##          [,1]      [,2]       [,3]         [,4]
## 25% 0.6286342 0.6470298 0.05479149 -0.001718463
## 50% 1.1580587 2.2399795 2.74129355  4.022461769
## 75% 1.8899430 3.2431767 4.33088906  6.924774426
```

```r
vapply(samples, fivenum, c(Min. = 0, "1st Qu." = 0, Median = 0, "3rd Qu." = 0, Max. = 0))
```

```
##               [,1]       [,2]        [,3]       [,4]
## Min.    -2.0387646 -1.8787299 -6.17005096 -4.7613877
## 1st Qu.  0.6284161  0.6452132  0.02621703 -0.1957386
## Median   1.1580587  2.2399795  2.74129355  4.0224618
## 3rd Qu.  1.9085011  3.2566626  4.39099699  7.0176236
## Max.     3.4353737  8.4032635 10.98660308 13.6565563
```

vapply 和 sapply 类似，但是预先指定返回值类型，这样可以更加安全，有时也更快。

以数据集 presidents 为例，它是一个 ts 对象类型的时间序列数据，记录了 1945 年至 1974 年每个季度美国总统的支持率，这组数据中存在缺失值，以 NA 表示。支持率的变化趋势见图 \@ref(fig:usa-presidents)。


```r
plot(presidents)
```

\begin{figure}

{\centering \includegraphics{data-manipulation_files/figure-latex/usa-presidents-1} 

}

\caption{1945-1974美国总统的支持率}(\#fig:usa-presidents)
\end{figure}

计算这 30 年每个季度的平均支持率


```r
tapply(presidents, cycle(presidents), mean, na.rm = TRUE)
```

```
##        1        2        3        4 
## 58.44828 56.43333 57.22222 53.07143
```

`cycle()` 函数计算序列中每个观察值在周期中的位置，presidents 的周期为 4，根据位置划分组，然后分组求平均，也可以化作如下计算步骤，虽然看起来复杂，但是数据操作的过程很清晰，不再看起来像是一个黑箱。


```r
# Base R
cbind(expand.grid(quarter = c("Qtr1", "Qtr2", "Qtr3", "Qtr4"), year = 1945:1974), rate = as.vector(presidents)) %>%
  reshape(., v.names = "rate", idvar = "year", timevar = "quarter", direction = "wide", sep = "") %>%
  `colnames<-`(., gsub(pattern = "(rate)", x = colnames(.), replacement =  "")) %>% 
  `[`(., -1) %>% 
  apply(., 2, mean, na.rm = TRUE)
```

```
##     Qtr1     Qtr2     Qtr3     Qtr4 
## 58.44828 56.43333 57.22222 53.07143
```

tapply 函数来做分组求和


```r
# 一个变量分组求和
tapply(warpbreaks$breaks, warpbreaks[, 3, drop = FALSE], sum)
```

```
## tension
##   L   M   H 
## 655 475 390
```

```r
# 两个变量分组计数
with(warpbreaks, table(wool, tension))
```

```
##     tension
## wool L M H
##    A 9 9 9
##    B 9 9 9
```

```r
# 两个变量分组求和
aggregate(breaks ~ wool + tension, data = warpbreaks,  sum) %>% 
  reshape(., v.names = "breaks", idvar = "wool", timevar = "tension", direction = "wide", sep = "") %>% 
  `colnames<-`(., gsub(pattern = "(breaks)", x = colnames(.), replacement =  ""))
```

```
##   wool   L   M   H
## 1    A 401 216 221
## 2    B 254 259 169
```

## 子集过滤 {#sec:subset}


```r
iris[iris$Species == 'setosa' & iris$Sepal.Length > 5.5, grepl('Sepal', colnames(iris))]
```

```
##    Sepal.Length Sepal.Width
## 15          5.8         4.0
## 16          5.7         4.4
## 19          5.7         3.8
```

```r
subset(iris, subset = Species == 'setosa' & Sepal.Length > 5.5, select = grepl('Sepal', colnames(iris)))
```

```
##    Sepal.Length Sepal.Width
## 15          5.8         4.0
## 16          5.7         4.4
## 19          5.7         3.8
```

## with 选项 {#sec:option-with}

注意 data.table 与 Base R 不同的地方


```r
# https://github.com/Rdatatable/data.table/issues/4513
# https://d.cosx.org/d/421532-datatable-base-r
library(data.table)
iris <- as.data.table(iris)
```


```r
iris[Species == "setosa" & Sepal.Length > 5.5, grepl("Sepal", colnames(iris))]
```

```
## [1]  TRUE  TRUE FALSE FALSE FALSE
```

需要使用 `with = FALSE` 选项


```r
iris[Species == "setosa" & Sepal.Length > 5.5, grepl("Sepal", colnames(iris)), with = FALSE]
```

```
##    Sepal.Length Sepal.Width
## 1:          5.8         4.0
## 2:          5.7         4.4
## 3:          5.7         3.8
```

不使用 with 选项，用函数 `mget()` 将字符串转变量


```r
iris[Species == "setosa" & Sepal.Length > 5.5, mget(grep("Sepal", colnames(iris), value = TRUE))]
```

```
##    Sepal.Length Sepal.Width
## 1:          5.8         4.0
## 2:          5.7         4.4
## 3:          5.7         3.8
```

更加 data.table 风格的方式见


```r
iris[Species == 'setosa' & Sepal.Length > 5.5, .SD, .SDcols = patterns('Sepal')]
```

```
##    Sepal.Length Sepal.Width
## 1:          5.8         4.0
## 2:          5.7         4.4
## 3:          5.7         3.8
```

with 还可以这样用，直接修改、添加一列


```r
df <- expand.grid(x = 1:10, y = 1:10)
df$z <- with(df, x^2 + y^2)
df <- subset(df, z < 100)
df <- df[sample(nrow(df)), ]
head(df)

library(ggplot2)
ggplot(df, aes(x, y, z = z)) +
  geom_contour()
```

## 分组聚合 {#sec:aggregate}


```r
methods("aggregate")
```

```
## [1] aggregate.data.frame aggregate.default*   aggregate.formula*  
## [4] aggregate.ts        
## see '?methods' for accessing help and source code
```

```r
args("aggregate.data.frame")
```

```
## function (x, by, FUN, ..., simplify = TRUE, drop = TRUE) 
## NULL
```

```r
args("aggregate.ts")
```

```
## function (x, nfrequency = 1, FUN = sum, ndeltat = 1, ts.eps = getOption("ts.eps"), 
##     ...) 
## NULL
```

```r
# getAnywhere(aggregate.formula)
```

按 Species 分组，对 Sepal.Length 中大于平均值的数取平均


```r
aggregate(Sepal.Length ~ Species, iris, function(x) mean(x[x > mean(x)]))
```

```
##      Species Sepal.Length
## 1     setosa     5.313636
## 2 versicolor     6.375000
## 3  virginica     7.159091
```


```r
library(data.table)

dt <- data.table(
  x = rep(1:3, each = 3), y = rep(1:3, 3),
  z = rep(c("A", "B", "C"), 3), w = rep(c("a", "b", "a"), each = 3)
)

dt[, .(x_sum = sum(x), y_sum = sum(y)), by = .(z, w)]
```

```
##    z w x_sum y_sum
## 1: A a     4     2
## 2: B a     4     4
## 3: C a     4     6
## 4: A b     2     1
## 5: B b     2     2
## 6: C b     2     3
```

```r
dt[, .(x_sum = sum(x), y_sum = sum(y)), by = mget(c("z", "w"))]
```

```
##    z w x_sum y_sum
## 1: A a     4     2
## 2: B a     4     4
## 3: C a     4     6
## 4: A b     2     1
## 5: B b     2     2
## 6: C b     2     3
```

shiny 前端传递字符串向量，借助 `mget()` 函数根据选择的变量分组统计计算，只有一个变量可以使用 `get()` 传递变量给 data.table


```r
library(shiny)

ui <- fluidPage(
  fluidRow(
    column(
      6,
      selectInput("input_vars",
        label = "变量", # 给筛选框取名
        choices = c(z = "z", w = "w"), # 待选的值
        selected = "z", # 指定默认值
        multiple = TRUE # 允许多选
      ),
      DT::dataTableOutput("output_table")
    )
  )
)

library(data.table)
library(magrittr)

dt <- data.table(
  x = rep(1:3, each = 3), y = rep(1:3, 3),
  z = rep(c("A", "B", "C"), 3), w = rep(c("a", "b", "a"), each = 3)
)

server <- function(input, output, session) {
  output$output_table <- DT::renderDataTable(
    {
      dt[, .(x_sum = sum(x), y_sum = sum(y)), by = mget(input$input_vars)] %>%
        DT::datatable()
    },
    server = FALSE
  )
}

# 执行
shinyApp(ui = ui, server = server)
```

reactable 制作表格


```r
library(shiny)
library(reactable)

ui <- fluidPage(
  reactableOutput("table")
)

server <- function(input, output) {
  output$table <- renderReactable({
    reactable(iris,
      filterable = TRUE, # 过滤
      searchable = TRUE, # 搜索
      showPageSizeOptions = TRUE, # 页面大小
      pageSizeOptions = c(5, 10, 15), # 页面大小可选项
      defaultPageSize = 10, # 默认显示10行
      highlight = TRUE, # 高亮选择
      striped = TRUE, # 隔行高亮
      fullWidth = FALSE, # 默认不要全宽填充，适应数据框的宽度
      defaultSorted = list(
        Sepal.Length = "asc", # 由小到大排序
        Petal.Length = "desc" # 由大到小
      ),
      columns = list(
        Sepal.Width = colDef(style = function(value) { # Sepal.Width 添加颜色标记
          if (value > 3.5) {
            color <- "#008000"
          } else if (value > 2) {
            color <- "#e00000"
          } else {
            color <- "#777"
          }
          list(color = color, fontWeight = "bold")
        })

      )
    )
  })
}

shinyApp(ui, server)
```


```r
# 修改自 Code: https://gist.github.com/jthomasmock/f085dce3e70e42ca49b052bbe25de49f
library(magrittr)
library(reactable)
library(htmltools)

# barchart function from: https://glin.github.io/reactable/articles/building-twitter-followers.html
bar_chart <- function(label, width = "100%", height = "14px", fill = "#00bfc4", background = NULL) {
  bar <- div(style = list(background = fill, width = width, height = height))
  chart <- div(style = list(flexGrow = 1, marginLeft = "6px", background = background), bar)
  div(style = list(display = "flex", alignItems = "center"), label, chart)
}

data <- mtcars %>% 
  subset(select = c("cyl", "mpg")) %>%
  subset(subset = sample(x = c(TRUE, FALSE), size = 6, replace = T))


reactable(
  data,
  defaultPageSize = 20,
  columns = list(
    cyl = colDef(align = "center"),
    mpg = colDef(
      name = "mpg",
      defaultSortOrder = "desc",
      minWidth = 250,
      cell = function(value, index) {
        width <- paste0(value * 100 / max(mtcars$mpg), "%")
        value <- format(value, width = 9, justify = "right", nsmall = 1)
        
        # output the value of another column 
        # that aligns with current value
        cyl_val <- data$cyl[index]

        # Color based on the row's cyl value
        color_fill <- if (cyl_val == 4) {
          "#3686d3" # blue
        } else if (cyl_val == 6) {
          "#88398a" # purple
        } else {
          "#fcab27" # orange
        }
        bar_chart(value, width = width, fill = color_fill, background = "#e1e1e1")
      },
      align = "left",
      style = list(fontFamily = "monospace", whiteSpace = "pre")
    )
  )
)
```

## 合并操作 {#sec:merge-two-tables}


```r
dat1 <- data.frame(x = c(0, 0, 10, 10, 20, 20, 30, 30), y = c(1, 1, 2, 2, 3, 3, 4, 4))
dat2 <- data.frame(x = c(0, 10, 20, 30), z = c(3, 4, 5, 6))

data.frame(dat1, z = dat2$z[match(dat1$x, dat2$x)])
```

```
##    x y z
## 1  0 1 3
## 2  0 1 3
## 3 10 2 4
## 4 10 2 4
## 5 20 3 5
## 6 20 3 5
## 7 30 4 6
## 8 30 4 6
```

```r
merge(dat1, dat2)
```

```
##    x y z
## 1  0 1 3
## 2  0 1 3
## 3 10 2 4
## 4 10 2 4
## 5 20 3 5
## 6 20 3 5
## 7 30 4 6
## 8 30 4 6
```

保留两个数据集中的所有行

## 长宽转换 {#sec:reshape}


```r
args("reshape")
```

```
## function (data, varying = NULL, v.names = NULL, timevar = "time", 
##     idvar = "id", ids = 1L:NROW(data), times = seq_along(varying[[1L]]), 
##     drop = NULL, direction, new.row.names = NULL, sep = ".", 
##     split = if (sep == "") {
##         list(regexp = "[A-Za-z][0-9]", include = TRUE)
##     } else {
##         list(regexp = sep, include = FALSE, fixed = TRUE)
##     }) 
## NULL
```

PlantGrowth 数据集的重塑操作也可以使用内置的函数 `reshape()` 实现


```r
PlantGrowth$id <- rep(1:10, 3)
reshape(
  data = PlantGrowth, idvar = "group", v.names = "weight",
  timevar = "id", direction = "wide",
  sep = ""
) %>% 
knitr::kable(.,
  caption = "不同生长环境下植物的干重", row.names = FALSE,
  col.names = gsub("(weight)", "", names(.)),
  align = "c"
)
```

\begin{table}

\caption{(\#tab:data-frame-PlantGrowth)不同生长环境下植物的干重}
\centering
\begin{tabular}[t]{c|c|c|c|c|c|c|c|c|c|c}
\hline
group & 1 & 2 & 3 & 4 & 5 & 6 & 7 & 8 & 9 & 10\\
\hline
ctrl & 4.17 & 5.58 & 5.18 & 6.11 & 4.50 & 4.61 & 5.17 & 4.53 & 5.33 & 5.14\\
\hline
trt1 & 4.81 & 4.17 & 4.41 & 3.59 & 5.87 & 3.83 & 6.03 & 4.89 & 4.32 & 4.69\\
\hline
trt2 & 6.31 & 5.12 & 5.54 & 5.50 & 5.37 & 5.29 & 4.92 & 6.15 & 5.80 & 5.26\\
\hline
\end{tabular}
\end{table}

或者，我们也可以使用 **tidyr** 包提供的 `pivot_wider()` 函数


```r
tidyr::pivot_wider(
  data = PlantGrowth, id_cols = id,
  names_from = group, values_from = weight
)
```

或者，我们还可以使用 **data.table** 包提供的 `dcast()` 函数，用于将长格式的数据框重塑为宽格式的


```r
PlantGrowth_DT <- as.data.table(PlantGrowth)
# 纵
dcast(PlantGrowth_DT, id ~ group, value.var = "weight")
```

```
##     id ctrl trt1 trt2
##  1:  1 4.17 4.81 6.31
##  2:  2 5.58 4.17 5.12
##  3:  3 5.18 4.41 5.54
##  4:  4 6.11 3.59 5.50
##  5:  5 4.50 5.87 5.37
##  6:  6 4.61 3.83 5.29
##  7:  7 5.17 6.03 4.92
##  8:  8 4.53 4.89 6.15
##  9:  9 5.33 4.32 5.80
## 10: 10 5.14 4.69 5.26
```

```r
# 横
dcast(PlantGrowth_DT, group ~ id, value.var = "weight")
```

```
##    group    1    2    3    4    5    6    7    8    9   10
## 1:  ctrl 4.17 5.58 5.18 6.11 4.50 4.61 5.17 4.53 5.33 5.14
## 2:  trt1 4.81 4.17 4.41 3.59 5.87 3.83 6.03 4.89 4.32 4.69
## 3:  trt2 6.31 5.12 5.54 5.50 5.37 5.29 4.92 6.15 5.80 5.26
```

## 对符合条件的列操作 {#sec:filter-columns}


```r
# 数值型变量的列的位置
which(sapply(iris, is.numeric))
```

```
## Sepal.Length  Sepal.Width Petal.Length  Petal.Width 
##            1            2            3            4
```


```r
iris[,sapply(iris, is.numeric), with = F][Sepal.Length > 7.5]
```

```
##    Sepal.Length Sepal.Width Petal.Length Petal.Width
## 1:          7.6         3.0          6.6         2.1
## 2:          7.7         3.8          6.7         2.2
## 3:          7.7         2.6          6.9         2.3
## 4:          7.7         2.8          6.7         2.0
## 5:          7.9         3.8          6.4         2.0
## 6:          7.7         3.0          6.1         2.3
```


```r
class(iris)
```

```
## [1] "data.table" "data.frame"
```

用 magrittr 提供的管道符号连接 data.table 的数据操作与 ggplot2 的数据可视化


```r
library(ggplot2)
iris %>%
  as.data.table(.) %>%
  .[Species == "setosa"] %>% # 行过滤
  .[Sepal.Length > 5.5] %>% # 行过滤
  .[, mget(grep("Sepal", colnames(.), value = TRUE))] %>% # 列过滤
  # .[, grepl("Sepal", colnames(.)), with = FALSE] %>%
  ggplot(aes(x = Sepal.Length, y = Sepal.Width)) + # 绘图
  geom_point()
```



\begin{center}\includegraphics{data-manipulation_files/figure-latex/datatable-ggplot2-1} \end{center}

## `CASE WHEN` 和 `fcase` {#sec:case-when}

`CASE WHEN` 是 SQL 中的条件判断语句，**data.table** 中的函数 `fcase()` 可与之等价。值得注意的是，`fcase()` 需要 **data.table** 版本 1.13.0 及以上。


```r
dat <- data.table(
  weights = c(56.8, 57.2, 46.3, 38.5),
  gender = c("1", "0", "", "0")
)
# 1 表示男，0表示女，空表示未知
transform(dat, gender_cn = fcase(
  gender == "1", "男",
  gender == "0", "女",
  gender == "", "未知"
))
```

```
##    weights gender gender_cn
## 1:    56.8      1        男
## 2:    57.2      0        女
## 3:    46.3             未知
## 4:    38.5      0        女
```

## 数据操作实战 {#sec:datatable-in-action}

[Toby Dylan Hocking](https://tdhock.github.io/) 在 useR! 2020 大会上分享的幻灯片 <https://github.com/tdhock/r-devel-emails>

## 高频数据操作 {#sec:faq-operations}

以数据集 dat 为例介绍常用的数据操作


```r
set.seed(2020)
dat = data.frame(num_a = rep(seq(4), each = 4), num_b = rep(seq(4), times = 4), 
                 group_a = sample(x = letters[1:3], size = 16, replace = T), 
                 group_b = sample(x = LETTERS[1:3], size = 16, replace = T))
dat = as.data.table(dat)
dat
```

```
##     num_a num_b group_a group_b
##  1:     1     1       c       B
##  2:     1     2       b       B
##  3:     1     3       a       B
##  4:     1     4       a       C
##  5:     2     1       b       B
##  6:     2     2       b       C
##  7:     2     3       a       B
##  8:     2     4       a       A
##  9:     3     1       b       C
## 10:     3     2       b       B
## 11:     3     3       b       B
## 12:     3     4       a       B
## 13:     4     1       b       C
## 14:     4     2       c       B
## 15:     4     3       b       C
## 16:     4     4       a       C
```

### 循环合并 {#subsec:reduce-merge}

- 问题来源 [Faster version of Reduce(merge, list(DT1,DT2,DT3,...)) called mergelist (a la rbindlist)](https://github.com/Rdatatable/data.table/issues/599)



### 分组计数 {#subsec:count-by-group}


```r
dat[, .(length(num_a)) , by = .(group_a)] # dat[, .N , by = .(group_a)]
```

```
##    group_a V1
## 1:       c  2
## 2:       b  8
## 3:       a  6
```

```r
dat[, .(length(num_a)) , by = .(group_b)]
```

```
##    group_b V1
## 1:       B  9
## 2:       C  6
## 3:       A  1
```

```r
dat[, .(length(num_a)), by = .(group_a, group_b)]
```

```
##    group_a group_b V1
## 1:       c       B  2
## 2:       b       B  4
## 3:       a       B  3
## 4:       a       C  2
## 5:       b       C  4
## 6:       a       A  1
```

### 分组抽样 {#subsec:sample-by-group}

以 `group_a` 为组别， a、 b、 c 分别有 6、 8、 2 条记录


```r
# 无放回的抽样
dt_sample_1 <- dat[, .SD[sample(x = .N, size = 2, replace = FALSE)], by = group_a]
# 有放回的随机抽样
dt_sample_2 <- dat[, .SD[sample(x = .N, size = 3, replace = TRUE)], by = group_a]
```

可能存在该组样本不平衡，有的组的样本量不足你想要的样本量。每个组无放回地抽取 4 个样本，如果该组样本量不足 4，则全部抽取全部样本量。


```r
dat[, .SD[sample(x = .N, size = min(4, .N))], by = group_a]
```

```
##     group_a num_a num_b group_b
##  1:       c     1     1       B
##  2:       c     4     2       B
##  3:       b     3     2       B
##  4:       b     2     2       C
##  5:       b     2     1       B
##  6:       b     3     3       B
##  7:       a     1     3       B
##  8:       a     2     3       B
##  9:       a     2     4       A
## 10:       a     1     4       C
```

还可以按照指定的比例抽取样本量 [^sample-by-group]

[^sample-by-group]: https://stackoverflow.com/questions/18258690/take-randomly-sample-based-on-groups

### 分组排序 {#subsec:order-by-group}

data.table 包的分组排序问题 <https://d.cosx.org/d/421650-datatable/3>


```r
dat[with(dat, order(-ave(num_a, group_a, FUN = max), -num_a)), ]
```

```
##     num_a num_b group_a group_b
##  1:     4     1       b       C
##  2:     4     2       c       B
##  3:     4     3       b       C
##  4:     4     4       a       C
##  5:     3     1       b       C
##  6:     3     2       b       B
##  7:     3     3       b       B
##  8:     3     4       a       B
##  9:     2     1       b       B
## 10:     2     2       b       C
## 11:     2     3       a       B
## 12:     2     4       a       A
## 13:     1     1       c       B
## 14:     1     2       b       B
## 15:     1     3       a       B
## 16:     1     4       a       C
```

```r
# num_a 降序排列，然后对 group_a 升序排列
dat[with(dat, order(-num_a, group_a)), ]
```

```
##     num_a num_b group_a group_b
##  1:     4     4       a       C
##  2:     4     1       b       C
##  3:     4     3       b       C
##  4:     4     2       c       B
##  5:     3     4       a       B
##  6:     3     1       b       C
##  7:     3     2       b       B
##  8:     3     3       b       B
##  9:     2     3       a       B
## 10:     2     4       a       A
## 11:     2     1       b       B
## 12:     2     2       b       C
## 13:     1     3       a       B
## 14:     1     4       a       C
## 15:     1     2       b       B
## 16:     1     1       c       B
```

```r
# 简写
dat[order(-num_a, group_a)]
```

```
##     num_a num_b group_a group_b
##  1:     4     4       a       C
##  2:     4     1       b       C
##  3:     4     3       b       C
##  4:     4     2       c       B
##  5:     3     4       a       B
##  6:     3     1       b       C
##  7:     3     2       b       B
##  8:     3     3       b       B
##  9:     2     3       a       B
## 10:     2     4       a       A
## 11:     2     1       b       B
## 12:     2     2       b       C
## 13:     1     3       a       B
## 14:     1     4       a       C
## 15:     1     2       b       B
## 16:     1     1       c       B
```

`setorder()` 函数直接修改原始数据记录的排序


```r
setorder(dat, -num_a, group_a)
```

参考多个列分组排序 [^sort-by-group]

[^sort-by-group]: <https://stackoverflow.com/questions/1296646/how-to-sort-a-dataframe-by-multiple-columns>

::: {.rmdtip data-latex="{提示}"}

如果数据集 dat 包含缺失值，考虑去掉缺失值


```r
dat[, .(length(!is.na(num_a))) , by = .(group_a)]
```

```
##    group_a V1
## 1:       c  2
## 2:       b  8
## 3:       a  6
```

如果数据集 dat 包含重复值，考虑去掉重复值


```r
dat[, .(length(unique(num_a))) , by = .(group_a)]
```

```
##    group_a V1
## 1:       c  2
## 2:       b  4
## 3:       a  4
```

:::

按 Species 分组，对 Sepal.Length 降序排列，取 Top 3


```r
iris = as.data.table(iris)
iris[order(-Sepal.Length), .SD[1:3], by="Species"]
```

```
##       Species Sepal.Length Sepal.Width Petal.Length Petal.Width
## 1:  virginica          7.9         3.8          6.4         2.0
## 2:  virginica          7.7         3.8          6.7         2.2
## 3:  virginica          7.7         2.6          6.9         2.3
## 4: versicolor          7.0         3.2          4.7         1.4
## 5: versicolor          6.9         3.1          4.9         1.5
## 6: versicolor          6.8         2.8          4.8         1.4
## 7:     setosa          5.8         4.0          1.2         0.2
## 8:     setosa          5.7         4.4          1.5         0.4
## 9:     setosa          5.7         3.8          1.7         0.3
```

对 iris 各个列排序


```r
ind <- do.call(what = "order", args = iris[,c(5,1,2,3)])
iris[ind, ]
```

```
##      Sepal.Length Sepal.Width Petal.Length Petal.Width   Species
##   1:          4.3         3.0          1.1         0.1    setosa
##   2:          4.4         2.9          1.4         0.2    setosa
##   3:          4.4         3.0          1.3         0.2    setosa
##   4:          4.4         3.2          1.3         0.2    setosa
##   5:          4.5         2.3          1.3         0.3    setosa
##  ---                                                            
## 146:          7.7         2.6          6.9         2.3 virginica
## 147:          7.7         2.8          6.7         2.0 virginica
## 148:          7.7         3.0          6.1         2.3 virginica
## 149:          7.7         3.8          6.7         2.2 virginica
## 150:          7.9         3.8          6.4         2.0 virginica
```


