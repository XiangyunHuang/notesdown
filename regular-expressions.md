# 正则表达式 {#chap:regular-expressions}




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

