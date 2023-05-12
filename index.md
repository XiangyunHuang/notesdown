--- 
title: "R 语言学习笔记"
author: "黄湘云"
date: "2023-05-12"
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
本书采用 [知识共享署名-非商业性使用-禁止演绎 4.0 国际许可协议](https://creativecommons.org/licenses/by-nc-nd/4.0/) 许可，请君自重，别没事儿拿去传个什么新浪爱问、百度文库以及 XX 经济论坛，项目中代码使用 [MIT 协议](https://github.com/XiangyunHuang/notesdown/blob/master/LICENSE) 开源
:::

<img src="images/cc-by-nc-nd.png" width="15%" style="display: block; margin: auto auto auto 0;" />


本书 R Markdown 源文件托管在 Github 仓库里，本地使用 RStudio IDE 编辑，bookdown 组织各个章节的 Rmd 文件和输出格式，使用 Git 进行版本控制。每次提交修改到 Github 上都会触发 Travis 自动编译书籍，将一系列 Rmd 文件经 knitr 调用 R 解释器执行里面的代码块，并将输出结果返回，Pandoc 将 Rmd 文件转化为 md 、 html 或者 tex 文件。若想输出 pdf 文件，还需要准备 TeX 排版环境，最后使用 Netlify 托管书籍网站，和 Travis 一起实现连续部署，使得每次修改都会同步到网站。最近一次编译时间 2023年05月12日21时27分58秒，本书用 R version 4.2.3 (2023-03-15) 编译，完整运行环境如下：


```r
xfun::session_info(packages = c(
  "knitr", "rmarkdown", "bookdown"
), dependencies = FALSE)
```

```
## R version 4.2.3 (2023-03-15)
## Platform: x86_64-pc-linux-gnu (64-bit)
## Running under: Ubuntu 22.04.2 LTS
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
##   bookdown_0.34  knitr_1.42     rmarkdown_2.21
## 
## Pandoc version: 2.16.2
```

借助 **bookdown** [@xie2016] 可以将 Rmd 文件组织起来， **rmarkdown** [@rmarkdown]和 **knitr** [@xie2015] 将源文件编译成 Markdown 文件， [Pandoc](https://pandoc.org/) 将 Markdown 文件转化成 HTML 和 TeX 文件， [TinyTeX](https://yihui.name/tinytex/) [@xie2019] 可以将 TeX 文件进一步编译成 PDF 文档，书中大量的图形在用 **ggplot2** 包制作 [@Wickham_2016_ggplot2]，而统计理论相关的示意图用 Base R 创作。

正文中的代码、函数、参数及参数值以等宽正体表示，如 `data(list = c('iris', 'BOD'))`{.R}，
其中函数名称 `data()`，参数及参数值 `list = c('iris', 'BOD')`{.R} ，R 程序包用粗体表示，如 **graphics**。
