# 参数估计 {#chap:parameter-estimators}

<!-- 本章开始介绍参数估计的内容，先从第 \@ref(sec:point-estimator) 节点估计开始 -->

> Jeremy Koster: My students were looking at the estimated varying intercepts for each higher-level group (or the "BLUP's", as some people seem to call them).
> 
> Douglas Bates: As Alan James once said, "these values are just like the BLUPs - Best Linear Unbiased Predictors - except that they aren't linear and they aren't unbiased and there is no clear sense in which they are "best", but other than that ..."
>
>   --- Jeremy Koster and Douglas Bates [^JK-help-2012]

[^JK-help-2012]: <https://stat.ethz.ch/pipermail/r-sig-mixed-models/2012q3/018817.html>

## 点估计 {#sec:point-estimator}



- 矩估计
- 极大似然估计
- 最小二乘估计
- 同变估计
- 稳健估计

单参数和多参数模型的参数估计，比如指数分布、泊松分布、二项分布、正态分布，线性模型各个估计的推导过程

::: {.rmdnote data-latex="{注意}"}
应当考虑 $(X^{\top}X)^{-1}$ 不存在的情况，在均方误差最小的意义下，不必要求 $\beta$ 的估计 $\hat{\beta}$ 满足无偏性的要求，所以介绍岭回归估计 $\hat{\beta}_{ridge}$、压缩估计 $\hat{\beta}_{jse}$、主成分估计 $\hat{\beta}_{pca}$ 和偏最小二乘估计 $\hat{\beta}_{pls}$。相比于 $\hat{\beta}_{pca}$， $\hat{\beta}_{pls}$ 考虑了响应变量的作用。《数理统计引论》第5章第5节线性估计类从改进 LS 估计出发，牺牲一部分估计的偏差，即采用有偏的估计，达到总体均方误差更小的效果 [@Stat_1981_Chen]

James-Stein 估计可不可以看作一种压缩估计？从它牺牲一部分偏差，获取整体方差的降低来看和上面应该有某种联系
:::

- [昔日因，今日意](https://cosx.org/2014/04/lmm-and-me) 讲线性混合效应模型和很多模型之间的联系
- [那些年，我们一起追的 EB](https://cosx.org/2012/05/chase-after-eb)  James-Stein 估计和岭回归估计的联系
- [统计学习那些事](https://cosx.org/2011/12/stories-about-statistical-learning)  lasso 和 boosting 之间的联系


### 矩估计 {#sec:moments-estimation}

### 最小二乘估计 {#sec:lse}

谈非线性最小二乘，这段话的意思是非线性模型不要谈 ANOVA 和 R^2 之类的东西

> As one of the developers of the `nls` function I would like to state that the lack of automatic ANOVA, $R^2$ and $adj. R^2$ from `nls` is a feature, not a bug :-)
>
>   --- Douglas Bates [^DB-help-2000]

[^DB-help-2000]: <https://stat.ethz.ch/pipermail/r-help/2000-August/007778.html>

> 最小二乘估计是一种非参数估计方法（对数据分布没有假设，只要预测误差达到最小即可），而极大似然估计是一种参数估计方法（观测数据服从带参数的多元分布）

非线性最小二乘估计


```r
# Nonlinear least-squares using nlm()
# demo(nlm)

# Helical Valley Function
# 非线性最小二乘

theta <- function(x1, x2) (atan(x2 / x1) + (if (x1 <= 0) pi else 0)) / (2 * pi)
## 更加简洁的表达
theta <- function(x1, x2) atan2(x2, x1) / (2 * pi)
# 目标函数
f <- function(x) {
  f1 <- 10 * (x[3] - 10 * theta(x[1], x[2]))
  f2 <- 10 * (sqrt(x[1]^2 + x[2]^2) - 1)
  f3 <- x[3]
  return(f1^2 + f2^2 + f3^2)
}

## explore surface {at x3 = 0}
x <- seq(-1, 2, length.out = 50)
y <- seq(-1, 1, length.out = 50)
z <- apply(as.matrix(expand.grid(x, y)), 1, function(x) f(c(x, 0)))

contour(x, y, matrix(log10(z), 50, 50))

nlm.f <- nlm(f, c(-1, 0, 0), hessian = TRUE)

points(rbind(nlm.f$estim[1:2]), col = "red", pch = 20)
```



```r
### the Rosenbrock banana valley function 香蕉谷函数

fR <- function(x) {
  x1 <- x[1]
  x2 <- x[2]
  100 * (x2 - x1 * x1)^2 + (1 - x1)^2
}

## explore surface
fx <- function(x) { ## `vectorized' version of fR()
  x1 <- x[, 1]
  x2 <- x[, 2]
  100 * (x2 - x1 * x1)^2 + (1 - x1)^2
}
x <- seq(-2, 2, length.out = 100)
y <- seq(-0.5, 1.5, length.out = 100)
z <- fx(expand.grid(x, y))
op <- par(mfrow = c(2, 1), mar = 0.1 + c(3, 3, 0, 0))
contour(x, y, matrix(log10(z), length(x)))

nlm.f2 <- nlm(fR, c(-1.2, 1), hessian = TRUE)
points(rbind(nlm.f2$estim[1:2]), col = "red", pch = 20)

## Zoom in :
rect(0.9, 0.9, 1.1, 1.1, border = "orange", lwd = 2)
x <- y <- seq(0.9, 1.1, length.out = 100)
z <- fx(expand.grid(x, y))
contour(x, y, matrix(log10(z), length(x)))
mtext("zoomed in")
box(col = "orange")
points(rbind(nlm.f2$estim[1:2]), col = "red", pch = 20)
par(op)
```



```r
with(
  nlm.f2,
  stopifnot(
    all.equal(estimate, c(1, 1), tol = 1e-5),
    minimum < 1e-11, abs(gradient) < 1e-6, code %in% 1:2
  )
)
```



```r
fg <- function(x) {
  gr <- function(x1, x2) {
    c(-400 * x1 * (x2 - x1 * x1) - 2 * (1 - x1), 200 * (x2 - x1 * x1))
  }
  x1 <- x[1]
  x2 <- x[2]
  structure(100 * (x2 - x1 * x1)^2 + (1 - x1)^2,
    gradient = gr(x1, x2)
  )
}

nfg <- nlm(fg, c(-1.2, 1), hessian = TRUE)
str(nfg)
```



```r
with(
  nfg,
  stopifnot(
    minimum < 1e-17, all.equal(estimate, c(1, 1)),
    abs(gradient) < 1e-7, code %in% 1:2
  )
)
```



```r
## or use deriv to find the derivatives

fd <- deriv(~ 100 * (x2 - x1 * x1)^2 + (1 - x1)^2, c("x1", "x2"))
fdd <- function(x1, x2) {}
body(fdd) <- fd

nlfd <- nlm(function(x) fdd(x[1], x[2]), c(-1.2, 1), hessian = TRUE)
str(nlfd)
```



```r
with(
  nlfd,
  stopifnot(
    minimum < 1e-17, all.equal(estimate, c(1, 1)),
    abs(gradient) < 1e-7, code %in% 1:2
  )
)
```



```r
fgh <- function(x) {
  gr <- function(x1, x2) {
    c(-400 * x1 * (x2 - x1 * x1) - 2 * (1 - x1), 200 * (x2 - x1 * x1))
  }
  h <- function(x1, x2) {
    a11 <- 2 - 400 * x2 + 1200 * x1 * x1
    a21 <- -400 * x1
    matrix(c(a11, a21, a21, 200), 2, 2)
  }
  x1 <- x[1]
  x2 <- x[2]
  structure(100 * (x2 - x1 * x1)^2 + (1 - x1)^2,
    gradient = gr(x1, x2),
    hessian  =  h(x1, x2)
  )
}

nlfgh <- nlm(fgh, c(-1.2, 1), hessian = TRUE)

str(nlfgh)
```



```r
## NB: This did _NOT_ converge for R version <= 3.4.0
with(
  nlfgh,
  stopifnot(
    minimum < 1e-15, # see 1.13e-17 .. slightly worse than above
    all.equal(estimate, c(1, 1), tol = 9e-9), # see 1.236e-9
    abs(gradient) < 7e-7, code %in% 1:2
  )
) # g[1] = 1.3e-7
```



### 极大似然估计 {#sec:mle}

<!-- 极大似然估计最初由德国数据学家 Gauss 于 1821 年提出，但未得到重视，后来， R. A. Fisher 在 1922 年再次提出极大似然的思想，探讨了它的性质，使它得到广泛的研究和应用。 -->

教材简短一句话，这里面有很多信息值得发散，一个数学家提出了统计学领域极其重要的一个核心思想，他是在研究什么的时候提出了这个想法，为什么后来没有得到重视，虽然这可能有点离题，但是对于读者可能有很多别的启迪。整整100 年以后，Fisher 又是怎么提出这一思想的呢？他做了什么使得这个思想被广泛接受和应用？

统计决策理论，任何统计推断都应该依赖损失函数，而极大似然估计未曾考虑到，这是它的局限性。 Lasso 和贝叶斯先验的关系，和损失函数的关系

是最大似然估计还是极大似然估计？当然是极大似然估计，如果有人告诉你是最大似然估计那一定是假的，这两个概念归根结底是极值和最值得区别

书本定义和性质，在后续章节介绍

介绍线性模型为何引入 REML 减少偏差

极大似然估计是费舍尔提出来的

- 边际似然 Marginal Likelihood
- 条件似然 conditional lkelihood
- 完全似然 complete Likelihood
- 层次似然 Hierarchical likelihood
- 部分似然 partial likelihood
- 剖面似然 Profile Likelihood
- 限制似然 Restricted Likelihood 
- 惩罚/边际拟似然 (PQL/MQL) Penalized Quasi-Likelihood/Marginal Quasi-Likelihood 
- 分布 边际分布 条件分布
- 似然 边际似然 条件似然
- 极大似然估计 Maximum likelihood 简称 ML
- 限制极大似然 Restricted Maximum likelihood, 简称 REML
- 惩罚拟似然 Penalized Quasi-Likelihood, 简称 PQL 和边际拟似然 Marginal Quasi-Likelihood, 简称 MQL，Profile Maximal Likelihood, 简称 PML

[拟似然估计](https://en.wikipedia.org/wiki/Quasi-maximum_likelihood_estimate)
[极大似然估计](https://en.wikipedia.org/wiki/Maximum_likelihood_estimation)
[似然函数](https://en.wikipedia.org/wiki/Likelihood_function)

Penalized maximum likelihood estimates are calculated using optimization methods such as the limited memory Broyden-Fletcher-Goldfarb-Shanno algorithm (L-BFGS).

BFGS 拟牛顿法和采样器 <https://bookdown.org/rdpeng/advstatcomp>

## 区间估计 {#chap:interval-estimation}

### 正态分布 {#subsec:ci}

<!-- 计算置信区间和覆盖概率 -->

正态分布 $\mathcal{N}(\mu,\sigma^2)$，$\sigma^2$ 未知，关于参数 $\mu$ 的置信水平为 $1 - \alpha$ 的区间估计

1. 构造统计量 $t = \frac{\bar{x} - \mu}{s/\sqrt{n}} \sim t(n-1)$
1. 参数 $\mu$ 的 $1-\alpha$ 置信区间为 $$\bar{x} \pm t_{1-\alpha/2}(n-1)s/\sqrt{n}$$

其中，$s^2 = \frac{1}{n-1}\sum_{i=1}^{n}(x_i - \bar{x})^2$ 是 $\sigma^2$ 的无偏估计。若取 $\alpha = 0.05$，则置信水平 $1 - \alpha = 0.95$。


```r
set.seed(2020) # 为了可重复，设置随机数种子
mu_ci <- function(alpha = 0.05, n = 100, mu = 4) {
  x <- rnorm(n = n, mean = mu, sd = 1)
  x_bar <- mean(x)
  d <- qt(p = 1 - alpha / 2, df = n - 1, lower.tail = TRUE) * var(x) / sqrt(n)
  c(mu = mu, lower = x_bar - d, upper = x_bar + d)
}
# 重抽样 100 次，获得 100 个置信区间
dat <- t(replicate(n = 100, mu_ci(alpha = 0.05, n = 100, mu = 4)))
dat <- transform(dat, idx = 1:100, cover = ifelse(mu >= lower & mu <= upper, TRUE, FALSE))
```

真实的参数值 $\mu = 4$，重抽样 100 次，覆盖真值的次数为 97 次，覆盖概率为 0.97


```r
# 覆盖概率
mean(dat$cover)
```

```
## [1] 0.97
```

(ref:ci) $\mu$ 的置信水平为 0.95 的置信区间


```r
library(ggplot2)
ggplot() +
  geom_segment(data = dat, aes(
    x = idx, xend = idx,
    y = lower, yend = upper, color = cover
  )) +
  geom_hline(yintercept = 4) +
  theme_minimal() +
  labs(x = "", y = "")
```

\begin{figure}

{\centering \includegraphics{parameter-estimators_files/figure-latex/ci-1} 

}

\caption{(ref:ci)}(\#fig:ci)
\end{figure}

方差 $\sigma^2$ 已知的情况下，标准正态分布 $N(\mu, \sigma^2), \mu = 0, \sigma^2 = 1$ 的参数 $\mu$ 的区间估计和覆盖概率 <https://yihui.org/animation/example/conf-int/>


### 0-1 分布 {#subsec:binomial}

设 0-1 分布 $B(1, p)$ 的成功概率 $p = 0.95$，假定是抛硬币的场景，成功概率对应正面朝上的概率为 0.95。一次实验，重复抛 10 次，有两次正面朝上。现在要根据这次实验结果估计成功概率 $p$ 的值，及其置信区间


```r
# 卡方近似
prop.test(x = 2, n = 10, p = 0.95, conf.level = 0.95, correct = TRUE)
```

```
## Warning in prop.test(x = 2, n = 10, p = 0.95, conf.level = 0.95, correct =
## TRUE): Chi-squared approximation may be incorrect
```

```
## 
## 	1-sample proportions test with continuity correction
## 
## data:  2 out of 10, null probability 0.95
## X-squared = 103.16, df = 1, p-value < 2.2e-16
## alternative hypothesis: true p is not equal to 0.95
## 95 percent confidence interval:
##  0.03542694 0.55781858
## sample estimates:
##   p 
## 0.2
```

```r
# 二项精确估计
binom.test(x = 2, n = 10, p = 0.95, conf.level = 0.95)
```

```
## 
## 	Exact binomial test
## 
## data:  2 and 10
## number of successes = 2, number of trials = 10, p-value = 1.605e-09
## alternative hypothesis: true probability of success is not equal to 0.95
## 95 percent confidence interval:
##  0.02521073 0.55609546
## sample estimates:
## probability of success 
##                    0.2
```

可知，在置信水平都是 0.95 的情况下，带连续矫正的单样本比例检验方法获得的区间估计是 (0.0354, 0.5578)， 区间长度 0.5224。精确二项检验方法获得的区间估计是 (0.0252, 0.5560)，区间长度 0.5308。


从二项分布 $B(30, 0.2)$ 中随机抽取一个样本，为可重复记，设置随机数种子为 2020


```r
set.seed(2020)
rbinom(1, size = 30, prob = 0.2) 
```

```
## [1] 7
```

得到样本观测值为 7，


```r
7 - qnorm(1 - 0.95 / 2) * sqrt(0.2 * 0.8 / 30) # 6.995
```

```
## [1] 6.995421
```

```r
7 + qnorm(1 - 0.95 / 2) * sqrt(0.2 * 0.8 / 30) # 7.0045
```

```
## [1] 7.004579
```

样本观测值 7 对应的参数 $p$ 的区间估计，如下


```r
prop.test(x = 7, n = 30, p = 0.2, conf.level = 0.95, correct = TRUE) 
```

```
## 
## 	1-sample proportions test with continuity correction
## 
## data:  7 out of 30, null probability 0.2
## X-squared = 0.052083, df = 1, p-value = 0.8195
## alternative hypothesis: true p is not equal to 0.2
## 95 percent confidence interval:
##  0.1063502 0.4270023
## sample estimates:
##         p 
## 0.2333333
```

随机变量 $X$ 服从二项分布 $B(30, 0.2)$，则概率值 $P(x \leq 7) = 0.7607$ 


```r
pbinom(7, size = 30, prob = 0.2, lower.tail = TRUE)
```

```
## [1] 0.7607906
```

已知概率值为 0.95， 即 $P(x \leq m) = 0.95$ 且 $X \sim B(30, 0.2)$，现在计算 m 的值，即求下分位点，为 10 


```r
qbinom(p = 0.95, size = 30, prob = 0.2, lower.tail = TRUE)
```

```
## [1] 10
```

::: {.rmdtip data-latex="{提示}"}
二项分布的特点，主要用于计算期望，概率 $P\big\{ C_1 +1\leq x \leq C_2 -1 \big\}$

$$
\sum_{x = C_1 + 1}^{C_2 -1} x \binom{n}{x} p^{x}(1-p)^{n-x} = np \sum_{x = C_1 + 1}^{C_2 -1} \binom{n -1}{x -1} p^{x -1}(1-p)^{(n -1)-(x-1)}
$$


```r
n = 30 
c2 = 20 
c1 = 10
p = 0.2
n * p * (pbinom(q = c2 - 2, size = n - 1, prob = p) - pbinom(q = c1 - 1, size = n - 1, prob = p))
```

```
## [1] 0.2955803
```
:::

### 置信区间和信仰区间 {#sec:confidence-fiducial-limits}

计算置信区间的覆盖概率 [binom](https://cran.r-project.org/package=binom)

二项分布的参数估计，包括点估计和区间估计 [@Test_1934_binom]

给定样本量 n = 10  0-1 分布 成功概率 p 分别取 0.1,0.2,...,1
置信度为 95% 观测到 x 取 1,2,3,..,10 时 估计 p 的上下限


```r
set.seed(2019)
x <- rbinom(n = 1, size = 10, prob = 0.1) # 结果解读
```

抛掷硬币 10 次，观测到2次正面朝上，估计正面朝上的概率

观测到正面朝上 2 次 此时请以 95% 的信心给出 p 的区间 (p_low, p_up)

绘制曲线 p 关于 x 的曲线


```r
set.seed(2019)
p <- seq(from = 0, to = 1, length.out = 11)
# 成功概率 总体参数 p 值
sapply(rep(p, each = 10), rbinom, n = 1, size = 10)
```

```
##   [1]  0  0  0  0  0  0  0  0  0  0  2  1  0  1  0  0  2  0  0  1  3  2  1  1  3
##  [26]  2  0  3  1  2  3  3  5  2  1  0  3  5  3  3  5  1  5  3  1  2  3  4  1  5
##  [51]  5  4  7  6  6  5  7  7  4  4  7  8  9  7  6  7  2  4  8  8  8  8  6  8  6
##  [76]  4  8  9  6  7  9  9  9  9  8  4  9  8  9  7 10  8  7 10  9 10  9  9  8 10
## [101] 10 10 10 10 10 10 10 10 10 10
```

计算每一次抽样获得的上下限

Clopper-Pearson 方法，即求和搜索，在保持累积概率

$$B(x,n;n,p) = \sum_{r = x}^{n} \binom{n}{r}p^r(1-p)^{n-r} = \alpha/2$$

其中 n 表示试验次数，这里是 10， p 是未知待求，已知 $\alpha = 0.05$，而 $1-\alpha$ 表示置信水平，意思是说对于我给出的区间估计，长期来看，我有 95% 的信心认为，真实值 $p$ 会落在此区间内。

对上尾部从 x 到 n 求和，计算 p，对每一个 x 都能计算出一个 p，根据二项分布的对称性，区间 $[0, x]$ 和 $[x,n]$ 的累积概率是相同的，各占 $\alpha/2$



```r
# 精确计算二项分布检验的 p
# 调用符号计算
# x = 7
fun <- function(p, r = 8, n = 10) {
  choose(n, n-2)*p^r*(1-p)^(n-r) + choose(n, n-1)*p^(n-1)*(1-p) + choose(n, n)*p^n - 0.025
}
uniroot(fun, lower = 0, upper = 1)
```

```
## $root
## [1] 0.4439038
## 
## $f.root
## [1] -2.707352e-07
## 
## $iter
## [1] 9
## 
## $init.it
## [1] NA
## 
## $estim.prec
## [1] 6.103516e-05
```



```r
# x = 8
fun <- function(p) {
  45*p^8*(1-p)^2 + 10*p^9*(1-p) + p^10 - 0.025
}
uniroot(fun, lower = 0, upper = 1)
```

```
## $root
## [1] 0.4439038
## 
## $f.root
## [1] -2.707352e-07
## 
## $iter
## [1] 9
## 
## $init.it
## [1] NA
## 
## $estim.prec
## [1] 6.103516e-05
```



```r
# x = 9
fun <- function(x) {
  9 * x^10 - 10 * x^9 + 0.025
}
# 0.555 计算下限
uniroot(fun, lower = 0, upper = 1)
```

```
## $root
## [1] 0.5549828
## 
## $f.root
## [1] 3.773379e-07
## 
## $iter
## [1] 10
## 
## $init.it
## [1] NA
## 
## $estim.prec
## [1] 6.462529e-05
```



```r
# x = 10
fun <- function(x) {
  x^10 - 0.025
}
# 0.691
uniroot(fun, lower = 0, upper = 1)
```

```
## $root
## [1] 0.6914996
## 
## $f.root
## [1] -1.194136e-06
## 
## $iter
## [1] 9
## 
## $init.it
## [1] NA
## 
## $estim.prec
## [1] 6.103516e-05
```

累积二项概率

找到最小的 p 使得其等于 9


```r
# 已知概率求上分位点

# 等于
qbinom(0.025, size = 10, prob = 0.565, lower.tail = F)
```

```
## [1] 9
```

找到使得函数为 0 的 p 中最小的那个，找到所有的根，然后取最小的那个


```r
fun <- function(p, r = 9) qbinom(0.025, size = 10, prob = p, lower.tail = F) - r
# 计算每个 x 对应的 p 
(p <- sapply(1:10, function(x) uniroot(fun, lower = 0, upper = 1, r = x)$root))
```

```
##  [1] 0.01666667 0.05333333 0.09375000 0.16000000 0.25000000 0.30000000
##  [7] 0.35000000 0.53333333 0.67500000 1.00000000
```




```r
plot(x = 1:10, y = p)
```



\begin{center}\includegraphics{parameter-estimators_files/figure-latex/unnamed-chunk-27-1} \end{center}



```r
# 二项检验 菱形置信带
set.seed(2019)

dat <- replicate(10^3, expr = {
  x = sample(0:1, size = 10, replace = TRUE, prob = c(0.8, 0.2))
  sum(x)/10
})

# 成功概率 p = 0.2 每个样本量 10
dat <- rbinom(n = 10^3, size = 10, prob = 0.2)/10
table(dat)
```

```
## dat
##   0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 
## 119 274 304 180  82  30  10   1
```



```r
# 分布图 y 轴是密度
# right = TRUE 区间形式 (a,b] 左开右闭
hist(dat, probability = T, breaks = seq(from = -0.1, to = 1, by = 0.1))
```



\begin{center}\includegraphics{parameter-estimators_files/figure-latex/unnamed-chunk-29-1} \end{center}

```r
# 0.2^10 左闭右开区间
hist(dat, probability = T, breaks = seq(from = 0, to = 1.1, by = 0.1),
     right = FALSE, xlim = c(0, 1.1))
```



\begin{center}\includegraphics{parameter-estimators_files/figure-latex/unnamed-chunk-29-2} \end{center}



```r
# 分布
library(ggplot2)
library(magrittr)
# 这个图里面会不会隐含什么信息，分布是怎样的？
# 二项展开有关系吗
dat1 <- as.data.frame(table(dat))


ggplot(data = dat1, aes(x = dat, y = Freq)) +
  geom_col()
```



\begin{center}\includegraphics{parameter-estimators_files/figure-latex/unnamed-chunk-30-1} \end{center}

```r
ggplot(as.data.frame(dat), aes(x = dat)) +
  geom_histogram(bins = 12)
```



\begin{center}\includegraphics{parameter-estimators_files/figure-latex/unnamed-chunk-30-2} \end{center}


## 最小角回归 {#sec:least-angle-regression}


1. Efron, Bradley and Hastie, Trevor and Johnstone, Iain and Tibshirani, Robert. 2004. Least angle regression. The Annals of Statistics. 32(2): 407--499. <https://doi.org/10.1214/009053604000000067>.

方差缩减技术，修偏技术

## 刀切法 {#sec:jackknife}

1. Efron, B. 1979. Bootstrap Methods: Another Look at the Jackknife. The Annals of Statistics. 7(1):1--26. <https://doi.org/10.1214/aos/1176344552>

## 重抽样 {#sec:resampling}


## Delta 方法 {#sec:delta-methods}


