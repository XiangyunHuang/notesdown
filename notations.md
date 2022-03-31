# 符号说明 {#chap-notations}

> Fabio Mulazzani: I need to obtain all the 9.somethingExp157 permutations that can be given from the numbers from 1 to 100.
>
> Ted Harding: To an adequate approximation there are 10^158^ of them. Simply to obtain them all (at a rate of 10^10^ per second, which is faster than the CPU frequency of most desktop computers) would take 10^148^ seconds, or slightly longer than $3\times 10^{140}$ years. Current estimates of the age of the Universe are of the order of $1.5\times 10^{10}$ years, so the Universe will have to last about $2\times 10^{130}$ times as long as it has already existed, before the task could be finished.
>
> So: why do you want to do this?
>
> --- Fabio Mulazzani and Ted Harding [^fabio-note]

[^fabio-note]: <https://stat.ethz.ch/pipermail/r-help/2008-November/180820.html>

数学符号约定参考花书 <https://github.com/goodfeli/dlbook_notation>

[Flexible Imputation of Missing Data](https://github.com/stefvanbuuren/fimdbook) 的 [符号约定章节](https://stefvanbuuren.name/fimd/symbol-description.html)

> 矩阵、向量用粗体大写表示，特殊情况下，Y 只有一列

$$
\mathsf{Y} = \mathbf{\mathsf{X}}\beta + \epsilon
$$

Y 叫做因变量或者响应变量 response variables，X 叫做自变量、协变量 covariate 或者预报变量 predictor variables


线性回归模型

$$y = X \beta + \epsilon$$ 其中 $y$ 是 $n \times 1$ 的观测向量， $X$ 为 $n \times p$ 的设计矩阵，$\beta$ 为未知参数向量，$\beta_0$ 为常数项， $\beta_1, \ldots, \beta_{p-1}$ 为回归系数， $\epsilon$ 为 $n \times 1$ 随机误差向量，其均值为 0，即 $E(\epsilon_i) = 0$

模型假设

1.  误差项方差齐性，即

    $$Var(\epsilon_i) = \sigma^2, \quad i = 1, 2, \ldots, n$$

2.  误差项彼此不相关，即

    $$Cov(\epsilon_i, \epsilon_j) = 0, \quad i \neq j,\quad i,j = 1, \ldots, n$$

线性模型中**线性**二字实质上是指 y 关于未知参数 $\beta_i$ 的关系是线性的。

$A,B,C,D$ 斜体表示普通的集合，$X,Y,Z$ 表示矩阵，$a,b,c,d$ 表示常数，$\alpha,\beta,\theta,\phi,\kappa$ 表示模型或者分布函数的参数，$\Theta$ 表示参数空间，$\mathbb{R}^{n},\mathbb{C}^{n}$ 表示特殊的 $n$ 维实（复）数域，$\mathscr{A,B,C,D}$ 表示一般的数域，$\mathcal{S,P,G}$ 分别表示随机过程、概率空间和图


Table: (\#tab:math-symbols) 数学符号表

| 符号                   | 含义                                                  | 符号                   | 含义                                                  |
|:-----------------------|:------------------------------------------------------|:-----------------------|:------------------------------------------------------|
| $\mathbf{A}$                          | 粗体                   | $\Omega$                             | 全集                                         |  
| $\mathit{A}$                          | 集合                   | $\mathbb{R,C}$                       | 实（复）数集                                 |  
| $\mathcal{A}$                         | 集族                   | $\varnothing$                        | 空集                                         | 
| $\mathsf{A}$                          | 矩阵                   | $\mathsf{A}^{-}$                     | 矩阵的广义逆                                 | 
| $\mathsf{A}^\top$                     | 矩阵转置               | $\bar{x}$                            | 平均值                                       | 
| $\mathsf{A}^{-1}$                     | 矩阵的逆               | $\vert a \vert$                      | 标量绝对值                                   | 
| $\mathsf{A}^{\star}$                  | 伴随矩阵               | $\mathop{\mathrm{diag}}(\mathsf{A})$ | 矩阵的对角                                   | 
| $\lVert \mathsf{A} \rVert_{1}$        | 矩阵的1范数            | $\mathsf{I}$                         | 单位矩阵                                     | 
| $\lVert \mathsf{A} \rVert_{2}$        | 矩阵的2范数            | $\mathsf{I}_{n}$                     | $n$ 阶单位矩阵                               |
| $\lVert \mathsf{A} \rVert_{\infty}$   | 矩阵的无穷范数         | $\mathsf{1}$                         | 全1矩阵                                      | 
| $\lVert \mathsf{X} \rVert_{1}$        | 向量的1范数            | $\mathsf{1}_{n}$                     | $n$ 阶全1矩阵                                | 
| $\lVert \mathsf{X} \rVert_{2}$        | 向量的2范数            | $\lVert \mathsf{X} \rVert_{\infty}$  | 向量的无穷范数                               | 
| $\langle\mathsf{X},\mathsf{Y}\rangle$ | 向量的内积             | $f(\mathsf{X})$                      | 随机变量的函数                               | 
| $\mathsf{X} \wedge \mathsf{Y}$        | 向量的外积             | $\nabla{\mathsf{X}}$                 | 向量微分或梯度                               |
| $\beta$                               | 模型系数               | $\theta$                             | 模型或分布参数                               | 
| $\alpha$                              | 模型截距               | $\Theta$                             | 参数空间                                     |
| $\hat{\beta}_{ls}$                    | 模型系数的LS估计       | $f(x)$                               | 标量值函数                                   |
| $\hat{\beta}_{mle}$                   | 模型系数的MLE估计      | $f(\mathsf{X})$                      | 向量的函数                                   |
| $\hat{\beta}_{bayes}$                 | 模型系数的Bayes估计    | $\mathcal{X}$                        | 概率空间                                       |
| $\rho$                                | 相关系数               | $\kappa$                             | 贝塞尔函数的阶                                 |    
| $\phi$                                | 尺度参数               | $u$                                  | 距离 $\lVert \mathsf{x}_1 -\mathsf{x}_2\rVert$ |
| $\mathbb{R}^2$                        | 二维实数域             | $S(x)$                               | 空间过程                                       |
| $\mathcal{S}$                         | $\mathcal{S} = \{S(x):x \in \mathbb{R}^2\}$ | $\mathcal{S}^{\star}$     | 随机过程 $\mathcal{S}$ 的近似        |
| $\triangleq$                          | 定义为或记为                         | $\hat{\beta}_{ridge}$  | $\beta$ 的岭回归估计                                  |
| $A \geq 0$                            | 矩阵 A 半正定                        | $\hat{\beta}_{lar}$    | $\beta$ 的最小角回归估计                              |
| $A > 0$                               | 矩阵 A 正定                          | $\hat{\beta}_{subset}$ | $\beta$ 的最优子集回归估计                            |
| $A\otimes B$                          | 矩阵 A 与 B 的 Kronecher 积          | MSE 均方误差           | $\frac{1}{n}\sum_{i=1}^{n}(y_i - \hat{y_i})^2$        |
| $\mathcal{M}(A)$                      | 矩阵 A 的列向量张成的子空间          | RMSE 均方根误差        | $\sqrt{\frac{1}{n}\sum_{i=1}^{n}(y_i - \hat{y_i})^2}$ |
| $\|A\|$                               | 矩阵 A 的范数                        | MAE 平均绝对误差       | $\frac{1}{n}\sum_{i=1}^{n}|y_i-\hat{y_i}|$            |
| $|A|$                                 | 矩阵 A 的行列式                      | LSE                    | 最小二乘估计                                          |
| $rk(A)$                               | 矩阵 A 的秩                          | BLUE                   | 最佳线性无偏估计                                      |
| $tr(A)$                               | 方阵 A 的迹                          | MVUE                   | 最小方差无偏估计                                      |
| $A^{-1}$                              | 矩阵 A 的逆                          | UMVUE                  | 一致最小方差无偏估计                                  |
| $A^{-}$                               | 矩阵 A 的广义逆                      | MINQUE                 | 最小范数二次无偏估计                                  |
| $\hat{\beta}_{ols}$                   | $\beta$ 的普通最小二乘估计           | OLS                    | 普通最小二乘估计                                      |
| $\hat{\beta}_{pca}$                   | $\beta$ 的主成分分析估计             | PLS                    | 偏最小二乘估计                                        |
| $\hat{\beta}_{pls}$                   | $\beta$ 的偏最小二乘估计             | GLS                    | 广义最小二乘估计                                      |
| $\hat{\beta}_{svm}$                   | $\beta$ 的支持向量机估计             | WLS                    | 带权最小二乘估计                                      |
| $\hat{\beta}_{lasso}$                 | $\beta$ 的 Lasso 估计                |  -                     | -                                                     |

多元统计分析 高惠璇 矩阵符号表示，深度学习符号表示 <https://github.com/XiangyunHuang/dlbook>

举例，线性模型的表示，此处 $Y$ 为 $n\times 1$列向量，$X$ 为$p\times n$的矩阵，$\beta$ 为 $p\times 1$的列向量 ，$\epsilon$ 为$n\times1$列向量 $$Y = X'\beta + \epsilon$$ $$\mathsf{A} = \varGamma^\top\Lambda\varGamma$$ $$\mathsf{u} = (u_1,u_2,\cdots,u_n)$$ $$\mathsf{x} = (x_1,x_2,\cdots,x_n)$$ 期望 $\mathsf{E}$ 正态分布 $\mathcal{N}(\mathsf{x};\mu,\Sigma)$ 对数 $\mathsf{\log}$ 协方差 $\mathsf{Cov},\mathsf{Var}$

矩阵 $$\mathsf{Y} = (\mathsf{y}^{(1)},\mathsf{y}^{(n)},\cdots,\mathsf{y}^{(n)})$$ 其中 $\mathsf{y}^{(i)} = (y_{1i},y_{2i},\cdots,y_{ni})$ 表示第 $i$ 列

梅隆函数(Matern function)是描述空间相关性的常用函数，它带有两参数$\kappa$ 和 $\phi$，具体形式如下： $$\rho(u) = \big\{2^{\kappa-1}\Gamma(\kappa)\big\}^{-1}(u/\phi)^{\kappa}K_{\kappa}(u/\phi)$$ 其中，$K_{\kappa}(\cdot)$ 表示 $\kappa$ 阶修正的贝塞尔函数
