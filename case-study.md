# 案例研究 {#chap-case-study}





```r
library(magrittr)
library(ggplot2)
library(gganimate)

library(formattable)
library(packagemetrics)
```

提升回归模型的10个提示
[10 quick tips to improve your regression modeling](https://statmodeling.stat.columbia.edu/wp-content/uploads/2020/07/raos_tips.pdf)

[tidymodels](https://github.com/tidymodels/tidymodels) 和 [easystats](https://github.com/easystats/easystats) 都是基于 [tidyverse](https://github.com/tidyverse/tidyverse) [@Hadley_2019_tidyverse] 的统计模型套件，[strengejacke](https://github.com/strengejacke/strengejacke)、 [mlr3verse](https://github.com/mlr-org/mlr3verse) 目的和 tidymodels 差不多，都是提供做数据建模的完整解决方案，区别在于它不基于 tidyverse 这套东西。

[easystats](https://github.com/easystats/easystats) 包含 [insight](https://github.com/easystats/insight) [@ludecke2019insight] 和 [bayestestR](https://github.com/easystats/bayestestR) [@makowski2019bayestestr] 等共 9 个R 包，[tidymodels](https://github.com/tidymodels/tidymodels) 也包含差不多量的 R 包。
[DrWhy](https://github.com/ModelOriented/DrWhy)
[rms](https://github.com/harrelfe/rms) Regression Modeling Strategies

[gtsummary](https://github.com/ddsjoberg/gtsummary)
[modelsummary](https://github.com/vincentarelbundock/modelsummary) 整理模型输出，提供丰富的格式输出，如 PDF, Text/Markdown, LaTeX, MS Word, RTF, JPG, and PNG.



```r
library(gtsummary)
library(modelsummary)
```



[R for Data Science Online Learning Community](https://github.com/rfordatascience) 在线学习社区以 [tidytuesday](https://github.com/rfordatascience/tidytuesday) 闻名遐迩。

```nomnoml
#padding: 25
#fontsize: 18
#stroke: #26A63A
#linewidth: 2

[Import] -> [Understand]

[Understand |
  [Wrangle] -> [Visualize]
  [Visualize] -> [Model]
  [Model] -> [Wrangle]
]

[Understand] -> [Communicate]
```

统计建模：两种文化 [@Breiman_2001_Modeling]

> 这些案例来自 Kaggle、 Tudesday 或者自己找的数据集，而不是论文里，或者 R 包里的小数据集，应该更加真实，贴近实际问题，考虑更多细节

## 统计学家生平 {#sec-life-of-statisticians}

<!-- 定位：不用任何数据建模的手段，我只是呈现数据本身，但是给人的感觉要达到，一眼就能获得一个直接的感觉，读者立马就能有个感觉，这个感觉就是知道影响统计学家寿命的重大因素有哪些，后续的检验只是帮助我们更加准确地知道影响的大小 -->

世纪统计学家 100 位统计学家，寿命的影响因素，关联分析，图展示数据本身的

<!-- https://github.com/XiangyunHuang/MSG-Book/issues/74 -->

注明每位统计学家所在的年代经历的重大事件，如欧洲中世纪霍乱，第二次世界大战，文化大革命，用图形来讲故事，展现数据可视化的魅力，参考文献 [@Statisticians_1997_Johnson]

## R 语言发展历史 {#sec-history-of-r}

R 语言发展历史和现状，用图来表达

## 不同实验条件下植物生长情况 {#sec-PlantGrowth}

PlantGrowth 数据集收集自 Annette J. Dobson 所著书籍《An Introduction to Statistical Modelling》[@Dobson_1983_Modelling] 第 2 章第 2 节的案例 --- 研究植物在两种不同试验条件下的生长情况，植物通过光合作用吸收土壤的养分和空气中的二氧化碳，完成积累，故以植物的干重来刻画植物的生长情况，首先将几乎相同的种子随机地分配到实验组和对照组，基于完全随机实验设计（completely randomized experimental design），经过预定的时间后，将植物收割，干燥并称重，结果如表 \@ref(tab:PlantGrowth-data) 所示


```r
# do.call("cbind", lapply(split(PlantGrowth, f = PlantGrowth$group), subset, select = "weight"))
## 或者
library(magrittr)
split(PlantGrowth, f = PlantGrowth$group) %>% # 分组
  lapply(., subset, select = "weight") %>% # 计算
  Reduce("cbind", .) %>% # 合并
  setNames(., levels(PlantGrowth$group)) %>% # 重命名 `colnames<-`(., levels(PlantGrowth$group))
  t %>% 
  knitr::kable(.,
    caption = "不同生长环境下植物的干重", row.names = TRUE,
    align = "c"
  )
```

\begin{table}

\caption{(\#tab:PlantGrowth-data)不同生长环境下植物的干重}
\centering
\begin{tabular}[t]{l|c|c|c|c|c|c|c|c|c|c}
\hline
  & 1 & 2 & 3 & 4 & 5 & 6 & 7 & 8 & 9 & 10\\
\hline
ctrl & 4.17 & 5.58 & 5.18 & 6.11 & 4.50 & 4.61 & 5.17 & 4.53 & 5.33 & 5.14\\
\hline
trt1 & 4.81 & 4.17 & 4.41 & 3.59 & 5.87 & 3.83 & 6.03 & 4.89 & 4.32 & 4.69\\
\hline
trt2 & 6.31 & 5.12 & 5.54 & 5.50 & 5.37 & 5.29 & 4.92 & 6.15 & 5.80 & 5.26\\
\hline
\end{tabular}
\end{table}

设立对照组（控制组）ctrl 和实验组 trt1 和 trt2，比较不同的处理方式对植物干重的影响


```r
summary(PlantGrowth)
```

```
##      weight       group   
##  Min.   :3.590   ctrl:10  
##  1st Qu.:4.550   trt1:10  
##  Median :5.155   trt2:10  
##  Mean   :5.073            
##  3rd Qu.:5.530            
##  Max.   :6.310
```

每个组都有10颗植物，生长情况如图\@ref(fig:plant-growth-fig)所示

\begin{figure}

{\centering \includegraphics[width=0.45\linewidth]{case-study_files/figure-latex/plant-growth-fig-1} \includegraphics[width=0.45\linewidth]{case-study_files/figure-latex/plant-growth-fig-2} 

}

\caption{植物干重}(\#fig:plant-growth-fig)
\end{figure}

实验条件 trt1 和 trt2 对植物生长状况有显著的影响，为了量化这种影响，建立线性回归模型


```r
fit_sublm <- lm(weight ~ group,
  data = PlantGrowth,
  subset = group %in% c("ctrl", "trt1")
)
anova(fit_sublm)
```

```
## Analysis of Variance Table
## 
## Response: weight
##           Df Sum Sq Mean Sq F value Pr(>F)
## group      1 0.6882 0.68820  1.4191  0.249
## Residuals 18 8.7292 0.48496
```

```r
summary(fit_sublm)
```

```
## 
## Call:
## lm(formula = weight ~ group, data = PlantGrowth, subset = group %in% 
##     c("ctrl", "trt1"))
## 
## Residuals:
##     Min      1Q  Median      3Q     Max 
## -1.0710 -0.4938  0.0685  0.2462  1.3690 
## 
## Coefficients:
##             Estimate Std. Error t value Pr(>|t|)    
## (Intercept)   5.0320     0.2202  22.850 9.55e-15 ***
## grouptrt1    -0.3710     0.3114  -1.191    0.249    
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Residual standard error: 0.6964 on 18 degrees of freedom
## Multiple R-squared:  0.07308,	Adjusted R-squared:  0.02158 
## F-statistic: 1.419 on 1 and 18 DF,  p-value: 0.249
```

下面再通过检验的方式比较实验组和对照组相比，是否有显著作用


```r
# 控制组和实验组1比较
t.test(weight ~ group, data = PlantGrowth, subset = group %in% c("ctrl", "trt1"))
```

```
## 
## 	Welch Two Sample t-test
## 
## data:  weight by group
## t = 1.1913, df = 16.524, p-value = 0.2504
## alternative hypothesis: true difference in means between group ctrl and group trt1 is not equal to 0
## 95 percent confidence interval:
##  -0.2875162  1.0295162
## sample estimates:
## mean in group ctrl mean in group trt1 
##              5.032              4.661
```

```r
# 控制组和实验组2比较
t.test(weight ~ group, data = PlantGrowth, subset = group %in% c("ctrl", "trt2"))
```

```
## 
## 	Welch Two Sample t-test
## 
## data:  weight by group
## t = -2.134, df = 16.786, p-value = 0.0479
## alternative hypothesis: true difference in means between group ctrl and group trt2 is not equal to 0
## 95 percent confidence interval:
##  -0.98287213 -0.00512787
## sample estimates:
## mean in group ctrl mean in group trt2 
##              5.032              5.526
```

检验结果表明，实验条件 trt2 会对植物生长产生显著效果，而实验条件 trt1 不会。在假定同方差的情况下，建立线性回归模型，同时考虑实验条件 trt1 和 trt2


```r
# 模型拟合
fit_lm <- lm(weight ~ group, data = PlantGrowth)

## 模型输出
summary(fit_lm)
```

```
## 
## Call:
## lm(formula = weight ~ group, data = PlantGrowth)
## 
## Residuals:
##     Min      1Q  Median      3Q     Max 
## -1.0710 -0.4180 -0.0060  0.2627  1.3690 
## 
## Coefficients:
##             Estimate Std. Error t value Pr(>|t|)    
## (Intercept)   5.0320     0.1971  25.527   <2e-16 ***
## grouptrt1    -0.3710     0.2788  -1.331   0.1944    
## grouptrt2     0.4940     0.2788   1.772   0.0877 .  
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Residual standard error: 0.6234 on 27 degrees of freedom
## Multiple R-squared:  0.2641,	Adjusted R-squared:  0.2096 
## F-statistic: 4.846 on 2 and 27 DF,  p-value: 0.01591
```

```r
## 方差分析
anova(fit_lm)
```

```
## Analysis of Variance Table
## 
## Response: weight
##           Df  Sum Sq Mean Sq F value  Pr(>F)  
## group      2  3.7663  1.8832  4.8461 0.01591 *
## Residuals 27 10.4921  0.3886                  
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
```

```r
## 参数估计
coef(summary(fit_lm))
```

```
##             Estimate Std. Error   t value     Pr(>|t|)
## (Intercept)    5.032  0.1971284 25.526514 1.936575e-20
## grouptrt1     -0.371  0.2787816 -1.330791 1.943879e-01
## grouptrt2      0.494  0.2787816  1.771996 8.768168e-02
```

模型输出整理成表 \@ref(tab:lm-plant-growth-output) 所示

\begin{table}

\caption{(\#tab:lm-plant-growth-output)线性回归的输出}
\centering
\begin{tabular}[t]{l|r|r|r|r}
\hline
  & 估计值 & 标准差 & t 统计量 & P 值\\
\hline
$\alpha$ & 5.032 & 0.1971 & 25.5265 & 0.0000\\
\hline
$\beta_1$ & -0.371 & 0.2788 & -1.3308 & 0.1944\\
\hline
$\beta_2$ & 0.494 & 0.2788 & 1.7720 & 0.0877\\
\hline
\end{tabular}
\end{table}

还可以将模型转化为数学公式


```r
# 理论模型
equatiomatic::extract_eq(fit_lm)
```



\begin{equation}
\operatorname{weight} = \alpha + \beta_{1}(\operatorname{group}_{\operatorname{trt1}}) + \beta_{2}(\operatorname{group}_{\operatorname{trt2}}) + \epsilon
\end{equation}

```r
# 拟合模型
equatiomatic::extract_eq(fit_lm, use_coefs = TRUE)
```



\begin{equation}
\operatorname{\widehat{weight}} = 5.03 - 0.37(\operatorname{group}_{\operatorname{trt1}}) + 0.49(\operatorname{group}_{\operatorname{trt2}})
\end{equation}

进一步地，我们在线性模型的基础上考虑每个实验组有不同的方差，先做方差齐性检验。


```r
bartlett.test(weight ~ group, data = PlantGrowth)
```

```
## 
## 	Bartlett test of homogeneity of variances
## 
## data:  weight by group
## Bartlett's K-squared = 2.8786, df = 2, p-value = 0.2371
```

```r
fligner.test(weight ~ group, data = PlantGrowth)
```

```
## 
## 	Fligner-Killeen test of homogeneity of variances
## 
## data:  weight by group
## Fligner-Killeen:med chi-squared = 2.3499, df = 2, p-value = 0.3088
```

检验的结果显示，可以认为三个组的方差没有显著差异，但我们还是考虑每个组有不同的方差，看看放开假设能获得多少提升，后续会发现，从对数似然的角度来看，实际提升量很小，只有 7.72\%

上面同时比较多个总体的方差，会发现方差没有显著差异，那么接下来在假定方差齐性的条件下，比较均值的差异是否显著？


```r
# 参数检验，假定异方差
oneway.test(weight ~ group, data = PlantGrowth, var.equal = FALSE)
```

```
## 
## 	One-way analysis of means (not assuming equal variances)
## 
## data:  weight and group
## F = 5.181, num df = 2.000, denom df = 17.128, p-value = 0.01739
```

```r
# 参数检验，假定方差齐性
oneway.test(weight ~ group, data = PlantGrowth, var.equal = TRUE)
```

```
## 
## 	One-way analysis of means
## 
## data:  weight and group
## F = 4.8461, num df = 2, denom df = 27, p-value = 0.01591
```

```r
# 非参数检验
kruskal.test(weight ~ group, data = PlantGrowth)
```

```
## 
## 	Kruskal-Wallis rank sum test
## 
## data:  weight by group
## Kruskal-Wallis chi-squared = 7.9882, df = 2, p-value = 0.01842
```

检验结果显示它们的均值是有显著差异的！


```r
# 固定效应模型
fit_gls <- nlme::gls(weight ~ 1,
  weights = nlme::varIdent(form = ~ 1 | group),
  data = PlantGrowth, method = "REML"
)
summary(fit_gls)
```

```
## Generalized least squares fit by REML
##   Model: weight ~ 1 
##   Data: PlantGrowth 
##        AIC      BIC    logLik
##   70.48628 75.95547 -31.24314
## 
## Variance function:
##  Structure: Different standard deviations per stratum
##  Formula: ~1 | group 
##  Parameter estimates:
##      ctrl      trt1      trt2 
## 1.0000000 1.5825700 0.9230865 
## 
## Coefficients:
##                Value Std.Error  t-value p-value
## (Intercept) 5.199759 0.1162421 44.73214       0
## 
## Standardized residuals:
##         Min          Q1         Med          Q3         Max 
## -1.74647988 -0.91870713 -0.07591108  0.60676033  2.03987301 
## 
## Residual standard error: 0.5896195 
## Degrees of freedom: 30 total; 29 residual
```

```r
# 随机效应模型
fit_lme <- nlme::lme(weight ~ 1, random = ~ 1 | group, data = PlantGrowth)
summary(fit_lme)
```

```
## Linear mixed-effects model fit by REML
##   Data: PlantGrowth 
##        AIC      BIC    logLik
##   67.44473 71.54662 -30.72237
## 
## Random effects:
##  Formula: ~1 | group
##         (Intercept)  Residual
## StdDev:   0.3865976 0.6233746
## 
## Fixed effects:  weight ~ 1 
##             Value Std.Error DF  t-value p-value
## (Intercept) 5.073 0.2505443 27 20.24792       0
## 
## Standardized Within-Group Residuals:
##          Min           Q1          Med           Q3          Max 
## -1.854449795 -0.688750457  0.006389611  0.406096866  2.059729645 
## 
## Number of Observations: 30
## Number of Groups: 3
```

$\sigma_i^2 = Var(\epsilon_{ij}), i = 1,2,3$ 表示第 $i$ 组的方差，

$$
y_{ij} = \mu + \epsilon_{ij}, i = 1,2,3
$$

其中 $\mu$ 是固定的未知参数，我们和之前假定同方差情形下的模型比较一下，现在异方差情况下模型提升的情况，从对数似然的角度来看


```r
logLik(fit_lm)
## 'log Lik.' -26.80952 (df=4)
logLik(fit_lm, REML = TRUE)
## 'log Lik.' -29.00481 (df=4)
logLik(fit_gls)
## 'log Lik.' -31.24314 (df=4)
logLik(fit_lme)
## 'log Lik.' -30.72237 (df=3)
```

进一步地，我们考虑两水平模型，认为不同的实验组其均值和方差都不一样，检验三样本均值是否相等？

$\mu_1 = \mu_2 = \mu_3$ 检验，这里因为每组的样本量都一样，因此考虑 Turkey 的 T 法检验，检验均值是否有显著差别，实际上这里因为实验组数量只有2个，可以两两比对，如前所述。但是这里我们想扩展一下，考虑多组比较的问题。

<!-- 书籍 《概率论与数理统计教程》438 页重复数相等场合下的多重比较 T 法 [@Prob_2011_Mao] -->

和上面用 `gls` 拟合的模型是一致的。

\begin{align}
y_{ij}& = \mu_i + \epsilon_{ij}, \\
\mu_i & = \mu_{\theta} + \xi_i. \quad i  = 1,\ldots,3; \quad j = 1, \ldots, 10.
\end{align}

其中 $\mu_i$ 是随机的未知变量，服从均值为 $\mu_{\theta}$ 方差为 $Var(\xi_i) = \tau^2$ 的正态分布

我们用 **MASS** 包提供的 `glmmPQL()` 函数拟合该数据集


```r
fit_lme_pql <- MASS::glmmPQL(weight ~ 1,
  random = ~ 1 | group, verbose = FALSE,
  family = gaussian(), data = PlantGrowth
)
summary(fit_lme_pql)
```

```
## Linear mixed-effects model fit by maximum likelihood
##   Data: PlantGrowth 
##   AIC BIC logLik
##    NA  NA     NA
## 
## Random effects:
##  Formula: ~1 | group
##         (Intercept)  Residual
## StdDev:   0.2944234 0.6233746
## 
## Variance function:
##  Structure: fixed weights
##  Formula: ~invwt 
## Fixed effects:  weight ~ 1 
##             Value Std.Error DF  t-value p-value
## (Intercept) 5.073 0.2080656 27 24.38174       0
## 
## Standardized Within-Group Residuals:
##          Min           Q1          Med           Q3          Max 
## -1.922640850 -0.734727623  0.004564386  0.405111223  1.991538416 
## 
## Number of Observations: 30
## Number of Groups: 3
```

我们再借助 **brms** 包从贝叶斯的角度来分析数据，并建模

<!-- 就以 brms 包为例谈谈先验、参数设置，默认的先验有可能太宽泛了，导致不是很合理 <https://discourse.mc-stan.org/t/11584> -->


```r
# 贝叶斯模型
fit_brm <- brms::brm(weight ~ group, data = PlantGrowth)
# 参考 https://www.xiangyunhuang.com.cn/2019/05/normal-hierarchical-model/
library(Rcpp)
fit_lme_brm <- brms::brm(weight ~ 1 + (1 | group),
  data = PlantGrowth, family = gaussian(), 
  refresh = 0, seed = 2019
)
summary(fit_lme_brm)
```

## 橘树生长情况 {#sec-orange}

<!-- 非线性混合效应模型 {#chap-nonlinear-mixed-models} -->

Orange 数据集包含三个变量，记录了加利福尼亚南部的一个小树林中的五棵橘树的生长情况，在 **datasets** 包里，数据集保存为 `c("nfnGroupedData", "nfGroupedData", "groupedData", "data.frame")` 类型的数据，同时具有着四个类的特点。

- Tree: 有序的指示变量，根据5棵橘树的最大直径划分，测量值很可能是根据林务员常用的“胸围周长”
- age: 橘树的树龄，自 1968 年 12 月 31 日起按天计算
- circumference: 橘树树干的周长，单位是毫米

查看部分数据的情况


```r
head(Orange)
```

```
## Grouped Data: circumference ~ age | Tree
##   Tree  age circumference
## 1    1  118            30
## 2    1  484            58
## 3    1  664            87
## 4    1 1004           115
## 5    1 1231           120
## 6    1 1372           142
```

查看变量的属性


```r
str(Orange)
```

```
## Classes 'nfnGroupedData', 'nfGroupedData', 'groupedData' and 'data.frame':	35 obs. of  3 variables:
##  $ Tree         : Ord.factor w/ 5 levels "3"<"1"<"5"<"2"<..: 2 2 2 2 2 2 2 4 4 4 ...
##  $ age          : num  118 484 664 1004 1231 ...
##  $ circumference: num  30 58 87 115 120 142 145 33 69 111 ...
##  - attr(*, "formula")=Class 'formula'  language circumference ~ age | Tree
##   .. ..- attr(*, ".Environment")=<environment: R_EmptyEnv> 
##  - attr(*, "labels")=List of 2
##   ..$ x: chr "Time since December 31, 1968"
##   ..$ y: chr "Trunk circumference"
##  - attr(*, "units")=List of 2
##   ..$ x: chr "(days)"
##   ..$ y: chr "(mm)"
```

说明 5 棵树之间的大小关系是 `3 < 1 < 5 < 2 < 4`，这里的数字 1，2，3，4，5 只是对树的编号，第一次测量时树的大小关系在 R 内用有序因子来表示。


```r
levels(Orange$Tree)
```

```
## [1] "3" "1" "5" "2" "4"
```

表 \@ref(tab:orange-data) 记录了 5 颗橘树自 1968 年 12 月 31 日以来的生长情况


```r
# aggregate(data = Orange, circumference ~  age, FUN = mean)
library(magrittr)
reshape(
  data = Orange, v.names = "circumference", idvar = "Tree",
  timevar = "age", direction = "wide", sep = ""
) %>%
  knitr::kable(.,
    caption = "躯干周长（毫米）随时间（天）的变化",
    row.names = FALSE, col.names = gsub("(circumference)", "", names(.)),
    align = "c"
  )
```

\begin{table}

\caption{(\#tab:orange-data)躯干周长（毫米）随时间（天）的变化}
\centering
\begin{tabular}[t]{c|c|c|c|c|c|c|c}
\hline
Tree & 118 & 484 & 664 & 1004 & 1231 & 1372 & 1582\\
\hline
1 & 30 & 58 & 87 & 115 & 120 & 142 & 145\\
\hline
2 & 33 & 69 & 111 & 156 & 172 & 203 & 203\\
\hline
3 & 30 & 51 & 75 & 108 & 115 & 139 & 140\\
\hline
4 & 32 & 62 & 112 & 167 & 179 & 209 & 214\\
\hline
5 & 30 & 49 & 81 & 125 & 142 & 174 & 177\\
\hline
\end{tabular}
\end{table}

图 \@ref(fig:orange-tree) 以直观的方式展示 5 颗橘树的生长变化，相比于表 \@ref(tab:orange-data) 我们能更加明确读取数据中的变化


```r
library(ggplot2)
p <- ggplot(data = Orange, aes(x = age, y = circumference, color = Tree)) +
  geom_point() +
  geom_line() +
  theme_minimal() +
  labs(x = "age (day)", y = "circumference (mm)")
p
```

\begin{figure}

{\centering \includegraphics{case-study_files/figure-latex/orange-tree-1} 

}

\caption{橘树生长模型}(\#fig:orange-tree)
\end{figure}


```r
library(gganimate)
p + transition_reveal(age)
```



\begin{center}\animategraphics[,controls,loop]{10}{case-study_files/figure-latex/orange-animate-}{1}{100}\end{center}



## R 包网络分析 {#pkg-network}

首先我们从 CRAN 官网下载 R 包描述信息


```r
pdb <- tools::CRAN_package_db()
```

接着，我们可以看看CRAN 上发布的 R 包数量


```r
length(pdb[, "Package"])
```

```
## [1] 18548
```

经过与官网发布的数据来对比，我们发现这里计算的结果与实际不符，多出来了几十个R包，所以我们再观察一下是否有重复的 R 包描述信息


```r
pdb[, "Package"][duplicated(pdb[, "Package"])]
```

```
##  [1] "boot"       "class"      "cluster"    "codetools"  "foreign"   
##  [6] "KernSmooth" "lattice"    "MASS"       "Matrix"     "mgcv"      
## [11] "nlme"       "nnet"       "rpart"      "spatial"    "survival"  
## [16] "RODBC"      "XML"
```

不难发现，果然有！所以去掉重复的 R 包信息，就是 CRAN 上实际发布的 R 包数量


```r
dim(subset(pdb, subset = !duplicated(pdb[, "Package"])))[1]
```

```
## [1] 18531
```

接下来就是分析去掉重复信息后的数据矩阵 pdb


```r
pdb <- subset(pdb, subset = !duplicated(pdb[, "Package"]))
```

### R 核心团队 {#R-Core-Team}

R 核心团队除了维护开发 Base R 包以外，还开发了哪些 R 包，我们依据这些开发者邮箱 `<Firstname>.<Lastname>@R-project.org` 的特点，从数据集 pdb 中提取他们开发的 R 包


```r
core_pdb <- subset(pdb,
  subset = grepl(
    x = pdb[, "Maintainer"],
    pattern = "(@R-project\\.org)"
  ),
  select = c("Package", "Maintainer")
)
dim(core_pdb[order(core_pdb[, "Maintainer"]), ])
```

```
## [1] 105   2
```

这么少，是不是有点意外，看来很多大佬更喜欢用自己的邮箱，比如 Paul Murrell， 他的邮箱是 <paul@stat.auckland.ac.nz>


```r
subset(pdb,
  subset = grepl(x = pdb[, "Maintainer"], pattern = "(Paul Murrell)"),
  select = c("Package", "Maintainer")
)
```

```
##            Package                              Maintainer
## 2524       compare Paul Murrell <p.murrell@auckland.ac.nz>
## 5774         gdiff Paul Murrell <paul@stat.auckland.ac.nz>
## 6074        gggrid Paul Murrell <paul@stat.auckland.ac.nz>
## 6532      gridBase Paul Murrell <paul@stat.auckland.ac.nz>
## 6533    gridBezier Paul Murrell <paul@stat.auckland.ac.nz>
## 6534     gridDebug Paul Murrell <p.murrell@auckland.ac.nz>
## 6536  gridGeometry Paul Murrell <paul@stat.auckland.ac.nz>
## 6537  gridGraphics Paul Murrell <paul@stat.auckland.ac.nz>
## 6538  gridGraphviz Paul Murrell <p.murrell@auckland.ac.nz>
## 6542       gridSVG Paul Murrell <paul@stat.auckland.ac.nz>
## 6545      grImport Paul Murrell <p.murrell@auckland.ac.nz>
## 6546     grImport2 Paul Murrell <paul@stat.auckland.ac.nz>
## 6870       hexView Paul Murrell <paul@stat.auckland.ac.nz>
## 9306      metapost Paul Murrell <paul@stat.auckland.ac.nz>
## 12998    rasterize Paul Murrell <paul@stat.auckland.ac.nz>
## 13742    RGraphics Paul Murrell <paul@stat.auckland.ac.nz>
## 14177        roloc Paul Murrell <paul@stat.auckland.ac.nz>
## 14178 rolocISCCNBS Paul Murrell <paul@stat.auckland.ac.nz>
## 18061       vwline Paul Murrell <paul@stat.auckland.ac.nz>
```

所以这种方式不行了，只能列举所有 R Core Team 成员，挨个去匹配，幸好 `contributors()` 函数已经收集了成员名单，不需要我们去官网找了。


```r
core_team <- read.table(
  text = "
Douglas Bates
John Chambers
Peter Dalgaard
Robert Gentleman
Kurt Hornik
Ross Ihaka
Tomas Kalibera
Michael Lawrence
Friedrich Leisch
Uwe Ligges
Thomas Lumley
Martin Maechler
Martin Morgan
Paul Murrell
Martyn Plummer
Brian Ripley
Deepayan Sarkar
Duncan Temple Lang
Luke Tierney
Simon Urbanek
Heiner Schwarte
Guido Masarotto
Stefano Iacus
Seth Falcon
Duncan Murdoch
David Meyer
Simon Wood
", header = FALSE, sep = "\n", 
  check.names = FALSE, stringsAsFactors = FALSE,
  colClasses = "character", comment.char = "", col.names = "name"
)
```

R 核心团队维护的 R 包及其最新发布的日期


```r
core_pdb <- subset(pdb,
  subset = grepl(
    x = pdb[, "Maintainer"],
    pattern = paste("(", core_team$name, ")", collapse = "|", sep = "")
  ),
  select = c("Package", "Maintainer", "Published")
)
```

清理 Maintainer 字段中的邮箱部分，方便表格展示


```r
clean_maintainer <- function(x) {
  # 去掉邮箱
  x <- gsub("<([^<>]*)>", "", x)
  # 去掉 \n \t \' \" 和 '
  x <- gsub("(\\\n)|(\\\t)|(\\\")|(\\\')|(')", "", x)
  # 去掉末尾空格
  x <- gsub(" +$", "", x)
}
core_pdb[, "Maintainer"] <- clean_maintainer(core_pdb[, "Maintainer"])
```

我们可以看到 R 核心团队总共开发维护有 174 个 R 包


```r
dim(core_pdb)
```

```
## [1] 174   3
```

篇幅所限，就展示部分人和R包，见表 \@ref(tab:r-core-team) 按照拼音顺序 Brian Ripley 是第一位


```r
knitr::kable(head(core_pdb[order(
  core_pdb[, "Maintainer"],
  core_pdb[, "Published"]
), ], 6),
caption = "R Core Team 维护的 R 包（展示部分）", 
booktabs = TRUE, row.names = FALSE
)
```

\begin{table}

\caption{(\#tab:r-core-team)R Core Team 维护的 R 包（展示部分）}
\centering
\begin{tabular}[t]{lll}
\toprule
Package & Maintainer & Published\\
\midrule
mix & Brian Ripley & 2017-06-12\\
pspline & Brian Ripley & 2017-06-12\\
gee & Brian Ripley & 2019-11-07\\
boot & Brian Ripley & 2021-05-03\\
class & Brian Ripley & 2021-05-03\\
\addlinespace
KernSmooth & Brian Ripley & 2021-05-03\\
\bottomrule
\end{tabular}
\end{table}

分组计数，看看核心开发者维护的 R 包有多少


```r
aggregate(data = core_pdb, Package ~ Maintainer, FUN = length) |> 
  ggplot(aes(x = reorder(Maintainer, Package), y = Package)) +
  geom_col() +
  coord_flip() +
  labs(x = "R 核心团队", y = "R 包数量") +
  theme_minimal(base_family = "source-han-serif-cn")
```



\begin{center}\includegraphics[width=0.75\linewidth]{case-study_files/figure-latex/unnamed-chunk-21-1} \end{center}


### 高产的开发者 {#Top-Creators}

> 这些人的个人简介

接下来，我们再来查看一些比较高产的 R 包开发者谢益辉都维护了哪些R包，如表 \@ref(tab:rmarkdown-ecology) 所示


```r
yihui_pdb <- subset(pdb,
  subset = grepl("Yihui Xie", pdb[, "Maintainer"]),
  select = c("Package", "Title")
)
yihui_pdb[, "Title"] <- gsub("(\\\n)", " ", yihui_pdb[, "Title"])
knitr::kable(yihui_pdb,
  caption = "谢益辉维护的 R Markdown 生态",
  booktabs = TRUE, row.names = FALSE
)
```

\begin{table}

\caption{(\#tab:rmarkdown-ecology)谢益辉维护的 R Markdown 生态}
\centering
\begin{tabular}[t]{ll}
\toprule
Package & Title\\
\midrule
animation & A Gallery of Animations in Statistics and Utilities to Create Animations\\
blogdown & Create Blogs and Websites with R Markdown\\
bookdown & Authoring Books and Technical Documents with R Markdown\\
DT & A Wrapper of the JavaScript Library 'DataTables'\\
evaluate & Parsing and Evaluation Tools that Provide More Details than the Default\\
\addlinespace
formatR & Format R Code Automatically\\
fun & Use R for Fun\\
highr & Syntax Highlighting for R Source Code\\
knitr & A General-Purpose Package for Dynamic Report Generation in R\\
markdown & Render Markdown with the C Library 'Sundown'\\
\addlinespace
mime & Map Filenames to MIME Types\\
MSG & Data and Functions for the Book Modern Statistical Graphics\\
pagedown & Paginate the HTML Output of R Markdown with CSS for Print\\
printr & Automatically Print R Objects to Appropriate Formats According to the 'knitr' Output Format\\
Rd2roxygen & Convert Rd to 'Roxygen' Documentation\\
\addlinespace
rmarkdown & Dynamic Documents for R\\
rolldown & R Markdown Output Formats for Storytelling\\
rticles & Article Formats for R Markdown\\
servr & A Simple HTTP Server to Serve Static Files or Dynamic Documents\\
testit & A Simple Package for Testing R Packages\\
\addlinespace
tinytex & Helper Functions to Install and Maintain TeX Live, and Compile LaTeX Documents\\
tufte & Tufte's Styles for R Markdown Documents\\
xaringan & Presentation Ninja\\
xfun & Supporting Functions for Packages Maintained by 'Yihui Xie'\\
\bottomrule
\end{tabular}
\end{table}

Jeroen Ooms 维护从 C++ 世界搬运进来的库，如图像处理 magick 包、 视频处理 av 包、 PDF 文档操作 qpdf 包


```r
subset(pdb, subset = grepl("Jeroen Ooms", pdb[, "Maintainer"]),
       select = 'Package', drop = TRUE)
```

```
##  [1] "antiword"    "askpass"     "av"          "base64"      "bcrypt"     
##  [6] "brotli"      "cld2"        "cld3"        "commonmark"  "credentials"
## [11] "curl"        "gert"        "gifski"      "gpg"         "graphql"    
## [16] "hunspell"    "jose"        "js"          "jsonld"      "jsonlite"   
## [21] "katex"       "magick"      "maketools"   "minimist"    "mongolite"  
## [26] "opencpu"     "opencv"      "openssl"     "pdftools"    "protolite"  
## [31] "qpdf"        "RAppArmor"   "rjade"       "RMySQL"      "rsvg"       
## [36] "rzmq"        "sodium"      "spelling"    "ssh"         "sys"        
## [41] "tesseract"   "unix"        "unrtf"       "V8"          "webp"       
## [46] "webutils"    "writexl"     "xslt"
```

Dirk Eddelbuettel 维护 Rcpp 生态


```r
subset(pdb, subset = grepl("Dirk Eddelbuettel", pdb[, "Maintainer"]),
       select = 'Package', drop = TRUE)
```

```
##  [1] "anytime"             "AsioHeaders"         "BH"                 
##  [4] "binb"                "corels"              "dang"               
##  [7] "digest"              "drat"                "gaussfacts"         
## [10] "gcbd"                "gettz"               "gunsales"           
## [13] "inline"              "linl"                "littler"            
## [16] "nanotime"            "pinp"                "pkgKitten"          
## [19] "prrd"                "random"              "RApiDatetime"       
## [22] "RApiSerialize"       "Rblpapi"             "Rcpp"               
## [25] "RcppAnnoy"           "RcppAPT"             "RcppArmadillo"      
## [28] "RcppBDT"             "RcppCCTZ"            "RcppClassic"        
## [31] "RcppClassicExamples" "RcppCNPy"            "RcppDate"           
## [34] "RcppDE"              "RcppEigen"           "RcppExamples"       
## [37] "RcppFarmHash"        "RcppFastFloat"       "RcppGetconf"        
## [40] "RcppGSL"             "RcppMsgPack"         "RcppNLoptExample"   
## [43] "RcppQuantuccia"      "RcppRedis"           "RcppSimdJson"       
## [46] "RcppSMC"             "RcppSpdlog"          "RcppStreams"        
## [49] "RcppTOML"            "RcppXts"             "RcppZiggurat"       
## [52] "RDieHarder"          "rfoaas"              "RInside"            
## [55] "rmsfact"             "RProtoBuf"           "RPushbullet"        
## [58] "RQuantLib"           "RVowpalWabbit"       "sanitizers"         
## [61] "td"                  "tidyCpp"             "tiledb"             
## [64] "tint"                "ttdo"                "x13binary"
```

Hadley Wickham 维护 tidyverse 生态 


```r
subset(pdb, subset = grepl("Hadley Wickham", pdb[, "Maintainer"]),
       select = 'Package', drop = TRUE)
```

```
##  [1] "assertthat"    "babynames"     "bigrquery"     "classifly"    
##  [5] "conflicted"    "cubelyr"       "dbplyr"        "diffviewer"   
##  [9] "downlit"       "dplyr"         "dtplyr"        "ellipsis"     
## [13] "feather"       "forcats"       "fueleconomy"   "generics"     
## [17] "ggplot2movies" "gtable"        "haven"         "hflights"     
## [21] "highlight"     "httr"          "httr2"         "lazyeval"     
## [25] "lobstr"        "lvplot"        "meifly"        "modelr"       
## [29] "multidplyr"    "nasaweather"   "nycflights13"  "odbc"         
## [33] "pins"          "pkgdown"       "plyr"          "productplots" 
## [37] "profr"         "proto"         "pryr"          "rappdirs"     
## [41] "reshape"       "reshape2"      "roxygen2"      "rvest"        
## [45] "scales"        "sloop"         "stringr"       "testthat"     
## [49] "tidyr"         "tidyverse"     "waldo"         "xml2"
```

[Scott Chamberlain](https://scottchamberlain.info/) 是非营利性组织 [rOpenSci](https://ropensci.org/) 的联合创始人，但是没几个 R 包听说过


```r
subset(pdb, subset = grepl("Scott Chamberlain", pdb[, "Maintainer"]),
       select = 'Package', drop = TRUE)
```

```
##  [1] "bold"        "brranching"  "charlatan"   "citecorp"    "ckanr"      
##  [6] "conditionz"  "cowsay"      "crul"        "discgolf"    "elastic"    
## [11] "fauxpas"     "finch"       "geojson"     "geojsonio"   "geojsonlint"
## [16] "getlandsat"  "ghql"        "gistr"       "handlr"      "hoardr"     
## [21] "httpcode"    "httping"     "isdparser"   "jaod"        "jqr"        
## [26] "mapr"        "microdemic"  "mregions"    "natserv"     "oai"        
## [31] "openadds"    "pangaear"    "parzer"      "phylocomr"   "pubchunks"  
## [36] "randgeo"     "rbace"       "rbhl"        "rbison"      "rcitoid"    
## [41] "rcol"        "rcoreoa"     "rcrossref"   "rdatacite"   "rdryad"     
## [46] "request"     "rgbif"       "rgnparser"   "ritis"       "rorcid"     
## [51] "rphylopic"   "rplos"       "rredlist"    "rvertnet"    "sofa"       
## [56] "solrium"     "spocc"       "taxize"      "taxizedb"    "traits"     
## [61] "vcr"         "webmockr"    "wellknown"   "wikitaxa"    "worrms"     
## [66] "zbank"
```

### 社区开发者 {#R-Package-Developers}

接下来，我们想看看 R 包维护者数量有多少


```r
length(unique(pdb[, "Maintainer"]))
```

```
## [1] 10811
```

可实际上没有这么多的开发者，因为存在这样的情况，以 R 包维护者 Hadley Wickham 为例，由于他曾使用过不同的邮箱，所以在维护者字段出现了不一致的情况，实际却是同一个人。


```r
subset(pdb,
  subset = grepl("Hadley Wickham", pdb[, "Maintainer"]),
  select = c("Package", "Maintainer")
)
```

```
##             Package                             Maintainer
## 593      assertthat    Hadley Wickham <hadley@rstudio.com>
## 752       babynames    Hadley Wickham <hadley@rstudio.com>
## 1205      bigrquery    Hadley Wickham <hadley@rstudio.com>
## 2202      classifly   Hadley Wickham <h.wickham@gmail.com>
## 2604     conflicted    Hadley Wickham <hadley@rstudio.com>
....
```

因此，有必要先把 Maintainer 字段中的邮箱部分去掉，这样我们可以得到比较靠谱的R包维护者数量了！


```r
pdb[, "Maintainer"] <- clean_maintainer(pdb[, "Maintainer"])
length(unique(pdb[, "Maintainer"]))
```

```
## [1] 10001
```

接下来，我们还想把 R 包维护者，按照其维护的R包数量排个序，用条形图\@ref(fig:top-maintainers) 表示，其中 Orphaned 表示之前的R包维护者不愿意继续维护了，后来有人接手维护，Orphaned 表示这一类接盘侠。


```r
top_maintainer <- head(sort(table(pdb[, "Maintainer"]), decreasing = TRUE), 20)

par(mar = c(2, 7, 1, 1))
barCenters <- barplot(top_maintainer,
  col = "lightblue", axes = FALSE,
  axisnames = FALSE, horiz = TRUE, border = "white"
)
text(
  y = barCenters, x = par("usr")[3],
  adj = 1, labels = names(top_maintainer), xpd = TRUE
)
axis(1,
  labels = seq(0, 90, by = 10), at = seq(0, 90, by = 10),
  las = 1, col = "gray"
)
grid()
```

\begin{figure}

{\centering \includegraphics[width=0.75\linewidth]{case-study_files/figure-latex/top-maintainers-1} 

}

\caption{维护 R 包数量最多的 20 个人}(\#fig:top-maintainers)
\end{figure}

调用 ggplot2 包绘图要求输入的数据类型是 `data.frame`，所以我们首先将 `top_maintainer` 转化为数据框类型


```r
top_maintainer <- as.data.frame(top_maintainer)
colnames(top_maintainer) <- c("Maintainer", "Freq")

ggplot(top_maintainer) +
  geom_bar(aes(x = Maintainer, y = Freq), stat = "identity") +
  coord_flip() +
  xlab("Maintainer") +
  ylab("Numbers of Package")
```



\begin{center}\includegraphics{case-study_files/figure-latex/unnamed-chunk-29-1} \end{center}

条形图在柱子很多的情况下，点线图是一种更加简洁的替代方式


```r
ggplot(top_maintainer, aes(x = Freq, y = Maintainer)) +
  geom_segment(aes(x = 20, xend = Freq, yend = Maintainer), colour = "grey50") +
  geom_point(size = 2, colour = "red") +
  labs(x = " # of Packages ", y = " Maintainer ")
```



\begin{center}\includegraphics{case-study_files/figure-latex/unnamed-chunk-30-1} \end{center}

接下来，我们想看看开发者维护的 R 包数量的分布，仅从上图，我们知道有的人能维护 80 多个 R 包，总体的分布情况又是如何呢？如图所示，我们将纵轴刻度设置为 log 模式，随着开发的R包数量的增加，开发者人数是指数级递减，可见开发R包依然是一个门槛很高的工作！


```r
barplot(table(table(pdb[, "Maintainer"])),
  col = "lightblue", log = "y", border = "white",
  xlab = "# of Packages", ylab = "# of Maintainers (log)",
  panel.first = grid()
)
```



\begin{center}\includegraphics{case-study_files/figure-latex/unnamed-chunk-31-1} \end{center}

只开发一个 R 包的人数达到 5276 人，占开发者总数的 67.31\%，约为2/3。

### 首次贡献 R 包 {#first-commit}

我们还想进一步了解这些人是不是就自己开发自己维护，基本没有其他人参与，答案是 Almost Sure. 这些人其实占了大部分，相比于前面的 R 核心开发团队或者 R Markdown 生态的维护者，他们绝大部分属于金字塔底部的人，二八定律似乎在这里再次得到印证。


```r
sub_pdb <- subset(pdb, select = c("Package", "Maintainer", "Author"))
```

接着先清理一下 Maintainer 和 Author 字段，Author 字段的内容比起 Maintainer 复杂一些


```r
clean_author <- function(x) {
  # 去掉中括号及其内容 [aut] [aut, cre]
  x <- gsub("(\\[.*?\\])", "", x)
  # 去掉小括号及其内容 ()
  x <- gsub("(\\(.*?\\))", "", x)
  # 去掉尖括号及其内容 < >
  x <- gsub("(<.*?>)", "", x)
  # 去掉 \n
  x <- gsub("(\\\n)", "", x)
  # 去掉制表符、双引号、单引号和 \'，如 'Hadley Wickham' 中的单引号 ' 等
  x <- gsub("(\\\t)|(\\\")|(\\\')|(')|(\\))", "", x)
  # Christian P. Robert, Universite Paris Dauphine, and Jean-Michel\n        Marin, Universite Montpellier 2
  x <- gsub("(and)", "", x)
  # 两个以上的空格替换为一个空格
  x <- gsub("( {2,})"," ",x)
  x
}

sub_pdb[, "Maintainer"] <- clean_maintainer(sub_pdb[, "Maintainer"])
sub_pdb[, "Author"] <- clean_author(sub_pdb[, "Author"])
```

维护多个 R 包的开发者数量


```r
length(unique(sub_pdb[, "Maintainer"][duplicated(sub_pdb[, "Maintainer"])]))
```

```
## [1] 3270
```

总的开发者中去掉开发了多个R包的人，就剩下只维护1个R包的开发者，共有 


```r
first_ctb <- setdiff(
  sub_pdb[, "Maintainer"][!duplicated(sub_pdb[, "Maintainer"])],
  unique(sub_pdb[, "Maintainer"][duplicated(sub_pdb[, "Maintainer"])])
)
```

按照每个R包贡献者的数量分组，如图所示，有一个或者没有贡献者的占总数占 70.60\%，说明这些 R 包的开发者基本在单干，有 4 个及以下的贡献者占总数（这个总数是指只开发了一个R包的那些开发者）的 90.85\%。


```r
ctb_num <- unlist(
  lapply(
    strsplit(
      subset(sub_pdb,
             subset = sub_pdb[, "Maintainer"] %in% first_ctb,
             select = "Author", drop = TRUE # drop out data.frame return vector
      ),
      split = ","
    ), length
  )
)

hist(ctb_num, col = "lightblue", border = "white", 
     probability = TRUE, labels = TRUE,
     xlab = "# of Contributors", ylab = "Proportion", main = "",
     panel.first = grid(), xlim = c(0, 100))
```



\begin{center}\includegraphics{case-study_files/figure-latex/unnamed-chunk-36-1} \end{center}

这些基本单干的R包开发者是否参与其它 R 包的贡献？如果不参与，则他们对社区的贡献非常有限，仅限于为社区带来数量上的堆积！


```r
table(ctb_num)
```

```
## ctb_num
##    1    2    3    4    5    6    7    8    9   10   11   12   13   14   15   16 
## 3039 1411  938  580  284  164  106   59   43   28   15   11    6   10    5    4 
##   17   18   19   20   22   23   24   26   27   28   56   60  133 
##    7    4    3    3    1    3    1    1    1    1    1    1    1
```

有意思的是，有一个开发者虽然只开发了一个 R 包，但是却引来37位贡献者（包括开发者本人在内），下面把这个颇受欢迎的 R 包找出来


```r
# 找到开发者
first_ctb[which.max(ctb_num)]
```

```
## [1] "Ryan Curtin"
```

```r
# 找到 R 包
subset(sub_pdb, subset = grepl("Matt Dowle", sub_pdb[, "Maintainer"]), select = "Package")
```

```
##         Package
## 3184 data.table
```

哇，大名鼎鼎的 [data.table](https://github.com/Rdatatable/data.table) 包！！ I JUST find it!! 这是个异数，我们知道 data.table 在R社区享有盛名，影响范围很广，从 Matt Dowle 的 [Github 主页](https://github.com/mattdowle) 来看，他确实只开发了这一个 R 包！黑天鹅在这里出现了！如果按照谁的贡献者多谁影响力大的规律来看，有 10 个以上贡献者的其它几个 R 包也必定是名器！这里留给读者把它找出来吧！

### 贡献关系网络 {#Contribution-Network}

<!-- 综合上面的分析，社区的主要推动者是余下的 1/3，他们相互之间的合作应该比较多，我们接下来想分析一下他们之间的贡献网络。 -->

接下来进入本节最核心的部分，分析所有的开发者之间的贡献网络，在第\@ref(first-commit)节清理 Author 字段的正则表达式几乎不可能覆盖到所有的情况，所以既然 Maintainer 字段是比较好清理的，不妨以它作为匹配的模式去匹配 Author 字段，这样做的代价就是迭代次数会很多，增加一定的计算负担，但是为了更加准确的清理结果，也是拼了！


```r
net_pdb <- subset(pdb, select = c("Maintainer", "Author"))
net_pdb[, "Maintainer"] <- clean_maintainer(net_pdb[, "Maintainer"])
total_maintainer <- unique(net_pdb[, "Maintainer"])
clean_author <- function(maintainer) {
  sapply(net_pdb[, "Author"], grepl, pattern = paste0("(", maintainer, ")"))
}
```

接下来是非常耗时的一步，实际是两层循环 1.2 亿次左右的查找计算， `grepl` 耗时 30分钟左右，正则表达式本身的性能优化问题，`maintainer_author` 逻辑型矩阵占用内存空间 430 M 左右


```r
maintainer_author <- Reduce("cbind", lapply(total_maintainer, clean_author))
colnames(maintainer_author) <- total_maintainer
rownames(maintainer_author) <- net_pdb[, "Maintainer"]
```

为了重复运行这段耗时很长的代码，我们将中间结果保存到磁盘，推荐保存为 R 支持的序列化后的数据格式 `*.rds`，相比于 `*.csv` 格式能极大地减少磁盘存储空间，读者可运行下面两行保存数据的代码，比较看看！ 


```r
saveRDS(maintainer_author, file = "data/maintainer_author.rds")
write.table(maintainer_author,file = "data/maintainer_author.csv", row.names = TRUE, col.names = TRUE)
```


查看 `maintainer_author` 数据集占用内存空间的大小


```r
format(object.size(maintainer_author), units = "auto")
```

看几个数字，R 包贡献者最多的有 62 人,这个 R 包的粉丝是真多！有一个开发者对 137 个 R 包的做出过贡献，其中包括自己开发的 R 包，快来快来抓住他！


```r
max(rowSums(maintainer_author))
max(colSums(maintainer_author))
```

继续看看每个开发者对外贡献的量的分布情况，由图可知，绝大部分开发者对外输出不超过 3，其表示对其它 R 包的贡献不超过 3个


```r
hist(colSums(maintainer_author)[colSums(maintainer_author) <= 10], 
     probability = FALSE, xlab = "", main = "")
```

每个 R 包参与贡献的人数分布又是如何呢？如图所示，基本集中在1~2个人的样子


```r
hist(rowSums(maintainer_author)[rowSums(maintainer_author) <= 20], 
     xlab = "", main = "",probability = FALSE)
```

好了，接下来我们要深入挖掘贡献协作网络中的结构特点，看看是不是由几位领导人在完全掌控，还有一大群人其实是自己搞自己的那点事，写论文、发布 R 包、投稿等如此循环。其实这就是 R 社区的特点，也决定了它不会像 Python 那样应用性强，有足够多的工程开发人员加入。大多数人写 R 包只是为了配合发论文而已，并不关心有没有人来用自己的 R 包！此外，没有人来做功能整合和持续维护，所以发展缓慢！各自造轮子的事情太多！

接着，先从表面看看开发者和贡献者的关系矩阵，`maintainer_author` 是一个大型的超稀疏矩阵，非零元素最多的行、列分别只占 0.79\% 和 0.95\%，都不到百分之一。


```r
# 非零元素最多的行
max(rowMeans(maintainer_author))
# 非零元素最多的列
max(colMeans(maintainer_author))
```

> 用稀疏索引的方式重新编码矩阵，然后用[社群检测的算法][community-detection]找到其中的结构，网络关系图用 Gephi 画，igraph 肯定是不行了，参考文献 [社会网络分析：探索人人网好友推荐系统](https://cosx.org/2011/04/exploring-renren-social-network) 网络的统计建模分析 [^statnet]

重新获取 `maintainer_author` 矩阵，存储指标向量，然后调用 Matrix 生成稀疏矩阵，后续的数据操作就好办了，因为 Matrix 包是内置的，它定义的稀疏矩阵类其它 R 包也都支持。先以一个简单的例子说明构造稀疏矩阵的过程


```r
library(Matrix)
spM <- spMatrix(3, 4, i = c(1, 1, 2, 3, 3), 
                j = c(4, 1, 2, 1, 3),
                x = c(4, 4, 1, 4, 8))
spM
```

```
## 3 x 4 sparse Matrix of class "dgTMatrix"
##             
## [1,] 4 . . 4
## [2,] . 1 . .
## [3,] 4 . 8 .
```

```r
image(spM)
```

\begin{figure}

{\centering \includegraphics[width=0.75\linewidth]{case-study_files/figure-latex/vis-sparse-mat-1} 

}

\caption{稀疏矩阵的图表示}(\#fig:vis-sparse-mat)
\end{figure}

`i` 和 `j` 表示矩阵中有值的位置，`x` 表示对应位置上的值，`i`，`j` 和 `x` 是三个长度相等的数值型向量，我们还可以调用 `image `函数，把稀疏矩阵可视化出来，对于大型稀疏矩阵可视化其稀疏模式是重要的。

> 贡献网络可视化 [^intro-igraph]


```r
clean_net_pdb <- function(maintainer) {
  index <- clean_author(maintainer)
  if (sum(index) == 0) {
    return(NULL)
  }
  data.frame(
    from_id = maintainer,
    to_id = net_pdb[, "Maintainer"][index],
    stringsAsFactors = FALSE
  )
}
```


```r
# maintainer_author <- data.table::rbindlist(lapply(total_maintainer, clean_net_pdb))
# saveRDS(maintainer_author, file = "data/maintainer_author.rds")
toc <- system.time({
  maintainer_author_net <- Reduce("rbind", lapply(total_maintainer, clean_net_pdb))
}, gcFirst = TRUE)
```


分组统计开发者之间贡献次数，从开发者到


```r
maintainer_author_net$weight <- 1
edges <- aggregate(weight ~ from_id + to_id, data = maintainer_author_net, sum)

dup_edges <- edges[edges[, 1] != edges[, 2], ]

library(geomnet)
ggplot(data = dup_edges, aes(from_id = from_id, to_id = to_id)) +
  geom_net(aes(linewidth = weight),
    layout.alg = "kamadakawai",
    labelon = FALSE, directed = TRUE, show.legend = FALSE, ealpha = 1,
    ecolour = "grey70", arrowsize = 0.1, size = 0.5
  ) +
  theme_net()
```



```r
# https://smallstats.blogspot.jp/2012/12/loading-huge-graphs-with-igraph-and-r.html
library(igraph)
# 贡献矩阵
ctb_df <- graph.data.frame(maintainer_author, directed = TRUE)

vertex.attrs <- list(name = unique(c(ctb_df$from_id, ctb_df$to_id)))
edges <- rbind(
  match(ctb_df$from_id, vertex.attrs$name),
  match(ctb_df$to_id, vertex.attrs$name)
)

ctb_net <- graph.empty(n = 0, directed = T)
ctb_net <- add.vertices(ctb_net, length(vertex.attrs$name), attr = vertex.attrs)
ctb_net <- add.edges(ctb_net, edges)
```

[community-detection]: https://bommaritollc.com/2012/06/17/summary-community-detection-algorithms-igraph-0-6/

[^statnet]: Statistical Modeling of Networks in R <https://user2010.org/Invited/handcockuser2010.pdf>
[^intro-igraph]: Network Analysis and Visualization with R and igraph <https://kateto.net/networks-r-igraph> with [PDF](https://kateto.net/wp-content/uploads/2016/01/NetSciX_2016_Workshop.pdf)




### 更新知多少 {#CRAN-Update-Packages}

这节标题取其字面意思表达 CRAN 服务器的特殊日子 2012-10-29，那天 CRAN 更新了一大波 R 包，像一根擎天柱一样支撑这幅图！


```r
update_pdb <- pdb[, c("Package", "Published")]
# 这天要更新的R包最多
sort(table(update_pdb[,"Published"]), decreasing = TRUE)[1]
```

```
## 2012-10-29 
##         87
```

```r
ggplot(update_pdb, aes(as.Date(Published))) +
  geom_bar(color = "skyblue4") +
  geom_line(
    data = data.frame(
      date = as.Date(c("2011-01-01", "2012-10-20")),
      count = c(80, 87)
    ), aes(x = date, y = count),
    arrow = arrow(angle = 15, length = unit(0.15, "inches"))
  ) +
  annotate("text", x = as.Date("2010-11-01"), y = 75, label = "(2012-10-29,87)") +
  scale_x_date(date_breaks = "1 year", date_labels = "%Y") +
  labs(x = "Published Date", y = "Count") +
  theme_minimal()
```

\begin{figure}

{\centering \includegraphics{case-study_files/figure-latex/pdb-update-history-1} 

}

\caption{R 包更新历史}(\#fig:pdb-update-history)
\end{figure}

当日发布的R包，不论是新增还是更新之前发布的R包都视为最新版，当日之前的都是旧版本，它们可能存在已经修复的 BUG！这句子好奇怪是吧，因为很多 R 包要么托管在 Github 上，要么托管在 [R-Forge](https://r-forge.r-project.org/) 上开发，而 CRAN 上的版本除了发布日外，一般来讲都会落后。如图所示待更新的 R 包在日期上的分布，有的已经10来年没有更新了，最老的 R 包可以追溯到 2006-03-15，它是 coxrobust！！


```r
subset(update_pdb, subset = update_pdb[, "Published"] == min(update_pdb[, "Published"]))
```

```
##        Package  Published
## 2835 coxrobust 2006-03-15
```

```r
update_pdb[which.min(as.Date(update_pdb[, "Published"])), 1]
```

```
## [1] "coxrobust"
```

### 使用许可证 {#Package-Licenses}

> 列举 R 社区使用的许可证及其区别和联系
R 开源还体现在许可证信息，顺便谈谈美国和中国技术封锁，开源社区可能面临的风险

社区主要使用 GPL 及其相关授权协议，因为 R 软件本身也是授权在 GPL-2 或 GPL-3 下


```r
license_pdb <- head(sort(table(pdb[, "License"]), decreasing = TRUE), 20)
par(mar = c(2, 12, 0.5, 0))
plot(c(1, 1e1, 1e2, 1e3, 1e4), c(1, 5, 10, 15, 20),
     type = "n",panel.first = grid(),
     ann = FALSE, log = "x", axes = FALSE
)
axis(1,
     at = c(1, 1e1, 1e2, 1e3, 1e4),
     labels = expression(1, 10^1, 10^2, 10^3, 10^4)
)
text(
  y = seq(length(license_pdb)), x = 1, cex = 1, offset = 1,
  pos = 2, labels = names(license_pdb), xpd = TRUE
)
text(1e3, 15, "CRAN")
segments(x0 = 1, y0 = seq(length(license_pdb)), 
         x1 = license_pdb, y1 = seq(length(license_pdb)), 
         col = "lightblue", lwd = 4)
```

\begin{figure}

{\centering \includegraphics{case-study_files/figure-latex/license-cran-1} 

}

\caption{CRAN 上采用的发布协议}(\#fig:license-cran)
\end{figure}



```r
rforge_pdb <- available.packages(repos = "https://R-Forge.R-project.org")
license_rforge_pdb <- head(sort(table(rforge_pdb[, "License"]), decreasing = TRUE), 20)
par(mar = c(2, 12, 0.5, 0))
plot(c(1, 1e1, 1e2, 1e3), seq(from = 1, to = 20,length.out = 4),
  type = "n",panel.first = grid(),
  ann = FALSE, log = "x", axes = FALSE
)
axis(1,
  at = c(1, 1e1, 1e2, 1e3),
  labels = expression(1, 10^1, 10^2, 10^3)
)

text(
  y = seq(length(license_rforge_pdb)), x = 1, cex = 1, offset = 1,
  pos = 2, labels = names(license_rforge_pdb), xpd = TRUE
)
text(1e2, 15, "R-Forge")
segments(x0 = 1, y0 = seq(length(license_rforge_pdb)), 
         x1 = license_rforge_pdb, y1 = seq(length(license_rforge_pdb)), 
         lwd = 4, col = "lightblue")
```

\begin{figure}

{\centering \includegraphics{case-study_files/figure-latex/license-rforge-1} 

}

\caption{R-Forge 开发者采用的发布协议}(\#fig:license-rforge)
\end{figure}


> 改进的方向是含义相同的进行合并，这需要研究一下各个许可证，然后使用对比型条形图合并上面两个图

CRAN 会检测 R 包的授权，只有授权协议包含在数据库中的才可以在 CRAN 上发布 <https://svn.r-project.org/R/trunk/share/licenses/license.db>

### 选择 R 包 {#Choose-Package}

R 社区开发的 R 包实在太多了，重复造的轮子也很多，哪个轮子结实好用就选哪个，挑选合适的 R 包


```r
# remotes::install_github("ropenscilabs/packagemetrics")
library(formattable)
library(packagemetrics)
packages <- subset(pdb, Maintainer == maintainer("rmarkdown"), select = "Package")

pdb_metrics <- apply(packages, 1, combine_metrics)
pdb_metrics <- data.table::rbindlist(pdb_metrics, fill = TRUE)

pd = subset(pdb_metrics, select = c("package", "published", "dl_last_month",
    "stars", "forks", "last_commit",
    "depends_count", "watchers")
  ) |> 
  transform(last_commit = round(last_commit, 1))

pd[is.na(pd)] <- ""

formattable(
  pd,
  list(
    package = formatter("span",
      style = x ~ style(font.weight = "bold")
    ),
    contributors = color_tile("white", "#1CC2E3"),
    depends_count = color_tile("white", "#1CC2E3"),
    reverse_count = color_tile("white", "#1CC2E3"),
    tidyverse_happy = formatter("span",
      style = x ~ style(color = ifelse(x, "purple", "white")),
      x ~ icontext(ifelse(x, "glass", "glass"))
    ),
    vignette = formatter("span",
      style = x ~ style(color = ifelse(x, "green", "white")),
      x ~ icontext(ifelse(x, "ok", "ok"))
    ),
    has_tests = formatter("span",
      style = x ~ style(color = ifelse(x, "green", "red")),
      x ~ icontext(ifelse(x, "ok", "remove"))
    ),
    dl_last_month = color_bar("#56A33E"),
    forks = color_tile("white", "#56A33E"),
    stars = color_tile("white", "#56A33E"),
    last_commit = color_tile("#F06B13", "white", na.rm = T)
  )
)
```




### R 包增长速度 {#pkg-growth}


```r
# 抓取网页数据
pkgs <- pdb |>
  transform(count = rev(1:nrow(pdb)), Date = as.Date(Date)) |>
  transform(Month = format(Date, format = "%Y-%m"))

pkgs <- aggregate(formula = count ~ Month, data = pkgs, FUN = min)

pkgs <- transform(pkgs, Date = as.Date(paste(Month, "-01", sep = ""))) %>%
  subset(Date > as.Date("2012-12-31"))

# 计算自2013年以来 R 包增长速度
new_pkgs <- pkgs %>%
  subset(Date > as.Date("2012-12-31")) %>%
  transform(publishedGrowth = c(tail(.$count, -1), NA) / count) %>%
  transform(counter = 1:nrow(.))

# 绘图
library(ggplot2)
library(grid)

gg <- ggplot(pkgs, aes(x = Date, y = count)) +
  geom_line(size = 1.5) +
  scale_y_log10(
    breaks = c(0, 10, 100, 1000, 10000),
    labels = c("1", "10", "100", "1.000", "10.000")
  ) +
  labs(
    x = "", y = "# Packages (log)",
    title = "Packages published on CRAN ever since"
  ) +
  theme_minimal(base_size = 14, base_family = "sans") +
  theme(panel.grid.major.x = element_blank()) +
  geom_hline(yintercept = 0, size = 1, colour = "#535353")

gg2 <- ggplot(new_pkgs, aes(x = Date, y = count)) +
  geom_line(size = 1) +
  geom_line(
    data = new_pkgs, aes(y = (min(count) * 1.048^counter)),
    color = "red", size = .7, linetype = 1
  ) +
  annotate("segment",
    x = as.Date("2015-04-01"), xend = as.Date("2015-08-01"),
    y = 1000, yend = 1000, colour = "red", size = 1
  ) +
  annotate("text",
    x = as.Date("2016-12-01"),
    y = 1000, label = "4.6% growth estimation", size = 3.5
  ) +
  scale_y_continuous(
    breaks = seq(from = 0, to = 12000, by = 2000),
    labels = seq(from = 0, to = 12000, by = 2000)
  ) +
  labs(
    y = "# Packages", x = "",
    subtitle = "Packages published on CRAN since 2013"
  ) +
  theme_minimal(
    base_size = 11, base_family = "sans"
  ) +
  theme(panel.grid.major.x = element_blank()) +
  geom_hline(yintercept = 0, size = .6, colour = "#535353")

gg
print(gg2, vp = viewport(.70, .31, .43, .43))
```

