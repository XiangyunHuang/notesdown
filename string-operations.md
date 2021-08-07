# 字符串操作 {#chap-string-operations}

[stringdist](https://github.com/markvanderloo/stringdist)
[stringfish](https://github.com/traversc/stringfish)
[stringb](https://github.com/hadley/stringb)
[stringi](https://github.com/gagolews/stringi)
[stringr](https://github.com/tidyverse/stringr)


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


## 字符串加密 {#sec-encode-string}

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