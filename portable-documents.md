# 便携式文档 {#chap-portable-document}

## 文档汉化 {#sec-chinese-document}

从 R Markdown 到 beamer 幻灯片，如何迁移 LaTeX 模版

默认的 PDF 文档 [PDF 文档案例](https://github.com/XiangyunHuang/masr/blob/master/examples/pdf-default.Rmd)

详见[PDF 文档案例](https://github.com/XiangyunHuang/masr/blob/master/examples/pdf-document.Rmd)

## 添加水印 {#sec-draft-watermark}

[draftwatermark](https://github.com/callegar/LaTeX-draftwatermark)

## 双栏排版 {#sec-two-column}

普通单栏排版改为双栏排版，只需添加文档类选项 `"twocolumn"`，将 YAML 元数据中的

```yaml
classoption: "UTF8,a4paper,fontset=adobe,zihao=false"
```

变为

```yaml
classoption: "UTF8,a4paper,fontset=adobe,zihao=false,twocolumn"
```

其中，参数 `UTF8` 设定文档编码类型， `a4paper` 设置版面为 A4 纸大小，`fontset=adobe` 指定中文字体为 Adobe 字体，`zihao=false` 不指定字体大小，使用文档类 ctexart 默认的字号,

## 参数化报告 {#sec-parameterized-reports}

[参数化文档案例](https://github.com/XiangyunHuang/masr/blob/master/examples/parameterized-document.Rmd)

进一步将文档类型做成参数化，实现在运行时自由选择，只需将如下两行替换掉上述一行

```yaml
params:
  classoption: twocolumn
classoption: "`r params$classoption`"
```

如果想要双栏的排版风格，编译时传递 documentclass 参数值，覆盖掉默认的参数值即可


```r
rmarkdown::render(
  input = "examples/pdf-document.Rmd",
  params = list(classoption = c("twocolumn"))
)
```

## 学术幻灯片 {#sec-beamer-slides}

beamer 幻灯片也是一种 PDF 文档 [PDF 文档案例](https://github.com/XiangyunHuang/masr/blob/master/examples/beamer-verona.Rmd)

Dirk Eddelbuettel 将几个大学的 beamer 幻灯片转化成 R Markdown 模板，收录在 [binb](https://github.com/eddelbuettel/binb) 包里，方便调用。伊利诺伊大学的 [James J Balamuta](https://thecoatlessprofessor.com/) 在 R Markdown 基础上专门为自己学校开发了一套的幻灯片模版，全部打包在 [uiucthemes](https://github.com/illinois-r/uiucthemes) 包里。

[komaletter](https://github.com/rnuske/komaletter) 用 Markdown 写信件

[memor](https://github.com/hebrewseniorlife/memor) `memor::pdf_memo()`

[hrbrthemes](http://github.com/hrbrmstr/hrbrthemes) 提供两个文档模版 `hrbrthemes::ipsum_pdf()` 和 `hrbrthemes::ipsum()`

此汉风主题由 [林莲枝](https://github.com/liantze/pgfornament-han/) 开发，LaTeX 宏包已发布在 [CTAN](https://www.ctan.org/pkg/pgfornament-han) 上，使用此幻灯片主题需要将相关的 LaTeX 宏包一块安装。

```bash
tlmgr install pgfornament pgfornament-han needspace xpatch
```

## 文档模版 {#sec-document-template}

字体设置

:::::: {.columns}
::: {.column width="47.5%" data-latex="{0.475\textwidth}"}

```yaml
---
output: 
  pdf_document: 
    extra_dependencies:
      DejaVuSansMono:
       - scaled=0.9
      DejaVuSerif:
       - scaled=0.9
      DejaVuSans:
       - scaled=0.9
---
```

:::
::: {.column width="5%" data-latex="{0.05\textwidth}"}
\ 
<!-- an empty Div (with a white space), serving as
a column separator -->
:::
::: {.column width="47.5%" data-latex="{0.475\textwidth}"}

```yaml
---
output: 
  pdf_document: 
    extra_dependencies:
      sourcecodepro:
       - scale=0.85
      sourceserifpro:
       - rmdefault
      sourcesanspro:
       - sfdefault
---
```

:::
::::::

## 引用文献 {#sec-cite-doi}

[Getting started with Zotero, Better BibTeX, and RMarkdown](https://fishandwhistle.net/post/2020/getting-started-zotero-better-bibtex-rmarkdown/)

[^doi]: <https://zh.wikipedia.org/wiki/DOI>

[knitcitations](https://github.com/cboettig/knitcitations) 包可以根据文献数字对象标识符（英文 Digital Object Identifier，简称 DOI）生成引用，以文章《A Probabilistic Grammar of Graphics》[@Pu_2020_Grammar] 为例，其 DOI 为 `10.1145/3313831.3376466`，总之， DOI 就像是文章的身份证，是一一对应的关系[^doi]。


```r
library(knitcitations)
citep(x ='10.1145/3313831.3376466')
```

```
[1] "(Pu and Kay, 2020)"
```

在表格的格子中引用参考文献


```r
data.frame(
  author = c("Yihui Xie", "Yihui Xie", "Yihui Xie"),
  citation = c("[@xie2019]", "[@xie2015]", "[@xie2016]")
) |> 
  knitr::kable(format = "pandoc")
```



author      citation   
----------  -----------
Yihui Xie   [@xie2019] 
Yihui Xie   [@xie2015] 
Yihui Xie   [@xie2016] 

[citr](https://github.com/crsh/citr) 包提供了快速查找参考文献的 RStudio 插件，不用去原始文献库 `*.bib` 搜索查找，也会自动生成引用，非常方便，极大地提高了工作效率。 **citr** 还支持集成 [Zotero](https://www.zotero.org/) 文献管理软件，可以直接从 Zotero 中导入参考文献数据库。[rbbt](https://github.com/paleolimbot/rbbt) 包也提供了类似的功能，只要系统安装 Zotero 软件及其插件 [Better Bibtex for Zotero connector](https://retorque.re/zotero-better-bibtex/)。

## 自定义块 {#sec-custom-blocks}

```r
tinytex::tlmgr_install(c('awesomebox', 'fontawesome5'))
```

安装 [awesomebox](https://ctan.org/pkg/awesomebox) 包，开发仓库在 <https://github.com/milouse/latex-awesomebox>，这个 LaTeX 宏包的作用是提供几类常用的块，比如提示、注意、警告等

::: {.noteblock data-latex="注意"}
这是注意
:::

::: {.tipblock data-latex="提示"}
这是提示信息
:::

::: {.warningblock data-latex="警告"}
这是警告信息
:::

::: {.importantblock data-latex="重要"}
这是重要信息
:::
