# 净土化操作 {#chap-dplyr-manipulation}


```r
library(dplyr)
```

<!--
[Jozef Hajnala](https://jozef.io/categories/rcase4base/) 博文。

[Malcolm Barrett](https://malco.io/) 以幻灯片的形式呈现 [dplyr](https://malco.io/slides/hs_dplyr/) 和 [purrr](https://malco.io/slides/hs_purrr/) 的基础用法

Charlotte Wickham 的课程 A introduction to purrr [purrr-tutorial](https://github.com/cwickham/purrr-tutorial)

关于引用 [quotation](https://github.com/cwickham/quotation)

相比于 SQL， dplyr 在数据库操作的不足 <https://dbi.r-dbi.org/articles/dbi-1#sec:open-issues>

函数式编程 Functional Programming Languages 用于数据处理

- [rpivotTable](https://github.com/smartinsightsfromdata/rpivotTable) 动态数据透视表
- [fuzzyjoin](https://github.com/dgrtwo/fuzzyjoin) Join tables together on inexact matching
- [dtplyr](https://github.com/hadley/dtplyr) dtplyr is the data.table backend for dplyr. It provides S3 methods for data.table objects so that dplyr works the way you expect.
- [bplyr](https://github.com/yonicd/bplyr) basic dplyr and tidyr functionality without the tidyverse dependencies 
- [SqlRender](https://github.com/OHDSI/SqlRender) 基于 Java 语言，借助 rJava 包支持参数化的 SQL 语句，并且可以将一种 SQL 语句（如 Microsoft SQL Server）转化为多种SQL语句（如Oracle, PostgreSQL, Amazon RedShift, Impala, IBM Netezza, Google BigQuery, Microsoft PDW, and SQLite）
- [fastmap](https://github.com/wch/fastmap) 实现键值存储，提供新的数据结构
- [Roaring bitmaps](https://github.com/RoaringBitmap/CRoaring) Bitsets, also called bitmaps, are commonly used as fast data structures.


数据操作的语法

第一代

1. Base R 数据操作已在第 \@ref(chap-data-manipulation) 章详细介绍

第二代

1. reshape （退休）使用函数 `melt` 和 `cast` 重构(restructure)和聚合(aggregate)数据 
1. reshape2 （退休）是 reshape 的继任者，功能和 reshape 类似，提供两个函数 `melt` 和 `cast` 聚合数据，因此不再介绍 reshape，而鉴于 reshape2 还在活跃使用中，故而以它为例介绍  `melt` 和 `cast` 函数
1. plyr （退休）统一拆分(split)，计算(apply)，合并(combine)的数据处理流，由 dplyr（用于data.frame） 和 purrr （用于 list）继任

第三代

1. dplyr 操作数据的语法及其扩展
1. sparklyr 给 dplyr 提供 Spark 接口支持
1. dbplyr 给 dplyr 提供 DBI 数据库接口支持
1. dtplyr 给 dplyr 提供 data.table 支持
1. tidyr 提供 `spread` 和 `gather` 两个函数清洗数据

Garrett Grolemund 在 RStudio 主要从事教育教学，参考 [Materials for the Tidyverse Train-the-trainer workshop](https://github.com/rstudio-education/teach-tidy) 和 [The Tidyverse Cookbook](https://rstudio-education.github.io/tidyverse-cookbook/)

Dirk Eddelbuettel 的 [Getting Started in R -- Tinyverse Edition](https://github.com/eddelbuettel/gsir-te)
-->


## 常用操作 {#common-operations}

dplyr 由 Hadley Wickham 主要由开发和维护，是Rstudio公司开源的用于数据处理的一大利器，该包号称「数据操作的语法」，与 ggplot2 的「图形语法」 对应，也就是说数据处理那一套已经建立完整的和SQL一样的功能。它们都遵循同样的处理逻辑，只不过一个用SQL写，一个用R语言写，处理效率差不多，R语言写的 SQL 会被翻译为 SQL 语句，再传至数据库查询，当然它也支持内存内的数据操作。目前 dplyr 以 dbplyr 为后端支持的数据库有：MySQL、PostgreSQL，SQLite等，完整的支持列表请看 [这里](https://dplyr.tidyverse.org)，连接特定数据库，都是基于 DBI，DBI 即 Database Interface， 是使用C/C++开发的底层数据库接口，是一个统一的关系型数据库连接框架，需要根据不同的具体的数据库进行实例化，才可使用。

dplyr 常用的函数是 7 个： `arrange` 排序 `filter` 过滤行 `select` 选择列 `mutate` 变换 `summarise` 汇总 `group_by` 分组 `distinct` 去重

以 ggplot2 包自带的钻石数据集 diamonds 为例介绍

### 查看 {#tibble-show}

除了直接打印数据集的前几行，tibble 包还提供 glimpse 函数查看数据集，而 Base R 默认查看方式是调用 str 函数


```r
data("diamonds", package = "ggplot2")
glimpse(diamonds)
```

```
## Rows: 53,940
## Columns: 10
## $ carat   <dbl> 0.23, 0.21, 0.23, 0.29, 0.31, 0.24, 0.24, 0.26, 0.22, 0.23, 0.~
## $ cut     <ord> Ideal, Premium, Good, Premium, Good, Very Good, Very Good, Ver~
## $ color   <ord> E, E, E, I, J, J, I, H, E, H, J, J, F, J, E, E, I, J, J, J, I,~
## $ clarity <ord> SI2, SI1, VS1, VS2, SI2, VVS2, VVS1, SI1, VS2, VS1, SI1, VS1, ~
## $ depth   <dbl> 61.5, 59.8, 56.9, 62.4, 63.3, 62.8, 62.3, 61.9, 65.1, 59.4, 64~
## $ table   <dbl> 55, 61, 65, 58, 58, 57, 57, 55, 61, 61, 55, 56, 61, 54, 62, 58~
## $ price   <int> 326, 326, 327, 334, 335, 336, 336, 337, 337, 338, 339, 340, 34~
## $ x       <dbl> 3.95, 3.89, 4.05, 4.20, 4.34, 3.94, 3.95, 4.07, 3.87, 4.00, 4.~
## $ y       <dbl> 3.98, 3.84, 4.07, 4.23, 4.35, 3.96, 3.98, 4.11, 3.78, 4.05, 4.~
## $ z       <dbl> 2.43, 2.31, 2.31, 2.63, 2.75, 2.48, 2.47, 2.53, 2.49, 2.39, 2.~
```

Table: (\#tab:dplyr-object-type) dplyr 定义的数据对象类型

| 类型 | 含义                   |
| :--- | :--------------------- |
| int  | 整型 integer           |
| dbl  | （单）双精度浮点类型   |
| chr  | 字符（串）类型         |
| dttm | data-time 类型         |
| lgl  | 布尔类型               |
| fctr | 因子类型 factor        |
| date | 日期类型               |

表 \@ref(tab:dplyr-object-type) 中 dttm 和 date 类型代指 lubridate 包指定的日期对象 POSIXct、 POSIXlt、 Date、 chron、 yearmon、 yearqtr、 zoo、 zooreg、 timeDate、 xts、 its、 ti、 jul、 timeSeries 和 fts。

### 筛选 {#dplyr-filter}

按条件筛选数据的子集，按行筛选


```r
diamonds |>  filter(cut == "Ideal" , carat >= 3)
```

```
## # A tibble: 4 x 10
##   carat cut   color clarity depth table price     x     y     z
##   <dbl> <ord> <ord> <ord>   <dbl> <dbl> <int> <dbl> <dbl> <dbl>
## 1  3.22 Ideal I     I1       62.6    55 12545  9.49  9.42  5.92
## 2  3.5  Ideal H     I1       62.8    57 12587  9.65  9.59  6.03
## 3  3.01 Ideal J     SI2      61.7    58 16037  9.25  9.2   5.69
## 4  3.01 Ideal J     I1       65.4    60 16538  8.99  8.93  5.86
```

先按行，再按列筛选


```r
diamonds |>  
  filter(carat >= 3, color == "I") |>  
  select(cut, carat)
```

```
## # A tibble: 16 x 2
##    cut       carat
##    <ord>     <dbl>
##  1 Premium    3.01
##  2 Fair       3.02
##  3 Good       3   
##  4 Ideal      3.22
##  5 Premium    4.01
##  6 Very Good  3.04
##  7 Very Good  4   
##  8 Premium    3.67
##  9 Premium    3   
## 10 Fair       3   
## 11 Premium    3.01
## 12 Fair       3.01
## 13 Fair       3.01
## 14 Good       3.01
## 15 Good       3.01
## 16 Premium    3.04
```

### 排序 {#dplyr-arrange}

arrange 默认升序排列，按钻石重量升序，按价格降序


```r
diamonds |>  
  filter(cut == "Ideal" , carat >= 3) |>  
  arrange(carat, desc(price))
```

```
## # A tibble: 4 x 10
##   carat cut   color clarity depth table price     x     y     z
##   <dbl> <ord> <ord> <ord>   <dbl> <dbl> <int> <dbl> <dbl> <dbl>
## 1  3.01 Ideal J     I1       65.4    60 16538  8.99  8.93  5.86
## 2  3.01 Ideal J     SI2      61.7    58 16037  9.25  9.2   5.69
## 3  3.22 Ideal I     I1       62.6    55 12545  9.49  9.42  5.92
## 4  3.5  Ideal H     I1       62.8    57 12587  9.65  9.59  6.03
```

### 聚合 {#dplyr-summarise}

分组求和，求平均，计数


```r
diamonds |>  
  filter(carat > 3, color == "I") |>  
  group_by(cut, clarity) |>  
  summarise(sum_carat = sum(carat), mean_carat = mean(carat), n_count = n())
```

```
## # A tibble: 8 x 5
## # Groups:   cut [5]
##   cut       clarity sum_carat mean_carat n_count
##   <ord>     <ord>       <dbl>      <dbl>   <int>
## 1 Fair      I1           3.02       3.02       1
## 2 Fair      SI2          6.02       3.01       2
## 3 Good      SI2          6.02       3.01       2
## 4 Very Good I1           4          4          1
## 5 Very Good SI2          3.04       3.04       1
## 6 Premium   I1          10.7        3.56       3
## 7 Premium   SI2          6.05       3.02       2
## 8 Ideal     I1           3.22       3.22       1
```


### 合并 {#dplyr-merge}

按行合并


```r
set.seed(2018)
one <- diamonds |>  
  filter(color == "I") |>  
  sample_n(5)
two <- diamonds |>  
  filter(color == "J") |>  
  sample_n(5)
# 按行合并数据框 one 和 two
bind_rows(one, two)
```

```
## # A tibble: 10 x 10
##    carat cut       color clarity depth table price     x     y     z
##    <dbl> <ord>     <ord> <ord>   <dbl> <dbl> <int> <dbl> <dbl> <dbl>
##  1  0.42 Ideal     I     VVS1     62.5  57     884  4.77  4.8   2.99
##  2  0.3  Ideal     I     VVS2     62.5  53.6   532  4.29  4.33  2.69
##  3  2.02 Good      I     VS1      57.9  63   17533  8.13  8.21  4.73
##  4  0.9  Premium   I     VS2      61.9  58    3398  6.18  6.23  3.84
##  5  1.98 Very Good I     VS2      62.7  60   15083  7.9   7.96  4.98
##  6  1.51 Very Good J     VVS2     62.6  63    8706  7.29  7.24  4.55
##  7  0.7  Very Good J     SI1      61.7  57    1979  5.65  5.69  3.5 
##  8  1.16 Premium   J     VS2      62.2  59    4702  6.74  6.69  4.18
##  9  1.5  Premium   J     VVS2     61.8  60    8760  7.36  7.33  4.54
## 10  1.51 Premium   J     SI1      60.4  62    6680  7.42  7.32  4.45
```

按列合并


```r
set.seed(2018)
three <- diamonds |>  
  select(carat, color) |>  
  sample_n(5)
four <- diamonds |>  
  select(carat, color) |>  
  sample_n(5)
bind_cols(three, four)
```

```
## # A tibble: 5 x 4
##   carat...1 color...2 carat...3 color...4
##       <dbl> <ord>         <dbl> <ord>    
## 1      0.33 H              0.52 F        
## 2      1.09 F              0.51 F        
## 3      1.52 I              0.5  G        
## 4      0.95 G              0.38 E        
## 5      0.35 E              0.51 J
```


### 变换 {#dplyr-mutate}

添加一列，新的列或者改变原来的列


```r
diamonds |>  
  filter(carat > 3, color == "I") |>  
  select(cut, carat) |>  
  mutate(vol = if_else(carat > 3.5, "A", "B"))
```

```
## # A tibble: 13 x 3
##    cut       carat vol  
##    <ord>     <dbl> <chr>
##  1 Premium    3.01 B    
##  2 Fair       3.02 B    
##  3 Ideal      3.22 B    
##  4 Premium    4.01 A    
##  5 Very Good  3.04 B    
##  6 Very Good  4    A    
##  7 Premium    3.67 A    
##  8 Premium    3.01 B    
##  9 Fair       3.01 B    
## 10 Fair       3.01 B    
## 11 Good       3.01 B    
## 12 Good       3.01 B    
## 13 Premium    3.04 B
```



### 去重 {#dplyr-duplicated}

数据去重在 dplyr 中的实现[^dplyr-duplicated]。


```r
set.seed(123)
df <- data.frame(
  x = sample(0:1, 10, replace = T),
  y = sample(0:1, 10, replace = T),
  z = 1:10
)
df
```

```
##    x y  z
## 1  0 1  1
## 2  0 1  2
## 3  0 1  3
## 4  1 0  4
## 5  0 1  5
## 6  1 0  6
## 7  1 1  7
## 8  1 0  8
## 9  0 0  9
## 10 0 0 10
```

去掉列重复的数据点 (x, y) 


```r
df |>  
  group_by(x, y) |> 
  filter(row_number(z) == 1)
```

```
## # A tibble: 4 x 3
## # Groups:   x, y [4]
##       x     y     z
##   <int> <int> <int>
## 1     0     1     1
## 2     1     0     4
## 3     1     1     7
## 4     0     0     9
```

```r
# 此处不对，没有了 z 
df |> 
  distinct(x, y)
```

```
##   x y
## 1 0 1
## 2 1 0
## 3 1 1
## 4 0 0
```

```r
# 应该为
df |> 
  distinct(x, y, .keep_all = TRUE)
```

```
##   x y z
## 1 0 1 1
## 2 1 0 4
## 3 1 1 7
## 4 0 0 9
```

[^dplyr-duplicated]: https://stackoverflow.com/questions/22959635/


## 高频问题 {#common-dataframe-operations}

常用的数据操作包含

1. 创建空的数据框或者说初始化一个数据框，
1. 按指定的列对数据框排序，
1. 选择特定的一些列，复杂情况是可能需要正则表达式从列名或者值中筛选
1. 合并两个数据框，分为 (inner outer left right) 四种情况
1. 宽格式和长格式互相转换，即重塑操作 reshape，单独的 tidyr 包操作，是 reshape2 包的进化版，提供 `spread` 和 `gather` 两个主要函数

### 初始化数据框 {#create-empty-dataframe}

创建空的数据框，就是不包含任何行、记录


```r
empty_df <- data.frame(
  Doubles = double(),
  Ints = integer(),
  Factors = factor(),
  Logicals = logical(),
  Characters = character(),
  stringsAsFactors = FALSE
)
str(empty_df)
```

```
## 'data.frame':	0 obs. of  5 variables:
##  $ Doubles   : num 
##  $ Ints      : int 
##  $ Factors   : Factor w/ 0 levels: 
##  $ Logicals  : logi 
##  $ Characters: chr
```

如果数据框 df 包含数据，现在要依据它创建一个空的数据框


```r
empty_df = df[FALSE,]
```

还可以使用 structure 构造一个数据框，并且我们发现它的效率更高


```r
s <- function() structure(list(
    Date = as.Date(character()),
    File = character(),
    User = character()
  ),
  class = "data.frame"
  )
d <- function() data.frame(
    Date = as.Date(character()),
    File = character(),
    User = character(),
    stringsAsFactors = FALSE
  )
microbenchmark::microbenchmark(s(), d())
```

```
## Unit: microseconds
##  expr   min     lq    mean median     uq    max neval
##   s()  19.8  22.60  55.281  26.35  31.55 2549.6   100
##   d() 210.2 215.35 244.591 217.95 222.65 2442.8   100
```

### 移除缺失记录 {#remove-missing-values}

只要行中包含缺失值，我们就把这样的行移除出去


```r
airquality[complete.cases(airquality), ] |> head()
```

```
##   Ozone Solar.R Wind Temp Month Day
## 1    41     190  7.4   67     5   1
## 2    36     118  8.0   72     5   2
## 3    12     149 12.6   74     5   3
## 4    18     313 11.5   62     5   4
## 7    23     299  8.6   65     5   7
## 8    19      99 13.8   59     5   8
```

### 数据类型转化 {#coerce-data-type}


```r
str(PlantGrowth)
```

```
## 'data.frame':	30 obs. of  2 variables:
##  $ weight: num  4.17 5.58 5.18 6.11 4.5 4.61 5.17 4.53 5.33 5.14 ...
##  $ group : Factor w/ 3 levels "ctrl","trt1",..: 1 1 1 1 1 1 1 1 1 1 ...
```

```r
bob <- PlantGrowth
i <- sapply(bob, is.factor)
bob[i] <- lapply(bob[i], as.character)
str(bob)
```

```
## 'data.frame':	30 obs. of  2 variables:
##  $ weight: num  4.17 5.58 5.18 6.11 4.5 4.61 5.17 4.53 5.33 5.14 ...
##  $ group : chr  "ctrl" "ctrl" "ctrl" "ctrl" ...
```

### 跨列分组求和 {#cross-group-by}

输入是一个数据框 data.frame，按照其中某一变量分组，然后计算任意数量的变量的行和和列和。

空气质量数据集 airquality 按月份 Month 分组，然后求取满足条件的列的和


```r
Reduce(rbind, lapply(unique(airquality$Month), function(gv) {
  subdta <- subset(airquality, subset = Month == gv)
  data.frame(
    Colsum = as.numeric(
      colSums(subdta[, grepl("[mM]", names(airquality))], na.rm = TRUE)
    ),
    Month = gv
  )
}))
```

```
##    Colsum Month
## 1    2032     5
## 2     155     5
## 3    2373     6
## 4     180     6
## 5    2601     7
## 6     217     7
## 7    2603     8
## 8     248     8
## 9    2307     9
## 10    270     9
```

什么是函数式编程，R 语言环境下的函数式编程是如何操作的


## 管道操作 {#pipe-manipulation}

[Stefan Milton Bache](http://stefanbache.dk/) 开发了 [magrittr](https://github.com/tidyverse/magrittr) 包实现管道操作，增加代码的可读性和维护性，但是这个 R 包的名字取的太奇葩，因为 [记不住](https://d.cosx.org/d/420697/21)，它其实是一个复杂的[法语发音][pronounce-magrittr]，中式英语就叫它马格里特吧！这下应该好记多了吧！

[pronounce-magrittr]: https://magrittr.tidyverse.org/articles/magrittr.html

我要查看是否需要新添加一个 R 包依赖，假设该 R 包是 reticulate 没有出现在 DESCRIPTION 文件中，但是可能已经被其中某（个）些 R 包依赖了


```r
"reticulate" %in% sort(unique(unlist(tools::package_dependencies(desc::desc_get_deps()$package, recursive = TRUE))))
```

```
## [1] TRUE
```

安装 pkg 的依赖


```r
pkg <- c(
  "bookdown",
  "e1071",
  "formatR",
  "lme4",
  "mvtnorm",
  "prettydoc", "psych",
  "reticulate", "rstan", "rstanarm", "rticles",
  "svglite",
  "TMB", "glmmTMB"
)
# 获取 pkg 的所有依赖
dep_pkg <- tools::package_dependencies(pkg, recursive = TRUE)
# 将列表 list 合并为向量 vector
merge_pkg <- Reduce("c", dep_pkg, accumulate = FALSE)
# 所有未安装的 R 包
miss_pkg <- setdiff(unique(merge_pkg), unique(.packages(TRUE)))
# 除了 pkg 外，未安装的 R 包，安装 pkg 的依赖
sort(setdiff(miss_pkg, pkg))
```

```
## [1] "mnormt"
```

转化为管道操作，增加可读性

> 再举一个关于数据模拟的例子

模拟 0-1 序列，


```r
set.seed(2019)
binom_sample <- function(n) {
  sum(sample(x = c(0,1), size = n, prob = c(0.8, 0.2), replace = TRUE))/n
}
# 频率估计概率
one_prob <- sapply(10^(seq(8)), binom_sample)
# 估计的误差
one_abs <- abs(one_prob - 0.2)
one_abs
```

```
## [1] 1.000e-01 1.000e-02 1.100e-02 4.400e-03 1.460e-03 3.980e-04 4.700e-06
## [8] 9.552e-05
```

似然估计

