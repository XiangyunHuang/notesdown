# 高级数据操作 {#chap-advanced-manipulation}


```r
library(data.table)
library(magrittr)
```

介绍 data.table 处理数据的方式，对标 dplyr 的基本操作

## 基础介绍 {#intro}


```r
# 用一个真实的数据集替换，让每一个操作都有实际含义和价值 mtcars
DT <- data.table(
  x = rep(c("b", "a", "c"), each = 3),
  v = c(1, 1, 1, 2, 2, 1, 1, 2, 2),
  y = c(1, 3, 6), a = 1:9, b = 9:1
)
DT
```

```
##    x v y a b
## 1: b 1 1 1 9
## 2: b 1 3 2 8
## 3: b 1 6 3 7
## 4: a 2 1 4 6
## 5: a 2 3 5 5
## 6: a 1 6 6 4
## 7: c 1 1 7 3
## 8: c 2 3 8 2
## 9: c 2 6 9 1
```



```r
# 分组求和
DT[, sum(v), by = .(y %% 2)]
```

```
##    y V1
## 1: 1  9
## 2: 0  4
```



```r
DT[, sum(v), by = .(bool = y %% 2)]
```

```
##    bool V1
## 1:    1  9
## 2:    0  4
```

```r
DT[, .SD[2], by = x] # 每组第二行
```

```
##    x v y a b
## 1: b 1 3 2 8
## 2: a 2 3 5 5
## 3: c 2 3 8 2
```



```r
DT[, tail(.SD, 2), by = x] # 每组最后两行
```

```
##    x v y a b
## 1: b 1 3 2 8
## 2: b 1 6 3 7
## 3: a 2 3 5 5
## 4: a 1 6 6 4
## 5: c 2 3 8 2
## 6: c 2 6 9 1
```



```r
# 除了 x 列外，所有列都按 x 分组求和
DT[, lapply(.SD, sum), by = x] 
```

```
##    x v  y  a  b
## 1: b 3 10  6 24
## 2: a 5 10 15 15
## 3: c 5 10 24  6
```



```r
# 各个列都按 x 分组取最小
DT[, .SD[which.min(v)], by = x] # 分组嵌套查询
```

```
##    x v y a b
## 1: b 1 1 1 9
## 2: a 1 6 6 4
## 3: c 1 1 7 3
```



```r
DT[, list(MySum = sum(v), MyMin = min(v), MyMax = max(v)), by = .(x, y %% 2)] # 表达式嵌套
```

```
##    x y MySum MyMin MyMax
## 1: b 1     2     1     1
## 2: b 0     1     1     1
## 3: a 1     4     2     2
## 4: a 0     1     1     1
## 5: c 1     3     1     2
## 6: c 0     2     2     2
```

```r
DT[, .(a = .(a), b = .(b)), by = x] # 按 x 分组，将 a,b 两列的值列出来
```

```
##    x     a     b
## 1: b 1,2,3 9,8,7
## 2: a 4,5,6 6,5,4
## 3: c 7,8,9 3,2,1
```

```r
DT[, .(seq = min(a):max(b)), by = x] # 列操作不仅仅是聚合
```

```
##     x seq
##  1: b   1
##  2: b   2
##  3: b   3
##  4: b   4
##  5: b   5
##  6: b   6
##  7: b   7
##  8: b   8
##  9: b   9
## 10: a   4
## 11: a   5
## 12: a   6
## 13: c   7
## 14: c   6
## 15: c   5
## 16: c   4
## 17: c   3
```



```r
# 按 x 分组对 v 求和，然后过滤出和小于 20 的行
DT[, sum(v), by = x][V1 < 20] # 组合查询
```

```
##    x V1
## 1: b  3
## 2: a  5
## 3: c  5
```

```r
DT[, sum(v), by = x][order(-V1)] # 对结果排序
```

```
##    x V1
## 1: a  5
## 2: c  5
## 3: b  3
```

```r
DT[, c(.N, lapply(.SD, sum)), by = x] # 计算每一组的和，每一组的观测数
```

```
##    x N v  y  a  b
## 1: b 3 3 10  6 24
## 2: a 3 5 10 15 15
## 3: c 3 5 10 24  6
```



```r
# 两个复杂的操作，还没弄清楚这个技术存在的意义
DT[,
  {
    tmp <- mean(y)
    .(a = a - tmp, b = b - tmp)
  },
  by = x
] # anonymous lambda in 'j', j accepts any valid
```

```
##    x          a          b
## 1: b -2.3333333  5.6666667
## 2: b -1.3333333  4.6666667
## 3: b -0.3333333  3.6666667
## 4: a  0.6666667  2.6666667
## 5: a  1.6666667  1.6666667
## 6: a  2.6666667  0.6666667
## 7: c  3.6666667 -0.3333333
## 8: c  4.6666667 -1.3333333
## 9: c  5.6666667 -2.3333333
```

```r
# using rleid, get max(y) and min of all cols in .SDcols for each consecutive run of 'v'
DT[, c(.(y = max(y)), lapply(.SD, min)), by = rleid(v), .SDcols = v:b]
```

```
##    rleid y v y a b
## 1:     1 6 1 1 1 7
## 2:     2 3 2 1 4 5
## 3:     3 6 1 1 6 3
## 4:     4 6 2 3 8 1
```


### 过滤 {#subsec-filter-i}


```r
mtcars_df = as.data.table(mtcars)
```

过滤 cyl = 6 并且 gear = 4 的记录


```r
mtcars_df[cyl == 6 & gear == 4]
```

```
##     mpg cyl  disp  hp drat    wt  qsec vs am gear carb
## 1: 21.0   6 160.0 110 3.90 2.620 16.46  0  1    4    4
## 2: 21.0   6 160.0 110 3.90 2.875 17.02  0  1    4    4
## 3: 19.2   6 167.6 123 3.92 3.440 18.30  1  0    4    4
## 4: 17.8   6 167.6 123 3.92 3.440 18.90  1  0    4    4
```


过滤操作是针对数据框的行（记录）




```r
mtcars_df[cyl == 6 & gear == 4, .(mpg, disp)]
```

```
##     mpg  disp
## 1: 21.0 160.0
## 2: 21.0 160.0
## 3: 19.2 167.6
## 4: 17.8 167.6
```


```r
subset(x = mtcars_df, subset = cyl == 6 & gear == 4, select = c(mpg, disp))
```

```
##     mpg  disp
## 1: 21.0 160.0
## 2: 21.0 160.0
## 3: 19.2 167.6
## 4: 17.8 167.6
```

::: dplyr


```r
mtcars %>% 
  dplyr::filter(cyl == 6 & gear == 4)  %>% 
  dplyr::select(mpg, disp)
```

```
##                mpg  disp
## Mazda RX4     21.0 160.0
## Mazda RX4 Wag 21.0 160.0
## Merc 280      19.2 167.6
## Merc 280C     17.8 167.6
```

:::

### 变换 {#subsec-mutate-j}

根据已有的列生成新的列，或者修改已有的列，一次只能修改一列


```r
mtcars_df[, mean_mpg := mean(mpg)
          ][, mean_disp := mean(disp)]
mtcars_df[1:6, ]
```

```
##     mpg cyl disp  hp drat    wt  qsec vs am gear carb mean_mpg mean_disp
## 1: 21.0   6  160 110 3.90 2.620 16.46  0  1    4    4 20.09062  230.7219
## 2: 21.0   6  160 110 3.90 2.875 17.02  0  1    4    4 20.09062  230.7219
## 3: 22.8   4  108  93 3.85 2.320 18.61  1  1    4    1 20.09062  230.7219
## 4: 21.4   6  258 110 3.08 3.215 19.44  1  0    3    1 20.09062  230.7219
## 5: 18.7   8  360 175 3.15 3.440 17.02  0  0    3    2 20.09062  230.7219
## 6: 18.1   6  225 105 2.76 3.460 20.22  1  0    3    1 20.09062  230.7219
```



```r
mtcars_df[, .(mean_mpg = mean(mpg), mean_disp = mean(disp))]
```

```
##    mean_mpg mean_disp
## 1: 20.09062  230.7219
```



```r
# mtcars_df[, .(mean_mpg := mean(mpg), mean_disp := mean(disp))] # 报错
# 正确的姿势
mtcars_df[, `:=`(mean_mpg = mean(mpg), mean_disp = mean(disp))          
          ][, .(mpg, disp, mean_mpg, mean_disp)] %>% head()
```

```
##     mpg disp mean_mpg mean_disp
## 1: 21.0  160 20.09062  230.7219
## 2: 21.0  160 20.09062  230.7219
## 3: 22.8  108 20.09062  230.7219
## 4: 21.4  258 20.09062  230.7219
## 5: 18.7  360 20.09062  230.7219
## 6: 18.1  225 20.09062  230.7219
```



```r
mtcars %>% 
  dplyr::summarise(mean_mpg = mean(mpg), mean_disp = mean(disp))
```

```
##   mean_mpg mean_disp
## 1 20.09062  230.7219
```



```r
mtcars %>% 
  dplyr::mutate(mean_mpg = mean(mpg), mean_disp = mean(disp)) %>% 
  dplyr::select(mpg, disp, mean_mpg, mean_disp) %>% head()
```

```
##                    mpg disp mean_mpg mean_disp
## Mazda RX4         21.0  160 20.09062  230.7219
## Mazda RX4 Wag     21.0  160 20.09062  230.7219
## Datsun 710        22.8  108 20.09062  230.7219
## Hornet 4 Drive    21.4  258 20.09062  230.7219
## Hornet Sportabout 18.7  360 20.09062  230.7219
## Valiant           18.1  225 20.09062  230.7219
```




### 聚合 {#subsec-summarise-j}

分组统计 多个分组变量



```r
dcast(mtcars_df, cyl ~ gear, value.var = "mpg", fun = mean)
```

```
##    cyl     3      4    5
## 1:   4 21.50 26.925 28.2
## 2:   6 19.75 19.750 19.7
## 3:   8 15.05    NaN 15.4
```

```r
tapply(mtcars$mpg, list(mtcars$cyl, mtcars$gear), mean)
```

```
##       3      4    5
## 4 21.50 26.925 28.2
## 6 19.75 19.750 19.7
## 8 15.05     NA 15.4
```

```r
mtcars_df[, .(mean_mpg = mean(mpg)), by = .(cyl, gear)]
```

```
##    cyl gear mean_mpg
## 1:   6    4   19.750
## 2:   4    4   26.925
## 3:   6    3   19.750
## 4:   8    3   15.050
## 5:   4    3   21.500
## 6:   4    5   28.200
## 7:   8    5   15.400
## 8:   6    5   19.700
```

```r
aggregate(data = mtcars_df, mpg ~ cyl + gear, FUN = mean)
```

```
##   cyl gear    mpg
## 1   4    3 21.500
## 2   6    3 19.750
## 3   8    3 15.050
## 4   4    4 26.925
## 5   6    4 19.750
## 6   4    5 28.200
## 7   6    5 19.700
## 8   8    5 15.400
```




```r
mtcars %>% 
  dplyr::group_by(cyl, gear) %>% 
  dplyr::summarise(mean_mpg = mean(mpg))
```

```
## # A tibble: 8 x 3
## # Groups:   cyl [3]
##     cyl  gear mean_mpg
##   <dbl> <dbl>    <dbl>
## 1     4     3     21.5
## 2     4     4     26.9
## 3     4     5     28.2
## 4     6     3     19.8
## 5     6     4     19.8
## 6     6     5     19.7
## 7     8     3     15.0
## 8     8     5     15.4
```



### 命名 {#subsec-setname}

修改列名，另存一份生效


```r
sub_mtcars_df <- mtcars_df[, .(mean_mpg = mean(mpg)), by = .(cyl, gear)] 
setNames(sub_mtcars_df, c("cyl", "gear", "ave_mpg"))
```

```
##    cyl gear ave_mpg
## 1:   6    4  19.750
## 2:   4    4  26.925
## 3:   6    3  19.750
## 4:   8    3  15.050
## 5:   4    3  21.500
## 6:   4    5  28.200
## 7:   8    5  15.400
## 8:   6    5  19.700
```

```r
# 注意 sub_mtcars_df 并没有修改列名
sub_mtcars_df
```

```
##    cyl gear mean_mpg
## 1:   6    4   19.750
## 2:   4    4   26.925
## 3:   6    3   19.750
## 4:   8    3   15.050
## 5:   4    3   21.500
## 6:   4    5   28.200
## 7:   8    5   15.400
## 8:   6    5   19.700
```

修改列名并直接起作用，在原来的数据集上生效


```r
setnames(sub_mtcars_df, old = c("mean_mpg"), new = c("ave_mpg"))
# sub_mtcars_df 已经修改了列名
sub_mtcars_df
```

```
##    cyl gear ave_mpg
## 1:   6    4  19.750
## 2:   4    4  26.925
## 3:   6    3  19.750
## 4:   8    3  15.050
## 5:   4    3  21.500
## 6:   4    5  28.200
## 7:   8    5  15.400
## 8:   6    5  19.700
```


修改列名最好使用 **data.table** 包的函数 `setnames()` 明确指出了要修改的列名，


### 排序 {#subsec-order-by-j}

按照某（些）列从大到小或从小到大的顺序排列， 先按 cyl 升序，然后按 gear 降序


```r
mtcars_df[, .(mpg, cyl, gear)          
          ][cyl == 4            
            ][order(cyl, -gear)]
```

```
##      mpg cyl gear
##  1: 26.0   4    5
##  2: 30.4   4    5
##  3: 22.8   4    4
##  4: 24.4   4    4
##  5: 22.8   4    4
##  6: 32.4   4    4
##  7: 30.4   4    4
##  8: 33.9   4    4
##  9: 27.3   4    4
## 10: 21.4   4    4
## 11: 21.5   4    3
```





```r
mtcars %>%
  dplyr::select(mpg, cyl, gear) %>%
  dplyr::filter(cyl == 4) %>%
  dplyr::arrange(cyl, desc(gear))
```

```
##                 mpg cyl gear
## Porsche 914-2  26.0   4    5
## Lotus Europa   30.4   4    5
## Datsun 710     22.8   4    4
## Merc 240D      24.4   4    4
## Merc 230       22.8   4    4
## Fiat 128       32.4   4    4
## Honda Civic    30.4   4    4
## Toyota Corolla 33.9   4    4
## Fiat X1-9      27.3   4    4
## Volvo 142E     21.4   4    4
## Toyota Corona  21.5   4    3
```




### 变形 {#subsec-reshape}

melt 宽的变长的


```r
DT <- data.table(
  i_1 = c(1:5, NA),
  i_2 = c(NA, 6, 7, 8, 9, 10),
  f_1 = factor(sample(c(letters[1:3], NA), 6, TRUE)),
  f_2 = factor(c("z", "a", "x", "c", "x", "x"), ordered = TRUE),
  c_1 = sample(c(letters[1:3], NA), 6, TRUE),
  d_1 = as.Date(c(1:3, NA, 4:5), origin = "2013-09-01"),
  d_2 = as.Date(6:1, origin = "2012-01-01")
)
```



```r
DT[, .(i_1, i_2, f_1, f_2)]
```

```
##    i_1 i_2  f_1 f_2
## 1:   1  NA    c   z
## 2:   2   6 <NA>   a
## 3:   3   7    a   x
## 4:   4   8    c   c
## 5:   5   9 <NA>   x
## 6:  NA  10    b   x
```



```r
melt(DT, id = 1:2, measure = c("f_1", "f_2"))
```

```
##     i_1 i_2 variable value
##  1:   1  NA      f_1     c
##  2:   2   6      f_1  <NA>
##  3:   3   7      f_1     a
##  4:   4   8      f_1     c
##  5:   5   9      f_1  <NA>
##  6:  NA  10      f_1     b
##  7:   1  NA      f_2     z
##  8:   2   6      f_2     a
##  9:   3   7      f_2     x
## 10:   4   8      f_2     c
## 11:   5   9      f_2     x
## 12:  NA  10      f_2     x
```

dcast 长的变宽的


```r
sleep <- as.data.table(sleep)
dcast(sleep, group ~ ID, value.var = "extra")
```

```
##    group   1    2    3    4    5   6   7   8   9  10
## 1:     1 0.7 -1.6 -0.2 -1.2 -0.1 3.4 3.7 0.8 0.0 2.0
## 2:     2 1.9  0.8  1.1  0.1 -0.1 4.4 5.5 1.6 4.6 3.4
```

```r
# 如果有多个值
dcast(mtcars_df, cyl ~ gear, value.var = "mpg")
```

```
##    cyl  3 4 5
## 1:   4  1 8 2
## 2:   6  2 4 1
## 3:   8 12 0 2
```

```r
dcast(mtcars_df, cyl ~ gear, value.var = "mpg", fun = mean)
```

```
##    cyl     3      4    5
## 1:   4 21.50 26.925 28.2
## 2:   6 19.75 19.750 19.7
## 3:   8 15.05    NaN 15.4
```

::: sidebar
tidyr 包提供数据变形的函数 `tidyr::pivot_longer()` 和 `tidyr::pivot_wider()` 相比于 Base R 提供的 `reshape()` 和 data.table 提供的 `melt()` 和 `dcast()` 更加形象的命名


```r
tidyr::pivot_wider(data = sleep, names_from = "ID", values_from = "extra")
```

```
## # A tibble: 2 x 11
##   group   `1`   `2`   `3`   `4`   `5`   `6`   `7`   `8`   `9`  `10`
##   <fct> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl>
## 1 1       0.7  -1.6  -0.2  -1.2  -0.1   3.4   3.7   0.8   0     2  
## 2 2       1.9   0.8   1.1   0.1  -0.1   4.4   5.5   1.6   4.6   3.4
```

```r
reshape(data = sleep, v.names = "extra", idvar = "group", timevar = "ID", direction = "wide")
```

```
##    group extra.1 extra.2 extra.3 extra.4 extra.5 extra.6 extra.7 extra.8
## 1:     1     0.7    -1.6    -0.2    -1.2    -0.1     3.4     3.7     0.8
## 2:     2     1.9     0.8     1.1     0.1    -0.1     4.4     5.5     1.6
##    extra.9 extra.10
## 1:     0.0      2.0
## 2:     4.6      3.4
```

- `idvar` 分组变量
- `timevar` 组内编号
- `v.names` 个体观察值

::: {.rmdnote data-latex="{注意}"}
`sep` 新的列名是由参数 `v.names` (extra) 和参数值 `timevar` (ID) 拼接起来的，默认 `sep = "."` 推荐使用下划线来做分割 `sep = "_"`
:::


```r
ToothGrowth %>% head
```

```
##    len supp dose
## 1  4.2   VC  0.5
## 2 11.5   VC  0.5
## 3  7.3   VC  0.5
## 4  5.8   VC  0.5
## 5  6.4   VC  0.5
## 6 10.0   VC  0.5
```

```r
ToothGrowth$time <- rep(1:10, 6)
reshape(ToothGrowth, v.names = "len", idvar = c("supp", "dose"),
        timevar = "time", direction = "wide")
```

```
##    supp dose len.1 len.2 len.3 len.4 len.5 len.6 len.7 len.8 len.9 len.10
## 1    VC  0.5   4.2  11.5   7.3   5.8   6.4  10.0  11.2  11.2   5.2    7.0
## 11   VC  1.0  16.5  16.5  15.2  17.3  22.5  17.3  13.6  14.5  18.8   15.5
## 21   VC  2.0  23.6  18.5  33.9  25.5  26.4  32.5  26.7  21.5  23.3   29.5
## 31   OJ  0.5  15.2  21.5  17.6   9.7  14.5  10.0   8.2   9.4  16.5    9.7
## 41   OJ  1.0  19.7  23.3  23.6  26.4  20.0  25.2  25.8  21.2  14.5   27.3
## 51   OJ  2.0  25.5  26.4  22.4  24.5  24.8  30.9  26.4  27.3  29.4   23.0
```
:::

以数据集 ToothGrowth 为例，变量 supp（大组），dose（小组） 和 time（组内个体编号） 一起决定唯一的一个数据 len，特别适合纵向数据的变形操作



### 分组 {#subsec-group-by}

分组切片，取每组第一个和最后一个值


```r
Loblolly %>% 
  dplyr::group_by(Seed) %>% 
  dplyr::arrange(height, age, Seed) %>% 
  dplyr::slice(1, dplyr::n())
```

```
## # A tibble: 28 x 3
## # Groups:   Seed [14]
##    height   age Seed 
##     <dbl> <dbl> <ord>
##  1   3.93     3 329  
##  2  56.4     25 329  
##  3   4.12     3 327  
##  4  56.8     25 327  
##  5   4.38     3 325  
##  6  58.5     25 325  
##  7   3.91     3 307  
##  8  59.1     25 307  
##  9   3.46     3 331  
## 10  59.5     25 331  
## # ... with 18 more rows
```

`dplyr::slice()` 和函数 `slice.index()` 有关系吗？

### 合并 {#subsec-merge}

合并操作对应于数据库中的连接操作， dplyr 包的哲学就来源于对数据库操作的进一步抽象， data.table 包的 merge 函数就对应为 dplyr 包的 join 函数

`data.table::merge` 和 `dplyr::join`

给出一个表格，数据操作， data.table 实现， dplyr 实现


```r
dt1 <- data.table(A = letters[1:10], X = 1:10, key = "A")
dt2 <- data.table(A = letters[5:14], Y = 1:10, key = "A")
merge(dt1, dt2) # 内连接
```

```
##    A  X Y
## 1: e  5 1
## 2: f  6 2
## 3: g  7 3
## 4: h  8 4
## 5: i  9 5
## 6: j 10 6
```

参数 key 的作用相当于建立一个索引，通过它实现更快的数据操作速度

`key = c("x","y","z")` 或者 `key = "x,y,z"` 其中 x,y,z 是列名



```r
data(band_members, band_instruments, package = "dplyr")
band_members
```

```
## # A tibble: 3 x 2
##   name  band   
##   <chr> <chr>  
## 1 Mick  Stones 
## 2 John  Beatles
## 3 Paul  Beatles
```

```r
band_instruments
```

```
## # A tibble: 3 x 2
##   name  plays 
##   <chr> <chr> 
## 1 John  guitar
## 2 Paul  bass  
## 3 Keith guitar
```

```r
dplyr::inner_join(band_members, band_instruments)
```

```
## # A tibble: 2 x 3
##   name  band    plays 
##   <chr> <chr>   <chr> 
## 1 John  Beatles guitar
## 2 Paul  Beatles bass
```


list 列表里每个元素都是 data.frame 时，最适合用 `data.table::rbindlist` 合并


```r
# 合并列表 https://recology.info/2018/10/limiting-dependencies/
function(x) {
  tibble::as_tibble((x <- data.table::setDF(
    data.table::rbindlist(x, use.names = TRUE, fill = TRUE, idcol = "id"))
  ))
}
```

```
## function(x) {
##   tibble::as_tibble((x <- data.table::setDF(
##     data.table::rbindlist(x, use.names = TRUE, fill = TRUE, idcol = "id"))
##   ))
## }
```




## 高频操作 {#chap:data-manipulation}

以面向问题的方式介绍 Base R 提供的数据操作，然后过渡到 data.table，它是加强版的 Base R。

<!-- data.table 和 HiveSQL/HQL 的等价表示 -->

Table: (\#tab:single-table-verbs) 单表的操作

| base | dplyr      |
|------|------------|
|   `df[order(x), , drop = FALSE]`                     | `arrange(df, x)` |
|   `df[!duplicated(x), , drop = FALSE]`, `unique()`   | `distinct(df, x)`  |
|   `df[x & !is.na(x), , drop = FALSE]`, `subset()`    | `filter(df, x)`  |
|   `df$z <- df$x + df$y`, `transform()`               | `mutate(df, z = x + y)`  |
|   `df$x`    | `pull(df, x)`       |
|   N/A       | `rename(df, y = x)` |
|   `df[c("x", "y")]`, `subset()`  | `select(df, x, y)` |
|   `df[grepl(names(df), "^x")]`   | `select(df, starts_with("x")` |
|   `mean(df$x)` | `summarise(df, mean(x))` |
|   `df[c(1, 2, 5), , drop = FALSE]` | `slice(df, c(1, 2, 5))` |

Table: (\#tab:two-table-verbs) 两表的操作

| base | dplyr      |
|------|------------|
|   `merge(df1, df2)`                 | `inner_join(df1, df2)`  |
|   `merge(df1, df2, all.x = TRUE)`   | `left_join(df1, df2) `  |
|   `merge(df1, df2, all.y = TRUE)`   | `right_join(df1, df2)`  |
|   `merge(df1, df2, all = TRUE)`     | `full_join(df1, df2)`   |
|   `df1[df1$x %in% df2$x, , drop = FALSE]`    | `semi_join(df1, df2)` |
|   `df1[!df1$x %in% df2$x, , drop = FALSE]`   | `anti_join(df1, df2)` |



```r
library(magrittr)
class(mtcars)
```

```
## [1] "data.frame"
```

```r
library(data.table)
mtcars <- as.data.table(mtcars)
class(mtcars)
```

```
## [1] "data.table" "data.frame"
```

### 选择多列 {#sec-select}


```r
# base
mtcars[, c("cyl", "gear")] %>% head(3)
```

```
##    cyl gear
## 1:   6    4
## 2:   6    4
## 3:   4    4
```

```r
# data.table
mtcars[, c("cyl", "gear")] %>% head(3)
```

```
##    cyl gear
## 1:   6    4
## 2:   6    4
## 3:   4    4
```

```r
# dplyr
dplyr::select(mtcars, cyl, gear) %>% head(3)
```

```
##    cyl gear
## 1:   6    4
## 2:   6    4
## 3:   4    4
```

反选多列，选择除了 cyl 和 gear 的列


```r
## 或者 mtcars[, setdiff(names(mtcars), c("cyl", "gear"))]
mtcars[ , !(names(mtcars) %in% c("cyl","gear"))]  %>% head(3) 
```

```
## [1]  TRUE FALSE  TRUE
```

```r
subset(mtcars, select = -c(cyl, gear)) %>% head(3)
```

```
##     mpg disp  hp drat    wt  qsec vs am carb
## 1: 21.0  160 110 3.90 2.620 16.46  0  1    4
## 2: 21.0  160 110 3.90 2.875 17.02  0  1    4
## 3: 22.8  108  93 3.85 2.320 18.61  1  1    1
```


### 过滤多行 {#sec-filter}


```r
# base
mtcars[mtcars$cyl == 6 & mtcars$gear == 4,]
```

```
##     mpg cyl  disp  hp drat    wt  qsec vs am gear carb
## 1: 21.0   6 160.0 110 3.90 2.620 16.46  0  1    4    4
## 2: 21.0   6 160.0 110 3.90 2.875 17.02  0  1    4    4
## 3: 19.2   6 167.6 123 3.92 3.440 18.30  1  0    4    4
## 4: 17.8   6 167.6 123 3.92 3.440 18.90  1  0    4    4
```

```r
subset(mtcars, subset = cyl == 6 & gear == 4)
```

```
##     mpg cyl  disp  hp drat    wt  qsec vs am gear carb
## 1: 21.0   6 160.0 110 3.90 2.620 16.46  0  1    4    4
## 2: 21.0   6 160.0 110 3.90 2.875 17.02  0  1    4    4
## 3: 19.2   6 167.6 123 3.92 3.440 18.30  1  0    4    4
## 4: 17.8   6 167.6 123 3.92 3.440 18.90  1  0    4    4
```

```r
# data.table
mtcars[cyl == 6 & gear == 4,]
```

```
##     mpg cyl  disp  hp drat    wt  qsec vs am gear carb
## 1: 21.0   6 160.0 110 3.90 2.620 16.46  0  1    4    4
## 2: 21.0   6 160.0 110 3.90 2.875 17.02  0  1    4    4
## 3: 19.2   6 167.6 123 3.92 3.440 18.30  1  0    4    4
## 4: 17.8   6 167.6 123 3.92 3.440 18.90  1  0    4    4
```

```r
# dplyr
dplyr::filter(mtcars, cyl == 6 & gear == 4)
```

```
##     mpg cyl  disp  hp drat    wt  qsec vs am gear carb
## 1: 21.0   6 160.0 110 3.90 2.620 16.46  0  1    4    4
## 2: 21.0   6 160.0 110 3.90 2.875 17.02  0  1    4    4
## 3: 19.2   6 167.6 123 3.92 3.440 18.30  1  0    4    4
## 4: 17.8   6 167.6 123 3.92 3.440 18.90  1  0    4    4
```


### 去重多行 {#sec-duplicated}


```r
# base
mtcars[!duplicated(mtcars[, c("cyl", "gear")])]
```

```
##     mpg cyl  disp  hp drat    wt  qsec vs am gear carb
## 1: 21.0   6 160.0 110 3.90 2.620 16.46  0  1    4    4
## 2: 22.8   4 108.0  93 3.85 2.320 18.61  1  1    4    1
## 3: 21.4   6 258.0 110 3.08 3.215 19.44  1  0    3    1
## 4: 18.7   8 360.0 175 3.15 3.440 17.02  0  0    3    2
## 5: 21.5   4 120.1  97 3.70 2.465 20.01  1  0    3    1
## 6: 26.0   4 120.3  91 4.43 2.140 16.70  0  1    5    2
## 7: 15.8   8 351.0 264 4.22 3.170 14.50  0  1    5    4
## 8: 19.7   6 145.0 175 3.62 2.770 15.50  0  1    5    6
```

```r
# data.table
mtcars[!duplicated(mtcars, by = c("cyl", "gear")), ]
```

```
##     mpg cyl  disp  hp drat    wt  qsec vs am gear carb
## 1: 21.0   6 160.0 110 3.90 2.620 16.46  0  1    4    4
## 2: 22.8   4 108.0  93 3.85 2.320 18.61  1  1    4    1
## 3: 21.4   6 258.0 110 3.08 3.215 19.44  1  0    3    1
## 4: 18.7   8 360.0 175 3.15 3.440 17.02  0  0    3    2
## 5: 21.5   4 120.1  97 3.70 2.465 20.01  1  0    3    1
## 6: 26.0   4 120.3  91 4.43 2.140 16.70  0  1    5    2
## 7: 15.8   8 351.0 264 4.22 3.170 14.50  0  1    5    4
## 8: 19.7   6 145.0 175 3.62 2.770 15.50  0  1    5    6
```

```r
unique(mtcars, by = c("cyl", "gear"))
```

```
##     mpg cyl  disp  hp drat    wt  qsec vs am gear carb
## 1: 21.0   6 160.0 110 3.90 2.620 16.46  0  1    4    4
## 2: 22.8   4 108.0  93 3.85 2.320 18.61  1  1    4    1
## 3: 21.4   6 258.0 110 3.08 3.215 19.44  1  0    3    1
## 4: 18.7   8 360.0 175 3.15 3.440 17.02  0  0    3    2
## 5: 21.5   4 120.1  97 3.70 2.465 20.01  1  0    3    1
## 6: 26.0   4 120.3  91 4.43 2.140 16.70  0  1    5    2
## 7: 15.8   8 351.0 264 4.22 3.170 14.50  0  1    5    4
## 8: 19.7   6 145.0 175 3.62 2.770 15.50  0  1    5    6
```

```r
# dplyr
dplyr::distinct(mtcars, cyl, gear, .keep_all = TRUE)
```

```
##     mpg cyl  disp  hp drat    wt  qsec vs am gear carb
## 1: 21.0   6 160.0 110 3.90 2.620 16.46  0  1    4    4
## 2: 22.8   4 108.0  93 3.85 2.320 18.61  1  1    4    1
## 3: 21.4   6 258.0 110 3.08 3.215 19.44  1  0    3    1
## 4: 18.7   8 360.0 175 3.15 3.440 17.02  0  0    3    2
## 5: 21.5   4 120.1  97 3.70 2.465 20.01  1  0    3    1
## 6: 26.0   4 120.3  91 4.43 2.140 16.70  0  1    5    2
## 7: 15.8   8 351.0 264 4.22 3.170 14.50  0  1    5    4
## 8: 19.7   6 145.0 175 3.62 2.770 15.50  0  1    5    6
```

### 合并操作 {#sec-merge}

在数据库的操作中，合并又称为连接


#### 左合并 {#subsec-left-join}



```r
# dplyr::inner_join()
# dplyr::left_join()
# dplyr::right_join()
# dplyr::full_join()
```

#### 右合并 {#subsec-right-join}





### 新添多列 {#sec-add-columns}


```r
mtcars[cyl == 6, `:=`(disp_mean = mean(disp), hp_mean = mean(hp))][cyl == 6, .(cyl, disp, hp, disp_mean, hp_mean)]
```

```
##    cyl  disp  hp disp_mean  hp_mean
## 1:   6 160.0 110  183.3143 122.2857
## 2:   6 160.0 110  183.3143 122.2857
## 3:   6 258.0 110  183.3143 122.2857
## 4:   6 225.0 105  183.3143 122.2857
## 5:   6 167.6 123  183.3143 122.2857
## 6:   6 167.6 123  183.3143 122.2857
## 7:   6 145.0 175  183.3143 122.2857
```

### 删除多列 {#sec-delete-columns}

删除列就是将该列的值清空，置为 NULL，下面将新添的两个列删除，根据列名的特点用正则表达式匹配


```r
mtcars[, colnames(mtcars)[grep('_mean$', colnames(mtcars))] := NULL]
```

### 修改多列类型 {#sec-modify-columns-type}


```r
mtcars[, (c("cyl", "disp")) := lapply(.SD, as.integer), .SDcols = c("cyl", "disp")]
str(mtcars)
```

```
## Classes 'data.table' and 'data.frame':	32 obs. of  11 variables:
##  $ mpg : num  21 21 22.8 21.4 18.7 18.1 14.3 24.4 22.8 19.2 ...
##  $ cyl : int  6 6 4 6 8 6 8 4 4 6 ...
##  $ disp: int  160 160 108 258 360 225 360 146 140 167 ...
##  $ hp  : num  110 110 93 110 175 105 245 62 95 123 ...
##  $ drat: num  3.9 3.9 3.85 3.08 3.15 2.76 3.21 3.69 3.92 3.92 ...
##  $ wt  : num  2.62 2.88 2.32 3.21 3.44 ...
##  $ qsec: num  16.5 17 18.6 19.4 17 ...
##  $ vs  : num  0 0 1 1 0 1 0 1 1 1 ...
##  $ am  : num  1 1 1 0 0 0 0 0 0 0 ...
##  $ gear: num  4 4 4 3 3 3 3 4 4 4 ...
##  $ carb: num  4 4 1 1 2 1 4 2 2 4 ...
##  - attr(*, ".internal.selfref")=<externalptr> 
##  - attr(*, "index")= int(0)
```

### 取每组第一行 {#sec-select-first-row}

先将 mtcars 按 cyl 升序，gear 降序排列，然后按 cyl, gear 和 am 分组取第一行


```r
mtcars[order(cyl, - gear)][, head(.SD, 1), by = list(cyl, gear, am)]
```

```
##     cyl gear am  mpg disp  hp drat    wt  qsec vs carb
##  1:   4    5  1 26.0  120  91 4.43 2.140 16.70  0    2
##  2:   4    4  1 22.8  108  93 3.85 2.320 18.61  1    1
##  3:   4    4  0 24.4  146  62 3.69 3.190 20.00  1    2
##  4:   4    3  0 21.5  120  97 3.70 2.465 20.01  1    1
##  5:   6    5  1 19.7  145 175 3.62 2.770 15.50  0    6
##  6:   6    4  1 21.0  160 110 3.90 2.620 16.46  0    4
##  7:   6    4  0 19.2  167 123 3.92 3.440 18.30  1    4
##  8:   6    3  0 21.4  258 110 3.08 3.215 19.44  1    1
##  9:   8    5  1 15.8  351 264 4.22 3.170 14.50  0    4
## 10:   8    3  0 18.7  360 175 3.15 3.440 17.02  0    2
```

```r
# 或者
mtcars[order(cyl, - gear)][, .SD[1], by = list(cyl, gear, am)]
```

```
##     cyl gear am  mpg disp  hp drat    wt  qsec vs carb
##  1:   4    5  1 26.0  120  91 4.43 2.140 16.70  0    2
##  2:   4    4  1 22.8  108  93 3.85 2.320 18.61  1    1
##  3:   4    4  0 24.4  146  62 3.69 3.190 20.00  1    2
##  4:   4    3  0 21.5  120  97 3.70 2.465 20.01  1    1
##  5:   6    5  1 19.7  145 175 3.62 2.770 15.50  0    6
##  6:   6    4  1 21.0  160 110 3.90 2.620 16.46  0    4
##  7:   6    4  0 19.2  167 123 3.92 3.440 18.30  1    4
##  8:   6    3  0 21.4  258 110 3.08 3.215 19.44  1    1
##  9:   8    5  1 15.8  351 264 4.22 3.170 14.50  0    4
## 10:   8    3  0 18.7  360 175 3.15 3.440 17.02  0    2
```


### 计算环比同比 {#subsec-mom-vs-yoy}

以数据集 AirPassengers 为例，重新整理后见表 \@ref(tab:air-passengers)


```r
library(magrittr)
dat <- data.frame(
  year = rep(1949:1960, each = 12),
  month = month.abb, num = AirPassengers
) %>%
  reshape(.,
    v.names = "num", idvar = "year", timevar = "month",
    direction = "wide", sep = ""
  ) %>%
  setNames(., gsub(pattern = "(num)", replacement = "", x = colnames(.)))

rownames(dat) <- subset(dat, select = year, drop = TRUE)
air_passengers <- subset(dat, select = -year)

knitr::kable(air_passengers,
    caption = "1949-1960年国际航班乘客数量变化",
    align = "c", row.names = TRUE
  )
```

\begin{table}

\caption{(\#tab:air-passengers)1949-1960年国际航班乘客数量变化}
\centering
\begin{tabular}[t]{l|c|c|c|c|c|c|c|c|c|c|c|c}
\hline
  & Jan & Feb & Mar & Apr & May & Jun & Jul & Aug & Sep & Oct & Nov & Dec\\
\hline
1949 & 112 & 118 & 132 & 129 & 121 & 135 & 148 & 148 & 136 & 119 & 104 & 118\\
\hline
1950 & 115 & 126 & 141 & 135 & 125 & 149 & 170 & 170 & 158 & 133 & 114 & 140\\
\hline
1951 & 145 & 150 & 178 & 163 & 172 & 178 & 199 & 199 & 184 & 162 & 146 & 166\\
\hline
1952 & 171 & 180 & 193 & 181 & 183 & 218 & 230 & 242 & 209 & 191 & 172 & 194\\
\hline
1953 & 196 & 196 & 236 & 235 & 229 & 243 & 264 & 272 & 237 & 211 & 180 & 201\\
\hline
1954 & 204 & 188 & 235 & 227 & 234 & 264 & 302 & 293 & 259 & 229 & 203 & 229\\
\hline
1955 & 242 & 233 & 267 & 269 & 270 & 315 & 364 & 347 & 312 & 274 & 237 & 278\\
\hline
1956 & 284 & 277 & 317 & 313 & 318 & 374 & 413 & 405 & 355 & 306 & 271 & 306\\
\hline
1957 & 315 & 301 & 356 & 348 & 355 & 422 & 465 & 467 & 404 & 347 & 305 & 336\\
\hline
1958 & 340 & 318 & 362 & 348 & 363 & 435 & 491 & 505 & 404 & 359 & 310 & 337\\
\hline
1959 & 360 & 342 & 406 & 396 & 420 & 472 & 548 & 559 & 463 & 407 & 362 & 405\\
\hline
1960 & 417 & 391 & 419 & 461 & 472 & 535 & 622 & 606 & 508 & 461 & 390 & 432\\
\hline
\end{tabular}
\end{table}

横向计算环比，如1949年2月相比1月增长多少、3月相比2月增长多少，以此类推，就是计算环比？纵向计算同比，如1950年1月相比1949年1月增长多少、1951年相比1950年1月增长多少？


```r
# 环比横向/同比纵向
mom <- function(x) diff(x, lag = 1)/x[-length(x)] # month to month
# 格式化输出
format_mom <- function(x) formatC(mom(x), format = "f", digits = 4)
```



```r
library(formattable)
# 同比变化
air_passengers %>%  
  apply(., 2, format_mom) %>% as.data.frame() %>%
  formattable(., list(
        Jan = color_tile("white", "pink"),
        Feb = color_tile("white", "springgreen4"),
        Mar = percent
      ))

library(DT)
datatable(air_passengers)
```

### 合并多个数据框 {#sec-merge-multi-dfs} 

将所有列都保留，以 `full_join()` 方式合并


```r
df1 <- iris[1:10, c(1, 5)]
df2 <- iris[11:15, c(1, 2, 5)]
df3 <- iris[16:30, c(1, 3, 5)]
all_dfs <- list(df1, df2, df3)
# base
Reduce(function(x, y, ...) merge(x, y, ..., all = TRUE), all_dfs)
```

```
##    Sepal.Length Species Sepal.Width Petal.Length
## 1           4.3  setosa         3.0           NA
## 2           4.4  setosa          NA           NA
## 3           4.6  setosa          NA          1.0
## 4           4.6  setosa          NA          1.0
## 5           4.7  setosa          NA          1.6
## 6           4.8  setosa         3.0          1.9
## 7           4.8  setosa         3.4          1.9
## 8           4.9  setosa          NA           NA
## 9           4.9  setosa          NA           NA
## 10          5.0  setosa          NA          1.6
## 11          5.0  setosa          NA          1.6
## 12          5.0  setosa          NA          1.6
## 13          5.0  setosa          NA          1.6
## 14          5.1  setosa          NA          1.5
## 15          5.1  setosa          NA          1.4
## 16          5.1  setosa          NA          1.7
## 17          5.1  setosa          NA          1.5
## 18          5.2  setosa          NA          1.4
## 19          5.2  setosa          NA          1.5
## 20          5.4  setosa         3.7          1.3
## 21          5.4  setosa         3.7          1.7
## 22          5.7  setosa          NA          1.5
## 23          5.7  setosa          NA          1.7
## 24          5.8  setosa         4.0           NA
```

```r
# dplyr
Reduce(function(x, y, ...) dplyr::full_join(x, y, ...), all_dfs)
```

```
##    Sepal.Length Species Sepal.Width Petal.Length
## 1           5.1  setosa          NA          1.4
## 2           5.1  setosa          NA          1.5
## 3           5.1  setosa          NA          1.5
## 4           5.1  setosa          NA          1.7
## 5           4.9  setosa          NA           NA
## 6           4.7  setosa          NA          1.6
## 7           4.6  setosa          NA          1.0
## 8           5.0  setosa          NA          1.6
## 9           5.0  setosa          NA          1.6
## 10          5.4  setosa         3.7          1.3
## 11          5.4  setosa         3.7          1.7
## 12          4.6  setosa          NA          1.0
## 13          5.0  setosa          NA          1.6
## 14          5.0  setosa          NA          1.6
## 15          4.4  setosa          NA           NA
## 16          4.9  setosa          NA           NA
## 17          4.8  setosa         3.4          1.9
## 18          4.8  setosa         3.0          1.9
## 19          4.3  setosa         3.0           NA
## 20          5.8  setosa         4.0           NA
## 21          5.7  setosa          NA          1.5
## 22          5.7  setosa          NA          1.7
## 23          5.2  setosa          NA          1.5
## 24          5.2  setosa          NA          1.4
```

合并完应该有30行，为啥只有24行？这是因为 `merge()` 函数对主键 key 相同的记录会合并，要想不合并，需要调用 `rbindlist()` 函数 <https://d.cosx.org/d/421235>


`rbind()` 列数相同的两个 data.frame 按行合并，`cbind()` 行数相同的两个 data.frame 按列合并，`merge()` 对行、列数没有要求



```r
rbindlist(all_dfs, fill = TRUE)
```

```
##     Sepal.Length Species Sepal.Width Petal.Length
##  1:          5.1  setosa          NA           NA
##  2:          4.9  setosa          NA           NA
##  3:          4.7  setosa          NA           NA
##  4:          4.6  setosa          NA           NA
##  5:          5.0  setosa          NA           NA
##  6:          5.4  setosa          NA           NA
##  7:          4.6  setosa          NA           NA
##  8:          5.0  setosa          NA           NA
##  9:          4.4  setosa          NA           NA
## 10:          4.9  setosa          NA           NA
## 11:          5.4  setosa         3.7           NA
## 12:          4.8  setosa         3.4           NA
## 13:          4.8  setosa         3.0           NA
## 14:          4.3  setosa         3.0           NA
## 15:          5.8  setosa         4.0           NA
## 16:          5.7  setosa          NA          1.5
## 17:          5.4  setosa          NA          1.3
## 18:          5.1  setosa          NA          1.4
## 19:          5.7  setosa          NA          1.7
## 20:          5.1  setosa          NA          1.5
## 21:          5.4  setosa          NA          1.7
## 22:          5.1  setosa          NA          1.5
## 23:          4.6  setosa          NA          1.0
## 24:          5.1  setosa          NA          1.7
## 25:          4.8  setosa          NA          1.9
## 26:          5.0  setosa          NA          1.6
## 27:          5.0  setosa          NA          1.6
## 28:          5.2  setosa          NA          1.5
## 29:          5.2  setosa          NA          1.4
## 30:          4.7  setosa          NA          1.6
##     Sepal.Length Species Sepal.Width Petal.Length
```

```r
# dplyr
dplyr::bind_rows(all_dfs)
```

```
##    Sepal.Length Species Sepal.Width Petal.Length
## 1           5.1  setosa          NA           NA
## 2           4.9  setosa          NA           NA
## 3           4.7  setosa          NA           NA
## 4           4.6  setosa          NA           NA
## 5           5.0  setosa          NA           NA
## 6           5.4  setosa          NA           NA
## 7           4.6  setosa          NA           NA
## 8           5.0  setosa          NA           NA
## 9           4.4  setosa          NA           NA
## 10          4.9  setosa          NA           NA
## 11          5.4  setosa         3.7           NA
## 12          4.8  setosa         3.4           NA
## 13          4.8  setosa         3.0           NA
## 14          4.3  setosa         3.0           NA
## 15          5.8  setosa         4.0           NA
## 16          5.7  setosa          NA          1.5
## 17          5.4  setosa          NA          1.3
## 18          5.1  setosa          NA          1.4
## 19          5.7  setosa          NA          1.7
## 20          5.1  setosa          NA          1.5
## 21          5.4  setosa          NA          1.7
## 22          5.1  setosa          NA          1.5
## 23          4.6  setosa          NA          1.0
## 24          5.1  setosa          NA          1.7
## 25          4.8  setosa          NA          1.9
## 26          5.0  setosa          NA          1.6
## 27          5.0  setosa          NA          1.6
## 28          5.2  setosa          NA          1.5
## 29          5.2  setosa          NA          1.4
## 30          4.7  setosa          NA          1.6
```

### 分组聚合多个指标 {#sec-multiple-aggregations}

<https://stackoverflow.com/questions/24151602/calculate-multiple-aggregations-with-lapply-sd>


```r
# base
aggregate(
  data = mtcars, cbind(mpg, hp) ~ cyl,
  FUN = function(x) c(mean = mean(x), median = median(x))
)
```

```
##   cyl mpg.mean mpg.median   hp.mean hp.median
## 1   4 26.66364   26.00000  82.63636  91.00000
## 2   6 19.74286   19.70000 122.28571 110.00000
## 3   8 15.10000   15.20000 209.21429 192.50000
```

```r
# 数据一致性 https://d.cosx.org/d/420763-base-r
with(
  aggregate(cbind(mpg, hp) ~ cyl, mtcars,
    FUN = function(x) c(mean = mean(x), median = median(x))
  ),
  cbind.data.frame(cyl, mpg, hp)
)
```

```
##   cyl     mean median      mean median
## 1   4 26.66364   26.0  82.63636   91.0
## 2   6 19.74286   19.7 122.28571  110.0
## 3   8 15.10000   15.2 209.21429  192.5
```

```r
# data.table
mtcars[, as.list(unlist(lapply(.SD, function(x) {
  list(
    mean = mean(x),
    median = median(x)
  )
}))),
by = "cyl", .SDcols = c("mpg", "hp")
]
```

```
##    cyl mpg.mean mpg.median   hp.mean hp.median
## 1:   6 19.74286       19.7 122.28571     110.0
## 2:   4 26.66364       26.0  82.63636      91.0
## 3:   8 15.10000       15.2 209.21429     192.5
```

```r
# dplyr
mtcars %>%
  dplyr::group_by(cyl) %>%
  dplyr::summarise(
    mean_mpg = mean(mpg), mean_hp = mean(hp),
    median_mpg = mean(mpg), median_hp = mean(hp)
  )
```

```
## # A tibble: 3 x 5
##     cyl mean_mpg mean_hp median_mpg median_hp
##   <int>    <dbl>   <dbl>      <dbl>     <dbl>
## 1     4     26.7    82.6       26.7      82.6
## 2     6     19.7   122.        19.7     122. 
## 3     8     15.1   209.        15.1     209.
```

### 重命名多个列 {#sec-rename-multi-cols}


```r
tmp <- aggregate(data = mtcars, cbind(mpg, hp) ~ cyl,
          FUN = median)
tmp <- as.data.table(tmp)
setnames(tmp, old = c("mpg", "hp"), new = c("median_mpg", "median_hp"))
tmp
```

```
##    cyl median_mpg median_hp
## 1:   4       26.0      91.0
## 2:   6       19.7     110.0
## 3:   8       15.2     192.5
```

### 对多个列依次排序 {#sec-sort-multi-cols}

<https://stackoverflow.com/questions/1296646/how-to-sort-a-dataframe-by-multiple-columns>


```r
# base
tmp[order(median_mpg, -median_hp), ]
```

```
##    cyl median_mpg median_hp
## 1:   8       15.2     192.5
## 2:   6       19.7     110.0
## 3:   4       26.0      91.0
```

```r
# data.table
setorder(tmp, median_mpg, -median_hp)
# dplyr
dplyr::arrange(tmp, median_mpg, desc(median_hp))
```

```
##    cyl median_mpg median_hp
## 1:   8       15.2     192.5
## 2:   6       19.7     110.0
## 3:   4       26.0      91.0
```

### 重排多个列的位置 {#sec-rearrange-position-multi-cols} 


```r
# https://stackoverflow.com/questions/19619666/change-column-position-of-data-table
setcolorder(tmp, c("median_mpg", setdiff(names(tmp), "median_mpg")))
tmp
```

```
##    median_mpg cyl median_hp
## 1:       15.2   8     192.5
## 2:       19.7   6     110.0
## 3:       26.0   4      91.0
```

```r
# dplyr
dplyr::select(tmp, "median_mpg", setdiff(names(tmp), "median_mpg"))
```

```
##    median_mpg cyl median_hp
## 1:       15.2   8     192.5
## 2:       19.7   6     110.0
## 3:       26.0   4      91.0
```

### 整理回归结果 {#sec-tidy-output}


```r
dat <- split(iris, iris$Species)
mod <- lapply(dat, function(x) lm(Petal.Length ~ Sepal.Length, x))
mod <- lapply(mod, function(x) coef(summary(x)))
mod <- Map(function(x, y) {x <- as.data.frame(x) ; x$Species = y; x}, mod, names(dat))
mod <- do.call(rbind, mod)
mod
```

```
##                          Estimate Std. Error    t value     Pr(>|t|)    Species
## setosa.(Intercept)      0.8030518 0.34387807  2.3352806 2.375647e-02     setosa
## setosa.Sepal.Length     0.1316317 0.06852690  1.9208760 6.069778e-02     setosa
## versicolor.(Intercept)  0.1851155 0.51421351  0.3599974 7.204283e-01 versicolor
## versicolor.Sepal.Length 0.6864698 0.08630708  7.9538056 2.586190e-10 versicolor
## virginica.(Intercept)   0.6104680 0.41710685  1.4635770 1.498279e-01  virginica
## virginica.Sepal.Length  0.7500808 0.06302606 11.9011203 6.297786e-16  virginica
```

```r
# 管道操作
split(iris, iris$Species) %>%
  lapply(., function(x) coef(summary(lm(Petal.Length ~ Sepal.Length, x)))) %>%
  Map(function(x, y) {
    x <- as.data.frame(x)
    x$Species <- y
    x
  }, ., levels(iris$Species)) %>%
  do.call(rbind, .)
```

```
##                          Estimate Std. Error    t value     Pr(>|t|)    Species
## setosa.(Intercept)      0.8030518 0.34387807  2.3352806 2.375647e-02     setosa
## setosa.Sepal.Length     0.1316317 0.06852690  1.9208760 6.069778e-02     setosa
## versicolor.(Intercept)  0.1851155 0.51421351  0.3599974 7.204283e-01 versicolor
## versicolor.Sepal.Length 0.6864698 0.08630708  7.9538056 2.586190e-10 versicolor
## virginica.(Intercept)   0.6104680 0.41710685  1.4635770 1.498279e-01  virginica
## virginica.Sepal.Length  0.7500808 0.06302606 11.9011203 6.297786e-16  virginica
```

```r
# dplyr 操作，需要 dplyr >= 1.0.0 或者开发版
iris %>% 
  dplyr::group_by(Species) %>% 
  dplyr::summarise(broom::tidy(lm(Petal.Length ~ Sepal.Length)))
```

```
## # A tibble: 6 x 6
## # Groups:   Species [3]
##   Species    term         estimate std.error statistic  p.value
##   <fct>      <chr>           <dbl>     <dbl>     <dbl>    <dbl>
## 1 setosa     (Intercept)     0.803    0.344      2.34  2.38e- 2
## 2 setosa     Sepal.Length    0.132    0.0685     1.92  6.07e- 2
## 3 versicolor (Intercept)     0.185    0.514      0.360 7.20e- 1
## 4 versicolor Sepal.Length    0.686    0.0863     7.95  2.59e-10
## 5 virginica  (Intercept)     0.610    0.417      1.46  1.50e- 1
## 6 virginica  Sepal.Length    0.750    0.0630    11.9   6.30e-16
```

### `:=` 和 `.()` {#sec-assignment-by-reference}


```r
mtcars[, mpg_rate := round(mpg/sum(mpg) * 100, digits = 2), by = .(cyl, vs, am)]
mtcars[, .(mpg_rate, mpg, cyl, vs, am)]
```

```
##     mpg_rate  mpg cyl vs am
##  1:    34.04 21.0   6  0  1
##  2:    34.04 21.0   6  0  1
##  3:    11.48 22.8   4  1  1
##  4:    27.97 21.4   6  1  0
##  5:    10.35 18.7   8  0  0
##  6:    23.66 18.1   6  1  0
##  7:     7.92 14.3   8  0  0
##  8:    35.52 24.4   4  1  0
##  9:    33.19 22.8   4  1  0
## 10:    25.10 19.2   6  1  0
## 11:    23.27 17.8   6  1  0
## 12:     9.08 16.4   8  0  0
## 13:     9.58 17.3   8  0  0
## 14:     8.42 15.2   8  0  0
## 15:     5.76 10.4   8  0  0
## 16:     5.76 10.4   8  0  0
## 17:     8.14 14.7   8  0  0
## 18:    16.31 32.4   4  1  1
## 19:    15.31 30.4   4  1  1
## 20:    17.07 33.9   4  1  1
## 21:    31.30 21.5   4  1  0
## 22:     8.58 15.5   8  0  0
## 23:     8.42 15.2   8  0  0
## 24:     7.36 13.3   8  0  0
## 25:    10.63 19.2   8  0  0
## 26:    13.75 27.3   4  1  1
## 27:   100.00 26.0   4  0  1
## 28:    15.31 30.4   4  1  1
## 29:    51.30 15.8   8  0  1
## 30:    31.93 19.7   6  0  1
## 31:    48.70 15.0   8  0  1
## 32:    10.78 21.4   4  1  1
##     mpg_rate  mpg cyl vs am
```

```r
mtcars[, .(mpg_rate = round(mpg/sum(mpg) * 100, digits = 2)), by = .(cyl, vs, am)]
```

```
##     cyl vs am mpg_rate
##  1:   6  0  1    34.04
##  2:   6  0  1    34.04
##  3:   6  0  1    31.93
##  4:   4  1  1    11.48
##  5:   4  1  1    16.31
##  6:   4  1  1    15.31
##  7:   4  1  1    17.07
##  8:   4  1  1    13.75
##  9:   4  1  1    15.31
## 10:   4  1  1    10.78
## 11:   6  1  0    27.97
## 12:   6  1  0    23.66
## 13:   6  1  0    25.10
## 14:   6  1  0    23.27
## 15:   8  0  0    10.35
## 16:   8  0  0     7.92
## 17:   8  0  0     9.08
## 18:   8  0  0     9.58
## 19:   8  0  0     8.42
## 20:   8  0  0     5.76
## 21:   8  0  0     5.76
## 22:   8  0  0     8.14
## 23:   8  0  0     8.58
## 24:   8  0  0     8.42
## 25:   8  0  0     7.36
## 26:   8  0  0    10.63
## 27:   4  1  0    35.52
## 28:   4  1  0    33.19
## 29:   4  1  0    31.30
## 30:   4  0  1   100.00
## 31:   8  0  1    51.30
## 32:   8  0  1    48.70
##     cyl vs am mpg_rate
```

### 去掉含有缺失值的记录 {#sec-remove-na}


```r
airquality[complete.cases(airquality), ] %>% head
```

```
##   Ozone Solar.R Wind Temp Month Day
## 1    41     190  7.4   67     5   1
## 2    36     118  8.0   72     5   2
## 3    12     149 12.6   74     5   3
## 4    18     313 11.5   62     5   4
## 7    23     299  8.6   65     5   7
## 8    19      99 13.8   59     5   8
```

```r
# 或着
airquality[!apply(airquality, 1, anyNA), ] %>%  head
```

```
##   Ozone Solar.R Wind Temp Month Day
## 1    41     190  7.4   67     5   1
## 2    36     118  8.0   72     5   2
## 3    12     149 12.6   74     5   3
## 4    18     313 11.5   62     5   4
## 7    23     299  8.6   65     5   7
## 8    19      99 13.8   59     5   8
```

### 集合操作 {#sec-match-set}

match 和 `%in%` 
<https://d.cosx.org/d/421314>


```r
`%nin%` <- Negate('%in%')
# `%in%` <- function(x, table) match(x, table, nomatch = 0) > 0 # %in% 函数的定义
x <- letters[1:5]
y <- letters[3:8]

x %in% y
```

```
## [1] FALSE FALSE  TRUE  TRUE  TRUE
```

```r
x %nin% y
```

```
## [1]  TRUE  TRUE FALSE FALSE FALSE
```

返回一个逻辑向量，x 中的元素匹配到了就返回 TRUE，否则 FALSE， `%nin%` 是 `%in%` 的取反效果


```r
match(x,y)
```

```
## [1] NA NA  1  2  3
```

x 在 y 中的匹配情况，匹配到了，就返回在 y 中匹配的位置，没有匹配到就返回 NA


```r
setdiff(x, y)
```

```
## [1] "a" "b"
```

```r
intersect(x, y)
```

```
## [1] "c" "d" "e"
```

```r
union(x, y)
```

```
## [1] "a" "b" "c" "d" "e" "f" "g" "h"
```


## 运行环境 {#sec-adm-sessioninfo}


```r
sessionInfo()
```

```
## R version 4.1.2 (2021-11-01)
## Platform: x86_64-pc-linux-gnu (64-bit)
## Running under: Ubuntu 20.04.3 LTS
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
## [1] magrittr_2.0.1    data.table_1.14.2
## 
## loaded via a namespace (and not attached):
##  [1] knitr_1.37       sysfonts_0.8.5   tidyselect_1.1.1 R6_2.5.1        
##  [5] rlang_0.4.12     fastmap_1.1.0    fansi_0.5.0      stringr_1.4.0   
##  [9] dplyr_1.0.7      tools_4.1.2      broom_0.7.11     xfun_0.29       
## [13] utf8_1.2.2       cli_3.1.0        DBI_1.1.2        htmltools_0.5.2 
## [17] ellipsis_0.3.2   assertthat_0.2.1 yaml_2.2.1       digest_0.6.29   
## [21] tibble_3.1.6     lifecycle_1.0.1  crayon_1.4.2     bookdown_0.24   
## [25] tidyr_1.1.4      purrr_0.3.4      vctrs_0.3.8      curl_4.3.2      
## [29] glue_1.6.0       evaluate_0.14    rmarkdown_2.11   stringi_1.7.6   
## [33] compiler_4.1.2   pillar_1.6.4     backports_1.4.1  generics_0.1.1  
## [37] pkgconfig_2.0.3
```
