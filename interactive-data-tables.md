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
library(magrittr)
```


```r
if (!is.na(Sys.getenv('CI', NA))) {
  Sys.setenv(R_CRAN_WEB = "https://cloud.r-project.org/")
} else {
  Sys.setenv(R_CRAN_WEB = "https://mirrors.tuna.tsinghua.edu.cn/CRAN")
}

pdb <- tools::CRAN_package_db()
sub_pdb <- subset(pdb, subset = !duplicated(pdb[, "Package"]) & pdb[, "Package"] %in% .packages(T))
pkg_pdb <- subset(sub_pdb,
  subset = grepl("Yihui Xie", sub_pdb[, "Maintainer"]) | grepl("Hadley Wickham", sub_pdb[, "Maintainer"]),
  select = c("Maintainer", "Package", "Version", "Published", "Title")
)

pkg_pdb <- transform(pkg_pdb, Title = gsub("(\\\n)", " ", Title))
```


```r
library(DT)
```


```r
datatable(pkg_pdb[order(pkg_pdb$Maintainer, decreasing = T), ],
  rownames = F, # 不显示行名
  extensions = c("Buttons", "RowGroup"),
  options = list(
    pageLength = 10, # 每页显示的行数
    language = list(url = "//cdn.datatables.net/plug-ins/1.10.11/i18n/Chinese.json"), # 汉化
    dom = "Brtp", # 去掉显示行数 i、过滤 f 的能力，翻页用 p 表示
    ordering = F, # 去掉列排序
    buttons = c("copy", "csv", "excel", "pdf", "print"), # 提供打印按钮
    rowGroup = list(dataSrc = 0), # 按 Maintainer 列分组
    columnDefs = list(
      list(className = "dt-center", targets = 0), # 不显示行名，则 targets 从 0 开始，否则从 1 开始
      list(visible = FALSE, targets = 0) # 不显示 Maintainer 列
    )
  ),
  caption = "谢大和哈神维护的 R 包"
)
```

```{=html}
<div id="htmlwidget-13107a707b2dea76ddd8" style="width:100%;height:auto;" class="datatables html-widget"></div>
<script type="application/json" data-for="htmlwidget-13107a707b2dea76ddd8">{"x":{"filter":"none","extensions":["Buttons","RowGroup"],"caption":"<caption>谢大和哈神维护的 R 包<\/caption>","data":[["Yihui Xie &lt;xie@yihui.name&gt;","Yihui Xie &lt;xie@yihui.name&gt;","Yihui Xie &lt;xie@yihui.name&gt;","Yihui Xie &lt;xie@yihui.name&gt;","Yihui Xie &lt;xie@yihui.name&gt;","Yihui Xie &lt;xie@yihui.name&gt;","Yihui Xie &lt;xie@yihui.name&gt;","Yihui Xie &lt;xie@yihui.name&gt;","Yihui Xie &lt;xie@yihui.name&gt;","Yihui Xie &lt;xie@yihui.name&gt;","Yihui Xie &lt;xie@yihui.name&gt;","Yihui Xie &lt;xie@yihui.name&gt;","Yihui Xie &lt;xie@yihui.name&gt;","Hadley Wickham &lt;hadley@rstudio.com&gt;","Hadley Wickham &lt;hadley@rstudio.com&gt;","Hadley Wickham &lt;hadley@rstudio.com&gt;","Hadley Wickham &lt;hadley@rstudio.com&gt;","Hadley Wickham &lt;hadley@rstudio.com&gt;","Hadley Wickham &lt;hadley@rstudio.com&gt;","Hadley Wickham &lt;hadley@rstudio.com&gt;","Hadley Wickham &lt;hadley@rstudio.com&gt;","Hadley Wickham &lt;hadley@rstudio.com&gt;","Hadley Wickham &lt;hadley@rstudio.com&gt;","Hadley Wickham &lt;hadley@rstudio.com&gt;","Hadley Wickham &lt;hadley@rstudio.com&gt;","Hadley Wickham &lt;hadley@rstudio.com&gt;","Hadley Wickham &lt;hadley@rstudio.com&gt;","Hadley Wickham &lt;hadley@rstudio.com&gt;","Hadley Wickham &lt;hadley@rstudio.com&gt;","Hadley Wickham &lt;hadley@rstudio.com&gt;","Hadley Wickham &lt;hadley@rstudio.com&gt;","Hadley Wickham &lt;hadley@rstudio.com&gt;","Hadley Wickham &lt;hadley@rstudio.com&gt;","Hadley Wickham &lt;hadley@rstudio.com&gt;","Hadley Wickham &lt;hadley@rstudio.com&gt;","Hadley Wickham &lt;hadley@rstudio.com&gt;","Hadley Wickham &lt;hadley@rstudio.com&gt;","Hadley Wickham &lt;h.wickham@gmail.com&gt;"],["bookdown","DT","evaluate","formatR","highr","knitr","markdown","mime","rmarkdown","servr","tinytex","xaringan","xfun","assertthat","cubelyr","dbplyr","dplyr","dtplyr","ellipsis","forcats","generics","gtable","haven","httr","lazyeval","modelr","plyr","productplots","rappdirs","roxygen2","rvest","scales","stringr","testthat","tidyr","tidyverse","waldo","reshape2"],["0.22","0.18","0.14","1.11","0.9","1.33","1.1","0.11","2.9","0.22","0.32","0.22","0.24","0.2.1","1.0.1","2.1.1","1.0.7","1.1.0","0.3.2","0.5.1","0.1.0","0.3.0","2.4.1","1.4.2","0.2.2","0.1.8","1.8.6","0.1.1","0.3.3","7.1.1","1.0.0","1.1.1","1.4.0","3.0.4","1.1.3","1.3.1","0.2.5","1.4.4"],["2021-04-22","2021-04-14","2019-05-28","2021-06-01","2021-04-16","2021-04-24","2019-08-07","2021-06-23","2021-06-15","2021-04-14","2021-05-29","2021-06-23","2021-06-15","2019-03-21","2020-11-24","2021-04-06","2021-06-18","2021-02-20","2021-04-29","2021-01-27","2020-10-31","2019-03-25","2021-04-23","2020-07-20","2019-03-15","2020-05-19","2020-03-03","2016-07-02","2021-01-31","2020-06-27","2021-03-09","2020-05-11","2019-02-10","2021-07-01","2021-03-03","2021-04-15","2021-03-08","2020-04-09"],["Authoring Books and Technical Documents with R Markdown","A Wrapper of the JavaScript Library 'DataTables'","Parsing and Evaluation Tools that Provide More Details than the Default","Format R Code Automatically","Syntax Highlighting for R Source Code","A General-Purpose Package for Dynamic Report Generation in R","Render Markdown with the C Library 'Sundown'","Map Filenames to MIME Types","Dynamic Documents for R","A Simple HTTP Server to Serve Static Files or Dynamic Documents","Helper Functions to Install and Maintain TeX Live, and Compile LaTeX Documents","Presentation Ninja","Supporting Functions for Packages Maintained by 'Yihui Xie'","Easy Pre and Post Assertions","A Data Cube 'dplyr' Backend","A 'dplyr' Back End for Databases","A Grammar of Data Manipulation","Data Table Back-End for 'dplyr'","Tools for Working with ...","Tools for Working with Categorical Variables (Factors)","Common S3 Generics not Provided by Base R Methods Related to Model Fitting","Arrange 'Grobs' in Tables","Import and Export 'SPSS', 'Stata' and 'SAS' Files","Tools for Working with URLs and HTTP","Lazy (Non-Standard) Evaluation","Modelling Functions that Work with the Pipe","Tools for Splitting, Applying and Combining Data","Product Plots for R","Application Directories: Determine Where to Save Data, Caches, and Logs","In-Line Documentation for R","Easily Harvest (Scrape) Web Pages","Scale Functions for Visualization","Simple, Consistent Wrappers for Common String Operations","Unit Testing for R","Tidy Messy Data","Easily Install and Load the 'Tidyverse'","Find Differences Between R Objects","Flexibly Reshape Data: A Reboot of the Reshape Package"]],"container":"<table class=\"display\">\n  <thead>\n    <tr>\n      <th>Maintainer<\/th>\n      <th>Package<\/th>\n      <th>Version<\/th>\n      <th>Published<\/th>\n      <th>Title<\/th>\n    <\/tr>\n  <\/thead>\n<\/table>","options":{"pageLength":10,"language":{"url":"//cdn.datatables.net/plug-ins/1.10.11/i18n/Chinese.json"},"dom":"Brtp","ordering":false,"buttons":["copy","csv","excel","pdf","print"],"rowGroup":{"dataSrc":0},"columnDefs":[{"className":"dt-center","targets":0},{"visible":false,"targets":0}],"order":[],"autoWidth":false,"orderClasses":false}},"evals":[],"jsHooks":[]}</script>
```





```r
colorize_num <- function(x) {
  ifelse(x > 0,
    sprintf("<span style='color:%s'>%s</span>", "green", x),
    sprintf("<span style='color:%s'>%s</span>", "red", x)
  )
}
colorize_pct <- function(x) {
  ifelse(x > 0,
    sprintf("<span style='color:%s'>%s</span>", "green", scales::percent(x, accuracy = 0.01)),
    sprintf("<span style='color:%s'>%s</span>", "red", scales::percent(x, accuracy = 0.01))
  )
}

colorize_pp <- function(x) {
  ifelse(x > 0,
    sprintf("<span style='color:%s'>%s</span>", "green", paste0(round(100*x, digits = 2), "PP")),
    sprintf("<span style='color:%s'>%s</span>", "red", paste0(round(100*x, digits = 2), "PP"))
  )
}

colorize_text <- function(x, color = "red") {
    sprintf("<span style='color:%s'>%s</span>", color, x )
}

library(tibble)

dat = tribble(
  ~name1, ~name2,
  as.character(htmltools::tags$b("加粗")), as.character(htmltools::a(href = "https://rstudio.com", "超链")), # 支持超链接
  as.character(htmltools::em("强调")), '<a href="#" onclick="alert(\'Hello World\');">Hello</a>',
  as.character(htmltools::span(style = 'color:red', "正常")), '正常'
)

datatable(
  data = dat,
  escape = F, # 设置 escape = F
  colnames = c(colorize_text("第1列", "red"), as.character(htmltools::em("第2列"))),
  caption = htmltools::tags$caption(
    style = "caption-side: top; text-align: center;",
    "表格 2: ", htmltools::em("表格标题")
  ), # 在表格底部显示标题，默认在表格上方显示标题
  # filter = "top", # 过滤框
  options = list(
    pageLength = 5, # 每页显示5行
    dom = "t"
  )
)
```

```{=html}
<div id="htmlwidget-87ceffa500a25d45d3bf" style="width:100%;height:auto;" class="datatables html-widget"></div>
<script type="application/json" data-for="htmlwidget-87ceffa500a25d45d3bf">{"x":{"filter":"none","caption":"<caption style=\"caption-side: top; text-align: center;\">\n  表格 2: \n  <em>表格标题<\/em>\n<\/caption>","data":[["1","2","3"],["<b>加粗<\/b>","<em>强调<\/em>","<span style=\"color:red\">正常<\/span>"],["<a href=\"https://rstudio.com\">超链<\/a>","<a href=\"#\" onclick=\"alert('Hello World');\">Hello<\/a>","正常"]],"container":"<table class=\"display\">\n  <thead>\n    <tr>\n      <th> <\/th>\n      <th><span style='color:red'>第1列<\/span><\/th>\n      <th><em>第2列<\/em><\/th>\n    <\/tr>\n  <\/thead>\n<\/table>","options":{"pageLength":5,"dom":"t","order":[],"autoWidth":false,"orderClasses":false,"columnDefs":[{"orderable":false,"targets":0}],"lengthMenu":[5,10,25,50,100]}},"evals":[],"jsHooks":[]}</script>
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
## [1] kableExtra_1.3.4 reactable_0.2.3  tibble_3.1.2     DT_0.18         
## [5] magrittr_2.0.1  
## 
## loaded via a namespace (and not attached):
##  [1] pillar_1.6.1      bslib_0.2.5.1     compiler_4.1.0    jquerylib_0.1.4  
##  [5] tools_4.1.0       digest_0.6.27     viridisLite_0.4.0 jsonlite_1.7.2   
##  [9] evaluate_0.14     lifecycle_1.0.0   pkgconfig_2.0.3   rlang_0.4.11     
## [13] rstudioapi_0.13   crosstalk_1.1.1   yaml_2.2.1        xfun_0.24        
## [17] stringr_1.4.0     httr_1.4.2        knitr_1.33        xml2_1.3.2       
## [21] systemfonts_1.0.2 htmlwidgets_1.5.3 sass_0.4.0        vctrs_0.3.8      
## [25] webshot_0.5.2     svglite_2.0.0     glue_1.4.2        R6_2.5.0         
## [29] fansi_0.5.0       rmarkdown_2.9     bookdown_0.22     scales_1.1.1     
## [33] ellipsis_0.3.2    htmltools_0.5.1.1 rvest_1.0.0       colorspace_2.0-2 
## [37] utf8_1.2.1        stringi_1.6.2     munsell_0.5.0     crayon_1.4.1
```
