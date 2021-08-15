# 文档元素 {#chap-document-elements}

knitr 将 R Markdown 文件转化为 Markdown 文件， Pandoc 可以将 Markdown 文件转化为 HTML5、Word、PowerPoint 和 PDF 等文档格式。

\begin{figure}

{\centering \href{https://www.ardata.fr/img/illustrations}{\includegraphics[width=0.15\linewidth,height=0.15\textheight]{images/html5} }\href{https://www.ardata.fr/img/illustrations}{\includegraphics[width=0.15\linewidth,height=0.15\textheight]{images/word} }\href{https://www.ardata.fr/img/illustrations}{\includegraphics[width=0.15\linewidth,height=0.15\textheight]{images/powerpoint} }\href{https://www.ardata.fr/img/illustrations}{\includegraphics[width=0.15\linewidth,height=0.15\textheight]{images/pdf} }

}

\caption{rmarkdown 支持的输出格式}(\#fig:rmarkdown-output)
\end{figure}

rmarkdown 自 2014年09月17日在 CRAN 上发布第一个正式版本以来，逐渐形成了一个强大的生态系统，世界各地的开发者贡献各种各样的扩展功能，见图 \@ref(fig:rmarkdown-ecosystem)

\begin{figure}

{\centering \includegraphics{document-elements_files/figure-latex/rmarkdown-ecosystem-1} 

}

\caption{rmarkdown 生态系统}(\#fig:rmarkdown-ecosystem)
\end{figure}


\begin{figure}

{\centering \includegraphics[width=0.75\linewidth]{diagrams/rmarkdown} 

}

\caption{R Markdown 概念图}(\#fig:rmarkdown-concept-map)
\end{figure}

## 控制选项 {#sec-sql-engine}

[Using SQL in RStudio](https://irene.rbind.io/post/using-sql-in-rstudio/)


```r
library(DBI)
conn <- DBI::dbConnect(RSQLite::SQLite(),
  dbname = system.file("db", "datasets.sqlite", package = "RSQLite")
)
```

Base R 内置的数据集都整合进 RSQLite 的样例数据库里了，


```r
dbListTables(conn)
```

```
##  [1] "BOD"              "CO2"              "ChickWeight"      "DNase"           
##  [5] "Formaldehyde"     "Indometh"         "InsectSprays"     "LifeCycleSavings"
##  [9] "Loblolly"         "Orange"           "OrchardSprays"    "PlantGrowth"     
## [13] "Puromycin"        "Theoph"           "ToothGrowth"      "USArrests"       
## [17] "USJudgeRatings"   "airquality"       "anscombe"         "attenu"          
## [21] "attitude"         "cars"             "chickwts"         "esoph"           
## [25] "faithful"         "freeny"           "infert"           "iris"            
## [29] "longley"          "morley"           "mtcars"           "npk"             
## [33] "pressure"         "quakes"           "randu"            "rock"            
## [37] "sleep"            "stackloss"        "swiss"            "trees"           
## [41] "warpbreaks"       "women"
```

随意选择 5 行数据记录，将结果保存到变量 iris_preview


```sql
SELECT * FROM iris LIMIT 5;
```

查看变量 iris_preview 的内容


```r
iris_preview
```

```
##   Sepal.Length Sepal.Width Petal.Length Petal.Width Species
## 1          5.1         3.5          1.4         0.2  setosa
## 2          4.9         3.0          1.4         0.2  setosa
## 3          4.7         3.2          1.3         0.2  setosa
## 4          4.6         3.1          1.5         0.2  setosa
## 5          5.0         3.6          1.4         0.2  setosa
```

结束后关闭连接


```r
dbDisconnect(conn = conn)
```

## 表格 {#sec-rmarkdown-table}

**knitr** 的 `kable()` 函数提供了制作表格的基本功能 <https://bookdown.org/yihui/rmarkdown-cookbook/tables.html>，[flextable](https://github.com/davidgohel/flextable) 支持更加细粒度的表格定制功能。[beautifyR](https://github.com/mwip/beautifyR) 整理 Markdown 表格非常方便，[datapasta](https://github.com/MilesMcBain/datapasta) 快速复制粘贴 data.frame 和 tibble 类型的数据表格。[rpivotTable](https://github.com/smartinsightsfromdata/rpivotTable) 不更新了，[pivottabler](https://github.com/cbailiss/pivottabler) 在更新，内容似乎更好。[remedy](https://github.com/ThinkR-open/remedy) 提供了更加通用的 Markdown 写作功能，简化创作的技术难度。

## 流程图 {#sec-rmarkdown-uml}

[nomnoml](https://github.com/rstudio/nomnoml) 流程图、思维导图


```r
nomnoml::nomnoml(" 
#stroke: #26A63A
#.box: fill=#8f8 dashed visual=note
#direction: down

[Sweave-test-1.Rnw] -> utils::Sweave() [Sweave-test-1.tex|Sweave-test-1-006.pdf|Sweave-test-1-007.pdf]
[Sweave-test-1.Rnw] -> utils::Stangle() [Sweave-test-1.R]
[Sweave-test-1.tex] -> tools::texi2pdf() [Sweave-test-1.pdf]
[Sweave-test-1.tex] -> tools::texi2dvi() [Sweave-test-1.dvi]
")
```



\begin{center}\includegraphics{document-elements_files/figure-latex/unnamed-chunk-6-1} \end{center}


