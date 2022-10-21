# 正则表达式 {#chap-regular-expressions}

> Douglas Bates: If you really want to be cautious you could use an octal
representation like `sep="\\007"` to get a character that is very unlikely to
occur in a factor level.
>
> Ed L. Cashin: I definitely want to be cautious. Instead of the bell character
I think I'll use the field separator character, `"\\034"`, just because this is
the first time I've been able to use it for it's intended purpose! ;)
>
> Douglas Bates: Yes, but with `"\\034"` you don't get to make obscure James Bond
references :-)
>
>   --- Douglas Bates and Ed L. Cashin
      R-help (April 2004)

维基百科关于 [正则表达式的描述](https://www.wikiwand.com/en/Regular_expression)， [学习正则表达式](https://github.com/ziishaned/learn-regex/blob/master/translations/README-cn.md)


```r
# 毒鸡汤用来做文本分析
# https://github.com/egotong/nows/blob/master/soul.sql
```

R 内置的三种匹配模式

1. `fixed = TRUE`: 字面意思匹配 exact matching.
1. `perl = TRUE`: 使用 Perl 正则表达式.
1. `fixed = FALSE, perl = FALSE`: 使用 POSIX 1003.2 extended 正则表达式 (默认设置).

不要拘泥于一种解决方案，比如清理数据中正则表达式有 Base R 提供的一套，stringr 又一套，提高效率的工具 RStudio 插件 [regexplain](https://github.com/gadenbuie/regexplain) 和辅助创建正则表达式 [RVerbalExpressions](https://github.com/VerbalExpressions/RVerbalExpressions) 包。


有几个名词需要单独拎出来解释的

- literal character strings 字面字符串
- metacharacters 元字符
- extended regular expressions 在下文中约定翻译为默认正则表达式
- character class 字符集 `[abc]`
- Perl-like regular expressions  Perl 风格的正则表达式

以下所述，都不考虑函数中参数 `perl=TRUE` 的情况，R 语言中提供了扩展的（默认的）和 Perl 风格 的两套正则表达式。作为入门，我们这里只关注前者，启用 Perl 正则表达式只需在函数如 `grep` 中将选项 `perl = TRUE` 即可，并将后者统一命名为 Perl 正则表达式[^learn-regex]。

正则表达式 (**reg**ular **exp**ression，简称 regexp)， 函数 `regexpr` 和 `gregexpr` 的名称就好理解了，在控制台输入 `?regex` 查看 R 支持的正则表达式，这个文档看上百八十回也不过分。R 内支持正则表达式的函数有 `grep`、`grepl`、`sub`、`gsub`、`regexpr`、`gregexpr` 、 `regexec` 和 `strsplit`。函数 `apropos`，`browseEnv`，`help.search`，`list.files` 和 `ls` 是通过函数 `grep` 来使用正则表达式的，它们全都使用 extended regular expressions

```r
grep(pattern, x, ignore.case = FALSE, perl = FALSE, value = FALSE,
     fixed = FALSE, useBytes = FALSE, invert = FALSE)
```

匹配模式 pattern 的内容 可以用函数 `cat` 打印出来，注意反斜杠进入 R 字符串中时，需要用两个，反斜杠 `\` 本身是转义符，否则会报错。


```r
cat("\\") # \ 反斜杠是转义字符
```

```
## \
```

```r
cat("\\.")
```

```
## \.
```

```r
cat("\\\n") # 注意 \n 表示换行
```

```
## \
```

## 字符常量 {#character-constants}

单引号 `'` 双引号 `"` 和反引号 \` 三种类型的引用 (quotes) 是 R 语法的一部分[^quotes]，此外反斜杠 `\` 用来转义下面的字符

Table: (\#tab:character-constants) 字符常量表

|   字符常量  |   含义
|:----------- |:---------------------------------
|`\n`	        | 换行 newline 
|`\r`	        | 回车 carriage return
|`\t`	        | 制表符 tab
|`\b`	        | 退格 backspace
|`\a`	        | 警报（铃）alert (bell)
|`\f`	        | 换页 form feed
|`\v`	        | 垂直制表符 vertical tab
|`\\`	        | 反斜杠 backslash `\`
|`\'`	        | 单引号 ASCII apostrophe `'`
|`\"`	        | 双引号 ASCII quotation mark `"`
| `` \` ``    | 反引号或沉音符 ASCII grave accent (backtick) \`
|`\nnn`	      | 八进制 character with given octal code (1, 2 or 3 digits)
|`\xnn`	      | 十六进制 character with given hex code (1 or 2 hex digits)
|`\unnnn`	    | Unicode character with given code (1--4 hex digits)
|`\Unnnnnnnn`	| Unicode character with given code (1--8 hex digits)


[^quotes]: https://stat.ethz.ch/R-manual/R-devel/library/base/html/Quotes.html

## 软件环境 {#environments}

R 内置的正则表达式实现是基于 PCRE ICU TRE iconv 等第三方库，搞清楚自己使用的版本信息是重要的，一些字符集的解释与区域环境有关，如 `[:alnum:]` 和 `[:alpha:]`等，所以获取当前的区域设置也很重要


```r
# find a suitable coding for the current locale
localeToCharset(locale = Sys.getlocale("LC_CTYPE"))
```

```
## [1] "UTF-8"     "ISO8859-1"
```

```r
# 软件版本信息
extSoftVersion()
```

```
##                                              zlib 
##                                          "1.2.11" 
##                                             bzlib 
##                              "1.0.8, 13-Jul-2019" 
##                                                xz 
##                                           "5.2.4" 
##                                              PCRE 
##                                "10.40 2022-04-14" 
##                                               ICU 
##                                            "66.1" 
##                                               TRE 
##                         "TRE 0.8.0 R_fixes (BSD)" 
##                                             iconv 
##                                      "glibc 2.31" 
##                                          readline 
##                                             "8.0" 
##                                              BLAS 
## "/usr/lib/x86_64-linux-gnu/blas/libblas.so.3.9.0"
```

```r
# 区域及其编码信息
l10n_info()
```

```
## $MBCS
## [1] TRUE
## 
## $`UTF-8`
## [1] TRUE
## 
## $`Latin-1`
## [1] FALSE
## 
## $codeset
## [1] "UTF-8"
```

```r
# 表示数字、货币的细节
Sys.localeconv()
```

```
##     decimal_point     thousands_sep          grouping   int_curr_symbol 
##               "."                ""                ""            "USD " 
##   currency_symbol mon_decimal_point mon_thousands_sep      mon_grouping 
##               "$"               "."               ","        "\003\003" 
##     positive_sign     negative_sign   int_frac_digits       frac_digits 
##                ""               "-"               "2"               "2" 
##     p_cs_precedes    p_sep_by_space     n_cs_precedes    n_sep_by_space 
##               "1"               "0"               "1"               "0" 
##       p_sign_posn       n_sign_posn 
##               "1"               "1"
```

```r
# PCRE 启用的配置选项
pcre_config()
```

```
##              UTF-8 Unicode properties                JIT              stack 
##               TRUE               TRUE               TRUE              FALSE
```

```r
# 比较全的字符信息
stringi::stri_info()
```

```
## $Unicode.version
## [1] "13.0"
## 
## $ICU.version
## [1] "66.1"
## 
## $Locale
## $Locale$Language
## [1] "en"
## 
## $Locale$Country
## [1] "US"
## 
## $Locale$Variant
## [1] ""
## 
## $Locale$Name
## [1] "en_US"
## 
## 
## $Charset.internal
## [1] "UTF-8"  "UTF-16"
## 
## $Charset.native
## $Charset.native$Name.friendly
## [1] "UTF-8"
## 
## $Charset.native$Name.ICU
## [1] "UTF-8"
## 
## $Charset.native$Name.UTR22
## [1] NA
## 
## $Charset.native$Name.IBM
## [1] "ibm-1208"
## 
## $Charset.native$Name.WINDOWS
## [1] "windows-65001"
## 
## $Charset.native$Name.JAVA
## [1] "UTF-8"
## 
## $Charset.native$Name.IANA
## [1] "UTF-8"
## 
## $Charset.native$Name.MIME
## [1] "UTF-8"
## 
## $Charset.native$ASCII.subset
## [1] TRUE
## 
## $Charset.native$Unicode.1to1
## [1] NA
## 
## $Charset.native$CharSize.8bit
## [1] FALSE
## 
## $Charset.native$CharSize.min
## [1] 1
## 
## $Charset.native$CharSize.max
## [1] 3
## 
## 
## $ICU.system
## [1] TRUE
## 
## $ICU.UTF8
## [1] TRUE
```

需要临时改变区域环境设置，配合特殊的画图和文本输出要求。


```r
# 获取当前默认的区域设置
Sys.getlocale()
foo <- Sys.getlocale()
# 恢复默认的区域设置
Sys.setlocale("LC_ALL", locale = foo)
```

## 基本概念 {#foundations}

正则表达式的构造方式类似算术表达式，通过各种操作组合子（更小的）表达式，整个表达式匹配一个或多个字符[^char-byte]。大多数字符，包括所有的字母和数字，是匹配自身的正则表达式。元字符 `. \ | ( ) [ { ^ $ * + ?` 需要转义才能表达其自身的含义，转义的方式是在元字符前面添加反斜杠，如要表达点号 `.` 需要使用 `\.`。要注意，它们是否有特殊意义取决于所在的内容。

一个字符集 (character class) 是用一对中括号`[]`括起来的字符列表，用来匹配列表中的任意单个字符，除非列表中的第一个字符是 `^`，它用来匹配不在这个列表中的字符。 `[0123456789]` 用来匹配任意单个数字，`[^abc]` 用来匹配除字符 `a,b,c` 以外的任意字符。字符范围 (character ranges) 可以通过第一个和最后一个字符指定， 中间用连字符 (hyphen) 连接， 由于这种解释依赖于区域和具体实现，所以指定字符范围的使用方式最好避免。唯一可移植（便携，通用）的方式是作为字符集，在列表中列出所有的 ASCII 字母，
`[ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz]`.

预定义的一些字符类，它们的解释依赖于当前的语言区域，下面是 POSIX locale 环境下的解释

- `[:alnum:]` 表示  `[:alpha:]` 和 `[:digit:]`，含义是 `[0-9A-Za-z]`，但是前者与区域和字符集无关，后者依赖于当前的区域设置和字符编码。要注意在这些字符集名 class names 中，中括号 `[]` 是符号名的一部分，是必须要包含的。在字符集中，大多数元字符失去它们特殊的意义。

- `[:alpha:]` 表示 `[:lower:]` 和 `[:upper:]`
- `[:blank:]` 表示 空格 space 制表符 tab
- `[:cntrl:]` 表示控制符，在 ASCII 字符集里里，这些字符有八进制代码，从 000 到 037，和 177(DEL)。 
- `[:digit:]` 表示数字 0,1,2,3,4,5,6,7,8,9
- `[:graph:]` 表示 `[:alnum:]` 和 `[:punct:]`.
- `[:lower:]` 表示当前区域下的小写字母
- `[:print:]` 表示可打印的字符  `[:alnum:]`, `[:punct:]` 和空格.
- `[:punct:]` 表示标点字符 

  ```
  ! " # $ % & ' ( ) * + , - . / : ; < = > ? @ [ \ ] ^ _ ` { | } ~`
  ```

- `[:space:]` 表示空格字符： 水平制表符 tab， 换行符 newline，垂直制表符 vertical tab，换页符 form feed，回车符 carriage return，空格符 space 
- `[:xdigit:]` 表示 16 进制数字 0 1 2 3 4 5 6 7 8 9 A B C D E F a b c d e f.


要包含字面的 `]` 就把它放在列表的开头，类似地，要包含字面 `^`，除了开头可以放在任意位置。要包含字面 `-` 把它放在开头或者结尾。只有 `^ - \ ]` 在字符集内是有特殊的含义

点号 `.` 匹配任意单个字符，`\w` 匹配一个词 word 字符(是`[[:alnum:]_]`的同义词，一个扩展) ，而 `\W` 是 `\w` 取反，意味着 `[^[:alnum:]_]`。 `\d`, `\s`, `\D` 和 `\S` 表示数字和空格类和它们的取反

脱字符 caret `^` 和美元符号 `$` 是元字符，分别匹配一行的开头和结尾。符号 `\<` 和 `\>` 分别匹配一个词的开头和结尾的空字符串。`\b` 匹配词边缘的空字符串，`\B` 匹配不在词边缘的空字符串。 词 word 的解释依赖于区域和实现。

## 字符串匹配 {#match}

默认的匹配方式是贪婪的，会使用尽可能多的匹配次数，这个可以变为最小的匹配次数，通过在其之后添加 `?`，一个正则表达式可能跟着重复量词，下面的限定符都是限定在它前面的正则表达式

Table: (\#tab:repetition-quantifiers) 贪婪匹配限定符

|    符号      |     描述                |
|:-----------  | :---------------------- |
|    `?`       | 匹配至多 1 次           |
|    `*`       | 匹配 0 次或多次         |
|    `+`       | 匹配至少 1 次           |
|    `{n}`     | 匹配 n 次               |
|    `{n,}`    | 匹配至少 n 次           |
|    `{n,m}`   | 匹配至少 n 次，至多 m 次|

## 级联表达式 {#concatenation}

> Regular expressions may be concatenated; the resulting regular expression matches any string formed by concatenating the substrings that match the concatenated subexpressions.

正则表达式可以是级联 concatenation 的，是不是在讲一个正则表达式里面嵌套一个正则表达式？

两个正则表达式可以通过中缀符号 `|` 联合，用两个子表达式的任意一个去匹配字符串，例如 `abba | cde` 要么匹配字符串 `abba` 要么匹配字符串 `cde`，要注意在字符集内，即 `abba|cde`，二选一的匹配不凑效，因为中缀符 `|` 有它的字面意思。

重复匹配 Repetition 的优先级高于级联，级联高于 `|` 。 整个子表达式可以括号括起来覆盖这些优先级规则。

## 反向引用 {#backreference}

反向引用 `\N` 这里 N 可取 1,2,...,9 匹配被之前第 N 个括起来的子表达式匹配的子字符串，例子见 COS 论坛 <https://d.cosx.org/d/420570/5>

## 命名捕捉 {#regexp-named-capture}

模式 `(?:...)` 包住的字符就是括号分组，但是不做反向查找。模式 `(?<=...)` 和 `(?<!...)` 都是反向查找，它们不允许跟限制符，在 `...` 也不允许出现 `\C`。表 \@ref(tab:group-lookaround) 展示四个反向引用

Table: (\#tab:group-lookaround) 环顾四周查找

|    符号      |     描述     |
|:-----------: | :-----------:|
|    `?=`      | 正向肯定查找 |
|    `?!`      | 正向否定查找 |
|    `?<=`     | 反向肯定查找 |
|    `?<!`     | 反向否定查找 |

函数 `regexpr` 和 `gregexpr` 支持命名捕捉 (named capture). 如果一个组被命名了，如 `(?<first>[A-Z][a-z]+)` 那么，匹配的位置是按名字返回。

下面举个例子说明，从字符串向量 `notables` 中获得了三组匹配 `name.rex` 是一段正则表达式，描述的模式是人名


```r
## named capture
notables <- c("  Ben Franklin and Jefferson Davis",
              "\tMillard Fillmore")
# name groups 'first' and 'last'
name.rex <- "(?<first>[[:upper:]][[:lower:]]+) (?<last>[[:upper:]][[:lower:]]+)"
parsed <- regexpr(name.rex, notables, perl = TRUE)
parsed
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

`notables` 是一个长度为2的字符串向量，所以获得两组匹配，捕捉到匹配开始的位置 `capture.start` 和匹配的长度 `capture.length` 都是两组，按列来看，字符 B 出现在字符串 `  Ben Franklin and Jefferson Davis` 的第三个位置，匹配的长度 Ben 是三个字符，长度是 3，如图 \@ref(fig:name-capture) 所示，需要注意的是一定要设置 `perl = TRUE` 才能使用命名捕捉功能，函数 `sub` 不支持命名反向引用 Named backreferences

\begin{figure}

{\centering \includegraphics[width=4.51in]{screenshots/regexp-name-capture} 

}

\caption{命名捕捉}(\#fig:name-capture)
\end{figure}

Atomic grouping 原子分组, possessive qualifiers 占有限定 and conditional 条件 and recursive 递归等模式超出介绍的范围，不在此处详述，感兴趣的读者可参考，此外，插播一条漫画 \@ref(fig:regex-xkcd)

[^char-byte]: `useBytes = TRUE` 表示把字符看作字节。字符、字节和比特的关系是，一个字节 byte 八个比特 bit，一个英文字符 character 用一个字节表示，而一个中、日、韩文字符需要两个字节表示 
[^learn-regex]: 推荐的学习正则表达式的路径可以见统计之都论坛 <https://d.cosx.org/d/420410>

\begin{figure}

{\centering \href{https://imgs.xkcd.com/comics/regular_expressions.png}{\includegraphics[width=2in]{screenshots/regexp-comics} }

}

\caption{正则表达式漫画}(\#fig:regex-xkcd)
\end{figure}

正则表达式的直观解释 <https://github.com/gadenbuie/regexplain>

[regex-xkcd]: https://xkcd.com/208/

## 表达式注释 {#comment}

The sequence `(?#` marks the start of a comment which continues up to the next closing parenthesis. Nested parentheses are not permitted. The characters that make up a comment play no part at all in the pattern matching.

If the extended option is set, an unescaped `#` character outside a character class introduces a comment that continues up to the next newline character in the pattern.


批量转换驼峰式命名


```r
old_name <- list.files(".", pattern = "^[A-Z].*.Rmd$")
new_name <- gsub("rmd", "Rmd", tolower(old_name))
file.rename(from = old_name, to = new_name)
```


```r
html_lines <- readLines("https://movie.douban.com/top250")
doc <- paste0(html_lines, collapse = "")

title_lines <- grep('class="title"', html_lines, value = T)
titles <- gsub(".*>(.*?)<.*", "\\1", title_lines, perl = T)

gsub(".*>(.*?)<.*", "\\1", '<span class="title">肖生克的救赎</span>', perl = T)
```

解析术之 XPath


```r
library(xml2)
dom = read_html(doc)
title_nodes = xml_find_all(dom, './/span[@class="title"]')
xml_text(title_nodes)
```

解析术之 CSS Selector


```r
library(rvest)
read_html(doc) %>%
html_nodes('.title') %>% # class="title"的标签
html_text()
```

