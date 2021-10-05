# 空间数据可视化 {#chap-spatial-viz}




```r
library(sp)
library(rgdal)
library(maps)
library(mapproj)
library(maptools)
library(sf)
library(ggplot2)
library(raster)
library(abind)
library(cubelyr)
library(stars)
library(echarts4r)
library(ggthemes)
```

[王江浩](https://github.com/Jianghao)
[北京城市实验室](https://www.beijingcitylab.com/)
<!-- https://segmentfault.com/a/1190000015048613 -->

Robert J. Hijmans [^Robert-Hijmans] 开发了 [raster](https://github.com/rspatial/raster) 包用于网格空间数据的读、写、操作、分析和建模，同时维护了空间数据分析的网站 <https://www.rspatial.org>。Edzer Pebesma [^Edzer-Pebesma] 和 Roger Bivand 等创建了 [sp](https://github.com/edzer/sp/) 包定义了空间数据类型和方法，提供了大量的空间数据操作方法，同时维护了空间数据对象 sp 的绘图网站 <https://edzer.github.io/sp/>，他们也一起合作写了新书 [Spatial Data Science](https://keen-swartz-3146c4.netlify.com/)，提供了在线 [网页版](https://www.r-spatial.org/book/) 书籍及其 [源代码](https://github.com/edzer/sdsr)。Edzer Pebesma 后来开发了 [sf](https://github.com/r-spatial/sf/) 包重新定义了空间数据对象和操作方法，并维护了空间数据分析、建模和可视化网站 <https://www.r-spatial.org/>

[^Robert-Hijmans]: Department of Environmental Science and Policy at the University of California, Davis. [Ecology, Geography, and Agriculture](https://biogeo.ucdavis.edu/)
[^Edzer-Pebesma]: Institute for Geoinformatics of the University of Münster.

课程案例学习

1. [2018-Introduction to Geospatial Raster and Vector Data with R](https://datacarpentry.org/r-raster-vector-geospatial/) 空间数据分析课程
1. [Peter Ellis](http://freerangestats.info) 新西兰大选和普查数据 [More cartograms of New Zealand census data: district and city level](http://freerangestats.info/blog/nz.html)
1. [2017-Mapping oil production by country in R](http://sharpsightlabs.com/blog/map-oil-production-country-r/) 石油产量在全球的分布
1. [2017-How to highlight countries on a map](https://www.sharpsightlabs.com/blog/highlight-countries-on-map/) 高亮地图上的国家
1. [2017-Mapping With Sf: Part 3](https://ryanpeek.github.io/2017-11-21-mapping-with-sf-part-3/) 
1. [Data Visualization Shiny Apps](https://ignaciomsarmiento.github.io/software.html) 数据可视化核密度估计 In this app I identify crime hotspots using a bivariate density estimation strategy
1. [Association of Statisticians of American Religious Bodies (ASARB) viridis USA map](http://www.rpubs.com/cgarey/ProjectOneFinal)
1. [出租车行车轨迹数据](https://www1.nyc.gov/site/tlc/about/tlc-trip-record-data.page)
1. [Geospatial processing with Clickhouse-CARTO Blog](https://carto.com/blog/geospatial-processing-with-clickhouse/)


## 空间数据 {#sec-spatial-data}

空间数据存储在数据库中，比如 [PostGIS](https://postgis.net/)，它是对象关系数据库 [PostgreSQL](https://postgresql.org/) 在空间数据库方面的扩展。

### data.frame {#subsec-dataframe}


```r
data("quakes")
quakes
```

```
##         lat   long depth mag stations
## 1    -20.42 181.62   562 4.8       41
## 2    -20.62 181.03   650 4.2       15
## 3    -26.00 184.10    42 5.4       43
## 4    -17.97 181.66   626 4.1       19
## 5    -20.42 181.96   649 4.0       11
....
```

### sp {#subsec-sp}

[sp-gallery](https://edzer.github.io/sp/)



```r
library(sp)
```

空间数据对象，以类 sp 方式存储 [@Pebesma_2005_sp]


```r
library(sp)
data("meuse")
coordinates(meuse) <- ~x+y
proj4string(meuse) <- CRS("+init=epsg:28992")
```

```
## Warning in showSRID(uprojargs, format = "PROJ", multiline = "NO", prefer_proj =
## prefer_proj): Discarded datum Amersfoort in Proj4 definition
```

```r
class(meuse)
```

```
## [1] "SpatialPointsDataFrame"
## attr(,"package")
## [1] "sp"
```

```r
proj4string(meuse)
```

```
## Warning in proj4string(meuse): CRS object has comment, which is lost in output
```

```
## [1] "+proj=sterea +lat_0=52.1561605555556 +lon_0=5.38763888888889 +k=0.9999079 +x_0=155000 +y_0=463000 +ellps=bessel +units=m +no_defs"
```



```r
plot(meuse, axes = TRUE)
```

\begin{figure}

{\centering \includegraphics[width=0.5833\linewidth]{spatial-viz_files/figure-latex/unnamed-chunk-5-1} 

}

\caption{sp 对象}(\#fig:unnamed-chunk-5)
\end{figure}


```r
library(rgdal)
crs.longlat <- CRS("+init=epsg:4326")
meuse.longlat <- spTransform(meuse, crs.longlat)
plot(meuse.longlat, axes = TRUE)
```

\begin{figure}

{\centering \includegraphics[width=0.5833\linewidth]{spatial-viz_files/figure-latex/unnamed-chunk-6-1} 

}

\caption{sp 对象}(\#fig:unnamed-chunk-6)
\end{figure}



```r
library(maptools)
fname <- system.file("shapes/sids.shp", package = "maptools")
p4s <- CRS("+proj=longlat +datum=NAD27")
nc <- readShapePoly(fname, proj4string = p4s)
```

```
## Warning: readShapePoly is deprecated; use rgdal::readOGR or sf::st_read
```

```r
plot(nc, axes = TRUE, col = grey(1 - nc$SID79 / 57))
```



\begin{center}\includegraphics{spatial-viz_files/figure-latex/unnamed-chunk-7-1} \end{center}

::: {.rmdwarn data-latex="{警告}"}
maptools 提供的 `readShapePoly` 函数去读取 shp 文件的方式已经过时，推荐使用 `rgdal::readOGR` 或者 `sf::st_read` 方式读取
:::



```r
# Trellis maps
arrow <- list("SpatialPolygonsRescale",
  layout.north.arrow(2),
  offset = c(-76, 34), scale = 0.5, which = 2
)
spplot(nc, c("SID74", "SID79"),
  as.table = TRUE,
  scales = list(draw = T), sp.layout = arrow
)
```



\begin{center}\includegraphics{spatial-viz_files/figure-latex/unnamed-chunk-8-1} \end{center}


### sf {#subsec-sf}


```r
library(sf)
library(ggplot2)
nc <- read_sf(system.file("gpkg/nc.gpkg", package = "sf"))
nc2 <- nc |> 
  dplyr::select(SID74, SID79) |> 
  tidyr::gather(VAR, SID, -geom)
ggplot() +
  geom_sf(data = nc2, aes(fill = SID)) +
  facet_wrap(~VAR, ncol = 1)
```



\begin{center}\includegraphics{spatial-viz_files/figure-latex/unnamed-chunk-9-1} \end{center}


### raster {#subsec-raster}

raster 包定义了获取和操作空间 raster 类型数据集的类和方法，rasterVis 补充加强了 raster 包在数据可视化和交互方面的功能。可视化是基于 lattice 的

[rastervis-gh]: https://github.com/oscarperpinan/rastervis
[rastervis-web]: https://oscarperpinan.github.io/rastervis/
[rastervis-faq]: https://oscarperpinan.github.io/rastervis/FAQ.html

[raster](https://github.com/rspatial/raster) 包的开发已经被作者 [Robert J. Hijmans](https://desp.ucdavis.edu/people/robert-j-hijmans) 迁移到 Github 上啦，官方文档 <https://www.rspatial.org/>

星号 * 标记的是 S3 方法


```r
methods(plot)
```

```
##  [1] plot,ANY,ANY-method                       
##  [2] plot,color,ANY-method                     
##  [3] plot,Extent,missing-method                
##  [4] plot,Raster,ANY-method                    
##  [5] plot,Raster,Raster-method                 
##  [6] plot,Spatial,missing-method               
##  [7] plot,SpatialGrid,missing-method           
##  [8] plot,SpatialGridDataFrame,missing-method  
##  [9] plot,SpatialLines,missing-method          
## [10] plot,SpatialMultiPoints,missing-method    
## [11] plot,SpatialPixels,missing-method         
## [12] plot,SpatialPixelsDataFrame,missing-method
## [13] plot,SpatialPoints,missing-method         
## [14] plot,SpatialPolygons,missing-method       
## [15] plot.acf*                                 
## [16] plot.bclust*                              
## [17] plot.classIntervals*                      
## [18] plot.data.frame*                          
## [19] plot.decomposed.ts*                       
## [20] plot.default                              
## [21] plot.dendrogram*                          
## [22] plot.density*                             
## [23] plot.ecdf                                 
## [24] plot.factor*                              
## [25] plot.formula*                             
## [26] plot.function                             
## [27] plot.ggplot*                              
## [28] plot.gtable*                              
## [29] plot.hcl_palettes*                        
## [30] plot.hclust*                              
## [31] plot.histogram*                           
## [32] plot.HoltWinters*                         
## [33] plot.ica*                                 
## [34] plot.isoreg*                              
## [35] plot.lm*                                  
## [36] plot.medpolish*                           
## [37] plot.mlm*                                 
## [38] plot.ppr*                                 
## [39] plot.prcomp*                              
## [40] plot.princomp*                            
## [41] plot.profile.nls*                         
## [42] plot.R6*                                  
## [43] plot.raster*                              
## [44] plot.sf*                                  
## [45] plot.sfc_CIRCULARSTRING*                  
## [46] plot.sfc_GEOMETRY*                        
## [47] plot.sfc_GEOMETRYCOLLECTION*              
## [48] plot.sfc_LINESTRING*                      
## [49] plot.sfc_MULTILINESTRING*                 
## [50] plot.sfc_MULTIPOINT*                      
## [51] plot.sfc_MULTIPOLYGON*                    
## [52] plot.sfc_POINT*                           
## [53] plot.sfc_POLYGON*                         
## [54] plot.sfg*                                 
## [55] plot.shingle*                             
## [56] plot.SOM*                                 
## [57] plot.somgrid*                             
## [58] plot.spec*                                
## [59] plot.stars*                               
## [60] plot.stars_proxy*                         
## [61] plot.stepfun                              
## [62] plot.stft*                                
## [63] plot.stl*                                 
## [64] plot.svm*                                 
## [65] plot.table*                               
## [66] plot.trans*                               
## [67] plot.trellis*                             
## [68] plot.ts                                   
## [69] plot.tskernel*                            
## [70] plot.TukeyHSD*                            
## [71] plot.tune*                                
## [72] plot.units*                               
## [73] plot.wk_crc*                              
## [74] plot.wk_rct*                              
## [75] plot.wk_wkb*                              
## [76] plot.wk_wkt*                              
## [77] plot.wk_xy*                               
## see '?methods' for accessing help and source code
```

查看函数的定义


```r
getAnywhere(plot.raster)
```

```
## A single object matching 'plot.raster' was found
## It was found in the following places
##   registered S3 method for plot from namespace graphics
##   namespace:graphics
## with value
## 
## function (x, y, xlim = c(0, ncol(x)), ylim = c(0, nrow(x)), xaxs = "i", 
##     yaxs = "i", asp = 1, add = FALSE, ...) 
## {
##     if (!add) {
##         plot.new()
##         plot.window(xlim = xlim, ylim = ylim, asp = asp, xaxs = xaxs, 
##             yaxs = yaxs)
##     }
##     rasterImage(x, 0, 0, ncol(x), nrow(x), ...)
## }
## <bytecode: 0x5588ba0cfb98>
## <environment: namespace:graphics>
```

rasterImage 函数来绘制图像，如果想知道 `rasterImage` 的内容可以继续看 `getAnywhere(rasterImage)`


```r
getAnywhere(rasterImage)
```

```
## A single object matching 'rasterImage' was found
## It was found in the following places
##   package:graphics
##   namespace:graphics
## with value
## 
## function (image, xleft, ybottom, xright, ytop, angle = 0, interpolate = TRUE, 
##     ...) 
## {
##     .External.graphics(C_raster, if (inherits(image, "nativeRaster")) image else as.raster(image), 
##         as.double(xleft), as.double(ybottom), as.double(xright), 
##         as.double(ytop), as.double(angle), as.logical(interpolate), 
##         ...)
##     invisible()
## }
## <bytecode: 0x5588ba44e780>
## <environment: namespace:graphics>
```

通过查看函数的帮助 `?rasterImage` ，我们需要重点关注一下
参数 *image* 传递的 raster 对象


```r
plot(c(100, 250), c(300, 450), type = "n", xlab = "", ylab = "")
image <- as.raster(matrix(0:1, ncol = 5, nrow = 3))
rasterImage(image, 100, 300, 150, 350, interpolate = FALSE)
rasterImage(image, 100, 400, 150, 450)
rasterImage(image, 200, 300, 200 + xinch(.5), 300 + yinch(.3),
  interpolate = FALSE
)
rasterImage(image, 200, 400, 250, 450, 
            angle = 15, interpolate = FALSE)
```

\begin{figure}

{\centering \includegraphics[width=0.5\linewidth]{spatial-viz_files/figure-latex/unnamed-chunk-13-1} 

}

\caption{raster 图像}(\#fig:unnamed-chunk-13)
\end{figure}


```r
library(raster)
meuse.test <- raster(x = system.file("external/test.grd", package="raster"))
class(meuse.test)
```

```
## [1] "RasterLayer"
## attr(,"package")
## [1] "raster"
```



```r
plot(meuse.test, legend = F)
```

\begin{figure}

{\centering \includegraphics{spatial-viz_files/figure-latex/unnamed-chunk-15-1} 

}

\caption{raster 对象}(\#fig:unnamed-chunk-15)
\end{figure}

### stars {#subsec-stars}

Edzer Pebesma 开发了 stars 包


```r
# https://resources.rstudio.com/rstudio-conf-2019/spatial-data-science-in-the-tidyverse
library(abind)
library(sf)
library(cubelyr)
library(stars)
x <- read_stars(system.file("tif/L7_ETMs.tif", package = "stars"))

ggplot() +
  geom_stars(data = x) +
  coord_equal() +
  facet_wrap(~band) +
  theme_bw() +
  scale_fill_viridis_c() +
  scale_x_discrete(expand = c(0, 0)) +
  scale_y_discrete(expand = c(0, 0))
```



\begin{center}\includegraphics{spatial-viz_files/figure-latex/unnamed-chunk-16-1} \end{center}


## 可视化 {#sec-viz-echarts4r}

### 斐济地震带分布 {#subsec-fiji-quakes}

相比于 **plotly**，**echarts4r** 更加轻量，这得益于 JavaScript 库 [Apache ECharts](https://github.com/apache/echarts)。
前者 MIT 协议，后者采用  Apache-2.0 协议，都可以商用。Apache ECharts 是 Apache 旗下顶级开源项目，由百度前端技术团队贡献，中文文档也比较全，学习起来门槛会低一些。


```r
library(echarts4r)
quakes |>
  e_charts(x = long) |>
  e_geo(
    roam = TRUE,
    boundingCoords = list(
      c(185, -10),
      c(165, -40)
    )
  ) |>
  e_scatter(
    serie = lat,
    size = mag, # 点的大小映射到震级
    # legend = F, # 是否移除图例
    name = "斐济地震带",
    coord_system = "geo"
  ) |>
  e_visual_map(
    serie = mag, scale = e_scale,
    inRange = list(color = terrain.colors(10))
  ) |>
  e_tooltip()
```



### 美国各城镇失业率 {#subsec-usa-unemp}


```r
# 数据来源 https://datasets.flowingdata.com/unemployment09.csv
unemp <- read.csv(
  file = "http://datasets.flowingdata.com/unemployment09.csv",
  header = FALSE, stringsAsFactors = FALSE
)
names(unemp) <- c(
  "id", "state_fips", "county_fips", "name", "year",
  "?", "?", "?", "rate"
)
unemp$county <- tolower(gsub(" County, [A-Z]{2}", "", unemp$name))
unemp$state <- gsub("^.*([A-Z]{2}).*$", "\\1", unemp$name)

county_df <- map_data("county")
names(county_df) <- c("long", "lat", "group", "order", "state_name", "county")
county_df$state <- state.abb[match(county_df$state_name, tolower(state.name))]
county_df$state_name <- NULL

state_df <- map_data("state")
# Combine together
choropleth <- merge(county_df, unemp, by = c("state", "county"))
choropleth <- choropleth[order(choropleth$order), ]
choropleth$rate_d <- cut(choropleth$rate, breaks = c(seq(0, 10, by = 2), 35))

library(ggthemes)
ggplot(choropleth, aes(long, lat, group = group)) +
  geom_polygon(aes(fill = rate_d), colour = alpha("white", 1 / 4), size = 0.2) +
  geom_polygon(data = state_df, colour = "white", fill = NA) +
  scale_fill_brewer(palette = "PuRd") +
  labs(
    fill = "ratio", title = "ratio of unemployment by county, 2009",
    caption = "data source: http://datasets.flowingdata.com/unemployment09.csv"
  ) +
  coord_map("polyconic") +
  theme_map()
```

\begin{figure}

{\centering \includegraphics{spatial-viz_files/figure-latex/unemploymentGG-1} 

}

\caption{2009年美国各城镇失业率}(\#fig:unemploymentGG)
\end{figure}



```r
# 来自帮助文档 ?map 
library(mapproj) 	# mapproj is used for  projection="polyconic"
# color US county map by 2009 unemployment rate
# match counties to map using FIPS county codes
# Based on J's solution to the "Choropleth Challenge"
# http://blog.revolutionanalytics.com/2009/11/choropleth-challenge-result.html

# load data
# unemp includes data for some counties not on the "lower 48 states" county
# map, such as those in Alaska, Hawaii, Puerto Rico, and some tiny Virginia cities
data(unemp)
data(county.fips)

# define color buckets
colors <- c("#F1EEF6", "#D4B9DA", "#C994C7", "#DF65B0", "#DD1C77", "#980043")
unemp$colorBuckets <- as.numeric(cut(unemp$unemp, c(0, 2, 4, 6, 8, 10, 100)))
leg.txt <- c("<2%", "2-4%", "4-6%", "6-8%", "8-10%", ">10%")

# align data with map definitions by (partial) matching state,county
# names, which include multiple polygons for some counties
cnty.fips <- county.fips$fips[match(
  map("county", plot = FALSE)$names,
  county.fips$polyname
)]
colorsmatched <- unemp$colorBuckets[match(cnty.fips, unemp$fips)]

# draw map
map("county",
  col = colors[colorsmatched], fill = TRUE, resolution = 0,
  lty = 0, projection = "polyconic"
)
map("state",
  col = "white", fill = FALSE, add = TRUE, lty = 1, lwd = 0.2,
  projection = "polyconic"
)
title("unemployment by county, 2009")
legend("topright", leg.txt, horiz = TRUE, fill = colors)
```



\begin{center}\includegraphics{spatial-viz_files/figure-latex/unnamed-chunk-17-1} \end{center}

美国各地区失业率地图，配不同颜色， [colormap](https://github.com/bhaskarvk/colormap) 适合给静态图配色
