# 空间数据分析  {#chap-spatial-analysis}


Robert Hijmans 开发的 [terra](https://github.com/rspatial/terra) 用以替代 [raster](https://github.com/rspatial/raster)，提供栅格数据和向量数据处理，基于回归和机器学习方法的空间差值和预测，能够处理相当大的数据集，包括卫星遥感数据，新的 R 包更加简洁、速度更快、功能更强。Edzer Pebesma 创建的 [r-spatial](https://github.com/r-spatial/) 开源组织提供了一系列非常流行的空间分析相关的 R 包，如 [sp](https://edzer.github.io/sp/)、 [sf](https://github.com/r-spatial/sf)、 [stars](https://github.com/r-spatial/stars)、 [mapedit](https://github.com/r-spatial/mapedit) 和
[mapview](https://github.com/r-spatial/mapview)。Edzer Pebesma 长期致力于地理信息和空间统计的软件开发，可以说目前已打造了一个生态。

Timothée Giraud 创建的 [riatelab](https://github.com/riatelab/) 组织开发系列 R 包工具，可以绘制各种类型和风格的地图，专题地图工具已经从 [cartography](https://github.com/riatelab/cartography/) 过渡到 [mapsf](https://github.com/riatelab/mapsf)，它更加友好、轻量和稳健。类似的 R 包还有 [choroplethr](https://github.com/trulia/choroplethr)，只是上次更新在 2015 年。

空间数据可视化常常离不开基础地图数据，不同的 R 包依赖的地图服务有所不同，比如
 [RgoogleMaps](https://github.com/markusloecher/rgooglemaps)、[ggmap](https://github.com/dkahle/ggmap) 和 [googleway](https://github.com/SymbolixAU/googleway) 主要依赖谷歌的地图数据。
而 [mapdeck](https://github.com/SymbolixAU/mapdeck) 基于 [deck.gl](https://github.com/visgl/deck.gl) 和 [Mapbox](https://github.com/mapbox/mapbox-gl-js) 支持移动和网页应用，GPU 渲染等。[leaflet](https://github.com/rstudio/leaflet) 则基于开源的[Leaflet](https://github.com/Leaflet/Leaflet)库提供交互式空间数据可视化的能力。


[芝加哥大学空间数据科学中心](https://spatial.uchicago.edu/) 开发的 R 包 [rgeoda](https://github.com/GeoDaCenter/rgeoda) 基于开源的 C++ 库[GeoDa](https://github.com/GeoDaCenter/geoda)，提供一系列空间数据分析能力，包括探索性空间数据分析、空间聚类检测和聚类分析。


Edzer Pebesma 和 Roger Bivand 合著的 [Spatial Data Science with applications in R](https://www.r-spatial.org/book)，Christopher K. Wikle, Andrew Zammit-Mangion 和 Noel Cressie 合著的 [Spatio-Temporal Statistics with R](https://spacetimewithr.org/)。推荐学习 Edzer Pebesma 在几届国际 R 语言大会上的材料，2021 年的[R Spatial](https://edzer.github.io/UseR2021/)，2020 年的[Analyzing and visualising spatial and spatiotemporal data cubes Part I](https://edzer.github.io/UseR2020/)，
2019 年的[Spatial workshop part I](https://edzer.github.io/UseR2019/part1.html) 和 [Spatial workshop part II](https://edzer.github.io/UseR2019/part2.html)，
2017 年的[Spatial Data in R: New Directions](https://edzer.github.io/UseR2017/)
2016 年的[Handling and Analyzing Spatial, Spatiotemporal and Movement Data](https://edzer.github.io/UseR2016/)。



```r
library(sp)
library(RColorBrewer)
library(raster)
library(lattice)
library(latticeExtra)
library(terra) # 
library(rasterVis) # https://oscarperpinan.github.io/rastervis/
# https://oscarperpinan.github.io/rastervis/FAQ.html
library(sf)
library(sfarrow) # https://github.com/wcjochem/sfarrow
# library(arrow) # 列式存储
# library(rgdal) # 要替换掉
```




```r
library(sp)
data(meuse)
coordinates(meuse) <- ~x+y
proj4string(meuse) <- CRS("+init=epsg:28992")
plot(meuse)
```


```r
library(sp)
demo(meuse, ask = FALSE, echo = FALSE) # loads the meuse data sets
library(maptools)
crs.longlat = CRS("+init=epsg:4326")
meuse.longlat = spTransform(meuse, crs.longlat)
plot(meuse.longlat, axes = TRUE)

library(mapview)
library(rgdal) # for readOGR
nc <- readOGR(system.file("shapes/", package="maptools"), "sids")
proj4string(nc) <- CRS("+proj=longlat +datum=NAD27")
class(nc)
mapview(nc, zcol = c("SID74", "SID79"), alpha.regions = 1.0, legend = TRUE)
```



## 冈比亚儿童疟疾 {#sec-gambia-malaria}

冈比亚地形


```r
sp_path <- "data/" # 存储临时地形文件
if (!dir.exists(sp_path)) dir.create(sp_path, recursive = TRUE)
# Gambia 海拔数据
gambia_alt <- raster::getData(name = "alt", country = "GMB", mask = TRUE, path = sp_path)
# Gambia 市级行政边界数据
gambia_map <- raster::getData("GADM", country = "GMB", level = 2, path = sp_path)
# 绘制冈比亚地形
rasterVis::levelplot(gambia_alt,
  margin = FALSE,
  main = "Elevation",
  colorkey = list(
    space = "top",
    labels = list(at = seq(from = -5, to = 65, by = 10)),
    axis.line = list(col = "black")
  ),
  par.settings = list(
    axis.line = list(col = "transparent")
  ),
  scales = list(draw = FALSE),
  col.regions = hcl.colors,
  at = seq(-5, 65, len = 101)
) +
  latticeExtra::layer(sp::sp.polygons(gambia_map, lwd = 1.5))
```

\begin{figure}

{\centering \includegraphics{spatial-analysis_files/figure-latex/gambia-altitude-1} 

}

\caption{冈比亚地形海拔数据}(\#fig:gambia-altitude)
\end{figure}

[rgdal](https://rgdal.r-forge.r-project.org/) 包可以实现坐标变换


```r
# 加载数据
data(gambia, package = "geoR")
# 坐标变换
library(sp)
sps <- SpatialPoints(gambia[, c("x", "y")],
  proj4string = CRS("+proj=utm +zone=28")
)
spst <- spTransform(sps, CRS("+proj=longlat +datum=WGS84"))
gambia[, c("x", "y")] <- coordinates(spst)
# 聚合数据
gambia_agg <- aggregate(
  formula = cbind(pos, netuse, treated) ~ x + y + green + phc,
  data = gambia, FUN = function(x) sum(x) / length(x)
)
# 抽取指定位置的海拔数据
# raster::extract(gambia_alt, gambia[, c("x", "y")])
```

$Y \sim b(1,p)$ 每个人检验结果，就是感染 1 或是没有感染 0，感染率 $p$ 的建模分析，个体水平




```r
# https://github.com/geodacenter/rgeoda/
library(rgeoda)
library(sf)

guerry <- st_read(system.file("extdata", "Guerry.shp", package = "rgeoda"))

crm_prp <- guerry["Crm_prp"]
queen_w <- queen_weights(guerry)

lisa <- local_moran(queen_w, crm_prp)

lisa_colors <- lisa_colors(lisa)
lisa_labels <- lisa_labels(lisa)
lisa_clusters <- lisa_clusters(lisa)

plot(st_geometry(guerry),
     col = sapply(lisa_clusters, function(x) {
       lisa_colors[[x + 1]]
     }),
     border = "#333333", lwd = 0.2
)
title(main = "Local Moran Map of Crm_prs")
legend("bottomleft",
  legend = lisa_labels,
  fill = lisa_colors,
  border = "#eeeeee"
)
```





## 运行环境 {#sec-spatial-analysis-session}


```r
sessionInfo()
```

```
## R version 4.1.2 (2021-11-01)
## Platform: x86_64-pc-linux-gnu (64-bit)
## Running under: Ubuntu 20.04.4 LTS
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
## [1] sfarrow_0.4.1       sf_1.0-5            rasterVis_0.51.1   
## [4] terra_1.4-22        latticeExtra_0.6-29 lattice_0.20-45    
## [7] raster_3.5-11       RColorBrewer_1.1-2  sp_1.4-6           
## 
## loaded via a namespace (and not attached):
##  [1] zoo_1.8-9          tidyselect_1.1.1   xfun_0.29          purrr_0.3.4       
##  [5] vctrs_0.3.8        generics_0.1.1     htmltools_0.5.2    viridisLite_0.4.0 
##  [9] yaml_2.2.1         utf8_1.2.2         rlang_0.4.12       e1071_1.7-9       
## [13] hexbin_1.28.2      pillar_1.6.4       glue_1.6.0         DBI_1.1.2         
## [17] jpeg_0.1-9         lifecycle_1.0.1    stringr_1.4.0      codetools_0.2-18  
## [21] evaluate_0.14      knitr_1.37         fastmap_1.1.0      parallel_4.1.2    
## [25] curl_4.3.2         class_7.3-19       fansi_0.5.0        Rcpp_1.0.7        
## [29] KernSmooth_2.23-20 classInt_0.4-3     sysfonts_0.8.5     png_0.1-7         
## [33] digest_0.6.29      stringi_1.7.6      bookdown_0.24      dplyr_1.0.7       
## [37] grid_4.1.2         rgdal_1.5-28       tools_4.1.2        magrittr_2.0.1    
## [41] proxy_0.4-26       tibble_3.1.6       crayon_1.4.2       pkgconfig_2.0.3   
## [45] ellipsis_0.3.2     assertthat_0.2.1   rmarkdown_2.11     R6_2.5.1          
## [49] units_0.7-2        compiler_4.1.2
```

