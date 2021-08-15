# 空间建模 {#chap-spatial-modeling}




```r
library(geoR)
# library(INLA)
# library(leaflet)
library(highcharter)
```

## 西非眼线虫病 {#sec-cameroon-eyeworm}

loaloa 眼线虫病，人群感染，村庄水平， 响应变量服从二项分布 $Y \sim b(n,p)$，每个村庄感染的人数 $Y_i \sim b(n_i, p_i)$ 其中 $n_i$ 是第 $i$ 个村庄调查的人数， $p_i$ 是观测的感染率


```r
data("loaloa", package = "PrevMap")
```

<!-- 大规模空间数据建模，低秩近似和最近邻算法 -->


```r
hcmap(map = "countries/cm/cm-all.js") %>%
  hc_title(text = "喀麦隆及其周边地区眼线虫病流行度")
```

## 运行环境 {#sec-spatial-modeling-session}


```r
sessionInfo()
```

```
## R version 4.1.1 (2021-08-10)
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
## [1] parallel  stats     graphics  grDevices utils     datasets  methods  
## [8] base     
## 
## other attached packages:
## [1] highcharter_0.8.2 geoR_1.8-1        INLA_21.02.23     sp_1.4-5         
## [5] foreach_1.5.1     Matrix_1.3-4     
## 
## loaded via a namespace (and not attached):
##  [1] zoo_1.8-9               tidyselect_1.1.1        xfun_0.25              
##  [4] purrr_0.3.4             splines_4.1.1           lattice_0.20-44        
##  [7] tcltk_4.1.1             vctrs_0.3.8             generics_0.1.0         
## [10] htmltools_0.5.1.1       yaml_2.2.1              utf8_1.2.2             
## [13] rlang_0.4.11            pillar_1.6.2            glue_1.4.2             
## [16] DBI_1.1.1               TTR_0.24.2              lifecycle_1.0.0        
## [19] quantmod_0.4.18         stringr_1.4.0           htmlwidgets_1.5.3      
## [22] codetools_0.2-18        evaluate_0.14           knitr_1.33             
## [25] curl_4.3.2              fansi_0.5.0             xts_0.12.1             
## [28] broom_0.7.9             Rcpp_1.0.7              backports_1.2.1        
## [31] jsonlite_1.7.2          digest_0.6.27           stringi_1.7.3          
## [34] rlist_0.4.6.1           bookdown_0.23           dplyr_1.0.7            
## [37] splancs_2.01-42         grid_4.1.1              tools_4.1.1            
## [40] magrittr_2.0.1          tibble_3.1.3            crayon_1.4.1           
## [43] tidyr_1.1.3             pkgconfig_2.0.3         MASS_7.3-54            
## [46] ellipsis_0.3.2          data.table_1.14.0       RandomFieldsUtils_0.5.3
## [49] RandomFields_3.3.8      lubridate_1.7.10        assertthat_0.2.1       
## [52] rmarkdown_2.10          iterators_1.0.13        R6_2.5.0               
## [55] igraph_1.2.6            compiler_4.1.1
```

