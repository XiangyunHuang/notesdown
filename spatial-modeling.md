# 空间数据建模 {#chap-spatial-modeling}




```r
library(geoR)
# library(INLA)
library(leaflet)
```

## 西非眼线虫病 {#sec-cameroon-eyeworm}

loaloa 眼线虫病，人群感染，村庄水平， 响应变量服从二项分布 $Y \sim b(n,p)$，每个村庄感染的人数 $Y_i \sim b(n_i, p_i)$ 其中 $n_i$ 是第 $i$ 个村庄调查的人数， $p_i$ 是观测的感染率


```r
data("loaloa", package = "PrevMap")
```

<!-- 大规模空间数据建模，低秩近似和最近邻算法 -->


## 运行环境 {#sec-spatial-modeling-session}


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
## [1] leaflet_2.0.4.1 geoR_1.8-1     
## 
## loaded via a namespace (and not attached):
##  [1] knitr_1.37              magrittr_2.0.1          MASS_7.3-54            
##  [4] lattice_0.20-45         R6_2.5.1                rlang_0.4.12           
##  [7] fastmap_1.1.0           stringr_1.4.0           tcltk_4.1.2            
## [10] tools_4.1.2             RandomFields_3.3.13     grid_4.1.2             
## [13] xfun_0.29               RandomFieldsUtils_0.5.6 htmltools_0.5.2        
## [16] crosstalk_1.2.0         yaml_2.2.1              digest_0.6.29          
## [19] bookdown_0.24           BiocManager_1.30.16     htmlwidgets_1.5.4      
## [22] splancs_2.01-42         curl_4.3.2              evaluate_0.14          
## [25] rmarkdown_2.11          sp_1.4-6                stringi_1.7.6          
## [28] compiler_4.1.2
```

