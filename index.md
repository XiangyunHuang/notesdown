--- 
title: "R 语言学习笔记"
author: "黄湘云"
date: "2022-06-04"
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







## 授权说明 {#sec-licenses .unnumbered}

::: {.rmdwarn data-latex="{警告}"}
本书采用 [知识共享署名-非商业性使用-禁止演绎 4.0 国际许可协议](https://creativecommons.org/licenses/by-nc-nd/4.0/) 许可，请君自重，别没事儿拿去传个什么新浪爱问、百度文库以及 XX 经济论坛，项目中代码使用 [MIT 协议](https://github.com/XiangyunHuang/notesdown/blob/master/LICENSE) 开源
:::


\begin{flushleft}\includegraphics[width=0.15\linewidth]{images/cc-by-nc-nd} \end{flushleft}

## 运行信息 {#sec-session-welcome .unnumbered}

书籍在 R version 4.2.0 (2022-04-22) 下编译，Pandoc 版本 2.16.2，最新一次编译发生在 2022-06-04 21:19:17。
