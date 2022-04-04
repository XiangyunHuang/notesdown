# 抽样分布 {#chap-sampling-distributions}

分布我们已经听说过很多了，可是它们都是凭空臆测的吗？肯定不是，那它们是怎么产生的呢？谁提出了正态分布，他/她是怎么提出的？一定有故事背景，一定有数据记录，即观察值，我们的样本数据

抽样分布其中抽样二字更加贴近生活，说明它源于实际生产场景，而不是光靠大脑思维理论推导出来的东西，它是最本质的

## 正态分布 {#sec-normal-distribution}

分三块介绍

- 历史背景
- 分布性质
- 应用场景

来源，为啥叫逻辑斯谛？历史故事

逻辑斯谛分布

1. 正态分布
1. t 分布
1. F 分布
1. $\chi^2$ 分布
1. 霍特林 $T^2$ 分布 Hoteling's T^2 Distribution
1. 威沙特分布 Wishart Distribution

分一元和多元情况阐述正态分布、t 分布、F 分布、卡方分布及分布[拟合](https://mirrors.tuna.tsinghua.edu.cn/CRAN/doc/contrib/Ricci-distributions-en.pdf)

常见分布之间的关系图需要用 TikZ 来绘制

完整的关系图 <http://www.math.wm.edu/~leemis/2008amstat.pdf> 参考自 <https://www.math.wustl.edu/~jmding/math494/dist.pdf>

图来自 [@Lawrence_1986_Dist]

[fitdistrplus](https://github.com/aursiber/fitdistrplus)

## 指数族 {#sec-exponential-family}

谁提出的指数族，有哪些性质，指数族 quasi-poisson 是什么含义，拟族

如何判别一个分布是否属于指数族

常见的高斯、二项、正态分布、伽马分布、泊松分布

指数族

推广到一般情况

> 三大抽样分布t分布，$\chi$ 分布和F分布，一元和多元情形，一元分布知识范围是本科，多元分布范围是研究生和博士，参考数理统计引论。一元分布多用于本科假设检验，多元分布常用于均值向量和协方差阵以及统计量的极限分布。介绍各个分布的形式、历史来源、各个特征量、密度、分布函数推导，数值计算

三大抽样的发现、历史、多元、非中心形式的推广

多元 t 分布函数 (MVT) 

$$
T(\mathbf{a},\mathbf{b},\Sigma,\nu)=\frac{2^{1-\frac{\nu}{2}}}{\Gamma(\frac{\nu}{2}) } \int_{0}^{\infty} s^{\nu-1}e^{-\frac{s^2}{2}} \Phi(\frac{s\mathbf{a}}{\sqrt{\nu}},\frac{s\mathbf{b}}{\sqrt{\nu}},\Sigma)ds
$$

多元正态分布函数 (MVN)

$$
\Phi(\mathbf{a},\mathbf{b},\Sigma)=\frac{1}{\sqrt{|\Sigma|(2\pi)^m}} \int_{a_1}^{b_1}\!\int_{a_2}^{b_2}\!\cdots\!\int_{a_m}^{b_m} e^{-\frac{1}{2}x^\top\Sigma^{-1}x}dx
$$

其中 $x = (x_1,x_2,\dots,x_m)^\top, \forall i, -\infty \le a_i \le b_i \le \infty$， $\Sigma$ 是 $m \times m$ 对称非负定的矩阵

多元 $t$ 分布分位数计算


```r
library(mvtnorm)
n <- c(26, 24, 20, 33, 32)
V <- diag(1 / n)
df <- 130
C <- matrix(c(
  1, 1, 1, 0, 0, -1, 0, 0, 1, 0,
  0, -1, 0, 0, 1, 0, 0, 0, -1, -1,
  0, 0, -1, 0, 0
), ncol = 5)
cv <- C %*% V %*% t(C) ## covariance matrix
dv <- t(1 / sqrt(diag(cv)))
cr <- cv * (t(dv) %*% dv) ## correlation matrix
delta <- rep(0, 5)
Tn <- qmvt(0.95,
  df = df, delta = delta, corr = cr,
  abseps = 0.0001, maxpts = 100000, tail = "both"
)
Tn
```

```
## $quantile
## [1] 2.560742
## 
## $f.quantile
## [1] 2.302634e-07
## 
## attr(,"message")
## [1] "Normal Completion"
```

计算多元正态分布的概率，这个例子来自 <https://stackoverflow.com/questions/36704081>


```r
# 模拟一个协方差矩阵
sigma <- as.matrix(read.csv(file = "data/sigma.csv", header = F, sep = ","))
rownames(sigma) <- colnames(sigma)
# matrixcalc::is.symmetric.matrix(sigma) # 判断 sigma 是否为对称的矩阵
# matrixcalc::is.positive.definite(sigma) # 判断 sigma 是否为正定的矩阵
# isTRUE(all.equal(sigma, t(sigma)))
m <- nrow(sigma)
Fn <- pmvnorm(
  lower = rep(-Inf, m), upper = rep(0, m),
  mean = rep(0, m), sigma = sigma
)
Fn
```

`mvrnorm()` 函数来自 **MASS** 包，模拟多元正态分布的样本


```r
library(MASS)
n <- 1000 # 样本量
X <- mvrnorm(n, mu = rep(0, 2), Sigma = matrix(c(1, 0.8, 0.8, 1), ncol = 2, byrow = TRUE))
plot(X,
  pch = 20, panel.first = grid(), cex = 1,
  col = densCols(X, colramp = terrain.colors),
  xlab = expression(X[1]), ylab = expression(X[2])
)
points(x =0, y = 0, pch = 3, cex = 2)
```

\begin{figure}

{\centering \includegraphics[width=0.75\linewidth]{sampling-distributions_files/figure-latex/bivariate-scatter-1} 

}

\caption{二维正态分布}(\#fig:bivariate-scatter)
\end{figure}



```r
f1 <- kde2d(X[, 1], X[, 2], n = 25)
filled.contour(f1, color.palette = terrain.colors)

library(shape)
persp(f1$z, 
  xlab = expression(X[1]), ylab = expression(X[2]),
  zlab = expression(Z),
  col = drapecol(f1$z, col = terrain.colors(20)),
  theta = 30, phi = 20, 
  r = 50, d = 0.1, expand = 0.5, ltheta = 90, lphi = 180,
  shade = 0.1, ticktype = "detailed", nticks = 5
)
```

\begin{figure}

{\centering \subfloat[等高线图(\#fig:bivariate-persp-1)]{\includegraphics[width=0.45\linewidth]{sampling-distributions_files/figure-latex/bivariate-persp-1} }\subfloat[透视图(\#fig:bivariate-persp-2)]{\includegraphics[width=0.45\linewidth]{sampling-distributions_files/figure-latex/bivariate-persp-2} }

}

\caption{二维正态分布}(\#fig:bivariate-persp)
\end{figure}

Wishart 分布 文献 [@Eaton_2007_MultiStat] 第八章
