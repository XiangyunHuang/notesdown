# 生存分析 {#chap-survival-analysis}



> The fact that some people murder doesn't mean we should copy them. And murdering data, though not as serious, should also be avoided.
>
>   --- Frank E. Harrell [^FH-help-2005-II]

[^FH-help-2005-II]: <https://stat.ethz.ch/pipermail/r-help/2005-July/075649.html>


R 软件内置了 [**survival**包](https://github.com/therneau/survival) 它是实现生存分析的核心 R 包。文档见 <https://cran.r-project.org/package=survival> 相关书籍见 @Therneau_2000_Modeling

[survminer](https://github.com/kassambara/survminer) 竟然严重依赖 [**ggpubr** 包](https://github.com/kassambara/ggpubr)，ggpubr 包曾被 [ggtree](https://github.com/YuLab-SMU/ggtree) 的作者[余光创](https://guangchuangyu.github.io/)严重[吐槽过](https://guangchuangyu.github.io/2019/12/why-hate-ggpubr/)。[**ggfortify**包](https://github.com/sinhrks/ggfortify) 大大扩展了 **ggplot2** 包的 `autoplot()` 函数，使得它适应各种模型对象的自动绘图。

## 急性粒细胞白血病生存数据 {#sec-aml}



```r
library(survival)
leukemia.surv <- survfit(Surv(time, status) ~ x, data = aml)
library(ggfortify)
autoplot(leukemia.surv, data = aml) +
  theme_minimal()
```

\begin{figure}

{\centering \includegraphics{survival-analysis_files/figure-latex/aml-1} 

}

\caption{急性粒细胞白血病生存数据}(\#fig:aml)
\end{figure}
