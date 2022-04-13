# 数值优化 {#chap-numerical-optimization}

<!-- 
Optimization Packages for R
https://github.com/r-opt 
数值优化 经典教材 [@Nocedal2006]
https://www.csie.ntu.edu.tw/~r97002/temp/num_optimization.pdf
[gslnls](https://github.com/JorisChau/gslnls) GSL 库做非线性回归

https://www.lindo.com/downloads/LINGO-OSX-64x86-19.0.dmg
-->

R 语言提供了相当多的优化求解器，比较完整的概览见[优化视图](https://CRAN.R-project.org/view=Optimization)。 本章介绍一些常用的优化算法及其R实现，涵盖线性规划、整数规划、二次规划、非线性规划等。

商业优化求解器的能力都覆盖非线性规划（NLP），线性（LP）、二次（QP）和锥规划（SOCP），混合整数线性规划（MILP），多目标优化，最小二乘和方程求解。此外，还有很多文档介绍，
[LINGO](https://www.lindo.com/)提供[用户手册](https://www.lindo.com/downloads/PDF/LINGO.pdf)，
[Matlab 优化工具箱](https://ww2.mathworks.cn/products/optimization.html) 提供 [Optimization 工具箱使用指南](https://ww2.mathworks.cn/help/releases/R2021a/pdf_doc/optim/optim.pdf)，
[MOSEK](https://github.com/MOSEK) (<https://www.mosek.com/>) 提供 [MOSEK 建模食谱](https://docs.mosek.com/modeling-cookbook/index.html)，[LocalSolver](https://www.localsolver.com/) 提供[基本使用手册](https://www.localsolver.com/docs/last/index.html)，
[Gurobi](https://www.gurobi.com/) 提供 [Gurobi 参考手册](https://www.gurobi.com/documentation/9.1/refman/index.html)，[CPLEX Optimization Studio](https://www.ibm.com/cn-zh/products/ilog-cplex-optimization-studio)。

开源社区有不少工具，也能求解常见的优化问题，如 Julia 的 [JuMP](https://github.com/jump-dev) (<https://jump.dev/>)，Octave (<https://www.gnu.org/software/octave/>) 内置的优化函数，Python 模块 [SciPy](https://github.com/scipy/scipy) 提供 [Optimization 优化求解器](https://docs.scipy.org/doc/scipy/reference/tutorial/optimize.html)，[cvxopt](https://github.com/cvxopt/cvxopt) 凸优化求解器，主要基于内点法，提供 Julia、Python、Matlab 接口，算法介绍见
[锥优化](http://www.seas.ucla.edu/~vandenbe/publications/coneprog.pdf)
[机器学习优化](http://www.seas.ucla.edu/~vandenbe/publications/mlbook.pdf)。
课程见 [Optimization for Machine Learning](https://github.com/epfml/OptML_course)，书籍见[Convex Optimization](https://stanford.edu/~boyd/cvxbook/)，相关综述见[Convex Optimization: Algorithms and Complexity](https://arxiv.org/pdf/1405.4980.pdf)。


Berwin A. Turlach 开发的 [quadprog](https://CRAN.R-project.org/package=quadprog) 主要用于求解二次规划问题。[Anqi Fu](https://web.stanford.edu/~anqif/) 开发的 [CVXR](https://github.com/anqif/CVXR) 可解很多凸优化问题 [@CVXR2020]，详见网站 <https://cvxr.rbind.io/>，[Jelmer Ypma](https://www.ucl.ac.uk/~uctpjyy/nloptr.html) 开发的 [nloptr](https://github.com/jyypma/nloptr) 可解无约束和有约束的非线性规划问题 [@nloptr]，[GPareto](https://github.com/mbinois/GPareto) 求解多目标优化问题，帕雷托前沿优化和估计[@GPareto2019]。[igraph](https://github.com/igraph/igraph/) 可以用来解决最短路径、最大网络流、最小生成树等图优化相关的问题。 <https://palomar.home.ece.ust.hk/MAFS6010R_lectures/Rsession_solvers.html> 提供了一般的求解器介绍。ROI 包力图统一各个求解器的调用接口，打造一个优化算法的基础设施平台。@ROI2020 详细介绍了目前优化算法发展情况及 R 社区提供的优化能力。[GA](https://github.com/luca-scr/GA) 包实现了遗传算法，支持连续和离散的空间搜索，可以并行 [@GA2013;@GA2017]，是求解 TSP 问题的重要方法。NMOF 包实现了差分进化、遗传算法、粒子群算法、模拟退火算法等启发式优化算法，还提供网格搜索和贪婪搜索工具，@NMOF2019 提供了详细的介绍。@Nash2014 总结了 R 语言环境下最优化问题的最佳实践。[RcppEnsmallen](https://github.com/coatless/rcppensmallen) 数值优化
通用标准的优化方法，前沿最新的优化方法，包含小批量/全批量梯度下降技术、无梯度优化器，约束优化技术。[RcppNumerical](https://github.com/yixuan/RcppNumerical) 无约束数值优化，一维/多维数值积分。

谷歌开源的运筹优化工具 [or-tools](https://github.com/google/or-tools) 提供了约束优化、线性优化、混合整数优化、装箱和背包算法、TSP（Traveling Salesman Problem）、VRP（Vehicle Routing Problem）、图算法（最短路径、最小成本流、最大流等）等算法和求解器。「运筹OR帷幄」社区开源的 [线性规划](https://github.com/Operations-Research-Science/Ebook-Linear_Programming) 一书值得一看。


```r
# 加载 ROI 时不要自动加载插件
Sys.setenv(ROI_LOAD_PLUGINS = FALSE)
library(lpSolve)    # 线性规划求解器
library(ROI)        # 优化工具箱
library(ROI.plugin.alabama)  # 注册 alabama 求解非线性规划
library(ROI.plugin.nloptr)   # 注册 nloptr 求解非线性规划
library(ROI.plugin.lpsolve)  # 注册 lpsolve 求解线性规划
library(ROI.plugin.quadprog) # 注册 quadprog 求解二次规划
library(ROI.plugin.scs)      # 注册 scs 求解凸锥规划
library(lattice)    # 图形绘制
library(kernlab)    # 优化问题和机器学习的关系

library(rootSolve)       # 非线性方程
library(BB)              # 非线性方程组
library(deSolve)         # ODE 常微分方程
library(scatterplot3d)   # 三维曲线图

library(shape)
library(ReacTran)        # PDE 偏微分方程
library(PBSddesolve)     # DAE 延迟微分方程

library(nlme)            # 混合效应模型
library(nlmeODE)         # ODE 应用于混合效应模型

library(Sim.DiffProc)    # SDE 随机微分方程

# library(nlmixr)          # Population ODE modeling
```



表 \@ref(tab:roi-plugin-latex) 对目前的优化器按优化问题做了分类


\begin{table}

\caption{(\#tab:roi-plugin-latex)ROI 插件按优化问题分类}
\centering
\begin{tabular}[t]{>{\raggedright\arraybackslash}p{2cm}>{\raggedright\arraybackslash}p{2cm}>{\raggedright\arraybackslash}p{2cm}>{\raggedright\arraybackslash}p{2cm}>{\raggedright\arraybackslash}p{2cm}}
\toprule
  & Linear & Quadratic & Conic & Functional\\
\midrule
No &  &  &  & \\
Box &  &  &  & optimx\\
Linear & $\mathrm{clp}^\star$, $\mathrm{cbc}^{\star+}$, $\mathrm{glpk}^{\star+}$, $\mathrm{lpsolve}^{\star+}$, $\mathrm{msbinlp}^{\star+}$, $\mathrm{symphony}^{\star+}$ & ipop, $\mathrm{quadprog}^{\star}$, qpoases &  & \\
Quadratic &  & $\mathrm{cplex}^{+}$, $\mathrm{gurobi}^{\star+}$, $\mathrm{mosek}^{\star+}$, $\mathrm{neos}^{+}$ &  & \\
Conic &  &  & $\mathrm{ecos}^{\star+}$, $\mathrm{scs}^{\star}$ & \\
\addlinespace
Functional &  &  &  & alabama, deoptim, nlminb, nloptr\\
\bottomrule
\multicolumn{5}{l}{\rule{0pt}{1em}\textsuperscript{*} 求解器受限于凸优化问题}\\
\multicolumn{5}{l}{\rule{0pt}{1em}\textsuperscript{+} 求解器可以处理整型约束}\\
\end{tabular}
\end{table}


## 线性规划 {#sec-linear-programming}

[clpAPI](https://cran.r-project.org/package=clpAPI) 线性规划求解器。[glpk](https://www.gnu.org/software/glpk/) 的两个 R 接口 -- [glpkAPI](https://cran.r-project.org/package=glpkAPI) 和
[Rglpk](https://CRAN.R-project.org/package=Rglpk) 提供线性规划和混合整数规划的求解能力。[lp_solve](http://lpsolve.sourceforge.net/) 的两个 R 接口 --
[lpSolveAPI](https://cran.r-project.org/package=lpSolveAPI) 和 [lpSolve](https://github.com/gaborcsardi/lpSolve) 也提供类似的能力。[ompr](https://github.com/dirkschumacher/ompr) 求解混合整数线性规划问题。

举个例子，如下

\begin{equation*}
\begin{array}{l}
  \min_x \quad -6x_1 -5x_2 \\
    s.t.\left\{ 
    \begin{array}{l}
    x_1  + 4x_2 \leq 16\\
    6x_1 + 4x_2 \leq 28\\
    2x_1 - 5x_2 \leq 6
    \end{array} \right.
\end{array}
\end{equation*}

写成矩阵形式

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
  \end{bmatrix}
 \end{array} \right.
\end{array} 
\end{equation*}

对应成 R 代码如下


```r
# lpSolve 添加约束条件
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

## 整数规划 {#sec-integer-programming}

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

[Rsymphony](https://cran.r-project.org/package=Rsymphony) 是混合整数规划求解器 [SYMPHONY](https://github.com/coin-or/SYMPHONY) 的 R 语言接口[^symphony]。

[^symphony]: 以 MacOS 为例安装 symphony 软件

    ```bash
    brew tap coin-or-tools/coinor
    brew install symphony
    ```


```r
library(Rsymphony)
## Simple linear program.
## maximize: 2 x_1 + 4 x_2 + 3 x_3
## subject to: 3 x_1 + 4 x_2 + 2 x_3 <= 60
## 2 x_1 + x_2 + x_3 <= 40
## x_1 + 3 x_2 + 2 x_3 <= 80
## x_1, x_2, x_3 are non-negative real numbers

# 简单线性规划
obj <- c(2, 4, 3)
mat <- matrix(c(3, 2, 1, 4, 1, 3, 2, 1, 2), nrow = 3)
dir <- c("<=", "<=", "<=")
rhs <- c(60, 40, 80)
max <- TRUE
Rsymphony_solve_LP(obj, mat, dir, rhs, max = max)

# 混合整数规划
obj <- c(3, 1, 3)
mat <- matrix(c(-1, 0, 1, 2, 4, -3, 1, -3, 2), nrow = 3)
dir <- c("<=", "<=", "<=")
rhs <- c(4, 2, 3)
max <- TRUE
types <- c("I", "C", "I")
Rsymphony_solve_LP(obj, mat, dir, rhs, types = types, max = max)

# 有边界约束的混合整数规划
## Same as before but with bounds replaced by
## -Inf < x_1 <= 4
## 0 <= x_2 <= 100
## 2 <= x_3 < Inf
bounds <- list(
  lower = list(ind = c(1L, 3L), val = c(-Inf, 2)),
  upper = list(ind = c(1L, 2L), val = c(4, 100))
)
Rsymphony_solve_LP(obj, mat, dir, rhs,
  types = types, max = max,
  bounds = bounds
)
```

一部分变量要求是整数

\begin{equation*}
\begin{array}{l}
  \max_x \quad 3x_1 + 7x_2 - 12x_3 \\
    s.t.\left\{ 
    \begin{array}{l}
    5x_1 + 7x_2 + 2x_3 \leq 61\\
    3x_1 + 2x_2 - 9x_3 \leq 35\\
    x_1 + 3x_2 + x_3 \leq 31\\
    x_1,x_2 \geq 0, \quad x_2, x_3 \in \mathbb{Z}, \quad x_3 \in [-10, 10]
    \end{array} \right.
\end{array}
\end{equation*}

矩阵形式如下

\begin{equation*}
\begin{array}{l}
\min_x \quad
  \begin{bmatrix}
  3  \\
  7  \\
  -12
  \end{bmatrix}
  ^{T} x \\
s.t.\left\{ 
 \begin{array}{l}
  \begin{bmatrix}
  5 & 7 & 2 \\
  3 & 2 & -9\\
  1 & 3 & 1
  \end{bmatrix}
  x \leq
  \begin{bmatrix}
   61 \\
   35 \\
   31
  \end{bmatrix}
 \end{array} \right.
\end{array} 
\end{equation*}



```r
op <- OP(
  objective = L_objective(c(3, 7, -12)),
  # 指定变量类型：第1个变量是连续值，第2、3个变量是整数
  types = c("C", "I", "I"),
  constraints = L_constraint(
    L = matrix(c(
      5, 7, 2,
      3, 2, -9,
      1, 3, 1
    ), ncol = 3, byrow = TRUE),
    dir = c("<=", "<=", "<="),
    rhs = c(61, 35, 31)
  ),
  # 添加约束：第3个变量的下、上界分别是 -10 和 10
  bounds = V_bound(li = 3, ui = 3, lb = -10, ub = 10, nobj = 3),
  maximum = TRUE
)
op
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
res <- ROI_solve(op, solver = "lpsolve")
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

## 二次规划 {#sec-quadratic-programming}

### 凸二次规划 {#sec-strictly-convex-quadratic-program}

[^intro-quadprog]: https://rwalk.xyz/solving-quadratic-progams-with-rs-quadprog-package/

在 R 中使用 **quadprog** [@quadprog2019] 包求解二次规划[^intro-quadprog]，**quadprogXT** 包用来求解带绝对值约束的二次规划，**pracma** [@pracma2021]包提供 `quadprog()` 函数就是对 **quadprog** 包的 `solve.QP()` 进行封装，调用风格更像 Matlab。**quadprog** 包实现了 Goldfarb and Idnani (1982, 1983) 提出的对偶方法，主要用来求解带线性约束的严格凸二次规划问题。quadprog 求解的二次型的形式如下：

$$\min_b - d^{\top}b +\frac{1}{2}b^{\top}Db , \quad A^{\top}b \geq b_{0}$$


```r
solve.QP(Dmat, dvec, Amat, bvec, meq = 0, factorized = FALSE)
```

参数 `Dmat`、`dvec`、`Amat`、`bvec` 分别对应二次规划问题中的 $D,d,A,b_{0}$。下面举个二次规划的具体例子

$$
D = \begin{bmatrix}2 & -1\\
-1 & 2
\end{bmatrix}, \quad
d = (-3,2), \quad
A = \begin{bmatrix}1 & 1\\
-1 & 1 \\
0  & -1
\end{bmatrix}, \quad
b_{0} = (2,-2,-3)
$$
即目标函数 $$Q(x,y) = x^2 + y^2 -xy+3x-2y+4$$
它的可行域如图\@ref(fig:feasible-region)所示


```r
plot(0, 0,
  xlim = c(-2, 5.5), ylim = c(-1, 3.5), type = "n",
  xlab = "x", ylab = "y", main = "Feasible Region"
)
polygon(c(2, 5, -1), c(0, 3, 3), border = TRUE, lwd = 2, col = "gray")
```

\begin{figure}

{\centering \includegraphics{numerical-optimization_files/figure-latex/feasible-region-1} 

}

\caption{可行域}(\#fig:feasible-region)
\end{figure}

调用 **quadprog** 包的 `solve.QP()` 函数求解此二次规划问题


```r
library(quadprog)
Dmat <- matrix(c(2, -1, -1, 2), nrow = 2, byrow = TRUE)
dvec <- c(-3, 2)
A <- matrix(c(1, 1, -1, 1, 0, -1), ncol = 2, byrow = TRUE)
bvec <- c(2, -2, -3)
Amat <- t(A)
sol <- solve.QP(Dmat = Dmat, dvec = dvec, Amat = Amat, bvec = bvec)
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

ROI 默认的二次规划的标准形式为 $\frac{1}{2}x^{\top}Qx + a^{\top}x$，在传递参数值的时候注意和上面的区别。


```r
library(ROI)
op <- OP(
  objective = Q_objective(Q = Dmat, L = -dvec),
  constraints = L_constraint(A, rep(">=", 3), bvec),
  maximum = FALSE # 默认求最小
)
nlp <- ROI_solve(op, solver = "nloptr.slsqp", start = c(1, 2))
nlp$objval
```

```
## [1] -0.08333333
```

```r
nlp$solution
```

```
## [1] 0.1666667 1.8333333
```

对变量 $x$ 添加整型约束，原二次规划即变成混合整数二次规划 （Mixed Integer Quadratic Programming，简称 MIQP）


```r
# 目前开源的求解器都不能处理 MIQP 问题
op <- OP(
  objective = Q_objective(Q = Dmat, L = -dvec),
  constraints = L_constraint(A, rep(">=", 3), bvec),
  types = c("I", "C"),
  maximum = FALSE # 默认求最小
)
nlp <- ROI_solve(op, solver = "nloptr.slsqp", start = c(1, 2))
nlp$objval
nlp$solution
```

在可行域上画出等高线，标记目标解的位置，图中红点表示无约束下的解，黄点表示线性约束下的解


```r
qp_sol <- sol$solution # 二次规划的解
uc_sol <- sol$unconstrained.solution # 无约束情况下的解
# 画图
library(lattice)
x <- seq(-2, 5.5, length.out = 500)
y <- seq(-1, 3.5, length.out = 500)
grid <- expand.grid(x = x, y = y)
# 二次规划的目标函数
grid$z <- with(grid, x^2 + y^2 - x * y + 3 * x - 2 * y + 4)
levelplot(z ~ x * y, grid,
  cuts = 40,
  panel = function(...) {
    panel.levelplot(...)
    panel.polygon(c(2, 5, -1), c(0, 3, 3),
      border = TRUE,
      lwd = 2, col = "transparent"
    )
    panel.points(
      c(uc_sol[1], qp_sol[1]),
      c(uc_sol[2], qp_sol[2]),
      lwd = 5, col = c("red", "yellow"), pch = 19
    )
  },
  colorkey = TRUE,
  col.regions = terrain.colors(40)
)
```

\begin{figure}

{\centering \includegraphics{numerical-optimization_files/figure-latex/quadprog-1} 

}

\caption{无约束和有约束条件下的解}(\#fig:quadprog)
\end{figure}


### 半正定二次优化 {#subsec-semidefinite-optimization}

kernlab 提供基于核的机器学习方法，可用于分类、回归、聚类、异常检测、分位回归、降维等场景，包含支撑向量机、谱聚类、核PCA、高斯过程和二次规划求解器，将优化方法用于机器学习，展示二者的关系。

R 包 kernlab 的函数 `ipop()` 实现内点法可以求解半正定的二次规划问题，对应到上面的例子，就是要求 $A \geq 0$，而 R 包 quadprog 只能求解正定的二次规划问题，即要求 $A > 0$。

以二分类问题为例，采用 SMO (Sequential Minimization Optimization) 求解器，将 SVM 的二次优化问题分解。


```r
library(kernlab)
set.seed(123)
x <- rbind(matrix(rnorm(120), 60, 2), matrix(rnorm(120, mean = 3), 60, 2))
y <- matrix(c(rep(1, 60), rep(-1, 60)))
svp <- ksvm(x, y, type = "C-svc")
plot(svp, data = x)
```

\begin{figure}

{\centering \includegraphics{numerical-optimization_files/figure-latex/toy-binary-1} 

}

\caption{二分类问题}(\#fig:toy-binary)
\end{figure}

## 非线性规划 {#sec-nonlinear-programming}

开源的非线性优化求解器，推荐使用 nloptr，它支持全局优化，同时推荐 ROI，它有统一的接口函数。

### 一元非线性优化 {#sec-one-dimensional-optimization}

下面考虑一个稍微复杂的一元函数优化问题，求复合函数的极值

$$
g(x) = \int_{0}^{x} -\sqrt{t}\exp(-t^2) \mathrm{dt}, \quad f(y) = \int_{0}^{y} g(s) \exp(-s) \mathrm{ds}
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

::: {.rmdtip data-latex="{提示}"}
计算积分的时候，输入了一系列 s 值，参数是向量，而函数 g 只支持输入参数是单个值，`g(c(1,2))` 会报错，因此上面对函数 `g()` 用了向量化函数 `Vectorize()` 操作。


```r
g(1)
```

```
## [1] -0.453392
```

类似地，同时计算多个目标函数 `f(y)` 的值，也需要`Vectorize()` 实现向量化操作。


```r
Vectorize(f, "y")(c(1, 2))
```

```
## [1] -0.1103310 -0.2373865
```
:::

### 多元非线性无约束优化 {#sec-nonlinear-unconstrained-optimization}

<!-- ?nlm -->



下面这些用来测试优化算法的函数来自[维基百科](https://en.wikipedia.org/wiki/Test_functions_for_optimization)



#### Himmelblau 函数 {#himmelblau}

Himmelblau 函数是一个多摸函数，常用于比较优化算法的优劣。

$$f(x_1,x_2) = (x_1^2 + x_2 -11)^2 + (x_1 + x_2^2 -7)^2$$
它在四个位置取得一样的极小值，分别是 $f(-3.7793, -3.2832) = 0$，$f(-2.8051, 3.1313) = 0$，$f(3, 2) = 0$，$f(3.5844, -1.8481) = 0$。函数图像见图 \@ref(fig:himmelblau)。


```r
# 目标函数
fn <- function(x) {
   (x[1]^2 + x[2] - 11)^2 + (x[1] + x[2]^2 - 7)^2
}

df <- expand.grid(
  x = seq(-5, 5, length = 101),
  y = seq(-5, 5, length = 101)
)

df$fnxy = apply(df, 1, fn)

library(lattice)
# 减少三维图形的边空
lattice.options(
  layout.widths = list(
    left.padding = list(x = -.6, units = "inches"),
    right.padding = list(x = -1.0, units = "inches")
  ),
  layout.heights = list(
    bottom.padding = list(x = -.8, units = "inches"),
    top.padding = list(x = -1.0, units = "inches")
  )
)

wireframe(
  data = df, fnxy ~ x * y,
  shade = TRUE, drape = FALSE,
  xlab = expression(x[1]), 
  ylab = expression(x[2]), 
  zlab = list(expression(italic(f) ~ group("(", list(x[1], x[2]), ")")), rot = 90),
  scales = list(arrows = FALSE, col = "black"),
  par.settings = list(axis.line = list(col = "transparent")),
  screen = list(z = -240, x = -70, y = 0)
)
```

\begin{figure}

{\centering \includegraphics{numerical-optimization_files/figure-latex/himmelblau-1} 

}

\caption{Himmelblau 函数图像}(\#fig:himmelblau)
\end{figure}


```r
# 梯度函数
gr <- function(x) {
  numDeriv::grad(fn, c(x[1], x[2])) 
}
optim(par = c(-1.2, 1), fn = fn, gr = gr, method = "BFGS")
```

```
## $par
## [1] -2.805118  3.131313
## 
## $value
## [1] 2.069971e-27
## 
## $counts
## function gradient 
##       42       15 
## 
## $convergence
## [1] 0
## 
## $message
## NULL
```


#### Peaks 函数 {#peaks}

测试函数

$$
f(x,y) = 3*(1-x)*\mathrm{e}^{-x^2 - (y+1)^2} - 10*(\frac{x}{5} - x^3 - y^5)*\mathrm{e}^{-x^2-y^2} - \frac{1}{3}*\mathrm{e}^{-(x+1)^2-y^2}
$$


```r
peaks <- expression(3*(1-x)*exp^(-x^2 - (y+1)^2) - 10*(x/5 - x^3 - y^5)*exp^(-x^2-y^2) -1/3*exp^(-(x+1)^2-y^2))
```


```r
D(peaks, "x")
```

```
## -(3 * (1 - x) * (exp^(-x^2 - (y + 1)^2) * (log(exp) * (2 * x))) + 
##     3 * exp^(-x^2 - (y + 1)^2) + (10 * (1/5 - 3 * x^2) * exp^(-x^2 - 
##     y^2) - 10 * (x/5 - x^3 - y^5) * (exp^(-x^2 - y^2) * (log(exp) * 
##     (2 * x)))) - 1/3 * (exp^(-(x + 1)^2 - y^2) * (log(exp) * 
##     (2 * (x + 1)))))
```

```r
D(peaks, "y")
```

```
## -(3 * (1 - x) * (exp^(-x^2 - (y + 1)^2) * (log(exp) * (2 * (y + 
##     1)))) - (10 * (x/5 - x^3 - y^5) * (exp^(-x^2 - y^2) * (log(exp) * 
##     (2 * y))) + 10 * (5 * y^4) * exp^(-x^2 - y^2)) - 1/3 * (exp^(-(x + 
##     1)^2 - y^2) * (log(exp) * (2 * y))))
```

```r
library(Deriv)
Simplify(D(peaks, "x"))
```

```
## -(10 * ((0.2 - 3 * x^2)/exp^(x^2 + y^2)) + 3/exp^((1 + y)^2 + 
##     x^2) + log(exp) * (x * (6 * ((1 - x)/exp^((1 + y)^2 + x^2)) - 
##     20 * ((x * (0.2 - x^2) - y^5)/exp^(x^2 + y^2))) - 0.666666666666667 * 
##     ((1 + x)/exp^((1 + x)^2 + y^2))))
```

```r
Simplify(D(peaks, "y"))
```

```
## -((6 * ((1 - x) * (1 + y)/exp^((1 + y)^2 + x^2)) - 0.666666666666667 * 
##     (y/exp^((1 + x)^2 + y^2))) * log(exp) - y * (20 * (log(exp) * 
##     (x * (0.2 - x^2) - y^5)/exp^(x^2 + y^2)) + 50 * (y^3/exp^(x^2 + 
##     y^2))))
```


```r
fn <- function(x) {
  3 * (1 - x[1])^2 * exp(-x[1]^2 - (x[2] + 1)^2) -
    10 * (x[1] / 5 - x[1]^3 - x[2]^5) * exp(-x[1]^2 - x[2]^2) -
    1 / 3 * exp(-(x[1] + 1)^2 - x[2]^2)
}
# 梯度函数
gr <- function(x) {
  numDeriv::grad(fn, c(x[1], x[2]))
}

optim(par = c(-1.2, 1), fn = fn, gr = gr, method = "BFGS")
```

```
## $par
## [1] -1.3473958  0.2045192
## 
## $value
## [1] -3.049849
## 
## $counts
## function gradient 
##       28       10 
## 
## $convergence
## [1] 0
## 
## $message
## NULL
```

在 $(-1.3473958,  0.2045192)$ 处取得极小值


```r
df <- expand.grid(
  x = seq(-3, 3, length = 101),
  y = seq(-3, 3, length = 101)
)

df$fnxy = apply(df, 1, fn)

library(lattice)
wireframe(
  data = df, fnxy ~ x * y,
  shade = TRUE, drape = FALSE,
  xlab = expression(x[1]),
  ylab = expression(x[2]),
  zlab = list(expression(italic(f) ~ group("(", list(x[1], x[2]), ")")), rot = 90),
  scales = list(arrows = FALSE, col = "black"),
  par.settings = list(axis.line = list(col = "transparent")),
  screen = list(z = -240, x = -70, y = 0)
)
```

\begin{figure}

{\centering \includegraphics{numerical-optimization_files/figure-latex/peaks-1} 

}

\caption{Peaks 多峰图像}(\#fig:peaks)
\end{figure}


函数来自 Octave 内置的 `peaks()` 函数，它有很多的局部极大值和极小值，可在 [Octave Online](https://octave-online.net/) 上输入命令 `help peaks` 查看其帮助文档。



#### Rosenbrock 函数 {#rosenbrock}

[香蕉函数](https://en.wikipedia.org/wiki/Rosenbrock_function) 定义如下：

$$f(x_1,x_2) = 100 (x_2 -x_1^2)^2 + (1 - x_1)^2$$


```r
fn <- function(x) {
  (100 * (x[2] - x[1]^2)^2 + (1 - x[1])^2)
}

df <- expand.grid(
  x = seq(-2.5, 2.5, length = 101),
  y = seq(-2.5, 2.5, length = 101)
)
df$fnxy = apply(df, 1, fn)

wireframe(
  data = df, fnxy ~ x * y,
  shade = TRUE, drape = FALSE,
  xlab = expression(x[1]), 
  ylab = expression(x[2]), 
  zlab = list(expression(italic(f) ~ group("(", list(x[1], x[2]), ")")), rot = 90),
  scales = list(arrows = FALSE, col = "black"),
  par.settings = list(axis.line = list(col = "transparent")),
  screen = list(z = 120, x = -70, y = 0)
)
```

\begin{figure}

{\centering \includegraphics{numerical-optimization_files/figure-latex/rosenbrock-1} 

}

\caption{香蕉函数图像}(\#fig:rosenbrock)
\end{figure}



```r
r <- raster::rasterFromXYZ(df, crs = CRS("+proj=longlat +datum=WGS84"))
rasterVis::vectorplot(r, par.settings = RdBuTheme())
```



```r
# 梯度函数
gr <- function(x) {
  numDeriv::grad(fn, c(x[1], x[2])) 
}
optim(par = c(-1.2, 1), fn = fn, gr = gr, method = "BFGS")
```

```
## $par
## [1] 1 1
## 
## $value
## [1] 9.595012e-18
## 
## $counts
## function gradient 
##      110       43 
## 
## $convergence
## [1] 0
## 
## $message
## NULL
```


```r
op <- OP(
  objective = F_objective(fn, n = 2L, G = gr),
  bounds = V_bound(ld = -3, ud = 3, nobj = 2L)
)
nlp <- ROI_solve(op, solver = "nloptr.lbfgs", start = c(-1.2, 1))
nlp$objval
```

```
## [1] 1.364878e-17
```

```r
nlp$solution
```

```
## [1] 1 1
```

#### Ackley 函数 {#ackley}


Ackley 函数是一个非凸函数，有大量局部极小值点，获取全局极小值点是一个比较有挑战的事。它的 $n$ 维形式如下：
$$f(\mathbf{x}) = - a \mathrm{e}^{-b\sqrt{\frac{1}{n}\sum_{i=1}^{n}x_{i}^{2}}} - \mathrm{e}^{\frac{1}{n}\sum_{i=1}^{n}\cos(cx_i)} + a + \mathrm{e}$$
其中，$a = 20, b = 0.2, c = 2\pi$，对 $\forall i = 1,2,\cdots, n$，$x_i \in [-10, 10]$，$f(\mathbf{x})$ 在 $\mathbf{x}^{\star} = (0,0,\cdot,0)$ 取得全局最小值 $f(\mathbf{x}^{\star}) = 0$，二维图像如图 \@ref(fig:ackley)。


```r
fn <- function(x, a = 20, b = 0.2, c = 2 * pi) {
  mean1 <- mean(x^2)
  mean2 <- mean(cos(c * x))
  -a * exp(-b * sqrt(mean1)) - exp(mean2) + a + exp(1)
}

df <- expand.grid(
  x = seq(-10, 10, length.out = 201),
  y = seq(-10, 10, length.out = 201)
)

df$fnxy = apply(df, 1, fn)

wireframe(
  data = df, fnxy ~ x * y,
  shade = TRUE, drape = FALSE,
  xlab = expression(x[1]), 
  ylab = expression(x[2]), 
  zlab = list(expression(italic(f) ~ group("(", list(x[1], x[2]), ")")), rot = 90),
  scales = list(arrows = FALSE, col = "black"),
  par.settings = list(axis.line = list(col = "transparent")),
  screen = list(z = 120, x = -70, y = 0)
)
```

\begin{figure}

{\centering \includegraphics{numerical-optimization_files/figure-latex/ackley-1} 

}

\caption{二维 Ackley 函数图像}(\#fig:ackley)
\end{figure}


<!-- 
rgl 包、TikZ 的 pgfplots 也可以绘制类似的三维图形，加上自带的 persp 共计4-5种三维图形的绘制方法
-->

以 10 维的 Ackley 函数为例，先试一下普通的局部优化算法 --- Nelder–Mead 算法，选择初值 $(2,2,\cdots,2)$ ，看下效果，再与全局优化算法比较。


```r
op <- OP(
  objective = F_objective(fn, n = 10L),
  bounds = V_bound(ld = -10, ud = 10, nobj = 10L)
)

nlp <- ROI_solve(op, solver = "nloptr.neldermead", start = rep(2, 10))
nlp$solution
```

```
##  [1] 2 2 2 2 2 2 2 2 2 2
```

```r
nlp$objval
```

```
## [1] 6.593599
```

可以说完全没有优化效果，已经陷入局部极小值。根据[nloptr 全局优化算法](https://nlopt.readthedocs.io/en/latest/NLopt_Algorithms/#global-optimization)的介绍，这里采用 directL 算法，因为是全局优化，不用选择初值。


```r
# 调全局优化器
nlp <- ROI_solve(op, solver = "nloptr.directL")
nlp$solution
```

```
##  [1] 0 0 0 0 0 0 0 0 0 0
```

```r
nlp$objval
```

```
## [1] 4.440892e-16
```

```r
fn(x = c(2, 2))
```

```
## [1] 6.593599
```

```r
fn(x = rep(2, 10))
```

```
## [1] 6.593599
```

#### Radistrigin 函数 {#radistrigin}

这里，还有另外一个例子，Radistrigin 函数也是多摸函数

$$f(\mathbf{x})= \sum_{i=1}^{n}\big(x_i^2 - 10 \cos(2\pi x_i) + 10\big)$$


```r
fn <- function(x) {
  sum(x^2 - 10 * cos(2 * pi * x) + 10)
}

df <- expand.grid(
  x = seq(-4, 4, length.out = 201),
  y = seq(-4, 4, length.out = 201)
)

df$fnxy = apply(df, 1, fn)

wireframe(
  data = df, fnxy ~ x * y,
  shade = TRUE, drape = FALSE,
  xlab = expression(x[1]), 
  ylab = expression(x[2]), 
  zlab = list(expression(italic(f) ~ group("(", list(x[1], x[2]), ")")), rot = 90),
  scales = list(arrows = FALSE, col = "black"),
  par.settings = list(axis.line = list(col = "transparent")),
  screen = list(z = 120, x = -65, y = 0)
)
```

\begin{figure}

{\centering \includegraphics{numerical-optimization_files/figure-latex/radistrigin-1} 

}

\caption{Radistrigin 函数}(\#fig:radistrigin)
\end{figure}

设置 10 维 的优化


```r
op <- OP(
  objective = F_objective(fn, n = 10L),
  bounds = V_bound(ld = -50, ud = 50, nobj = 10L)
)
```

调全局优化器求解非凸优化问题


```r
nlp <- ROI_solve(op, solver = "nloptr.directL")
nlp$solution
```

```
##  [1] 0 0 0 0 0 0 0 0 0 0
```

```r
nlp$objval
```

```
## [1] 0
```

#### Schaffer 函数 {#schaffer}

$$
f(x_1,x_2) = 0.5 + \frac{\sin^2(x_1^2 - x_2^2) - 0.5}{ [1 + 0.001(x_1^2 + x_2^2)]^2}
$$
在 $\mathbf{x}^\star = (0,0)$ 处取得全局最小值 $f(\mathbf{x}^\star) = 0$


```r
fn <- function(x) {
  0.5 + ((sin(x[1]^2 - x[2]^2))^2 - 0.5) / (1 + 0.001*(x[1]^2 + x[2]^2))^2
}

df <- expand.grid(
  x = seq(-50, 50, length = 201),
  y = seq(-50, 50, length = 201)
)
df$fnxy = apply(df, 1, fn)

wireframe(
  data = df, fnxy ~ x * y,
  shade = TRUE, drape = FALSE,
  xlab = expression(x[1]), 
  ylab = expression(x[2]), 
  zlab = list(expression(italic(f) ~ group("(", list(x[1], x[2]), ")")), rot = 90),
  scales = list(arrows = FALSE, col = "black"),
  par.settings = list(axis.line = list(col = "transparent")),
  screen = list(z = 120, x = -70, y = 0)
)
```

\begin{figure}

{\centering \includegraphics{numerical-optimization_files/figure-latex/schaffer-01-1} 

}

\caption{Schaffer 函数}(\#fig:schaffer-01)
\end{figure}



```r
df <- expand.grid(
  x = seq(-2, 2, length = 101),
  y = seq(-2, 2, length = 101)
)
df$fnxy = apply(df, 1, fn)

wireframe(
  data = df, fnxy ~ x * y,
  shade = TRUE, drape = FALSE,
  xlab = expression(x[1]), 
  ylab = expression(x[2]), 
  zlab = list(expression(italic(f) ~ group("(", list(x[1], x[2]), ")")), rot = 90),
  scales = list(arrows = FALSE, col = "black"),
  par.settings = list(axis.line = list(col = "transparent")),
  screen = list(z = 120, x = -70, y = 0)
)
```

\begin{figure}

{\centering \includegraphics{numerical-optimization_files/figure-latex/schaffer-02-1} 

}

\caption{Schaffer 函数}(\#fig:schaffer-02)
\end{figure}

#### Hölder 函数 {#holder}

Hölder 桌面函数

$$
f(x_1,x_2) = - | \sin(x_1)\cos(x_2)\exp\big(| 1 - \frac{\sqrt{x_1^2 + x_2^2}}{\pi}|\big) |
$$

在 $(8.05502, 9.66459)$、$(-8.05502, 9.66459)$、$(8.05502, -9.66459)$、$(-8.05502, -9.66459)$ 同时取得最小值 $-19.2085$。

(ref:holder) Hölder 函数


```r
fn <- function(x) {
  -abs(sin(x[1]) * cos(x[2])) * exp(abs(1 - sqrt(x[1]^2 + x[2]^2) / pi))
}

df <- expand.grid(
  x = seq(-10, 10, length = 101),
  y = seq(-10, 10, length = 101)
)
df$fnxy = apply(df, 1, fn)

wireframe(
  data = df, fnxy ~ x * y,
  shade = TRUE, drape = FALSE,
  xlab = expression(x[1]), 
  ylab = expression(x[2]), 
  zlab = list(expression(italic(f) ~ group("(", list(x[1], x[2]), ")")), rot = 90),
  scales = list(arrows = FALSE, col = "black"),
  par.settings = list(axis.line = list(col = "transparent")),
  screen = list(z = 120, x = -60, y = 0)
)
```

\begin{figure}

{\centering \includegraphics{numerical-optimization_files/figure-latex/holder-1} 

}

\caption{(ref:holder)}(\#fig:holder)
\end{figure}




#### Trid 函数 {#trid}

<!-- 碗状函数 -->

$n \geq 2$ 维 Trid 函数

$$
f(x) = \sum_{i=1}^{n}(x_i - 1)^2 - \sum_{i=2}^{n}x_i x_{i-1}
$$
$\forall i = 1,2,\cdots, n$，$f(x)$ 在 $x_i = i(n+1-i)$ 处取得全局极小值 $f(\mathbf{x}^\star)=-n(n+4)(n-1)/6$，取值区间 $x \in [-n^2, n^2], \forall i = 1,2,\cdots,n$


```r
fn <- function(x) {
  n <- length(x)
  sum((x - 1)^2) - sum(x[-1] * x[-n])
}

df <- expand.grid(
  x = seq(-4, 4, length = 101),
  y = seq(-4, 4, length = 101)
)
df$fnxy = apply(df, 1, fn)

wireframe(
  data = df, fnxy ~ x * y,
  shade = TRUE, drape = FALSE,
  xlab = expression(x[1]), 
  ylab = expression(x[2]), 
  zlab = list(expression(italic(f) ~ group("(", list(x[1], x[2]), ")")), rot = 90),
  scales = list(arrows = FALSE, col = "black"),
  par.settings = list(axis.line = list(col = "transparent")),
  screen = list(z = -60, x = -70, y = 0)
)
```

\begin{figure}

{\centering \includegraphics{numerical-optimization_files/figure-latex/trid-1} 

}

\caption{Trid 函数}(\#fig:trid)
\end{figure}


#### 超级复杂函数 {#super-complex-function}

有如下复杂的目标函数

\begin{equation*}
\begin{array}{l}
  \min_x \quad \cos(x_1)\cos(x_2) - \sum_{i=1}^{5}\Big( (-1)^i \cdot i \cdot 2 \cdot \exp\big(-500 \cdot ( (x_1 - i \cdot 2)^2 + (x_2 - i\cdot 2)^2 ) \big) \Big) \\
    s.t. \quad -50 \leq x_1, x_2 \leq 50
\end{array}
\end{equation*}



```r
subfun <- function(i, m) {
  (-1)^i * i * 2 * exp(-500 * ((m[1] - i * 2)^2 + (m[2] - i * 2)^2))
}

fn <- function(x) {
  cos(x[1]) * cos(x[2]) -
    sum(mapply(FUN = subfun, i = 1:5, MoreArgs = list(m = x)))
}
```

目标函数的图像见图 \@ref(fig:super-function)，搜索区域 $[-50, 50] \times [-50, 50]$ 内几乎没有变化的梯度，给寻优过程带来很大困难。


```r
df <- expand.grid(
  x = seq(-50, 50, length.out = 101),
  y = seq(-50, 50, length.out = 101)
)

df$fnxy = apply(df, 1, fn)

wireframe(
  data = df, fnxy ~ x * y,
  shade = TRUE, drape = FALSE,
  xlab = expression(x[1]), 
  ylab = expression(x[2]), 
  zlab = list(expression(italic(f) ~ group("(", list(x[1], x[2]), ")")), rot = 90),
  scales = list(arrows = FALSE, col = "black"),
  par.settings = list(axis.line = list(col = "transparent")),
  screen = list(z = 120, x = -65, y = 0)
)
```

\begin{figure}

{\centering \includegraphics{numerical-optimization_files/figure-latex/super-function-1} 

}

\caption{函数图像}(\#fig:super-function)
\end{figure}

将区域 $[0, 12] \times [0, 12]$ 的图像绘制出来，不难发现，有不少局部陷阱。


```r
df <- expand.grid(
  x = seq(0, 12, length.out = 201),
  y = seq(0, 12, length.out = 201)
)

df$fnxy = apply(df, 1, fn)

wireframe(
  data = df, fnxy ~ x * y,
  shade = TRUE, drape = FALSE,
  xlab = expression(x[1]), 
  ylab = expression(x[2]), 
  zlab = list(expression(italic(f) ~ group("(", list(x[1], x[2]), ")")), rot = 90),
  scales = list(arrows = FALSE, col = "black"),
  par.settings = list(axis.line = list(col = "transparent")),
  screen = list(z = 120, x = -65, y = 0)
)
```

\begin{figure}

{\centering \includegraphics{numerical-optimization_files/figure-latex/zoom-super-function-1} 

}

\caption{局部放大函数图像}(\#fig:zoom-super-function)
\end{figure}

最优解在 $(7.999982, 7.999982)$ 取得，目标函数值为 -7.978832。


```r
fn(x = c(7.999982, 7.999982))
```

```
## [1] -7.978832
```

面对如此复杂的函数，调用全局优化器


```r
op <- OP(
  objective = F_objective(fn, n = 2L),
  bounds = V_bound(ld = -50, ud = 50, nobj = 2L)
)
nlp <- ROI_solve(op, solver = "nloptr.directL")
nlp$solution
```

```
## [1] 22.22222  0.00000
```

```r
nlp$objval
```

```
## [1] -0.9734211
```

实际上，还是陷入局部最优解。

```
SETS:
P/1..5/;
Endsets
Min=@cos(x1) * @cos(x2) - @Sum(P(j): (-1)^j * j * 2 * @exp(-500 * ((x1 - j * 2)^2 + (x2 - j * 2)^2)));
@Bnd(-50, x1, 50);
@Bnd(-50, x2, 50);
```

Lingo 18.0 启用全局优化求解器后，在 $(x_1 = 7.999982, x_2 = 7.999982)$ 取得最小值 -7.978832。而默认未启用全局优化求解器的情况下，在 $(x_1 = 18.84956, x_2 = -40.84070)$ 取得局部极小值 -1.000000。


### 多元非线性约束优化 {#sec-nonlinear-constrained-optimization}

R 自带的函数 `nlminb()` 可求解无约束、箱式约束优化问题，`constrOptim()` 还可求解线性不等式约束优化，其中包括带线性约束的二次规划。`optim()` 提供一大类优化算法，且包含随机优化算法---模拟退火算法，可求解无约束、箱式约束优化问题。

#### 普通箱式约束 {#box-constrained-optimization}

有如下箱式约束优化问题，目标函数和[香蕉函数](https://en.wikipedia.org/wiki/Rosenbrock_function)有些相似。

\begin{equation*}
\begin{array}{l}
  \min_x \quad (x_1 - 1)^2 + 4\sum_{i =1}^{n -1}(x_{i+1} -x_i^2)^2  \\
    s.t. \quad 2 \leq x_1,x_2,\cdots,x_n \leq 4
\end{array}
\end{equation*}



```r
fn <- function(x) {
  n <- length(x)
  sum(c(1, rep(4, n - 1)) * (x - c(1, x[-n])^2)^2)
}
```

$n$ 维目标函数是非线性的，给定初值 $(3, 3, \cdots, 3)$，下面求解 25 维的箱式约束，


```r
nlminb(start = rep(3, 25), objective = fn, lower = rep(2, 25), upper = rep(4, 25))
```

```
## $par
##  [1] 2.000000 2.000000 2.000000 2.000000 2.000000 2.000000 2.000000 2.000000
##  [9] 2.000000 2.000000 2.000000 2.000000 2.000000 2.000000 2.000000 2.000000
## [17] 2.000000 2.000000 2.000000 2.000000 2.000000 2.000000 2.000000 2.109093
## [25] 4.000000
## 
## $objective
## [1] 368.1059
## 
## $convergence
## [1] 0
## 
## $iterations
## [1] 6
## 
## $evaluations
## function gradient 
##       10      177 
## 
## $message
## [1] "relative convergence (4)"
```

`nlminb()` 出于历史兼容性的原因尚且存在，最优解的第24个分量没有在可行域的边界上。使用 `constrOptim()` 函数求解，默认求极小，需将箱式或线性不等式约束写成矩阵形式，即 $Ax \geq b$ 的形式，参数 ui 是 $k \times n$ 的约束矩阵 $A$，ci 是右侧 $k$ 维约束向量 $b$。以上面的优化问题为例，将箱式约束 $2 \leq x_1,x_2 \leq 4$ 转化为矩阵形式，约束矩阵和向量分别为：

$$
A = \begin{bmatrix}
1  & 0  \\
0  & 1 \\
-1 & 0 \\
0  & -1
\end{bmatrix}, \quad
b = (2, 2, -4, -4)
$$


```r
constrOptim(
  theta = rep(3, 25), # 初始值
  f = fn, # 目标函数
  method = "Nelder-Mead", # 没有提供梯度，则必须用 Nelder-Mead 方法
  ui = rbind(diag(rep(1, 25)), diag(rep(-1, 25))),
  ci = c(rep(2, 25), rep(-4, 25))
)
```

```
## $par
##  [1] 2.006142 2.002260 2.003971 2.003967 2.004143 2.004255 2.001178 2.002990
##  [9] 2.003883 2.006029 2.017345 2.009236 2.000949 2.007793 2.025831 2.007896
## [17] 2.004514 2.004381 2.008771 2.015695 2.005803 2.009127 2.017988 2.257782
## [25] 3.999846
## 
## $value
## [1] 378.4208
## 
## $counts
## function gradient 
##    12048       NA 
## 
## $convergence
## [1] 1
## 
## $message
## NULL
## 
## $outer.iterations
## [1] 25
## 
## $barrier.value
## [1] -0.003278963
```

从求解的结果来看，convergence = 1 意味着迭代次数到达默认的极限 maxit = 500，结合 `nlminb()` 函数的求解结果来看，实际上还没有收敛。如果没有提供梯度，则必须用 Nelder-Mead 方法，下面增加迭代次数到 1000。


```r
constrOptim(
  theta = rep(3, 25), # 初始值
  f = fn, # 目标函数
  method = "Nelder-Mead", 
  control = list(maxit = 1000),
  ui = rbind(diag(rep(1, 25)), diag(rep(-1, 25))),
  ci = c(rep(2, 25), rep(-4, 25))
)
```

```
## $par
##  [1] 2.000081 2.000142 2.001919 2.000584 2.000007 2.000003 2.001097 2.001600
##  [9] 2.000207 2.000042 2.000250 2.000295 2.000580 2.002165 2.000453 2.000932
## [17] 2.000456 2.000363 2.000418 2.000474 2.009483 2.001156 2.003173 2.241046
## [25] 3.990754
## 
## $value
## [1] 370.8601
## 
## $counts
## function gradient 
##    18036       NA 
## 
## $convergence
## [1] 1
## 
## $message
## NULL
## 
## $outer.iterations
## [1] 19
## 
## $barrier.value
## [1] -0.003366467
```

还是没有收敛，可见 Nelder-Mead 方法在这个优化问题上收敛速度比较慢。下面考虑调用基于梯度的优化算法 --- BFGS 方法。


```r
# 输入 n 维向量，输出 n 维向量
gr <- function(x) {
  n <- length(x)
  c(2 * (x[1] - 2), rep(0, n - 1))
  +8 * c(0, x[-1] - x[-n]^2)
  -16 * c(x[-n], 0) * c(x[-1] - x[-n]^2, 0)
}

constrOptim(
  theta = rep(3, 25), # 初始值
  f = fn, # 目标函数
  grad = gr,
  method = "BFGS", 
  control = list(maxit = 1000),
  ui = rbind(diag(rep(1, 25)), diag(rep(-1, 25))),
  ci = c(rep(2, 25), rep(-4, 25))
)
```

```
## $par
##  [1] 2.000000 2.000000 2.000000 2.000000 2.000000 2.000000 2.000000 2.000000
##  [9] 2.000000 2.000000 2.000000 2.000000 2.000000 2.000000 2.000000 2.000000
## [17] 2.000000 2.000000 2.000000 2.000000 2.000000 2.000000 2.000000 2.000001
## [25] 3.000000
## 
## $value
## [1] 373
## 
## $counts
## function gradient 
##     3721      464 
## 
## $convergence
## [1] 0
## 
## $message
## NULL
## 
## $outer.iterations
## [1] 3
## 
## $barrier.value
## [1] -0.003327104
```

相比于 Nelder-Mead 方法，目标值 373 更大，可见已陷入局部最优解，下面通过 ROI 包，分别调用求解器 L-BFGS 和 directL，发现前者同样陷入局部最优解，而后者可以获得与 `nlminb()` 函数一致的结果。


```r
# 调用改进的 BFGS 算法
op <- OP(
  objective = F_objective(fn, n = 25L, G = gr),
  bounds = V_bound(ld = 2, ud = 4, nobj = 25L)
)
nlp <- ROI_solve(op, solver = "nloptr.lbfgs", start = rep(3, 25))
nlp$objval
```

```
## [1] 373
```

```r
nlp$solution
```

```
##  [1] 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 3
```

```r
# 调全局优化算法
nlp <- ROI_solve(op, solver = "nloptr.directL")
nlp$objval
```

```
## [1] 368.1061
```

```r
nlp$solution
```

```
##  [1] 2.000000 2.000000 2.000000 2.000000 2.000000 2.000000 2.000000 2.000000
##  [9] 2.000000 2.000000 2.000000 2.000000 2.000000 2.000000 2.000000 2.000000
## [17] 2.000000 2.000000 2.000000 2.000000 2.000000 2.000000 2.000000 2.109093
## [25] 4.000000
```

下面再与函数 `optim()` 提供的 L-BFGS-B 算法比较


```r
optim(
  par = rep(3, 25), fn = fn, gr = NULL, method = "L-BFGS-B",
  lower = rep(2, 25), upper = rep(4, 25)
)
```

```
## $par
##  [1] 2.000000 2.000000 2.000000 2.000000 2.000000 2.000000 2.000000 2.000000
##  [9] 2.000000 2.000000 2.000000 2.000000 2.000000 2.000000 2.000000 2.000000
## [17] 2.000000 2.000000 2.000000 2.000000 2.000000 2.000000 2.000000 2.109093
## [25] 4.000000
## 
## $value
## [1] 368.1059
## 
## $counts
## function gradient 
##        6        6 
## 
## $convergence
## [1] 0
## 
## $message
## [1] "CONVERGENCE: REL_REDUCTION_OF_F <= FACTR*EPSMCH"
```

值得注意的是，当提供梯度信息的时候，虽然求解速度提升了，但是最优解变差了。


```r
optim(
  par = rep(3, 25), fn = fn, gr = gr, method = "L-BFGS-B",
  lower = rep(2, 25), upper = rep(4, 25)
)
```

```
## $par
##  [1] 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 3
## 
## $value
## [1] 373
## 
## $counts
## function gradient 
##        2        2 
## 
## $convergence
## [1] 0
## 
## $message
## [1] "CONVERGENCE: NORM OF PROJECTED GRADIENT <= PGTOL"
```

#### 非线性严格不等式约束 {#nonlinear-strictly-inequality-constraints}

第一个例子，目标函数是非线性的，约束条件也是非线性的，非线性不等式约束不包含等号。

\begin{equation*}
\begin{array}{l}
  \min_x \quad (x_1 + 3x_2 + x_3)^2 + 4(x_1 - x_2)^2 \\
    s.t.\left\{ 
    \begin{array}{l}
     x_1 + x_2 + x_3 = 1 \\
     6 x_2 + 4 x_3 - x_1^3 > 3 \\
     x_1, x_2, x_3 > 0
    \end{array} \right.
\end{array}
\end{equation*}


```r
# 目标函数
fn <- function(x) (x[1] + 3 * x[2] + x[3])^2 + 4 * (x[1] - x[2])^2
# 目标函数的梯度
gr <- function(x) {
  c(
    2 * (x[1] + 3 * x[2] + x[3]) + 8 * (x[1] - x[2]), # 对 x[1] 求偏导
    6 * (x[1] + 3 * x[2] + x[3]) - 8 * (x[1] - x[2]), # 对 x[2] 求偏导
    2 * (x[1] + 3 * x[2] + x[3]) # 对 x[3] 求偏导
  )
}
# 等式约束
heq <- function(x) {
  x[1] + x[2] + x[3] - 1 
}
# 等式约束的雅可比矩阵
# 这里只有一个等式约束，所以雅可比矩阵行数为 1
heq.jac <- function(x) {
  matrix(c(1, 1, 1), ncol = 3, byrow = TRUE)
}
# 不等式约束
# 要求必须是严格不等式，不能带等号，方向是 x > 0 
hin <- function(x) {
  c(6 * x[2] + 4 * x[3] - x[1]^3 - 3, x[1], x[2], x[3])
}
# 不等式约束的雅可比矩阵
# 其实是有 4 个不等式约束，3 个目标变量约束，雅可比矩阵行数是 4
hin.jac <- function(x) {
  matrix(c(
    -3 * x[1]^2, 6, 4,
    1, 0, 0,
    0, 1, 0,
    0, 0, 1
  ), ncol = 3, byrow = TRUE)
}
```

调用 **alabama** 包的求解器 


```r
set.seed(12)
# 初始值
p0 <- runif(3)
# 求目标函数的极小值
ans <- alabama::constrOptim.nl(
  par = p0,
  # 目标函数
  fn = fn,
  gr = gr,
  # 等式约束
  heq = heq,
  heq.jac = heq.jac,
  # 不等式约束
  hin = hin,
  hin.jac = hin.jac,
  # 不显示迭代过程
  control.outer = list(trace = FALSE)
)
ans
```

```
## $par
## [1] 7.390292e-04 4.497160e-12 9.992610e-01
## 
## $value
## [1] 1.000002
## 
## $counts
## function gradient 
##     1230      163 
## 
## $convergence
## [1] 0
## 
## $message
## NULL
## 
## $hessian
##           [,1]      [,2]      [,3]
## [1,] 120517098 120517087 120517091
## [2,] 120517087 120517115 120517095
## [3,] 120517091 120517095 120517091
## 
## $outer.iterations
## [1] 13
## 
## $lambda
## [1] 4.481599
## 
## $sigma
## [1] 120517089
## 
## $barrier.value
## [1] 0.003472071
## 
## $K
## [1] 4.269112e-08
```

ans 是 `constrOptim.nl()` 返回的一个 list， convergence = 0 表示迭代成功收敛，value 表示目标函数在迭代终止时的取直，par 表示满足约束条件，成功收敛的情况下，目标函数的参数值，counts 表示迭代过程中目标函数及其梯度计算的次数。


```r
# 不提供梯度函数，照样可以求解
ans <- alabama::constrOptim.nl(par = p0, fn = fn, heq = heq, hin = hin)
```

::: {.rmdtip data-latex="{注意}"}
等式和不等式约束的雅可比矩阵必须以 matrix 数据类型存储，而不能以 vector 类型存储。要注意和后面 ROI 包的调用形式区别。
:::

实际上，可以用 ROI 调用 alabama 求解器的方式，这种方式可以简化目标函数梯度和约束条件的表示


```r
# 目标函数
fn <- function(x) (x[1] + 3 * x[2] + x[3])^2 + 4 * (x[1] - x[2])^2
# 目标函数的梯度
gr <- function(x) {
  c(
    2 * (x[1] + 3 * x[2] + x[3]) + 8 * (x[1] - x[2]),
    6 * (x[1] + 3 * x[2] + x[3]) - 8 * (x[1] - x[2]),
    2 * (x[1] + 3 * x[2] + x[3])
  )
}
heq <- function(x) {
  x[1] + x[2] + x[3]
}
heq.jac <- function(x) {
  c(1, 1, 1)
}
hin <- function(x) {
  6 * x[2] + 4 * x[3] - x[1]^3
}
hin.jac <- function(x) {
   c(-3 * x[1]^2, 6, 4)
}
```

通过 ROI 调用 alabama 求解器


```r
set.seed(2020)
# 初始值
p0 <- runif(3)
# 定义目标规划
op <- OP(
  objective = F_objective(F = fn, n = 3L, G = gr), # 4 个目标变量
  constraints = F_constraint(
    F = list(heq = heq, hin = hin),
    dir = c("==", ">"),
    rhs = c(1, 3),
    # 等式和不等式约束的雅可比
    J = list(heq.jac = heq.jac, hin.jac = hin.jac)
  ),
  bounds = V_bound(ld = 0, ud = +Inf, nobj = 3L),
  maximum = FALSE # 求最小
)
nlp <- ROI_solve(op, solver = "alabama", start = p0)
nlp$solution
```

```
## [1] 1.674812e-06 9.994336e-08 9.999982e-01
```

```r
nlp$objval
```

```
## [1] 1
```

#### 非线性和箱式约束 {#nonlinear-and-box-constrained}

与上面的例子不同，下面这个例子的不等式约束包含等号，还有箱式约束，优化问题来源于[Ipopt 官网](https://coin-or.github.io/Ipopt/INTERFACES.html)，提供的初始值为 $x_0 = (1,5,5,1)$，最优解为 $x_{\star} = (1.00000000,4.74299963,3.82114998,1.37940829)$。优化问题的具体内容如下：

\begin{equation*}
\begin{array}{l}
  \min_x \quad x_1 x_4 (x_1 + x_2 + x_3) + x_3 \\
    s.t.\left\{ 
    \begin{array}{l}
     x_1^2 + x_2^2 + x_3^2 + x_4^2 = 40 \\
     x_1 x_2 x_3 x_4 \geq 25 \\
     1 \leq x_1, x_2, x_3, x_4 \leq 5
    \end{array} \right.
\end{array}
\end{equation*}

考虑用 ROI 调 nloptr 实现，看结果是否和例子一致，nloptr 支持不等式约束包含等号，支持箱式约束。


```r
# 一个 4 维的目标函数
fn <- function(x) {
  x[1] * x[4] * (x[1] + x[2] + x[3]) + x[3]
}
# 目标函数的梯度
gr <- function(x) {
  c(
    x[4] * (2 * x[1] + x[2] + x[3]), x[1] * x[4],
    x[1] * x[4] + 1, x[1] * (x[1] + x[2] + x[3])
  )
}
# 等式约束
heq <- function(x) {
  sum(x^2)
}
# 等式约束的雅可比
heq.jac <- function(x) {
  2 * c(x[1], x[2], x[3], x[4])
}
# 不等式约束
hin <- function(x) {
  prod(x)
}
# 不等式约束的雅可比
hin.jac <- function(x) {
  c(prod(x[-1]), prod(x[-2]), prod(x[-3]), prod(x[-4]))
}
# 定义目标规划
op <- OP(
  objective = F_objective(F = fn, n = 4L, G = gr), # 4 个目标变量
  constraints = F_constraint(
    F = list(heq = heq, hin = hin),
    dir = c("==", ">="),
    rhs = c(40, 25),
    # 等式和不等式约束的雅可比
    J = list(heq.jac = heq.jac, hin.jac = hin.jac)
  ),
  bounds = V_bound(ld = 1, ud = 5, nobj = 4L),
  maximum = FALSE # 求最小
)
```


```r
# 目标函数初始值
fn(c(1, 5, 5, 1))
```

```
## [1] 16
```

```r
# 目标函数最优值
fn(c(1.00000000, 4.74299963, 3.82114998, 1.37940829))
```

```
## [1] 17.01402
```

求解一般的非线性约束问题，求解器 nloptr.mma / nloptr.cobyla 仅支持非线性不等式约束，不支持等式约束，而 nlminb 只支持等式约束，因此，下面分别调用 nloptr.auglag、nloptr.slsqp 和 nloptr.isres 来求解上述优化问题。


```r
nlp <- ROI_solve(op, solver = "nloptr.auglag", start = c(1, 5, 5, 1))
nlp$solution
```

```
## [1] 1.000000 4.743174 3.820922 1.379440
```

```r
nlp$objval
```

```
## [1] 17.01402
```


```r
nlp <- ROI_solve(op, solver = "nloptr.slsqp", start = c(1, 5, 5, 1))
nlp$solution
```

```
## [1] 1.000000 4.742996 3.821155 1.379408
```

```r
nlp$objval
```

```
## [1] 17.01402
```


```r
nlp <- ROI_solve(op, solver = "nloptr.isres", start = c(1, 5, 5, 1))
nlp$solution
```

```
## [1] 1.156667 4.649759 3.950369 1.198390
```

```r
nlp$objval
```

```
## [1] 17.47464
```

可以看出，nloptr 提供的优化能力可以覆盖[Ipopt 求解器](https://github.com/coin-or/Ipopt)，推荐使用 nloptr.slsqp 求解器。


#### 非线性混合整数约束 {#nonlinear-mixed-integer-constrained}

\begin{equation*}
\begin{array}{l}
  \max_x \quad 1.5(x_1 - \sin(x_1 - x_2))^2 + 0.5x_2^2 + x_3^2 - x_1 x_2 - 2x_1 + x_2 x_3 \\
    s.t.\left\{ 
    \begin{array}{l}
     -20 < x_1 < 20 \\
     -20 < x_2 < 20 \\
     -10 < x_3 < 10 \\
     x_1, x_2 \in \mathbb{R}, \quad x_3 \in \mathbb{Z}
    \end{array} \right.
\end{array}
\end{equation*}



```r
fn <- function(x) {
  1.5 * (x[1] - sin(x[1] - x[2]))^2 + 0.5 * x[2]^2 + x[3]^2
  -x[1] * x[2] - 2 * x[1] + x[2] * x[3]
}
gr <- function(x) {
  c(
    3 * (x[1] - sin(x[1] - x[2])) * (1 - cos(x[1] - x[2])) - x[2] - 2,
    3 * (x[1] - sin(x[1] - x[2])) * cos(x[1] - x[2]) - x[2] - x[1] + x[3],
    2 * x[3] + x[2]
  )
}
```

目前 ROI 还解不了


```r
# 初始值
p0 <- c(2.1, 5.1, 5)
# 定义目标规划
op <- OP(
  objective = F_objective(F = fn, n = 3L, G = gr), # 3 个目标变量
  types = c("C", "C", "I"), # 目标变量的类型
  bounds = V_bound(lb = c(-20, -20, -10), ub = c(20, 20, 10), nobj = 3L),
  maximum = FALSE # 求最小
)
nlp <- ROI_solve(op, solver = "auto", start = p0)
nlp$solution
```

目标函数在 $(4.49712, 9.147501, -4)$ 取得最小值 -86.72165


```r
fn(x = c(4.49712, 9.147501, -4))
```

```
## [1] -86.72165
```


#### 含复杂目标函数 {#complex-object-function}

下面这个目标函数比较复杂，约束条件也是非线性的

\begin{equation*}
\begin{array}{l}
  \max_x \quad \frac{(\sin(2\pi x_1))^3 \sin(2\pi x_2)}{x_1^3 (x_1 + x_2)} \\
    s.t.\left\{ 
    \begin{array}{l}
     x_1^2 - x_2 + 1 \leq 0 \\
     1 - x_1 + (x_2 - 4)^2 \geq 0 \\
     0 \leq x_1, x_2 \leq 10
    \end{array} \right.
\end{array}
\end{equation*}



```r
# 目标函数
fn <- function(x) (sin(2*pi*x[1]))^3 * sin(2*pi*x[2])/(x[1]^3*(x[1] + x[2]))
# 目标函数的梯度
gr <- function(x) {
  numDeriv::grad(fn, c(x[1], x[2]))
}

hin <- function(x) {
  c(
    x[1]^2 - x[2] + 1,
    1 - x[1] + (x[2] - 4)^2
  )
}

hin.jac <- function(x) {
  matrix(c(
    2 * x[1], -1,
    -1, 2 * x[2]
  ),
  ncol = 2, byrow = TRUE
  )
}

# 初始值
p0 <- c(2, 5)
# 定义目标规划
op <- OP(
  objective = F_objective(F = fn, n = 2L, G = gr), # 2 个目标变量
  constraints = F_constraint(
    F = list(hin = hin),
    dir = c("<=", "<="),
    rhs = c(0, 0),
    # 不等式约束的雅可比
    J = list(hin.jac = hin.jac)
  ),
  bounds = V_bound(ld = 0, ud = 10, nobj = 2L),
  maximum = TRUE # 求最大
)
nlp <- ROI_solve(op, solver = "nloptr.isres", start = p0)
nlp$solution
```

```
## [1] 1.227972 4.245369
```

```r
nlp$objval
```

```
## [1] 0.09582504
```

下面再给一个来自 [Octave 优化文档](https://octave.org/doc/v6.2.0/Nonlinear-Programming.html) 的示例，该优化问题包含多个非线性的等式约束。

\begin{equation*}
\begin{array}{l}
  \min_x \quad \mathrm{e}^{\prod_{i=1}^{5} x_i} - \frac{1}{2}(x_1^3 + x_2^3 + 1)^2 \\
    s.t.\left\{ 
    \begin{array}{l}
     \sum_{i=1}^{5}x_i^2 - 10 = 0 \\
     x_2 x_3 - 5x_4 x_5 = 0 \\
     x_1^3 + x_2^3 + 1 = 0
    \end{array} \right.
\end{array}
\end{equation*}


```r
# 一个 5 维的目标函数
fn <- function(x) {
  exp(prod(x)) - 0.5 * (x[1]^3 + x[2]^3 + 1)^2
}
# 目标函数的梯度
gr <- function(x) {
  c(
    exp(prod(x))*prod(x[-1]) - 3*(x[1]^3 + x[2]^3 + 1)*x[1]^2,
    exp(prod(x))*prod(x[-2]) - 3*(x[1]^3 + x[2]^3 + 1)*x[2]^2,
    exp(prod(x))*prod(x[-3]), 
    exp(prod(x))*prod(x[-4]),
    exp(prod(x))*prod(x[-5])
  )
}
# 等式约束
heq <- function(x) {
  c(
    sum(x^2) - 10,
    x[2] * x[3] - 5 * x[4] * x[5],
    x[1]^3 + x[2]^3 + 1
  )
}
# 等式约束的雅可比
heq.jac <- function(x) {
  matrix(c(2 * x[1], 2 * x[2], 2 * x[3], 2 * x[4], 2 * x[5],
    0, x[3], x[2], -5 * x[5], -5 * x[4],
    3 * x[1]^2, 3 * x[2]^2, 0, 0, 0),
    ncol = 5, byrow = TRUE
  )
}
```


```r
# 定义目标规划
op <- OP(
  objective = F_objective(F = fn, n = 5L, G = gr), # 5 个目标变量
  constraints = F_constraint(
    F = list(heq = heq),
    dir = "==",
    rhs = 0,
    # 等式的雅可比
    J = list(heq.jac = heq.jac)
  ),
  bounds = V_bound(ld = -Inf, ud = Inf, nobj = 5L),
  maximum = FALSE # 求最小
)
```

调用 SQP（序列二次规划） 求解器


```r
nlp <- ROI_solve(op, solver = "nloptr.slsqp", start = c(-1.8, 1.7, 1.9, -0.8,-0.8))
nlp$solution
```

```
## [1] -1.7171435  1.5957096  1.8272458 -0.7636431 -0.7636431
```

计算结果和 Octave 的示例一致。

#### 含复杂约束条件 {#complex-constrained-function}


\begin{equation*}
\begin{array}{l}
  \min_x \quad \exp(\sin(50\cdot x)) + \sin(60\cdot \exp(y)) + \sin(70\cdot\sin(x)) \\
         \qquad + \sin(\sin(80\cdot y)) - \sin(10\cdot (x +y)) + \frac{(x^2 + y^2)^{\sin(y)}}{4} \\
    s.t. \quad \left\{ 
    \begin{array}{l}
     x - \big((\cos(y))^x - x\big)^y = 0 \\
    -50 \leq x_1,x_2 \leq 50
    \end{array} \right.
\end{array}
\end{equation*}

Lingo 代码如下：

```
Min = @exp(@sin(50 * x)) + @sin(60 * @exp(y)) + @sin(70 * @sin(x)) 
      + @sin(@sin(80 * y)) - @sin(10 * (x + y)) + (x^2 + y^2)^@sin(y) / 4;

x - (( @cos(y) )^x - x)^y = 0;

@bnd(-50, x, 50);
@bnd(-50, y, 50);
```

启用全局优化求解器，求解 14 分钟，在 $(0.08256372, 24.56510)$ 取得极小值 -2.863497。不启用全局优化器就没法解，Lingo 会报错，找不到最优解，勉强找到一个可行解 $(0.06082750, 44.12793)$，目标值为 -1.29816。


```r
fn <- function(x) {
  exp(sin(50 * x[1])) + sin(60 * exp(x[2])) +
    sin(70 * sin(x[1])) + sin(sin(80 * x[2])) -
    sin(10 * (x[1] + x[2])) + (x[1]^2 + x[2]^2)^(sin(x[2])) / 4
}
gr <- function(x){
  numDeriv::grad(fn, c(x[1], x[2]))
}
heq <- function(x){
  x[1] - ( (cos(x[2]))^x[1] - x[1] )^x[2]
}
heq.jac <- function(x){
  numDeriv::grad(heq, c(x[1], x[2]))
}

fn(x = c(0.06082750, 44.12793))
```

```
## [1] -1.29816
```

```r
fn(x = c(1, 0))
```

```
## [1] 1.966877
```

```r
heq(x = c(0.06082750, 44.12793))
```

```
## [1] 1.923673e-08
```

```r
heq(x = c(1, 0))
```

```
## [1] 0
```


```r
# 定义目标规划
op <- OP(
  objective = F_objective(F = fn, n = 2L, G = gr), # 2 个目标变量
  constraints = F_constraint(
    F = list(heq = heq),
    dir = "==",
    rhs = 0,
    J = list(heq.jac = heq.jac)
  ),
  bounds = V_bound(ld = -50, ud = 50, nobj = 2L),
  maximum = FALSE # 求最小
)
```

nloptr.auglag 无法求解此优化问题


```r
nlp <- ROI_solve(op, solver = "nloptr.auglag", start = c(1, 0))
nlp$solution
```

调 nloptr.isres 求解器，每次执行都会得到不同的局部最优解


```r
nlp <- ROI_solve(op, solver = "nloptr.isres", start = c(1, 0))
nlp$solution
```

```
## [1] -9.58856 22.92133
```

```r
nlp$objval
```

```
## [1] -2.912641
```
比如下面三组


```r
fn(x = c(40.95941, 41.52914))
```

```
## [1] -1.025926
```

```r
heq(x = c(40.95941, 41.52914))
```

```
## [1] NaN
```

```r
fn(x = c(-21.88091, 28.96994))
```

```
## [1] -1.467513
```

```r
heq(x = c(-21.88091, 28.96994))
```

```
## [1] NaN
```

```r
fn(x = c(-49.921967437, 4.8499336803))
```

```
## [1] -3.466596
```

```r
heq(x = c(-49.921967437, 4.8499336803))
```

```
## [1] -8.515447e+208
```

## 非线性方程 {#sec-nonlinear-equations}

### 一元非线性方程 {#subsec-equation}

[牛顿-拉弗森方法](https://blog.hamaluik.ca/posts/solving-equations-using-the-newton-raphson-method/)


```r
library(rootSolve)
```

### 非线性方程组 {#subsec-equations}


```r
library(BB)
```

二项混合泊松分布的参数最大似然估计


```r
poissmix.loglik <- function(p, y) {
  # Log-likelihood for a binary Poisson mixture distribution
  i <- 0:(length(y) - 1)
  
  loglik <- y * log(p[1] * exp(-p[2]) * p[2]^i / exp(lgamma(i + 1)) +
    (1 - p[1]) * exp(-p[3]) * p[3]^i / exp(lgamma(i + 1)))

  sum(loglik)
}
# Data from Hasselblad (JASA 1969)
# 介绍实际应用场景
poissmix.dat <- data.frame(death = 0:9, 
                           freq = c(162, 267, 271, 185, 111, 61, 27, 8, 3, 1))
lo <- c(0, 0, 0) # lower limits for parameters
hi <- c(1, Inf, Inf) # upper limits for parameters
p0 <- runif(3, c(0.2, 1, 1), c(0.8, 5, 8)) 
# a randomly generated vector of length 3
y <- c(162, 267, 271, 185, 111, 61, 27, 8, 3, 1)

ans1 <- spg(
  par = p0, fn = poissmix.loglik, y = y, lower = lo, upper = hi,
  control = list(maximize = TRUE, trace = FALSE)
)
ans2 <- BBoptim(
  par = p0, fn = poissmix.loglik, y = y,
  lower = lo, upper = hi, control = list(maximize = TRUE)
)
```

```
## iter:  0  f-value:  -2136.431  pgrad:  236.9752 
## iter:  10  f-value:  -1995.89  pgrad:  2.961353 
## iter:  20  f-value:  -2041.139  pgrad:  2.57697 
## iter:  30  f-value:  -1989.974  pgrad:  0.4742151 
## iter:  40  f-value:  -1989.949  pgrad:  0.2614752 
## iter:  50  f-value:  -1989.946  pgrad:  0.01959506 
## iter:  60  f-value:  -1989.946  pgrad:  0.002494289 
##   Successful convergence.
```

```r
ans2
```

```
## $par
## [1] 0.3598829 1.2560906 2.6634011
## 
## $value
## [1] -1989.946
## 
## $gradient
## [1] 0.0001000444
## 
## $fn.reduction
## [1] -146.4848
## 
## $iter
## [1] 68
## 
## $feval
## [1] 170
## 
## $convergence
## [1] 0
## 
## $message
## [1] "Successful convergence"
## 
## $cpar
## method      M 
##      2     50
```

计算最大似然处的黑塞矩阵以及参数的标准差


```r
hess <- numDeriv::hessian(x = ans2$par, func = poissmix.loglik, y = y)
# Note that we have to supplied data vector 'y'
hess
```

```
##           [,1]      [,2]      [,3]
## [1,] -907.1105  270.2287  341.2543
## [2,]  270.2287 -113.4794  -61.6819
## [3,]  341.2543  -61.6819 -192.7822
```

```r
se <- sqrt(diag(solve(-hess)))
se
```

```
## [1] 0.1946836 0.3500308 0.2504769
```

从不同初始值出发尝试寻找全局最大值，实际找的是一系列局部最大值


```r
# 3 randomly generated starting values
p0 <- matrix(runif(30, c(0.2, 1, 1), c(0.8, 8, 8)), 10, 3, byrow = TRUE)
ans <- multiStart(
  par = p0, fn = poissmix.loglik, action = "optimize",
  y = y, lower = lo, upper = hi, control = list(maximize = TRUE)
)
```

```
## Parameter set :  1 ... 
## iter:  0  f-value:  -2076.377  pgrad:  266.5811 
## iter:  10  f-value:  -1991.788  pgrad:  3.394882 
## iter:  20  f-value:  -1990.932  pgrad:  8.266675 
## iter:  30  f-value:  -1989.958  pgrad:  0.2441652 
## iter:  40  f-value:  -1989.946  pgrad:  0.001411991 
##   Successful convergence.
## Parameter set :  2 ... 
## iter:  0  f-value:  -3999.343  pgrad:  6.350898 
## iter:  10  f-value:  -2015.457  pgrad:  2.400803 
##   Successful convergence.
## Parameter set :  3 ... 
## iter:  0  f-value:  -2526.385  pgrad:  3.959104 
## iter:  10  f-value:  -1997.785  pgrad:  4.651176 
## iter:  20  f-value:  -2041.124  pgrad:  130.6335 
## iter:  30  f-value:  -1989.979  pgrad:  0.4133676 
## iter:  40  f-value:  -1989.953  pgrad:  0.2001525 
## iter:  50  f-value:  -1989.946  pgrad:  0.02953584 
##   Successful convergence.
## Parameter set :  4 ... 
## iter:  0  f-value:  -4036.966  pgrad:  7.725057 
## iter:  10  f-value:  -1993.146  pgrad:  3.356279 
## iter:  20  f-value:  -1992.445  pgrad:  3.162911 
## iter:  30  f-value:  -1999.964  pgrad:  3.124857 
## iter:  40  f-value:  -1990.201  pgrad:  0.9762675 
## iter:  50  f-value:  -1989.962  pgrad:  0.3950169 
## iter:  60  f-value:  -1989.946  pgrad:  0.0507498 
## iter:  70  f-value:  -1989.946  pgrad:  0.0001978151 
##   Successful convergence.
## Parameter set :  5 ... 
## iter:  0  f-value:  -2048.809  pgrad:  2.862445 
## iter:  10  f-value:  -1992.344  pgrad:  2.68979 
## iter:  20  f-value:  -1990.604  pgrad:  7.2791 
## iter:  30  f-value:  -1989.978  pgrad:  0.3772993 
## iter:  40  f-value:  -1989.946  pgrad:  0.004172307 
## iter:  50  f-value:  -1989.946  pgrad:  0.004260983 
##   Successful convergence.
## Parameter set :  6 ... 
## iter:  0  f-value:  -4777.283  pgrad:  7.596832 
## iter:  10  f-value:  -1991.838  pgrad:  11.02078 
## iter:  20  f-value:  -1990.272  pgrad:  0.5307333 
## iter:  30  f-value:  -1989.963  pgrad:  2.230793 
## iter:  40  f-value:  -1989.946  pgrad:  0.008421921 
## iter:  50  f-value:  -1989.946  pgrad:  0.0001841727 
##   Successful convergence.
## Parameter set :  7 ... 
## iter:  0  f-value:  -2019.928  pgrad:  3.485709 
## iter:  10  f-value:  -1990.626  pgrad:  1.833378 
## iter:  20  f-value:  -1989.999  pgrad:  1.098717 
## iter:  30  f-value:  -1989.947  pgrad:  0.3092782 
## iter:  40  f-value:  -1989.946  pgrad:  0.007039489 
##   Successful convergence.
## Parameter set :  8 ... 
## iter:  0  f-value:  -2764.625  pgrad:  4.891128 
## iter:  10  f-value:  -2001.398  pgrad:  2.273737e-06 
##   Successful convergence.
## Parameter set :  9 ... 
## iter:  0  f-value:  -2167.165  pgrad:  195.5499 
## iter:  10  f-value:  -2001.54  pgrad:  2.194864 
## iter:  20  f-value:  -2000.825  pgrad:  0.6559458 
## iter:  30  f-value:  -1992.777  pgrad:  7.064828 
## iter:  40  f-value:  -1991.747  pgrad:  3.357115 
## iter:  50  f-value:  -1989.983  pgrad:  2.772795 
## iter:  60  f-value:  -1989.946  pgrad:  0.03392643 
## iter:  70  f-value:  -1989.946  pgrad:  0.0003728928 
##   Successful convergence.
## Parameter set :  10 ... 
## iter:  0  f-value:  -2100.94  pgrad:  317.5313 
## iter:  10  f-value:  -1991.327  pgrad:  2.7843 
## iter:  20  f-value:  -1990.415  pgrad:  1.435174 
## iter:  30  f-value:  -1990.046  pgrad:  3.248585 
## iter:  40  f-value:  -1989.946  pgrad:  0.06813025 
## iter:  50  f-value:  -1989.946  pgrad:  0.001450644 
##   Successful convergence.
```

```r
# selecting only converged solutions
pmat <- round(cbind(ans$fvalue[ans$conv], ans$par[ans$conv, ]), 4)
dimnames(pmat) <- list(NULL, c("fvalue", "parameter 1", "parameter 2", "parameter 3"))
pmat[!duplicated(pmat), ]
```

```
##         fvalue parameter 1 parameter 2 parameter 3
## [1,] -1989.946      0.6401      2.6634      1.2561
## [2,] -1997.263      0.4922      2.4559      1.8567
## [3,] -1989.946      0.3599      1.2561      2.6634
## [4,] -2000.039      0.7931      2.0681      2.4778
## [5,] -1989.946      0.3599      1.2560      2.6634
```

用一个具体的参数估计问题，求极大似然点，混合正态分布
隐函数方程组
求解非线性方程组 [@BB2019]



## 多目标规划 {#sec-multi-objective-optimization}

多目标规划的基本想法是将多目标问题转化为单目标问题，常见方法有理想点法、线性加权法、非劣解集法、极大极小法。理想点法是先在给定约束条件下分别求解单个目标的最优值，构造新的单目标函数。线性加权法是给每个目标函数赋予权重系数，各个权重系数之和等于1。非劣解集法是先求解其中一个单目标函数的最优值，然后将其设为等式约束，将其最优值从最小值开始递增，然后求解另一个目标函数的最小值。极大极小法是采用标准的简面体爬山法和通用全局优化法求解多目标优化问题。

R 环境中，[GPareto](https://github.com/mbinois/GPareto) 主要用来求解多目标规划问题。[试验设计和过程优化与R语言](https://bookdown.org/gerhard_krennrich/doe_and_optimization/) 的 [约束优化](https://bookdown.org/gerhard_krennrich/doe_and_optimization/optimization.html#constrained-optimization) 章节，[优化和解方程](https://www.stat.umn.edu/geyer/3701/notes/optimize.html)。另外，《Search Methodologies: Introductory Tutorials in Optimization and Decision Support Techniques》[@Deb2005] 多目标优化方法


\begin{equation*}
\begin{array}{l}
  \min_x \left\{
      \begin{array}{l}  
        f_1(x) = 0.5x_1 + 0.6x_2 + 0.7 \exp(\frac{x_1 + x_3}{10}) \\
        f_2(x) = (x_1 - 2x_2)^2 + (2x_2 - 3x_3)^2 + (5x_3 -x_1)^2
      \end{array} \right. \\
    s.t. \quad x_1 \in [10, 80], x_2 \in [20, 90], x_3 \in [15, 100]
\end{array}
\end{equation*}


```r
library(DiceKriging)
library(emoa)
library(GPareto)
library(DiceDesign)
```


```r
library(Ternary)
TernaryPlot(
  atip = "Top", btip = "Bottom", ctip = "Right", 
  axis.col = "red", col = rgb(0.8, 0.8, 0.8)
)
HorizontalGrid(grid.lines = 2, grid.col = "blue", grid.lty = 1)
```

## 经典优化问题 {#sec-classic-optimization}

旅行商问题、背包问题、指派问题、选址问题、网络流量问题

规划快递员送餐的路线：从快递员出发地到各个取餐地，再到顾客家里，如何规划路线使得每个顾客下单到拿到餐的时间间隔小于 50 分钟，完成送餐，快递员的总时间最少？

## 回归与优化 {#sec-regression-optimization}

简单线性回归

[nlsr](https://cran.r-project.org/package=nlsr)

是否能给大家提供一些思路？

Lasso [@lasso1996]

Least Angle Regression [@lar2004]

为了解决Lasso的有偏估计问题，自适应 Lasso、松弛 Lasso 
SCAD (Smoothly Clipped Absolute Deviation)[@scad2008]
MCP (Minimax Concave Penalty)[@mcp2010]

由于缺少高效的求解算法，Lasso 在高维小样本特征选择研究中没有广泛流行，最小角回归(Least Angle Regression, LAR)算法 [@lar2004] 的出现有力促进了Lasso在高维小样本数据中的应用

[bestsubset](https://github.com/ryantibs/best-subset/) 最优子集回归

经典的普通最小二乘、广义最小二乘、岭回归、逐步回归、Lasso 回归、最优子集回归都可转化为优化问题，一般形式如下

$$
\underbrace{\hat{\theta}_{\lambda_n}}_{\text{待估参数}} \in \arg \min_{\theta \in \Omega} \left\{ \underbrace{\mathcal{L}(\theta;Z_{1}^{n})}_{\text{损失函数}} + \lambda_n \underbrace{\mathcal{R}(\theta)}_{\text{正则化项}} \right\}.
$$

下面尝试以 nloptr 包的优化器来展示求解过程，并与 Base R、**glmnet** 和 **MASS** 实现的回归模型比较。

<!-- 向量用小写，矩阵用大写 -->

$$
\arg \min_{\beta,\lambda} ~~ \frac{1}{2} || \mathbf{y} - \mathbf{X} \beta ||_2^2 +  \lambda ||\beta||_1
$$
其中，$X \in \mathbb{R}^{m\times n}$， $y \in \mathbb{R}^m$，$\beta \in \mathbb{R}^n$， $0 < \lambda \in \mathbb{R}$

<!-- 
广义最小二乘拟合 nlme::gls  预测 nlme::predict.gls
用广义最小二乘拟合线性模型 MASS::lm.gls	
用广义最小二乘拟合趋势面 spatial::surf.gls
-->

$$y = X\beta + \epsilon$$

$\hat{\beta} = (X^{\top}X)^{-1}X^{\top}y, \quad \hat{Y} = X(X^{\top}X)^{-1}X^{\top}y$


```r
set.seed(123)
n <- 200
p <- 50
x <- matrix(rnorm(n * p), n)
y <- rnorm(n)
lm(y ~ x + 0)
# y 的估计
# 教科书版
fit_base = function(x, y) {
  x %*% solve(t(x) %*% x) %*% t(x) %*% y
}
# 先向量计算，然后矩阵计算
fit_vector = function(x, y) {
  x %*% (solve(t(x) %*% x) %*% (t(x) %*% y))
}
# X'X 是对称的，防止求逆
fit_inv = function(x, y) {
  x %*% solve(crossprod(x), crossprod(x, y))
}
```

QR 分解 $X_{n\times p} = Q_{n\times p} R_{p\times p}$，$n > p$，$Q^{\top}Q = I$，$R$ 是上三角矩阵，$\hat{Y} = X(X^{\top}X)^{-1}X^{\top}y = QQ^{\top}y$


```r
fit_qr <- function(x, y) {
  decomp <- qr(x)
  qr.qy(decomp, qr.qty(decomp, y))
}
lm.fit(x, y)
```

若 $A = X^{\top}X$ 是正定矩阵，则 $A = LL^{\top}$，$L$ 是下三角矩阵


```r
fit_chol <- function(x, y) {
  decomp <- chol(crossprod(x))
  lxy <- backsolve(decomp, crossprod(x, y), transpose = TRUE)
  b <- backsolve(decomp, lxy)
  x %*% b
}
```


```r
## Using C/C++
system.time(RcppEigen::fastLmPure(x, y, method = 1)) ## QR
system.time(RcppEigen::fastLmPure(x, y, method = 2)) ## Cholesky
system.time(RcppArmadillo::fastLmPure(x, y, method = 1)) ## QR
system.time(RcppArmadillo::fastLmPure(x, y, method = 2)) ## Cholesky
```

## 对数似然 {#sec-log-likelihood}

随机变量 X 服从参数为 $\lambda > 0$ 的指数分布，密度函数 $p(x)$ 为

\begin{equation*}
\begin{array}{l}
 p(x) = \left\{ 
    \begin{array}{l}
    \lambda\mathrm{e}^{-\lambda x},  x \geq 0\\
    0, \quad x < 0
    \end{array} \right.
\end{array}
\end{equation*}

其中，$\lambda > 0$，下面给定一系列模拟样本观察值 $x_1, x_2, \cdots, x_n$，估计参数 $\lambda$。对数似然函数 $\ell(\lambda) = \log \prod_{i=1}^{n} f(x_i) = n \log \lambda - \lambda \sum_{i=1}^{n}x_i$。解此方程即可得到 $\lambda$ 的极大似然估计 $\lambda_{mle} = \frac{1}{\bar{X}}$，极大值 $\ell(\lambda_{mle}) = - n(1 + \log \bar{X})$。

根据上述样本，计算样本均值 $(\mu - 1.5*\sigma/\sqrt{n}, \mu + 1.5*\sigma/\sqrt{n})$ 和方差 $(0.8\sigma, 1.5\sigma)$。
已知正态分布 $f(x) = \frac{1}{\sqrt{2\pi}\sigma}\mathrm{e}^{- \frac{(x - \mu)^2}{2\sigma^2}}$ 的对数似然形式 $\ell(\mu,\sigma^2) = \log \prod_{i=1}^{n} f(x_i) = \sum_{i=1}^{n}\log f(x_i)$。正态分布的密度函数的对数可用 `dnorm(..., log = TRUE)` 计算。

生成服从指数分布的样本，计算样本的均值和方差，依据均值和方差构造区间，然后将区间网格化，在此网格上绘制正态分布的对数似然函数。绕那么大一个圈子，其实就是绘制正态分布的对数似然函数。


```r
set.seed(2021)
n <- 20 # 随机数的个数
x <- rexp(n, rate = 5) # 服从指数分布的随机数
m <- 40 # 网格数

mu <- seq(
  mean(x) - 1.5 * sd(x) / sqrt(n),
  mean(x) + 1.5 * sd(x) / sqrt(n),
  length.out = m
)
sigma <- seq(0.8 * sd(x), 1.5 * sd(x), length.out = m)
df <- expand.grid(x = mu, y = sigma)
# 正态分布的对数似然
loglik <- function(b, x0) -sum(dnorm(x0, b[1], b[2], log = TRUE))

df$fnxy = apply(df, 1, loglik, x0 = x)

wireframe(
  data = df, fnxy ~ x * y,
  shade = TRUE, drape = FALSE,
  xlab = expression(mu), 
  ylab = expression(sigma), 
  zlab = list(expression(-loglik(mu, sigma)), rot = 90),
  scales = list(arrows = FALSE, col = "black"),
  par.settings = list(axis.line = list(col = "transparent")),
  screen = list(z = 120, x = -70, y = 0)
)
```

\begin{figure}

{\centering \includegraphics{numerical-optimization_files/figure-latex/log-likelihood-1} 

}

\caption{正态分布参数的负对数似然函数}(\#fig:log-likelihood)
\end{figure}


<!-- 添加极大值点，除指数分布外，还有正态、二项、泊松分布观察其似然曲面的特点，都是单峰，有唯一极值点，再考虑正态混合模型的似然曲面 -->

## 微分方程 {#sec-non-linear-tseries}

<!-- 介绍洛伦兹方程、人口模型、寿险精算模型、混沌 -->

[ode45 求解偏微分方程](https://blog.hamaluik.ca/posts/solving-systems-of-partial-differential-equations/)

**pracma** 实现了 ode23, ode23s, ode45 等几个自适应的 Runge-Kutta 求解器，**deSolve** 包求解 ODE（常微分方程）, DAE（微分代数方程）, DDE（延迟微分方程，包含刚性和非刚性方程）和 PDE（偏微分方程），**bvpSolve**包求解 DAE/ODE 方程的边值问题。**ReacTran** [@ReacTran2012] 可将偏微分方程转为常微分方程组，解决反应运输问题，在笛卡尔、极坐标、圆柱形和球形网格上离散偏微分方程。 [sundials](https://github.com/LLNL/sundials) 提供一系列非线性方程、常微分方程、微分代数方程求解器，Satyaprakash Nayak 开发了相应的 [**sundialr**](https://github.com/sn248/sundialr) 包。

### 常微分方程 {#subsec-ordinary-differential-equations}

[洛伦兹系统](https://en.wikipedia.org/wiki/Lorenz_system)是一个常微分方程组，系统参数的默认值为 $(\sigma = 10, \rho = 28, \beta = 8/3)$，初值为 $(-13, -14, 47)$。


\begin{equation*}
\left\{ 
  \begin{array}{l}
    \frac{\partial x}{\partial t} = \sigma (y - x) \\
    \frac{\partial y}{\partial t} = x(\rho -z) - y \\
    \frac{\partial x}{\partial t} = xy - \beta z
  \end{array} \right.
\end{equation*}



```r
library(deSolve)
# 参数
pars <- c(a = -8 / 3, b = -10, c = 28)
# 初值
state <- c(X = 1, Y = 1, Z = 1)
# 时间间隔
times <- seq(0, 100, by = 0.01)
# 定义方程组
lorenz_fun <- function(t, state, parameters) {
  with(as.list(c(state, parameters)), {
    dX <- a * X + Y * Z
    dY <- b * (Y - Z)
    dZ <- -X * Y + c * Y - Z
    list(c(dX, dY, dZ))
  })
}
out <- ode(
  y = state, times = times,
  func = lorenz_fun, parms = pars
)
```

调用 **scatterplot3d** 绘制三维曲线图，如图\@ref(fig:ode-lorenz) 所示


```r
library(scatterplot3d)

scatterplot3d(
  x = out[, "X"], y = out[, "Y"], z = out[, "Z"],
  col.axis = "black", type = "l", color = "gray",
  xlab = expression(x), ylab = expression(y), zlab = expression(z),
  col.grid = "gray", main = "Lorenz"
)
```

\begin{figure}

{\centering \includegraphics{numerical-optimization_files/figure-latex/ode-lorenz-1} 

}

\caption{洛伦兹曲线}(\#fig:ode-lorenz)
\end{figure}

### 偏微分方程 {#subsec-partial-differential-equations}

ReacTran 的几个关键函数介绍

一维热传导方程

\begin{equation*}
\left\{ 
  \begin{array}{l}
    \frac{\partial y}{\partial t} = D \frac{\partial^2 y}{\partial x^2}
  \end{array} \right.
\end{equation*}

参数 $D = 0.01$，边界条件 $y_{t,x=0} = 0, y_{t, x = 1} = 1$，初始条件 $y_{t=0,x} = \sin(\pi x)$。



```r
library(ReacTran)

N <- 100
xgrid <- setup.grid.1D(x.up = 0, x.down = 1, N = N)
x <- xgrid$x.mid
D.coeff <- 0.01
Diffusion <- function(t, Y, parms) {
  tran <- tran.1D(
    C = Y, C.up = 0, C.down = 1,
    D = D.coeff, dx = xgrid
  )
  list(
    dY = tran$dC, 
    flux.up = tran$flux.up,
    flux.down = tran$flux.down
  )
}
yini <- sin(pi * x)
times <- seq(from = 0, to = 5, by = 0.01)
out <- ode.1D(
  y = yini, times = times, func = Diffusion,
  parms = NULL, dimens = N
)
```


```r
image(out,
  grid = xgrid$x.mid, xlab = "times",
  ylab = "Distance", main = "PDE", add.contour = TRUE
)
```

\begin{figure}

{\centering \includegraphics{numerical-optimization_files/figure-latex/pde-1d-1} 

}

\caption{一维热传导方程的数值解热力图}(\#fig:pde-1d)
\end{figure}

二维拉普拉斯方程

\begin{equation*}
\left\{ 
  \begin{array}{l}
    \frac{\partial^2 u}{\partial^2 x} + \frac{\partial^2 u}{\partial y^2} = 0
  \end{array} \right.
\end{equation*}

边界条件

\begin{equation*}
\left\{ 
  \begin{array}{l}
    u_{x=0,y} = u_{x=1,y} = 0 \\
    \frac{\partial u_{x, y=0}}{\partial y} = 0 \\
    \frac{\partial u_{x,y=1}}{\partial y} = \pi\sinh(\pi)\sin(\pi x)
  \end{array} \right.
\end{equation*}

它有解析解

$$
u(x,y) = \sin(\pi x)\cosh(\pi y)
$$

其中 $x \in [0,1], y\in [0,1]$


```r
fn <- function(x, y) {
  sin(pi * x) * cosh(pi * y)
}
x <- seq(0, 1, length.out = 101)
y <- seq(0, 1, length.out = 101)
z <- outer(x, y, fn)
```



```r
image(z, col = terrain.colors(20))
contour(z, method = "flattest", add = TRUE, lty = 1)
```

\begin{figure}

{\centering \includegraphics{numerical-optimization_files/figure-latex/laplace-eq-image-1} 

}

\caption{解析解的二维图像}(\#fig:laplace-eq-image)
\end{figure}


```r
persp(z, 
  theta = 30, phi = 20, 
  r = 50, d = 0.1, expand = 0.5, ltheta = 90, lphi = 180,
  shade = 0.1, ticktype = "detailed", nticks = 5, box = TRUE,
  col = drapecol(z, col = terrain.colors(20)),
  border = "transparent",
  xlab = "X", ylab = "Y", zlab = "Z", 
  main = ""
)
```

\begin{figure}

{\centering \includegraphics{numerical-optimization_files/figure-latex/laplace-eq-persp-1} 

}

\caption{解析解的三维透视图像}(\#fig:laplace-eq-persp)
\end{figure}

求解 PDE


```r
dx <- 0.2
xgrid <- setup.grid.1D(-100, 100, dx.1 = dx)
x <- xgrid$x.mid
N <- xgrid$N

uini <- exp(-0.05 * x^2)
vini <- rep(0, N)
yini <- c(uini, vini)
times <- seq(from = 0, to = 50, by = 1)

wave <- function(t, y, parms) {
  u1 <- y[1:N]
  u2 <- y[-(1:N)]
  du1 <- u2
  du2 <- tran.1D(C = u1, C.up = 0, C.down = 0, D = 1, dx = xgrid)$dC
  return(list(c(du1, du2)))
}

out <- ode.1D(
  func = wave, y = yini, times = times, parms = NULL,
  nspec = 2, method = "ode45", dimens = N, names = c("u", "v")
)
```

### 延迟微分方程 {#subsec-delay-differential-equations}


```r
library(PBSddesolve)    # DAE 延迟微分方程
```

[**PBSddesolve**](https://github.com/pbs-software/pbs-ddesolve) [@PBSddesolve]
**PBSmodelling**
**PBSmapping**

**nlmeODE** 通过微分方程整合用于混合效应模型的 odesolve 和 nlme 包。

### 随机微分方程 {#subsec-stochastic-differential-equations}

[Sim.DiffProc](https://github.com/acguidoum/Sim.DiffProc)

[随机微分方程入门：基于 R 语言的模拟和推断](https://uploads.cosx.org/2008/12/stochastic-differential-equation-with-r.pdf)


```r
library(Sim.DiffProc)
```



种群 ODE 建模，

[nlmixr](https://github.com/nlmixrdevelopment/nlmixr) 借助 [RxODE](https://github.com/nlmixrdevelopment/RxODE/) 求解基于常微分方程的非线性混合效应模型

## 运行环境 {#sec-numerical-optimization-session}


```r
sessionInfo()
```

```
## R version 4.1.3 (2022-03-10)
## Platform: x86_64-pc-linux-gnu (64-bit)
## Running under: Ubuntu 20.04.4 LTS
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
##  [1] Deriv_4.1.3               quadprog_1.5-8           
##  [3] kableExtra_1.3.4          tibble_3.1.6             
##  [5] Sim.DiffProc_4.8          nlmeODE_1.1              
##  [7] nlme_3.1-157              PBSddesolve_1.12.6       
##  [9] ReacTran_1.4.3.1          shape_1.4.6              
## [11] scatterplot3d_0.3-41      deSolve_1.31             
## [13] BB_2019.10-1              rootSolve_1.8.2.3        
## [15] kernlab_0.9-29            lattice_0.20-45          
## [17] ROI.plugin.scs_1.1-1      ROI.plugin.quadprog_1.0-0
## [19] ROI.plugin.lpsolve_1.0-1  ROI.plugin.nloptr_1.0-0  
## [21] ROI.plugin.alabama_1.0-0  ROI_1.0-0                
## [23] lpSolve_5.6.15           
## 
## loaded via a namespace (and not attached):
##  [1] svglite_2.1.0           sysfonts_0.8.8          digest_0.6.29          
##  [4] utf8_1.2.2              slam_0.1-50             R6_2.5.1               
##  [7] alabama_2015.3-1        evaluate_0.15           httr_1.4.2             
## [10] pillar_1.7.0            rlang_1.0.2             curl_4.3.2             
## [13] rstudioapi_0.13         nloptr_2.0.0            rmarkdown_2.13         
## [16] webshot_0.5.2           stringr_1.4.0           munsell_0.5.0          
## [19] compiler_4.1.3          numDeriv_2016.8-1.1     xfun_0.30              
## [22] systemfonts_1.0.4       pkgconfig_2.0.3         htmltools_0.5.2        
## [25] bookdown_0.25           viridisLite_0.4.0       fansi_1.0.3            
## [28] crayon_1.5.1            MASS_7.3-56             grid_4.1.3             
## [31] lifecycle_1.0.1         registry_0.5-1          magrittr_2.0.3         
## [34] scales_1.1.1            cli_3.2.0               stringi_1.7.6          
## [37] xml2_1.3.3              ellipsis_0.3.2          vctrs_0.4.0            
## [40] lpSolveAPI_5.5.2.0-17.7 tools_4.1.3             glue_1.6.2             
## [43] parallel_4.1.3          fastmap_1.1.0           yaml_2.3.5             
## [46] colorspace_2.0-3        scs_3.0-0               rvest_1.0.2            
## [49] knitr_1.38
```

