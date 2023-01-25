--- 
title: "R 语言学习笔记"
author: "黄湘云"
date: "2023-01-25"
site: bookdown::bookdown_site
documentclass: book
papersize: a4
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
cover-image: images/cover.png
---


\mainmatter

# 欢迎 {#welcome .unnumbered}

\chaptermark{欢迎}

::: {.rmdwarn data-latex="{警告}"}
Book in early development. Planned release in 202X. 
:::





## 如何发问 {#sec-help-me .unnumbered}


> The phrase "does not work" is not very helpful, it can mean quite a few things including:
> 
* Your computer exploded.
* No explosion, but smoke is pouring out the back and microsoft's "NoSmoke" utility is not compatible with your power supply.
* The computer stopped working.
* The computer sits around on the couch all day eating chips and watching talk shows.
* The computer has started picketing your house shouting catchy slogans and demanding better working conditions and an increase in memory.
* Everything went dark and you cannot check the cables on the back of the computer because the lights are off due to the power outage.
* R crashed, but the other programs are still working.
* R gave an error message and stopped processing your code after running for a while.
* R gave an error message without running any of your code (and is waiting for your next command).
* R is still running your code and the time has exceeded your patience so you think it has hung.
* R completed and returned a result, but also gave warnings.
* R completed your command, but gave an incorrect answer.
* R completed your command but the answer is different from what you expect (but is correct according to the documentation).
> 
> There are probably others. Running your code I think the answer is the last one.
>
> --- Greg Snow [^GS-help-2012]

[^GS-help-2012]: 来自 R 社区论坛收集的智语 `fortunes::fortune(324)`。

R 社区提供了丰富的帮助资源，可以在 R 官网搜集的高频问题 <https://cran.r-project.org/faqs.html> 中查找，也可在线搜索 <https://cran.r-project.org/search.html> 或 <https://rseek.org/> ，更多获取帮助方式见 <https://www.r-project.org/help.html>。爆栈网问题以标签分类，比如 [r-plotly](https://stackoverflow.com/questions/tagged/r-plotly)、[r-markdown](https://stackoverflow.com/questions/tagged/r-markdown)、 [data.table](https://stackoverflow.com/questions/tagged/data.table) 和 [ggplot2](https://stackoverflow.com/questions/tagged/ggplot2)，还可以关注一些活跃的社区大佬，比如 [谢益辉](https://stackoverflow.com/users/559676/yihui-xie)。

## 授权说明 {#sec-licenses .unnumbered}

::: {.rmdwarn data-latex="{警告}"}
本书采用 [知识共享署名-非商业性使用-禁止演绎 4.0 国际许可协议](https://creativecommons.org/licenses/by-nc-nd/4.0/) 许可，请君自重，别没事儿拿去传个什么新浪爱问、百度文库以及 XX 经济论坛，项目中代码使用 [MIT 协议](https://github.com/XiangyunHuang/notesdown/blob/master/LICENSE) 开源
:::

<img src="images/cc-by-nc-nd.png" width="15%" style="display: block; margin: auto auto auto 0;" />

## 运行信息 {#sec-session-welcome .unnumbered}

本书 R Markdown 源文件托管在 Github 仓库里，本地使用 RStudio IDE 编辑，bookdown 组织各个章节的 Rmd 文件和输出格式，使用 Git 进行版本控制。每次提交修改到 Github 上都会触发 Travis 自动编译书籍，将一系列 Rmd 文件经 knitr 调用 R 解释器执行里面的代码块，并将输出结果返回，Pandoc 将 Rmd 文件转化为 md 、 html 或者 tex 文件。若想输出 pdf 文件，还需要准备 TeX 排版环境，最后使用 Netlify 托管书籍网站，和 Travis 一起实现连续部署，使得每次修改都会同步到网站。最近一次编译时间 2023年01月25日11时16分01秒，本书用 R version 4.2.2 (2022-10-31) 编译，完整运行环境如下：


```r
xfun::session_info(packages = c(
  "knitr", "rmarkdown", "bookdown"
), dependencies = FALSE)
```

```
## R version 4.2.2 (2022-10-31)
## Platform: x86_64-pc-linux-gnu (64-bit)
## Running under: Ubuntu 22.04.1 LTS
## 
## Locale:
##   LC_CTYPE=en_US.UTF-8       LC_NUMERIC=C              
##   LC_TIME=en_US.UTF-8        LC_COLLATE=en_US.UTF-8    
##   LC_MONETARY=en_US.UTF-8    LC_MESSAGES=en_US.UTF-8   
##   LC_PAPER=en_US.UTF-8       LC_NAME=C                 
##   LC_ADDRESS=C               LC_TELEPHONE=C            
##   LC_MEASUREMENT=en_US.UTF-8 LC_IDENTIFICATION=C       
## 
## Package version:
##   bookdown_0.26  knitr_1.39     rmarkdown_2.14
## 
## Pandoc version: 2.16.2
```

借助 **bookdown** [@xie2016] 可以将 Rmd 文件组织起来， **rmarkdown** [@rmarkdown]和 **knitr** [@xie2015] 将源文件编译成 Markdown 文件， [Pandoc](https://pandoc.org/) 将 Markdown 文件转化成 HTML 和 TeX 文件， [TinyTeX](https://yihui.name/tinytex/) [@xie2019] 可以将 TeX 文件进一步编译成 PDF 文档，书中大量的图形在用 **ggplot2** 包制作 [@Wickham_2016_ggplot2]，而统计理论相关的示意图用 Base R 创作。

## 记号约定 {#sec-conventions .unnumbered}

正文中的代码、函数、参数及参数值以等宽正体表示，如 `data(list = c('iris', 'BOD'))`{.R}，
其中函数名称 `data()`，参数及参数值 `list = c('iris', 'BOD')`{.R} ，R 程序包用粗体表示，如 **graphics**。

## 作者简介 {#sec-about-author .unnumbered}

热心开源事业，统计之都编辑，经常混迹于统计之都论坛、Github 和爆栈网。个人主页 <https://xiangyun.rbind.io/>
