--- 
title: "现代应用统计与 R 语言"
subtitle: "Modern Applied Statistics with R"
author: "黄湘云"
date: "2021-10-20"
site: bookdown::bookdown_site
documentclass: book
papersize: b5
fontsize: 10pt
graphics: yes
colorlinks: yes
lot: yes
lof: yes
mathspec: yes
geometry:
  - tmargin=2.5cm
  - bmargin=2.5cm
  - lmargin=3.0cm
  - rmargin=2.0cm
classoption: "UTF8,twoside,openany,table"
bibliography: 
  - book.bib
  - packages.bib
link-citations: yes
csl: ieee.csl
hyperrefoptions:
  - linktoc=all
  - pdfstartview=FitH # 适合宽度
  - bookmarksnumbered=true # 书签带编号
keywords: 
  - 现代统计
  - 机器学习
  - 深度学习
  - 抽样分布
  - 参数估计
  - 假设检验
  - 预测
  - 线性模型
  - 极大似然估计
  - 最小二乘估计
  - 矩估计
  - 似然比检验 Wilks
  - Wald 检验
  - Score 检验 Rao
  - R 语言
subject: "现代应用统计与 R 语言"
description: "线性模型理论及其应用，注意模型的适用范围、参数估计方法、模型检验和诊断，理论和应用并重，同时附以真实的案例分析。将线性模型、广义线性模型、广义可加模型、线性混合效应模型、广义线性混合效应模型和广义可加混合效应模型融合到同一框架下。应用层面，要考虑数据集的平衡问题、缺失问题和异常问题。应用场景包括环境污染、流行病学和风险控制等领域。"
cover-image: images/cover.png
---


\mainmatter

# 欢迎 {#welcome .unnumbered}

\chaptermark{欢迎}

::: {.rmdwarn data-latex="{警告}"}
Book in early development. Planned release in 202X. 
:::




## 本书风格 {#sec-style .unnumbered}

\index{置信区间}
\index{信仰区间}
\index{统计功效}

可以说，点估计、区间估计、假设检验、统计功效是每一个学数理统计的学生都绕不过去的坎，离开学校从事数据相关的工作，它们仍然是必备的工具。所以，本书会覆盖相关内容，但是和高校的教材最大的区别是更加注重它们之间的区别和联系，毕竟每一个统计概念都是经过了千锤百炼，而我们的主流教材始终如一地遵循的一个基本套路，就是突然给出一大堆定义、命题或定理，紧接着冗长的证明过程，然后给出一些难以找到实际应用背景的例子。三板斧抡完后就是给学生布置大量的习题，这种教学方式无论对于立志从事理论工作的还是将来投身于工业界的学生都是不合适的。

> 极大似然估计最初由德国数据学家 Gauss 于 1821 年提出，但未得到重视，后来， R. A. Fisher 在 1922 年再次提出极大似然的思想，探讨了它的性质，使它得到广泛的研究和应用。[@Prob_2006_Mao]

这是国内某著名数理统计教材在极大似然估计开篇第一段的内容，后面是各种定义、定理、公式推导。教材简短一句话，这里面有很多信息值得发散，一个数学家提出了统计学领域极其重要的一个核心思想，他是在研究什么的时候提出了这个想法，为什么后来没有得到重视，整整 100 年以后，Fisher 又是怎么提出这一思想的呢？他做了什么使得这个思想被广泛接受和应用？虽然这可能有点离题，但是读者可以获得很多别的启迪，要知道统计领域核心概念的形成绝不是一蹴而就的，这一点也绝不局限于统计科学，任何一门科学都是这样的，比如物理学之于光的波粒二象性。历史上，各门各派的学者历经多年的思想碰撞才最终沉淀出现在的结晶。笔者认为，学校要想培养出有原创理论创新的人才，在对待前辈的成果上，我们要不吝笔墨和口水，传道不等于满堂灌和刷分机，用寥寥数节课或者数页纸来梳理学者们几十年乃至上百年的智慧结晶是非常值得的，我们甚至可以从当时的社会、人文去剖析。非常欣赏有人在收集关于统计学历史的材料，读者不妨去看看 <https://github.com/sctyner/history_of_statistics>。 另一个不得不提的人是 [Allison Horst](https://www.allisonhorst.com/)，她以风趣幽默的漫画形式，以画龙点睛之手法勾勒出基本的统计概念和思想，详见 <https://github.com/allisonhorst/stats-illustrations>，是我见过最好的科普读物。

\index{统计分布}

Bradley Efron 在他的课程中谈及现代统计的研究层次，第一层次是基于正态分布假设的，这种类型已经研究的很清楚了，往往可以得到精确的结果，第二层次是将正态分布推广到指数族，这种类型的也研究的比较多了，常见的情况都研究的比较清楚，罕见的情况也是大量存在的，特别是在实际应用当中，总的来说只能得到部分精确的结果，第三层次对分布没有任何限定，只要满足成为一个统计分布的条件，这种情况下就只能求助于一般的数学工具和渐进理论。

\begin{figure}

{\centering \includegraphics{index_files/figure-latex/stats-level-1} 

}

\caption[(ref:stats-level-s)]{(ref:stats-level)}(\#fig:stats-level)
\end{figure}

(ref:stats-level-s) 现代统计建模的三重境界

(ref:stats-level) 现代统计建模的三重境界：修改自 2019 年冬季 Bradley Efron 的课程笔记（第一部分） <http://statweb.stanford.edu/~ckirby/brad/STATS305B_Part-1_corrected-2.pdf>

\index{区间估计}

下面以区间估计为例，希望能为传道做一点事情。区间估计的意义是解决点估计可靠性问题，它用置信系数解决了对估计结果的信心问题，弥补了点估计的不足。置信系数是最大的置信水平。


区间半径这么长，区间估计的意义何在？增加样本量可以使得半径更短，那么至少应该有多少样本量才可以让估计变得有意义呢？就是说用估计比不用估计更好呢？答案是 39 个，留给读者思考一下为什么？读者可能已经注意到，置信带是关于点 $(5, 0.5)$ 中心对称的，这又是为什么，并且两头窄中间胖，像个酒桶？

::: {.rmdtip data-latex="{提示}"}
Base R 提供的 `uniroot()` 函数只能求取一元非线性方程的一个根，而 **rootSolve** 包提供的 `uniroot.all()` 函数可以求取所有的根。在给定分位点下，我们需要满足方程的最小的概率值。
:::

Base R 提供的 `binom.test()` 函数可以精确计算置信区间，而 `prop.test()` 函数可近似计算置信区间。


```r
# 近似计算 Wilson 区间
prop.test(x = 2, n = 10, p = 0.95, conf.level = 0.95, correct = TRUE)
## Warning in prop.test(x = 2, n = 10, p = 0.95, conf.level = 0.95, correct =
## TRUE): Chi-squared approximation may be incorrect
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
# 精确计算
binom.test(x = 2, n = 10, p = 0.95, conf.level = 0.95)
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


(ref:pbinom) 二项分布 $B(n,\theta)$ 成功概率 $\theta$，固定样本量 $n = 10$，分不同的分位点 $q = 2, 4, 6$ 绘制概率随成功概率 $\theta$ 的变化

\begin{figure}

{\centering \includegraphics{index_files/figure-latex/pbinom-1} 

}

\caption{(ref:pbinom)}(\#fig:pbinom)
\end{figure}

实际达到的置信度水平随真实的未知参数值和样本量的变化而**剧烈**波动，这意味着这种参数估计方法在实际应用中不可靠、真实场景中参数真值是永远未知的，样本量是可控的，并且是可以变化的。根本原因在于这类分布是离散的，比如这里的二项分布。当数据 $x$ 是离散的情况，置信区间的端点$\ell(x)$ 和 $u(x)$ 也是离散的。这种缺陷是无法避免的，清晰的置信区间和离散的数据之间存在无法调和的冲突。


<!-- 机器学习和统计学习本质上是一回事，计算机和统计学家各有所表。 -->

覆盖概率 $P_{\theta}(X = x)$ 和参数真值 $\theta$ 的关系 [@Lawrence2001;@Geyer2005]


以抛硬币为例，我来做这个实验，抛10次，7 次正面朝上，他做这个实验，也抛10 次，4 次正面朝上。换不同的人来做这个实验，结果会有所不同，实际上，总共有 2^10 = 1024 个结果，每个结果都可以用来估计未知的参数 $p$ 及其置信区间、覆盖概率。假设参数 $p$ 的真值是 0.7，抛10次，6 次正面朝上。先来模拟这个抛硬币的过程，重复抛了10次，是 10 重伯努利实验，正面朝上的累计次数服从二项分布 $B(10, 0.7)$，从此二项分布里抽样一次，相当于抛10次硬币，R 提供了模拟二项分布的函数 `rbinom()`，实现起来非常方便，为了模拟过程可重复，设置随机数种子为 2019。


```r
set.seed(2019)
rbinom(n = 1, size = 10, prob = 0.7)
```

```
## [1] 6
```

假设只知道抛了 10 次硬币，有 6 次正面朝上的结果，并不知道参数 $p$ 的真实值，现在做个假设，假设 $p = 0.7$，我们看看基于这样一次实验的数据，检验一下该假设是否成立。这是一个典型的二项检验，R 已经提供内置的函数 `binom.test()` 来实现，经计算，检验的 P 值，即样本落在拒绝域的概率是 0.4997，大于 0.05，所以原假设有一定合理性，不能拒绝。


```r
binom.test(x = 6, n = 10, p = 0.7, conf.level = 0.95)
```

```
## 
## 	Exact binomial test
## 
## data:  6 and 10
## number of successes = 6, number of trials = 10, p-value = 0.4997
## alternative hypothesis: true probability of success is not equal to 0.7
## 95 percent confidence interval:
##  0.2623781 0.8784477
## sample estimates:
## probability of success 
##                    0.6
```

比例的真实值 $p$ 落在区间 $(\hat{p} - Z_{1-\alpha/2} * \sqrt{\frac{\hat{p}(1-\hat{p})}{n}}, \hat{p} + Z_{1-\alpha/2} * \sqrt{\frac{\hat{p}(1-\hat{p})}{n}})$ 的概率是 0.95。


```r
c(
  0.6 - qnorm(p = 1 - 0.05 / 2, mean = 0, sd = 1) * sqrt(0.6 * (1 - 0.6) / 10),
  0.6 + qnorm(p = 1 - 0.05 / 2, mean = 0, sd = 1) * sqrt(0.6 * (1 - 0.6) / 10)
)
```

```
## [1] 0.2963637 0.9036363
```




```r
pnorm(q = 0.9036363) - pnorm(q = 0.2963637)
```

```
## [1] 0.200382
```



[多重比较与检验]{.todo}

多重比较 `p.adjust()` 函数 Adjust P-values for Multiple Comparisons 单因素多重比较 `oneway.test()`


```r
set.seed(123)
x <- rnorm(50, mean = c(rep(0, 25), rep(3, 25)))
p <- 2 * pnorm(sort(-abs(x)))
# ?p.adjust
round(p, 3)
```

```
##  [1] 0.000 0.000 0.000 0.000 0.000 0.000 0.000 0.000 0.000 0.000 0.001 0.002
## [13] 0.003 0.004 0.005 0.007 0.007 0.009 0.009 0.011 0.021 0.049 0.061 0.063
## [25] 0.074 0.083 0.086 0.119 0.189 0.206 0.221 0.286 0.305 0.466 0.483 0.492
## [37] 0.532 0.575 0.578 0.619 0.636 0.645 0.656 0.689 0.719 0.818 0.827 0.897
## [49] 0.912 0.944
```

```r
# round(p.adjust(p), 3)
# round(p.adjust(p, "BH"), 3)
```

[混合正态分布的参数估计]{.todo}

标准正态分布的概率密度函数 $f(x) = \frac{1}{\sqrt{2\pi}}e^{-\frac{x^2}{2}}$ 的图像见图\@ref(fig:god-play-games) 中的红线，非常的优美，然而，现实中的数据所呈现出来的却是另一翻景象，它们只是近似却永远也不会严丝合缝，这又是大自然神奇的地方，整体似乎有某种确定性的规律，局部又有不确定的随机扰动，横看成岭侧成峰，远近高低各不同。

\begin{figure}

{\centering \includegraphics[width=0.75\linewidth]{index_files/figure-latex/god-play-games-1} 

}

\caption{上帝在掷骰子吗？}(\#fig:god-play-games)
\end{figure}



[统计检验，决策风险，显著性水平]{.todo}


\begin{center}\includegraphics{index_files/figure-latex/ab-test-1} \end{center}

Charles J. Geyer 的文章 Fuzzy and Randomized Confidence Intervals and P-Values [@Geyer2005] 文章中的图 1 名义覆盖概率的计算见 [@Blyth1960]


## 本书定位 {#sec-audience .unnumbered}

学习本书需要读者具备基本的概率、统计知识，比如上过一学期的概率论和数理统计学，也需要读者接触过编程知识，比如至少上过一学期的 C 语言、Python 语言或 Matlab 语言。了解基本的线性代数，比如矩阵的加、减、乘、逆四则运算、线性子空间、矩阵的 LU、SVD、Eigen 等分解。

## 内容概要 {#sec-abstract .unnumbered}

第 \@ref(chap-preface) 章介绍本书的写作背景、语言环境、全书的记号约定、如何获取帮助、作者简介等信息。

第 \@ref(chap-notations) 章介绍全书的数学公式符号。

第 \@ref(chap-file-operations) 章介绍文件操作。

第 \@ref(chap-data-structure) 章介绍 R 语言的数据结构。

第 \@ref(chap-data-manipulation) 章介绍数据操作，包括 Base R 、**data.table** 和 **magrittr**。

第 \@ref(chap-data-transportation) 章介绍数据导入导出， **data.table** 之于 csv 文件， **openxlsx** 之于 xlsx 文件。

第 \@ref(chap-data-visualization) 章介绍数据可视化，分四个部分，基础元素、常用图形、字体和颜色设置。

第 \@ref(chap-document-elements) 章介绍动态文档，即 R Markdown 及其生态系统。

第 \@ref(chap-interactive-web-graphics) 章介绍交互图形，以常用的 **plotly** 和 **highcharter** 为主，重点介绍 R 和 JavaScript 库的对应关系。

第 \@ref(chap-interactive-data-tables) 章介绍交互表格，分两节介绍交互式的 **DT** 和 **reactable**，静态的 **gt** 和 **kableExtra**，掌握这几个 R 包足以应付日常工作。

第 \@ref(chap-interactive-shiny-app) 章介绍交互报表开发，符合工业标准的最佳实践。


## 致谢名单 {#sec-acknowledgments .unnumbered}

特别感谢 XX，还有很多人通过提交 PR 或 Issues 的方式参与了本书的创作过程，没有这一点一滴的持续改进，本书不会达到现在的样子，所以我将他们列在致谢名单中，详见表 \@ref(tab:acknowledgments)，人名按照提交量（commit 的个数）降序排列。



Table: (\#tab:acknowledgments) 致谢名单

贡献者        提交量
-----------  -------
Yadong Liu         1
Yihui Xie          1

::: {.flushright data-latex=""}
黄湘云  
于北京
:::


## 授权说明 {#sec-licenses .unnumbered}

::: {.rmdwarn data-latex="{警告}"}
本书采用 [知识共享署名-非商业性使用-禁止演绎 4.0 国际许可协议](https://creativecommons.org/licenses/by-nc-nd/4.0/) 许可，请君自重，别没事儿拿去传个什么新浪爱问、百度文库以及 XX 经济论坛，项目中代码使用 [MIT 协议](https://github.com/XiangyunHuang/masr/blob/master/LICENSE) 开源
:::


\begin{flushleft}\includegraphics[width=0.15\linewidth]{images/cc-by-nc-nd} \end{flushleft}

## 运行信息 {#sec-session-welcome .unnumbered}

书籍在 R version 4.1.1 (2021-08-10) 下编译，Pandoc 版本 2.14.1，最新一次编译发生在 2021-10-20 14:27:12。


