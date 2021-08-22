# 空间数据可视化 {#chap-spatial-viz}



相比于 **plotly**，**echarts4r** 更加轻量，这得益于 JavaScript 库 [Apache ECharts](https://github.com/apache/echarts)。
前者 MIT 协议，后者采用  Apache-2.0 协议，都可以商用。Apache ECharts 是 Apache 旗下顶级开源项目，由百度前端技术团队贡献，中文文档也比较全，学习起来门槛会低一些。

echarts4r 空间数据


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



