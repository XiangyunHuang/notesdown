# 试验设计 {#chap:experimental-design}


```r
library(magrittr)
library(ggplot2)
```

::: {.rmdtip data-latex="{提示}"}
我想不少人初次见到本章题目首先疑惑的可能是到底是试验还是实验？这里做一下说明，实验的意思是带有验证性的目的，已经有结果了，做实验验证某个规律，常常用在物理、化学的课堂里，学生做实验验证自由落体运动、做实验测量重力加速度等等。试验的意思是人为设定一系列操作步骤去探索未知，不确定结果如何，试一试。
:::

试验设计（Design of Experiment，简称 DOE）是一个应用性很强的学科领域，R. A. Fisher 曾在农业站做实验验证孟德尔的豌豆实验结果。

Vikneswaran 提供了一份书籍 @Berger2002 的补充材料 --- [An R companion to "Experimental Design"](http://CRAN.R-project.org/doc/contrib/Vikneswaran-ED_companion.pdf)，目前 Paul Berger 的这本书已经迭代到第二版 [@Berger2018]，2015 年 Paul Berger 出版了新书 《Improving the User Experience through Practical Data Analytics: Gain Meaningful Insight and Increase Your Bottom Line》 [@Berger2015] 颇具应用性，结合产品用户体验来谈试验设计。

Bill Venables 开发的 [conf.design](https://cran.r-project.org/package=conf.design) 是试验设计领域的核心 R 包，CRAN 官网上试验设计视图 <https://cran.r-project.org/view=ExperimentalDesign> 可以让我们对试验设计这个领域有一个粗略的了解。

推荐读者使用贴合 R 语言的试验设计入门书 《Design and Analysis of Experiments with R》[@Lawson2014]，作者提供相应的 R 包 [daewr](https://cran.r-project.org/package=daewr) 打包了该书的数据和代码。另外，推荐的读物是 《Statistics for Experimenters: Design, Innovation, and Discovery》[@Box2005] 和《Trustworthy Online Controlled Experiments: A Practical Guide to A/B Testing》 [@Ron2020]。

另一个和试验设计紧密相关的话题是敏感性分析，推荐 Devin Incerti 的敏感性分析系列博客 <https://devinincerti.com/blog.html>，R 包 [sensitivity](https://CRAN.R-project.org/package=sensitivity) 提供140+ 页的手册，功能非常强，模型的全局敏感性分析， [SWATplusR](https://github.com/chrisschuerz/SWATplusR) SWAT 分析法和 R 语言结合。

## 学生睡眠质量 {#sec:sleep}

<!-- 单因素两水平方差分析 -->


```r
ggplot(data = sleep, aes(x = group, y = extra, color = group)) +
  geom_boxplot() +
  geom_jitter() +
  theme_minimal()
```



\begin{center}\includegraphics{experimental-design_files/figure-latex/sleep-data-1} \end{center}

## 驱虫喷雾的效果 {#sec:insect-sprays}

<!-- 单因素多水平方差分析，多重比较 -->

InsectSprays 数据集 [@Beall1942] 来源于农业实验，记录了不同杀虫剂的效果，即杀虫剂过后，单位实验区域内虫子的数量，如图\@ref(fig:insect-sprays)所示，横轴表示杀虫剂种类，纵轴表示虫子数量。


```r
ggplot(data = InsectSprays, aes(x = spray, y = count, color = spray)) +
  geom_boxplot() +
  geom_jitter() +
  theme_minimal()
```

\begin{figure}

{\centering \includegraphics{experimental-design_files/figure-latex/insect-sprays-1} 

}

\caption{不同杀虫剂的效果}(\#fig:insect-sprays)
\end{figure}

先创建一个 aov 对象，把它命名为 mod1，见下方


```r
mod1 <- aov(count ~ spray, data = InsectSprays)
```

第一个参数告诉 R count 是响应变量，spray 是协变量，第二个参数告诉 R 去对象 InsectSprays 中寻找这些变量。下面把分析结果以一种漂亮的格式打印出来


```r
summary(mod1)
```

```
##             Df Sum Sq Mean Sq F value Pr(>F)    
## spray        5   2669   533.8    34.7 <2e-16 ***
## Residuals   66   1015    15.4                   
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
```

表格中的条目是很容易理解的，比如最右边的列表示 P 值。如果我们想做固定显著性水平下的检验，比如 $\alpha = 0.075$ 时的 F 统计量的值，


```r
qf(0.075, 5, 66, lower.tail = F)
```

```
## [1] 2.110783
```

上面的命令是说 $F(5, 66)$ 分布的 0.075 分位点，最后一个参数很关键，因为默认情况下 R 计算下分位点，详情见 `?qf`。

方差分析做了三个假设

1. 残差 $\epsilon_{ij}$ 是相互独立的随机变量；
1. 残差 $\epsilon_{ij}$ 服从正态分布；
1. 残差 $\epsilon_{ij}$ 均值为 0，方差是固定的常数。

假设 1 和 3 通过图来检验，假设 2 通过 QQ 图来检验。值得一提的是 mod1 对象除了打印出来，还有很多方法


```r
names(mod1)
```

```
##  [1] "coefficients"  "residuals"     "effects"       "rank"         
##  [5] "fitted.values" "assign"        "qr"            "df.residual"  
##  [9] "contrasts"     "xlevels"       "call"          "terms"        
## [13] "model"
```

比如获取残差，考虑到篇幅，这里仅显示前 10 个


```r
head(mod1$residuals, 10)
```

```
##    1    2    3    4    5    6    7    8    9   10 
## -4.5 -7.5  5.5 -0.5 -0.5 -2.5 -4.5  8.5  2.5  5.5
```


```r
par(mar = c(4, 4, 2, 2), mfrow = c(2,2))
plot(mod1)
```



\begin{center}\includegraphics{experimental-design_files/figure-latex/unnamed-chunk-7-1} \end{center}


```r
plot(mod1$fitted.values, mod1$residuals, main = "Residuals vs. Fitted", pch = 20)
abline(h = 0, lty = 2)
```



\begin{center}\includegraphics{experimental-design_files/figure-latex/unnamed-chunk-8-1} \end{center}


```r
plot(mod1$model$spray, mod1$residuals, main = "Residuals vs. Levels" )
```



\begin{center}\includegraphics{experimental-design_files/figure-latex/unnamed-chunk-9-1} \end{center}


```r
plot(1:72, mod1$residuals, main = "Residuals vs. Time Order")
abline(h = 0, lty = 2)
```



\begin{center}\includegraphics{experimental-design_files/figure-latex/unnamed-chunk-10-1} \end{center}


```r
qqnorm(mod1$residuals, pch = 20)
qqline(mod1$residuals)
```



\begin{center}\includegraphics{experimental-design_files/figure-latex/unnamed-chunk-11-1} \end{center}

如果上面的假设显著失效，我们要采用非参数检验


```r
mod2 <- kruskal.test(count ~ spray, data = InsectSprays)
mod2
```

```
## 
## 	Kruskal-Wallis rank sum test
## 
## data:  count by spray
## Kruskal-Wallis chi-squared = 54.691, df = 5, p-value = 1.511e-10
```

计算给定水平下的置信区间，构造置信水平为 95\% 的区间

$$
\bar{X} \pm t_{1-\alpha/2}(s/\sqrt{n})
$$
以 A 号杀虫剂为例，


```r
xbar = mean(InsectSprays[InsectSprays$spray == "A", "count"])
t_crit <- qt(0.025, mod1$df.residual, lower.tail = F)
s <- sqrt(sum((mod1$residuals)^2) / mod1$df.residual)
n <- sum(InsectSprays$spray == "A")
# 最后置信区间的上下限
c(xbar - t_crit * (s/ sqrt(n)), xbar + t_crit * (s/ sqrt(n)))
```

```
## [1] 12.23958 16.76042
```

比较 A 号和 C 号杀虫剂的效果，计算两个均值差的置信区间

$$
\bar{X}_1 - \bar{X}_2 \pm t_{1-\alpha/2}(s/\sqrt{1/n_1 + 1/n_2})
$$


```r
n1 <- sum(InsectSprays$spray == "A")
n2 <- sum(InsectSprays$spray == "C")

x1bar = mean(InsectSprays[InsectSprays$spray == "A", "count"])
x2bar = mean(InsectSprays[InsectSprays$spray == "C", "count"])
```

代入公式即可计算得到置信区间


```r
(x1bar - x2bar) - t_crit * s * sqrt( 1/ n1 + 1/n2)
```

```
## [1] 9.219948
```

```r
(x1bar - x2bar) + t_crit * s * sqrt( 1/ n1 + 1/n2)
```

```
## [1] 15.61339
```

Fisher's 最小显著性检验 (Fisher's Least Significant Difference Test) 即


```r
t_crit * s * sqrt( 1/ n1 + 1/n2)
```

```
## [1] 3.196719
```

Tukey's Honestly Significant Difference Test 主要测量成对实验的误差比率，假定每个水平下的实验次数是相等的，只需将上面的 aov 对象传递给函数 `TukeyHSD()`


```r
mod3 <- TukeyHSD(mod1, ordered = TRUE)
mod3
```

```
##   Tukey multiple comparisons of means
##     95% family-wise confidence level
##     factor levels have been ordered
## 
## Fit: aov(formula = count ~ spray, data = InsectSprays)
## 
## $spray
##           diff       lwr       upr     p adj
## E-C  1.4166667 -3.282742  6.116075 0.9488669
## D-C  2.8333333 -1.866075  7.532742 0.4920707
## A-C 12.4166667  7.717258 17.116075 0.0000000
## B-C 13.2500000  8.550591 17.949409 0.0000000
## F-C 14.5833333  9.883925 19.282742 0.0000000
## D-E  1.4166667 -3.282742  6.116075 0.9488669
## A-E 11.0000000  6.300591 15.699409 0.0000000
## B-E 11.8333333  7.133925 16.532742 0.0000000
## F-E 13.1666667  8.467258 17.866075 0.0000000
## A-D  9.5833333  4.883925 14.282742 0.0000014
## B-D 10.4166667  5.717258 15.116075 0.0000002
## F-D 11.7500000  7.050591 16.449409 0.0000000
## B-A  0.8333333 -3.866075  5.532742 0.9951810
## F-A  2.1666667 -2.532742  6.866075 0.7542147
## F-B  1.3333333 -3.366075  6.032742 0.9603075
```

<!-- TODO: 上下限是怎么计算的，调整的 P 值是怎么算的？ -->

其中，`diff` 表示均值之差，`lwr` 和 `upr` 表示置信区间的上下限，$p_{adj}$ 是对应的。检查一下，看看哪些置信区间包含 0 ，包含 0 的表示不显著，从第三行来看， A 和 C 之间差别显著。之前计算过 A、C 均值，均值之差即


```r
(x1bar - x2bar)
```

```
## [1] 12.41667
```

在误差比率 $\alpha = 0.05$ 的情况下，如果你想手动计算 HSD 值


```r
q_crit <- qtukey(p = 0.05, nmeans = length(mod1$xlevels[[1]]), df = mod1$df.residual, lower.tail = F)
# mod1$df.residual 是 6 
hsd <- q_crit * s / sqrt(6)
hsd
```

```
## [1] 6.645967
```

将模型结果 mod3 用图画出来，见下图


```r
plot(mod3)
```

\begin{figure}

{\centering \includegraphics[width=0.75\linewidth]{experimental-design_files/figure-latex/tukey-hsd-1} 

}

\caption{成对显著性水平}(\#fig:tukey-hsd)
\end{figure}

关于多重比较请见 Frank Bretz, Torsten Hothorn, Peter Westfall 的书《Multiple Comparisons Using R》及配套 R 包 [multcomp](https://cran.r-project.org/package=multcomp)，该 R 包现由 Torsten Hothorn 维护，他还维护了一个由数据集构成的 R 包 [TH.data](https://cran.r-project.org/package=TH.data)，我们后续章节也会用到。

## 重复数不等的多重比较 {#sec:multiple-comparison}

<!-- 这个方法由谁提出来的呢？ [数理统计讲义](https://bookdown.org/hezhijian/book/) 和 [Advanced Statistical Computing](https://bookdown.org/rdpeng/advstatcomp/) -->

Tukey 的检验方法要求各个组的重复数相等，而方差分析的重复数不等时，我们需要用如下方法

$$
\frac{(\bar{y}_{i\cdot} - \bar{y}_{j\cdot}) - (\mu_i - \mu_j)}{\sqrt{\frac{1}{m_i} + \frac{1}{m_j}} \hat{\sigma}} \sim t(f_e)
$$

$$
c_{ij} = \sqrt{(r-1)F_{1-\alpha}(r-1, f_e)(\frac{1}{m_i} +\frac{1}{m_j})\hat{\sigma^2}}
$$

$\hat{\sigma^2} = S_e/ f_e$ 是 $\sigma^2$ 无偏估计。

$$
y_{ij} = \mu + a_i + \epsilon_{ij}, \quad i = 1,2,\ldots,r, \quad j = 1,2, \ldots, m_i. \quad
\sum_{i=1}^{r}m_{i}a_{i} = 0,
$$
其中，$\epsilon_{ij}$ 相互独立，服从 $\mathcal{N}(0, \sigma^2)$.

$f_e = n - r, S_e = \sum_{i=1}^{r}\sum_{j=1}^{m_{i}}(y_{ij} - \bar{y}_{i\cdot})^2 = S_T - S_A$

## 不同地区的草类植物吸收二氧化碳的情况 {#sec:co2}

<!-- 多因素多水平方差分析：绘图表示5个变量 -->

通过观察不同地区的草类植物吸收二氧化碳的情况，研究植物的耐寒性


```r
ggplot(data = CO2, aes(x = conc, y = uptake, color = Type, shape = Treatment)) +
  geom_point() +
  geom_line() +
  facet_wrap(~Plant, ncol = 3) +
  theme_minimal() +
  labs(x = "conc (mL/L)", y = "uptake (umol/m^2 sec)")
```

\begin{figure}

{\centering \includegraphics{experimental-design_files/figure-latex/co2-1} 

}

\caption{草类植物吸收二氧化碳的量}(\#fig:co2)
\end{figure}

## 果园喷雾剂的效力 {#sec:orchard-sprays}

<!-- 拉丁方设计 -->

评估喷雾杀虫剂的在果园的效果


```r
data("OrchardSprays")
```

## 验证孟德尔的豌豆实验结果 {#sec:npk}

<!-- 试验设计：正交设计 -->
R. A. Fisher 在农业站做实验验证孟德尔的豌豆实验结果


```r
data("npk")
```

豌豆产量和氮 (nitrogen, N) 磷酸盐 (phosphate, P) 钾盐 (potassium, K) 的关系
