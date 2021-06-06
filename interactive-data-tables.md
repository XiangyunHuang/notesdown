# 交互式数据表格 {#chap:interactive-data-tables}

Greg Lin 开发的 [reactable](https://github.com/glin/reactable) 包覆盖测试达到惊人的 99\%，它基于 JavaScript 库 [react-table](https://github.com/tannerlinsley/react-table)， 是 [react](https://github.com/facebook/react) 框架的衍生品，Nick Raienko 整理了一份超棒的 [react 模块合集](https://github.com/enaqx/awesome-react) 也许机智如你，可以引入更多优秀的 react 模块到 R 语言社区。[reactablefmtr](https://github.com/kcuilla/reactablefmtr) 提供一些函数简化 reactable 定制表格的复杂性

谢益辉开发的 [DT](https://github.com/rstudio/DT) 包覆盖测试 31\%， 它基于 [DataTables](https://datatables.net/) 库，是 [jQuery](https://jquery.com/) 框架的衍生品。益辉评价 reactable 在多个方面优于 DT，比如行分组和聚合，嵌入 HTML widgets，甚至说要是 **reactable** 存在于 **DT** 之前，他就不会新开发 DT 这个 R 包了，不过这是后话了[^dt-vs-reactable]。

Richard Iannone 开发的 [gt](https://github.com/rstudio/gt) 包覆盖测试 78\%，类似 **ggplot2** 的设计哲学，试图打造制作表格的语法，相比于 **reactable** 和 **DT**， 它不依赖于 JavaScript 库，更加轻量，一般来讲，持续维护更新重 JS 库依赖的 R 包比较累人，JS 库可能会不断重构，进而变动 API。

朱昊开发的 [kableExtra](https://github.com/haozhu233/kableExtra) 大大扩展了 **knitr** 包的 `kable()` 函数的功能，虽没有覆盖测试，但中英文文档特别详细，见官网 <https://haozhu233.github.io/kableExtra/>。

目前，Greg Lin、 谢益辉和 Richard Iannone 都是 RStudio 公司雇员，他们背靠开源组织和大公司，开发的这些 R 包的生命力都比较强。 **gt** 和 **kableExtra** 摆脱了 JavaScript 库的依赖，网页形式的表格可以嵌入到邮件内容中，这是一个不太引人注意的优势。**kableExtra** 还支持高度自定义的 LaTeX 输出，详见案例 <https://github.com/XiangyunHuang/bookdown-kableExtra>，**gt** 包据说未来也会支持，拭目以待吧，也许在成书之日能看到！

此外，还有任坤开发的 [**formattable**](https://github.com/renkun-ken/formattable) 和 David Gohel 开发的 [**flextable**](https://github.com/davidgohel/flextable) 包等，一份综合介绍见博文 [How to Make Beautiful Tables in R](https://rfortherestofus.com/2019/11/how-to-make-beautiful-tables-in-r/)。

[rtables](https://github.com/Roche/rtables) 处于原型开发的阶段，针对复杂表格，有比较好的设计。[tablesgg](https://github.com/rrprf/tablesgg) 使用 ggplot2 将表格渲染成图片。

[^dt-vs-reactable]: <https://bookdown.org/yihui/rmarkdown-cookbook/table-other.html>

## DT 和 reactable {#sec:dt-reactable}

[DT](https://github.com/rstudio/DT) 基于 jQuery 的 JS 库 [DataTables](https://datatables.net/) 提供了一个 R 的封装，封装工具和许多其他基于 JS 库的 R 包一样，比如即将介绍的 **reactable** 包，都依赖于 [htmlwidgets](https://github.com/ramnathv/htmlwidgets)。


```r
library(DT)
```


```r
data.frame(name1 = c(
  "<b>加粗</b>",
  "<em>强调</em>",
  "正常"
), name2 = c(
  '<a href="http://rstudio.com">超链</a>', # 支持超链接
  '<a href="#" onclick="alert(\'Hello\');">点击</a>',
  '正常'
)) %>%
  datatable(
    data = .,
    escape = F, # 设置 escape = F
    colnames = c('<span style="color:red">第1列</span>', "<em>第2列</em>"),
    caption = htmltools::tags$caption(
      style = "caption-side: top; text-align: center;",
      "表格 2: ", htmltools::em("表格标题")
    ), # 在表格底部显示标题，默认在表格上方显示标题
    filter = "top", # 过滤框
    options = list(
      language = list(url = "//cdn.datatables.net/plug-ins/1.10.11/i18n/Chinese.json"), # 汉化
      pageLength = 5, # 每页显示5行
      dom = "tip",
      autoWidth = TRUE # 自动页面宽度
    )
  )
```

```{=html}
<div id="htmlwidget-4cc63ae57fde0679c080" style="width:100%;height:auto;" class="datatables html-widget"></div>
<script type="application/json" data-for="htmlwidget-4cc63ae57fde0679c080">{"x":{"filter":"top","filterHTML":"<tr>\n  <td><\/td>\n  <td data-type=\"character\" style=\"vertical-align: top;\">\n    <div class=\"form-group has-feedback\" style=\"margin-bottom: auto;\">\n      <input type=\"search\" placeholder=\"All\" class=\"form-control\" style=\"width: 100%;\"/>\n      <span class=\"glyphicon glyphicon-remove-circle form-control-feedback\"><\/span>\n    <\/div>\n  <\/td>\n  <td data-type=\"character\" style=\"vertical-align: top;\">\n    <div class=\"form-group has-feedback\" style=\"margin-bottom: auto;\">\n      <input type=\"search\" placeholder=\"All\" class=\"form-control\" style=\"width: 100%;\"/>\n      <span class=\"glyphicon glyphicon-remove-circle form-control-feedback\"><\/span>\n    <\/div>\n  <\/td>\n<\/tr>","caption":"<caption style=\"caption-side: top; text-align: center;\">\n  表格 2: \n  <em>表格标题<\/em>\n<\/caption>","data":[["1","2","3"],["<b>加粗<\/b>","<em>强调<\/em>","正常"],["<a href=\"http://rstudio.com\">超链<\/a>","<a href=\"#\" onclick=\"alert('Hello');\">点击<\/a>","正常"]],"container":"<table class=\"display\">\n  <thead>\n    <tr>\n      <th> <\/th>\n      <th><span style=\"color:red\">第1列<\/span><\/th>\n      <th><em>第2列<\/em><\/th>\n    <\/tr>\n  <\/thead>\n<\/table>","options":{"language":{"url":"//cdn.datatables.net/plug-ins/1.10.11/i18n/Chinese.json"},"pageLength":5,"dom":"tip","autoWidth":true,"order":[],"orderClasses":false,"columnDefs":[{"orderable":false,"targets":0}],"orderCellsTop":true,"lengthMenu":[5,10,25,50,100]}},"evals":[],"jsHooks":[]}</script>
```

下面重点介绍 reactable 包，看看 React.js 和 Shiny 是如何集成的，这是比较高级的主题，主要参考 [Alan Dipert](https://github.com/alandipert) 的演讲材料 [Integrating React.js and Shiny](https://rstudio.com/resources/rstudioconf-2019/integrating-react-js-and-shiny/)。


```r
library(reactable) 
```

下面这个例子来自 React.js 官网 <https://reactjs.org/>

````md
```js
class HelloMessage extends React.Component {
  render() {
    return (
      <div>
        Hello {this.props.name}
      </div>
    );
  }
}

ReactDOM.render(
  <HelloMessage name="Taylor" />,
  document.getElementById('hello-example')
);
```
````

更多细节定制见 Thomas Mock 的博文 [reactable - An Interactive Tables Guide](https://themockup.blog/posts/2020-05-13-reactable-tables-the-rest-of-the-owl/)  

## gt 和 kableExtra {#sec:gt-kableExtra}

如表 \@ref(tab:kable-styles) 所示，我们可以自定义表格样式，比如配色，例子修改自 kableExtra 帮助文档 <https://haozhu233.github.io/kableExtra/bookdown/cross-format-tables-in-bookdown.html>，同时支持 HTML 和 LaTeX 输出， 但是 LaTeX 输出需要在文档类选项中增加 table 选项，即 `classoption: "table"`，这样就可以加载 colortbl 宏包，进而提供 `\rowcolor` 等 LaTeX 命令，在表格中给每个格子定制颜色。我们推荐在 classoption 中添加 table 选项，而不是再次加载 xcolor 包，比如像这样 `\usepackage[table]{xcolor}`，这会在 R Markdown 中引起冲突 [^table-rmd]。

[^table-rmd]: <https://stackoverflow.com/questions/50094698/rmarkdown-beamer-presentation-option-clash-clash-for-xcolor>


```r
library(kableExtra)

iris[1:10, ] %>%
  transform(
    Sepal.Length =
      cell_spec(Sepal.Length,
        bold = T,
        color = spec_color(Sepal.Length, end = 0.9),
        font_size = spec_font_size(Sepal.Length)
      )
  ) %>%
  transform(Species = cell_spec(
    Species,
    color = "white", bold = T,
    background = spec_color(1:10,
      end = 0.9,
      option = "A", direction = -1
    )
  )) %>%
  kable(
    escape = F, align = "c", booktabs = T,
    caption = "自定义表格样式"
  ) %>%
  kable_styling(c("striped", "condensed"),
    latex_options = "striped",
    full_width = F
  )
```

<table class="table table-striped table-condensed" style="width: auto !important; margin-left: auto; margin-right: auto;">
<caption>(\#tab:kable-styles)自定义表格样式</caption>
 <thead>
  <tr>
   <th style="text-align:center;"> Sepal.Length </th>
   <th style="text-align:center;"> Sepal.Width </th>
   <th style="text-align:center;"> Petal.Length </th>
   <th style="text-align:center;"> Petal.Width </th>
   <th style="text-align:center;"> Species </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:center;"> <span style=" font-weight: bold;    color: rgba(40, 174, 128, 1) !important;font-size: 14px;">5.1</span> </td>
   <td style="text-align:center;"> 3.5 </td>
   <td style="text-align:center;"> 1.4 </td>
   <td style="text-align:center;"> 0.2 </td>
   <td style="text-align:center;"> <span style=" font-weight: bold;    color: white !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: rgba(254, 206, 145, 1) !important;">setosa</span> </td>
  </tr>
  <tr>
   <td style="text-align:center;"> <span style=" font-weight: bold;    color: rgba(37, 131, 142, 1) !important;font-size: 12px;">4.9</span> </td>
   <td style="text-align:center;"> 3.0 </td>
   <td style="text-align:center;"> 1.4 </td>
   <td style="text-align:center;"> 0.2 </td>
   <td style="text-align:center;"> <span style=" font-weight: bold;    color: white !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: rgba(254, 160, 109, 1) !important;">setosa</span> </td>
  </tr>
  <tr>
   <td style="text-align:center;"> <span style=" font-weight: bold;    color: rgba(57, 87, 140, 1) !important;font-size: 10px;">4.7</span> </td>
   <td style="text-align:center;"> 3.2 </td>
   <td style="text-align:center;"> 1.3 </td>
   <td style="text-align:center;"> 0.2 </td>
   <td style="text-align:center;"> <span style=" font-weight: bold;    color: white !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: rgba(246, 110, 92, 1) !important;">setosa</span> </td>
  </tr>
  <tr>
   <td style="text-align:center;"> <span style=" font-weight: bold;    color: rgba(67, 62, 133, 1) !important;font-size: 10px;">4.6</span> </td>
   <td style="text-align:center;"> 3.1 </td>
   <td style="text-align:center;"> 1.5 </td>
   <td style="text-align:center;"> 0.2 </td>
   <td style="text-align:center;"> <span style=" font-weight: bold;    color: white !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: rgba(222, 73, 104, 1) !important;">setosa</span> </td>
  </tr>
  <tr>
   <td style="text-align:center;"> <span style=" font-weight: bold;    color: rgba(31, 154, 138, 1) !important;font-size: 13px;">5</span> </td>
   <td style="text-align:center;"> 3.6 </td>
   <td style="text-align:center;"> 1.4 </td>
   <td style="text-align:center;"> 0.2 </td>
   <td style="text-align:center;"> <span style=" font-weight: bold;    color: white !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: rgba(183, 55, 121, 1) !important;">setosa</span> </td>
  </tr>
  <tr>
   <td style="text-align:center;"> <span style=" font-weight: bold;    color: rgba(187, 223, 39, 1) !important;font-size: 16px;">5.4</span> </td>
   <td style="text-align:center;"> 3.9 </td>
   <td style="text-align:center;"> 1.7 </td>
   <td style="text-align:center;"> 0.4 </td>
   <td style="text-align:center;"> <span style=" font-weight: bold;    color: white !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: rgba(140, 41, 129, 1) !important;">setosa</span> </td>
  </tr>
  <tr>
   <td style="text-align:center;"> <span style=" font-weight: bold;    color: rgba(67, 62, 133, 1) !important;font-size: 10px;">4.6</span> </td>
   <td style="text-align:center;"> 3.4 </td>
   <td style="text-align:center;"> 1.4 </td>
   <td style="text-align:center;"> 0.3 </td>
   <td style="text-align:center;"> <span style=" font-weight: bold;    color: white !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: rgba(100, 26, 128, 1) !important;">setosa</span> </td>
  </tr>
  <tr>
   <td style="text-align:center;"> <span style=" font-weight: bold;    color: rgba(31, 154, 138, 1) !important;font-size: 13px;">5</span> </td>
   <td style="text-align:center;"> 3.4 </td>
   <td style="text-align:center;"> 1.5 </td>
   <td style="text-align:center;"> 0.2 </td>
   <td style="text-align:center;"> <span style=" font-weight: bold;    color: white !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: rgba(60, 15, 112, 1) !important;">setosa</span> </td>
  </tr>
  <tr>
   <td style="text-align:center;"> <span style=" font-weight: bold;    color: rgba(68, 1, 84, 1) !important;font-size: 8px;">4.4</span> </td>
   <td style="text-align:center;"> 2.9 </td>
   <td style="text-align:center;"> 1.4 </td>
   <td style="text-align:center;"> 0.2 </td>
   <td style="text-align:center;"> <span style=" font-weight: bold;    color: white !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: rgba(20, 14, 54, 1) !important;">setosa</span> </td>
  </tr>
  <tr>
   <td style="text-align:center;"> <span style=" font-weight: bold;    color: rgba(37, 131, 142, 1) !important;font-size: 12px;">4.9</span> </td>
   <td style="text-align:center;"> 3.1 </td>
   <td style="text-align:center;"> 1.5 </td>
   <td style="text-align:center;"> 0.1 </td>
   <td style="text-align:center;"> <span style=" font-weight: bold;    color: white !important;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: rgba(0, 0, 4, 1) !important;">setosa</span> </td>
  </tr>
</tbody>
</table>

一个非常基本的 gt 制作的表格


```r
library(gt)
iris %>% 
  head() %>% 
  gt()
```

然后添加表格的标题和副标题，套上 `md()` 函数后，标题和副标题支持 Markdown 语法，告别 HTML 的制表方式吧！其它表格元素，如脚注支持和表格的列指标关联


```r
library(data.table)

iris %>%
  as.data.table %>% 
  .[, head(.SD, 2), by = .(Species)] %>% 
  gt() %>%
  tab_header(
    title = md("**鸢尾花**数据集"),
    subtitle = "R 内置数据集"
  ) %>%
  data_color(
    columns = vars(Sepal.Length),
    colors = scales::col_numeric(palette = terrain.colors(5, rev = T), domain = NULL)
  ) %>%
  data_color(
    columns = vars(Species),
    colors = scales::col_factor(palette = hcl.colors(3), domain = NULL)
  ) %>%
  tab_footnote(
    footnote = md("据说数据集最早收集自 Fisher's or Anderson's"),
    locations = cells_column_labels(columns = vars(Sepal.Length))
  ) %>%
  tab_footnote(
    footnote = "鸢尾花的类别",
    locations = cells_column_labels(
      columns = vars(Species)
    )
  )
```

更多细节的设置见 Thomas Mock 的博文[gt - a (G)rammar of (T)ables](https://themockup.blog/posts/2020-05-16-gt-a-grammer-of-tables/)

::: {.rmdnote data-latex="{注意}"}
当前 gt 包对 LaTeX 的支持比较弱，上述表格在 HTML 网页环境中可以看到的效果并不能一一对应到 LaTeX 输出中。且 gt 包生成 LaTeX 表格会自动加载宏包 amsmath、booktabs、caption 和 longtable， `gt_latex_dependencies()` 且不能控制
:::

## 运行环境 {#sec:table-session}


```r
sessionInfo()
```

```
## R version 4.1.0 (2021-05-18)
## Platform: x86_64-pc-linux-gnu (64-bit)
## Running under: Ubuntu 20.04.2 LTS
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
## [1] kableExtra_1.3.4 reactable_0.2.3  DT_0.18         
## 
## loaded via a namespace (and not attached):
##  [1] rstudioapi_0.13   xml2_1.3.2        knitr_1.33        magrittr_2.0.1   
##  [5] munsell_0.5.0     rvest_1.0.0       viridisLite_0.4.0 colorspace_2.0-1 
##  [9] R6_2.5.0          rlang_0.4.11      httr_1.4.2        stringr_1.4.0    
## [13] tools_4.1.0       webshot_0.5.2     xfun_0.23         jquerylib_0.1.4  
## [17] systemfonts_1.0.2 htmltools_0.5.1.1 crosstalk_1.1.1   yaml_2.2.1       
## [21] digest_0.6.27     lifecycle_1.0.0   bookdown_0.22     sass_0.4.0       
## [25] htmlwidgets_1.5.3 glue_1.4.2        evaluate_0.14     rmarkdown_2.8    
## [29] stringi_1.6.2     compiler_4.1.0    bslib_0.2.5.1     scales_1.1.1     
## [33] svglite_2.0.0     jsonlite_1.7.2
```
