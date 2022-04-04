# 混合编程 {#chap-mixed-programming}



R 语言 [@Ross_1996_R] 是一个统计计算和绘图的环境，以下各个节不介绍具体 R 包函数用法和参数设置，重点在历史发展趋势脉络，详细介绍去见[《现代统计图形》](https://bookdown.org/xiangyun/msg)的相应章节。R 语言的目标在于统计计算和绘图，设计优势在数据结构、图形语法、动态文档和交互图形

<!-- 介绍 R 与其它语言的异同，降低编程门槛 -->


## 函数源码 {#sec-function-source}


[flow](https://github.com/moodymudskipper/flow) 包可以将函数调用的过程以流程图的方式呈现，代码结构一目了然，快速理清源代码


```r
remotes::install_github('moodymudskipper/funflow')
funflow::view_flow('median.default')
```


```r
methods(predict)
```

```
##  [1] predict.ar*                predict.Arima*            
##  [3] predict.arima0*            predict.glm               
##  [5] predict.HoltWinters*       predict.lm                
##  [7] predict.loess*             predict.mlm*              
##  [9] predict.nls*               predict.poly*             
## [11] predict.ppr*               predict.prcomp*           
## [13] predict.princomp*          predict.smooth.spline*    
## [15] predict.smooth.spline.fit* predict.StructTS*         
## see '?methods' for accessing help and source code
```

stats 包里找不到这个函数


```r
ls("package:stats", all.names = TRUE, pattern = "predict.poly")
```

```
## character(0)
```



```r
predict.poly
```

```
## Error in eval(expr, envir, enclos): object 'predict.poly' not found
```

可见函数 `predict.poly()` 默认没有导出


```r
stats:::predict.poly
```

```
## function (object, newdata, ...) 
## {
##     if (missing(newdata)) 
##         object
##     else if (is.null(attr(object, "coefs"))) 
##         poly(newdata, degree = max(attr(object, "degree")), raw = TRUE, 
##             simple = TRUE)
##     else poly(newdata, degree = max(attr(object, "degree")), 
##         coefs = attr(object, "coefs"), simple = TRUE)
## }
## <bytecode: 0x55ba170be5c0>
## <environment: namespace:stats>
```

或者


```r
getAnywhere(predict.poly)
```

```
## A single object matching 'predict.poly' was found
## It was found in the following places
##   registered S3 method for predict from namespace stats
##   namespace:stats
## with value
## 
## function (object, newdata, ...) 
## {
##     if (missing(newdata)) 
##         object
##     else if (is.null(attr(object, "coefs"))) 
##         poly(newdata, degree = max(attr(object, "degree")), raw = TRUE, 
##             simple = TRUE)
##     else poly(newdata, degree = max(attr(object, "degree")), 
##         coefs = attr(object, "coefs"), simple = TRUE)
## }
## <bytecode: 0x55ba170be5c0>
## <environment: namespace:stats>
```


```r
getAnywhere("predict.poly")$where
```

```
## [1] "registered S3 method for predict from namespace stats"
## [2] "namespace:stats"
```

函数参数个数


```r
names(formals(read.table))
```

```
##  [1] "file"             "header"           "sep"              "quote"           
##  [5] "dec"              "numerals"         "row.names"        "col.names"       
##  [9] "as.is"            "na.strings"       "colClasses"       "nrows"           
## [13] "skip"             "check.names"      "fill"             "strip.white"     
## [17] "blank.lines.skip" "comment.char"     "allowEscapes"     "flush"           
## [21] "stringsAsFactors" "fileEncoding"     "encoding"         "text"            
## [25] "skipNul"
```


## 命名约定 {#sec-naming-conventions}

R 语言当前的命名状态  <https://journal.r-project.org/archive/2012-2/RJournal_2012-2_Baaaath.pdf> 和 <https://essentials.togaware.com/StyleO.pdf>


R 与不同的编程语言如何交互

## R 与 JavaScripts {#sec-r-javascripts}

<!-- roughviz.js 为例介绍如何使用 htmlwidgets 制作将 JavaScripts 库打包成 R 包 -->


```r
library(htmlwidgets)
```

## R 与 Python {#sec-r-python}

R 包 knitr 和 reticulate 支持 R Markdown 文档中嵌入 Python 代码块， reticulate 包还支持 Python 和 R 之间的数据对象通信交流。


```r
library(reticulate)
```

如图 \@ref(fig:reticulate-matplotlib) 所示，在 R Markdown 中执行 Python 绘图代码，并且将图形插入文档。


```python
import matplotlib.pyplot as plt
plt.switch_backend('agg')

plt.plot([0, 2, 1, 4])
plt.show()
```

\begin{figure}

{\centering \includegraphics[width=.8\textwidth]{mixed-programming_files/figure-latex/reticulate-matplotlib-1} 

}

\caption{Python 图形}(\#fig:reticulate-matplotlib)
\end{figure}


## R 与 C {#sec-r-c}

knitr 支持在 R Markdown 中嵌入 C 语言代码


```c
void useC(int *i){
  i[0] = 11;
}
```

```
## make[1]: Entering directory '/home/runner/work/masr/masr'
## gcc -I"/opt/R/4.1.3/lib/R/include" -DNDEBUG   -I/usr/local/include   -fpic  -g -O2  -c c671e47fc0e26.c -o c671e47fc0e26.o
## gcc -shared -L/opt/R/4.1.3/lib/R/lib -L/usr/local/lib -o c671e47fc0e26.so c671e47fc0e26.o -L/opt/R/4.1.3/lib/R/lib -lR
## make[1]: Leaving directory '/home/runner/work/masr/masr'
```

```r
a <- rep(2,10)
out <- .C("useC", b = as.integer(a))
out
```

```
## $b
##  [1] 11  2  2  2  2  2  2  2  2  2
```

```r
out$b
```

```
##  [1] 11  2  2  2  2  2  2  2  2  2
```


一步一步地命令行操作

```bash
R CMD SHLIB useC1.c
```

```r
dyn.load("useC1.dll")
a <- rep(2,10)
out <- .C("useC", b = as.integer(a))
out$b
```


## R 与 C++ {#sec-r-cpp}

[Dirk Eddelbuettel](https://dirk.eddelbuettel.com) 是 Rcpp 的核心开发者。

- Dirk Eddelbuettel celebRtion 2020, Copenhagen, Denmark [Introduction to Rcpp: from simple examples to machine learning](https://dirk.eddelbuettel.com/papers/celebRtion_feb2020_rcpp.pdf)
- Online Tutorial for useR! 2020 [Seamless R and C++ Introduction with Rcpp](https://dirk.eddelbuettel.com/papers/useR2020_rcpp_tutorial.pdf) 视频 https://vimeo.com/438283959
- James Balamuta [unofficial rcpp api documentation](https://thecoatlessprofessor.com/programming/unofficial-rcpp-api-documentation/) <https://github.com/coatless/rcpp-api>
- Rcpp for everyone <https://github.com/teuder/rcpp4everyone_en>
- 课程 [Foundations of Data Science](https://ds4ps.org/cpp-526-sum-2020/)


```r
library(Rcpp)
```

## R 与 LaTeX {#sec-r-latex}

<!-- TeX 的历史一小段介绍，tikzDevice 对公式的加强， 引入 TikZ 图形，常用 LaTeX 语法 <https://wch.github.io/latexsheet/latexsheet-a4.pdf> -->

**tikzDevice** 包将 LaTeX 公式和绘图系统 [TikZ](https://en.wikipedia.org/wiki/PGF/TikZ) 引入 R 语言生态，贡献在于提供更加漂亮的公式输出，对图形进行后期布局排版加工，达到设计师出品的质量水平。图 \@ref(fig:tex-system) 展示了复杂的 TeX 生态系统， R 语言只是取其精华，使用 TikZ 绘制。


```tex
\begin{tikzpicture}
  \path [
    mindmap,
    text = white,
    level 1 concept/.append style =
      {font=\Large\bfseries\sffamily, sibling angle=90, level distance=125},
    level 2 concept/.append style =
      {font=\normalsize\bfseries\sffamily},
    level 3 concept/.append style =
      {font=\small\bfseries\sffamily},
    tex/.style     = {concept, ball color=blue,
      font=\Huge\bfseries},
    engines/.style = {concept, ball color=green!50!black},
    formats/.style = {concept, ball color=purple!50!black},
    systems/.style = {concept, ball color=red!90!black},
    editors/.style = {concept, ball color=orange!90!black}
  ]
  node [tex] {\TeX} [clockwise from=0]
    child[concept color=green!50!black, nodes={engines}] {
      node {Engines} [clockwise from=90]
        child { node {\TeX} }
        child { node {pdf\TeX} }
        child { node {XeTeX} }
        child { node {Lua\TeX} }}
    child [concept color=purple, nodes={formats}] {
      node {Formats} [clockwise from=300]
        child { node {\LaTeX} }
        child { node {Con\TeX t} }}
    child [concept color=red, nodes={systems}] {
      node {Systems} [clockwise from=210]
        child { node {\TeX Live} [clockwise from=300]
          child { node {Mac \TeX} }}
        child { node {MiK\TeX} [clockwise from=60]
          child { node {Pro \TeX t} }}}
    child [concept color=orange, nodes={editors}] {
      node {Editors} [clockwise from=180]
        child { node {WinEdt} }
        child { node {\TeX works} }
        child { node {\TeX studio} }
        child { node {\TeX maker} }};
\end{tikzpicture}
```


\begin{figure}

{\centering \includegraphics{mixed-programming_files/figure-latex/tex-system-1} 

}

\caption{TeX 系统}(\#fig:tex-system)
\end{figure}


## 运行环境 {#sec-mixed-programming-session-info}


```r
sessionInfo()
```

```
## R version 4.1.3 (2022-03-10)
## Platform: x86_64-pc-linux-gnu (64-bit)
## Running under: Ubuntu 20.04.4 LTS
## 
## Matrix products: default
## BLAS:   /usr/lib/x86_64-linux-gnu/blas/libblas.so.3.9.0
## LAPACK: /usr/lib/x86_64-linux-gnu/lapack/liblapack.so.3.9.0
## 
## locale:
##  [1] LC_CTYPE=en_US.UTF-8       LC_NUMERIC=C              
##  [3] LC_TIME=en_US.UTF-8        LC_COLLATE=en_US.UTF-8    
##  [5] LC_MONETARY=en_US.UTF-8    LC_MESSAGES=en_US.UTF-8   
##  [7] LC_PAPER=en_US.UTF-8       LC_NAME=C                 
##  [9] LC_ADDRESS=C               LC_TELEPHONE=C            
## [11] LC_MEASUREMENT=en_US.UTF-8 LC_IDENTIFICATION=C       
## 
## attached base packages:
## [1] stats     graphics  grDevices utils     datasets  methods   base     
## 
## other attached packages:
## [1] Rcpp_1.0.8.3      reticulate_1.24   htmlwidgets_1.5.4 shiny_1.7.1      
## [5] magrittr_2.0.3   
## 
## loaded via a namespace (and not attached):
##  [1] knitr_1.38       sysfonts_0.8.8   lattice_0.20-45  xtable_1.8-4    
##  [5] R6_2.5.1         rlang_1.0.2      fastmap_1.1.0    stringr_1.4.0   
##  [9] tools_4.1.3      grid_4.1.3       xfun_0.30        png_0.1-7       
## [13] tinytex_0.38     cli_3.2.0        htmltools_0.5.2  ellipsis_0.3.2  
## [17] yaml_2.3.5       digest_0.6.29    lifecycle_1.0.1  bookdown_0.25   
## [21] Matrix_1.4-1     later_1.3.0      promises_1.2.0.1 curl_4.3.2      
## [25] evaluate_0.15    mime_0.12        rmarkdown_2.13   stringi_1.7.6   
## [29] compiler_4.1.3   jsonlite_1.8.0   httpuv_1.6.5
```
