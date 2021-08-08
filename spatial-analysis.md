# 空间分析  {#chap-spatial-analysis}

<!-- 
1. 静态可视化和动态可视化
1. Google 地图和开源地图服务需要介绍，国内的地图服务也需要介绍
1. 介绍空间基础对象，及其数据操作和分析

开源组织
Timothée Giraud 等创建的 [riatelab](https://github.com/riatelab/) 和 Edzer Pebesma 等创建的 [r-spatial](https://github.com/r-spatial/)


Robert Hijmans 开发的 [terra](https://github.com/rspatial/terra) 用以替代 [raster](https://github.com/rspatial/raster)，新的R包更加简洁、速度更快、功能更强。

mapedit
mapview
leaflet

Edzer Pebesma, Roger Bivand 著作 [Spatial Data Science with applications in R](https://www.r-spatial.org/book)
-->

[mapsf](https://github.com/riatelab/mapsf) 是 [cartography](https://github.com/riatelab/cartography/) 的继任者，它更加友好、轻量和稳健。

[choroplethr](https://github.com/trulia/choroplethr) 简化创建 thematic maps 的过程。

[ggmap](https://github.com/dkahle/ggmap) 依赖 [RgoogleMaps](https://github.com/markusloecher/rgooglemaps) 就不介绍了

[mapdeck](https://github.com/SymbolixAU/mapdeck) 支持调用 GPU 渲染
[deck.gl](https://github.com/visgl/deck.gl) MIT 协议

[googleway](https://github.com/SymbolixAU/googleway)


Edzer Pebesma

- UseR2020 [Analyzing and visualising spatial and spatiotemporal data cubes - Part I](https://edzer.github.io/UseR2020/)
- UseR2019 [UseR! 2019 Spatial workshop part I](https://edzer.github.io/UseR2019/part1.html) [UseR! 2019 Spatial workshop part II](https://edzer.github.io/UseR2019/part2.html)
- UseR2017 [Spatial Data in R: New Directions](https://edzer.github.io/UseR2017/)
- UseR2016 [Handling and Analyzing Spatial, Spatiotemporal and Movement Data](https://edzer.github.io/UseR2016/)


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
# library(highcharter) # 要替换掉
```



```r
library(RgoogleMaps)
library(mapdeck)
library(mapsf)
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
library(highcharter)
hchart(gambia_agg, "bubble", hcaes(x = x, y = y, fill = pos, size = pos),
  maxSize = "5%", name = "Gambia", showInLegend = FALSE
) %>%
  hc_yAxis(title = list(text = "Latitude")) %>%
  hc_xAxis(title = list(text = "Longitude"), labels = list(align = "center")) %>%
  hc_colorAxis(
    stops = color_stops(colors = hcl.colors(palette = "Plasma", n = 10))
  ) %>%
  hc_tooltip(
    pointFormat = "({point.x:.2f}, {point.y:.2f}) <br/> Size: {point.z:.2f}"
  )
```



```r
# gm_data <- download_map_data("https://code.highcharts.com/mapdata/countries/gm/gm-all.js")
# get_data_from_map(gm_data)

hcmap("countries/gm/gm-all.js") %>%
  hc_title(text = "Gambia")
```


```r
data("USArrests", package = "datasets")
data("usgeojson") # 加载地图数据 地图数据的结构

USArrests <- transform(USArrests, state = rownames(USArrests))

highchart() %>%
  hc_title(text = "Violent Crime Rates by US State") %>%
  hc_subtitle(text = "Source: USArrests data") %>%
  hc_add_series_map(usgeojson, USArrests,
    name = "Murder arrests (per 100,000)",
    value = "Murder", joinBy = c("woename", "state"),
    dataLabels = list(
      enabled = TRUE,
      format = "{point.properties.postalcode}"
    )
  ) %>%
  hc_colorAxis(stops = color_stops()) %>%
  hc_legend(valueDecimals = 0, valueSuffix = "%") %>%
  hc_mapNavigation(enabled = TRUE)
```

highcharter 包含三个数据集分别是： worldgeojson 世界地图（国家级）、 usgeojson 美国地图（州级）、  uscountygeojson 美国地图（城镇级）。其它地图数据见 <https://code.highcharts.com/mapdata/>。



```r
# 添加地图数据
hcmap(map = "countries/cn/custom/cn-all-sar-taiwan.js") %>%
  hc_title(text = "中国地图")
```



```r
library(mapdeck)
# 多边形
mapdeck() %>%
  add_polygon(
    data = spatialwidget::widget_melbourne, 
    fill_colour = "SA2_NAME",
    palette = "spectral"
  )

mapdeck( location = c(145, -37.8), zoom = 10) %>%
  add_geojson(
    data = mapdeck::geojson
  )
```





## 运行环境 {#sec-spatial-analysis-session}


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
## [1] sfarrow_0.4.0       sf_1.0-2            rasterVis_0.50.3   
## [4] terra_1.3-4         latticeExtra_0.6-29 lattice_0.20-44    
## [7] raster_3.4-13       RColorBrewer_1.1-2  sp_1.4-5           
## 
## loaded via a namespace (and not attached):
##  [1] zoo_1.8-9          tidyselect_1.1.1   xfun_0.25          purrr_0.3.4       
##  [5] vctrs_0.3.8        generics_0.1.0     htmltools_0.5.1.1  viridisLite_0.4.0 
##  [9] yaml_2.2.1         utf8_1.2.2         rlang_0.4.11       e1071_1.7-8       
## [13] hexbin_1.28.2      pillar_1.6.2       glue_1.4.2         DBI_1.1.1         
## [17] jpeg_0.1-9         lifecycle_1.0.0    stringr_1.4.0      codetools_0.2-18  
## [21] evaluate_0.14      knitr_1.33         parallel_4.1.0     curl_4.3.2        
## [25] class_7.3-19       fansi_0.5.0        Rcpp_1.0.7         KernSmooth_2.23-20
## [29] classInt_0.4-3     png_0.1-7          digest_0.6.27      stringi_1.7.3     
## [33] bookdown_0.22      dplyr_1.0.7        grid_4.1.0         rgdal_1.5-23      
## [37] tools_4.1.0        magrittr_2.0.1     proxy_0.4-26       tibble_3.1.3      
## [41] crayon_1.4.1       pkgconfig_2.0.3    ellipsis_0.3.2     assertthat_0.2.1  
## [45] rmarkdown_2.10     R6_2.5.0           units_0.7-2        compiler_4.1.0
```

