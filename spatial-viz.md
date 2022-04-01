# 空间数据可视化 {#chap-spatial-viz}

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



### raster {#subsec-raster}


```r
library(raster)
```

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
##  [2] plot,Extent,missing-method                
##  [3] plot,Raster,ANY-method                    
##  [4] plot,Raster,Raster-method                 
##  [5] plot,SpatExtent,missing-method            
##  [6] plot,Spatial,missing-method               
##  [7] plot,SpatialGrid,missing-method           
##  [8] plot,SpatialGridDataFrame,missing-method  
##  [9] plot,SpatialLines,missing-method          
## [10] plot,SpatialMultiPoints,missing-method    
## [11] plot,SpatialPixels,missing-method         
## [12] plot,SpatialPixelsDataFrame,missing-method
## [13] plot,SpatialPoints,missing-method         
## [14] plot,SpatialPolygons,missing-method       
## [15] plot,SpatRaster,character-method          
## [16] plot,SpatRaster,missing-method            
## [17] plot,SpatRaster,numeric-method            
## [18] plot,SpatRaster,SpatRaster-method         
## [19] plot,SpatVector,character-method          
## [20] plot,SpatVector,missing-method            
## [21] plot,SpatVector,numeric-method            
## [22] plot,SpatVectorProxy,missing-method       
## [23] plot.acf*                                 
## [24] plot.data.frame*                          
## [25] plot.decomposed.ts*                       
## [26] plot.default                              
## [27] plot.dendrogram*                          
## [28] plot.density*                             
## [29] plot.ecdf                                 
## [30] plot.factor*                              
## [31] plot.formula*                             
## [32] plot.function                             
## [33] plot.hclust*                              
## [34] plot.histogram*                           
## [35] plot.HoltWinters*                         
## [36] plot.isoreg*                              
## [37] plot.lm*                                  
## [38] plot.medpolish*                           
## [39] plot.mlm*                                 
## [40] plot.ppr*                                 
## [41] plot.prcomp*                              
## [42] plot.princomp*                            
## [43] plot.profile.nls*                         
## [44] plot.raster*                              
## [45] plot.shingle*                             
## [46] plot.spec*                                
## [47] plot.stepfun                              
## [48] plot.stl*                                 
## [49] plot.table*                               
## [50] plot.trellis*                             
## [51] plot.ts                                   
## [52] plot.tskernel*                            
## [53] plot.TukeyHSD*                            
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
## <bytecode: 0x556b435b5650>
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
## <bytecode: 0x556b43769750>
## <environment: namespace:graphics>
```

通过查看函数的帮助 `?rasterImage` ，我们需要重点关注一下
参数 *image* 传递的 raster 对象。



```r
plot(c(100, 250), c(300, 450), type = "n", xlab = "", ylab = "")
x <- rep(0, 15)
x[seq(from = 2, to = 14, by = 2)] <- 1
image <- as.raster(matrix(x, ncol = 5, nrow = 3))
rasterImage(image, 100, 300, 150, 350, interpolate = FALSE)
# 插值平滑
rasterImage(image, 100, 400, 150, 450)
# 缩小比例
rasterImage(image, 200, 300, 200 + xinch(.5), 300 + yinch(.3),
  interpolate = FALSE
)
# 旋转图像
rasterImage(image, 200, 400, 250, 450,
  angle = 15, interpolate = FALSE
)
```

\begin{figure}

{\centering \includegraphics[width=0.5\linewidth]{spatial-viz_files/figure-latex/raster-image-1} 

}

\caption{raster 图像}(\#fig:raster-image)
\end{figure}


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



## 美国各个城镇的失业率分布


以 2009 年美国各个城镇的失业率数据为例，数据来自 **maps** 包的 unemp 数据集，它有三个变量，fips 城镇代码[^fips]，pop 人口，unemp 失业率。失业率本是连续的数据，将其分级划分区间，每个失业率区间用不同颜色表示。


[^fips]: 可类比我国[行政区划代码](http://www.mca.gov.cn/article/sj/xzqh/1980/)，自1980年以来，每年都会发布一次，涉及一些市、区、县、乡、镇、街道等的变更。


### maps

**maps** 包提供城镇地图数据，数据集 county.fips 各个城镇的名称 polyname 及 行政代码 fips，和 unemp 数据集关联可以知道各个城镇的失业率，再与城镇地图数据关联，就可以将数据绘制在地图上。county.fips 没有夏威夷、阿拉斯加、波多黎各的地图数据，导致 unemp 数据集里阿拉斯加、夏威夷、波多黎各和部分弗吉尼亚的小城市无法映射到地图上。





```r
# 代码调整自帮助文档 ?map
library(maps)
library(mapproj)
# 失业率数据
data(unemp)
# 行政编码
data(county.fips)
# 准备调色板
# colors <- c("#F1EEF6", "#D4B9DA", "#C994C7", "#DF65B0", "#DD1C77", "#980043")
colors <- viridisLite::plasma(9)
# 失业率划分区间
unemp$colorBuckets <- as.numeric(cut(unemp$unemp, c(seq(0, 10, by = 2), 15, 20, 25, 100)))
# 准备图例文本
leg.txt <- c("<2%", "2-4%", "4-6%", "6-8%", "8-10%", "10-15%", "15-20%", "20-25%", ">25%")

cnty.fips <- county.fips$fips[match(
  map("county", plot = FALSE)$names,
  county.fips$polyname
)]

# 匹配上的区域
colorsmatched <- unemp$colorBuckets[match(cnty.fips, unemp$fips)]
par(mar = c(1.5, 0, 2, 0))
# 绘制区县地图
map("county",
  col = colors[colorsmatched], fill = TRUE, resolution = 0,
  lty = 0, projection = "polyconic", mar = c(0.5, 0.5, 2, 0.5)
)
# 添加州边界线
map("state",
  col = "white", fill = FALSE, add = TRUE,
  lty = 1, lwd = 0.2, projection = "polyconic"
)
# 添加图标题
title("2009 年美国各个城镇的失业率")
mtext(text = "数据源：美国人口调查局", side = 1, adj = 0)
# 添加图例
legend("top", leg.txt, horiz = TRUE, fill = colors, cex = 0.85)
```

\begin{figure}

{\centering \includegraphics[width=0.75\linewidth]{spatial-viz_files/figure-latex/unemp-maps-1} 

}

\caption{2009 年美国各个城镇的失业率分布}(\#fig:unemp-maps)
\end{figure}

### latticeExtra


```r
# 地图数据
us_county <- map("county", plot = FALSE, fill = TRUE, projection = "polyconic")
# 失业率数据和行政区域名称关联
unemp_df <- merge(unemp, county.fips, by = "fips")
# 绘图
latticeExtra::mapplot(polyname ~ unemp,
  data = unemp_df,
  map = us_county,
  colramp = viridisLite::plasma,
  border = NA,
  # cuts = 10, # 等距分桶的数，和参数 breaks 二选一
  breaks = c(seq(0, 10, by = 2), 15, 20, 25, 30, 35),
  subset = polyname %in% us_county$names,
  scales = list(draw = F),
  xlab = "",
  par.settings = list(
    # 副标题放在左下角
    par.sub.text = list(
      font = 2,
      just = "left",
      x = grid::unit(5, "mm"),
      y = grid::unit(5, "mm")
    ),
    # 轴线设置白色以隐藏
    axis.line = list(col = "white")
  ),
  sub = "数据源：美国人口调查局",
  main = "2009 年美国各个城镇的失业率"
)
```

\begin{figure}

{\centering \includegraphics{spatial-viz_files/figure-latex/unemp-lattice-1} 

}

\caption{2009 年美国各个城镇的失业率分布}(\#fig:unemp-lattice)
\end{figure}


### ggplot2


[**usmapdata**](https://github.com/pdil/usmapdata) 包提供美国国家、州和城镇边界地图数据，下面以此数据为基础，借助 **ggplot2** 包[@Wickham2022]绘制失业率专题地图，未收集到失业率数据的城镇填充灰色，图中中文采用 **showtext** 包[@Qiu2015]处理，如图 \@ref(fig:unemp-ggplot2) 所示。


```r
# 失业率数据和行政编码数据结合
# unemp_df <- merge(unemp, county.fips, by = "fips")
# 从 usmapdata 包获取地图数据
county_df <- usmapdata::us_map("counties")
# 行政编码是一串数字组成的字符串
county_df$fips <- as.numeric(county_df$fips)
# 地图数据和失业率数据结合
choropleth <- merge(county_df, unemp_df, by = "fips", all.x = TRUE)
# 还原地图数据的顺序
choropleth <- choropleth[order(choropleth$order), ]
# 失业率分级
choropleth$rate_d <- cut(choropleth$unemp, breaks = c(seq(0, 10, by = 2), 15, 20, 25, 30, 35))
# 准备州边界线数据
state_df <- usmapdata::us_map("states")
# 绘图
library(ggplot2)
ggplot(choropleth, aes(x, y, group = group)) +
  geom_polygon(aes(fill = rate_d), colour = alpha("gray95", 1/4), size = 0.2) +
  geom_polygon(data = state_df, colour = "gray80", fill = NA, size = 0.3) +
  scale_fill_viridis_d(option = "plasma", na.value = "gray80") +
  labs(
    fill = "失业率(%)", title = "2009 年美国各个城镇的失业率",
    caption = "数据源：美国人口调查局"
  ) +
  theme_void() +
  theme(plot.title = element_text(hjust = 0.5))
```

\begin{figure}

{\centering \includegraphics{spatial-viz_files/figure-latex/unemp-ggplot2-1} 

}

\caption{2009 年美国各个城镇的失业率分布}(\#fig:unemp-ggplot2)
\end{figure}


### sf

相比于前任 **sp** 包，**sf** 包将是新一代空间数据操作、分析和可视化的基石，引入 GDAL、PROJ 和 GEOS 三大基础框架，和更庞大的空间数据社区接轨，不局限于 R 语言社区的一亩三分地。**sf** 包支持 Base R 绘图，以此绘制失业率专题地图，如图\@ref(fig:unemp-sf)所示，可见效果丝毫不逊于 **lattice** 和 **ggplot2** 版本，而且在兼容性、代码量、稳定性和性能等方面有明显优势。


```r
library(sf)
# 准备地图数据
us_states_shifted <- readRDS(file = "data/us_states_shifted.rds")
us_county_shifted <- readRDS(file = "data/us_county_shifted.rds")
# 准备用于合并操作的主键
us_county_shifted <- within(us_county_shifted, {
  polyname <- tolower(paste(STATE_NAME, NAME, sep = ","))
})
# 将失业率数据和地图数据合并
us_county_data <- merge(x = us_county_shifted, y = unemp_df, by = "polyname", all.x = T)

plot(us_county_data["unemp"],
  pal = viridisLite::plasma,
  breaks = c(seq(0, 10, by = 2), 15, 20, 25, 30, 35),
  border = alpha("gray95", 1/8), key.pos = 4, reset = FALSE,
  main = "2009 年美国各个城镇的失业率"
)
# 添加州边界
plot(st_geometry(us_states_shifted), col = NA, border = "gray", add = T)
mtext(text = "数据源：美国人口调查局", side = 1, adj = 0)
```

\begin{figure}

{\centering \includegraphics{spatial-viz_files/figure-latex/unemp-sf-1} 

}

\caption{2009 年美国各个城镇的失业率分布}(\#fig:unemp-sf)
\end{figure}



```r
# 绘制失业率地图
par(mar = c(1, 0, 2, 0))
plot(st_geometry(us_county_data),
  col = "gray80",
  border = alpha("gray95", 1 / 4),
  main = "2009 年美国各个城镇的失业率", reset = FALSE
)
plot(us_county_data["unemp"],
  pal = viridisLite::plasma,
  breaks = c(seq(0, 10, by = 2), 15, 20, 35),
  border = alpha("gray95", 1 / 8), key.pos = 4, add = TRUE
)
# 添加州边界
plot(st_geometry(us_states_shifted), col = NA, border = "gray90", add = T)
mtext(text = "数据源：美国人口调查局", side = 1, adj = 0)
# 添加图例
legend("top",
  legend = c(
    "<2%", "2-4%", "4-6%", "6-8%", "8-10%",
    "10-15%", "15-20%", ">20%", "NA"
  ),
  horiz = T, border = NA, box.col = "gray",
  fill = c(viridisLite::plasma(8), "gray80"), cex = 0.75
)
```

\begin{figure}

{\centering \includegraphics{spatial-viz_files/figure-latex/unemp-sf-base-1} 

}

\caption{2009 年美国各个城镇的失业率分布}(\#fig:unemp-sf-base)
\end{figure}

