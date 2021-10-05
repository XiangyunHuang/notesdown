# 字符串操作 {#chap-string-operations}

[Handling Strings with R](https://www.gastonsanchez.com/r4strings/) 和 [R for Data Science](https://r4ds.had.co.nz/strings.html) 提供字符串入门介绍 ，Sara Stoudt 整理了 stringr 包与 Base R 正则表达式函数的对应表 <https://stringr.tidyverse.org/articles/from-base.html>

[stringr](https://stringr.tidyverse.org/) 基于 [stringi](https://github.com/gagolews/stringi) 包字符串处理包， [re2r](https://github.com/qinwf/re2r/) 包基于 Google 开发的 C++ 库 [re2](https://github.com/google/re2)，Google 编程之夏项目提供了一份 [正则表达式性能综述](https://github.com/rstats-gsoc/gsoc2016/wiki/re2-regular-expressions)， [stringdist](https://github.com/markvanderloo/stringdist) Approximate String Matching and String Distance Functions 近似字符串匹配和字符串距离计算函数 [@stringdist2014]

- [janitor](https://github.com/sfirke/janitor)
- [Manipulating strings with the stringr package](https://www.brodrigues.co/blog/2019-02-10-stringr_package/)
- [filesstrings](https://github.com/rorynolan/filesstrings) 基于 stringr 操作字符串
- [strex](https://github.com/rorynolan/strex) 一些没有包含在 stringr 或者 stringi 中的字符串操作函数
- [tidytext](https://github.com/juliasilge/tidytext) Text mining using dplyr, ggplot2, and other tidy tools

[stringdist](https://github.com/markvanderloo/stringdist)
[stringfish](https://github.com/traversc/stringfish)
[stringb](https://github.com/hadley/stringb)
[stringi](https://github.com/gagolews/stringi)
[stringr](https://github.com/tidyverse/stringr)

字符和字符串类型的数据值得单独拿出来讲，不仅因为内容多，而且比较难，应用范围最广，特别是面对文本类型的数据时，几乎是避不开的！R 的前身是 S，S 的前身是一些 Fortran 和 C 子程序，最早在贝尔实验室是用于文本分析领域，因此在 R 基础包中提供了丰富的字符串处理函数，你可以在R控制台中执行如下一行命令查看


```r
help.search(keyword = "character", package = "base")
```

本章主要介绍 R 内置的字符串操作函数

## 字符数统计 {#base-count}

`nchar` 函数统计字符串向量中每个元素的字符个数，注意与函数`length` 的差别，它统计向量中元素的个数，即向量的长度。


```r
nchar(c("Hello", "world", "!"))
```

```
## [1] 5 5 1
```

```r
R.version.string
```

```
## [1] "R version 4.1.1 (2021-08-10)"
```

```r
nchar(R.version.string)
```

```
## [1] 28
```

```r
deparse(base::mean)
```

```
## [1] "function (x, ...) "  "UseMethod(\"mean\")"
```

```r
nchar(deparse(base::mean))
```

```
## [1] 18 17
```

一些特殊的情况


```r
nchar("")
```

```
## [1] 0
```

```r
nchar(NULL)
```

```
## integer(0)
```

```r
nchar(0)
```

```
## [1] 1
```

```r
pi
```

```
## [1] 3.141593
```

```r
nchar(pi)
```

```
## [1] 16
```

```r
exp(1)
```

```
## [1] 2.718282
```

```r
nchar(exp(1))
```

```
## [1] 16
```

```r
nchar(NA)
```

```
## [1] NA
```

## 字符串翻译 {#base-translations}

`tolower` 将字符串或字符串向量中含有的大写字母全都转化为小写， `toupper` 函数正好与之相反.


```r
tolower(c("HELLO", "Hello, R", "hello"))
```

```
## [1] "hello"    "hello, r" "hello"
```

```r
toupper(c("HELLO", "Hello, R", "hello"))
```

```
## [1] "HELLO"    "HELLO, R" "HELLO"
```

## 字符串连接 {#base-concatenate}

`paste` 函数设置参数 sep 作为连接符，设置参数 collapse 可以将字符串拼接后连成一个字符串


```r
paste("A", "B", sep = "")
```

```
## [1] "AB"
```

```r
paste(c("A", "B", "C"), 1:3, sep = "-")
```

```
## [1] "A-1" "B-2" "C-3"
```

```r
paste(c("A", "B", "C"), 1:3, sep = "-", collapse = ";")
```

```
## [1] "A-1;B-2;C-3"
```

`paste0` 相当于 sep 设为空，没有连接符 


```r
paste0("A", "B")
```

```
## [1] "AB"
```

```r
paste0(c("A", "B", "C"), 1:3)
```

```
## [1] "A1" "B2" "C3"
```

```r
paste0(c("A", "B", "C"), 1:3, collapse = ";")
```

```
## [1] "A1;B2;C3"
```

## 字符串拆分 {#base-strsplit}


```r
strsplit(x, split, fixed = FALSE, perl = FALSE, useBytes = FALSE)
```

`strsplit` 函数用于字符串拆分，参数 x 是被拆分的字符串向量，其每个元素都会被拆分，而参数 split 表示拆分的位置，可以用正则表达式来描述位置，拆分的结果是一个列表。

参数 fixed 默认设置 `fixed = FALSE` 表示正则表达式匹配，而 `fixed = TRUE` 表示正则表达式的精确匹配或者按文本字符的字面意思匹配，即按普通文本匹配。我们知道按普通文本匹配速度快。

当启用 `perl = TRUE` 时，由 `PCRE_use_JIT` 控制细节。`perl` 参数的设置与 Perl 软件版本有关，如果正则表达式很长，除了正确设置正则表达式，使用 `perl = TRUE` 可以提高运算速度

参数 useBytes 设置是否按照逐个字节地进行匹配，默认设置为 FALSE，即按照字符而不是字节进行匹配


```r
x <- c(as = "asfef", qu = "qwerty", "yuiop[", "b", "stuff.blah.yech")
# 按字母 e 拆分字符串向量 x
strsplit(x, "e")
```

```
## $as
## [1] "asf" "f"  
## 
## $qu
## [1] "qw"  "rty"
## 
## [[3]]
## [1] "yuiop["
## 
## [[4]]
## [1] "b"
## 
## [[5]]
## [1] "stuff.blah.y" "ch"
```

参数 split 支持通过正则表达式的方式指明拆分位置


```r
# 默认将点号 . 看作一个正则表达式，它是一个元字符，匹配任意字符
strsplit("a.b.c", ".")
```

```
## [[1]]
## [1] "" "" "" "" ""
```

```r
# 这才是按点号拆分
strsplit("a.b.c", ".", fixed = TRUE)
```

```
## [[1]]
## [1] "a" "b" "c"
```

```r
# 或者
strsplit("a.b.c", "[.]")
```

```
## [[1]]
## [1] "a" "b" "c"
```

```r
# 或者转义点号，去掉元字符的特殊意义
strsplit("a.b.c", "\\.")
```

```
## [[1]]
## [1] "a" "b" "c"
```

这里介绍一个将字符串逆序的函数 `str_rev`


```r
str_rev <- function(x)
        sapply(lapply(strsplit(x, NULL), rev), paste, collapse = "")
str_rev(c("abc", "Statistics"))
```

```
## [1] "cba"        "scitsitatS"
```

为了加深理解，再举几个例子


```r
# 最后一个空字符没有产生
strsplit(paste(c("", "a", ""), collapse="#"), split="#")
```

```
## [[1]]
## [1] ""  "a"
```

```r
# 空字符只有有定义的时候才会产生
strsplit("", " ")
```

```
## [[1]]
## character(0)
```

```r
strsplit(" ", " ")
```

```
## [[1]]
## [1] ""
```

## 字符串匹配 {#base-match}

`agrep` 和 `agrepl` 函数做近似（模糊）匹配 (Approximate Matching or Fuzzy Matching) ，对于匹配，考虑到参数 pattern 在参数 x 中匹配时，允许参数值x存在最小可能的插入、删除和替换，这种修改叫做Levenshtein 编辑距离，`max.distance` 控制其细节


```r
agrep(pattern, x, max.distance = 0.1, costs = NULL,
      ignore.case = FALSE, value = FALSE, fixed = TRUE,
      useBytes = FALSE)

agrepl(pattern, x, max.distance = 0.1, costs = NULL,
       ignore.case = FALSE, fixed = TRUE, useBytes = FALSE)
```

`agrep ` 函数返回 pattern 在 x 中匹配到的一个位置向量，`agrepl` 返回一个逻辑向量，这一点类似 `grep` 和 `grepl` 这对函数，下面举例子说明


```r
agrep("lasy", "1 lazy 2")
```

```
## [1] 1
```

```r
# sub = 0 表示匹配时不考虑替换
agrep("lasy", c(" 1 lazy 2", "1 lasy 2"), max = list(sub = 0))
```

```
## [1] 2
```

```r
# 默认设置下，匹配时区分大小写
agrep("laysy", c("1 lazy", "1", "1 LAZY"), max = 2)
```

```
## [1] 1
```

```r
# 返回匹配到值，而不是位置下标，类似 grep(..., value = TRUE) 的返回值
agrep("laysy", c("1 lazy", "1", "1 LAZY"), max = 2, value = TRUE)
```

```
## [1] "1 lazy"
```

```r
# 不区分大小写
agrep("laysy", c("1 lazy", "1", "1 LAZY"), max = 2, ignore.case = TRUE)
```

```
## [1] 1 3
```


```r
startsWith(x, prefix)
  endsWith(x, suffix)
```

`startsWith` 和 `endsWith` 函数用来匹配字符串的前缀和后缀，返回值是一个逻辑向量，参数 prefix 和 suffix 不要包含特殊的正则表达式字符，如点号`.`，举例子


```r
# 字符串向量
search()
```

```
## [1] ".GlobalEnv"        "package:stats"     "package:graphics" 
## [4] "package:grDevices" "package:utils"     "package:datasets" 
## [7] "package:methods"   "Autoloads"         "package:base"
```

```r
# 匹配以 package: 开头的字符串
startsWith(search(), "package:")
```

```
## [1] FALSE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE FALSE  TRUE
```

```r
# 或者
grepl("^package:", search())
```

```
## [1] FALSE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE FALSE  TRUE
```

当前目录下，列出扩展名为 `.Rmd` 的文件


```r
# list.files(path = ".", pattern = "\\.Rmd$")
# 而不是 endsWith(list.files(), "\\.Rmd")
endsWith(list.files(), ".Rmd")
```

```
##   [1] FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE  TRUE  TRUE  TRUE
##  [13]  TRUE  TRUE FALSE  TRUE  TRUE FALSE FALSE FALSE  TRUE FALSE FALSE FALSE
##  [25] FALSE  TRUE FALSE  TRUE  TRUE  TRUE FALSE  TRUE FALSE FALSE  TRUE FALSE
##  [37] FALSE FALSE  TRUE FALSE  TRUE  TRUE  TRUE FALSE FALSE FALSE FALSE FALSE
##  [49] FALSE FALSE  TRUE  TRUE FALSE  TRUE FALSE  TRUE  TRUE FALSE  TRUE  TRUE
##  [61]  TRUE FALSE  TRUE  TRUE FALSE FALSE FALSE  TRUE FALSE  TRUE FALSE  TRUE
##  [73] FALSE FALSE FALSE FALSE FALSE  TRUE  TRUE  TRUE FALSE  TRUE FALSE  TRUE
##  [85]  TRUE FALSE  TRUE  TRUE FALSE FALSE  TRUE  TRUE FALSE  TRUE FALSE FALSE
##  [97]  TRUE FALSE  TRUE FALSE FALSE FALSE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE
## [109]  TRUE  TRUE  TRUE  TRUE FALSE  TRUE  TRUE  TRUE  TRUE FALSE FALSE  TRUE
## [121]  TRUE FALSE  TRUE FALSE  TRUE  TRUE FALSE  TRUE FALSE FALSE FALSE FALSE
## [133]  TRUE FALSE  TRUE  TRUE FALSE  TRUE  TRUE  TRUE FALSE FALSE  TRUE FALSE
## [145] FALSE  TRUE FALSE FALSE FALSE FALSE FALSE FALSE  TRUE  TRUE FALSE  TRUE
## [157]  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE FALSE  TRUE FALSE  TRUE FALSE
## [169]  TRUE  TRUE FALSE  TRUE FALSE FALSE  TRUE  TRUE
```

```r
# 或者
grepl("\\.Rmd$", list.files())
```

```
##   [1] FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE  TRUE  TRUE  TRUE
##  [13]  TRUE  TRUE FALSE  TRUE  TRUE FALSE FALSE FALSE  TRUE FALSE FALSE FALSE
##  [25] FALSE  TRUE FALSE  TRUE  TRUE  TRUE FALSE  TRUE FALSE FALSE  TRUE FALSE
##  [37] FALSE FALSE  TRUE FALSE  TRUE  TRUE  TRUE FALSE FALSE FALSE FALSE FALSE
##  [49] FALSE FALSE  TRUE  TRUE FALSE  TRUE FALSE  TRUE  TRUE FALSE  TRUE  TRUE
##  [61]  TRUE FALSE  TRUE  TRUE FALSE FALSE FALSE  TRUE FALSE  TRUE FALSE  TRUE
##  [73] FALSE FALSE FALSE FALSE FALSE  TRUE  TRUE  TRUE FALSE  TRUE FALSE  TRUE
##  [85]  TRUE FALSE  TRUE  TRUE FALSE FALSE  TRUE  TRUE FALSE  TRUE FALSE FALSE
##  [97]  TRUE FALSE  TRUE FALSE FALSE FALSE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE
## [109]  TRUE  TRUE  TRUE  TRUE FALSE  TRUE  TRUE  TRUE  TRUE FALSE FALSE  TRUE
## [121]  TRUE FALSE  TRUE FALSE  TRUE  TRUE FALSE  TRUE FALSE FALSE FALSE FALSE
## [133]  TRUE FALSE  TRUE  TRUE FALSE  TRUE  TRUE  TRUE FALSE FALSE  TRUE FALSE
## [145] FALSE  TRUE FALSE FALSE FALSE FALSE FALSE FALSE  TRUE  TRUE FALSE  TRUE
## [157]  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE FALSE  TRUE FALSE  TRUE FALSE
## [169]  TRUE  TRUE FALSE  TRUE FALSE FALSE  TRUE  TRUE
```

部分匹配(Partial String Matching)


```r
match(x, table, nomatch = NA_integer_, incomparables = NULL)
x %in% table
charmatch(x, table, nomatch = NA_integer_)
pmatch(x, table, nomatch = NA_integer_, duplicates.ok = FALSE)
```

这几个 `match` 函数的返回值都是一个向量，每个元素是参数x在参数table中第一次匹配到的位置，`charmatch` 与 `pmatch(x, table, nomatch = NA_integer_, duplicates.ok = TRUE)` 类似，所以 `pmatch` 在默认 `duplicates.ok = FALSE` 的情况下，若x在第二个参数table中有多次匹配就会返回 NA，因此，实际上 `pmatch` 只允许在第二个参数中匹配一次


```r
match("xx", c("abc", "xx", "xxx", "xx"))
```

```
## [1] 2
```

```r
1:10 %in% c(1,3,5,9)
```

```
##  [1]  TRUE FALSE  TRUE FALSE  TRUE FALSE FALSE FALSE  TRUE FALSE
```

```r
# charmatch 就比较奇怪，规则太多
charmatch("", "")                             # returns 1
```

```
## [1] 1
```

```r
# 多个精确匹配到，或者多个部分匹配到，则返回 0
charmatch("m",   c("mean", "median", "mode", "quantile")) # returns 0
```

```
## [1] 0
```

```r
# med 只在table参数值的第二个位置部分匹配到，所以返回2
charmatch("med", c("mean", "median", "mode", "quantile")) # returns 2
```

```
## [1] 2
```

```r
charmatch("xx", "xx")
```

```
## [1] 1
```

```r
charmatch("xx", "xxa")
```

```
## [1] 1
```

```r
charmatch("xx", "axx")
```

```
## [1] NA
```

```r
# 注意比较与 charmatch 的不同
pmatch("", "")                             # returns NA
```

```
## [1] NA
```

```r
pmatch("m",   c("mean", "median", "mode")) # returns NA
```

```
## [1] NA
```

```r
pmatch("med", c("mean", "median", "mode")) # returns 2
```

```
## [1] 2
```

## 字符串查询 {#base-search}


```r
grep(pattern, x,
  ignore.case = FALSE, perl = FALSE, value = FALSE,
  fixed = FALSE, useBytes = FALSE, invert = FALSE
)
grepl(pattern, x,
  ignore.case = FALSE, perl = FALSE,
  fixed = FALSE, useBytes = FALSE
)
```

`grep` 和 `grepl` 是一对字符串查询函数，查看字符串向量 x 中是否包含正则表达式 pattern 描述的内容

- `ignore.case`: `TRUE` 表示忽略大小写，`FALSE` 表示匹配的时候区分大小写
- `fixed = TRUE` 表示启用 literal regular expression 字面正则表达式，默认情况下`fixed = FALSE`
- `grep` 函数返回匹配到的字符串向量x的元素的下标，如果 `value=TRUE` 则返回下标对应的值
- `grepl` 函数返回一个逻辑向量，检查字符串向量x中的每个元素是否匹配到，匹配到返回 `TRUE`，没有匹配到返回 `FALSE`


```r
# 返回下标位置
grep("[a-z]", letters)
```

```
##  [1]  1  2  3  4  5  6  7  8  9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25
## [26] 26
```

```r
# 返回查询到的值
grep("[a-z]", letters, value = TRUE)
```

```
##  [1] "a" "b" "c" "d" "e" "f" "g" "h" "i" "j" "k" "l" "m" "n" "o" "p" "q" "r" "s"
## [20] "t" "u" "v" "w" "x" "y" "z"
```

继续举例子


```r
grep(x = c("apple", "banana"), pattern = "a")
```

```
## [1] 1 2
```

```r
grep(x = c("apple", "banana"), pattern = "b")
```

```
## [1] 2
```

```r
grep(x = c("apple", "banana"), pattern = "a", value = TRUE)
```

```
## [1] "apple"  "banana"
```

```r
grep(x = c("apple", "banana"), pattern = "b", value = TRUE)
```

```
## [1] "banana"
```

关于 `grepl` 函数的使用例子


```r
grepl(x = c("apple", "banana"), pattern = "a")
```

```
## [1] TRUE TRUE
```

```r
grepl(x = c("apple", "banana"), pattern = "b")
```

```
## [1] FALSE  TRUE
```

::: sidebar
R 语言是用字符串来表示正则表达式的，但是正则表达式不是字符串，字符串的构造类似算术表达式
::: 

在 R 里面分别表示 `a\\b` 和 `a\b`


```r
writeLines(c("a\\\\b", "a\\b"))
```

```
## a\\b
## a\b
```

下面在 R 里面分别匹配字符串 `a\\b` 和 `a\b` 中的 `\\` 和 `\`


```r
# 匹配字符串中的一个反斜杠
grep(x = c("a\\\\b", "a\\b"), pattern = "\\", value = TRUE, fixed = TRUE)
```

```
## [1] "a\\\\b" "a\\b"
```

```r
grep(x = c("a\\\\b", "a\\b"), pattern = "\\\\", value = TRUE, fixed = FALSE)
```

```
## [1] "a\\\\b" "a\\b"
```

```r
# 匹配字符串中的两个反斜杠
grep(x = c("a\\\\b", "a\\b"), pattern = "\\\\", value = TRUE, fixed = TRUE)
```

```
## [1] "a\\\\b"
```

```r
grep(x = c("a\\\\b", "a\\b"), pattern = "\\\\\\\\", value = TRUE, fixed = FALSE)
```

```
## [1] "a\\\\b"
```

```r
# 匹配字符串中的两个反斜杠 \\
grepl(x = "a\\\\b", pattern = "\\\\\\\\", fixed = FALSE)
```

```
## [1] TRUE
```

```r
grepl(x = "a\\\\b", pattern = "\\\\\\\\", fixed = TRUE)
```

```
## [1] FALSE
```

```r
grepl(x = "a\\\\b", pattern = "\\\\", fixed = TRUE)
```

```
## [1] TRUE
```

<!-- 此外，还有一个函数 `grepRaw` 用于匹配 Raw Vectors  -->


```r
regexpr(pattern, text,
  ignore.case = FALSE, perl = FALSE,
  fixed = FALSE, useBytes = FALSE
)
gregexpr(pattern, text,
  ignore.case = FALSE, perl = FALSE,
  fixed = FALSE, useBytes = FALSE
)
regexec(pattern, text,
  ignore.case = FALSE, perl = FALSE,
  fixed = FALSE, useBytes = FALSE
)       
```

当启用 `perl=TRUE` 时， 函数 `regexpr` 和 `gregexpr` 支持 Python 环境下的命名捕获(named captures)，但是不支持长向量的输入。如果一个分组被命名了，如 `(?<first>[A-Z][a-z]+)` 那么匹配到的位置按命名返回。函数 `sub` 不支持命名反向引用 (Named backreferences)

函数 `regmatches` 用来提取函数`regexpr`, `gregexpr` 和 `regexec` 匹配到的子字符串

`useBytes = FALSE` 匹配位置和长度默认是按照字符级别来的，如果 `useBytes = TRUE` 则是按照逐个字节的匹配结果

如果使用到了 **命名捕获** 则会返回更多的属性 "capture.start"，"capture.length" 和 "capture.names"，分别表示捕获的起始位置、捕获的长度和捕获的命名。

- `regexpr` 函数返回一个整型向量，第一次匹配的初始位置，-1 表示没有匹配到，返回的属性 `match.length`  表示匹配的字符数量，是一个整型向量，向量长度是匹配的文本的长度，-1 表示没有匹配到


```r
text <- c("Hellow, Adam!", "Hi, Adam!", "How are you, Adam.")
regexpr("Adam", text)
```

```
## [1]  9  5 14
## attr(,"match.length")
## [1] 4 4 4
## attr(,"index.type")
## [1] "chars"
## attr(,"useBytes")
## [1] TRUE
```


```r
txt <- c(
  "The", "licenses", "for", "most", "software", "are",
  "designed", "to", "take", "away", "your", "freedom",
  "to", "share", "and", "change", "it.",
  "", "By", "contrast,", "the", "GNU", "General", "Public", "License",
  "is", "intended", "to", "guarantee", "your", "freedom", "to",
  "share", "and", "change", "free", "software", "--",
  "to", "make", "sure", "the", "software", "is",
  "free", "for", "all", "its", "users"
)
# gregexpr("en", txt)
regexpr("en", txt)
```

```
##  [1] -1  4 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1  2 -1  4
## [26] -1  4 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1
## attr(,"match.length")
##  [1] -1  2 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1  2 -1  2
## [26] -1  2 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1
## attr(,"index.type")
## [1] "chars"
## attr(,"useBytes")
## [1] TRUE
```

- `gregexpr` 函数返回一个列表，返回列表的长度与字符串向量的长度一样，列表中每个元素的形式与 `regexpr` 的返回值一样, except that the starting positions of every (disjoint) match are given.


```r
gregexpr("Adam", text)
```

```
## [[1]]
## [1] 9
## attr(,"match.length")
## [1] 4
## attr(,"index.type")
## [1] "chars"
## attr(,"useBytes")
## [1] TRUE
## 
## [[2]]
## [1] 5
## attr(,"match.length")
## [1] 4
## attr(,"index.type")
## [1] "chars"
## attr(,"useBytes")
## [1] TRUE
## 
## [[3]]
## [1] 14
## attr(,"match.length")
## [1] 4
## attr(,"index.type")
## [1] "chars"
## attr(,"useBytes")
## [1] TRUE
```

- `regexec` 函数返回一个列表，类似函数`gregexpr`的返回结果，长度与字符串向量的长度一样，如果没有匹配到就返回 -1，匹配到了就返回一个匹配的初值位置的整型序列，所有子字符串与括号分组的正则表达式的子表达式对应，属性 "match.length" 是一个表示匹配的长度的向量，如果是 -1 表示没有匹配到。位置、长度和属性的解释与 `regexpr` 一致


```r
regexec("Adam", text)
```

```
## [[1]]
## [1] 9
## attr(,"match.length")
## [1] 4
## attr(,"index.type")
## [1] "chars"
## attr(,"useBytes")
## [1] TRUE
## 
## [[2]]
## [1] 5
## attr(,"match.length")
## [1] 4
## attr(,"index.type")
## [1] "chars"
## attr(,"useBytes")
## [1] TRUE
## 
## [[3]]
## [1] 14
## attr(,"match.length")
## [1] 4
## attr(,"index.type")
## [1] "chars"
## attr(,"useBytes")
## [1] TRUE
```

::: sidebar
由于资源限制（特别是 PCRE）导致的匹配失败，会视为没有匹配，通常伴随一个警告
:::

下面这个将链接分解的例子由 Luke Tierney 提供[^regexp]


```r
x <- "http://stat.umn.edu:80/xyz"
m <- regexec("^(([^:]+)://)?([^:/]+)(:([0-9]+))?(/.*)", x)
m
```

```
## [[1]]
## [1]  1  1  1  8 20 21 23
## attr(,"match.length")
## [1] 26  7  4 12  3  2  4
## attr(,"index.type")
## [1] "chars"
## attr(,"useBytes")
## [1] TRUE
```

这里 x 是一个字符串，所以函数 `regexec` 返回的列表长度为1，正则表达式 `^(([^:]+)://)?([^:/]+)(:([0-9]+))?(/.*)` 括号分组匹配到了7次，第一次匹配整个字符串，所以起始位置是1，而匹配长度是26，即整个字符串的长度，读者可以调用函数 `nchar(x)` 算一下，如果你愿意手动数一下也可以哈！余下不一一介绍，可以根据返回结果和图\@ref(fig:regex101)一起看，最后还可以调用`regmatches`函数抽取匹配到的结果


```r
regmatches(x, m)
```

```
## [[1]]
## [1] "http://stat.umn.edu:80/xyz" "http://"                   
## [3] "http"                       "stat.umn.edu"              
## [5] ":80"                        "80"                        
## [7] "/xyz"
```

我们可以在 <https://regex101.com/> 上测试表达式，如图\@ref(fig:regex101)所示，表达式 `^(([^:]+)://)?([^:/]+)(:([0-9]+))?(/.*)` 包含7个组，每个组的匹配结果见图的右下角，这样我们不难理解，函数 `regmatches` 返回的第列表中，第3个位置是传输协议 protocol `http` ，第4个位置是主机 host `stat.umn.edu`， 第6个位置是端口 port `80` ，第7个位置是路径 path `/xyz`，所以函数 `regmatches` 的作用就是根据函数 `regexec` 匹配的结果抽取子字符串。

\begin{figure}

{\centering \href{https://regex101.com/}{\includegraphics[width=0.75\linewidth]{screenshots/regexp-name-group} }

}

\caption{正则表达式匹配结果}(\#fig:regex101)
\end{figure}

进一步，我们可以用 `regmatches` 函数抽取 URL 的部分内容，如前面提到的传输协议，主机等


```r
URL_parts <- function(x) {
  m <- regexec("^(([^:]+)://)?([^:/]+)(:([0-9]+))?(/.*)", x)
  parts <- do.call(
    rbind,
    lapply(regmatches(x, m), `[`, c(3L, 4L, 6L, 7L))
    # 3,4,6,7是索引位置
  )
  colnames(parts) <- c("protocol", "host", "port", "path")
  parts
}
URL_parts(x)
```

```
##      protocol host           port path  
## [1,] "http"   "stat.umn.edu" "80" "/xyz"
```

目前还没有 `gregexec` 函数，但是可以模拟一个，首先用 `gregexpr` 函数返回匹配的位置，`regmatches` 抽取相应的值，然后用 `regexec` 作用到每一个提取的值，做再一次匹配和值的抽取，实现了全部的匹配。另一个例子


```r
## There is no gregexec() yet, but one can emulate it by running
## regexec() on the regmatches obtained via gregexpr().  E.g.:
pattern <- "([[:alpha:]]+)([[:digit:]]+)"
s <- "Test: A1 BC23 DEF456"
gregexpr(pattern, s)
```

```
## [[1]]
## [1]  7 10 15
## attr(,"match.length")
## [1] 2 4 6
## attr(,"index.type")
## [1] "chars"
## attr(,"useBytes")
## [1] TRUE
```

```r
regmatches(s, gregexpr(pattern, s))
```

```
## [[1]]
## [1] "A1"     "BC23"   "DEF456"
```

```r
lapply(
  regmatches(s, gregexpr(pattern, s)),
  function(e) regmatches(e, regexec(pattern, e))
)
```

```
## [[1]]
## [[1]][[1]]
## [1] "A1" "A"  "1" 
## 
## [[1]][[2]]
## [1] "BC23" "BC"   "23"  
## 
## [[1]][[3]]
## [1] "DEF456" "DEF"    "456"
```

## 字符串替换 {#base-replacement}

`chartr` 支持正则表达式的替换，`chartr` 是对应字符的替换操作


```r
x <- "MiXeD cAsE 123"
# 将字符 iXs 替换为 why
chartr("iXs", "why", x)
```

```
## [1] "MwheD cAyE 123"
```

```r
# 将字符串 a-cX 中的字符挨个对应地替换为 D-Fw
chartr("a-cX", "D-Fw", x)
```

```
## [1] "MiweD FAsE 123"
```

两个 `*sub` 函数的区别：`sub` 替换第一次匹配到的结果，`gsub` 替换所有匹配的结果


```r
sub(" .*", "", extSoftVersion()["PCRE"])
```

```
##    PCRE 
## "10.34"
```

参数 replacement 的值是正则表达式，其包含反向引用的用法， `\\1` 即引用表达式 `([ab])` 


```r
gsub(pattern =  "([ab])", replacement = "\\1_\\1_", x = "abc and ABC")
```

```
## [1] "a_a_b_b_c a_a_nd ABC"
```

## 字符串提取 {#base-extract}


```r
substr(x, start, stop)
substring(text, first, last = 1000000L)
```

`substr` 和 `substring` 函数通过位置进行字符串的拆分和提取，它们本身不使用正则表达式，结合其他正则表达式函数`regexpr`, `gregexpr` 和 `regexec`，可以很方便地从大量文本中提取所需的信息。作用类似之前提到的 `regmatches` 函数

参数设置基本相同

- x/text 是要拆分的字符串向量
- start/first 截取的起始位置向量
- stop/last 截取的终止位置向量

返回值有差别

- `substr` 返回的字串个数等于第一个参数 x 的长度
- `substring` 返回字串个数等于三个参数中最长向量长度，短向量循环使用。


```r
x <- "123456789"
substr(x, c(2, 4), c(4, 5, 8))
```

```
## [1] "234"
```

```r
substring(x, c(2, 4), c(4, 5, 8))
```

```
## [1] "234"     "45"      "2345678"
```

```r
substr("abcdef", 2, 4)
```

```
## [1] "bcd"
```

```r
substring("abcdef", 1:6, 1:6)
```

```
## [1] "a" "b" "c" "d" "e" "f"
```

因为 x 的向量长度为1，所以 `substr` 获得的结果只有1个字串，即第2和第3个参数向量只用了第一个组合：起始位置2，终止位置4。而 `substring` 的语句三个参数中最长的向量为 `c(4,5,8)`，执行时按短向量循环使用的规则第一个参数事实上就是`c(x,x,x)`，第二个参数就成了`c(2,4,2)`，最终截取的字串起始位置组合为：2-4, 4-5和2-8。


```r
x <- c("123456789", "abcdefghijklmnopq")
substr(x, c(2, 4), c(4, 5, 8))
```

```
## [1] "234" "de"
```

```r
substring(x, c(2, 4), c(4, 5, 8))
```

```
## [1] "234"     "de"      "2345678"
```

更加高级的字符串抽取


```r
# 从字符串中抽取固定模式的文本，替代 stringr::str_extract
# 只抽取一个匹配的
extract_str <- function(text, pattern) regmatches(text, regexpr(pattern, text))
# 符合模式的全部抽取
gextract_str <- function(text, pattern) regmatches(text, gregexpr(pattern, text))
```

举例子，抽取连续的数字


```r
# 两个例子
extract_str(text = "abd123da345das", pattern = "(\\d+){3}")
```

```
## [1] "123"
```

```r
gextract_str(text = "abd123da345das", pattern = "(\\d+){3}")
```

```
## [[1]]
## [1] "123" "345"
```

例子来自于 <https://recology.info/2018/10/limiting-dependencies/>

## 命名捕捉 {#string-named-capture}

函数 `regexpr(..., perl = TRUE)` 和 `gregexpr(..., perl = TRUE)` 支持命名捕捉


```r
## named capture
notables <- c("  Ben Franklin and Jefferson Davis",
              "\tMillard Fillmore")
# name groups 'first' and 'last'
name.rex <- "(?<first>[[:upper:]][[:lower:]]+) (?<last>[[:upper:]][[:lower:]]+)"

(parsed <- regexpr(name.rex, notables, perl = TRUE))
```

```
## [1] 3 2
## attr(,"match.length")
## [1] 12 16
## attr(,"index.type")
## [1] "chars"
## attr(,"useBytes")
## [1] TRUE
## attr(,"capture.start")
##      first last
## [1,]     3    7
## [2,]     2   10
## attr(,"capture.length")
##      first last
## [1,]     3    8
## [2,]     7    8
## attr(,"capture.names")
## [1] "first" "last"
```

```r
attr(parsed, 'capture.names')
```

```
## [1] "first" "last"
```

```r
regmatches(notables, parsed)
```

```
## [1] "Ben Franklin"     "Millard Fillmore"
```

希望返回一个 data.frame，列名是指定的 named group 名字


```r
# 有多个结果
(idx <- gregexpr(name.rex, notables, perl = TRUE))
```

```
## [[1]]
## [1]  3 20
## attr(,"match.length")
## [1] 12 15
## attr(,"index.type")
## [1] "chars"
## attr(,"useBytes")
## [1] TRUE
## attr(,"capture.start")
##      first last
## [1,]     3    7
## [2,]    20   30
## attr(,"capture.length")
##      first last
## [1,]     3    8
## [2,]     9    5
## attr(,"capture.names")
## [1] "first" "last" 
## 
## [[2]]
## [1] 2
## attr(,"match.length")
## [1] 16
## attr(,"index.type")
## [1] "chars"
## attr(,"useBytes")
## [1] TRUE
## attr(,"capture.start")
##      first last
## [1,]     2   10
## attr(,"capture.length")
##      first last
## [1,]     7    8
## attr(,"capture.names")
## [1] "first" "last"
```

```r
regmatches(notables, idx)
```

```
## [[1]]
## [1] "Ben Franklin"    "Jefferson Davis"
## 
## [[2]]
## [1] "Millard Fillmore"
```

```r
attr(idx[[1]], 'capture.names')
```

```
## [1] "first" "last"
```


```r
library(magrittr)
data.frame(notable = notables) %>% 
tidyr::extract(
    notable, c("first", "last"), name.rex, 
    remove = FALSE
  )
```

```
##                              notable   first     last
## 1   Ben Franklin and Jefferson Davis     Ben Franklin
## 2                 \tMillard Fillmore Millard Fillmore
```


## 精确匹配 {#exact-match}

`fixed = TRUE`

## 模糊匹配 {#fuzzy-match}

近似字符串匹配 (Approximate String Matching) 也叫模糊匹配 (Fuzzy Matching)

`agrep()` `agrepl()` `aregexec()` `adist()`


```r
agrep(pattern = "lasy", x = "1 lazy 2")
```

```
## [1] 1
```

```r
agrep("lasy", c(" 1 lazy 2", "1 lasy 2"), max = list(sub = 0))
```

```
## [1] 2
```

```r
agrep("laysy", c("1 lazy", "1", "1 LAZY"), max = 2)
```

```
## [1] 1
```

```r
agrep("laysy", c("1 lazy", "1", "1 LAZY"), max = 2, value = TRUE)
```

```
## [1] "1 lazy"
```

```r
agrep("laysy", c("1 lazy", "1", "1 LAZY"), max = 2, ignore.case = TRUE)
```

```
## [1] 1 3
```

```r
agrepl(pattern = "lasy", x = "1 lazy 2")
```

```
## [1] TRUE
```


```r
## Cf. the examples for agrep.
x <- c("1 lazy", "1", "1 LAZY")

aregexec("laysy", x, max.distance = 2)
```

```
## [[1]]
## [1] 3
## attr(,"match.length")
## [1] 4
## 
## [[2]]
## [1] -1
## attr(,"match.length")
## [1] -1
## 
## [[3]]
## [1] -1
## attr(,"match.length")
## [1] -1
```

```r
aregexec("(lay)(sy)", x, max.distance = 2)
```

```
## [[1]]
## [1] 3 3 5
## attr(,"match.length")
## [1] 4 2 2
## 
## [[2]]
## [1] -1
## attr(,"match.length")
## [1] -1
## 
## [[3]]
## [1] -1
## attr(,"match.length")
## [1] -1
```

```r
aregexec("(lay)(sy)", x, max.distance = 2, ignore.case = TRUE)
```

```
## [[1]]
## [1] 3 3 6
## attr(,"match.length")
## [1] 4 3 1
## 
## [[2]]
## [1] -1
## attr(,"match.length")
## [1] -1
## 
## [[3]]
## [1] 3 3 6
## attr(,"match.length")
## [1] 4 3 1
```

```r
m <- aregexec("(lay)(sy)", x, max.distance = 2)
regmatches(x, m)
```

```
## [[1]]
## [1] "lazy" "la"   "zy"  
## 
## [[2]]
## character(0)
## 
## [[3]]
## character(0)
```



```r
## Cf. https://en.wikipedia.org/wiki/Levenshtein_distance
adist("kitten", "sitting")
```

```
##      [,1]
## [1,]    3
```

```r
## To see the transformation counts for the Levenshtein distance:
drop(attr(adist("kitten", "sitting", counts = TRUE), "counts"))
```

```
## ins del sub 
##   1   0   2
```

```r
## To see the transformation sequences:
attr(adist(c("kitten", "sitting"), counts = TRUE), "trafos")
```

```
##      [,1]      [,2]     
## [1,] "MMMMMM"  "SMMMSMI"
## [2,] "SMMMSMD" "MMMMMMM"
```

```r
## Cf. the examples for agrep:
adist("lasy", "1 lazy 2")
```

```
##      [,1]
## [1,]    5
```

```r
## For a "partial approximate match" (as used for agrep):
adist("lasy", "1 lazy 2", partial = TRUE)
```

```
##      [,1]
## [1,]    1
```

案例

`help.search()`

## 高级的替换 {#replace}

相比于 `sprintf()` 格式化输出字符串的方式替换，它的优势在于提示性，或者说代码的可读性


```r
glue_data <- function(param, text) {
  idx <- gregexpr('\\{[^}]*\\}', text)[[1L]]
  keys <- substring(text, idx, idx + attr(idx, 'match.length') - 1L)
  for (key in keys) {
    text <- gsub(key, param[[gsub('[{}]', '', key)]], text, fixed = TRUE)
  }
  text
}
cat(glue_data(
  param = list(table = 'flights', origin = 'JFK'),
  text = "
  select count(*) as n
  from {table}
  where origin = '{origin}'
  "
))
```

```
## 
##   select count(*) as n
##   from flights
##   where origin = 'JFK'
## 
```


## 高级的提取 {#extract}

从 text 中抽取给定模式 pattern 的字符串


```r
str_extract <- function(text, pattern, ...) regmatches(text, regexpr(pattern, text, ...))
```

举个栗子，比如提取数字


```r
shopping_list <- c("apples x4", "bag of flour", "bag of sugar", "milk x2")
stringr::str_extract(shopping_list, "\\d")
```

```
## [1] "4" NA  NA  "2"
```

```r
# 注意二者的差别
str_extract(shopping_list, "\\d")
```

```
## [1] "4" "2"
```

提取所有符合匹配模式的字符串


```r
str_extract_all <- function(text, pattern, ...) regmatches(text, gregexpr(pattern, text, ...))
```

举个栗子，提取其中的英文字母


```r
str_extract_all(shopping_list, "[a-z]+")
```

```
## [[1]]
## [1] "apples" "x"     
## 
## [[2]]
## [1] "bag"   "of"    "flour"
## 
## [[3]]
## [1] "bag"   "of"    "sugar"
## 
## [[4]]
## [1] "milk" "x"
```

```r
stringr::str_extract_all(shopping_list, "[a-z]+")
```

```
## [[1]]
## [1] "apples" "x"     
## 
## [[2]]
## [1] "bag"   "of"    "flour"
## 
## [[3]]
## [1] "bag"   "of"    "sugar"
## 
## [[4]]
## [1] "milk" "x"
```


## 其它操作 {#other-string-op}

### strwrap


```r
strwrap(x, width = 0.9 * getOption("width"), indent = 0,
        exdent = 0, prefix = "", simplify = TRUE, initial = prefix)
```

该函数把一个字符串当成一个段落的文字（不管字符串中是否有换行符），按照段落的格式（缩进和长度）和断字方式进行分行，每一行是结果中的一个字符串。


```r
# 读取一段文本
x <- paste(readLines(file.path(R.home("doc"), "THANKS")), collapse = "\n")
## 将文本拆分为段落，且移除前三段
x <- unlist(strsplit(x, "\n[ \t\n]*\n"))[-(1:3)]
# 每一段换两行
x <- paste(x, collapse = "\n\n")
# 每一行的宽度设定为60个字符
writeLines(strwrap(x, width = 60))
```

```
## J. D. Beasley, David J. Best, Richard Brent, Kevin Buhr,
## Michael A. Covington, Bill Cleveland, Robert Cleveland,, G.
## W. Cran, C. G. Ding, Ulrich Drepper, Paul Eggert, J. O.
## Evans, David M. Gay, H. Frick, G. W. Hill, Richard H.
## Jones, Eric Grosse, Shelby Haberman, Bruno Haible, John
## Hartigan, Andrew Harvey, Trevor Hastie, Min Long Lam,
## George Marsaglia, K. J. Martin, Gordon Matzigkeit, C. R.
## Mckenzie, Jean McRae, Cyrus Mehta, Fionn Murtagh, John C.
## Nash, Finbarr O'Sullivan, R. E. Odeh, William Patefield,
## Nitin Patel, Alan Richardson, D. E. Roberts, Patrick
## Royston, Russell Lenth, Ming-Jen Shyu, Richard C.
## Singleton, S. G. Springer, Supoj Sutanthavibul, Irma
## Terpenning, G. E. Thomas, Rob Tibshirani, Wai Wan Tsang,
## Berwin Turlach, Gary V. Vaughan, Michael Wichura, Jingbo
## Wang, M. A. Wong, and the Free Software Foundation (for
## autoconf code and utilities). See also files under
## src/extras.
## 
## Many more, too numerous to mention here, have contributed
## by sending bug reports and suggesting various improvements.
## 
## Simon Davies whilst at the University of Auckland wrote the
## original version of glm().
## 
## Julian Harris and Wing Kwong (Tiki) Wan whilst at the
## University of Auckland assisted Ross Ihaka with the
## original Macintosh port.
## 
## R was inspired by the S environment which has been
## principally developed by John Chambers, with substantial
## input from Douglas Bates, Rick Becker, Bill Cleveland,
## Trevor Hastie, Daryl Pregibon and Allan Wilks.
## 
## A special debt is owed to John Chambers who has graciously
## contributed advice and encouragement in the early days of R
## and later became a member of the core team.
## 
## Stefano Iacus (a former member of R Core) and Simon Urbanek
## developed the macOS port, including the R.app GUI,
## toolchains and packaging.
## 
## The Windows port was developed by Guido Masarotto (for a
## while a member of R Core) and Brian Ripley, then Duncan
## Murdoch (a former member of R Core) and currently by Jeroen
## Ooms (base) and Uwe Ligges (packages).
## 
## Tomas Kalibera's work has been sponsored by Jan Vitek and
## funded by his European Research Council grant "Evolving
## Language Ecosystems (ELE)".
## 
## Computing support (including hardware, hosting and
## infrastructure) has been provided/funded by the R
## Foundation, employers of R-Core members (notably WU Wien,
## ETH Zurich, U Oxford and U Iowa) and by Northeastern
## University and the University of Kent.
## 
## Distributions of R contain the recommended packages, whose
## authors/contributors are listed in their DESCRIPTION files.
```

```r
# 每一段的段首缩进5个字符
writeLines(strwrap(x, width = 60, indent = 5))
```

```
##      J. D. Beasley, David J. Best, Richard Brent, Kevin
## Buhr, Michael A. Covington, Bill Cleveland, Robert
## Cleveland,, G. W. Cran, C. G. Ding, Ulrich Drepper, Paul
## Eggert, J. O. Evans, David M. Gay, H. Frick, G. W. Hill,
## Richard H. Jones, Eric Grosse, Shelby Haberman, Bruno
## Haible, John Hartigan, Andrew Harvey, Trevor Hastie, Min
## Long Lam, George Marsaglia, K. J. Martin, Gordon
## Matzigkeit, C. R. Mckenzie, Jean McRae, Cyrus Mehta, Fionn
## Murtagh, John C. Nash, Finbarr O'Sullivan, R. E. Odeh,
## William Patefield, Nitin Patel, Alan Richardson, D. E.
## Roberts, Patrick Royston, Russell Lenth, Ming-Jen Shyu,
## Richard C. Singleton, S. G. Springer, Supoj Sutanthavibul,
## Irma Terpenning, G. E. Thomas, Rob Tibshirani, Wai Wan
## Tsang, Berwin Turlach, Gary V. Vaughan, Michael Wichura,
## Jingbo Wang, M. A. Wong, and the Free Software Foundation
## (for autoconf code and utilities). See also files under
## src/extras.
## 
##      Many more, too numerous to mention here, have
## contributed by sending bug reports and suggesting various
## improvements.
## 
##      Simon Davies whilst at the University of Auckland
## wrote the original version of glm().
## 
##      Julian Harris and Wing Kwong (Tiki) Wan whilst at the
## University of Auckland assisted Ross Ihaka with the
## original Macintosh port.
## 
##      R was inspired by the S environment which has been
## principally developed by John Chambers, with substantial
## input from Douglas Bates, Rick Becker, Bill Cleveland,
## Trevor Hastie, Daryl Pregibon and Allan Wilks.
## 
##      A special debt is owed to John Chambers who has
## graciously contributed advice and encouragement in the
## early days of R and later became a member of the core team.
## 
##      Stefano Iacus (a former member of R Core) and Simon
## Urbanek developed the macOS port, including the R.app GUI,
## toolchains and packaging.
## 
##      The Windows port was developed by Guido Masarotto (for
## a while a member of R Core) and Brian Ripley, then Duncan
## Murdoch (a former member of R Core) and currently by Jeroen
## Ooms (base) and Uwe Ligges (packages).
## 
##      Tomas Kalibera's work has been sponsored by Jan Vitek
## and funded by his European Research Council grant "Evolving
## Language Ecosystems (ELE)".
## 
##      Computing support (including hardware, hosting and
## infrastructure) has been provided/funded by the R
## Foundation, employers of R-Core members (notably WU Wien,
## ETH Zurich, U Oxford and U Iowa) and by Northeastern
## University and the University of Kent.
## 
##      Distributions of R contain the recommended packages,
## whose authors/contributors are listed in their DESCRIPTION
## files.
```

```r
# 除了段首，每一段的余下诸行都缩进5个字符
writeLines(strwrap(x, width = 60, exdent = 5))
```

```
## J. D. Beasley, David J. Best, Richard Brent, Kevin Buhr,
##      Michael A. Covington, Bill Cleveland, Robert
##      Cleveland,, G. W. Cran, C. G. Ding, Ulrich Drepper,
##      Paul Eggert, J. O. Evans, David M. Gay, H. Frick, G.
##      W. Hill, Richard H. Jones, Eric Grosse, Shelby
##      Haberman, Bruno Haible, John Hartigan, Andrew Harvey,
##      Trevor Hastie, Min Long Lam, George Marsaglia, K. J.
##      Martin, Gordon Matzigkeit, C. R. Mckenzie, Jean McRae,
##      Cyrus Mehta, Fionn Murtagh, John C. Nash, Finbarr
##      O'Sullivan, R. E. Odeh, William Patefield, Nitin
##      Patel, Alan Richardson, D. E. Roberts, Patrick
##      Royston, Russell Lenth, Ming-Jen Shyu, Richard C.
##      Singleton, S. G. Springer, Supoj Sutanthavibul, Irma
##      Terpenning, G. E. Thomas, Rob Tibshirani, Wai Wan
##      Tsang, Berwin Turlach, Gary V. Vaughan, Michael
##      Wichura, Jingbo Wang, M. A. Wong, and the Free
##      Software Foundation (for autoconf code and utilities).
##      See also files under src/extras.
## 
## Many more, too numerous to mention here, have contributed
##      by sending bug reports and suggesting various
##      improvements.
## 
## Simon Davies whilst at the University of Auckland wrote the
##      original version of glm().
## 
## Julian Harris and Wing Kwong (Tiki) Wan whilst at the
##      University of Auckland assisted Ross Ihaka with the
##      original Macintosh port.
## 
## R was inspired by the S environment which has been
##      principally developed by John Chambers, with
##      substantial input from Douglas Bates, Rick Becker,
##      Bill Cleveland, Trevor Hastie, Daryl Pregibon and
##      Allan Wilks.
## 
## A special debt is owed to John Chambers who has graciously
##      contributed advice and encouragement in the early days
##      of R and later became a member of the core team.
## 
## Stefano Iacus (a former member of R Core) and Simon Urbanek
##      developed the macOS port, including the R.app GUI,
##      toolchains and packaging.
## 
## The Windows port was developed by Guido Masarotto (for a
##      while a member of R Core) and Brian Ripley, then
##      Duncan Murdoch (a former member of R Core) and
##      currently by Jeroen Ooms (base) and Uwe Ligges
##      (packages).
## 
## Tomas Kalibera's work has been sponsored by Jan Vitek and
##      funded by his European Research Council grant
##      "Evolving Language Ecosystems (ELE)".
## 
## Computing support (including hardware, hosting and
##      infrastructure) has been provided/funded by the R
##      Foundation, employers of R-Core members (notably WU
##      Wien, ETH Zurich, U Oxford and U Iowa) and by
##      Northeastern University and the University of Kent.
## 
## Distributions of R contain the recommended packages, whose
##      authors/contributors are listed in their DESCRIPTION
##      files.
```

```r
# 在输出的每一行前面添加前缀
writeLines(strwrap(x, prefix = "THANKS> "))
```

```
## THANKS> J. D. Beasley, David J. Best, Richard Brent, Kevin Buhr,
## THANKS> Michael A. Covington, Bill Cleveland, Robert Cleveland,, G. W.
## THANKS> Cran, C. G. Ding, Ulrich Drepper, Paul Eggert, J. O. Evans,
## THANKS> David M. Gay, H. Frick, G. W. Hill, Richard H. Jones, Eric
## THANKS> Grosse, Shelby Haberman, Bruno Haible, John Hartigan, Andrew
## THANKS> Harvey, Trevor Hastie, Min Long Lam, George Marsaglia, K. J.
## THANKS> Martin, Gordon Matzigkeit, C. R. Mckenzie, Jean McRae, Cyrus
## THANKS> Mehta, Fionn Murtagh, John C. Nash, Finbarr O'Sullivan, R. E.
## THANKS> Odeh, William Patefield, Nitin Patel, Alan Richardson, D. E.
## THANKS> Roberts, Patrick Royston, Russell Lenth, Ming-Jen Shyu, Richard
## THANKS> C. Singleton, S. G. Springer, Supoj Sutanthavibul, Irma
## THANKS> Terpenning, G. E. Thomas, Rob Tibshirani, Wai Wan Tsang, Berwin
## THANKS> Turlach, Gary V. Vaughan, Michael Wichura, Jingbo Wang, M. A.
## THANKS> Wong, and the Free Software Foundation (for autoconf code and
## THANKS> utilities). See also files under src/extras.
## THANKS> 
## THANKS> Many more, too numerous to mention here, have contributed by
## THANKS> sending bug reports and suggesting various improvements.
## THANKS> 
## THANKS> Simon Davies whilst at the University of Auckland wrote the
## THANKS> original version of glm().
## THANKS> 
## THANKS> Julian Harris and Wing Kwong (Tiki) Wan whilst at the
## THANKS> University of Auckland assisted Ross Ihaka with the original
## THANKS> Macintosh port.
## THANKS> 
## THANKS> R was inspired by the S environment which has been principally
## THANKS> developed by John Chambers, with substantial input from Douglas
## THANKS> Bates, Rick Becker, Bill Cleveland, Trevor Hastie, Daryl
## THANKS> Pregibon and Allan Wilks.
## THANKS> 
## THANKS> A special debt is owed to John Chambers who has graciously
## THANKS> contributed advice and encouragement in the early days of R and
## THANKS> later became a member of the core team.
## THANKS> 
## THANKS> Stefano Iacus (a former member of R Core) and Simon Urbanek
## THANKS> developed the macOS port, including the R.app GUI, toolchains
## THANKS> and packaging.
## THANKS> 
## THANKS> The Windows port was developed by Guido Masarotto (for a while
## THANKS> a member of R Core) and Brian Ripley, then Duncan Murdoch (a
## THANKS> former member of R Core) and currently by Jeroen Ooms (base)
## THANKS> and Uwe Ligges (packages).
## THANKS> 
## THANKS> Tomas Kalibera's work has been sponsored by Jan Vitek and
## THANKS> funded by his European Research Council grant "Evolving
## THANKS> Language Ecosystems (ELE)".
## THANKS> 
## THANKS> Computing support (including hardware, hosting and
## THANKS> infrastructure) has been provided/funded by the R Foundation,
## THANKS> employers of R-Core members (notably WU Wien, ETH Zurich, U
## THANKS> Oxford and U Iowa) and by Northeastern University and the
## THANKS> University of Kent.
## THANKS> 
## THANKS> Distributions of R contain the recommended packages, whose
## THANKS> authors/contributors are listed in their DESCRIPTION files.
```

再举一个烧脑的例子


```r
x <- paste(sapply(
  sample(10, 100, replace = TRUE), # 从1-10个数字中有放回的随机抽取100个数
  function(x) substring("aaaaaaaaaa", 1, x)
), collapse = " ")
sapply(
  10:40,
  function(m)
    c(target = m, actual = max(nchar(strwrap(x, m))))
)
```

```
##        [,1] [,2] [,3] [,4] [,5] [,6] [,7] [,8] [,9] [,10] [,11] [,12] [,13]
## target   10   11   12   13   14   15   16   17   18    19    20    21    22
## actual   10   10   11   12   13   14   15   16   17    18    19    20    21
##        [,14] [,15] [,16] [,17] [,18] [,19] [,20] [,21] [,22] [,23] [,24] [,25]
## target    23    24    25    26    27    28    29    30    31    32    33    34
## actual    22    23    24    25    26    27    28    29    30    31    32    33
##        [,26] [,27] [,28] [,29] [,30] [,31]
## target    35    36    37    38    39    40
## actual    34    35    36    37    38    39
```

### strtrim


```r
strtrim(x, width)
```

`strtrim` 函数将字符串x修剪到特定的显示宽度，返回的字符串向量的长度等于字符串向量 x 的长度，如果 width 的参数值（它是一个整型向量）的长度小于 x 的，就循环补齐。


```r
strtrim(c("abcdef", "abcdef", "abcdef"), c(1, 5, 10))
```

```
## [1] "a"      "abcde"  "abcdef"
```
### strrep


```r
strrep(x, times)
```

以给定的次数重复字符串向量中每个元素的个数，并连接字符串的各个副本


```r
strrep("ABC", 2)
```

```
## [1] "ABCABC"
```

```r
strrep(c("A", "B", "C"), 1 : 3)
```

```
## [1] "A"   "BB"  "CCC"
```

```r
# 创建一个字符串向量，指定每个元素中空格的数量
strrep(" ", 1 : 5)
```

```
## [1] " "     "  "    "   "   "    "  "     "
```

### trimws


```r
trimws(x, which = c("both", "left", "right"), whitespace = "[ \t\r\n]")
```

`trimws` 函数用于移除字符串中的空格，这种空格可以来自制表符、回车符和换行符，位置可以位于字符串的开头或者结尾，`which` 参数指定空格的大致位置。举例如下


```r
x <- "  Some text. "
x
```

```
## [1] "  Some text. "
```

```r
trimws(x)
```

```
## [1] "Some text."
```

```r
trimws(x, "l")
```

```
## [1] "Some text. "
```

```r
trimws(x, "r")
```

```
## [1] "  Some text."
```




```r
shopping_list <- c("apples x4", "bag of flour", "bag of sugar", "milk x2")

stringr::str_replace(string = shopping_list, pattern = "\\d", replacement = "aa")
```

```
## [1] "apples xaa"   "bag of flour" "bag of sugar" "milk xaa"
```



```r
# https://github.com/hadley/stringb/issues/5
# x is vector
str_replace <- function(x, pattern, fun, ...) {
  loc <- gregexpr(pattern, text = x, perl = TRUE)
  matches <- regmatches(x, loc)
  out <- lapply(matches, fun, ...)

  regmatches(x, loc) <- out
  x
}


loc <- gregexpr(pattern = "\\d", text = shopping_list, perl = TRUE)

matches = regmatches(x = shopping_list, loc)

matches

out <- lapply(matches, transform, "aa")

regmatches(x = shopping_list, loc) <- out


shopping_list


str_replace(shopping_list, pattern = "\\\\d", replace = "aa")
```

### tolower

tolower 和 toupper 是一对，将大写转小写，小写转大写


```r
simpleCap <- function(x) {
  x <- tolower(x)
  s <- strsplit(x, " ")[[1]]
  paste(toupper(substring(s, 1, 1)), substring(s, 2),
    sep = "", collapse = " "
  )
}
# 参考文献条目里需要将每个英文单词的首字母大写
simpleCap(x = "THE USE OF MULTIPLE MEASUREMENTS IN TAXONOMIC PROBLEMS")
```

```
## [1] "The Use Of Multiple Measurements In Taxonomic Problems"
```

## 字符串加密 {#encode-string}

字符串编码加密， **openssl** 包提供了 sha1 函数 [^encode]


```r
library(openssl)
encode_mobile <- function(phone_number) paste("*", paste(toupper(sha1(sha1(charToRaw(paste(phone_number, "$1$mobile$", sep = ""))))), collapse = ""), sep = "")
# 随意模拟两个手机号
mobile_vec <- c("18601013453", "13811674545")
sapply(mobile_vec, encode_mobile)
```

```
##                                 18601013453 
## "*B1D46D1D62C7280137F0E14249EE500865247B7B" 
##                                 13811674545 
## "*0554DA6E403491F58F1567DF2EDEB19186B77173"
```

[^encode]: 参考刘思喆的两篇博文： [利用 R 函数生成差异化密码](http://bjt.name/2019/09/28/secure-hash.html) 和 [在 R 中各种码的转换](http://bjt.name/2019/10/21/url-handle.html)


## 处理性能 {#performance}

当你对一个很长的字符串进行大量的正则表达式匹配的时候，你需要考虑性能问题了，这时候该考虑启用合适的选项，一般来讲， PCRE 比默认的正则表达式引擎快，`fixed=TRUE` 可以继续加快匹配速度，特别是当每个模式只匹配少量次数时。

连接字符串，`paste/c/bfile/bracket` 函数性能比较
<https://wch.github.io/string_builder/index.html>

R 内置的默认正则表达式匹配方式是基于 PCRE 的匹配，`options` 控制 PCRE 默认的三个选项 `PCRE_limit_recursion=NA` 、`PCRE_study=10` 和 `PCRE_use_JIT=TRUE`，当前系统环境下 PCRE 的支持情况


```r
pcre_config()
```

```
##              UTF-8 Unicode properties                JIT              stack 
##               TRUE               TRUE               TRUE              FALSE
```

查看R环境的 PCRE 配置


```r
sapply(c("PCRE_limit_recursion", "PCRE_study", "PCRE_use_JIT"), getOption)
```

```
## PCRE_limit_recursion           PCRE_study         PCRE_use_JIT 
##                   NA                FALSE                 TRUE
```


## 网络爬虫 {#web-crawler}

用 R 语言写爬虫 [curl](https://github.com/jeroen/curl)、[httr](https://github.com/r-lib/httr)、 [xml2](https://github.com/r-lib/xml2)、[XML](https://CRAN.R-project.org/package=XML) 和 [rvest](https://github.com/tidyverse/rvest) 解析网页[^RCurl]


```r
# 查看 libcurl 库的版本
libcurlVersion()
```

```
## [1] "7.68.0"
## attr(,"ssl_version")
## [1] "OpenSSL/1.1.1f"
## attr(,"libssh_version")
## [1] "libssh/0.9.3/openssl/zlib"
## attr(,"protocols")
##  [1] "dict"   "file"   "ftp"    "ftps"   "gopher" "http"   "https"  "imap"  
##  [9] "imaps"  "ldap"   "ldaps"  "pop3"   "pop3s"  "rtmp"   "rtsp"   "scp"   
## [17] "sftp"   "smb"    "smbs"   "smtp"   "smtps"  "telnet" "tftp"
```

于主编利用 [tidyRSS](https://github.com/RobertMyles/tidyRSS) 包 抓取解析博客站点的订阅信息，并将此设置为定时任务，创建自动更新内容的博客聚合网站 [Daily R](https://dailyr.netlify.com/)

抓取地震台信息

[^RCurl]: Jeroen Ooms 已经确认 RCurl 早已经不再维护，取代它的是 curl/httr，不要使用不再维护的 R 包 <https://frie.codes/curl-vs-rcurl/>

[一个爬网页的练习：看看 R 邮件列表中最热门的讨论是什么](https://d.cosx.org/d/420739)

## 文本挖掘 {#text-mining}

[How did Axios rectangle Trump's PDF schedule? A try with R](https://masalmon.eu/2019/02/11/trump-schedule/) 使用 pdftools 和 magick 处理表格，这两个 R 包分别依赖 Poppler C++ 和 ImageMagick++，在 Ubuntu 上安装 pdftools 和 magick 包

```bash
sudo apt-get install libpoppler-cpp-dev libmagick++-dev
```


```r
install.packages(c("pdftools", "magick"))
```

除了 pdftools 包外，PDF 文档中表格抽取工具还有 [tabulizer](https://github.com/ropensci/tabulizer)。扫描版 PDF 文档需要OCR识别技术支持的 tesseract 包


## 运行环境 {#string-session-info}


```r
xfun::session_info()
```

```
## R version 4.1.1 (2021-08-10)
## Platform: x86_64-pc-linux-gnu (64-bit)
## Running under: Ubuntu 20.04.3 LTS
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
##   askpass_1.1      assertthat_0.2.1 base64enc_0.1.3  bookdown_0.24   
##   cli_3.0.1        compiler_4.1.1   cpp11_0.4.0      crayon_1.4.1    
##   curl_4.3.2       DBI_1.1.1        digest_0.6.28    dplyr_1.0.7     
##   ellipsis_0.3.2   evaluate_0.14    fansi_0.5.0      fastmap_1.1.0   
##   generics_0.1.0   glue_1.4.2       graphics_4.1.1   grDevices_4.1.1 
##   highr_0.9        htmltools_0.5.2  jquerylib_0.1.4  jsonlite_1.7.2  
##   knitr_1.36       lifecycle_1.0.1  magrittr_2.0.1   methods_4.1.1   
##   openssl_1.4.5    pillar_1.6.3     pkgconfig_2.0.3  purrr_0.3.4     
##   R6_2.5.1         rlang_0.4.11     rmarkdown_2.11   stats_4.1.1     
##   stringi_1.7.4    stringr_1.4.0    sys_3.4          tibble_3.1.5    
##   tidyr_1.1.4      tidyselect_1.1.1 tinytex_0.34     tools_4.1.1     
##   utf8_1.2.2       utils_4.1.1      vctrs_0.3.8      xfun_0.26       
##   yaml_2.2.1
```

[^regexp]: https://homepage.divms.uiowa.edu/~luke/R/regexp.html

