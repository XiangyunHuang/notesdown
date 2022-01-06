# 时序分析 {#chap-time-series-analysis}


```r
library(formatR)
`%>%` <- magrittr::`%>%`
library(ggplot2)
library(ggfortify) # **ggfortify** 包提供的 `autoplot()` 函数可以根据数据对象的不同绘制不同的图形。
library(dygraphs) 
# library(robustbase) # Robust Statistics
# library(timeDate) # 日期处理
# library(timeSeries) # 序列处理
# library(fPortfolio) # 投资组合
# library(prophet) # 时间序列预测
# https://github.com/business-science/timetk
# library(timetk) # 处理时间序列数据的工具箱
```

首先介绍时序数据对象及操作，处理时序数据的工具，包括时序图、相关图、平稳性检验，相关检验，之后才是时序建模。[timeDate](https://cran.r-project.org/package=timeDate)  [timeSeries](https://cran.r-project.org/package=timeSeries) 是处理日期和时间序列的 R 包，有专门的官网 <https://www.rmetrics.org/>，扩展到时间序列、组合优化、金融市场、投资管理等一系列书籍，非常值得一看。此外，北大李东风老师的[金融时间序列分析讲义](https://www.math.pku.edu.cn/teachers/lidf/course/) 是这方面非常好的中文参考材料。David R. Brillinger 在 1975 年出版的书 《Time Series: Data Analysis and Theory》 [@Brillinger_2001_TSD] 是经典著作，我们可以从时间序列分析的综述上开始入手，比如从 ARIMA 过渡到异方差和非高斯分布 <https://mason.gmu.edu/~jgentle/talks/CompFin_Tutorial.pdf>， <https://www.stat.berkeley.edu/~brill/Papers/encysbs.pdf> 和 ARCH or GARCH 的综述 <http://public.econ.duke.edu/~boller/Papers/glossary_arch.pdf> ，宾州州立大学开设的 Applied Time Series Analysis 课程 <https://newonlinecourses.science.psu.edu/stat510/>，以及 《Time Series Analysis and Its Applications With R Examples》 已经出到第四版了，和 R 语言结合，理论和应用结合 <https://www.stat.pitt.edu/stoffer/tsa4/>。从时间序列中寻找规律，这样才是真的数据建模，从数据到模型，而不是相反 [Finding Patterns in Time Series](https://mason.gmu.edu/~jgentle/papers/FindingPatternsTimeSeriesDraft.pdf)，识别金融时间序列的模式和统计规律。现在工业界做时序分析和预测的工具，如 facebook 出品的 [prophet](https://github.com/facebook/prophet/tree/master/R)，微软收集了一些时间序列预测的最佳实战案例 <https://github.com/microsoft/forecasting>

[forecastML](https://github.com/nredell/forecastML/) 自回归模型结合机器学习方法。

[CausalImpact](https://github.com/google/CausalImpact) 借助贝叶斯分析方法推断时间序列中的因果关系，比如广告促销带来的点击效果。


[robustbase](https://r-forge.r-project.org/projects/robustbase/) [@robustbase2006] 提供稳健统计方法。

[prophet](https://github.com/facebook/prophet) 基于可加模型的时间序列预测

[AnomalyDetection](https://github.com/twitter/AnomalyDetection) 时间序列数据中的异常值检测


## 时序数据 {#sec-ts-data}

以数据集 AirPassengers 为例说明一下 R 内置的存储时间序列数据的数据结构 --- ts 数据对象。函数 `class()` 、 `mode()` 和 `str()` 分别可以查看其数据类型、存储类型和数据结构。


```r
# 数据类型
class(AirPassengers)
```

```
## [1] "ts"
```

```r
# 存储类型
mode(AirPassengers)
```

```
## [1] "numeric"
```

```r
# 数据结构
str(AirPassengers)
```

```
##  Time-Series [1:144] from 1949 to 1961: 112 118 132 129 121 135 148 148 136 119 ...
```

查看该数据集开始和结束的时间点


```r
c(start(AirPassengers), end(AirPassengers))
```

```
## [1] 1949    1 1960   12
```

数据集 AirPassengers 在以上时间区间的划分


```r
time(AirPassengers)
```

```
##           Jan      Feb      Mar      Apr      May      Jun      Jul      Aug
## 1949 1949.000 1949.083 1949.167 1949.250 1949.333 1949.417 1949.500 1949.583
## 1950 1950.000 1950.083 1950.167 1950.250 1950.333 1950.417 1950.500 1950.583
## 1951 1951.000 1951.083 1951.167 1951.250 1951.333 1951.417 1951.500 1951.583
## 1952 1952.000 1952.083 1952.167 1952.250 1952.333 1952.417 1952.500 1952.583
## 1953 1953.000 1953.083 1953.167 1953.250 1953.333 1953.417 1953.500 1953.583
## 1954 1954.000 1954.083 1954.167 1954.250 1954.333 1954.417 1954.500 1954.583
## 1955 1955.000 1955.083 1955.167 1955.250 1955.333 1955.417 1955.500 1955.583
## 1956 1956.000 1956.083 1956.167 1956.250 1956.333 1956.417 1956.500 1956.583
## 1957 1957.000 1957.083 1957.167 1957.250 1957.333 1957.417 1957.500 1957.583
## 1958 1958.000 1958.083 1958.167 1958.250 1958.333 1958.417 1958.500 1958.583
## 1959 1959.000 1959.083 1959.167 1959.250 1959.333 1959.417 1959.500 1959.583
## 1960 1960.000 1960.083 1960.167 1960.250 1960.333 1960.417 1960.500 1960.583
##           Sep      Oct      Nov      Dec
## 1949 1949.667 1949.750 1949.833 1949.917
## 1950 1950.667 1950.750 1950.833 1950.917
## 1951 1951.667 1951.750 1951.833 1951.917
## 1952 1952.667 1952.750 1952.833 1952.917
## 1953 1953.667 1953.750 1953.833 1953.917
## 1954 1954.667 1954.750 1954.833 1954.917
## 1955 1955.667 1955.750 1955.833 1955.917
## 1956 1956.667 1956.750 1956.833 1956.917
## 1957 1957.667 1957.750 1957.833 1957.917
## 1958 1958.667 1958.750 1958.833 1958.917
## 1959 1959.667 1959.750 1959.833 1959.917
## 1960 1960.667 1960.750 1960.833 1960.917
```

期初和期末的周期


```r
tsp(AirPassengers)
```

```
## [1] 1949.000 1960.917   12.000
```

函数 `diff()` 实现差分算子，默认参数 `lag = 1` ，`differences = 1` 表示延迟期数为 1 的一阶差分。


```r
# 差分前
AirPassengers
```

```
##      Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec
## 1949 112 118 132 129 121 135 148 148 136 119 104 118
## 1950 115 126 141 135 125 149 170 170 158 133 114 140
## 1951 145 150 178 163 172 178 199 199 184 162 146 166
## 1952 171 180 193 181 183 218 230 242 209 191 172 194
## 1953 196 196 236 235 229 243 264 272 237 211 180 201
## 1954 204 188 235 227 234 264 302 293 259 229 203 229
## 1955 242 233 267 269 270 315 364 347 312 274 237 278
## 1956 284 277 317 313 318 374 413 405 355 306 271 306
## 1957 315 301 356 348 355 422 465 467 404 347 305 336
## 1958 340 318 362 348 363 435 491 505 404 359 310 337
## 1959 360 342 406 396 420 472 548 559 463 407 362 405
## 1960 417 391 419 461 472 535 622 606 508 461 390 432
```

```r
# 差分后
diff(AirPassengers)
```

```
##       Jan  Feb  Mar  Apr  May  Jun  Jul  Aug  Sep  Oct  Nov  Dec
## 1949         6   14   -3   -8   14   13    0  -12  -17  -15   14
## 1950   -3   11   15   -6  -10   24   21    0  -12  -25  -19   26
## 1951    5    5   28  -15    9    6   21    0  -15  -22  -16   20
## 1952    5    9   13  -12    2   35   12   12  -33  -18  -19   22
## 1953    2    0   40   -1   -6   14   21    8  -35  -26  -31   21
## 1954    3  -16   47   -8    7   30   38   -9  -34  -30  -26   26
## 1955   13   -9   34    2    1   45   49  -17  -35  -38  -37   41
## 1956    6   -7   40   -4    5   56   39   -8  -50  -49  -35   35
## 1957    9  -14   55   -8    7   67   43    2  -63  -57  -42   31
## 1958    4  -22   44  -14   15   72   56   14 -101  -45  -49   27
## 1959   23  -18   64  -10   24   52   76   11  -96  -56  -45   43
## 1960   12  -26   28   42   11   63   87  -16  -98  -47  -71   42
```

```r
# 延迟一期的二阶差分
diff(AirPassengers, lag = 1, differences = 2)
```

```
##       Jan  Feb  Mar  Apr  May  Jun  Jul  Aug  Sep  Oct  Nov  Dec
## 1949              8  -17   -5   22   -1  -13  -12   -5    2   29
## 1950  -17   14    4  -21   -4   34   -3  -21  -12  -13    6   45
## 1951  -21    0   23  -43   24   -3   15  -21  -15   -7    6   36
## 1952  -15    4    4  -25   14   33  -23    0  -45   15   -1   41
## 1953  -20   -2   40  -41   -5   20    7  -13  -43    9   -5   52
## 1954  -18  -19   63  -55   15   23    8  -47  -25    4    4   52
## 1955  -13  -22   43  -32   -1   44    4  -66  -18   -3    1   78
## 1956  -35  -13   47  -44    9   51  -17  -47  -42    1   14   70
## 1957  -26  -23   69  -63   15   60  -24  -41  -65    6   15   73
## 1958  -27  -26   66  -58   29   57  -16  -42 -115   56   -4   76
## 1959   -4  -41   82  -74   34   28   24  -65 -107   40   11   88
## 1960  -31  -38   54   14  -31   52   24 -103  -82   51  -24  113
```

## 时序图 {#sec-ts-plot}

美国纽黑文自1912年至1971年的年平均气温变化见图 \@ref(fig:new-haven-temp)。


```r
plot(nhtemp, main = "美国纽黑文的年平均气温", family = "Noto Serif CJK SC")
```

\begin{figure}

{\centering \includegraphics{time-series-analysis_files/figure-latex/new-haven-temp-1} 

}

\caption{美国纽黑文的年平均气温，单位：华氏温度}(\#fig:new-haven-temp)
\end{figure}




```r
# 构造多个 ts 序列
tmp <- ts(
  data = data.frame(
    pay_one = rnorm(20),
    pay_two = rnorm(20),
    pay_three = rnorm(20)
  ),
  start = c(1961, 1), frequency = 12
)

plot(tmp, main = "pay cnt")
```



\begin{center}\includegraphics{time-series-analysis_files/figure-latex/unnamed-chunk-7-1} \end{center}

```r
plot(tmp, plot.type = "single", col = 1:3, ylab = "pay cnt")
```



\begin{center}\includegraphics{time-series-analysis_files/figure-latex/unnamed-chunk-7-2} \end{center}

## 基本概念 {#sec:frequency}


```r
# 从某个完整的一天开始统计数据
# 分钟级 ts 数据
time_min <- format(seq.POSIXt(
  from = as.POSIXct("2020-01-01 00:00"),
  to = as.POSIXct("2020-01-01 23:59"), by = "1 min"
),
format = "%H:%M"
)
tmp = ts(data = rnorm(1440 * 3), start = c(2020, 12),
         frequency = 24*60*365.25, names = "访问量")
plot(tmp)
```



\begin{center}\includegraphics{time-series-analysis_files/figure-latex/unnamed-chunk-8-1} \end{center}

frequency: the number of observations per unit of time.

frequency 里面乘以 365.25 而不是 365 是因为每隔 4 年出现一次 366 天，多出的这一天分摊到每一年。
frequency 表示单位时间内发生的次数，ts 对象的时间基准为 1 年，所以，frequency = 4 表示一年出现四次，依此类推。关于季节性周期的说明 <https://robjhyndman.com/hyndsight/seasonal-periods/>。

序列长度一样，但是周期不一样，这里的单位时间指的是1年


```r
# 季数据
op = par(mfrow = c(2,2), mar = c(4,4,4,1))
tmp = ts(rnorm(20), start = c(1961, 1), frequency = 4)
plot(tmp, main = "Quarterly", type = "b")
# 月数据
tmp = ts(rnorm(20), start = c(1961, 1), frequency = 12) # 自然时间周期是一年，每月采样
plot(tmp, main = "Monthly", type = "b")
# 日数据
tmp = ts(rnorm(20), start = c(1961, 1), frequency = 365.25)
plot(tmp, main = "Daily", type = "b")
# 分钟数据
tmp = ts(rnorm(20), start = c(1961, 1), frequency = 24*60*365.25)
plot(tmp, main = "Minutely", type = "b")
```



\begin{center}\includegraphics{time-series-analysis_files/figure-latex/unnamed-chunk-9-1} \end{center}

```r
par(op)
```

默认情况下，自然时间周期是一年，每月采样。那可不可以设置自然时间周期是一周，每天采样呢？
当然可以，只是 Base R 暂不支持，其实表达数据粒度的能力没有变化，以年或周为基准，都可以表达上面的季、月、日、分钟数据。

deltat 和 frequency 只需提供一个参数值即可 deltat = 1/12 和 frequency = 12 表示同样的含义。

R 4.0.0 开始，frequency 不必是整数，还可以是小数，frequency = .2 表示每 5 个时间单位抽样一次，根据周期 T 和频率 f 的关系 T = 1/f


```r
tmp = ts(rnorm(20), start = c(1961, 1), frequency = .2)
plot(tmp, type = "b")
```



\begin{center}\includegraphics{time-series-analysis_files/figure-latex/unnamed-chunk-10-1} \end{center}

ts 和 seq 构造时间向量的关系是什么？


```r
seq(from = 1961, to = 2056, by = 5)
```

```
##  [1] 1961 1966 1971 1976 1981 1986 1991 1996 2001 2006 2011 2016 2021 2026 2031
## [16] 2036 2041 2046 2051 2056
```

即每隔5年抽样一次，采一个数据点


```r
ts(rnorm(20), start = c(1961, 1), frequency = 365.25/7)
```

```
## Time Series:
## Start = 1961 
## End = 1961.36413415469 
## Frequency = 52.1785714285714 
##  [1]  0.92778224 -0.33497473  0.03163971  0.56505945  0.97833416 -1.51024167
##  [7]  0.10942815 -1.73153351  1.07624918 -0.95820468  0.20071616  0.02790389
## [13] -1.78162591  1.51820198  0.84707559 -1.25067288  0.37305630 -0.41749863
## [19] -0.46821106 -0.96636785
```

周数据，一周采一个点，采了 20 个点

## 时序检验 {#sec-ts-tests}



参数的计算公式，实现的 R 代码

- Applies linear filtering to a univariate time series or to each series separately of a multivariate time series. 过滤

一元时间序列的线性过滤，或者对多元时间序列的单个序列分别做线性过滤

$$
y[i] = x[i] + f[1]*y[i-1] +\ldots+ f[p]*y[i-p]
$$

$$
y[i] = f[1]*x[i+o] + \ldots + f[p]*x[i+o-(p-1)]
$$

其中 $o$ 代表 offset


介绍 FTT 算法细节

不同的方法对时间序列平滑的影响 FTT 快速傅里叶变换算法


```r
usage(stats::filter)
```

```
## filter(x, filter, method = c("convolution", "recursive"), sides = 2L,
##     circular = FALSE, init = NULL)
```

- `filter()` 时间序列线性过滤
- `fft()` 快速离散傅里叶变换


## 指数平滑 {#sec-exponential-smoothing}


## Holt-Winters {#sec-holt-winters}

**可加** Holt-Winters [@Winters_1960_Forecasting;@Holt_2004_Forecasting] 预测函数，周期长度为 p

$$
\hat{Y}[t+h] = a[t] + h * b[t] + s[t - p + 1 + (h - 1) \mod p
$$

其中 $a[t], b[t], s[t]$ 由以下决定

\begin{align}
a[t] &= \alpha (Y[t] - s[t-p]) + (1-\alpha) (a[t-1] + b[t-1]) \\
b[t] &= \beta (a[t] - a[t-1]) + (1-\beta) b[t-1] \\
s[t] &= \gamma (Y[t] - a[t]) + (1-\gamma) s[t-p]
\end{align}


可乘 Holt-Winters

$$
\hat{Y}[t+h] = (a[t] + h * b[t]) * s[t - p + 1 + (h - 1) \mod p]
$$

其中  $a[t], b[t], s[t]$ 由如下决定


\begin{align}
a[t] &= \alpha (Y[t] / s[t-p]) + (1-\alpha) (a[t-1] + b[t-1]) \\
b[t] &= \beta (a[t] - a[t-1]) + (1-\beta) b[t-1] \\
s[t] &= \gamma (Y[t] / a[t]) + (1-\gamma) s[t-p]
\end{align}

`HoltWinters()` 用 Shiny App / 动画的形式展示 $\alpha, \beta, \gamma$ 三个参数对模型预测的影响，参数的确定通过最小化预测均方误差


```r
## Seasonal Holt-Winters
(m <- HoltWinters(co2))
plot(m)
plot(fitted(m))

p <- predict(m, 50, prediction.interval = TRUE)
plot(m, p)

(m <- HoltWinters(AirPassengers, seasonal = "mult"))
plot(m)

## 指数平滑 Exponential Smoothing
m2 <- HoltWinters(x, gamma = FALSE, beta = FALSE)
lines(fitted(m2)[,1], col = 3)
```

## 1749-2013 年太阳黑子数据 {#sec-sunspots}

再从官网拿到最近的数据



```r
plot(sunspot.month, xlab = "Year", ylab = "Monthly sunspot numbers",
     main = "Monthly mean relative sunspot numbers from 1749 to 2013")

autoplot(sunspot.month,
  main = "Monthly mean relative sunspot numbers from 1749 to 2013",
  xlab = "Year", ylab = "Monthly sunspot numbers"
)
```

\begin{figure}

{\centering \includegraphics{time-series-analysis_files/figure-latex/sunspot-month-1} \includegraphics{time-series-analysis_files/figure-latex/sunspot-month-2} 

}

\caption{时序图：太阳黑子月均数量}(\#fig:sunspot-month)
\end{figure}


```r
autoplot(sunspots)
```



\begin{center}\includegraphics{time-series-analysis_files/figure-latex/unnamed-chunk-15-1} \end{center}


```r
autoplot(sunspot.year, xlab = "Year", ylab = "Yearly Sunspot Data, 1700-1988") +
  theme_minimal()
```

\begin{figure}

{\centering \includegraphics{time-series-analysis_files/figure-latex/sunspots-year-tsplot-1} 

}

\caption{太阳黑子数量年平均时序图}(\#fig:sunspots-year-tsplot)
\end{figure}



```r
library(dygraphs)
hw <- HoltWinters(sunspot.month)
predicted <- predict(hw, n.ahead = 72, prediction.interval = TRUE)

dygraph(predicted, main = "Predicted sunspot numbers") %>%
  dyAxis("x", drawGrid = FALSE) %>%
  dySeries(c("lwr", "fit", "upr"), label = "sunspot") %>%
  dyOptions(colors = hcl.colors(3))
```



```r
par(family = "Noto Serif CJK SC")
plot(sunspot.month, col = "black")
lines(sunspots, col = "red")
legend("topright", legend = c("1749 至今", "1749-1983"), col = c("black", "red"), lty = 1)
```

\begin{figure}

{\centering \includegraphics{time-series-analysis_files/figure-latex/sunspot-1} 

}

\caption{月均太阳黑子数}(\#fig:sunspot)
\end{figure}


## 1991-1998 年欧洲主要股票市场日闭市价格指数 {#sec-EuStockMarkets}


```r
matplot(time(EuStockMarkets), EuStockMarkets,
  main = "",
  xlab = "Date", ylab = "closing prices",
  pch = 17, type = "l", col = 1:4
)
legend("topleft", colnames(EuStockMarkets), pch = 17, lty = 1, col = 1:4)
```

\begin{figure}

{\centering \includegraphics{time-series-analysis_files/figure-latex/unnamed-chunk-16-1} 

}

\caption{1991-1998年间欧洲主要股票市场日闭市价格指数图 
 德国 DAX (Ibis), Switzerland SMI, 法国 CAC 和 英国 FTSE}(\#fig:unnamed-chunk-16)
\end{figure}


```r
# 考虑收集加入最新的数据 1991~1998年的数据
plot(EuStockMarkets, plot.type = "single", col = hcl.colors(4))
legend("topleft", colnames(EuStockMarkets),
  col = hcl.colors(4), text.col = hcl.colors(4), lty = 1,
  box.col = NA, inset = 0.05
)
```



\begin{center}\includegraphics{time-series-analysis_files/figure-latex/EuStockMarkets-1} \end{center}

## 自回归模型 {#sec-autoregressive}

`ar()` 

## 移动平均模型 {#sec-moving-average}

`arima()`

## 自回归移动平均模型 {#sec-autoregressive-movement-average}

`arima()` ARIMA 

## 自回归条件异方差模型 {#sec-autoregressive-conditional-heteroskedasticity}

自回归条件异方差模型 ARCH

## 广义自回归条件异方差模型 {#sec-generalized-autoregressive-conditional-heteroskedasticity}

广义自回归条件异方差模型 （Generalized Autoregressive Conditional Heteroskedasticity，简称 GARCH ）


## 其它特征的时间序列 {#sec-other-ts}



```r
plot(JohnsonJohnson)
plot(AirPassengers)
plot(nottem)
plot(lynx)
```

\begin{figure}

{\centering \subfloat[1960-1980年强生公司每股季度收益(\#fig:other-ts-1)]{\includegraphics[width=0.45\linewidth]{time-series-analysis_files/figure-latex/other-ts-1} }\subfloat[1949-1960年月均航班乘客数量(\#fig:other-ts-2)]{\includegraphics[width=0.45\linewidth]{time-series-analysis_files/figure-latex/other-ts-2} }\newline\subfloat[1920-1939 年诺丁汉月均气温(\#fig:other-ts-3)]{\includegraphics[width=0.45\linewidth]{time-series-analysis_files/figure-latex/other-ts-3} }\subfloat[1821-1934 年加拿大山猫陷阱数量(\#fig:other-ts-4)]{\includegraphics[width=0.45\linewidth]{time-series-analysis_files/figure-latex/other-ts-4} }

}

\caption{时间序列：非平稳、周期性、非线性}(\#fig:other-ts)
\end{figure}


## 港股走势 {#sec-hk-stock}

美团、阿里巴巴在香港上市


```r
# 美团
meituan <- quantmod::getSymbols("3690.HK", auto.assign = FALSE, src = "yahoo", from = '2019-06-30')
# 阿里
ali <- quantmod::getSymbols("9988.HK", auto.assign = FALSE, src = "yahoo", from = '2019-06-30')
# 京东
sw <- quantmod::getSymbols("9618.HK", auto.assign = FALSE, src = "yahoo", from = '2019-06-30')
# 腾讯
tx <- quantmod::getSymbols("0700.HK", auto.assign = FALSE, src = "yahoo", from = '2019-06-30')
```

```r
# 如何共 x 轴，右对齐
plot(as.ts(meituan[, "3690.HK.Close"]), col = "orange", ylab = "股价")
lines(as.ts(ali[, "9988.HK.Close"]), col = "springgreen4")
lines(as.ts(sw[, "9618.HK.Close"]), col = "purple4")
lines(as.ts(tx[, "0700.HK.Close"]), col = "lightsteelblue4")
legend("topright", col = c("Orange", "springgreen4", "purple4", "lightsteelblue4"), 
       lty = 1, legend = c("美团", "阿里", "京东", "腾讯") )
```

## 美股走势 {#sec-us-stock}

拼多多、京东、阿里巴巴、51Talk 在美股上市


```r
# 拼多多
pdd <- quantmod::getSymbols("PDD", auto.assign = FALSE, src = "yahoo")
# 京东
jd <- quantmod::getSymbols("JD", auto.assign = FALSE, src = "yahoo")
# 阿里巴巴
baba <- quantmod::getSymbols("BABA", auto.assign = FALSE, src = "yahoo")
# 51Talk
coe <- quantmod::getSymbols("COE", auto.assign = FALSE, src = "yahoo", from = '2016-06-30')
```



## 51Talk 股价走势 {#sec-coe-stock}

Joshua M. Ulrich 开发维护的 [quantmod](https://github.com/joshuaulrich/quantmod) 包可以下载国内外股票市场的数据

51talk 于 2016年6月10日在美国纽交所上市，股票代码 COE， 2020年1月22日，武汉封城，受新冠肺炎病毒影响，政府停课不停学的号召，线下教育纷纷转线上，线上教育的春天来临，股价开始回升到发行价的水平，在公司将资源转变为能力后，预期公司股价继续翻倍，回到理性的水平。


```r
coe <- quantmod::getSymbols("COE", auto.assign = FALSE, src = "yahoo", from = '2016-06-30')
```

读者可以从雅虎财经获取数据源 <https://finance.yahoo.com/>


```r
plot(coe[, "COE.Close"],
  subset = "2016-06-30/2021-06-30",
  col = "Orange", main = "COE Stock Close Price"
)
```

\begin{figure}

{\centering \includegraphics{time-series-analysis_files/figure-latex/coe-close-price-1} 

}

\caption{51Talk公司上市以来的股价走势}(\#fig:coe-close-price)
\end{figure}

COE 股价变化趋势见下图，包含开盘价 Open、最低价 Low、最高价 High、闭市价 Close 和调整价 Adjust 和交易额 Volume


```r
autoplot(coe)
```

\begin{figure}

{\centering \includegraphics[width=0.85\linewidth]{time-series-analysis_files/figure-latex/coe-price-1} 

}

\caption{CEO 股价变化趋势}(\#fig:coe-price)
\end{figure}


## 运行环境 {#sec-tsa-sessioninfo}


```r
sessionInfo()
```

```
## R version 4.1.2 (2021-11-01)
## Platform: x86_64-pc-linux-gnu (64-bit)
## Running under: Ubuntu 20.04.3 LTS
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
## [1] dygraphs_1.1.1.6 ggfortify_0.4.14 ggplot2_3.3.5    formatR_1.11    
## 
## loaded via a namespace (and not attached):
##  [1] compiler_4.1.2    pillar_1.6.4      xts_0.12.1        tools_4.1.2      
##  [5] sysfonts_0.8.5    digest_0.6.29     lattice_0.20-45   evaluate_0.14    
##  [9] lifecycle_1.0.1   tibble_3.1.6      gtable_0.3.0      pkgconfig_2.0.3  
## [13] rlang_0.4.12      DBI_1.1.2         curl_4.3.2        yaml_2.2.1       
## [17] xfun_0.29         fastmap_1.1.0     gridExtra_2.3     showtextdb_3.0   
## [21] withr_2.4.3       stringr_1.4.0     dplyr_1.0.7       knitr_1.37       
## [25] htmlwidgets_1.5.4 generics_0.1.1    vctrs_0.3.8       grid_4.1.2       
## [29] tidyselect_1.1.1  glue_1.6.0        R6_2.5.1          fansi_0.5.0      
## [33] rmarkdown_2.11    bookdown_0.24     TTR_0.24.3        farver_2.1.0     
## [37] tidyr_1.1.4       purrr_0.3.4       magrittr_2.0.1    scales_1.1.1     
## [41] ellipsis_0.3.2    htmltools_0.5.2   quantmod_0.4.18   showtext_0.9-4   
## [45] assertthat_0.2.1  colorspace_2.0-2  labeling_0.4.2    utf8_1.2.2       
## [49] stringi_1.7.6     munsell_0.5.0     crayon_1.4.2      zoo_1.8-9
```
