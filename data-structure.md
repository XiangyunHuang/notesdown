# 数据结构 {#chap:data-structure}

网站 <https://r-coder.com/> 主要介绍 Base R，特点是全面细致，排版精美

## 字符 {#sec:character}

## 向量 {#sec:vector}

## 矩阵 {#sec:matrix}

## 数组 {#sec:array}

## 列表 {#sec:list}


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

## 日期 {#sec:date}

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
## [1] cut.Date        cut.default     cut.dendrogram* cut.POSIXt     
## see '?methods' for accessing help and source code
```

格式化输出日期类型数据


```r
formatC(round(runif(1, 1e8, 1e9)), digits = 10, big.mark = ",")
```

```
## [1] "283,621,883"
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
## [1] "2021-07-04 00:00:00"
```

从 POSIXt 数据对象中，抽取小时和分钟部分，返回字符串


```r
strftime(x = Sys.time(), format = "%H:%M")
```

```
## [1] "06:15"
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

本节介绍了 R 本身提供的基础日期操作，第\@ref(chap:time-series-analysis)章着重介绍一般的时间序列类型的数据对象及其操作。
