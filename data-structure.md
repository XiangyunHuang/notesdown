# 数据结构 {#chap-data-structure}



网站 <https://r-coder.com/> 主要介绍 Base R，特点是全面细致，排版精美

> 可用于绘图的数据对象，向量 vector 等，只涉及基础操作和绘图，关键在入门引导式的介绍，点到即止

数据类型：字符、数值：字符数据操作：按数据类型介绍各类数据操作，重复之处如前所述，数据处理的分类：按数据类型来，一共是 table matrix data.frame 和 vector

> The trouble with nonstandard evaluation is that it doesn't follow standard
evaluation rules...
>
>   --- Peter Dalgaard (about nonstandard evaluation in the `curve()` function)
      R-help (June 2011)

<!-- 详细介绍 data.frame 和 data.table，而不简略介绍 tibble 和 dplyr -->

向量，列表，

数据框 data frame 在 R 里面可以用三种不同类型的数据对象来表达

> 从历史脉络来看，为什么会出现三种不同的东西，它们之间的区别和联系是什么，能否用一张表来描述

data.frame 设计的历史，首次包含在 R 里面是什么时候，R 是否一发布就包含了这个数据类型

The function `data.frame()` creates data frames, tightly coupled collections of variables which share many of the properties of matrices and of lists, used as the fundamental data structure by most of R's modeling software.

**data.table** 2006 年 4 月 15 日首次登陆 CRAN 发布 1.0 版本，差不多恰好 10 年后

**tibble** 在 2016 年 3 月 23 日首次登陆 CRAN 发布 1.0 版本

`data.frame()`， `tibble()` 和 `data.table()` 的区别，去看函数的帮助文档

Provides a 'tbl_df' class (the 'tibble') that provides stricter checking and better formatting than the traditional data frame.

[vctrs](https://github.com/r-lib/vctrs) 和 [rlang](https://github.com/r-lib/rlang) 包
R 内置的 [R Language Definition](https://cran.r-project.org/doc/manuals/r-release/R-lang.html)


## 类型 {#subsec:typeof}


```r
x <- "abc" # 数据对象
typeof(x) # 数据类型
```

```
## [1] "character"
```

```r
mode(x) # 存储模式
```

```
## [1] "character"
```

```r
storage.mode(x) # 存储类型
```

```
## [1] "character"
```


Table: (\#tab:all-data-type) 函数 `typeof()` 返回的数据类型 [^note]

| 符号          | 含义                     |
| :------------ | :----------------------- |
| `NULL`        | 空值                     |
| `symbol`      | 可变的名称/变量          |
| `pairlist`    | pairlist 对象***         |
| `closure`     | 函数闭包                 |
| `environment` | 环境                     |
| `promise`     | 实现惰性求值的对象       |
| `language`    | R 语言构造               |
| `special`     | 内部函数，不计算参数     |
| `builtin`     | 内部函数，计算参数       |
| `char`        | scalar 型字符对象***     |
| `logical`     | 逻辑向量                 |
| `integer`     | 整数向量                 |
| `double`      | 实值向量                 |
| `complex`     | 复值向量                 |
| `character`   | 字符向量                 |
| `...`         | 可变长度的参数***        |
| `any`         | 匹配任意类型             |
| `expression`  | 表达式对象               |
| `list`        | 列表                     |
| `bytecode`    | 位代码***                |
| `externalptr` | 外部指针对象             |
| `weakref`     | 弱引用对象               |
| `raw`         | 位向量                   |
| `S4`          | S4 对象                  |

[^note]: 表格中带 *** 标记的类型，用户不能轻易获得


Table: (\#tab:basic-data-type) R/Rcpp 提供的基本数据类型

|  Value   |  R vector   |            Rcpp vector             |            Rcpp matrix             | Rcpp scalar | C++ scalar |
| :------: | :---------: | :--------------------------------: | :--------------------------------: | :---------: | :--------: |
| Logical  |  `logical`  |          `LogicalVector`           |          `LogicalMatrix`           |      -      |   `bool`   |
| Integer  |  `integer`  |          `IntegerVector`           |          `IntegerMatrix`           |      -      |   `int`    |
|   Real   |  `numeric`  |          `NumericVector`           |          `NumericMatrix`           |      -      |  `double`  |
| Complex  |  `complex`  |          `ComplexVector`           |          `ComplexMatrix`           | `Rcomplex`  | `complex`  |
|  String  | `character` | `CharacterVector` (`StringVector`) | `CharacterMatrix` (`StringMatrix`) |  `String`   |  `string`  |
|   Date   |   `Date`    |            `DateVector`            |                 -                  |   `Date`    |     -      |
| Datetime |  `POSIXct`  |          `DatetimeVector`          |                 -                  | `Datetime`  |  `time_t`  |


## 字符 {#sec-character}

## 向量 {#sec-vector}

## 矩阵 {#sec-matrix}

## 数组 {#sec-array}

更多数组操作 [rray](https://github.com/r-lib/rray)

## 表达式 {#sec-expression}


```r
# %||% 中缀符
# x 是空值或者长度为 0 则保留 y 否则保留 x
function(x, y) if (is.null(x) || length(x) == 0) y else x
```

```
## function(x, y) if (is.null(x) || length(x) == 0) y else x
```

## 列表 {#sec-list}


```r
x <- list(a = 1, b = 2, c = list(d = c(1, 2, 3), e = "hello"))
print(x)
```

```
## $a
## [1] 1
## 
## $b
## [1] 2
## 
## $c
## $c$d
## [1] 1 2 3
## 
## $c$e
## [1] "hello"
```

```r
base::print.simple.list(x)
```

```
##      _    
## a    1    
## b    2    
## c.d1 1    
## c.d2 2    
## c.d3 3    
## c.e  hello
```

## 日期 {#sec-date}

注意观察时间转化


```r
Sys.Date()
```

```
## [1] "2023-01-25"
```

```r
Sys.time()
```

```
## [1] "2023-01-25 23:28:44 UTC"
```

```r
c(Sys.time(), Sys.Date())
```

```
## [1] "2023-01-25 23:28:44 UTC" "2023-01-25 00:00:00 UTC"
```

```r
data.table::year(Sys.Date())
```

```
## [1] 2023
```

```r
data.table::year(Sys.time())
```

```
## [1] 2023
```

```r
data.table::year(c(Sys.time(), Sys.Date()))
```

```
## [1] 2023 2023
```


```r
x <- Sys.time()
class(x)
```

```
## [1] "POSIXct" "POSIXt"
```

```r
format(x, format = "%Y-%m-%d")
```

```
## [1] "2023-01-25"
```



```r
x <- c("2019-12-21", "2019/12/21")
data.table::year("2019-12-21")
```

```
## [1] 2019
```

```r
data.table::year("2019/12/21")
```

```
## [1] 2019
```

但是，下面这样会报错


```r
data.table::year(x)
```

```
## Error in as.POSIXlt.character(x): character string is not in a standard unambiguous format
```

正确的姿势是首先将表示日期的字符串格式统一


```r
gsub(pattern = "/", replacement = "-", x) %>% 
  data.table::year()
```

```
## [1] 2019 2019
```


date-times 表示 POSIXct 和 POSIXlt 类型的日期对象


```r
(x <- Sys.time())
```

```
## [1] "2023-01-25 23:28:44 UTC"
```

```r
class(x)
```

```
## [1] "POSIXct" "POSIXt"
```

```r
data.table::second(x) # 取秒
```

```
## [1] 44
```

```r
format(x, format = "%S")
```

```
## [1] "44"
```

```r
data.table::minute(x) # 取分
```

```
## [1] 28
```

```r
format(x, format = "%M")
```

```
## [1] "28"
```

```r
data.table::hour(x) # 取时
```

```
## [1] 23
```

```r
format(x, format = "%H")
```

```
## [1] "23"
```

```r
data.table::yday(x) # 此刻在一年的第几天
```

```
## [1] 25
```

```r
data.table::wday(x) # 此刻在一周的第几天，星期日是第1天，星期六是第7天
```

```
## [1] 4
```

```r
data.table::mday(x) # 此刻在当月第几天
```

```
## [1] 25
```

```r
format(x, format = "%d")
```

```
## [1] "25"
```

```r
weekdays(x)
```

```
## [1] "Wednesday"
```

```r
weekdays(x, abbreviate = T)
```

```
## [1] "Wed"
```

```r
data.table::week(x) # 此刻在第几周
```

```
## [1] 4
```

```r
data.table::isoweek(x)
```

```
## [1] 4
```

```r
data.table::month(x) # 此刻在第几月
```

```
## [1] 1
```

```r
format(x, format = "%m")
```

```
## [1] "01"
```

```r
months(x)
```

```
## [1] "January"
```

```r
months(x, abbreviate = T)
```

```
## [1] "Jan"
```

```r
data.table::quarter(x) # 此刻在第几季度
```

```
## [1] 1
```

```r
quarters(x)
```

```
## [1] "Q1"
```

```r
data.table::year(x) # 取年
```

```
## [1] 2023
```

```r
format(x, format = "%Y")
```

```
## [1] "2023"
```

::: {.rmdtip data-latex="{提示}"}
`format()` 是一个泛型函数，此刻命名空间有 92 方法。
`format.Date()`， `format.difftime()`， `format.POSIXct()` 和 `format.POSIXlt()` 四个函数通过格式化不同类型的日期数据对象抽取指定部分。


```r
format(difftime(Sys.time(), x, units = "secs"))
```

```
## [1] "0.05354953 secs"
```

日期转化详见 [@Brian_2001_date;@Gabor_2004_date]
:::

上个季度最后一天


```r
# https://d.cosx.org/d/421162/16
as.Date(cut(as.Date(c("2020-02-01", "2020-05-02")), "quarter")) - 1
```

```
## [1] "2019-12-31" "2020-03-31"
```

本季度第一天


```r
as.Date(cut(as.Date(c("2020-02-01", "2020-05-02")), "quarter"))
```

```
## [1] "2020-01-01" "2020-04-01"
```

类似地，本月第一天和上月最后一天


```r
# 本月第一天
as.Date(cut(as.Date(c("2020-02-01", "2020-05-02")), "month"))
```

```
## [1] "2020-02-01" "2020-05-01"
```

```r
# 上月最后一天
as.Date(cut(as.Date(c("2020-02-01", "2020-05-02")), "month")) - 1
```

```
## [1] "2020-01-31" "2020-04-30"
```

**timeDate** 提供了很多日期计算函数，比如季初、季末、月初、月末等


```r
library(timeDate) 
# 季初
as.Date(format(timeFirstDayInQuarter(charvec = c("2020-02-01", "2020-05-02")), format = "%Y-%m-%d")) 
# 季末
as.Date(format(timeLastDayInQuarter(charvec = c("2020-02-01", "2020-05-02")), format = "%Y-%m-%d"))
# 月初
as.Date(format(timeFirstDayInMonth(charvec = c("2020-02-01", "2020-05-02")), format = "%Y-%m-%d")) 
# 月末
as.Date(format(timeLastDayInMonth(charvec = c("2020-02-01", "2020-05-02")), format = "%Y-%m-%d")) 
```

`cut.Date()` 是一个泛型函数，查看它的所有 S3 方法


```r
methods(cut)
```

```
## [1] cut.Date        cut.default     cut.dendrogram* cut.IDate*     
## [5] cut.POSIXt     
## see '?methods' for accessing help and source code
```

格式化输出日期类型数据


```r
formatC(round(runif(1, 1e8, 1e9)), digits = 10, big.mark = ",")
```

```
## [1] "615,936,210"
```


```r
# Sys.setlocale(locale = "C") # 如果是 Windows 系统，必须先设置，否则转化结果是 NA
as.Date(paste("1990-January", 1, sep = "-"), format = "%Y-%B-%d")
```

```
## [1] "1990-01-01"
```

获取当日零点


```r
format(as.POSIXlt(Sys.Date()), "%Y-%m-%d %H:%M:%S")
```

```
## [1] "2023-01-25 00:00:00"
```

从 POSIXt 数据对象中，抽取小时和分钟部分，返回字符串


```r
strftime(x = Sys.time(), format = "%H:%M")
```

```
## [1] "23:28"
```

Table: (\#tab:table-of-date) 日期表格

| 代码  | 含义                           | 代码  | 含义                                       |
| ---- | :---------------------------- | ---- | :-------------------------------------------- |
| `%a` | Abbreviated weekday           | `%A` | Full weekday                                  |
| `%b` | Abbreviated month             | `%B` | Full month                                    |
| `%c` | Locale-specific date and time | `%d` | Decimal date                                  |
| `%H` | Decimal hours (24 hour)       | `%I` | Decimal hours (12 hour)                       |
| `%j` | Decimal day of the year       | `%m` | Decimal month                                 |
| `%M` | Decimal minute                | `%p` | Locale-specific AM/PM                         |
| `%S` | Decimal second                | `%U` | Decimal week of the year (starting on Sunday) |
| `%w` | Decimal Weekday (0=Sunday)    | `%W` | Decimal week of the year (starting on Monday) |
| `%x` | Locale-specific Date          | `%X` | Locale-specific Time                          |
| `%y` | 2-digit year                  | `%Y` | 4-digit year                                  |
| `%z` | Offset from GMT               | `%Z` | Time zone (character)                         |

本节介绍了 R 本身提供的基础日期操作，第\@ref(chap-time-series-analysis)章着重介绍一般的时间序列类型的数据对象及其操作。



[Jeffrey A. Ryan](https://blog.revolutionanalytics.com/2011/07/the-r-files-jeff-ryan.html) 开发的 [xts](https://github.com/joshuaulrich/xts) 和 [quantmod](https://github.com/joshuaulrich/quantmod) 包，Joshua M. Ulrich 开发的 [zoo](https://r-forge.r-project.org/projects/zoo/) 是处理时间序列数据的主要工具

Jeffrey A. Ryan 在开设了一门免费课程教大家如何在 R 语言中使用 xts 和 zoo 包操作时间序列数据 [^course-xts-zoo]

xts (eXtensible Time Series) 扩展的 zoo 对象


```r
xts(x = NULL,
    order.by = index(x),
    frequency = NULL,
    unique = TRUE,
    tzone = Sys.getenv("TZ"),
    ...)
```



```r
library(zoo)
library(xts)
x = matrix(1:4, ncol = 2,nrow = 2)
idx <- as.Date(c("2018-01-01", "2019-12-12"))
# xts = matrix + index
xts(x, order.by = idx)
```

```
##            [,1] [,2]
## 2018-01-01    1    3
## 2019-12-12    2    4
```

Date，POSIX times，timeDate，chron 等各种各样处理日期数据的对象


[^course-xts-zoo]: https://www.datacamp.com/courses/manipulating-time-series-data-in-r-with-xts-zoo

## 空值 {#sec-null}

移除`list()` 列表里的为 `NULL` 元素


```r
rm_null <- function(l) Filter(Negate(is.null), l)
```


