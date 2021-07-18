# 空间分析  {#chap:spatial-analysis}


[mapdeck](https://github.com/SymbolixAU/mapdeck) 支持调用 GPU 渲染
[deck.gl](https://github.com/visgl/deck.gl) MIT 协议


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
library(rasterVis) # https://oscarperpinan.github.io/rastervis/
# https://oscarperpinan.github.io/rastervis/FAQ.html
library(sf)
library(rgdal)
library(highcharter)
```

## 冈比亚儿童疟疾 {#sec:gambia-malaria}

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
library(rgdal)
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

[googleway](https://github.com/SymbolixAU/googleway)、[ggmap](https://github.com/dkahle/ggmap)、[RgoogleMaps](https://github.com/markusloecher/rgooglemaps)


```r
library(RgoogleMaps)
lat <- c(40.702147, 40.718217, 40.711614)
lon <- c(-74.012318, -74.015794, -73.998284)
center <- c(mean(lat), mean(lon))
zoom <- min(MaxZoom(range(lat), range(lon)))
bb <- qbbox(lat, lon)
par(pty = "s")
# OSM
myMap <- GetMap(center, zoom = 15)
PlotOnStaticMap(myMap,
  lat = lat, lon = lon, pch = 20,
  col = c("red", "blue", "green"), cex = 2
)
```



```r
library(ggmap)

us <- c(left = -125, bottom = 25.75, right = -67, top = 49)
get_stamenmap(us, zoom = 5, maptype = "toner-lite") %>%
  ggmap()
```

## 运行环境 {#sec:spatial-analysis-session}


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
##  [1] highcharter_0.8.2   rgdal_1.5-23        sf_1.0-0           
##  [4] rasterVis_0.50.2    terra_1.3-4         latticeExtra_0.6-29
##  [7] lattice_0.20-44     raster_3.4-13       RColorBrewer_1.1-2 
## [10] sp_1.4-5           
## 
## loaded via a namespace (and not attached):
##  [1] zoo_1.8-9          tidyselect_1.1.1   xfun_0.24          purrr_0.3.4       
##  [5] vctrs_0.3.8        generics_0.1.0     htmltools_0.5.1.1  viridisLite_0.4.0 
##  [9] yaml_2.2.1         utf8_1.2.1         rlang_0.4.11       e1071_1.7-7       
## [13] hexbin_1.28.2      pillar_1.6.1       glue_1.4.2         DBI_1.1.1         
## [17] TTR_0.24.2         jpeg_0.1-8.1       lifecycle_1.0.0    quantmod_0.4.18   
## [21] stringr_1.4.0      htmlwidgets_1.5.3  codetools_0.2-18   evaluate_0.14     
## [25] knitr_1.33         curl_4.3.2         parallel_4.1.0     class_7.3-19      
## [29] fansi_0.5.0        xts_0.12.1         broom_0.7.8        Rcpp_1.0.7        
## [33] KernSmooth_2.23-20 backports_1.2.1    classInt_0.4-3     jsonlite_1.7.2    
## [37] png_0.1-7          digest_0.6.27      stringi_1.7.3      rlist_0.4.6.1     
## [41] bookdown_0.22      dplyr_1.0.7        grid_4.1.0         tools_4.1.0       
## [45] magrittr_2.0.1     proxy_0.4-26       tibble_3.1.2       tidyr_1.1.3       
## [49] crayon_1.4.1       pkgconfig_2.0.3    ellipsis_0.3.2     data.table_1.14.0 
## [53] lubridate_1.7.10   assertthat_0.2.1   rmarkdown_2.9      R6_2.5.0          
## [57] igraph_1.2.6       units_0.7-2        compiler_4.1.0
```

