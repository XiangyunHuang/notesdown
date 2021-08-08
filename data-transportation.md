# 数据搬运 {#chap-data-transportation}

导入数据与导出数据，各种数据格式，数据库

处理 Excel 2003 (XLS) 和 Excel 2007 (XLSX) 文件还可以使用 [WriteXLS](https://github.com/marcschwartz/WriteXLS) 包，不过它依赖于 Perl，另一个 R 包 [xlsx](	https://github.com/dragua/rexcel) 与之功能类似，依赖 Java 环境。Jennifer Bryan 和 Hadley Wickham 开发的 [readxl](https://github.com/tidyverse/readxl) 包和 Jeroen Ooms 开发的 [writexl](https://github.com/ropensci/writexl) 包专门处理 xlsx 格式并且无任何系统依赖。

## 导入数据 {#import-data}

Base R 针对不同的数据格式文件，提供了大量的数据导入和导出函数，不愧是专注数据分析20余年的优秀统计软件。 除了函数 `write.ftable` 和 `read.ftable` 来自 stats 包，都来自 base 和 utils 包


```r
# 当前环境的搜索路径
searchpaths()
```

```
## [1] ".GlobalEnv"                          
## [2] "/opt/R/4.1.0/lib/R/library/stats"    
## [3] "/opt/R/4.1.0/lib/R/library/graphics" 
## [4] "/opt/R/4.1.0/lib/R/library/grDevices"
## [5] "/opt/R/4.1.0/lib/R/library/utils"    
## [6] "/opt/R/4.1.0/lib/R/library/datasets" 
## [7] "/opt/R/4.1.0/lib/R/library/methods"  
## [8] "Autoloads"                           
## [9] "/opt/R/4.1.0/lib/R/library/base"
```

```r
# 返回匹配结果及其所在路径的编号
apropos("^(read|write)", where = TRUE, mode = "function")
```

```
##                  5                  5                  9                  5 
##         "read.csv"        "read.csv2"         "read.dcf"       "read.delim" 
##                  5                  5                  5                  2 
##      "read.delim2"         "read.DIF"     "read.fortran"      "read.ftable" 
##                  5                  5                  5                  9 
##         "read.fwf"      "read.socket"       "read.table"          "readBin" 
##                  9                  5                  9                  9 
##         "readChar" "readCitationFile"         "readline"        "readLines" 
##                  9                  9                  9                  5 
##          "readRDS"     "readRenviron"            "write"        "write.csv" 
##                  5                  9                  2                  5 
##       "write.csv2"        "write.dcf"     "write.ftable"     "write.socket" 
##                  5                  9                  9                  9 
##      "write.table"         "writeBin"        "writeChar"       "writeLines"
```

### `scan` {#scan-file}


```r
scan(file = "", what = double(), nmax = -1, n = -1, sep = "",
     quote = if(identical(sep, "\n")) "" else "'\"", dec = ".",
     skip = 0, nlines = 0, na.strings = "NA",
     flush = FALSE, fill = FALSE, strip.white = FALSE,
     quiet = FALSE, blank.lines.skip = TRUE, multi.line = TRUE,
     comment.char = "", allowEscapes = FALSE,
     fileEncoding = "", encoding = "unknown", text, skipNul = FALSE)
```

首先让我们用 `cat` 函数创建一个练习数据集 `ex.data`


```r
cat("TITLE extra line", "2 3 5 7", "11 13 17")
```

```
## TITLE extra line 2 3 5 7 11 13 17
```

```r
cat("TITLE extra line", "2 3 5 7", "11 13 17", file = "data/ex.data", sep = "\n")
```

以此练习数据集，介绍 `scan` 函数最常用的参数


```r
scan("data/ex.data")
```

```
## Error in scan("data/ex.data"): scan() expected 'a real', got 'TITLE'
```

从上面的报错信息，我们发现 `scan` 函数只能读取同一类型的数据，如布尔型 logical， 整型 integer，数值型 numeric(double)， 复数型 complex，字符型 character，raw 和列表 list。所以我们设置参数 `skip = 1` 把第一行跳过，就成功读取了数据


```r
scan("data/ex.data", skip = 1)
```

```
## [1]  2  3  5  7 11 13 17
```

如果设置参数 `quiet = TRUE` 就不会报告读取的数据量


```r
scan("data/ex.data", skip = 1, quiet = TRUE)
```

```
## [1]  2  3  5  7 11 13 17
```

参数 `nlines = 1` 表示只读取一行数据


```r
scan("data/ex.data", skip = 1, nlines = 1) # only 1 line after the skipped one
```

```
## [1] 2 3 5 7
```

默认参数 `flush = TRUE` 表示读取最后一个请求的字段后，刷新到行尾，下面对比一下读取的结果


```r
scan("data/ex.data", what = list("", "", "")) # flush is F -> read "7"
```

```
## Warning in scan("data/ex.data", what = list("", "", "")): number of items read
## is not a multiple of the number of columns
```

```
## [[1]]
## [1] "TITLE" "2"     "7"     "17"   
## 
## [[2]]
## [1] "extra" "3"     "11"    ""     
## 
## [[3]]
## [1] "line" "5"    "13"   ""
```

```r
scan("data/ex.data", what = list("", "", ""), flush = TRUE)
```

```
## [[1]]
## [1] "TITLE" "2"     "11"   
## 
## [[2]]
## [1] "extra" "3"     "13"   
## 
## [[3]]
## [1] "line" "5"    "17"
```

临时文件 ex.data 用完了，我们调用 `unlink` 函数将其删除，以免留下垃圾文件


```r
unlink("data/ex.data") # tidy up
```

### `read.table` {#read-write-table}


```r
read.table(file, header = FALSE, sep = "", quote = "\"'",
           dec = ".", numerals = c("allow.loss", "warn.loss", "no.loss"),
           row.names, col.names, as.is = !stringsAsFactors,
           na.strings = "NA", colClasses = NA, nrows = -1,
           skip = 0, check.names = TRUE, fill = !blank.lines.skip,
           strip.white = FALSE, blank.lines.skip = TRUE,
           comment.char = "#",
           allowEscapes = FALSE, flush = FALSE,
           stringsAsFactors = default.stringsAsFactors(),
           fileEncoding = "", encoding = "unknown", text, skipNul = FALSE)

read.csv(file, header = TRUE, sep = ",", quote = "\"",
         dec = ".", fill = TRUE, comment.char = "", ...)

read.csv2(file, header = TRUE, sep = ";", quote = "\"",
          dec = ",", fill = TRUE, comment.char = "", ...)

read.delim(file, header = TRUE, sep = "\t", quote = "\"",
           dec = ".", fill = TRUE, comment.char = "", ...)

read.delim2(file, header = TRUE, sep = "\t", quote = "\"",
            dec = ",", fill = TRUE, comment.char = "", ...)
```

变量名是不允许以下划线开头的，同样在数据框里，列名也不推荐使用下划线开头。默认情况下，`read.table` 都会通过参数 `check.names` 检查列名的有效性，该参数实际调用了函数 `make.names` 去检查。如果想尽量保持数据集原来的样子可以设置参数 `check.names = FALSE, stringsAsFactors = FALSE`。 默认情形下，`read.table` 还会将字符串转化为因子变量，这是 R 的历史原因，作为一门统计学家的必备语言，在统计模型中，字符常用来描述类别，而类别变量在 R 环境中常用因子类型来表示，而且大量内置的统计模型也是将它们视为因子变量，如 `lm` 、`glm` 等


```r
dat1 = read.table(header = TRUE, check.names = TRUE, text = "
_a _b _c
1 2 a1
3 4 a2
")
dat1
```

```
##   X_a X_b X_c
## 1   1   2  a1
## 2   3   4  a2
```

```r
dat2 = read.table(header = TRUE, check.names = FALSE, text = "
_a _b _c
1 2 a1
3 4 a2
")
dat2
```

```
##   _a _b _c
## 1  1  2 a1
## 2  3  4 a2
```

```r
dat3 = read.table(header = TRUE, check.names = FALSE, stringsAsFactors = FALSE, text = "
_a _b _c
1 2 a1
3 4 a2
")
dat3
```

```
##   _a _b _c
## 1  1  2 a1
## 2  3  4 a2
```

### `readLines` {#read-write-lines}


```r
readLines(con = stdin(), n = -1L, ok = TRUE, warn = TRUE,
          encoding = "unknown", skipNul = FALSE)
```

让我们折腾一波，读进来又写出去，只有 R 3.5.3 以上才能保持原样的正确输入输出，因为这里有一个之前版本包含的 BUG


```r
writeLines(readLines(system.file("DESCRIPTION", package = "splines")), "data/DESCRIPTION")
# 比较一下
identical(
  readLines(system.file("DESCRIPTION", package = "splines")),
  readLines("data/DESCRIPTION")
)
```

```
## [1] TRUE
```

这次我们创建一个真的临时文件，因为重新启动 R 这个文件和文件夹就没有了，回收掉了


```r
fil <- tempfile(fileext = ".data")
cat("TITLE extra line", "2 3 5 7", "", "11 13 17", file = fil,
    sep = "\n")
fil
```

```
## [1] "/tmp/RtmpUxOoKj/file62853c377b90.data"
```

设置参数 `n = -1` 表示将文件 fil 的内容从头读到尾


```r
readLines(fil, n = -1)
```

```
## [1] "TITLE extra line" "2 3 5 7"          ""                 "11 13 17"
```

作为拥有良好习惯的 R 用户，这种垃圾文件最好用后即焚


```r
unlink(fil) # tidy up
```

再举个例子，我们创建一个新的临时文件 `fil`，文件内容只有


```r
cat("123\nabc")
```

```
## 123
## abc
```

```r
fil <- tempfile("test")
cat("123\nabc\n", file = fil, append = TRUE)
fil
```

```
## [1] "/tmp/RtmpUxOoKj/test628516639ee7"
```

```r
readLines(fil)
```

```
## [1] "123" "abc"
```

这次读取文件的过程给出了警告，原因是 fil 没有以空行结尾，`warn = TRUE` 表示这种情况要给出警告，如果设置参数 `warn = FALSE` 就没有警告。我们还是建议大家尽量遵循规范。

再举一个例子，从一个连接读取数据，建立连接的方式有很多，参见 `?file`，下面设置参数 `blocking`


```r
con <- file(fil, "r", blocking = FALSE)
readLines(con)
```

```
## [1] "123" "abc"
```

```r
cat(" def\n", file = fil, append = TRUE)
readLines(con)
```

```
## [1] " def"
```

```r
# 关闭连接
close(con)
# 清理垃圾文件
unlink(fil)
```


### `readRDS` {#read-save-rds}

序列化数据操作，Mark Klik 开发的 [fst](https://github.com/fstpackage/fst) 和 [Travers Ching](https://travers.im/) 开发的 [qs](https://github.com/traversc/qs)， Hadley Wickham 开发的 [feather](https://github.com/wesm/feather/tree/master/R) 包实现跨语言环境快速的读写数据

Table: (\#tab:fst-vs-others) fst 序列化数据框对象性能比较 BaseR、 data.table 和 feather [^fst-performance]

| Method         | Format  | Time (ms) | Size (MB) | Speed (MB/s) | N       |
| :------------- | :------ | :-------- | :-------- | :----------- | :------ |
| readRDS        | bin     | 1577      | 1000      | 633          | 112     |
| saveRDS        | bin     | 2042      | 1000      | 489          | 112     |
| fread          | csv     | 2925      | 1038      | 410          | 232     |
| fwrite         | csv     | 2790      | 1038      | 358          | 241     |
| read\_feather  | bin     | 3950      | 813       | 253          | 112     |
| write\_feather | bin     | 1820      | 813       | 549          | 112     |
| **read\_fst**  | **bin** | **457**   | **303**   | **2184**     | **282** |
| **write\_fst** | **bin** | **314**   | **303**   | **3180**     | **291** |

目前比较好的是 qs 和 fst 包 

[^fst-performance]: https://www.fstpackage.org/ 

## 其它数据格式 {#other-data-source}

来自其它格式的数据形式，如 JSON、XML、YAML 需要转化清理成 R 中数据框的形式 data.frame 

1. [Data Rectangling with jq](https://www.carlboettiger.info/2017/12/11/data-rectangling-with-jq/)
1. [Mongolite User Manual](https://jeroen.github.io/mongolite/) introduction to using MongoDB with the mongolite client in R

[jsonlite](https://github.com/jeroen/jsonlite) 读取 `*.json` 格式的文件，`jsonlite::write_json` 函数将 R对象保存为 JSON 文件，`jsonlite::fromJSON` 将 json 字符串或文件转化为 R 对象，`jsonlite::toJSON` 函数正好与之相反


```r
library(jsonlite)
# 从 json 格式的文件导入
# jsonlite::read_json(path = "path/to/filename.json")
# A JSON array of primitives
json <- '["Mario", "Peach", null, "Bowser"]'

# 简化为原子向量atomic vector
fromJSON(json)
```

```
## [1] "Mario"  "Peach"  NA       "Bowser"
```

```r
# 默认返回一个列表
fromJSON(json, simplifyVector = FALSE)
```

```
## [[1]]
## [1] "Mario"
## 
## [[2]]
## [1] "Peach"
## 
## [[3]]
## NULL
## 
## [[4]]
## [1] "Bowser"
```

yaml 包读取 `*.yml` 格式文件，返回一个列表，`yaml::write_yaml` 函数将 R 对象写入 yaml 格式 


```r
library(yaml)
yaml::read_yaml(file = '_bookdown.yml')
```

```
## $book_filename
## [1] "masr"
## 
## $delete_merged_file
## [1] TRUE
## 
## $language
## $language$label
## $language$label$fig
## [1] "图 "
## 
## $language$label$tab
## [1] "表 "
## 
## 
## $language$ui
## $language$ui$edit
## [1] "编辑"
## 
## $language$ui$chapter_name
## [1] "第 " " 章"
## 
## $language$ui$appendix_name
## [1] "附录 "
## 
## 
## 
## $new_session
## [1] TRUE
## 
## $before_chapter_script
## [1] "_common.R"
## 
## $rmd_files
##  [1] "index.Rmd"                       "preface.Rmd"                    
##  [3] "notations.Rmd"                   "file-operations.Rmd"            
##  [5] "data-structure.Rmd"              "data-manipulation.Rmd"          
##  [7] "data-transportation.Rmd"         "graphics-foundations.Rmd"       
##  [9] "data-visualization.Rmd"          "dynamic-documents.Rmd"          
## [11] "interactive-web-graphics.Rmd"    "interactive-data-tables.Rmd"    
## [13] "interactive-shiny-app.Rmd"       "string-operations.Rmd"          
## [15] "regular-expressions.Rmd"         "text-analysis.Rmd"              
## [17] "sampling-distributions.Rmd"      "parameter-estimators.Rmd"       
## [19] "hypothesis-test.Rmd"             "power-analysis.Rmd"             
## [21] "experimental-design.Rmd"         "linear-models.Rmd"              
## [23] "generalized-linear-models.Rmd"   "case-study.Rmd"                 
## [25] "data-explorer.Rmd"               "survival-analysis.Rmd"          
## [27] "time-series-analysis.Rmd"        "spatial-analysis.Rmd"           
## [29] "spatial-modeling.Rmd"            "bayesian-models.Rmd"            
## [31] "gradient-boosting-machine.Rmd"   "neural-networks.Rmd"            
## [33] "matrix-operations.Rmd"           "symbolic-computation.Rmd"       
## [35] "numerical-optimization.Rmd"      "appendix.Rmd"                   
## [37] "other-softwares.Rmd"             "mixed-programming.Rmd"          
## [39] "object-oriented-programming.Rmd" "references.Rmd"
```

Table: (\#tab:other-softwares) 导入来自其它数据分析软件产生的数据集

|    统计软件       |         R函数     |        R包
|:------------------|:------------------|:------------------
|ERSI ArcGIS        |  `read.shapefile` |   shapefiles
|Matlab             |  `readMat`        |   R.matlab
|minitab            |  `read.mtp`       |   foreign
|SAS (permanent data)| `read.ssd`       |   foreign
|SAS (XPORT format)|   `read.xport`     |   foreign
|SPSS              |   `read.spss`      |   foreign
|Stata             |   `read.dta`       |   foreign
|Systat            |   `read.systat`    |   foreign
|Octave            |   `read.octave`    |   foreign

Table: (\#tab:other-read-functions) 导入来自其它格式的数据集

|    文件格式       |         R函数     |        R包
|:------------------|:------------------|:------------------
|    列联表数据     |  `read.ftable`    |   stats
|    二进制数据     |  `readBin`        |   base
|    字符串数据     |  `readChar`       |   base
|    剪贴板数据     |  `readClipboard`  |   utils

`read.dcf` 函数读取 Debian 控制格式文件，这种类型的文件以人眼可读的形式在存储数据，如 R 包的 DESCRIPTION 文件或者包含所有 CRAN 上 R 包描述的文件 <https://cran.r-project.org/src/contrib/PACKAGES>


```r
x <- read.dcf(file = system.file("DESCRIPTION", package = "splines"),
              fields = c("Package", "Version", "Title"))
x
```

```
##      Package   Version Title                                    
## [1,] "splines" "4.1.0" "Regression Spline Functions and Classes"
```

最后要提及拥有瑞士军刀之称的 [rio](https://github.com/leeper/rio) 包，它集合了当前 R 可以读取的所有统计分析软件导出的数据。

## 导入大数据集 {#import-large-dataset}

在不使用数据库的情况下，从命令行导入大数据集，如几百 M 或几个 G 的 csv 文件。利用 data.table 包的 `fread` 去读取

<https://stackoverflow.com/questions/1727772/>

## 从数据库导入 {#import-data-from-database}

[Hands-On Programming with R](https://rstudio-education.github.io/hopr) 数据读写章节[^dataio] 以及 [R, Databases and Docker](https://smithjd.github.io/sql-pet/)

将大量的 txt 文本存进 MySQL 数据库中，通过操作数据库来聚合文本，极大降低内存消耗 [^txt-to-mysql]，而 ODBC 与 DBI 包是其它数据库接口的基础，knitr 提供了一个支持 SQL 代码的引擎，它便是基于 DBI，因此可以在 R Markdown 文档中直接使用 SQL 代码块 [^sql-engine]。这里制作一个归纳表格，左边数据库右边对应其 R 接口，两边都包含链接，如表 \@ref(tab:dbi) 所示

\begin{table}

\caption{(\#tab:dbi)数据库接口}
\centering
\begin{tabular}[t]{l|l|l|l}
\hline
数据库 & 官网 & R接口 & 开发仓\\
\hline
MySQL & https://www.mysql.com/ & RMySQL & https://github.com/r-dbi/RMySQL\\
\hline
SQLite & https://www.sqlite.org & RSQLite & https://github.com/r-dbi/RSQLite\\
\hline
PostgreSQL & https://www.postgresql.org/ & RPostgres & https://github.com/r-dbi/RPostgres\\
\hline
MariaDB & https://mariadb.org/ & RMariaDB & https://github.com/r-dbi/RMariaDB\\
\hline
\end{tabular}
\end{table}



### PostgreSQL

[odbc](https://github.com/r-dbi/odbc) 可以支持很多数据库，下面以连接 [PostgreSQL](https://www.postgresql.org/) 数据库为例介绍其过程

首先在某台机器上，拉取 PostgreSQL 的 Docker 镜像


```bash
docker pull postgres
```

在 Docker 上运行 PostgreSQL，主机端口号 8181 映射给数据库 PostgreSQL 的默认端口号 5432（或其它你的 DBA 分配给你的端口）


```bash
docker run --name psql -d -p 8181:5432 -e ROOT=TRUE \
   -e USER=xiangyun -e PASSWORD=cloud postgres
```

在主机 Ubuntu 上配置


```bash
sudo apt-get install unixodbc unixodbc-dev odbc-postgresql
```

端口 5432 是分配给 PostgreSQL 的默认端口，`host` 可以是云端的地址，如 你的亚马逊账户下的 PostgreSQL 数据库地址 `<ec2-54-83-201-96.compute-1.amazonaws.com>`，也可以是本地局域网IP地址，如`<192.168.1.200>`。通过参数 `dbname` 连接到指定的 PostgreSQL 数据库，如 Heroku，这里作为演示就以默认的数据库 `postgres` 为例

查看配置系统文件路径

```bash
odbcinst -j 
```
```
unixODBC 2.3.6
DRIVERS............: /etc/odbcinst.ini
SYSTEM DATA SOURCES: /etc/odbc.ini
FILE DATA SOURCES..: /etc/ODBCDataSources
USER DATA SOURCES..: /root/.odbc.ini
SQLULEN Size.......: 8
SQLLEN Size........: 8
SQLSETPOSIROW Size.: 8
```

不推荐修改全局配置文件，可设置 `ODBCSYSINI` 环境变量指定配置文件路径，如 `ODBCSYSINI=~/ODBC` <http://www.unixodbc.org/odbcinst.html>

安装完驱动程序，`/etc/odbcinst.ini` 文件内容自动更新，我们可以不必修改，如果你想自定义不妨手动修改，我们查看在 R 环境中注册的数据库，可以看到 PostgreSQL 的驱动已经配置好

```r
odbc::odbcListDrivers()
```
```
                 name   attribute                                    value
1     PostgreSQL ANSI Description    PostgreSQL ODBC driver (ANSI version)
2     PostgreSQL ANSI      Driver                             psqlodbca.so
3     PostgreSQL ANSI       Setup                          libodbcpsqlS.so
4     PostgreSQL ANSI       Debug                                        0
5     PostgreSQL ANSI     CommLog                                        1
6     PostgreSQL ANSI  UsageCount                                        1
7  PostgreSQL Unicode Description PostgreSQL ODBC driver (Unicode version)
8  PostgreSQL Unicode      Driver                             psqlodbcw.so
9  PostgreSQL Unicode       Setup                          libodbcpsqlS.so
10 PostgreSQL Unicode       Debug                                        0
11 PostgreSQL Unicode     CommLog                                        1
12 PostgreSQL Unicode  UsageCount                                        1
```

系统配置文件 `/etc/odbcinst.ini` 已经包含有 PostgreSQL 的驱动配置，无需再重复配置

```
[PostgreSQL ANSI]
Description=PostgreSQL ODBC driver (ANSI version)
Driver=psqlodbca.so
Setup=libodbcpsqlS.so
Debug=0
CommLog=1
UsageCount=1

[PostgreSQL Unicode]
Description=PostgreSQL ODBC driver (Unicode version)
Driver=psqlodbcw.so
Setup=libodbcpsqlS.so
Debug=0
CommLog=1
UsageCount=1
```

只需将如下内容存放在 `~/.odbc.ini` 文件中，

```
[PostgreSQL]
Driver              = PostgreSQL Unicode
Database            = postgres
Servername          = 172.17.0.1
UserName            = postgres
Password            = default
Port                = 8080
```

最后，一行命令 DNS 配置连接 <https://github.com/r-dbi/odbc> 这样就实现了代码中无任何敏感信息，这里为了展示这个配置过程故而把相关信息公开。

> 注意下面的内容需要在容器中运行， Windows 环境下的配置 PostgreSQL 的驱动有点麻烦就不搞了，意义也不大，现在数据库基本都是跑在 Linux 系统上

`docker-machine.exe ip default` 可以获得本地 Docker 的 IP，比如 192.168.99.101。 Travis 上 `ip addr` 可以查看 Docker 的 IP，如 172.17.0.1

```r
library(DBI)
con <- dbConnect(RPostgres::Postgres(),
  dbname = "postgres",
  host = ifelse(is_on_travis, Sys.getenv("DOCKER_HOST_IP"), "192.168.99.101"),
  port = 8080,
  user = "postgres",
  password = "default"
)
```
```r
library(DBI)
con <- dbConnect(odbc::odbc(), "PostgreSQL")
```

列出数据库中的所有表

```r
dbListTables(con)
```

第一次启动从 Docker Hub 上下载的镜像，默认的数据库是 postgres 里面没有任何表，所以将 R 环境中的 mtcars 数据集写入 postgres 数据库

将数据集 mtcars 写入 PostgreSQL 数据库中，基本操作，写入表的操作也不能缓存，即不能缓存数据库中的表 mtcars

```r
dbWriteTable(con, "mtcars", mtcars, overwrite = TRUE)
```

现在可以看到数据表 mtcars 的各个字段

```r
dbListFields(con, "mtcars")
```

最后执行一条 SQL 语句

```r
res <- dbSendQuery(con, "SELECT * FROM mtcars WHERE cyl = 4") # 发送 SQL 语句
dbFetch(res) # 获取查询结果
dbClearResult(res) # 清理查询通道
```

或者一条命令搞定

```r
dbGetQuery(con, "SELECT * FROM mtcars WHERE cyl = 4")
```

再复杂一点的 SQL 查询操作

```r
dbGetQuery(con, "SELECT cyl, AVG(mpg) AS mpg FROM mtcars GROUP BY cyl ORDER BY cyl")
aggregate(mpg ~ cyl, data = mtcars, mean)
```

得益于 knitr [@xie2015] 开发的钩子，这里直接写 SQL 语句块，值得注意的是 SQL 代码块不能启用缓存，数据库连接通道也不能缓存，如果数据库中还没有写入表，那么写入表的操作也不能缓存， `tab.cap = "表格标题"` 输出的内容是一个表格

```sql
SELECT cyl, AVG(mpg) AS mpg FROM mtcars GROUP BY cyl ORDER BY cyl
```

如果将查询结果导出到变量，在 Chunk 设置 `output.var = "agg_cyl"` 可以使用缓存，下面将 mpg 按 cyl 分组聚合的结果打印出来，`ref.label = "mtcars"` 引用上一个 SQL 代码块的内容

这种基于 odbc 的方式的好处就不需要再安装 R 包 RPostgres 和相关系统依赖，最后关闭连接通道

```r
dbDisconnect(con)
```

### MySQL

MySQL 是一个很常见，应用也很广泛的数据库，数据分析的常见环境是在一个R Notebook 里，我们可以在正文之前先设定数据库连接信息


````
```{r setup}
library(DBI)
# 指定数据库连接信息
db <- dbConnect(RMySQL::MySQL(),
  dbname = 'dbtest',
  username = 'user_test',
  password = 'password',
  host = '10.10.101.10',
  port = 3306
)
# 创建默认连接
knitr::opts_chunk$set(connection = 'db')
# 设置字符编码，以免中文查询乱码
DBI::dbSendQuery(db, 'SET NAMES utf8')
# 设置日期变量，以运用在SQL中
idate <- '2019-05-03'
```
````

SQL 代码块中使用 R 环境中的变量，并将查询结果输出为R环境中的数据框


````
```{sql, output.var='data_output'}
SELECT * FROM user_table where date_format(created_date,'%Y-%m-%d')>=?idate
```
````

以上代码会将 SQL 的运行结果存在 `data_output` 这是数据库中，idate 取之前设置的日期`2019-05-03`，`user_table` 是 MySQL 数据库中的表名，`created_date` 是创建`user_table`时，指定的日期名。

如果 SQL 比较长，为了代码美观，把带有变量的 SQL 保存为`demo.sql`脚本，只需要在 SQL 的 chunk 中直接读取 SQL 文件[^sql-chunck]。


````
```{sql, code=readLines('demo.sql'), output.var='data_output'}
```
````

如果我们需要每天或者按照指定的日期重复地运行这个 R Markdown 文件，可以在 YAML 部分引入参数[^params-knit]

```markdown
---
params:
  date: "2019-05-03"  # 参数化日期
---
```

````
```{r setup, include=FALSE}
idate = params$date # 将参数化日期传递给 idate 变量
```
````

我们将这个 Rmd 文件命名为 `MyDocument.Rmd`，运行这个文件可以从 R 控制台执行或在 RStudio 点击 knit。


```r
rmarkdown::render("MyDocument.Rmd", params = list(
  date = "2019-05-03"
))
```

如果在文档的 YAML 位置已经指定日期，这里可以不指定。注意在这里设置日期会覆盖 YAML 处指定的参数值，这样做的好处是可以批量化操作。

### Spark

当数据分析报告遇上 Spark 时，就需要 [SparkR](https://github.com/apache/spark/tree/master/R)、 [sparklyr](https://github.com/rstudio/sparklyr)、 [arrow](https://github.com/apache/arrow/tree/master/r) 或 [rsparking](https://github.com/h2oai/sparkling-water/tree/master/r) 接口了， Javier Luraschi 写了一本书 [The R in Spark: Learning Apache Spark with R](https://therinspark.com/) 详细介绍了相关扩展和应用

首先安装 sparklyr 包，RStudio 公司 Javier Lurasch 开发了 sparklyr 包，作为 Spark 与 R 语言之间的接口，安装完 sparklyr 包，还是需要 Spark 和 Hadoop 环境


```r
install.packages('sparklyr')
library(sparklyr)
spark_install()
# Installing Spark 2.4.0 for Hadoop 2.7 or later.
# Downloading from:
# - 'https://archive.apache.org/dist/spark/spark-2.4.0/spark-2.4.0-bin-hadoop2.7.tgz'
# Installing to:
# - '~/spark/spark-2.4.0-bin-hadoop2.7'
# trying URL 'https://archive.apache.org/dist/spark/spark-2.4.0/spark-2.4.0-bin-hadoop2.7.tgz'
# Content type 'application/x-gzip' length 227893062 bytes (217.3 MB)
# ==================================================
# downloaded 217.3 MB
# 
# Installation complete.
```

既然 sparklyr 已经安装了 Spark 和 Hadoop 环境，安装 SparkR 后，只需配置好路径，就可以加载 SparkR 包


```r
install.packages('SparkR')
if (nchar(Sys.getenv("SPARK_HOME")) < 1) {
  Sys.setenv(SPARK_HOME = "~/spark/spark-2.4.0-bin-hadoop2.7")
}
library(SparkR, lib.loc = c(file.path(Sys.getenv("SPARK_HOME"), "R", "lib")))
sparkR.session(master = "local[*]", sparkConfig = list(spark.driver.memory = "2g"))
```

[rscala](https://github.com/dbdahl/rscala) 架起了 R 和 Scala 两门语言之间交流的桥梁，使得彼此之间可以互相调用

> 是否存在这样的可能， Spark 提供了大量的 MLib 库的调用接口，R 的功能支持是最少的，Java/Scala 是原生的，那么要么自己开发新的功能整合到 SparkR 中，要么借助 rscala 将 scala 接口代码封装进来 

在本地，Windows 主机上，可以在 `.Rprofile` 中给 Spark 添加环境变量 `SPARK_HOME` 指定其安装路径，


```r
# Windows 平台默认安装路径
Sys.setenv(SPARK_HOME = "C:/Users/XiangYun/AppData/Local/spark/spark-2.4.3-bin-hadoop2.7")
library(sparklyr)
sc <- spark_connect(master = "local", version = "2.4")
```

将 R 环境中的数据集 mtcars 传递到 Spark 上


```r
cars <- copy_to(sc, mtcars)
cars
```
```
# Source: spark<mtcars> [?? x 11]
    mpg   cyl  disp    hp  drat    wt  qsec    vs    am  gear  carb
  <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl>
1  21       6   160   110  3.9   2.62  16.5     0     1     4     4
2  21       6   160   110  3.9   2.88  17.0     0     1     4     4
3  22.8     4   108    93  3.85  2.32  18.6     1     1     4     1
4  21.4     6   258   110  3.08  3.22  19.4     1     0     3     1
5  18.7     8   360   175  3.15  3.44  17.0     0     0     3     2
6  18.1     6   225   105  2.76  3.46  20.2     1     0     3     1
# ... with more rows
```

监控和分析命令执行的情况，可以在浏览器中，见图 \@ref(fig:spark-web)


```r
spark_web(sc)
```
\begin{figure}

{\centering \includegraphics[width=6.4in]{screenshots/spark-start} 

}

\caption{Spark Web 接口}(\#fig:spark-web)
\end{figure}

传递 SQL 查询语句，比如数据集 mtcars 有多少行


```r
library(DBI)
dbGetQuery(sc, "SELECT count(*) FROM mtcars")
```
```
  count(1)
1       32
```

进一步地，我们可以调用 dplyr 包来写数据操作，避免写复杂逻辑的 SQL 语句，


```r
# library(dplyr) # 数据操作
library(tidyverse) # 提供更多功能，包括数据可视化
count(cars)
```

再举一个稍复杂的操作，先从数据集 cars 中选择两个字段 hp 和 mpg


```r
select(cars, hp, mpg) %>%
  sample_n(100) %>% # 随机选择 100 行
  collect() %>% # 执行 SQL 查询，将结果返回到本地
  ggplot(aes(hp, mpg)) + # 绘图
  geom_point()
```

数据查询和结果可视化，见图 \@ref(fig:spark-mtcars)

\begin{figure}

{\centering \includegraphics[width=1.6in]{screenshots/spark-mtcars} 

}

\caption{数据聚合和可视化}(\#fig:spark-mtcars)
\end{figure}

用完要记得关闭连接


```r
spark_disconnect(sc)
```

::: rmdwarning
不要使用 SparkR 接口，要使用 sparklyr， 后者的功能已经全面覆盖前者，生态方面更是更是已经远远超越，它有大厂 RStudio 支持，是公司支持的旗舰项目。但是 sparklyr 的版本稍微比最新的 Spark 低一两个版本，这是开发周期和出于稳定性的考虑，无伤大雅！
:::

Spark 提供了官方 R 语言接口 SparkR。Spark JVM 和 SparkR 包版本要匹配，比如从 CRAN 上安装了最新版的 SparkR，比如版本 2.4.4 就要去 Spark 官网下载最新版的预编译文件 spark-2.4.4-bin-hadoop2.7，解压到本地磁盘，比如 `D:/spark-2.4.4-bin-hadoop2.7`


```r
Sys.setenv(SPARK_HOME = "D:/spark-2.4.4-bin-hadoop2.7")
# Sys.setenv(R_HOME = "C:/Program Files/R/R-3.6.1/")
library(SparkR, lib.loc = c(file.path(Sys.getenv("SPARK_HOME"), "R", "lib")))
sparkR.session(master = "local[*]", 
               sparkConfig = list(spark.driver.memory = "4g"), 
               enableHiveSupport = TRUE)
```

从数据集 mtcars（数据类型是 R 的 data.frame） 创建 Spark 的 DataFrame 类型数据


```r
cars <- as.DataFrame(mtcars)
# 显示 SparkDataFrame 的前几行
head(cars)
```
```
 mpg cyl disp  hp drat    wt  qsec vs am gear carb
1 21.0   6  160 110 3.90 2.620 16.46  0  1    4    4
2 21.0   6  160 110 3.90 2.875 17.02  0  1    4    4
3 22.8   4  108  93 3.85 2.320 18.61  1  1    4    1
4 21.4   6  258 110 3.08 3.215 19.44  1  0    3    1
5 18.7   8  360 175 3.15 3.440 17.02  0  0    3    2
6 18.1   6  225 105 2.76 3.460 20.22  1  0    3    1
```

打印数据集 cars 的 schema 各个字段的


```r
printSchema(cars)
```
```
root
 |-- mpg: double (nullable = true)
 |-- cyl: double (nullable = true)
 |-- disp: double (nullable = true)
 |-- hp: double (nullable = true)
 |-- drat: double (nullable = true)
 |-- wt: double (nullable = true)
 |-- qsec: double (nullable = true)
 |-- vs: double (nullable = true)
 |-- am: double (nullable = true)
 |-- gear: double (nullable = true)
 |-- carb: double (nullable = true)
```

从本地 JSON 文件创建 DataFrame


```r
path <- file.path(Sys.getenv("SPARK_HOME"), "examples/src/main/resources/people.json")
peopleDF <- read.json(path)
printSchema(peopleDF)
```
```
root
 |-- age: long (nullable = true)
 |-- name: string (nullable = true)
```


```r
peopleDF
```
```
SparkDataFrame[age:bigint, name:string]
```


```r
showDF(peopleDF)
```
```
+----+-------+
| age|   name|
+----+-------+
|null|Michael|
|  30|   Andy|
|  19| Justin|
+----+-------+
```

peopleDF 转成 Hive 中的表 people


```r
createOrReplaceTempView(peopleDF, "people")
```

调用 `sql` 传递 SQL 语句查询数据，启动 `sparkR.session` 时，设置 `enableHiveSupport = TRUE`，就是执行不出来，报错，不知道哪里配置存在问题


```r
teenagers <- SparkR::sql("SELECT name FROM people WHERE age >= 13 AND age <= 19")
show(people)
```
```
Error in handleErrors(returnStatus, conn) : 
  org.apache.spark.sql.AnalysisException: java.lang.RuntimeException: java.io.IOException: (null) entry in command string: null chmod 0733 F:\tmp\hive;
	at org.apache.spark.sql.hive.HiveExternalCatalog.withClient(HiveExternalCatalog.scala:106)
	at org.apache.spark.sql.hive.HiveExternalCatalog.databaseExists(HiveExternalCatalog.scala:214)
	at org.apache.spark.sql.internal.SharedState.externalCatalog$lzycompute(SharedState.scala:114)
	at org.apache.spark.sql.internal.SharedState.externalCatalog(SharedState.scala:102)
	at org.apache.spark.sql.internal.SharedState.globalTempViewManager$lzycompute(SharedState.scala:141)
	at org.apache.spark.sql.internal.SharedState.globalTempViewManager(SharedState.scala:136)
	at org.apache.spark.sql.hive.HiveSessionStateBuilder$$anonfun$2.apply(HiveSessionStateBuilder.scala:55)
	at org.apache.spark.sql.hive.HiveSessionStateBuilder$$anonfun$2.apply(HiveSessionStateBuilder.scala:55)
	at org.apache.spark.sql.catalyst.catalog.SessionCatalog.gl
```

调用 `collect` 函数执行查询，并将结果返回到本地 `data.frame` 类型


```r
teenagersLocalDF <- collect(teenagers)
```

查看数据集 teenagersLocalDF 的属性


```r
print(teenagersLocalDF)
```

最后，关闭 SparkSession 会话


```r
sparkR.session.stop()
```



[^sql-chunck]: https://d.cosx.org/d/419974
[^txt-to-mysql]: https://brucezhaor.github.io/blog/2016/08/04/batch-process-txt-to-mysql
[^params-knit]: https://bookdown.org/yihui/rmarkdown/params-knit.html
[^dataio]: https://rstudio-education.github.io/hopr/dataio.html
[^sql-engine]: https://bookdown.org/yihui/rmarkdown/language-engines.html#sql
[rstudio-spark]: https://spark.rstudio.com/
[rmarkdown-teaching-demo]: https://stackoverflow.com/questions/35459166

## 批量导入数据 {#batch-import-data}


```r
library(tidyverse)
```


```r
read_list <- function(list_of_datasets, read_func) {
  read_and_assign <- function(dataset, read_func) {
    dataset_name <- as.name(dataset)
    dataset_name <- read_func(dataset)
  }

  # invisible is used to suppress the unneeded output
  output <- invisible(
    sapply(list_of_datasets,
      read_and_assign,
      read_func = read_func, simplify = FALSE, USE.NAMES = TRUE
    )
  )

  # Remove the extension at the end of the data set names
  names_of_datasets <- c(unlist(strsplit(list_of_datasets, "[.]"))[c(T, F)])
  names(output) <- names_of_datasets
  return(output)
}
```

批量导入文件扩展名为 `.csv` 的数据文件，即逗号分割的文件
 

```r
data_files <- list.files(path = "path/to/csv/dir",
                         pattern = ".csv", full.names = TRUE)
print(data_files)
```

相比于 Base R 提供的 `read.csv` 函数，使用 readr 包的 `read_csv` 函数可以更快地读取csv格式文件，特别是在读取GB级数据文件时，效果特别明显。


```r
list_of_data_sets <- read_list(data_files, readr::read_csv)
```

使用 tibble 包的`glimpse`函数可以十分方便地对整个数据集有一个大致的了解，展示方式和信息量相当于 `str` 加 `head` 函数 


```r
tibble::glimpse(list_of_data_sets)
```

## 批量导出数据 {#batch-export-data}

假定我们有一个列表，其每个元素都是一个数据框，现在要把每个数据框分别存入 xlsx 表的工作薄中，以 mtcars 数据集为例，将其按分类变量 cyl 分组拆分，获得一个列表 list 


```r
dat <- split(mtcars, mtcars$cyl)
dat
```

```
## $`4`
##                 mpg cyl  disp  hp drat    wt  qsec vs am gear carb
## Datsun 710     22.8   4 108.0  93 3.85 2.320 18.61  1  1    4    1
## Merc 240D      24.4   4 146.7  62 3.69 3.190 20.00  1  0    4    2
## Merc 230       22.8   4 140.8  95 3.92 3.150 22.90  1  0    4    2
## Fiat 128       32.4   4  78.7  66 4.08 2.200 19.47  1  1    4    1
## Honda Civic    30.4   4  75.7  52 4.93 1.615 18.52  1  1    4    2
## Toyota Corolla 33.9   4  71.1  65 4.22 1.835 19.90  1  1    4    1
## Toyota Corona  21.5   4 120.1  97 3.70 2.465 20.01  1  0    3    1
## Fiat X1-9      27.3   4  79.0  66 4.08 1.935 18.90  1  1    4    1
## Porsche 914-2  26.0   4 120.3  91 4.43 2.140 16.70  0  1    5    2
## Lotus Europa   30.4   4  95.1 113 3.77 1.513 16.90  1  1    5    2
## Volvo 142E     21.4   4 121.0 109 4.11 2.780 18.60  1  1    4    2
## 
## $`6`
##                 mpg cyl  disp  hp drat    wt  qsec vs am gear carb
## Mazda RX4      21.0   6 160.0 110 3.90 2.620 16.46  0  1    4    4
## Mazda RX4 Wag  21.0   6 160.0 110 3.90 2.875 17.02  0  1    4    4
## Hornet 4 Drive 21.4   6 258.0 110 3.08 3.215 19.44  1  0    3    1
## Valiant        18.1   6 225.0 105 2.76 3.460 20.22  1  0    3    1
## Merc 280       19.2   6 167.6 123 3.92 3.440 18.30  1  0    4    4
## Merc 280C      17.8   6 167.6 123 3.92 3.440 18.90  1  0    4    4
## Ferrari Dino   19.7   6 145.0 175 3.62 2.770 15.50  0  1    5    6
## 
## $`8`
##                      mpg cyl  disp  hp drat    wt  qsec vs am gear carb
## Hornet Sportabout   18.7   8 360.0 175 3.15 3.440 17.02  0  0    3    2
## Duster 360          14.3   8 360.0 245 3.21 3.570 15.84  0  0    3    4
## Merc 450SE          16.4   8 275.8 180 3.07 4.070 17.40  0  0    3    3
## Merc 450SL          17.3   8 275.8 180 3.07 3.730 17.60  0  0    3    3
## Merc 450SLC         15.2   8 275.8 180 3.07 3.780 18.00  0  0    3    3
## Cadillac Fleetwood  10.4   8 472.0 205 2.93 5.250 17.98  0  0    3    4
## Lincoln Continental 10.4   8 460.0 215 3.00 5.424 17.82  0  0    3    4
## Chrysler Imperial   14.7   8 440.0 230 3.23 5.345 17.42  0  0    3    4
## Dodge Challenger    15.5   8 318.0 150 2.76 3.520 16.87  0  0    3    2
## AMC Javelin         15.2   8 304.0 150 3.15 3.435 17.30  0  0    3    2
## Camaro Z28          13.3   8 350.0 245 3.73 3.840 15.41  0  0    3    4
## Pontiac Firebird    19.2   8 400.0 175 3.08 3.845 17.05  0  0    3    2
## Ford Pantera L      15.8   8 351.0 264 4.22 3.170 14.50  0  1    5    4
## Maserati Bora       15.0   8 301.0 335 3.54 3.570 14.60  0  1    5    8
```

将 xlsx 表格初始化，创建空白的工作薄， [openxlsx](https://github.com/awalker89/openxlsx) 包不依赖 Java 环境，读写效率也高


```r
## 加载 openxlsx 包
library(openxlsx)
## 创建空白的工作薄
wb <- createWorkbook()
```

将列表里的每张表分别存入 xlsx 表格的每个 worksheet，worksheet 的名字就是分组变量的名字


```r
Map(function(data, name){
    addWorksheet(wb, name)
    writeData(wb, name, data)
 
}, dat, names(dat))
```

最后保存数据到磁盘，见图 \@ref(fig:batch-export-xlsx)


```r
saveWorkbook(wb, file = "data/matcars.xlsx", overwrite = TRUE)
```
\begin{figure}

{\centering \includegraphics[width=4.1in]{screenshots/dm-batch-export-xlsx} 

}

\caption{批量导出数据}(\#fig:batch-export-xlsx)
\end{figure}

## 导出数据 {#export-data}

### 导出运行结果 {#export-output}


```r
capture.output(..., file = NULL, append = FALSE,
               type = c("output", "message"), split = FALSE)
```

`capture.output` 将一段R代码执行结果，保存到文件，参数为表达式。`capture.output` 和 `sink` 的关系相当于 `with` 和 `attach` 的关系。


```r
glmout <- capture.output(summary(glm(case ~ spontaneous + induced,
  data = infert, family = binomial()
)), file = "data/capture.txt")
capture.output(1 + 1, 2 + 2)
```

```
## [1] "[1] 2" "[1] 4"
```

```r
capture.output({
  1 + 1
  2 + 2
})
```

```
## [1] "[1] 4"
```

`sink` 函数将控制台输出结果保存到文件，只将 `outer` 函数运行的结果保存到 `ex-sink.txt` 文件，outer 函数计算的是直积，在这里相当于 `seq(10) %*% t(seq(10))`，而在 R 语言中，更加有效的计算方式是 `tcrossprod(seq(10),seq(10))`


```r
sink("data/ex-sink.txt")
i <- 1:10
outer(i, i, "*") 
```

```
##       [,1] [,2] [,3] [,4] [,5] [,6] [,7] [,8] [,9] [,10]
##  [1,]    1    2    3    4    5    6    7    8    9    10
##  [2,]    2    4    6    8   10   12   14   16   18    20
##  [3,]    3    6    9   12   15   18   21   24   27    30
##  [4,]    4    8   12   16   20   24   28   32   36    40
##  [5,]    5   10   15   20   25   30   35   40   45    50
##  [6,]    6   12   18   24   30   36   42   48   54    60
##  [7,]    7   14   21   28   35   42   49   56   63    70
##  [8,]    8   16   24   32   40   48   56   64   72    80
##  [9,]    9   18   27   36   45   54   63   72   81    90
## [10,]   10   20   30   40   50   60   70   80   90   100
```

```r
sink()
```

<!-- 记得删除文件 capture.txt 和 ex-sink.txt -->

### 导出数据对象 {#export-data-object}


```r
load(file, envir = parent.frame(), verbose = FALSE)

save(..., list = character(),
     file = stop("'file' must be specified"),
     ascii = FALSE, version = NULL, envir = parent.frame(),
     compress = isTRUE(!ascii), compression_level,
     eval.promises = TRUE, precheck = TRUE)

save.image(file = ".RData", version = NULL, ascii = FALSE,
           compress = !ascii, safe = TRUE)
```

`load` 和`save` 函数加载或保存包含工作环境信息的数据对象，`save.image` 保存当前工作环境到磁盘，即保存工作空间中所有数据对象，数据格式为 `.RData`，即相当于


```r
save(list = ls(all.names = TRUE), file = ".RData", envir = .GlobalEnv)
```

`dump` 保存数据对象 AirPassengers 到文件 `AirPassengers.txt`，文件内容是 R 命令，可把`AirPassengers.txt`看作代码文档执行，dput 保存数据对象内容到文件`AirPassengers.dat`，文件中不包含变量名 AirPassengers。注意到 `dump` 输入是一个字符串，而 `dput` 要求输入数据对象的名称，`source` 函数与 `dump` 对应，而 `dget` 与 `dput`对应。 


```r
# 加载数据
data(AirPassengers, package = "datasets")
# 将数据以R代码块的形式保存到文件
dump('AirPassengers', file = 'data/AirPassengers.txt') 
# source(file = 'data/AirPassengers.txt')
```

接下来，我们读取 `AirPassengers.txt` 的文件内容，可见它是一段完整的 R 代码，可以直接复制到 R 的控制台中运行，并且得到一个与原始 AirPassengers 变量一样的结果


```r
cat(readLines('data/AirPassengers.txt'), sep = "\n")
```

```
## AirPassengers <-
## structure(c(112, 118, 132, 129, 121, 135, 148, 148, 136, 119, 
## 104, 118, 115, 126, 141, 135, 125, 149, 170, 170, 158, 133, 114, 
## 140, 145, 150, 178, 163, 172, 178, 199, 199, 184, 162, 146, 166, 
## 171, 180, 193, 181, 183, 218, 230, 242, 209, 191, 172, 194, 196, 
## 196, 236, 235, 229, 243, 264, 272, 237, 211, 180, 201, 204, 188, 
## 235, 227, 234, 264, 302, 293, 259, 229, 203, 229, 242, 233, 267, 
## 269, 270, 315, 364, 347, 312, 274, 237, 278, 284, 277, 317, 313, 
## 318, 374, 413, 405, 355, 306, 271, 306, 315, 301, 356, 348, 355, 
## 422, 465, 467, 404, 347, 305, 336, 340, 318, 362, 348, 363, 435, 
## 491, 505, 404, 359, 310, 337, 360, 342, 406, 396, 420, 472, 548, 
## 559, 463, 407, 362, 405, 417, 391, 419, 461, 472, 535, 622, 606, 
## 508, 461, 390, 432), .Tsp = c(1949, 1960.9166666666699, 12), class = "ts")
```

`dput` 函数类似 `dump` 函数，保存数据对象到磁盘文件


```r
# 将 R 对象保存/导出到磁盘
dput(AirPassengers, file = 'data/AirPassengers.dat')
AirPassengers
```

```
     Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec
1949 112 118 132 129 121 135 148 148 136 119 104 118
1950 115 126 141 135 125 149 170 170 158 133 114 140
1951 145 150 178 163 172 178 199 199 184 162 146 166
1952 171 180 193 181 183 218 230 242 209 191 172 194
1953 196 196 236 235 229 243 264 272 237 211 180 201
1954 204 188 235 227 234 264 302 293 259 229 203 229
1955 242 233 267 269 270 315 364 347 312 274 237 278
1956 284 277 317 313 318 374 413 405 355 306 271 306
1957 315 301 356 348 355 422 465 467 404 347 305 336
1958 340 318 362 348 363 435 491 505 404 359 310 337
1959 360 342 406 396 420 472 548 559 463 407 362 405
1960 417 391 419 461 472 535 622 606 508 461 390 432
```

```r
# dget 作用与 dput 相反
AirPassengers2 <- dget(file = 'data/AirPassengers.dat')
AirPassengers2
```

```
     Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec
1949 112 118 132 129 121 135 148 148 136 119 104 118
1950 115 126 141 135 125 149 170 170 158 133 114 140
1951 145 150 178 163 172 178 199 199 184 162 146 166
1952 171 180 193 181 183 218 230 242 209 191 172 194
1953 196 196 236 235 229 243 264 272 237 211 180 201
1954 204 188 235 227 234 264 302 293 259 229 203 229
1955 242 233 267 269 270 315 364 347 312 274 237 278
1956 284 277 317 313 318 374 413 405 355 306 271 306
1957 315 301 356 348 355 422 465 467 404 347 305 336
1958 340 318 362 348 363 435 491 505 404 359 310 337
1959 360 342 406 396 420 472 548 559 463 407 362 405
1960 417 391 419 461 472 535 622 606 508 461 390 432
```

同样地，现在我们观察 `dput` 函数保存的文件 `AirPassengers.dat` 内容，和`dump` 函数保存的文件 `AirPassengers.txt`相比，就缺一个赋值变量


```r
cat(readLines('data/AirPassengers.dat'), sep = "\n")
```

```
structure(c(112, 118, 132, 129, 121, 135, 148, 148, 136, 119, 
104, 118, 115, 126, 141, 135, 125, 149, 170, 170, 158, 133, 114, 
140, 145, 150, 178, 163, 172, 178, 199, 199, 184, 162, 146, 166, 
171, 180, 193, 181, 183, 218, 230, 242, 209, 191, 172, 194, 196, 
196, 236, 235, 229, 243, 264, 272, 237, 211, 180, 201, 204, 188, 
235, 227, 234, 264, 302, 293, 259, 229, 203, 229, 242, 233, 267, 
269, 270, 315, 364, 347, 312, 274, 237, 278, 284, 277, 317, 313, 
318, 374, 413, 405, 355, 306, 271, 306, 315, 301, 356, 348, 355, 
422, 465, 467, 404, 347, 305, 336, 340, 318, 362, 348, 363, 435, 
491, 505, 404, 359, 310, 337, 360, 342, 406, 396, 420, 472, 548, 
559, 463, 407, 362, 405, 417, 391, 419, 461, 472, 535, 622, 606, 
508, 461, 390, 432), .Tsp = c(1949, 1960.91666666667, 12), class = "ts")
```

<!-- 记得删除文件 AirPassengers.txt 和 AirPassengers.dat -->



[openxlsx](https://github.com/ycphs/openxlsx) 可以读写 XLSX 文档

美团使用的大数据工具有很多，最常用的 Hive、Spark、Kylin、Impala、Presto 等，详见 <https://tech.meituan.com/2018/08/02/mt-r-practice.html>。下面主要介绍如何在 R 中连接 MySQL、Presto 和 Spark。

[sparklyr.flint](https://github.com/r-spark/sparklyr.flint) 支持 Spark 的时间序列库 [flint](https://github.com/twosigma/flint)，[sparkxgb](https://github.com/rstudio/sparkxgb) 为 Spark 上的 XGBoost 提供 R 接口，[sparkwarc](https://github.com/r-spark/sparkwarc) 支持加载 Web ARChive 文件到 Spark 里
[sparkavro](https://github.com/chezou/sparkavro) 支持从 Apache Avro (<https://avro.apache.org/>) 读取文件到 Spark 里，[sparkbq](https://github.com/miraisolutions/sparkbq) 是一个 sparkly 扩展包，集成 Google BigQuery 服务，[geospark](https://github.com/harryprince/geospark) 提供 GeoSpark 库的 R 接口，并且以 sf 的数据操作方式，[rsparkling](https://github.com/h2oai/sparkling-water/tree/master/r) H2O Sparkling Water 机器学习库的 R 接口。

Spark 性能优化，参考三篇博文

- [Spark在美团的实践](https://tech.meituan.com/2016/03/31/spark-in-meituan.html)
- [Spark性能优化指南——基础篇](https://tech.meituan.com/2016/04/29/spark-tuning-basic.html)
- [Spark性能优化指南——高级篇](https://tech.meituan.com/2016/05/12/spark-tuning-pro.html)

其他材料

- 朱俊晖收集的 Spark 资源列表 <https://github.com/harryprince/awesome-sparklyr>，推荐使用 sparklyr <https://github.com/sparklyr/sparklyr> 连接 Spark
- Spark 与 R 语言 <https://docs.microsoft.com/en-us/azure/databricks/spark/latest/sparkr/>
- Mastering Spark with R <https://therinspark.com/>

## Spark 与 R 语言 {#sec-spark-with-r}

### sparklyr {#subsec-sparklyr}

::: {.rmdwarn data-latex="{警告}"}
Spark 依赖特定版本的 Java、Hadoop，三者之间的版本应该要相融。
:::

在 MacOS 上配置 Java 环境，注意 Spark 仅支持 Java 8 至 11，所以安装指定版本的 Java 开发环境

```bash
# 安装 openjdk 11
brew install openjdk@11
# 全局设置 JDK 11
sudo ln -sfn /usr/local/opt/openjdk@11/libexec/openjdk.jdk /Library/Java/JavaVirtualMachines/openjdk-11.jdk
# Java 11 JDK 添加到 .zshrc 
export CPPFLAGS="-I/usr/local/opt/openjdk@11/include"
export PATH="/usr/local/opt/openjdk@11/bin:$PATH"
```

配置 R 环境，让 R 能够识别 Java 环境，再安装 **rJava** 包

```bash
# 配置
sudo R CMD javareconf
# 系统软件依赖
brew install pcre2
# 安装 rJava
Rscript -e 'install.packages("rJava", type="source")'
```

最后安装 **sparklyr** 包，以及 Spark 环境，可以借助 `spark_install()` 安装 Spark，比如下面 Spark 3.0 连同 hadoop 2.7 一起安装。


```r
install.packages('sparklyr')
sparklyr::spark_install(version = '3.0', hadoop_version = '2.7')
```

也可以先手动下载 Spark 软件环境，建议选择就近镜像站点下载，比如在北京选择清华站点
<https://mirrors.tuna.tsinghua.edu.cn/apache/spark/spark-3.0.1/spark-3.0.1-bin-hadoop2.7.tgz>，此环境自带 R 和 Python 接口。为了供 sparklyr 调用，先设置 `SPARK_HOME` 环境变量指向 Spark 安装位置，再连接单机版 Spark。


```r
# 排错 https://github.com/sparklyr/sparklyr/issues/2827
options(sparklyr.log.console = FALSE)
# 连接 Spark 
library(sparklyr)
library(ggplot2)
sc <- spark_connect(
  master = "local",
  # config = list(sparklyr.gateway.address = "127.0.0.1"),
  spark_home = Sys.getenv("SPARK_HOME")
)
# diamonds 数据集导入 Spark
diamonds_tbl <- copy_to(sc, ggplot2::diamonds, "diamonds")
```

做数据的聚合统计，有两种方式。一种是使用用 R 包 dplyr 提供的数据操作语法，下面以按 cut 分组统计钻石的数量为例，说明 dplyr 提供的数据操作方式。


```r
library(dplyr)
# 列出数据源下所有的表 tbls
src_tbls(sc)

diamonds_tbl <- diamonds_tbl %>%
  group_by(cut) %>%
  summarise(cnt = n()) %>%
  collect
```

另一种是使用结构化查询语言 SQL，这自不必说，大多数情况下，使用和一般的 SQL 没什么两样。


```r
library(DBI)
diamonds_preview <- dbGetQuery(sc, "SELECT count(*) as cnt, cut FROM diamonds GROUP BY cut")
diamonds_preview
```

```
##     cnt       cut
## 1 21551     Ideal
## 2 13791   Premium
## 3  4906      Good
## 4  1610      Fair
## 5 12082 Very Good
```

:::::: {.columns}
::: {.column width="47.5%" data-latex="{0.475\textwidth}"}


```r
# SQL 中的 AVG 和 R 中的 mean 函数是类似的
diamonds_price <- dbGetQuery(sc, "SELECT AVG(price) as mean_price, cut FROM diamonds GROUP BY cut")
diamonds_price
```

```
##   mean_price       cut
## 1   3457.542     Ideal
## 2   4584.258   Premium
## 3   3928.864      Good
## 4   4358.758      Fair
## 5   3981.760 Very Good
```

:::
::: {.column width="5%" data-latex="{0.05\textwidth}"}
\ 
<!-- an empty Div (with a white space), serving as
a column separator -->
:::
::: {.column width="47.5%" data-latex="{0.475\textwidth}"}


```r
library(ggplot2)
library(data.table)
diamonds <- as.data.table(diamonds)
diamonds[,.(mean_price = mean(price)), by = .(cut)]
```

```
##          cut mean_price
## 1:     Ideal   3457.542
## 2:   Premium   4584.258
## 3:      Good   3928.864
## 4: Very Good   3981.760
## 5:      Fair   4358.758
```

:::
::::::

将结果数据用 ggplot2 呈现出来


```r
ggplot(diamonds_preview, aes(cut, cnt)) +
  geom_col() +
  theme_minimal()
```



\begin{center}\includegraphics{data-transportation_files/figure-latex/unnamed-chunk-75-1} \end{center}

diamonds 数据集总共 53940 条数据，下面用 BUCKET 分桶抽样，将原数据随机分成 1000 个桶，取其中的一个桶，由于是随机分桶，所以每次的结果都不一样，解释详见<https://spark.apache.org/docs/latest/sql-ref-syntax-qry-select-sampling.html>


```r
diamonds_sample <- dbGetQuery(sc, "SELECT * FROM diamonds TABLESAMPLE (BUCKET 1 OUT OF 1000) LIMIT 6")
diamonds_sample
```

```
##   carat       cut color clarity depth table price    x    y    z
## 1  0.72     Ideal     E     SI1  60.8    55  2869 5.77 5.84 3.53
## 2  0.90      Good     J     SI1  64.0    61  2873 6.00 5.96 3.83
## 3  0.70     Ideal     F     VS1  61.5    55  3319 5.73 5.75 3.53
## 4  0.96 Very Good     D     SI2  60.2    63  3480 6.30 6.36 3.81
## 5  0.90 Very Good     H     SI1  63.3    58  3500 6.04 6.13 3.85
## 6  0.90 Very Good     G     SI2  59.9    60  3581 6.19 6.23 3.72
```

将抽样的结果用窗口函数 `RANK()` 排序，详见 <https://spark.apache.org/docs/latest/sql-ref-syntax-qry-select-window.html>

窗口函数 <https://www.cnblogs.com/ZackSun/p/9713435.html>


```r
diamonds_rank <- dbGetQuery(sc, "
  SELECT cut, price, RANK() OVER (PARTITION BY cut ORDER BY price) AS rank 
  FROM diamonds TABLESAMPLE (BUCKET 1 OUT OF 1000)
  LIMIT 6
")
diamonds_rank
```

```
##    cut price rank
## 1 Fair   371    1
## 2 Fair  3816    2
## 3 Fair  5185    3
## 4 Good  1338    1
## 5 Good  1920    2
## 6 Good  3246    3
```

LATERAL VIEW 把一列拆成多行

<https://liam.page/2020/03/09/LATERAL-VIEW-in-Hive-SQL/>
<https://spark.apache.org/docs/latest/sql-ref-syntax-qry-select-lateral-view.html>

创建数据集


```r
# 先删除存在的表 person
dbGetQuery(sc, "DROP TABLE IF EXISTS person")
# 创建表 person
dbGetQuery(sc, "CREATE TABLE IF NOT EXISTS person (id INT, name STRING, age INT, class INT, address STRING)")
# 插入数据到表 person
dbGetQuery(sc, "
INSERT INTO person VALUES
    (100, 'John', 30, 1, 'Street 1'),
    (200, 'Mary', NULL, 1, 'Street 2'),
    (300, 'Mike', 80, 3, 'Street 3'),
    (400, 'Dan', 50, 4, 'Street 4')
")
```

查看数据集


```r
dbGetQuery(sc, "SELECT * FROM person")
```

```
##    id name age class  address
## 1 100 John  30     1 Street 1
## 2 200 Mary  NA     1 Street 2
## 3 300 Mike  80     3 Street 3
## 4 400  Dan  50     4 Street 4
```

行列转换 <https://www.cnblogs.com/kimbo/p/6208973.html>，LATERAL VIEW 展开


```r
dbGetQuery(sc,"
SELECT * FROM person
    LATERAL VIEW EXPLODE(ARRAY(30, 60)) tabelName AS c_age
    LATERAL VIEW EXPLODE(ARRAY(40, 80)) AS d_age
LIMIT 6
")
```

```
##    id name age class  address c_age d_age
## 1 100 John  30     1 Street 1    30    40
## 2 100 John  30     1 Street 1    30    80
## 3 100 John  30     1 Street 1    60    40
## 4 100 John  30     1 Street 1    60    80
## 5 200 Mary  NA     1 Street 2    30    40
## 6 200 Mary  NA     1 Street 2    30    80
```

日期相关的函数 <https://spark.apache.org/docs/latest/sql-ref-functions-builtin.html#date-and-timestamp-functions>


```r
# 今天
dbGetQuery(sc, "select current_date")
```

```
##   current_date()
## 1     2021-08-08
```

```r
# 昨天
dbGetQuery(sc, "select date_sub(current_date, 1)")
```

```
##   date_sub(current_date(), 1)
## 1                  2021-08-07
```

```r
# 本月最后一天 current_date 所属月份的最后一天
dbGetQuery(sc, "select last_day(current_date)")
```

```
##   last_day(current_date())
## 1               2021-08-31
```

```r
# 星期几
dbGetQuery(sc, "select dayofweek(current_date)")
```

```
##   dayofweek(current_date())
## 1                         1
```

最后，使用完记得关闭 Spark 连接


```r
spark_disconnect(sc)
```

### SparkR {#subsec-sparkr}

::: {.rmdnote data-latex="{注意}"}
考虑到和第\@ref(subsec-sparklyr)节的重合性，以及 sparklyr 的优势，本节代码都不会执行，仅作为补充信息予以描述。完整的介绍见 [SparkR 包](https://spark.apache.org/docs/latest/sparkr.html#running-sql-queries-from-sparkr)
:::

```r
if (nchar(Sys.getenv("SPARK_HOME")) < 1) {
  Sys.setenv(SPARK_HOME = "/opt/spark/spark-3.0.1-bin-hadoop2.7")
}
library(SparkR, lib.loc = c(file.path(Sys.getenv("SPARK_HOME"), "R", "lib")))
sparkR.session(master = "local[*]", sparkConfig = list(spark.driver.memory = "2g"))
```

::: {.rmdwarn data-latex="{警告}"}
**SparkR** 要求 Java 版本满足：大于等于8，而小于12，本地 MacOS 安装高版本，比如 oracle-jdk 16.0.1 会报不兼容的错误。

```
Spark package found in SPARK_HOME: /opt/spark/spark-3.1.1-bin-hadoop3.2
Error in checkJavaVersion() : 
  Java version, greater than or equal to 8 and less than 12, is required for this package; found version: 16.0.1
```
:::


`sparkConfig` 有哪些参数可以传递

| Property Name                   | Property group         | `spark-submit` equivalent |
| :------------------------------ | :--------------------- | :------------------------ |
| `spark.master`                  | Application Properties | `--master`                |
| `spark.kerberos.keytab`         | Application Properties | `--keytab`                |
| `spark.kerberos.principal`      | Application Properties | `--principal`             |
| `spark.driver.memory`           | Application Properties | `--driver-memory`         |
| `spark.driver.extraClassPath`   | Runtime Environment    | `--driver-class-path`     |
| `spark.driver.extraJavaOptions` | Runtime Environment    | `--driver-java-options`   |
| `spark.driver.extraLibraryPath` | Runtime Environment    | `--driver-library-path`   |

将 data.frame 转化为 SparkDataFrame

```r
faithful_sdf <- as.DataFrame(faithful)
```

SparkDataFrame

```r
head(faithful_sdf)
```

查看结构

```r
str(faithful_sdf)
```

## 数据库与 R 语言 {#sec-database-with-r}

[Presto](https://github.com/prestodb/presto) 的 R 接口 <https://github.com/prestodb/RPresto> 和文档 <https://prestodb.io/docs/current/index.html>，Presto 数据库


```r
install.packages('RPresto')
```

MySQL 为例介绍 odbc 的连接和使用，详见 [从 R 连接 MySQL](https://cosx.org/2020/06/connect-mysql-from-r/)


```sql
-- !preview conn=DBI::dbConnect(odbc::odbc(),  driver = "MariaDB", database = "demo", 
--                              uid = "root", pwd = "cloud", host = "localhost", port = 3306)

SELECT * FROM mtcars
LIMIT 10
```

我的系统已经安装了多款数据库的 ODBC 驱动

```bash
dnf install -y unixODBC unixODBC-devel mariadb mariadb-server mariadb-devel mariadb-connector-odbc
```

```r
odbc::odbcListDrivers()
```

```
# Driver from the mariadb-connector-odbc package
# Setup from the unixODBC package
[MariaDB]
Description     = ODBC for MariaDB
Driver          = /usr/lib/libmaodbc.so
Driver64        = /usr/lib64/libmaodbc.so
FileUsage       = 1
```

## 批量读取 csv 文件 {#sec-batch-import-csv}

iris 数据转化为 data.table 类型，按照 Species 分组拆成单独的 csv 文件，各个文件的文件名用鸢尾花的类别名表示


```r
# 批量分组导出
library(data.table)
as.data.table(iris)[, fwrite(.SD, paste0("data/user_", unique(Species), ".csv")), by = Species, .SDcols = colnames(iris)]
```

读取文件夹 `data/` 所有 csv 数据文件


```r
library(data.table)
merged_df <- do.call('rbind', lapply(list.files(pattern = "*.csv", path = "data/"), fread ) )
# 或者
merged_df <- rbindlist(lapply(list.files(pattern = "*.csv", path = "data/"), fread ))
```


```r
xdf$date <- as.Date(xdf$date)
xdf$ts <- as.POSIXct(as.numeric(xdf$ts), origin = "1978-01-01")
split(xdf[order(xdf$ts), ], interaction(xdf$study, xdf$port)) %>%
  lapply(function(.x) {
    .x[nrow(.x), ]
  }) %>%
  unname() %>%
  Filter(function(.x) {
    nrow(.x) > 0
  }, .) %>%
  do.call(rbind.data.frame, .)

library(dplyr)
xdf %>%
  mutate(
    date = as.Date(date),
    ts = anytime::anytime(as.numeric(ts))
  ) %>%
  arrange(ts) %>%
  group_by(study, port) %>%
  slice(n()) %>%
  ungroup()
```


```r
library(tibble)
library(magrittr)

mtcars <- tibble(mtcars)

mtcars %>% 
  print(n = 16, width = 69)
```

```
## # A tibble: 32 x 11
##      mpg   cyl  disp    hp  drat    wt  qsec    vs    am  gear  carb
##    <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl>
##  1  21       6  160    110  3.9   2.62  16.5     0     1     4     4
##  2  21       6  160    110  3.9   2.88  17.0     0     1     4     4
##  3  22.8     4  108     93  3.85  2.32  18.6     1     1     4     1
##  4  21.4     6  258    110  3.08  3.22  19.4     1     0     3     1
##  5  18.7     8  360    175  3.15  3.44  17.0     0     0     3     2
##  6  18.1     6  225    105  2.76  3.46  20.2     1     0     3     1
##  7  14.3     8  360    245  3.21  3.57  15.8     0     0     3     4
##  8  24.4     4  147.    62  3.69  3.19  20       1     0     4     2
##  9  22.8     4  141.    95  3.92  3.15  22.9     1     0     4     2
## 10  19.2     6  168.   123  3.92  3.44  18.3     1     0     4     4
## 11  17.8     6  168.   123  3.92  3.44  18.9     1     0     4     4
## 12  16.4     8  276.   180  3.07  4.07  17.4     0     0     3     3
## 13  17.3     8  276.   180  3.07  3.73  17.6     0     0     3     3
## 14  15.2     8  276.   180  3.07  3.78  18       0     0     3     3
## 15  10.4     8  472    205  2.93  5.25  18.0     0     0     3     4
## 16  10.4     8  460    215  3     5.42  17.8     0     0     3     4
## # ... with 16 more rows
```


```r
mtcars %>% 
  print(., n = nrow(.)/4)
```

```
## # A tibble: 32 x 11
##     mpg   cyl  disp    hp  drat    wt  qsec    vs    am  gear  carb
##   <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl>
## 1  21       6  160    110  3.9   2.62  16.5     0     1     4     4
## 2  21       6  160    110  3.9   2.88  17.0     0     1     4     4
## 3  22.8     4  108     93  3.85  2.32  18.6     1     1     4     1
## 4  21.4     6  258    110  3.08  3.22  19.4     1     0     3     1
## 5  18.7     8  360    175  3.15  3.44  17.0     0     0     3     2
## 6  18.1     6  225    105  2.76  3.46  20.2     1     0     3     1
## 7  14.3     8  360    245  3.21  3.57  15.8     0     0     3     4
## 8  24.4     4  147.    62  3.69  3.19  20       1     0     4     2
## # ... with 24 more rows
```

## 批量导出 xlsx 文件 {#sec-batch-export-xlsx}

将 R 环境中的数据集导出为 xlsx 表格


```r
## 加载 openxlsx 包
library(openxlsx)
## 创建空白的工作薄，标题为鸢尾花数据集
wb <- createWorkbook(title = "鸢尾花数据集")
## 添加 sheet 页
addWorksheet(wb, sheetName = "iris")
# 将数据写进 sheet 页
writeData(wb, sheet = "iris", x = iris, colNames = TRUE)
# 导出数据到本地
saveWorkbook(wb, file = "iris.xlsx", overwrite = TRUE)
```


```r
library(openxlsx)
xlsxFile <- system.file("extdata", "readTest.xlsx", package = "openxlsx")
# 导入
dat = read.xlsx(xlsxFile = xlsxFile)
# 导出
write.xlsx(dat, xlsxfile)
```

## 运行环境 {#dm-session-info}


```r
xfun::session_info()
```

```
## R version 4.1.0 (2021-05-18)
## Platform: x86_64-pc-linux-gnu (64-bit)
## Running under: Ubuntu 20.04.2 LTS
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
##   askpass_1.1        assertthat_0.2.1   base64enc_0.1-3    blob_1.2.2        
##   bookdown_0.22      cli_3.0.1          codetools_0.2.18   colorspace_2.0-2  
##   compiler_4.1.0     config_0.3.1       cpp11_0.3.1        crayon_1.4.1      
##   curl_4.3.2         data.table_1.14.0  DBI_1.1.1          dbplyr_2.1.1      
##   digest_0.6.27      dplyr_1.0.7        ellipsis_0.3.2     evaluate_0.14     
##   fansi_0.5.0        farver_2.1.0       forge_0.2.0        generics_0.1.0    
##   ggplot2_3.3.5      globals_0.14.0     glue_1.4.2         graphics_4.1.0    
##   grDevices_4.1.0    grid_4.1.0         gtable_0.3.0       highr_0.9         
##   htmltools_0.5.1.1  htmlwidgets_1.5.3  httr_1.4.2         isoband_0.2.5     
##   jsonlite_1.7.2     knitr_1.33         labeling_0.4.2     lattice_0.20.44   
##   lifecycle_1.0.0    magrittr_2.0.1     markdown_1.1       MASS_7.3.54       
##   Matrix_1.3.4       methods_4.1.0      mgcv_1.8.36        mime_0.11         
##   munsell_0.5.0      nlme_3.1.152       openssl_1.4.4      parallel_4.1.0    
##   pillar_1.6.2       pkgconfig_2.0.3    png_0.1-7          purrr_0.3.4       
##   r2d3_0.2.5         R6_2.5.0           rappdirs_0.3.3     RColorBrewer_1.1.2
##   rlang_0.4.11       rmarkdown_2.10     rprojroot_2.0.2    rstudioapi_0.13   
##   scales_1.1.1       sparklyr_1.7.1     splines_4.1.0      stats_4.1.0       
##   stringi_1.7.3      stringr_1.4.0      sys_3.4            tibble_3.1.3      
##   tidyr_1.1.3        tidyselect_1.1.1   tinytex_0.33       tools_4.1.0       
##   utf8_1.2.2         utils_4.1.0        uuid_0.1.4         vctrs_0.3.8       
##   viridisLite_0.4.0  withr_2.4.2        xfun_0.25          xml2_1.3.2        
##   yaml_2.2.1
```

