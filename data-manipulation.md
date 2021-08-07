# 数据操作 {#chap-data-manipulation}

[data.table](https://github.com/Rdatatable/data.table) 大大加强了 [Base R](https://github.com/wch/r-source) 提供的数据操作，[poorman](https://github.com/nathaneastwood/poorman) 提供最常用的数据操作，但是不依赖 dplyr，[openxlsx](https://github.com/ycphs/openxlsx) 可以读写 XLSX 文档，[fst](https://github.com/fstpackage/fst)，[arrow](https://github.com/apache/arrow/tree/master/r) 和 [feather](https://github.com/wesm/feather/tree/master/R) 提供更加高效的数据读写性能。

[collapse](https://github.com/SebKrantz/collapse) 提供一系列高级和快速的数据操作，支持 Base R、dplyr、tibble、data.table、plm 和 sf 数据框结构类型。关键的特点有：1. 高级的统计编程，提供一系列统计函数支持在向量、矩阵和数据框上做分组和带权计算。

更多参考材料见[A data.table and dplyr tour](https://atrebas.github.io/post/2019-03-03-datatable-dplyr/)，
[Big Data in Economics: Data cleaning and wrangling](https://raw.githack.com/uo-ec510-2020-spring/lectures/master/05-datatable/05-datatable.html) 和 [DataCamp’s data.table cheatsheet](https://s3.amazonaws.com/assets.datacamp.com/img/blog/data+table+cheat+sheet.pdf)

\begin{figure}

{\centering \includegraphics[width=0.55\linewidth]{diagrams/tidyverse-vs-base-r} 

}

\caption{Tidyverse 和 Base R 的关系}(\#fig:tidyverse-vs-base-r)
\end{figure}

## apply 族 {#sec-apply-family}

Table: (\#tab:apply-functions) apply 函数

| 函数   |       输入         |         输出       |
|:------ |:------------------ |:------------------ |
| `apply()`  |  矩阵、数据框      | 向量               |
| `lapply()` |  向量、列表        | 列表               |
| `sapply()` |  向量、列表        | 向量、矩阵         |
| `mapply()` |  多个向量          | 列表               |
| `tapply()` |  数据框、数组      | 向量               |
| `vapply()` |  列表              | 矩阵               |
| `eapply()` |   列表             | 列表               |
| `rapply()` |  嵌套列表          | 嵌套列表           |

除此之外，还有 `dendrapply()` 专门处理层次聚类或分类回归树型结构， 而函数 `kernapply()` 用于时间序列的平滑处理


```r
# Reproduce example 10.4.3 from Brockwell and Davis (1991) [@Brockwell_1991_Time]
spectrum(sunspot.year, kernel = kernel("daniell", c(11, 7, 3)), log = "no")
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
samples <- mapply(rnorm,
  mean = means, sd = sds,
  MoreArgs = list(n = 10), SIMPLIFY = FALSE
)
samples
```

```
## [[1]]
##  [1]  1.37697212  1.30154837 -0.09802317 -0.13040590 -1.79653432  1.72057350
##  [7]  1.93912102  0.77062225  2.75913135  1.11736679
## 
## [[2]]
##  [1]  0.2937544  3.8185184  4.3927459  1.2568322  1.7534795  5.6000862
##  [7]  5.4079918 -4.0775292 -2.5779499  2.1166070
## 
## [[3]]
##  [1] 9.523096 6.294548 3.954661 2.780557 5.502806 3.596252 6.893524 5.810155
##  [9] 2.557700 3.331296
## 
## [[4]]
##  [1]  0.7499813  1.0251913  8.3813803 13.7414948  5.5524739  5.1625107
##  [7]  2.8576069  4.3040589  1.7588056  5.7887535
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
## [1] 0.8960372 1.7984536 5.0244596 4.9322257
```

分别计算每个样本的1，2，3 分位点


```r
lapply(samples, quantile, probs = 1:3 / 4)
```

```
## [[1]]
##       25%       50%       75% 
## 0.1191382 1.2094576 1.6346732 
## 
## [[2]]
##       25%       50%       75% 
## 0.5345238 1.9350433 4.2491890 
## 
## [[3]]
##      25%      50%      75% 
## 3.397535 4.728734 6.173450 
## 
## [[4]]
##      25%      50%      75% 
## 2.033506 4.733285 5.729684
```

仅用 `sapply()` 函数替换上面的 `lapply()`，我们可以得到一个矩阵，值得注意的是函数 `quantile()` 和 `fivenum()` 算出来的结果有一些差异


```r
sapply(samples, quantile, probs = 1:3 / 4)
```

```
##          [,1]      [,2]     [,3]     [,4]
## 25% 0.1191382 0.5345238 3.397535 2.033506
## 50% 1.2094576 1.9350433 4.728734 4.733285
## 75% 1.6346732 4.2491890 6.173450 5.729684
```

```r
vapply(samples, fivenum, c(Min. = 0, "1st Qu." = 0, Median = 0, "3rd Qu." = 0, Max. = 0))
```

```
##                [,1]       [,2]     [,3]       [,4]
## Min.    -1.79653432 -4.0775292 2.557700  0.7499813
## 1st Qu. -0.09802317  0.2937544 3.331296  1.7588056
## Median   1.20945758  1.9350433 4.728734  4.7332848
## 3rd Qu.  1.72057350  4.3927459 6.294548  5.7887535
## Max.     2.75913135  5.6000862 9.523096 13.7414948
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
dat <- aggregate(breaks ~ wool + tension, data = warpbreaks, sum) |>
  reshape(v.names = "breaks", idvar = "wool", timevar = "tension", direction = "wide", sep = "")

`colnames<-`(dat, gsub(pattern = "(breaks)", x = colnames(dat), replacement = ""))
```

```
##   wool   L   M   H
## 1    A 401 216 221
## 2    B 254 259 169
```

## 子集过滤 {#sec-subset}


```r
iris[iris$Species == "setosa" & iris$Sepal.Length > 5.5, grepl("Sepal", colnames(iris))]
```

```
##    Sepal.Length Sepal.Width
## 15          5.8         4.0
## 16          5.7         4.4
## 19          5.7         3.8
```

```r
subset(iris,
  subset = Species == "setosa" & Sepal.Length > 5.5,
  select = grepl("Sepal", colnames(iris))
)
```

```
##    Sepal.Length Sepal.Width
## 15          5.8         4.0
## 16          5.7         4.4
## 19          5.7         3.8
```

## with 选项 {#sec-option-with}

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
iris[Species == "setosa" & Sepal.Length > 5.5,
  grepl("Sepal", colnames(iris)),
  with = FALSE
]
```

```
##    Sepal.Length Sepal.Width
## 1:          5.8         4.0
## 2:          5.7         4.4
## 3:          5.7         3.8
```

不使用 with 选项，用函数 `mget()` 将字符串转变量


```r
iris[
  Species == "setosa" & Sepal.Length > 5.5,
  mget(grep("Sepal", colnames(iris), value = TRUE))
]
```

```
##    Sepal.Length Sepal.Width
## 1:          5.8         4.0
## 2:          5.7         4.4
## 3:          5.7         3.8
```

更加 data.table 风格的方式见


```r
iris[Species == "setosa" & Sepal.Length > 5.5, .SD, .SDcols = patterns("Sepal")]
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
```

```
##    x y  z
## 7  7 1 50
## 8  8 1 65
## 65 5 7 74
## 14 4 2 20
## 37 7 4 65
## 5  5 1 26
```



```r
library(ggplot2)
ggplot(df, aes(x, y, z = z)) +
  geom_contour()
```

\begin{figure}

{\centering \includegraphics{data-manipulation_files/figure-latex/with-op-1} 

}

\caption{with 操作}(\#fig:with-op)
\end{figure}

## 分组聚合 {#sec-aggregate}


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
      dt[, .(x_sum = sum(x), y_sum = sum(y)), by = mget(input$input_vars)] |>
        DT::datatable()
    },
    server = FALSE
  )
}

# 执行
shinyApp(ui = ui, server = server)
```


## 合并操作 {#sec-merge-two-tables}


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

## 长宽转换 {#sec-reshape}


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
dat <- reshape(
  data = PlantGrowth, idvar = "group", v.names = "weight",
  timevar = "id", direction = "wide",
  sep = ""
)
knitr::kable(dat,
  caption = "不同生长环境下植物的干重", row.names = FALSE,
  col.names = gsub("(weight)", "", names(dat)),
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

```
## # A tibble: 10 x 4
##       id  ctrl  trt1  trt2
##    <int> <dbl> <dbl> <dbl>
##  1     1  4.17  4.81  6.31
##  2     2  5.58  4.17  5.12
##  3     3  5.18  4.41  5.54
##  4     4  6.11  3.59  5.5 
##  5     5  4.5   5.87  5.37
##  6     6  4.61  3.83  5.29
##  7     7  5.17  6.03  4.92
##  8     8  4.53  4.89  6.15
##  9     9  5.33  4.32  5.8 
## 10    10  5.14  4.69  5.26
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

## 对符合条件的列操作 {#sec-filter-columns}


```r
# 数值型变量的列的位置
which(sapply(iris, is.numeric))
```

```
## Sepal.Length  Sepal.Width Petal.Length  Petal.Width 
##            1            2            3            4
```


```r
iris[, sapply(iris, is.numeric), with = F][Sepal.Length > 7.5]
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

用 Base R 提供的管道符号 |> 将 data.table 数据操作与 ggplot2 数据可视化连接起来


```r
library(ggplot2)
iris |>
  subset(Species == "setosa" & Sepal.Length > 5.5) |>
  # 行过滤
  # subset(select = grep("Sepal", colnames(iris), value = TRUE)) |> # 列过滤
  subset(select = grepl("Sepal", colnames(iris))) |>
  ggplot(aes(x = Sepal.Length, y = Sepal.Width)) + # 绘图
  geom_point()
```

\begin{figure}

{\centering \includegraphics{data-manipulation_files/figure-latex/pipe-dataframe-ggplot2-1} 

}

\caption{管道连接数据操作和可视化}(\#fig:pipe-dataframe-ggplot2)
\end{figure}

## `CASE WHEN` 和 `fcase` {#sec-case-when}

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

## 数据操作实战 {#sec-datatable-in-action}

[Toby Dylan Hocking](https://tdhock.github.io/) 在 useR! 2020 大会上分享的幻灯片 <https://github.com/tdhock/r-devel-emails>

## 高频数据操作 {#sec-faq-operations}

以数据集 dat 为例介绍常用的数据操作


```r
set.seed(2020)
dat <- data.frame(
  num_a = rep(seq(4), each = 4), num_b = rep(seq(4), times = 4),
  group_a = sample(x = letters[1:3], size = 16, replace = T),
  group_b = sample(x = LETTERS[1:3], size = 16, replace = T)
)
dat <- as.data.table(dat)
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

### 循环合并 {#subsec-reduce-merge}

- 问题来源 [Faster version of Reduce(merge, list(DT1,DT2,DT3,...)) called mergelist (a la rbindlist)](https://github.com/Rdatatable/data.table/issues/599)



### 分组计数 {#subsec-count-by-group}


```r
dat[, .(length(num_a)), by = .(group_a)] # dat[, .N , by = .(group_a)]
```

```
##    group_a V1
## 1:       c  2
## 2:       b  8
## 3:       a  6
```

```r
dat[, .(length(num_a)), by = .(group_b)]
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

### 分组抽样 {#subsec-sample-by-group}

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

### 分组排序 {#subsec-order-by-group}

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
dat[, .(length(!is.na(num_a))), by = .(group_a)]
```

```
##    group_a V1
## 1:       c  2
## 2:       b  8
## 3:       a  6
```

如果数据集 dat 包含重复值，考虑去掉重复值


```r
dat[, .(length(unique(num_a))), by = .(group_a)]
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
iris <- as.data.table(iris)
iris[order(-Sepal.Length), .SD[1:3], by = "Species"]
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
dat <- head(iris)
ind <- do.call(what = "order", args = dat[, c(5, 1, 2, 3)])
dat[ind, ]
```

```
##    Sepal.Length Sepal.Width Petal.Length Petal.Width Species
## 1:          4.6         3.1          1.5         0.2  setosa
## 2:          4.7         3.2          1.3         0.2  setosa
## 3:          4.9         3.0          1.4         0.2  setosa
## 4:          5.0         3.6          1.4         0.2  setosa
## 5:          5.1         3.5          1.4         0.2  setosa
## 6:          5.4         3.9          1.7         0.4  setosa
```


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

对 iris 各个列排序，依次对第 5、1、2、3 列升序排列


```r
ind <- do.call(what = "order", args = iris[,c(5,1,2,3)])
head(iris[ind, ])
```

```
##    Sepal.Length Sepal.Width Petal.Length Petal.Width Species
## 1:          4.3         3.0          1.1         0.1  setosa
## 2:          4.4         2.9          1.4         0.2  setosa
## 3:          4.4         3.0          1.3         0.2  setosa
## 4:          4.4         3.2          1.3         0.2  setosa
## 5:          4.5         2.3          1.3         0.3  setosa
## 6:          4.6         3.1          1.5         0.2  setosa
```
\begin{table}
\caption{(\#tab:column-order)iris 数据集原顺序（左）和新顺序（右）}

\centering
\begin{tabular}[t]{rrrrl}
\toprule
Sepal.Length & Sepal.Width & Petal.Length & Petal.Width & Species\\
\midrule
5.1 & 3.5 & 1.4 & 0.2 & setosa\\
4.9 & 3.0 & 1.4 & 0.2 & setosa\\
4.7 & 3.2 & 1.3 & 0.2 & setosa\\
4.6 & 3.1 & 1.5 & 0.2 & setosa\\
5.0 & 3.6 & 1.4 & 0.2 & setosa\\
\addlinespace
5.4 & 3.9 & 1.7 & 0.4 & setosa\\
\bottomrule
\end{tabular}
\centering
\begin{tabular}[t]{rrrrl}
\toprule
Sepal.Length & Sepal.Width & Petal.Length & Petal.Width & Species\\
\midrule
4.3 & 3.0 & 1.1 & 0.1 & setosa\\
4.4 & 2.9 & 1.4 & 0.2 & setosa\\
4.4 & 3.0 & 1.3 & 0.2 & setosa\\
4.4 & 3.2 & 1.3 & 0.2 & setosa\\
4.5 & 2.3 & 1.3 & 0.3 & setosa\\
\addlinespace
4.6 & 3.1 & 1.5 & 0.2 & setosa\\
\bottomrule
\end{tabular}
\end{table}

