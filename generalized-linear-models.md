# 广义线性模型 {#chap:generalized-linear-models}



> It's not meant for sampling weights. It's meant for precision weights. How best to include sampling weights in mixed models is a research problem at the moment, but you can rely on getting the wrong answer if you just use the `weights =` argument.
> 
>   --- Thomas Lumley [^TL-help-2012]

[^TL-help-2012]: <https://stat.ethz.ch/pipermail/r-help/2012-January/301501.html>


<!-- 每个模型都给出 rstan/rstanarm 中的实现方式，或者另起一章在贝叶斯模型中 -->

一般广义线性模型理论参考文献 An Introduction to Generalized Linear Models [@Dobson_2018_Generalized] 和 Generalized Linear Models [@McCullagh_1989_Generalized]，逻辑回归模型主要参考 Applied Logistic Regression [@David_2000_Logistic] 和 Discrete Choice Methods with Simulation [@Train_2009_mlogit]。


简单线性模型（Linear Models，简称 LM），`stats::lm()` 函数可以拟合线性模型，而一般线性模型（General Linear Models，简称 GLM）允许线性模型方差非齐性、存在相关关系，甚至可以扩展到线性混合效应模型，将线性回归模型，方差分析模型，协方差分析模型统一地看待，一般要采用广义最小二乘（Generalized Least Squares，简称 GLS）拟合， `nlme::gls()` 函数实现广义最小二乘拟合线性模型，类似地，`nlme::gnls()` 函数实现广义最小二乘拟合非线性模型。`glm2::glm2()` 补充 `glm()`，提供更加稳定的拟合方法，适应于 `glm()` 不收敛的情况，而 `fastglm::fastglm()` 主要是加快 `glm()` 求解效率，收敛效果也比 `glm()` 和 `glm2()` 好。


[glmnet](https://CRAN.R-project.org/package=glmnet) 包是处理广义线性模型的事实标准。 其官网见 <https://glmnet.stanford.edu/>，而 [glmnetUtils](https://github.com/hongooi73/glmnetUtils) 补充公式接口，适用于弹性网络回归，交叉验证筛选 $\alpha$ 参数等。 [glmpath](https://CRAN.R-project.org/package=glmpath) 包实现 path-following 算法用于带 L1 正则项的广义线性模型和 Cox 比例风险模型。[Boom](https://github.com/steve-the-bayesian/BOOM) 和 **BoomSpikeSlab** 包实现 MCMC 算法用于 Spike 和 Slab 回归，而 **spikeslab** 包进一步实现预测和变量选择 [@spikeslab_2005_Ishwaran]。[Cyclops](https://github.com/OHDSI/Cyclops) 包实现 Cyclic coordinate descent 算法 用于逻辑回归、泊松回归和生存分析，适用于大规模正则回归 large scale regularized regressions，达到百万级别的观测和特征变量，交叉验证自动选择超参数，独立变量稀疏表示，用剖面似然估计某个变量的置信区间。[plsRglm](https://github.com/fbertran/plsRglm) 包实现偏最小二乘回归方法用于广义线性模型。**biglm**、[speedglm](https://cran.r-project.org/package=speedglm) 和 [bigReg](https://CRAN.R-project.org/package=bigReg) 用于处理大数据集的回归，求解限制内存的 GLM [biglmm](https://CRAN.R-project.org/package=biglmm)。[cglm](https://CRAN.R-project.org/package=cglm) 估计带聚类数据的条件 GLM 的回归系数和发散参数。[MGLM](https://CRAN.R-project.org/package=MGLM) 拟合多个响应变量的广义线性回归模型（多重 GLM ）。[robmixglm](https://CRAN.R-project.org/package=robmixglm) 响应变量扩展到混合分布的情形，实现稳健 GLM 回归估计。[ClusterBootstrap](https://CRAN.R-project.org/package=ClusterBootstrap) 实现自主法估计带聚类数据的 GLM。[lcpm](https://CRAN.R-project.org/package=lcpm) 和 [oglmx](https://CRAN.R-project.org/package=oglmx) 处理有序输出的回归。
[gmnl](https://cran.r-project.org/package=gmnl)、 [mlogit](https://CRAN.R-project.org/package=mlogit) [@Train_2009_mlogit] 和 **mnlogit** [@mnlogit_2016_JSS] 处理多项逻辑回归。[pscl](https://github.com/atahk/pscl) 包（Political Science Computational Laboratory）可以处理贝叶斯 IRT 模型，zero-inflated 零膨胀模型，广义线性模型的拟合优度度量。


<!--
贝叶斯变量选择方法的综述 <http://www3.stat.sinica.edu.tw/statistica/oldpdf/A7n26.pdf>，17 种分类算法应用于信用评分 <https://www.datascience-zing.com/blog/implemetation-of-17-classification-algorithms-in-r-using-car-evaluation-data> 数据和代码 <https://github.com/surajvv12/17_Classification> 数据集来源于  [UCI Machine learning repository](https://archive.ics.uci.edu/ml)
-->

## 介绍 {#sec:glm-introduction}

模型结构，模型种类，参数估计办法，相当于综述

响应变量分别服从二项分布、多项分布、对数正态分布、泊松分布、伽马分布


## 理论基础 {#sec:glm-theory}

分两个段落分别介绍指数族和 GLM 

$$
f(y;\theta,\phi) = \exp[(a(y) b(\theta) + c(\theta))/f(\phi) + d(y,\phi)]
$$

泊松分布 (with $\lambda \to \theta$, $x \to y$) ($\phi=1$):


\begin{equation}
\begin{split}
f(y,\theta) & = \exp(-\theta) \theta^y/(y!) \\
            & = \exp\left( \underbrace{y}_{a(y)} 
                           \underbrace{\log \theta}_{b(\theta)} + 
                           \underbrace{(-\theta)}_{c(\theta)} + 
                           \underbrace{(- \log(y!))}_{d(y)} \right)
\end{split}
\end{equation}


<!-- 如果能以非常直观的几何展示方式表现高深的高维模型和算法理论，将是非常有意义的 -->

### 岭回归 {#subsec:glm-ridge}

Geometry and properties of generalized ridge regression in high dimensions <http://web.ccs.miami.edu/~hishwaran/papers/IR.conmath2014.pdf>

这篇文章借助三维几何图形展示高维情形下的广义岭回归


### Lasso {#subsec:glm-lasso}

glmnet: Lasso and Elastic-Net Regularized Generalized Linear Models <https://glmnet.stanford.edu>

### 最优子集回归 {#subset:glm-best-subset}

bestglm: Best Subset GLM and Regression Utilities

### 偏最小二乘回归 {#subsec:glm-pls}

[pls](https://github.com/bhmevik/pls) 包 [@JSS_2007_pls] 实现了偏最小二乘回归（partial least squares regression， PLS）和主成分回归 （principal component regression， PCR），详见主页 <https://mevik.net/work/software/pls.html>
帮助文档的质量较高，是比较完整全面的。

- several algorithms: the traditional orthogonal scores (NIPALS) PLS algorithm, kernel PLS, wide kernel PLS, Simpls and PCR through svd
- supports multi-response models (aka PLS2)
- flexible cross-validation
- Jackknife variance estimates of regression coefficients
- extensive and flexible plots: scores, loadings, predictions, coefficients, (R)MSEP, R², correlation loadings 
- formula interface, modelled after lm(), with methods for predict, print, summary, plot, update, etc.
- extraction functions for coefficients, scores and loadings 
- MSEP, RMSEP and R² estimates
- multiplicative scatter correction (MSC)



## 吸烟喝酒和食道癌的关系 {#sec:alcohol}

存在有序分类数据

酒精的作用 effects of alcohol, tobacco and interaction, age-adjusted
数据集描述见 `help(esoph)`


```r
head(esoph)
```

```
##   agegp     alcgp    tobgp ncases ncontrols
## 1 25-34 0-39g/day 0-9g/day      0        40
## 2 25-34 0-39g/day    10-19      0        10
## 3 25-34 0-39g/day    20-29      0         6
## 4 25-34 0-39g/day      30+      0         5
## 5 25-34     40-79 0-9g/day      0        27
## 6 25-34     40-79    10-19      0         7
```

```r
str(esoph)
```

```
## 'data.frame':	88 obs. of  5 variables:
##  $ agegp    : Ord.factor w/ 6 levels "25-34"<"35-44"<..: 1 1 1 1 1 1 1 1 1 1 ...
##  $ alcgp    : Ord.factor w/ 4 levels "0-39g/day"<"40-79"<..: 1 1 1 1 2 2 2 2 3 3 ...
##  $ tobgp    : Ord.factor w/ 4 levels "0-9g/day"<"10-19"<..: 1 2 3 4 1 2 3 4 1 2 ...
##  $ ncases   : num  0 0 0 0 0 0 0 0 0 0 ...
##  $ ncontrols: num  40 10 6 5 27 7 4 7 2 1 ...
```


```r
p1 <- ggplot(data = esoph, aes(x = agegp, y = ncases / ncontrols, color = agegp)) +
  geom_boxplot(show.legend = FALSE) +
  geom_jitter(show.legend = FALSE) +
  theme_minimal()

p2 <- ggplot(data = esoph, aes(x = alcgp, y = ncases / ncontrols, color = alcgp)) +
  geom_boxplot(show.legend = FALSE) +
  geom_jitter(show.legend = FALSE) +
  theme_minimal()

p3 <- ggplot(data = esoph, aes(x = tobgp, y = ncases / ncontrols, color = tobgp)) +
  geom_boxplot(show.legend = FALSE) +
  geom_jitter(show.legend = FALSE) +
  theme_minimal()

bottom_row <- plot_grid(p2, p3, labels = c('B', 'C'), label_size = 12)
```

```
## Warning: Removed 12 rows containing non-finite values (stat_boxplot).
```

```
## Warning: Removed 12 rows containing missing values (geom_point).
```

```
## Warning: Removed 12 rows containing non-finite values (stat_boxplot).
```

```
## Warning: Removed 12 rows containing missing values (geom_point).
```

```r
plot_grid(p1, bottom_row, labels = c('A', ''), label_size = 12, ncol = 1)
```

```
## Warning: Removed 12 rows containing non-finite values (stat_boxplot).

## Warning: Removed 12 rows containing missing values (geom_point).
```

<div class="figure" style="text-align: center">
<img src="generalized-linear-models_files/figure-html/esoph-data-1.png" alt="吸烟喝酒和食道癌的关系" width="672" />
<p class="caption">(\#fig:esoph-data)吸烟喝酒和食道癌的关系</p>
</div>



```r
fit_esoph_glm <- glm(cbind(ncases, ncontrols) ~ agegp + tobgp * alcgp,
  data = esoph, family = binomial(link = "logit")
)
```



```r
library(Rcpp)
fit_esoph_brm <- brms::brm(ncases | trials(ncases + ncontrols) ~ agegp + tobgp * alcgp,
  data = esoph, family = binomial(link = "logit"), refresh = 0
)
```

## 自然流产和人工流产后的不育 {#sec:infert}

`help(infert)`


```r
head(infert)
```

```
##   education age parity induced case spontaneous stratum pooled.stratum
## 1    0-5yrs  26      6       1    1           2       1              3
## 2    0-5yrs  42      1       1    1           0       2              1
## 3    0-5yrs  39      6       2    1           0       3              4
## 4    0-5yrs  34      4       2    1           0       4              2
## 5   6-11yrs  35      3       1    1           1       5             32
## 6   6-11yrs  36      4       2    1           1       6             36
```

```r
str(infert)
```

```
## 'data.frame':	248 obs. of  8 variables:
##  $ education     : Factor w/ 3 levels "0-5yrs","6-11yrs",..: 1 1 1 1 2 2 2 2 2 2 ...
##  $ age           : num  26 42 39 34 35 36 23 32 21 28 ...
##  $ parity        : num  6 1 6 4 3 4 1 2 1 2 ...
##  $ induced       : num  1 1 2 2 1 2 0 0 0 0 ...
##  $ case          : num  1 1 1 1 1 1 1 1 1 1 ...
##  $ spontaneous   : num  2 0 0 0 1 1 0 0 1 0 ...
##  $ stratum       : int  1 2 3 4 5 6 7 8 9 10 ...
##  $ pooled.stratum: num  3 1 4 2 32 36 6 22 5 19 ...
```


存在无序分类变量


```r
infert_glm_1 <- glm(case ~ spontaneous + induced,
  data = infert, family = binomial()
)
summary(infert_glm_1)
```

```
## 
## Call:
## glm(formula = case ~ spontaneous + induced, family = binomial(), 
##     data = infert)
## 
## Deviance Residuals: 
##     Min       1Q   Median       3Q      Max  
## -1.6678  -0.8360  -0.5772   0.9030   1.9362  
## 
## Coefficients:
##             Estimate Std. Error z value Pr(>|z|)    
## (Intercept)  -1.7079     0.2677  -6.380 1.78e-10 ***
## spontaneous   1.1972     0.2116   5.657 1.54e-08 ***
## induced       0.4181     0.2056   2.033    0.042 *  
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## (Dispersion parameter for binomial family taken to be 1)
## 
##     Null deviance: 316.17  on 247  degrees of freedom
## Residual deviance: 279.61  on 245  degrees of freedom
## AIC: 285.61
## 
## Number of Fisher Scoring iterations: 4
```

考虑其他潜在的因素


```r
infert_glm_2 <- glm(case ~ age + parity + education + spontaneous + induced,
  data = infert, family = binomial()
)
summary(infert_glm_2)
```

```
## 
## Call:
## glm(formula = case ~ age + parity + education + spontaneous + 
##     induced, family = binomial(), data = infert)
## 
## Deviance Residuals: 
##     Min       1Q   Median       3Q      Max  
## -1.7603  -0.8162  -0.4956   0.8349   2.6536  
## 
## Coefficients:
##                  Estimate Std. Error z value Pr(>|z|)    
## (Intercept)      -1.14924    1.41220  -0.814   0.4158    
## age               0.03958    0.03120   1.269   0.2046    
## parity           -0.82828    0.19649  -4.215 2.49e-05 ***
## education6-11yrs -1.04424    0.79255  -1.318   0.1876    
## education12+ yrs -1.40321    0.83416  -1.682   0.0925 .  
## spontaneous       2.04591    0.31016   6.596 4.21e-11 ***
## induced           1.28876    0.30146   4.275 1.91e-05 ***
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## (Dispersion parameter for binomial family taken to be 1)
## 
##     Null deviance: 316.17  on 247  degrees of freedom
## Residual deviance: 257.80  on 241  degrees of freedom
## AIC: 271.8
## 
## Number of Fisher Scoring iterations: 4
```

实际上应该使用条件逻辑回归， 调用 **survival** 包


```r
library(survival)
infert_glm_3 <- clogit(case ~ spontaneous + induced + strata(stratum),
  data = infert
)
summary(infert_glm_3)
```

```
## Call:
## coxph(formula = Surv(rep(1, 248L), case) ~ spontaneous + induced + 
##     strata(stratum), data = infert, method = "exact")
## 
##   n= 248, number of events= 83 
## 
##               coef exp(coef) se(coef)     z Pr(>|z|)    
## spontaneous 1.9859    7.2854   0.3524 5.635 1.75e-08 ***
## induced     1.4090    4.0919   0.3607 3.906 9.38e-05 ***
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
##             exp(coef) exp(-coef) lower .95 upper .95
## spontaneous     7.285     0.1373     3.651    14.536
## induced         4.092     0.2444     2.018     8.298
## 
## Concordance= 0.776  (se = 0.044 )
## Likelihood ratio test= 53.15  on 2 df,   p=3e-12
## Wald test            = 31.84  on 2 df,   p=1e-07
## Score (logrank) test = 48.44  on 2 df,   p=3e-11
```

## 细菌数据集 {#sec:australia-bacteria}

流感嗜血杆菌的细菌与中耳炎患儿


```r
data(bacteria, package = "MASS")
```



```r
# 惩罚拟似然
fit_glmmpql <- MASS::glmmPQL(y ~ trt + I(week > 2),
  random = ~ 1 | ID, verbose = FALSE,
  family = binomial, data = bacteria
)
summary(fit_glmmpql)
```

```
## Linear mixed-effects model fit by maximum likelihood
##   Data: bacteria 
##   AIC BIC logLik
##    NA  NA     NA
## 
## Random effects:
##  Formula: ~1 | ID
##         (Intercept)  Residual
## StdDev:    1.410637 0.7800511
## 
## Variance function:
##  Structure: fixed weights
##  Formula: ~invwt 
## Fixed effects:  y ~ trt + I(week > 2) 
##                     Value Std.Error  DF   t-value p-value
## (Intercept)      3.412014 0.5185033 169  6.580506  0.0000
## trtdrug         -1.247355 0.6440635  47 -1.936696  0.0588
## trtdrug+        -0.754327 0.6453978  47 -1.168779  0.2484
## I(week > 2)TRUE -1.607257 0.3583379 169 -4.485311  0.0000
##  Correlation: 
##                 (Intr) trtdrg trtdr+
## trtdrug         -0.598              
## trtdrug+        -0.571  0.460       
## I(week > 2)TRUE -0.537  0.047 -0.001
## 
## Standardized Within-Group Residuals:
##        Min         Q1        Med         Q3        Max 
## -5.1985361  0.1572336  0.3513075  0.4949482  1.7448845 
## 
## Number of Observations: 220
## Number of Groups: 50
```



```r
# 拉普拉斯近似
fit_glmer <- lme4::glmer(y ~ trt + I(week > 2) + (1 | ID),
  family = binomial, data = bacteria
)
summary(fit_glmer)
```

```
## Generalized linear mixed model fit by maximum likelihood (Laplace
##   Approximation) [glmerMod]
##  Family: binomial  ( logit )
## Formula: y ~ trt + I(week > 2) + (1 | ID)
##    Data: bacteria
## 
##      AIC      BIC   logLik deviance df.resid 
##    202.3    219.2    -96.1    192.3      215 
## 
## Scaled residuals: 
##     Min      1Q  Median      3Q     Max 
## -4.5615  0.1359  0.3022  0.4217  1.1276 
## 
## Random effects:
##  Groups Name        Variance Std.Dev.
##  ID     (Intercept) 1.543    1.242   
## Number of obs: 220, groups:  ID, 50
## 
## Fixed effects:
##                 Estimate Std. Error z value Pr(>|z|)    
## (Intercept)       3.5479     0.6958   5.099 3.41e-07 ***
## trtdrug          -1.3667     0.6770  -2.019 0.043516 *  
## trtdrug+         -0.7826     0.6831  -1.146 0.251926    
## I(week > 2)TRUE  -1.5985     0.4759  -3.359 0.000783 ***
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Correlation of Fixed Effects:
##             (Intr) trtdrg trtdr+
## trtdrug     -0.593              
## trtdrug+    -0.537  0.487       
## I(wk>2)TRUE -0.656  0.126  0.064
```


## 研究婴儿出生体重低的相关危险因素 {#sec:birthwt}

<!-- 多项逻辑回归模型 Multinomial-Logistic-Regression-Models -->

在线性回归的基础上，响应变量是离散的类别，且无序 [@mnlogit_2016_JSS]



birthwt 数据是 1986 年在马萨诸塞州斯普林菲尔德的 Baystate 医疗中心收集的，用于研究婴儿出生体重低的相关危险因素


```r
# 加载数据
# library(MASS)
data(birthwt, package = "MASS")
# 查看 birthwt 数据集 `help(birthwt)`
head(birthwt)
```

```
##    low age lwt race smoke ptl ht ui ftv  bwt
## 85   0  19 182    2     0   0  0  1   0 2523
## 86   0  33 155    3     0   0  0  0   3 2551
## 87   0  20 105    1     1   0  0  0   1 2557
## 88   0  21 108    1     1   0  0  1   2 2594
## 89   0  18 107    1     1   0  0  1   0 2600
## 91   0  21 124    3     0   0  0  0   0 2622
```

```r
str(birthwt)
```

```
## 'data.frame':	189 obs. of  10 variables:
##  $ low  : int  0 0 0 0 0 0 0 0 0 0 ...
##  $ age  : int  19 33 20 21 18 21 22 17 29 26 ...
##  $ lwt  : int  182 155 105 108 107 124 118 103 123 113 ...
##  $ race : int  2 3 1 1 1 3 1 3 1 1 ...
##  $ smoke: int  0 0 1 1 1 0 0 0 1 1 ...
##  $ ptl  : int  0 0 0 0 0 0 0 0 0 0 ...
##  $ ht   : int  0 0 0 0 0 0 0 0 0 0 ...
##  $ ui   : int  1 0 0 1 1 0 0 0 0 0 ...
##  $ ftv  : int  0 3 1 2 0 0 1 1 1 0 ...
##  $ bwt  : int  2523 2551 2557 2594 2600 2622 2637 2637 2663 2665 ...
```

`low` 表示婴儿出生体重小于 2.5kg，`age` 表示母亲的年龄（年），`lwt` 母亲最后一次月经期间的体重(磅)，`race` 母亲的种族(1 =白人，2 =黑人，3 =其他)。，`smoke` 怀孕期间的吸烟状况，`ptl` 以前早产的次数，`ht` 高血压病史，`ui` 子宫过敏，`ftv` 妊娠头三个月的医生就诊次数，`bwt` 出生体重（克） 


```r
with(birthwt, tapply(lwt, ui, var))
```

```
##        0        1 
## 940.8472 783.7196
```

```r
t.test(lwt ~ ui, data = birthwt, var.equal = TRUE)
```

```
## 
## 	Two Sample t-test
## 
## data:  lwt by ui
## t = 2.1138, df = 187, p-value = 0.03586
## alternative hypothesis: true difference in means between group 0 and group 1 is not equal to 0
## 95 percent confidence interval:
##   0.8753389 25.3544748
## sample estimates:
## mean in group 0 mean in group 1 
##        131.7578        118.6429
```

```r
t.test(lwt ~ ui, data = birthwt)
```

```
## 
## 	Welch Two Sample t-test
## 
## data:  lwt by ui
## t = 2.2547, df = 39.163, p-value = 0.02982
## alternative hypothesis: true difference in means between group 0 and group 1 is not equal to 0
## 95 percent confidence interval:
##   1.351128 24.878685
## sample estimates:
## mean in group 0 mean in group 1 
##        131.7578        118.6429
```



```r
# birthwt$ui <- as.factor(birthwt$ui)
# library(lattice)
# bwplot(lwt ~ ui, data = birthwt, pch = "|")

boxplot(lwt ~ ui, data = birthwt)
```

<img src="generalized-linear-models_files/figure-html/unnamed-chunk-11-1.png" width="672" style="display: block; margin: auto;" />


```r
# 重新编码，数据预处理，方便代入模型
bwt <- with(birthwt, {
  race <- factor(race, labels = c("white", "black", "other"))
  ptd <- factor(ptl > 0)
  ftv <- factor(ftv)
  levels(ftv)[-(1:2)] <- "2+" # 除了前两个水平外，其余的都编码为 2+
  data.frame(
    low = factor(low), age, lwt, race, smoke = (smoke > 0),
    ptd, ht = (ht > 0), ui = (ui > 0), ftv
  )
})
```



```r
# 查看编码后的数据
head(bwt)
```

```
##   low age lwt  race smoke   ptd    ht    ui ftv
## 1   0  19 182 black FALSE FALSE FALSE  TRUE   0
## 2   0  33 155 other FALSE FALSE FALSE FALSE  2+
## 3   0  20 105 white  TRUE FALSE FALSE FALSE   1
## 4   0  21 108 white  TRUE FALSE FALSE  TRUE  2+
## 5   0  18 107 white  TRUE FALSE FALSE  TRUE   0
## 6   0  21 124 other FALSE FALSE FALSE FALSE   0
```

```r
str(bwt)
```

```
## 'data.frame':	189 obs. of  9 variables:
##  $ low  : Factor w/ 2 levels "0","1": 1 1 1 1 1 1 1 1 1 1 ...
##  $ age  : int  19 33 20 21 18 21 22 17 29 26 ...
##  $ lwt  : int  182 155 105 108 107 124 118 103 123 113 ...
##  $ race : Factor w/ 3 levels "white","black",..: 2 3 1 1 1 3 1 3 1 1 ...
##  $ smoke: logi  FALSE FALSE TRUE TRUE TRUE FALSE ...
##  $ ptd  : Factor w/ 2 levels "FALSE","TRUE": 1 1 1 1 1 1 1 1 1 1 ...
##  $ ht   : logi  FALSE FALSE FALSE FALSE FALSE FALSE ...
##  $ ui   : logi  TRUE FALSE FALSE TRUE TRUE FALSE ...
##  $ ftv  : Factor w/ 3 levels "0","1","2+": 1 3 2 3 1 1 2 2 2 1 ...
```

广义线性模型拟合，二项逻辑回归，响应变量为婴儿出生的体重，以2.5kg为界，它被编码成二分类变量 0或1


```r
options(contrasts = c("contr.treatment", "contr.poly"))
glm(formula = low ~ ., family = binomial, data = bwt)
```

```
## 
## Call:  glm(formula = low ~ ., family = binomial, data = bwt)
## 
## Coefficients:
## (Intercept)          age          lwt    raceblack    raceother    smokeTRUE  
##     0.82302     -0.03723     -0.01565      1.19241      0.74068      0.75553  
##     ptdTRUE       htTRUE       uiTRUE         ftv1        ftv2+  
##     1.34376      1.91317      0.68020     -0.43638      0.17901  
## 
## Degrees of Freedom: 188 Total (i.e. Null);  178 Residual
## Null Deviance:	    234.7 
## Residual Deviance: 195.5 	AIC: 217.5
```

多项逻辑回归


```r
library(nnet)
(bwt.mu <- multinom(formula = low ~ ., data = bwt))
```

```
## # weights:  12 (11 variable)
## initial  value 131.004817 
## iter  10 value 98.029803
## final  value 97.737759 
## converged
```

```
## Call:
## multinom(formula = low ~ ., data = bwt)
## 
## Coefficients:
## (Intercept)         age         lwt   raceblack   raceother   smokeTRUE 
##  0.82320102 -0.03723828 -0.01565359  1.19240391  0.74065606  0.75550487 
##     ptdTRUE      htTRUE      uiTRUE        ftv1       ftv2+ 
##  1.34375901  1.91320116  0.68020207 -0.43638470  0.17900392 
## 
## Residual Deviance: 195.4755 
## AIC: 217.4755
```

```r
summary(bwt.mu)
```

```
## Call:
## multinom(formula = low ~ ., data = bwt)
## 
## Coefficients:
##                  Values  Std. Err.
## (Intercept)  0.82320102 1.24476766
## age         -0.03723828 0.03870437
## lwt         -0.01565359 0.00708079
## raceblack    1.19240391 0.53598076
## raceother    0.74065606 0.46176615
## smokeTRUE    0.75550487 0.42503626
## ptdTRUE      1.34375901 0.48063449
## htTRUE       1.91320116 0.72076133
## uiTRUE       0.68020207 0.46434974
## ftv1        -0.43638470 0.47941107
## ftv2+        0.17900392 0.45639129
## 
## Residual Deviance: 195.4755 
## AIC: 217.4755
```

计算 Z 分数和 P 值


```r
z <- summary(bwt.mu)$coefficients / summary(bwt.mu)$standard.errors
z
```

```
## (Intercept)         age         lwt   raceblack   raceother   smokeTRUE 
##   0.6613291  -0.9621210  -2.2107121   2.2247140   1.6039635   1.7775069 
##     ptdTRUE      htTRUE      uiTRUE        ftv1       ftv2+ 
##   2.7958023   2.6544170   1.4648486  -0.9102516   0.3922159
```

```r
p <- (1 - pnorm(abs(z), 0, 1)) * 2
p
```

```
## (Intercept)         age         lwt   raceblack   raceother   smokeTRUE 
## 0.508401310 0.335988847 0.027055777 0.026100443 0.108722092 0.075484881 
##     ptdTRUE      htTRUE      uiTRUE        ftv1       ftv2+ 
## 0.005177106 0.007944557 0.142962228 0.362689827 0.694898695
```

> 模型解释

## 哥本哈根住房状况调查 {#sec:housing}

<!-- 有序逻辑回归模型 Ordinal-Logistic-Regression-Models -->

响应变量是离散类别，且存在强弱，等级，大小之分

调用函数 `MASS::polr()` 

数据集 housing 哥本哈根住房状况调查中的次数分布表，`Sat` 住户对目前居住环境的满意程度，是一个有序的因子变量，`Infl` 住户对物业管理的感知影响程度，`Type` 租赁住宿类型，如塔楼、中庭、公寓、露台，`Cont` 联系居民可与其他居民联系(低、高)，`Freq` 每个类中的居民人数，调查的人数


```r
data("housing", package = "MASS")
# 查看数据 help(housing)
head(housing)
```

```
##      Sat   Infl  Type Cont Freq
## 1    Low    Low Tower  Low   21
## 2 Medium    Low Tower  Low   21
## 3   High    Low Tower  Low   28
## 4    Low Medium Tower  Low   34
## 5 Medium Medium Tower  Low   22
## 6   High Medium Tower  Low   36
```

```r
str(housing)
```

```
## 'data.frame':	72 obs. of  5 variables:
##  $ Sat : Ord.factor w/ 3 levels "Low"<"Medium"<..: 1 2 3 1 2 3 1 2 3 1 ...
##  $ Infl: Factor w/ 3 levels "Low","Medium",..: 1 1 1 2 2 2 3 3 3 1 ...
##  $ Type: Factor w/ 4 levels "Tower","Apartment",..: 1 1 1 1 1 1 1 1 1 2 ...
##  $ Cont: Factor w/ 2 levels "Low","High": 1 1 1 1 1 1 1 1 1 1 ...
##  $ Freq: int  21 21 28 34 22 36 10 11 36 61 ...
```

居民对居住环境满意度 Sat 三个等级的有序回归


```r
options(contrasts = c("contr.treatment", "contr.poly"))
house.plr <- MASS::polr(Sat ~ Infl + Type + Cont, weights = Freq, data = housing)
house.plr
```

```
## Call:
## MASS::polr(formula = Sat ~ Infl + Type + Cont, data = housing, 
##     weights = Freq)
## 
## Coefficients:
##    InflMedium      InflHigh TypeApartment    TypeAtrium   TypeTerrace 
##     0.5663937     1.2888191    -0.5723501    -0.3661866    -1.0910149 
##      ContHigh 
##     0.3602841 
## 
## Intercepts:
##  Low|Medium Medium|High 
##  -0.4961353   0.6907083 
## 
## Residual Deviance: 3479.149 
## AIC: 3495.149
```

再计算一下 P 值，置信区间


```r
ctable <- coef(summary(house.plr))
p <- pnorm(abs(ctable[, "t value"]), lower.tail = FALSE) * 2
ctable <- cbind(ctable, "p value" = p)
# confidence intervals 计算置信区间
ci <- confint(house.plr)
exp(coef(house.plr))
```

```
##    InflMedium      InflHigh TypeApartment    TypeAtrium   TypeTerrace 
##     1.7619017     3.6284990     0.5641979     0.6933734     0.3358754 
##      ContHigh 
##     1.4337368
```

```r
## OR and CI
exp(cbind(OR = coef(house.plr), ci))
```

```
##                      OR     2.5 %    97.5 %
## InflMedium    1.7619017 1.4356845 2.1639915
## InflHigh      3.6284990 2.8319659 4.6626461
## TypeApartment 0.5641979 0.4462124 0.7121941
## TypeAtrium    0.6933734 0.5114084 0.9398410
## TypeTerrace   0.3358754 0.2492277 0.4514276
## ContHigh      1.4337368 1.1892931 1.7296674
```

> 模型解释

参考文档 `help(housing)` 包含泊松回归、多项回归、比例风险模型，以及 <https://www.analyticsvidhya.com/blog/2016/02/multinomial-ordinal-logistic-regression/>

> 好好看文档 `help(housing)` 和对应的参考书籍，把原理弄清楚

> 有序因子变量是如何实现编码的



## 癫痫病发作次数 {#sec:epileptics-counts}

纵向数据 [@Peter_1990_epil]，考虑了过度发散 overdispersion 异方差 heteroscedasticity 观测不独立

数据集 epil 记录癫痫发作的次数及病人的特征，下面是数据建模分析过程


```r
data(epil, package = "MASS")
fit_glm_epil <- glm(y ~ lbase * trt + lage + V4,
  family = poisson,
  data = epil
)
summary(fit_glm_epil)

fit_glmm_epil<- MASS::glmmPQL(y ~ lbase * trt + lage + V4,
  random = ~ 1 | subject,
  family = poisson, data = epil
)
summary(fit_glmm_epil)

fit_glmm_lme4 <- lme4::glmer(y ~ lbase * trt + lage + V4 + (1 | subject),
  family = poisson, data = epil
)
summary(fit_glmm_lme4)


fit_glmm_glmmtmb <- glmmTMB::glmmTMB(y ~ lbase * trt + lage + V4 + (1 | subject),
  data = epil, family = poisson, REML = TRUE
) # REML 估计
summary(fit_glmm_glmmtmb)


# https://github.com/drizopoulos/GLMMadaptive
fit_glmm_glmmadaptive <- GLMMadaptive::mixed_model(
  fixed = y ~ lbase * trt + lage + V4,
  random = ~ 1 | subject, data = epil,
  family = poisson()
)
summary(fit_glmm_glmmadaptive)
```

## 对数线性模型 {#sec:generalized-log-linear-model}

当响应变量 $Y$ 服从对数正态分布的时候，广义线性模型具化为对数线性模型，**gllm** 包 [@gllm]

## 泊松回归模型 {#sec:generalized-possion-linear-model}

加载数据


```r
data(beall.webworms, package = "agridat")
```

查看数据


```r
head(beall.webworms)
```

```
##   row col y block trt spray lead
## 1   1   1 1    B1  T1     N    N
## 2   2   1 0    B1  T1     N    N
## 3   3   1 1    B1  T1     N    N
## 4   4   1 3    B1  T1     N    N
## 5   5   1 6    B1  T1     N    N
## 6   6   1 0    B2  T1     N    N
```

描述响应变量的分布


```r
hist(beall.webworms$y, main = "Histogram of Worm Count", xlab = "Number of Worms")
```

<img src="generalized-linear-models_files/figure-html/unnamed-chunk-22-1.png" width="672" style="display: block; margin: auto;" />


```r
boxplot(y ~ trt, data = beall.webworms)
```

<img src="generalized-linear-models_files/figure-html/unnamed-chunk-23-1.png" width="672" style="display: block; margin: auto;" />

抖动图


```r
plot(y ~ trt, data = beall.webworms, xlab = "Types of Worms", ylab = "Worm Count")
```

<img src="generalized-linear-models_files/figure-html/unnamed-chunk-24-1.png" width="672" style="display: block; margin: auto;" />


```r
ggplot(beall.webworms, aes(trt, y)) +
  geom_boxplot(colour = "red") +
  geom_jitter() +
  labs(x = "Types of Worms", y = "Worm Count") +
  theme_minimal()
```

<img src="generalized-linear-models_files/figure-html/unnamed-chunk-25-1.png" width="672" style="display: block; margin: auto;" />



```r
pois.mod <- glm(y ~ trt, data = beall.webworms, family = "poisson")
summary(pois.mod)
```

```
## 
## Call:
## glm(formula = y ~ trt, family = "poisson", data = beall.webworms)
## 
## Deviance Residuals: 
##     Min       1Q   Median       3Q      Max  
## -1.6733  -1.0046  -0.9081   0.6141   4.2771  
## 
## Coefficients:
##             Estimate Std. Error z value Pr(>|z|)    
## (Intercept)  0.33647    0.04688   7.177 7.12e-13 ***
## trtT2       -1.02043    0.09108 -11.204  < 2e-16 ***
## trtT3       -0.49628    0.07621  -6.512 7.41e-11 ***
## trtT4       -1.22246    0.09829 -12.438  < 2e-16 ***
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## (Dispersion parameter for poisson family taken to be 1)
## 
##     Null deviance: 1955.9  on 1299  degrees of freedom
## Residual deviance: 1720.4  on 1296  degrees of freedom
## AIC: 3125.5
## 
## Number of Fisher Scoring iterations: 6
```

模型系数 T2 的解释，这里 GLM 使用了对数联系函数(log link function) ，因此 -1.02 是对数变换后的值，T2的系数实际是 0.3605949 ，实际意义是相对于T1，T2 类型的蠕虫数量是 T1 的 0.3605949 倍


The first valuable information is related to the residuals of the model, which should be symmetrical as for any normal linear model. From this output we can see that minimum and maximum, as well as the first and third quartiles, are similar, so this assumption is confirmed. Then we can see that the variable trt (i.e. treatment factor) is highly significant for the model, with very low p-values. The statistical test in this case is not a t-test, as in the output of the function lm, but a Wald Test ([Wald Test](http://www.blackwellpublishing.com/specialarticles/jcn_10_774.pdf)). This test computes the probability that the coefficient is 0, if the p is significant it means the chances the coefficient is zero are very low so the variable should be included in the model since it has an effect on y.

Another important information is the deviance, particularly the residual deviance. As a general rule, this value should be lower or in line than the residuals degrees of freedom for the model to be good. In this case the fact that the residual deviance is high (even though not dramatically) may suggests the explanatory power of the model is low. We will see below how to obtain p-value for the significance of the model.



```r
par(mfrow = c(2, 2))
plot(pois.mod)
```

<img src="generalized-linear-models_files/figure-html/unnamed-chunk-27-1.png" width="672" style="display: block; margin: auto;" />



```r
predict(pois.mod, newdata = data.frame(trt = c("T1", "T2")))
```

```
##          1          2 
##  0.3364722 -0.6839588
```

模型的P值


```r
1 - pchisq(deviance(pois.mod), df.residual(pois.mod))
```

```
## [1] 1.709743e-14
```

模型选择


```r
pois.mod2 <- glm(y ~ block + spray * lead, data = beall.webworms, family = "poisson")
```

两模型的 AIC 比较


```r
AIC(pois.mod, pois.mod2)
```

```
##           df      AIC
## pois.mod   4 3125.478
## pois.mod2 16 3027.438
```

假设响应变量 Y 服从泊松分布，意味着随机变量 Y 的期望和方差相等
 

```r
mean(beall.webworms$y)
```

```
## [1] 0.7923077
```

```r
var(beall.webworms$y)
```

```
## [1] 1.290164
```

实际上方差比均值大，这种情况称之为过度发散 (overdispersed)，分布应该修正为拟（似然）泊松分布


```r
pois.mod3 <- glm(y ~ trt, data = beall.webworms, family = c("quasipoisson"))
summary(pois.mod3)
```

```
## 
## Call:
## glm(formula = y ~ trt, family = c("quasipoisson"), data = beall.webworms)
## 
## Deviance Residuals: 
##     Min       1Q   Median       3Q      Max  
## -1.6733  -1.0046  -0.9081   0.6141   4.2771  
## 
## Coefficients:
##             Estimate Std. Error t value Pr(>|t|)    
## (Intercept)  0.33647    0.05457   6.166 9.32e-10 ***
## trtT2       -1.02043    0.10601  -9.626  < 2e-16 ***
## trtT3       -0.49628    0.08870  -5.595 2.69e-08 ***
## trtT4       -1.22246    0.11440 -10.686  < 2e-16 ***
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## (Dispersion parameter for quasipoisson family taken to be 1.35472)
## 
##     Null deviance: 1955.9  on 1299  degrees of freedom
## Residual deviance: 1720.4  on 1296  degrees of freedom
## AIC: NA
## 
## Number of Fisher Scoring iterations: 6
```

计算得知发散参数(dispersion parameter) 是 1.35472，可见数据Y并不是发散得离谱，泊松分布可能仍然是对这个数据的合理假设

AER 包是书籍 Applied Econometrics with R 的配套材料 [@AER_2008_Kleiber]，可用于直接检验发散参数是否大于1


```r
# AER::dispersiontest(pois.mod, alternative="greater")
```

如果数据真的过度离散，就应该使用负二项分布作为响应变量的拟合分布，拟合它就采用 MASS 包 [@MASS_2002_Venables] 提供的 `glm.nb`函数


```r
NB.mod1 <- MASS::glm.nb(y ~ trt, data = beall.webworms)
summary(NB.mod1)
```

```
## 
## Call:
## MASS::glm.nb(formula = y ~ trt, data = beall.webworms, init.theta = 2.004130573, 
##     link = log)
## 
## Deviance Residuals: 
##     Min       1Q   Median       3Q      Max  
## -1.4572  -0.9488  -0.8660   0.5340   2.7698  
## 
## Coefficients:
##             Estimate Std. Error z value Pr(>|z|)    
## (Intercept)  0.33647    0.06110   5.507 3.65e-08 ***
## trtT2       -1.02043    0.10661  -9.572  < 2e-16 ***
## trtT3       -0.49628    0.09423  -5.267 1.39e-07 ***
## trtT4       -1.22246    0.11283 -10.834  < 2e-16 ***
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## (Dispersion parameter for Negative Binomial(2.0041) family taken to be 1)
## 
##     Null deviance: 1442.7  on 1299  degrees of freedom
## Residual deviance: 1275.3  on 1296  degrees of freedom
## AIC: 3053
## 
## Number of Fisher Scoring iterations: 1
## 
## 
##               Theta:  2.004 
##           Std. Err.:  0.325 
## 
##  2 x log-likelihood:  -3042.969
```

两个模型的方差分析


```r
anova(pois.mod, pois.mod2, test = "Chisq")
```

```
## Analysis of Deviance Table
## 
## Model 1: y ~ trt
## Model 2: y ~ block + spray * lead
##   Resid. Df Resid. Dev Df Deviance  Pr(>Chi)    
## 1      1296     1720.4                          
## 2      1284     1598.4 12   122.04 < 2.2e-16 ***
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
```

从方差分析比较的结果来看，P值告诉我们，两模型是显著不同的，由上面对两模型的 AIC 计算结果来看，模型 pois.mod2 比模型 pois.mod 要好，模型的 AIC 值越小，表明拟合得越准确。 
