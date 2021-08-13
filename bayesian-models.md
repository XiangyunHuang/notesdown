# 贝叶斯模型 {#chap-bayesian-models}



[LaplacesDemon](https://github.com/LaplacesDemonR/LaplacesDemon) 支持常见模型的贝叶斯推断，具体可见[网站](https://CRAN.R-project.org/package=LaplacesDemon) [@LaplacesDemon2021]，[shinystan](https://github.com/stan-dev/shinystan) 借助 [rstan](https://github.com/stan-dev/rstan) 打包了一些 stan 编写的统计模型，提供模型评估的功能。相比于 [rstan](https://github.com/stan-dev/rstan)，[brms](https://github.com/paul-buerkner/brms) 支持了更加广泛的模型，[shinybrms](https://github.com/fweber144/shinybrms) 类似 [shinystan](https://github.com/stan-dev/shinystan) 提供可视化的 shiny 前端，方便用户调用模型和评估效果。[rstanarm](https://github.com/stan-dev/rstanarm) 基于 stan 语言重写了 [arm](https://github.com/suyusung/arm) 里的模型，和 [brms](https://github.com/paul-buerkner/brms) 一样，提供类似 [lme4](https://github.com/lme4/lme4) 的公式语法，和 Base R 内置的函数 `lm()` 和 `glm()` 保持一致，降低用户学习成本。

[cmdstanr](https://github.com/stan-dev/cmdstanr) 相比于 rstan 将会更加轻量，更快地将 CmdStan 的新功能融入进来，方便用户滚动升级，相比于 **rstan** 包，**cmdstanr** 包的一个巨大优势是和 Stan 软件的更新分离。做贝叶斯计算的软件框架还包括 JAGS 和 WinBUGS，苏毓松开发的 R2jags 包 [@R2jags] 是 JAGS 的 R 接口。

[TMB](https://github.com/kaskr/adcomp)

- 书籍：
[Richard McElreath](https://xcelab.net/rm/) 为《Statistical Rethinking》写的 [rethinking](https://github.com/rmcelreath/rethinking) 包，参考 Derek S. Young [@Regression_2017_Young] 和 Michael H. Kutner 等 [@Kutner_2005_Applied]

- 论文：
An Introduction to Inductive Statistical Inference: from Parameter Estimation to Decision-Making <https://arxiv.org/abs/1808.10173v2> 固定效应/随机效应广义线性模型：多水平各种模型回归，模型结构和 Stan 代码

- 课程：
线性模型的内容主要分为四大块，分别是线性回归模型、方差分析模型、协方差分析模型和线性混合效应模型。国外 David Pollard 的线性模型 [课程内容](http://www.stat.yale.edu/~pollard/Courses/312.fall2016/)

- 会议：
Paul-Christian Bürkner 在 Stan 大会上介绍 brms 和 rstanarm <https://github.com/InsuranceDataScience/StanWorkshop2018>

## 软件配置 {#sec-stan-setup}

从 GitHub 下载最新版的源码包 <https://github.com/stan-dev/cmdstan/releases/latest>，编译二进制版本

```bash
tar -xzf /Users/xiangyun/Desktop/cmdstan-2.26.0.tar.gz -C /opt/
cd cmdstan-2.26.0
make build
```

设置环境变量 CMDSTAN 指向 CmdStan 安装路径，加载 **cmdstanr** 包会自动检测和加载

```r
Sys.setenv(CMDSTAN="/opt/cmdstan-2.26.0")
```

还可以设置环境变量 `CMDSTANR_NO_VER_CHECK=TRUE`，让 cmdstanr 不要检查 CmdStan 版本状态，是不是最新版，比如本书将固定下 CmdStan 版本为 2.26.0

**cmdstanr** 当前还在开发中，安装方式如下


```r
remotes::install_github('stan-dev/cmdstanr')
# 或者
install.packages("cmdstanr", repos = c("https://mc-stan.org/r-packages/", getOption("repos")))
```

另有一篇博文介绍在 [Windows 系统上安装 cmdstanr](https://www.maxmantei.com/blog/2020-05-16-installing-cmdstanr-on-windows/cmdstanr-windows/) 的过程，这里不做展开。


```r
# rstan
# brms
# rstanarm
remotes::install_github('rmcelreath/rethinking')
```

## 正态分布 {#sec-bayesian-normal-distribution}

我们以估计正态分布参数为例说明贝叶斯估计方法

$$Y \sim \mathcal{N}(\mu,\sigma^2)$$
已知 $y_1,y_2,\ldots,y_n$ 是来自正态总体 $\mathcal{N}(\mu,\sigma^2)$ 的一个样本，我们需要估计这个正态分布模型的参数 $\mu$ 和 $\sigma^2$。

最大似然估计，简单推导过程，计算代码；再讲 stan 的计算步骤




```r
library(cmdstanr)
mod <- cmdstan_model(stan_file = "code/normal_dist.stan", compile = TRUE)
```

打包观测数据，初始化待估参数值，指定链条数，其中 `dataList` 必须与 stan 代码中数据块声明保持一致（如变量名称，长度），每条链使用不同的初始值，选择合适的初始值可以有效地提高收敛的速度。


```r
# 数据准备
set.seed(20190427)
# 设置参数
mu <- 10
sd <- 2
# 样本量
nobs <- 500
nchains <- 4
# 生成随机数
y <- rnorm(n = nobs, mean = mu, sd = sd)
# 给每条链设置不同的参数初始值
inits_data <- lapply(1:nchains, function(i) {
  list(
    mu = runif(1, min(y), max(y)),
    sigma = runif(1, 1, 10)
  )
})
```

将参数初值代入模型，抽样，获取参数的后验分布


```r
normal_fit <- mod$sample(
  data = list(
    N = nobs,
    y = y
  ),
  init = inits_data,
  iter_warmup = 1000, # 每条链预处理迭代次数
  iter_sampling = 2000, # 每条链总迭代次数
  chains = nchains, # 马尔科夫链的数目
  parallel_chains = 1, # 指定 CPU 核心数，可以给每条链分配一个
  show_messages = FALSE, # 不显示迭代的中间过程
  refresh = 0, # 不显示采样的进度
  seed = 20190425 # 设置随机数种子，不要使用 set.seed() 函数
)
```

```
## Running MCMC with 4 sequential chains...
## 
## Chain 1 finished in 0.1 seconds.
## Chain 2 finished in 0.1 seconds.
## Chain 3 finished in 0.1 seconds.
## Chain 4 finished in 0.1 seconds.
## 
## All 4 chains finished successfully.
## Mean chain execution time: 0.1 seconds.
## Total execution time: 0.6 seconds.
```

检查收敛性，Rhat 决定收敛性，所有待估参数的Rhat必须小于1.1，同时有效样本数量 n_eff 除以抽样总数 N 必须小于0.001，否则收敛性是值得怀疑的。拟合结果及解释如下：


```r
# 模型参数估计结果
normal_fit$cmdstan_summary()
```

```
## Inference for Stan model: normal_dist_model
## 4 chains: each with iter=(2000,2000,2000,2000); warmup=(0,0,0,0); thin=(1,1,1,1); 8000 iterations saved.
## 
## Warmup took (0.014, 0.014, 0.014, 0.014) seconds, 0.056 seconds total
## Sampling took (0.045, 0.041, 0.040, 0.037) seconds, 0.16 seconds total
## 
##                 Mean     MCSE  StdDev    5%   50%  95%    N_Eff  N_Eff/s    R_hat
## 
## lp__            -602  1.7e-02     1.0  -604  -601 -601     3591    22032      1.0
## accept_stat__   0.92  3.3e-03    0.11  0.69  0.96  1.0  1.1e+03  6.5e+03  1.0e+00
## stepsize__      0.88  6.9e-02   0.098  0.73  0.90  1.0  2.0e+00  1.2e+01  1.5e+13
## treedepth__      1.9  1.2e-01    0.56   1.0   2.0  3.0  2.1e+01  1.3e+02  1.1e+00
## n_leapfrog__     3.7  3.7e-01     1.8   1.0   3.0  7.0  2.4e+01  1.5e+02  1.0e+00
## divergent__     0.00      nan    0.00  0.00  0.00 0.00      nan      nan      nan
## energy__         603  2.5e-02     1.4   601   602  605  3.3e+03  2.0e+04  1.0e+00
## 
## mu                10  1.2e-03   0.092   9.9    10   10     5732    35165     1.00
## sigma            2.0  7.7e-04   0.064   1.9   2.0  2.1     6885    42238     1.00
## 
## Samples were drawn using hmc with nuts.
## For each parameter, N_Eff is a crude measure of effective sample size,
## and R_hat is the potential scale reduction factor on split chains (at 
## convergence, R_hat=1).
```

调用 draws 方法 `normal_fit$draws()`，获得一个由 **posterior** 构造的 `draws_array` 对象，


```r
draws_array <- normal_fit$draws()
str(draws_array)
```

```
##  'draws_array' num [1:2000, 1:4, 1:3] -601 -601 -602 -601 -601 ...
##  - attr(*, "dimnames")=List of 3
##   ..$ iteration: chr [1:2000] "1" "2" "3" "4" ...
##   ..$ chain    : chr [1:4] "1" "2" "3" "4"
##   ..$ variable : chr [1:3] "lp__" "mu" "sigma"
```

采样结果可以直接传递给 **bayesplot** 包，绘制参数的后验分布和马尔科夫链蒙特卡罗采样的轨迹图（trace plot）。


```r
library(bayesplot)
mcmc_trace(normal_fit$draws(c("mu", "sigma")))
mcmc_hist(normal_fit$draws(c("mu", "sigma")))
```

\begin{figure}

{\centering \subfloat[参数的轨迹图(\#fig:mu-sigma-dist-1)]{\includegraphics{bayesian-models_files/figure-latex/mu-sigma-dist-1} }\newline\subfloat[参数的后验分布图(\#fig:mu-sigma-dist-2)]{\includegraphics{bayesian-models_files/figure-latex/mu-sigma-dist-2} }

}

\caption{(ref:mu-dist-cap)}(\#fig:mu-sigma-dist)
\end{figure}

(ref:mu-dist-cap) 参数 $\mu, \sigma$ 的迭代轨迹图和后验分布图

## 高斯过程 {#sec-gaussian-process}

模拟高斯过程例子来自 Stan 参考手册 [@Stan_2018_Bayesian]




```r
mod <- cmdstan_model(stan_file = "code/normal_gp.stan")
```

stan 库内置了核函数为二次幂指数的实现，因此可以直接调用 `cov_exp_quad` 函数计算协方差矩阵




```r
mod <- cmdstan_model(stan_file = "code/compat_gp.stan")
```

以 MASS 的 topo 数据集引出高斯过程回归模型问题复杂性

## 分层正态模型 {#sec-hierarchical-normal-models}

Multilevel Models 多水平模型、Hierarchical Models 层次模型

### schools 数据 {#sec-eight-schools}




```r
# 模型编译
mod <- cmdstan_model(stan_file = "code/eight_schools.stan")

# 模型拟合
eight_schools_fit <- mod$sample(
  data = list( # 观测数据
    J = 8,
    y = c(28, 8, -3, 7, -1, 1, 18, 12),
    sigma = c(15, 10, 16, 11, 9, 11, 10, 18)
  ),
  iter_warmup = 1000, # 每条链预处理迭代次数
  iter_sampling = 2000, # 每条链总迭代次数
  chains = 4, # 马尔科夫链的数目
  parallel_chains = 1, # 指定 CPU 核心数，可以给每条链分配一个
  show_messages = FALSE, # 不显示迭代的中间过程
  refresh = 0, # 不显示采样的进度
  seed = 20190425 # 设置随机数种子，不要使用 set.seed() 函数
)
```

```
## Running MCMC with 4 sequential chains...
## 
## Chain 1 finished in 0.1 seconds.
## Chain 2 finished in 0.1 seconds.
## Chain 3 finished in 0.1 seconds.
## Chain 4 finished in 0.1 seconds.
## 
## All 4 chains finished successfully.
## Mean chain execution time: 0.1 seconds.
## Total execution time: 0.8 seconds.
```

模型拟合结果


```r
eight_schools_fit$cmdstan_summary()
```

```
## Inference for Stan model: eight_schools_model
## 4 chains: each with iter=(2000,2000,2000,2000); warmup=(0,0,0,0); thin=(1,1,1,1); 8000 iterations saved.
## 
## Warmup took (0.023, 0.026, 0.023, 0.027) seconds, 0.099 seconds total
## Sampling took (0.072, 0.082, 0.082, 0.088) seconds, 0.32 seconds total
## 
##                     Mean     MCSE  StdDev     5%       50%   95%    N_Eff  N_Eff/s    R_hat
## 
## lp__            -4.0e+01  5.4e-02     2.7    -44  -3.9e+01   -36     2447     7553     1.00
## accept_stat__       0.88  1.5e-02    0.20   0.40      0.96   1.0  1.8e+02  5.6e+02  1.0e+00
## stepsize__          0.34  3.2e-02   0.045   0.28      0.33  0.41  2.0e+00  6.2e+00  1.8e+13
## treedepth__          3.5  1.8e-01    0.54    3.0       4.0   4.0  8.4e+00  2.6e+01  1.1e+00
## n_leapfrog__          12  1.3e+00     4.0    7.0        15    15  9.9e+00  3.0e+01  1.1e+00
## divergent__         0.00      nan    0.00   0.00      0.00  0.00      nan      nan      nan
## energy__              45  7.2e-02     3.5     39        44    51  2.4e+03  7.5e+03  1.0e+00
## 
## mu               8.0e+00  8.1e-02     5.0  0.015   7.9e+00    17     3886    11994      1.0
## tau              6.6e+00  1.0e-01     5.6   0.48   5.3e+00    17     3064     9457      1.0
## eta[1]           3.9e-01  1.1e-02    0.95   -1.2   4.2e-01   1.9     7716    23814     1.00
## eta[2]          -4.0e-04  9.5e-03    0.88   -1.4   2.1e-04   1.4     8427    26009     1.00
## eta[3]          -2.0e-01  1.0e-02    0.94   -1.7  -2.0e-01   1.4     8319    25677      1.0
## eta[4]          -3.0e-02  9.7e-03    0.88   -1.5  -2.8e-02   1.4     8220    25370      1.0
## eta[5]          -3.7e-01  1.0e-02    0.88   -1.8  -3.9e-01   1.1     7355    22700      1.0
## eta[6]          -2.2e-01  9.8e-03    0.90   -1.7  -2.5e-01   1.3     8439    26046      1.0
## eta[7]           3.5e-01  1.0e-02    0.88   -1.1   3.7e-01   1.8     7255    22391      1.0
## eta[8]           5.4e-02  1.1e-02    0.93   -1.5   6.6e-02   1.6     7356    22703     1.00
## theta[1]         1.1e+01  1.1e-01     8.4   0.10   1.0e+01    27     5668    17493     1.00
## theta[2]         7.9e+00  6.8e-02     6.4   -2.5   7.9e+00    18     8940    27593      1.0
## theta[3]         6.2e+00  9.3e-02     7.7   -7.5   6.6e+00    18     6961    21484      1.0
## theta[4]         7.7e+00  7.1e-02     6.5   -3.0   7.7e+00    18     8515    26281      1.0
## theta[5]         5.0e+00  7.0e-02     6.4   -6.4   5.5e+00    14     8218    25363      1.0
## theta[6]         6.1e+00  7.3e-02     6.7   -5.7   6.5e+00    16     8504    26246     1.00
## theta[7]         1.1e+01  8.4e-02     6.8   0.92   1.0e+01    23     6537    20176     1.00
## theta[8]         8.5e+00  1.0e-01     7.8   -3.8   8.2e+00    22     5904    18221      1.0
## 
## Samples were drawn using hmc with nuts.
## For each parameter, N_Eff is a crude measure of effective sample size,
## and R_hat is the potential scale reduction factor on split chains (at 
## convergence, R_hat=1).
```

4 条马尔可夫链，19 个变量，2000 次迭代，轨迹数据如下


```r
eight_schools_fit$draws()
```

```
## # A draws_array: 2000 iterations, 4 chains, and 19 variables
## , , variable = lp__
## 
##          chain
## iteration   1   2   3   4
##         1 -42 -39 -38 -40
##         2 -37 -40 -37 -42
##         3 -40 -38 -38 -43
##         4 -39 -39 -40 -43
##         5 -38 -45 -38 -40
## 
## , , variable = mu
## 
##          chain
## iteration    1      2    3    4
##         1  9.0 -3.696  8.9  1.9
##         2  5.9 13.895  1.5 13.5
##         3  6.2  0.013  4.2  1.5
##         4 12.0  2.365 10.6 15.5
##         5  5.8 -7.633  5.2 12.2
## 
## , , variable = tau
## 
##          chain
## iteration    1    2     3     4
##         1 3.20 10.3  7.93  4.11
##         2 9.70  1.9 10.70  0.65
##         3 0.38  6.3  4.31  1.18
##         4 7.19  9.2  0.43 11.03
##         5 4.06  5.6  3.36  8.74
## 
## , , variable = eta[1]
## 
##          chain
## iteration     1     2     3     4
##         1  1.10  1.72  1.23  1.10
##         2 -0.30 -0.98  1.19 -0.74
##         3 -0.31  1.28  0.34 -0.85
##         4  0.97  1.53 -0.86  2.02
##         5  1.04  0.75  1.46  1.24
## 
## # ... with 1995 more iterations, and 15 more variables
```

提取参数 $\mu$ 的四条迭代点列


```r
eight_schools_fit$draws("mu")
```

```
## # A draws_array: 2000 iterations, 4 chains, and 1 variables
## , , variable = mu
## 
##          chain
## iteration    1      2    3    4
##         1  9.0 -3.696  8.9  1.9
##         2  5.9 13.895  1.5 13.5
##         3  6.2  0.013  4.2  1.5
##         4 12.0  2.365 10.6 15.5
##         5  5.8 -7.633  5.2 12.2
## 
## # ... with 1995 more iterations
```

`eight_schools_fit` 是一个 R6 对象，包含整个模型信息


```r
class(eight_schools_fit)
```

```
## [1] "CmdStanMCMC" "CmdStanFit"  "R6"
```

```r
str(eight_schools_fit)
```

```
## Classes 'CmdStanMCMC', 'CmdStanFit', 'R6' <CmdStanMCMC>
##   Inherits from: <CmdStanFit>
##   Public:
##     clone: function (deep = FALSE) 
##     cmdstan_diagnose: function () 
##     cmdstan_summary: function (flags = NULL) 
##     data_file: function () 
##     draws: function (variables = NULL, inc_warmup = FALSE, format = getOption("cmdstanr_draws_format", 
##     init: function () 
##     initialize: function (runset) 
##     inv_metric: function (matrix = TRUE) 
##     latent_dynamics_files: function (include_failed = FALSE) 
##     loo: function (variables = "log_lik", r_eff = TRUE, ...) 
##     lp: function () 
##     metadata: function () 
##     num_chains: function () 
##     num_procs: function () 
##     output: function (id = NULL) 
##     output_files: function (include_failed = FALSE) 
##     print: function (variables = NULL, ..., digits = 2, max_rows = getOption("cmdstanr_max_rows", 
##     profile_files: function (include_failed = FALSE) 
##     profiles: function () 
##     return_codes: function () 
##     runset: CmdStanRun, R6
##     sampler_diagnostics: function (inc_warmup = FALSE, format = getOption("cmdstanr_draws_format", 
##     save_data_file: function (dir = ".", basename = NULL, timestamp = TRUE, random = TRUE) 
##     save_latent_dynamics_files: function (dir = ".", basename = NULL, timestamp = TRUE, random = TRUE) 
##     save_object: function (file, ...) 
##     save_output_files: function (dir = ".", basename = NULL, timestamp = TRUE, random = TRUE) 
##     save_profile_files: function (dir = ".", basename = NULL, timestamp = TRUE, random = TRUE) 
##     summary: function (variables = NULL, ...) 
##     time: function () 
##   Private:
##     draws_: -42.0125 -37.337 -40.2068 -38.9824 -38.4394 -38.7721 -35 ...
##     init_: NULL
##     inv_metric_: list
##     metadata_: list
##     read_csv_: function (variables = NULL, sampler_diagnostics = NULL, format = getOption("cmdstanr_draws_format", 
##     sampler_diagnostics_: 3 3 4 3 4 3 3 3 3 3 2 3 3 3 3 3 4 3 3 3 3 2 3 3 3 3 3 3  ...
##     warmup_draws_: NULL
##     warmup_sampler_diagnostics_: NULL
```

模型诊断：查看迭代点列的平稳性


```r
mcmc_dens(eight_schools_fit$draws(c("mu")))
```



\begin{center}\includegraphics{bayesian-models_files/figure-latex/mu-iteration-1} \end{center}

分层线性模型之生长曲线模型 [@Gelfand_1990_JASA]

### rats 数据 {#subsec-rats}

贝叶斯分层图


```r
# 数据准备
# modified code from https://github.com/stan-dev/example-models/tree/master/bugs_examples/vol1/rats
N <- 30
T <- 5
y <- structure(c(
  151, 145, 147, 155, 135, 159, 141, 159, 177, 134,
  160, 143, 154, 171, 163, 160, 142, 156, 157, 152, 154, 139, 146,
  157, 132, 160, 169, 157, 137, 153, 199, 199, 214, 200, 188, 210,
  189, 201, 236, 182, 208, 188, 200, 221, 216, 207, 187, 203, 212,
  203, 205, 190, 191, 211, 185, 207, 216, 205, 180, 200, 246, 249,
  263, 237, 230, 252, 231, 248, 285, 220, 261, 220, 244, 270, 242,
  248, 234, 243, 259, 246, 253, 225, 229, 250, 237, 257, 261, 248,
  219, 244, 283, 293, 312, 272, 280, 298, 275, 297, 350, 260, 313,
  273, 289, 326, 281, 288, 280, 283, 307, 286, 298, 267, 272, 285,
  286, 303, 295, 289, 258, 286, 320, 354, 328, 297, 323, 331, 305,
  338, 376, 296, 352, 314, 325, 358, 312, 324, 316, 317, 336, 321,
  334, 302, 302, 323, 331, 345, 333, 316, 291, 324
), .Dim = c(30, 5))
x <- c(8.0, 15.0, 22.0, 29.0, 36.0)
xbar <- 22.0


# 模型参数设置
chains <- 4
iter <- 1000

init <- rep(list(list(
  alpha = rep(250, 30), beta = rep(6, 30),
  alpha_c = 150, beta_c = 10,
  tausq_c = 1, tausq_alpha = 1,
  tausq_beta = 1
)), chains)
```


```r
mod <- cmdstan_model(stan_file = "code/rats.stan")

rats_fit <- mod$sample(
  data = list(N = N, T = T, y = y, x = x, xbar = xbar),
  init = init,
  iter_warmup = 1000, # 每条链预处理迭代次数
  iter_sampling = 2000, # 每条链总迭代次数
  chains = chains, # 马尔科夫链的数目
  parallel_chains = 1, # 指定 CPU 核心数，可以给每条链分配一个
  show_messages = FALSE, # 不显示迭代的中间过程
  refresh = 0, # 不显示采样的进度
  seed = 20190425 # 设置随机数种子，不要使用 set.seed() 函数
)
```

```
## Running MCMC with 4 sequential chains...
## 
## Chain 1 finished in 0.6 seconds.
## Chain 2 finished in 0.7 seconds.
## Chain 3 finished in 0.7 seconds.
## Chain 4 finished in 0.6 seconds.
## 
## All 4 chains finished successfully.
## Mean chain execution time: 0.6 seconds.
## Total execution time: 2.7 seconds.
```

## 非线性模型 {#sec-nlm-gp}

高斯过程

### mcycle 数据 {#subsec-mcycle}


```r
library(MASS)
library(ggplot2)
```


```r
ggplot(data = mcycle, aes(x = times, y= accel)) +
  geom_point() +
  # geom_smooth() +
  labs(x = "Times (ms)", y = "Acceleration (g)") +
  theme_minimal()
```



\begin{center}\includegraphics{bayesian-models_files/figure-latex/unnamed-chunk-23-1} \end{center}
