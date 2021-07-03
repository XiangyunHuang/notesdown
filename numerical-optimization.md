# 数值优化 {#chap:numerical-optimization}

> 数值微分、，带约束与无约束，多元函数优化，带约束和无约束，整数优化
凸优化 [Anqi Fu](https://web.stanford.edu/~anqif/) 开发的 [CVXR](https://github.com/anqif/CVXR)
[Jelmer Ypma](https://www.ucl.ac.uk/~uctpjyy/nloptr.html) 开发的 [nloptr](https://github.com/jyypma/nloptr) 和 Berwin A. Turlach 开发的 [quadprog](https://CRAN.R-project.org/package=quadprog)

求解器介绍 <https://palomar.home.ece.ust.hk/MAFS6010R_lectures/Rsession_solvers.html>

按照 [MOSEK](https://docs.mosek.com/9.2/rmosek/optimization-tutorials.html) 的优化材料，都用 R 替换实现，一直到马科维茨组合优化。梳理一个表格，各种规划类型，各个 R 包的功能。

Matlab 优化工具箱 [Optimization Toolbox User’s Guide](https://ww2.mathworks.cn/help/releases/R2021a/pdf_doc/optim/optim.pdf)


[igraph](https://github.com/igraph/igraph/) 可以用来解决最短路径、最大网络流、最小生成树等图优化相关的问题。

[GPareto](https://github.com/mbinois/GPareto) 求解多目标优化问题，帕雷托前沿优化和估计



## 线性规划 {#sec:linear-programming}

注意以下求解器的区别，以具体的问题描述出来，体现能力的不同。

[clpAPI](https://cran.r-project.org/package=clpAPI) 线性规划求解器。

[glpk](https://www.gnu.org/software/glpk/) 的两个 R 接口 -- [glpkAPI](https://cran.r-project.org/package=glpkAPI) 和
[Rglpk](https://CRAN.R-project.org/package=Rglpk) 提供线性规划和混合整数规划的求解能力。

[ompr](https://github.com/dirkschumacher/ompr) 求解混合整数线性规划问题

[lp_solve](http://lpsolve.sourceforge.net/) 的两个 R 接口 --
[lpSolveAPI](https://cran.r-project.org/package=lpSolveAPI) 和 [lpSolve](https://github.com/gaborcsardi/lpSolve) 也提供类似的能力。

\begin{equation*}
\begin{array}{l}
  \min_x \quad -6x_1 -5x_2 \\
    s.t.\left\{ 
    \begin{array}{l}
    x_1  + 4x_2 \leq 16\\
    6x_1 + 4x_2 \leq 28\\
    2x_1 - 5x_2 \leq 6\\
    0 \leq x    \leq 10
    \end{array} \right.
\end{array}
\end{equation*}



\begin{equation*}
\begin{array}{l}
\min_x \quad
  \begin{bmatrix}
  -6  \\
  -5
  \end{bmatrix}
  ^{T} x \\
s.t.\left\{ 
 \begin{array}{l}
  \begin{bmatrix}
  1 & 4  \\
  6 & 4  \\
  2 & -5 
  \end{bmatrix}
  x \leq
  \begin{bmatrix}
   16 \\
   28 \\
   6
  \end{bmatrix}\\
  0 \leq x \leq 10
 \end{array} \right.
\end{array} 
\end{equation*}



```r
library(lpSolve)
# 目标
f.obj <- c(-6, -5)
# 约束
f.con <- matrix(c(1, 4, 6, 4, 2, -5), nrow = 3, byrow = TRUE)
# 方向
f.dir <- c("<=", "<=", "<=")
# 右手边
f.rhs <- c(16, 28, 6)
res <- lp("min", f.obj, f.con, f.dir, f.rhs)
res$objval
```

```
## [1] -31.4
```

```r
res$solution
```

```
## [1] 2.4 3.4
```

## 整数规划 {#sec:integer-programming}

### 一般整数规划 {#common-integer-programming}

\begin{equation*}
\begin{array}{l}
  \max_x \quad 0.2x_1 + 0.6x_2 \\
    s.t.\left\{ 
    \begin{array}{l}
    5x_1  + 3x_2 \leq 250\\
    -3x_1 + 2x_2 \leq 4\\
    x_1,x_2 \geq 0, \quad x_1,x_2 \in \mathbb{Z}
    \end{array} \right.
\end{array}
\end{equation*}



```r
# 目标
f.obj <- c(0.2, 0.6)
# 约束
f.con <- matrix(c(5, 3, -3, 2), nrow = 2, byrow = TRUE)
# 方向
f.dir <- c("<=", "<=")
# 右手边
f.rhs <- c(250, 4)
# 限制两个变量都是整数
res <- lp("max", f.obj, f.con, f.dir, f.rhs, int.vec=1:2)
res$objval
```

```
## [1] 29.2
```

```r
res$solution
```

```
## [1] 26 40
```

### 0-1 整数规划 {#binary-integer-programming}

\begin{equation*}
\begin{array}{l}
  \max_x \quad 0.2x_1 + 0.6x_2 \\
    s.t.\left\{ 
    \begin{array}{l}
    5x_1  + 3x_2 \leq 250\\
    -3x_1 + 2x_2 \leq 4\\
    x_1,x_2 \in \{0,1\}
    \end{array} \right.
\end{array}
\end{equation*}


```r
# 目标
f.obj <- c(0.2, 0.6)
# 约束
f.con <- matrix(c(5, 3, -3, 2), nrow = 2, byrow = TRUE)
# 方向
f.dir <- c("<=", "<=")
# 右手边
f.rhs <- c(250, 4)
# 限制两个变量都是0-1整数
res <- lp("max", f.obj, f.con, f.dir, f.rhs, int.vec=1:2, all.bin = TRUE)
res$objval
```

```
## [1] 0.8
```

```r
res$solution
```

```
## [1] 1 1
```

### 混合整数规划 {#mixed-integer-programming}

一部分变量要求是整数

\begin{equation*}
\begin{array}{l}
  \max_x \quad 3x_1 + 7x_2 - 12x_3 \\
    s.t.\left\{ 
    \begin{array}{l}
    5x_1 + 7x_2 + 2x_3 \leq 61\\
    3x_1 + 2x_2 - 9x_3 \leq 35\\
    x_1 + 3x_2 + x_3 \leq 31\\
    x_1,x_2 \geq 0, \quad x_3 \in [-10, 10]
    \end{array} \right.
\end{array}
\end{equation*}


```r
# 还必须安装 ROI.plugin.lpsolve
library(ROI)
prob <- OP(
  objective = L_objective(c(3, 7, -12)),
  # 指定变量类型：第1个变量是连续值，第2、3个变量是整数
  types = c("C", "I", "I"),
  constraints = L_constraint(
    L = rbind(
      c(5, 7, 2),
      c(3, 2, -9),
      c(1, 3, 1)
    ),
    dir = c("<=", "<=", "<="),
    rhs = c(61, 35, 31)
  ),
  # 添加约束：第3个变量的下、上界分别是 -10 和 10
  bounds = V_bound(li = 3, ui = 3, lb = -10, ub = 10, nobj = 3),
  maximum = TRUE
)
prob
```

```
## ROI Optimization Problem:
## 
## Maximize a linear objective function of length 3 with
## - 1 continuous objective variable,
## - 2 integer objective variables,
## 
## subject to
## - 3 constraints of type linear.
## - 1 lower and 1 upper non-standard variable bound.
```

```r
res <- ROI_solve(prob)
res$solution
```

```
## [1]  0.3333333  8.0000000 -2.0000000
```

```r
res$objval
```

```
## [1] 81
```

## 二次规划 {#sec:quadratic-programming}

### 凸二次规划 {#sec:strictly-convex-quadratic-program}

在 R 中使用 quadprog 包求解二次规划[^intro-quadprog]，而 ipoptr 包可用来求解一般的非线性约束的非线性规划[^intro-ipoptr]，quadprogXT 包用来求解带绝对值约束的二次规划，pracma 包提供 quadprog 函数就是对 quadprog 包的 solve.QP 进行封装，使得调用风格更像 Matlab 而已。quadprog 包实现了 Goldfarb and Idnani (1982, 1983) 提出的对偶方法，主要用来求解带线性约束的严格凸二次规划问题。

$$\min(-d^{T}b+1/2b^{T}Db), A^{T}b \geq b_{0}$$


```r
solve.QP(Dmat, dvec, Amat, bvec, meq = 0, factorized = FALSE)
```

参数 `Dmat`、`dvec`、`Amat`、`bvec` 分别对应二次规划问题中的 $D,d,A,b_{0}$ 

现在有如下二次规划问题

$$
D = 2* \begin{bmatrix}1 & -1/2\\
-1/2 & 1
\end{bmatrix},
d = (-3,2),
A = \begin{bmatrix}1 & 1\\
-1 & 1 \\
0  & -1
\end{bmatrix},
b_{0} = (2,-2,-3)
$$

上述二次规划问题的可行域如图所示


```r
plot(0, 0,
  xlim = c(-2, 5.5), ylim = c(-1, 3.5), type = "n",
  xlab = "x", ylab = "y", main = "Feasible Region"
)
polygon(c(2, 5, -1), c(0, 3, 3), border = TRUE, lwd = 2, col = "gray")
```

<div class="figure" style="text-align: center">
<img src="numerical-optimization_files/figure-html/feasible-region-1.png" alt="可行域" width="384" />
<p class="caption">(\#fig:feasible-region)可行域</p>
</div>

**quadprog** 包的 `solve.QP` 函数求解二次规划


```r
library(quadprog)
Dmat <- 2 * matrix(c(1, -1 / 2, -1 / 2, 1), nrow = 2, byrow = TRUE)
dvec <- c(-3, 2)
A <- matrix(c(1, 1, -1, 1, 0, -1), ncol = 2, byrow = TRUE)
bvec <- c(2, -2, -3)
Amat <- t(A)
sol <- solve.QP(Dmat, dvec, Amat, bvec, meq = 0)
sol
```

```
## $solution
## [1] 0.1666667 1.8333333
## 
## $value
## [1] -0.08333333
## 
## $unconstrained.solution
## [1] -1.3333333  0.3333333
## 
## $iterations
## [1] 2 0
## 
## $Lagrangian
## [1] 1.5 0.0 0.0
## 
## $iact
## [1] 1
```

在可行域上画出等高线，表示目标解的位置，图中红点表示无约束下的解，黄点表示线性约束下的解


```r
qp_sol <- sol$solution # 二次规划的解
uc_sol <- sol$unconstrained.solution # 无约束情况下的解
# 画图
library(lattice)
x <- seq(-2, 5.5, length.out = 500)
y <- seq(-1, 3.5, length.out = 500)
grid <- expand.grid(x = x, y = y)
grid$z <- with(grid, x^2 + y^2 - x * y + 3 * x - 2 * y + 4)
levelplot(z ~ x * y, grid,
  cuts = 40,
  panel = function(...) {
    panel.levelplot(...)
    panel.polygon(c(2, 5, -1), c(0, 3, 3),
      border = TRUE,
      lwd = 2, col = "transparent"
    )
    panel.points(c(uc_sol[1], qp_sol[1]),
      c(uc_sol[2], qp_sol[2]),
      lwd = 5, col = c("red", "yellow"), pch = 19
    )
  },
  colorkey = TRUE,
  col.regions = terrain.colors(40)
)
```

<div class="figure" style="text-align: center">
<img src="numerical-optimization_files/figure-html/unnamed-chunk-7-1.png" alt="无约束和有约束条件下的解" width="384" />
<p class="caption">(\#fig:unnamed-chunk-7)无约束和有约束条件下的解</p>
</div>

可行域 `polypath` 线性约束 非线性约束如何

## 非线性规划 {#sec:nonlinear-programming}

### 一元非线性优化 {#sec:one-dimensional-optimization}

复合函数求极值

$$
g(x) = \int_{0}^{x} -\sqrt{t}\exp(-t^2) dt, \\
f(y) = \int_{0}^{y} g(s) \exp(-s) ds
$$


```r
g <- function(x) {
  integrate(function(t) {
    -sqrt(t) * exp(-t^2)
  }, lower = 0, upper = x)$value
}

f <- function(y) {
  integrate(function(s) {
    Vectorize(g, "x")(s) * exp(-s)
  }, lower = 0, upper = y)$value
}

optimize(f, interval = c(10, 100), maximum = FALSE)
```

```
## $minimum
## [1] 66.84459
## 
## $objective
## [1] -0.3201572
```

计算积分的时候，输入了一系列 s 值，参数是向量，而函数 g 只支持输入参数是单个值，`g(c(1,2))` 则会报错


```r
g(1)
```

```
## [1] -0.453392
```

### 多元无约束非线性优化 {#sec:unconstrained-nonlinear-optimization}

需要使用启发式算法来求解这类规划问题，[GA](https://github.com/luca-scr/GA) 包实现了遗传算法，

### 一元非线性方程 {#sec:optimize}

[牛顿-拉弗森方法](https://blog.hamaluik.ca/posts/solving-equations-using-the-newton-raphson-method/)



## 线性最小二乘 {#sec:linear-least-squares}

## 对数似然 {#sec:log-lik}


```r
set.seed(1234)
n <- 20 # 随机数的个数
x <- rexp(n, rate = 5) # 服从指数分布的随机数
m <- 40 # 网格数
mu <- seq(mean(x) - 1.5 * sd(x) / sqrt(n),
          mean(x) + 1.5 * sd(x) / sqrt(n),
          length.out = m
)
sigma <- seq(0.8 * sd(x), 1.5 * sd(x), length.out = m)
tmp <- expand.grid(x = mu, y = sigma)
loglikelihood <- function(b) -sum(dnorm(x, b[1], b[2], log = TRUE))
pp <- apply(tmp, 1, loglikelihood)
z <- matrix(pp, m, m)
nbcol <- 100
color <- hcl.colors(nbcol)
zfacet <- z[-1, -1] + z[-1, -m] + z[-m, -1] + z[-m, -m]
facetcol <- cut(zfacet, nbcol)

par(mar = c(0.1, 2, 0.1, 0.1))
persp(mu, sigma, z,
      xlab = "\n \u03bc", ylab = "\n \u03c3",
      zlab = "\n log-likelihood",
      border = NA,
      ticktype = "simple",
      col = color[facetcol],
      theta = 50, phi = 25,
      r = 60, d = 0.1, expand = .6,
      ltheta = 90, lphi = 180,
      shade = 0.1, nticks = 5, 
      box = TRUE, axes = TRUE
)
```

<img src="numerical-optimization_files/figure-html/unnamed-chunk-10-1.png" width="672" style="display: block; margin: auto;" />

<!-- 添加极大值点，除指数分布外，还有正态、二项、泊松分布观察其似然曲面的特点，都是单峰，有唯一极值点，再考虑正态混合模型的似然曲面 -->

[^intro-quadprog]: https://rwalk.xyz/solving-quadratic-progams-with-rs-quadprog-package/
[^intro-ipoptr]: https://www.ucl.ac.uk/~uctpjyy/ipoptr.html


## 微分方程 {#sec:non-linear-tseries}

[ode45 求解偏微分方程](https://blog.hamaluik.ca/posts/solving-systems-of-partial-differential-equations/)


```r
library(nonlinearTseries)
library(plot3D)
lor <- lorenz(do.plot = F)

scatter3D(lor$x, lor$y, lor$z,
  ann = FALSE, col = terrain.colors(25),
  type = "o", cex = 0.3,
  colkey = FALSE, box = FALSE
)
```

