# 数据可视化 {#chap-data-visualization}


```r
library(ggplot2)           # ggplot2 图形
library(patchwork)         # 图形布局
library(magrittr)          # 管道操作
library(ggrepel)           # 文本注释
library(extrafont)         # 加载外部字体 TTF
library(hrbrthemes)        # 主题
library(maps)              # 地图数据
library(mapdata)           # 地图数据
library(xkcd)              # 漫画字体
library(RgoogleMaps)       # 静态地图
library(data.table)        # 数据操作
library(KernSmooth)        # 核平滑
library(ggnormalviolin)    # 提琴图
library(ggbeeswarm)        # 蜂群图
library(gert)              # Git 数据操作
library(ggridges)          # 岭线图
library(ggpubr)            # 组合图
library(treemap)           # 树状图
library(treemapify)        # 树状图
library(ggalluvial)        # 桑基图
library(ggmosaic)          # 马赛克图
library(ggbump)            # 凹凸图
library(ggstream)          # 水流图
library(timelineS)         # 时间线
library(ggdendro)          # 聚类图
library(ggfortify)         # 统计分析结果可视化：主成分图
library(gganimate)         # 动态图
```

David Robinson 给出为何使用 ggplot2 [^why-ggplot2] 当然也有 Jeff Leek 指出在某些重要场合不适合 ggplot2 [^why-not-ggplot2] 并且给出强有力的 [证据](http://motioninsocial.com/tufte/)，其实不管怎么样，适合自己的才是好的。也不枉费 Garrick Aden-Buie 花费 160 页幻灯片逐步分解介绍 [优雅的ggplot2](https://pkg.garrickadenbuie.com/gentle-ggplot2)，[Malcolm Barrett](https://malco.io/) 也介绍了 [ggplot2 基础用法](https://malco.io/slides/hs_ggplot2)，还有 Selva Prabhakaran 精心总结给出了 50 个 ggplot2 数据可视化的 [例子](https://r-statistics.co/Top50-Ggplot2-Visualizations-MasterList-R-Code.html) 以及 Victor Perrier 为小白用 ggplot2 操碎了心地开发 RStudio 插件 [esquisse](https://github.com/dreamRs/esquisse) 包，Claus O. Wilke 教你一步步创建出版级的图形 <https://github.com/clauswilke/practical_ggplot2>。

ggplot2 是十分方便的统计作图工具，相比 Base R，为了一张出版级的图形，不需要去调整每个参数，实现快速出图。集成了很多其它统计计算的 R 包，支持丰富的统计分析和计算功能，如回归、平滑等，实现了作图和模型的无缝连接。比如图\@ref(fig:awesome-ggplot2)，使用 loess 局部多项式平滑得到数据的趋势，不仅仅是散点图，代码量也非常少。


```r
ggplot(mpg, aes(displ, hwy)) +
  geom_point(aes(color = class)) +
  geom_smooth(se = TRUE, method = "loess") +
  labs(
    title = "Fuel efficiency generally decreases with engine size",
    subtitle = "Two seaters (sports cars) are an exception because of their light weight",
    caption = "Data from fueleconomy.gov"
  )
```

\begin{figure}

{\centering \includegraphics{data-visualization_files/figure-latex/awesome-ggplot2-1} 

}

\caption{简洁美观}(\#fig:awesome-ggplot2)
\end{figure}

故事源于一幅图片，我不记得第一次见到这幅图是什么时候了，只因多次在多个场合中见过，所以留下了深刻的印象，后来才知道它出自于一篇博文 --- [Using R packages and education to scale Data Science at Airbnb](https://medium.com/airbnb-engineering/using-r-packages-and-education-to-scale-data-science-at-airbnb)，作者 Ricardo Bion 还在其 Github 上传了相关代码^[<https://github.com/ricardo-bion/medium_visualization>]。除此之外还有几篇重要的参考资料：

1. Pablo Barberá 的 [Data Visualization with R and ggplot2](https://github.com/pablobarbera/Rdataviz)
3. Matt Leonawicz 的新作 [mapmate](https://github.com/leonawicz/mapmate), 可以去其主页欣赏系列作品^[<https://leonawicz.github.io/>]
4. [tidytuesday 可视化挑战官方项目](https://github.com/rfordatascience/tidytuesday) 还有 [tidytuesday](https://github.com/abichat/tidytuesday)
5. [ggstatsplot](https://github.com/IndrajeetPatil/ggstatsplot) 可视化统计检验、模型的结果
6. [ggpubr](https://github.com/kassambara/ggpubr) 制作出版级统计图形
7. Thomas Lin Pedersen [Drawing Anything with ggplot2](https://github.com/thomasp85/ggplot2_workshop)
8. [Designing ggplots: making clear figures that communicate](https://designing-ggplots.netlify.app/)
9. [ggh4x](https://github.com/teunbrand/ggh4x) 提供 ggplot2 的额外定制功能
10. [ggdist](https://github.com/mjskay/ggdist) Visualizations of distributions and uncertainty
11. [gghighlight](https://github.com/yutannihilation/gghighlight)
12. [ggnetwork](https://github.com/briatte/ggnetwork)
13. [ggPMX](https://github.com/ggPMXdevelopment/ggPMX) 'ggplot2' Based Tool to Facilitate Diagnostic Plots for NLME Models
14. [ggpp](https://github.com/aphalo/ggpp) ggpp: Grammar Extensions to 'ggplot2'

[^why-ggplot2]: http://varianceexplained.org/r/why-I-use-ggplot2/
[^why-not-ggplot2]: https://simplystatistics.org/2016/02/11/why-i-dont-use-ggplot2/

如 Berton Gunter 所说，数据可视化只是一种手段，根据数据实际情况作展示才是重要的，并不是要追求酷炫。

> 3-D bar plots are an abomination. Just because Excel can do them doesn't mean you should. (Dismount pulpit).
>
> --- Berton Gunter [^BG-help-2007]

[^BG-help-2007]: <https://stat.ethz.ch/pipermail/r-help/2007-October/142420.html>

**grid** 是 **lattice** 和 **ggplot2** 的基础，**gganimate** 是 ggplot2 一个扩展，它将静态图形视为帧，调用第三方工具合成 GIF 动图或 MP4 视频等，要想深入了解 ggplot2，可以去看 [Hadley Wickham](http://hadley.nz), [Danielle Navarro](https://djnavarro.net), and [Thomas Lin Pedersen](https://www.data-imaginist.com) 合著的《ggplot2: elegant graphics for data analysis》第三版 <https://ggplot2-book.org/>。

## 元素 {#sec-elements}

以数据集 airquality 为例介绍 GGplot2 图层、主题、配色、坐标、尺度、注释和组合等

### 图层 {#ggplot2-layer}


```r
ls("package:ggplot2", pattern = "^geom_")
```

```
##  [1] "geom_abline"            "geom_area"              "geom_bar"              
##  [4] "geom_bin_2d"            "geom_bin2d"             "geom_blank"            
##  [7] "geom_boxplot"           "geom_col"               "geom_contour"          
## [10] "geom_contour_filled"    "geom_count"             "geom_crossbar"         
## [13] "geom_curve"             "geom_density"           "geom_density_2d"       
## [16] "geom_density_2d_filled" "geom_density2d"         "geom_density2d_filled" 
## [19] "geom_dotplot"           "geom_errorbar"          "geom_errorbarh"        
## [22] "geom_freqpoly"          "geom_function"          "geom_hex"              
## [25] "geom_histogram"         "geom_hline"             "geom_jitter"           
## [28] "geom_label"             "geom_line"              "geom_linerange"        
## [31] "geom_map"               "geom_path"              "geom_point"            
## [34] "geom_pointrange"        "geom_polygon"           "geom_qq"               
## [37] "geom_qq_line"           "geom_quantile"          "geom_raster"           
## [40] "geom_rect"              "geom_ribbon"            "geom_rug"              
## [43] "geom_segment"           "geom_sf"                "geom_sf_label"         
## [46] "geom_sf_text"           "geom_smooth"            "geom_spoke"            
## [49] "geom_step"              "geom_text"              "geom_tile"             
## [52] "geom_violin"            "geom_vline"
```

生成一个散点图


```r
ggplot(airquality, aes(x = Temp, y = Ozone)) + geom_point()
```

```
## Warning: Removed 37 rows containing missing values (geom_point).
```



\begin{center}\includegraphics{data-visualization_files/figure-latex/unnamed-chunk-3-1} \end{center}


### 标签 {#subsec-axis-label}

图形的标签分为横纵轴标签、刻度标签、主标题、副标题等


```r
data.frame(
  dates = seq.Date(
    from = as.Date("1945-01-01"),
    to = as.Date("1974-12-31"), 
    by = "quarter"
  ),
  presidents = as.vector(presidents)
) |> 
  ggplot(aes(x = dates, y = presidents)) +
  geom_line(color = "slategray", na.rm = TRUE) +
  geom_point(size = 1.5, color = "darkslategray", na.rm = TRUE) +
  scale_x_date(date_breaks = "4 year", date_labels = "%Y") +
  labs(
    title = "1945年至1974年美国总统每季度支持率",
    x = "年份", y = "支持率 (%)",
    caption = "数据源: R 包 datasets"
  ) +
  theme_minimal(base_size = 10.54, base_family = "source-han-sans-cn")
```

\begin{figure}

{\centering \includegraphics[width=0.75\linewidth]{data-visualization_files/figure-latex/approval-ratings-1} 

}

\caption{自1945年第一季度至1974年第四季度美国总统的支持率}(\#fig:approval-ratings)
\end{figure}

<!-- 每个点给出总统的人名，部分给出图片
数据来源 help(presidents) The Gallup Organisation. McNeil, D. R. (1977) Interactive Data Analysis. New York: Wiley.
-->

### 注释 {#subsec-annotation}

图中注释的作用在于高亮指出关键点，提请读者注意。文本注释可由 [**ggrepel**](https://github.com/slowkow/ggrepel) 包提供的标签图层 `geom_label_repel()` 添加，标签数据可独立于之前的数据层，标签所在的位置可以通过参数 `direction` 和 `nudge_y` 精调，图 \@ref(fig:text-annotation) 模拟了一组数据。


```r
set.seed(2020)
library(ggrepel)
dat <- data.frame(
  x = seq(100),
  y = cumsum(rnorm(100))
)
anno_data <- dat |> 
  subset(x %% 25 == 10)  |> 
  transform(text = "text")

ggplot(data = dat, aes(x, y)) +
  geom_line() +
  geom_label_repel(aes(label = text),
    data = anno_data,
    direction = "y",
    nudge_y = c(-5, 5, 5, 5)
  ) +
  theme_minimal()
```

\begin{figure}

{\centering \includegraphics[width=0.75\linewidth]{data-visualization_files/figure-latex/text-annotation-1} 

}

\caption{文本注释}(\#fig:text-annotation)
\end{figure}

**ggrepel** 包的图层 `geom_text_repel()` 支持所有数据点的注释，并且自动调整文本的位置，防止重叠，增加辨识度，如图 \@ref(fig:mtcars-annotation)。当然，数据点如果过于密集也不适合全部注释，高亮其中的关键点即可。


```r
mtcars |> 
  transform(cyl = as.factor(cyl)) |> 
  ggplot(aes(wt, mpg, label = rownames(mtcars), color = cyl)) +
  geom_point() +
  geom_text_repel(max.overlaps = 12) +
  theme_minimal()
```

\begin{figure}

{\centering \includegraphics[width=0.75\linewidth]{data-visualization_files/figure-latex/mtcars-annotation-1} 

}

\caption{少量点的情况下可以全部注释，且可以解决注释重叠的问题}(\#fig:mtcars-annotation)
\end{figure}

Claus Wilke 开发的 [ggtext](https://github.com/wilkelab/ggtext) 包支持更加丰富的注释样式，详见网站 <https://wilkelab.org/ggtext/>


```r
ls("package:ggplot2", pattern = "^annotation_")
```

```
## [1] "annotation_custom"   "annotation_logticks" "annotation_map"     
## [4] "annotation_raster"
```


```r
ggplot(airquality, aes(x = Temp, y = Ozone)) + 
  geom_point(na.rm = TRUE)
```



\begin{center}\includegraphics{data-visualization_files/figure-latex/unnamed-chunk-5-1} \end{center}



```r
ggplot(airquality, aes(x = Temp, y = Ozone)) + 
  geom_point(na.rm = TRUE) +
  labs(title = substitute(paste(d *
    bolditalic(x)[italic(t)] == alpha * (theta - bolditalic(x)[italic(t)]) *
    d * italic(t) + lambda * d * italic(B)[italic(t)]), list(lambda = 4)))
```



\begin{center}\includegraphics{data-visualization_files/figure-latex/math-expr-r-1} \end{center}

### 刻度 {#ggplot2-scale}


```r
ls("package:ggplot2", pattern = "^scale_(x|y)_")
```

```
##  [1] "scale_x_binned"     "scale_x_continuous" "scale_x_date"      
##  [4] "scale_x_datetime"   "scale_x_discrete"   "scale_x_log10"     
##  [7] "scale_x_reverse"    "scale_x_sqrt"       "scale_x_time"      
## [10] "scale_y_binned"     "scale_y_continuous" "scale_y_date"      
## [13] "scale_y_datetime"   "scale_y_discrete"   "scale_y_log10"     
## [16] "scale_y_reverse"    "scale_y_sqrt"       "scale_y_time"
```


```r
range(airquality$Temp, na.rm = TRUE)
```

```
## [1] 56 97
```

```r
range(airquality$Ozone, na.rm = TRUE)
```

```
## [1]   1 168
```

```r
ggplot(airquality, aes(x = Temp, y = Ozone)) + 
  geom_point(na.rm = TRUE) +
  scale_x_continuous(breaks = seq(50, 100, 5)) +
  scale_y_continuous(breaks = seq(0, 200, 20))
```



\begin{center}\includegraphics{data-visualization_files/figure-latex/unnamed-chunk-7-1} \end{center}

### 图例 {#ggplot2-legend}

二维的图例 [biscale](https://github.com/slu-openGIS/biscale) 和 [multiscales](https://github.com/clauswilke/multiscales) 和 [ggnewscale](https://github.com/eliocamp/ggnewscale)


### 坐标系 {#ggplot2-coord}

极坐标，直角坐标


```r
ls("package:ggplot2", pattern = "^coord_")
```

```
##  [1] "coord_cartesian" "coord_equal"     "coord_fixed"     "coord_flip"     
##  [5] "coord_map"       "coord_munch"     "coord_polar"     "coord_quickmap" 
##  [9] "coord_sf"        "coord_trans"
```

### 坐标轴 {#ggplot2-axes}

坐标轴标签位置、大小、字体


### 配色 {#ggplot2-color}


```r
ls("package:ggplot2", pattern = "^scale_(color|fill)_")
```

```
##  [1] "scale_color_binned"     "scale_color_brewer"     "scale_color_continuous"
##  [4] "scale_color_date"       "scale_color_datetime"   "scale_color_discrete"  
##  [7] "scale_color_distiller"  "scale_color_fermenter"  "scale_color_gradient"  
## [10] "scale_color_gradient2"  "scale_color_gradientn"  "scale_color_grey"      
## [13] "scale_color_hue"        "scale_color_identity"   "scale_color_manual"    
## [16] "scale_color_ordinal"    "scale_color_steps"      "scale_color_steps2"    
## [19] "scale_color_stepsn"     "scale_color_viridis_b"  "scale_color_viridis_c" 
## [22] "scale_color_viridis_d"  "scale_fill_binned"      "scale_fill_brewer"     
## [25] "scale_fill_continuous"  "scale_fill_date"        "scale_fill_datetime"   
## [28] "scale_fill_discrete"    "scale_fill_distiller"   "scale_fill_fermenter"  
## [31] "scale_fill_gradient"    "scale_fill_gradient2"   "scale_fill_gradientn"  
## [34] "scale_fill_grey"        "scale_fill_hue"         "scale_fill_identity"   
## [37] "scale_fill_manual"      "scale_fill_ordinal"     "scale_fill_steps"      
## [40] "scale_fill_steps2"      "scale_fill_stepsn"      "scale_fill_viridis_b"  
## [43] "scale_fill_viridis_c"   "scale_fill_viridis_d"
```


```r
ggplot(airquality, aes(x = Temp, y = Ozone, color = as.factor(Month))) +
  geom_point(na.rm = TRUE)
```



\begin{center}\includegraphics{data-visualization_files/figure-latex/unnamed-chunk-10-1} \end{center}

```r
ggplot(airquality, aes(x = Temp, y = Ozone, color = as.ordered(Month))) +
  geom_point(na.rm = TRUE)
```



\begin{center}\includegraphics{data-visualization_files/figure-latex/unnamed-chunk-10-2} \end{center}


### 主题 {#subsec-theme}

[ggcharts](https://github.com/thomas-neitmann/ggcharts) 和 [bbplot](https://github.com/bbc/bbplot)
[prettyB](https://github.com/jumpingrivers/prettyB) 美化 Base R 图形
[ggprism](https://github.com/csdaw/ggprism)


```r
ls("package:ggplot2", pattern = "^theme_")
```

```
##  [1] "theme_bw"       "theme_classic"  "theme_dark"     "theme_get"     
##  [5] "theme_gray"     "theme_grey"     "theme_light"    "theme_linedraw"
##  [9] "theme_minimal"  "theme_replace"  "theme_set"      "theme_test"    
## [13] "theme_update"   "theme_void"
```

这里只展示 `theme_bw()` `theme_void()` `theme_minimal() ` 和 `theme_void()` 等四个常见主题，更多主题参考 [ggsci](https://github.com/nanxstats/ggsci)、[ggthemes](https://github.com/jrnold/ggthemes) 、[ggtech](https://github.com/ricardo-bion/ggtech)、[hrbrthemes](https://github.com/hrbrmstr/hrbrthemes) 和 [ggthemr](https://github.com/cttobin/ggthemr) 包


```r
ggplot(airquality, aes(x = Temp, y = Ozone)) + geom_point() + theme_bw()
```

```
## Warning: Removed 37 rows containing missing values (geom_point).
```

```r
ggplot(airquality, aes(x = Temp, y = Ozone)) + geom_point() + theme_void()
```

```
## Warning: Removed 37 rows containing missing values (geom_point).
```

```r
ggplot(airquality, aes(x = Temp, y = Ozone)) + geom_point() + theme_minimal()
```

```
## Warning: Removed 37 rows containing missing values (geom_point).
```

```r
ggplot(airquality, aes(x = Temp, y = Ozone)) + geom_point() + theme_classic()
```

```
## Warning: Removed 37 rows containing missing values (geom_point).
```

\begin{figure}

{\centering \subfloat[黑白主题(\#fig:builtin-themes-1)]{\includegraphics[width=0.45\linewidth]{data-visualization_files/figure-latex/builtin-themes-1} }\subfloat[无主题(\#fig:builtin-themes-2)]{\includegraphics[width=0.45\linewidth]{data-visualization_files/figure-latex/builtin-themes-2} }\newline\subfloat[极少配置的主题(\#fig:builtin-themes-3)]{\includegraphics[width=0.45\linewidth]{data-visualization_files/figure-latex/builtin-themes-3} }\subfloat[经典主题(\#fig:builtin-themes-4)]{\includegraphics[width=0.45\linewidth]{data-visualization_files/figure-latex/builtin-themes-4} }

}

\caption{ggplot2 内置的主题}(\#fig:builtin-themes)
\end{figure}

除主题之外，还有一类提供一整套统一的风格样式来绘制各种统计图形，如 [ggpubr](https://github.com/kassambara/ggpubr) 和 [bbplot](https://github.com/bbc/bbplot)



### 布局 {#ggplot2-grid}


```r
ggplot(airquality) + 
  geom_point(aes(x = Temp, y = Ozone), na.rm = TRUE) + 
  facet_wrap(~ as.ordered(Month))
```



\begin{center}\includegraphics[width=0.85\linewidth]{data-visualization_files/figure-latex/unnamed-chunk-12-1} \end{center}



```r
ggplot(airquality) + 
  geom_point(aes(x = Temp, y = Ozone), na.rm = TRUE) + 
  facet_wrap(~ as.ordered(Month), nrow = 1)
```



\begin{center}\includegraphics[width=1\linewidth]{data-visualization_files/figure-latex/unnamed-chunk-13-1} \end{center}

[cowplot](https://github.com/wilkelab/cowplot) 是以作者 [Claus O. Wilke](https://wilkelab.org/) 命名的，用来组合 ggplot 对象画图，类似的组合图形的功能包还有 [baptiste auguié](https://baptiste.github.io/) 开发的 [gridExtra](https://CRAN.R-project.org/package=gridExtra) 和 [egg](https://github.com/baptiste/egg)， [Thomas Lin Pedersen](https://www.data-imaginist.com/) 开发的 [patchwork](https://github.com/thomasp85/patchwork)

[Dean Attali](https://deanattali.com/) 开发的 [ggExtra](https://github.com/daattali/ggExtra) 可以在图的边界添加密度估计曲线，直方图等


## 字体 {#sec-fonts}

[firatheme](https://github.com/vankesteren/firatheme) 包提供基于 fira sans 字体的 ggplot2 主题，类似的字体主题包还有 [trekfont](https://github.com/leonawicz/trekfont) 、 [fontHind](https://github.com/bhaskarvk/fontHind)， [fontquiver](https://github.com/lionel-/fontquiver) 包与 fontBitstreamVera（Bitstream Vera 字体）、 [fontLiberation](https://cran.r-project.org/package=fontLiberation)（Liberation 字体）包和 [fontDejaVu](https://github.com/lionel-/fontDejaVu) （DejaVu 字体）包一道提供了一些可允许使用的字体文件，这样，我们可以不依赖系统制作可重复的图形。Thomas Lin Pedersen 开发的 [systemfonts](https://github.com/r-lib/systemfonts) 可直接使用系统自带的字体。

### 系统字体 {#subsec-system-fonts}

以 CentOS 系统为例，软件仓库中包含 [Noto](https://github.com/googlefonts/noto-fonts) ， [DejaVu](https://github.com/dejavu-fonts) 、[liberation](https://github.com/liberationfonts/liberation-fonts) 等字体。可以安装自己喜欢的字体类型，比如：

```bash
sudo dnf install -y \
  google-noto-mono-fonts \
  google-noto-sans-fonts \
  google-noto-serif-fonts \
  dejavu-sans-mono-fonts \
  dejavu-sans-fonts \
  dejavu-serif-fonts
# 或者
sudo dnf install -y dejavu-fonts liberation-fonts
```

liberation 系列的四款字体可以用来替换 Windows 系统上对应的四款字体，对应关系见表 \@ref(tab:fonts-centos-vs-win)

|                 | CentOS 系统             | Windows 系统    |
|:----------------|:------------------------|:----------------|
| 衬线体/宋体     | liberation-serif-fonts  | Times New Roman |
| 无衬线体/黑体   | liberation-sans-fonts   | Arial           |
| Arial 的细瘦版  | liberation-narrow-fonts | Arial Narrow    |
| 等宽体/微软雅黑 | liberation-mono-fonts   | Courier New     |

: (\#tab:fonts-centos-vs-win) Windows 系统上四款字体的替代品

Lionel Henry 将 Liberation 系列字体打包到 R 包 [fontLiberation](https://github.com/lionel-/fontLiberation)，非常便携，不需要操心跨平台的字体安装了。那如何使用呢？


```r
# install.packages("fontLiberation")
system.file(package = "fontLiberation", "fonts", "liberation-fonts")
```

```
## [1] ""
```


此外，我们还可以从网上获取各种个样的字体，特别地，Boryslav Larin 收录的 [awesome-fonts](https://github.com/brabadu/awesome-fonts) 列表是一个不错的开始，比如图标字体 [Font-Awesome](https://github.com/FortAwesome/Font-Awesome)，

```bash
sudo dnf install -y fontawesome-fonts
```

再安装宏包 [fontawesome](https://ctan.org/pkg/fontawesome) 后，即可在 LaTeX 文档中使用，下面这个示例推荐用 XeLaTeX 引擎编译。

```tex
\documentclass[border=10pt]{standalone}
\usepackage{fontawesome}
\begin{document}
Hello, \faGithub
\end{document}
```

而在 R 绘制的图形中，通过指定 `par()`、 `plot()`、 `title()` 等函数的 `family` 参数值，比如 `family = "Liberation Sans"` 来调用系统无衬线 Liberation 字体，效果见图 \@ref(fig:system-fonts-liberation)。



```r
library(extrafont)
plot(data = pressure, pressure ~ temperature, 
     xlab = "Temperature (deg C)", ylab = "Pressure (mm of Hg)",
     col.lab = "red", col.axis = "blue",
     font.lab = 3, font.axis = 2, family = "Liberation Sans")
title(main = "Vapor Pressure of Mercury as a Function of Temperature", 
      family = "Liberation Serif", font.main = 3)
title(sub = "Data Source: Weast, R. C", 
      family = "Liberation Mono", font.sub = 1)
```

\begin{figure}

{\centering \includegraphics[width=0.75\linewidth]{data-visualization_files/figure-latex/system-fonts-liberation-1} 

}

\caption{调用系统字体绘图}(\#fig:system-fonts-liberation)
\end{figure}

为了符合出版的要求，需要在 \@ref(fig:system-fonts-liberation) 中嵌入字体，

```r
# embed fonts to pdf
embed_fonts <- function(fig_path) {
  if(knitr::is_latex_output()){
    embedFonts(
      file = fig_path, outfile = fig_path,
      fontpaths = "~/Library/Fonts"
    )
  }
  return(fig_path)
}
```

设置代码块选项 `fig.process=embed_fonts`，这样生成 PDF 格式图形的时候，会调用此函数处理 PDF 图形。在 ggplot2 绘图中的调用方式是类似的，便不再赘述了。值得注意的是，extrafont 和 showtext 有些不一样，前者只能处理系统字体，后者还能获取网络字体和使用 OTF 字体，下面从 Google 开源的字体库获取 Noto 系列的四款字体，如图 \@ref(fig:font-in-ggplot)。


```r
sysfonts::font_add_google(name = "Noto Sans", family = "Noto Sans")
sysfonts::font_add_google(name = "Noto Serif", family = "Noto Serif")
sysfonts::font_add_google(name = "Noto Serif SC", family = "Noto Serif SC")
sysfonts::font_add_google(name = "Noto Sans SC", family = "Noto Sans SC")
```

::: {.rmdwarn data-latex="{警告}"}
在本书中，不要全局加载 showtext 包或调用 `showtext::showtext_auto()`，会和 extrafont 冲突，使得绘图时默认就只能使用 showtext 提供的字体。extrafont 包提供的函数 `font_import()` 仅支持系统安装的 TrueType/Type1 字体
:::


```r
p1 <- ggplot(pressure, aes(x = temperature, y = pressure)) +
  geom_point() +
  ggtitle(label = "默认字体设置")

p2 <- p1 + theme(
  axis.title = element_text(family = "Noto Sans"),
  axis.text = element_text(family = "Noto Serif")
) +
  theme(
    title = element_text(family = "Noto Serif SC")
  ) +
  ggtitle(label = "英文字体设置")

p3 <- p1 + labs(x = "温度", y = "压力") +
  theme(
    axis.title = element_text(family = "Noto Serif SC"),
    axis.text = element_text(family = "Noto Serif")
  ) +
  ggtitle(label = "中文字体设置")

p4 <- p1 + labs(
  x = "温度", y = "压力", title = "散点图",
  subtitle = "Vapor Pressure of Mercury as a Function of Temperature",
  caption = paste("Data on the relation 
                  between temperature in degrees Celsius and",
    "vapor pressure of mercury in millimeters (of mercury).",
    sep = "\n"
  )
) +
  theme(
    axis.title = element_text(family = "Noto Serif SC"),
    axis.text.x = element_text(family = "Noto Serif"),
    axis.text.y = element_text(family = "Noto Sans"),
    title = element_text(family = "Noto Serif SC"),
    plot.subtitle = element_text(family = "Noto Sans", size = rel(0.7)),
    plot.caption = element_text(family = "Noto Sans", size = rel(0.6))
  ) +
  ggtitle(label = "任意字体设置")

(p1 + p2) / (p3 + p4)
```

\begin{figure}

{\centering \includegraphics[width=1\linewidth]{data-visualization_files/figure-latex/font-in-ggplot-1} 

}

\caption{在 ggplot2 绘图系统中设置中英文字体}(\#fig:font-in-ggplot)
\end{figure}

另外值得一提的是 [hrbrthemes](https://github.com/hrbrmstr/hrbrthemes) 包，除了定制了很多 ggplot2 主题，它还打包了很多的字体主题。比如默认主题 `theme_ipsum()` 使用 Arial Narrow 字体，如果没有该字体就自动寻找系统中的替代品，如图 \@ref(fig:hrbrthemes) 实际使用的是 Nimbus Sans Narrow 字体，因为在 GitHub Action 中，我实际使用的测试环境是 Ubuntu 20.04，该系统自带 Nimbus Sans Narrow 字体，Arial Narrow 毕竟是 Windows 上的闭源字体。


```r
# brew install font-roboto
# 导入字体
# hrbrthemes::import_roboto_condensed()
sysfonts::font_add_google(name = "Roboto Condensed", family = "Roboto Condensed")
```



```r
library(hrbrthemes)
ggplot(mtcars, aes(mpg, wt)) +
  geom_point() +
  labs(
    x = "Fuel efficiency (mpg)", y = "Weight (tons)",
    title = "Seminal ggplot2 scatterplot example",
    subtitle = "A plot that is only useful for demonstration purposes",
    caption = "Brought to you by the letter 'g'"
  ) +
  theme_ipsum(base_family = "Roboto Condensed")
```

\begin{figure}

{\centering \includegraphics[width=0.75\linewidth]{data-visualization_files/figure-latex/hrbrthemes-1} 

}

\caption{调用 hrbrthemes 包设置字体主题}(\#fig:hrbrthemes)
\end{figure}

如果系统没有安装 Arial Narrow 字体，可以导入 hrbrthemes 包自带的一些字体，比如 `hrbrthemes::import_roboto_condensed()`，然后调用字体主题 `theme_ipsum_rc()` 。如果不想使用这个包自带的字体，可以用系统中安装的字体去修改主题 `theme_ipsum()` 和 `theme_ipsum_rc()` 中的字体设置。如图 \@ref(fig:arial-narrow) 使用了 `theme_ipsum()` 中的 Arial Narrow 字体。


```r
ggplot(mtcars, aes(mpg, wt)) +
  geom_point() +
  labs(
    x = "Fuel efficiency (mpg)", y = "Weight (tons)",
    title = "Seminal ggplot2 scatterplot example",
    subtitle = "A plot that is only useful for demonstration purposes",
    caption = "Brought to you by the letter 'g'"
  ) +
  theme_ipsum()
```

\begin{figure}

{\centering \includegraphics[width=0.75\linewidth]{data-visualization_files/figure-latex/arial-narrow-1} 

}

\caption{默认字体 Arial Narrow}(\#fig:arial-narrow)
\end{figure}

::: {.rmdtip data-latex="{提示}"}
**hrbrthemes** 包提供了一个全局字体加载选项 `hrbrthemes.loadfonts` ，如果设置为 TRUE，即 `options(hrbrthemes.loadfonts = TRUE)` 会先调用函数 `extrafont::loadfonts()` 预加载系统字体，就不用一次次手动加载字体了。后续在第 \@ref(subsec-fontcm) 节还会提及 extrafont 包的其它功能。
:::

### 思源字体 {#subsec-showtext}

邱怡轩开发的 [showtext](https://github.com/yixuan/showtext) 包支持丰富的外部字体，支持 Base R 和 ggplot2 图形，图 \@ref(fig:showtext) 嵌入了 5 号思源宋体，图例和坐标轴文本使用 serif 字体，更多详细的使用文档见 [@Qiu2015]。


```r
# 安装 showtext 包
install.packages('showtext')
# 思源宋体
showtextdb::font_install(showtextdb::source_han_serif())
# 思源黑体
showtextdb::font_install(showtextdb::source_han_sans())
```


```r
ggplot(iris, aes(Sepal.Length, Sepal.Width)) +
  geom_point(aes(colour = Species)) +
  scale_colour_brewer(palette = "Set1") +
  labs(
    title = "鸢尾花数据的散点图",
    x = "萼片长度", y = "萼片宽度", colour = "鸢尾花类别",
    caption = "鸢尾花数据集最早见于 Edgar Anderson (1935) "
  ) +
  theme(
    title = element_text(family = "source-han-sans-cn"),
    axis.title = element_text(family = "source-han-serif-cn"),
    legend.title = element_text(family = "source-han-serif-cn")
  )
```

\begin{figure}

{\centering \includegraphics[width=0.75\linewidth]{data-visualization_files/figure-latex/showtext-1} 

}

\caption{showtext 包处理图里的中文}(\#fig:showtext)
\end{figure}

斐济是太平洋上的一个岛国，受地壳板块运动的影响，地震活动频繁，图 \@ref(fig:fiji-earthquake) 清晰展示了它的地震带。


```r
library(maps)
library(mapdata)
FijiMap <- map_data("worldHires", region = "Fiji")
ggplot(FijiMap, aes(x = long, y = lat)) +
  geom_map(map = FijiMap, aes(map_id = region), size = .2) +
  geom_point(data = quakes, aes(x = long, y = lat, colour = mag)) +
  xlim(160, 195) +
  scale_colour_distiller(palette = "Spectral") +
  scale_y_continuous(breaks = (-18:18) * 5) +
  coord_map("ortho", orientation = c(-10, 180, 0)) +
  labs(colour = "震级", x = "经度", y = "纬度", title = "斐济地震带") +
  theme_minimal() +
  theme(
    title = element_text(family = "source-han-sans-cn"),
    axis.title = element_text(family = "source-han-serif-cn"),
    legend.title = element_text(family = "source-han-sans-cn"),
    legend.position = c(1, 0), legend.justification = c(1, 0)
  )
```

\begin{figure}

{\centering \includegraphics[width=0.75\linewidth]{data-visualization_files/figure-latex/fiji-earthquake-1} 

}

\caption{斐济地震带}(\#fig:fiji-earthquake)
\end{figure}

### 数学字体 {#subsec-fontcm}

Winston Chang 将 Paul Murrell 的 Computer Modern 字体文件打包成 [fontcm](https://github.com/wch/fontcm) 包 [@fontcm]，**fontcm** 包可以在 Base R 图形中嵌入数学字体 [^font-cmr]，图形中嵌入重音字符 [^font-maori]。 下面先下载、安装、加载字体，

[^font-cmr]: <https://www.stat.auckland.ac.nz/~paul/R/CM/CMR.html>

[^font-maori]: <https://www.stat.auckland.ac.nz/~paul/Reports/maori/maori.html>


```r
library(extrafont)
font_addpackage(pkg = "fontcm")
```

查看可被 `pdf()` 图形设备使用的字体列表


```r
# 可用的字体
fonts()
```

```
##  [1] "CM Roman"               "CM Roman Asian"         "CM Roman CE"           
##  [4] "CM Roman Cyrillic"      "CM Roman Greek"         "CM Sans"               
##  [7] "CM Sans Asian"          "CM Sans CE"             "CM Sans Cyrillic"      
## [10] "CM Sans Greek"          "CM Symbol"              "CM Typewriter"         
## [13] "CM Typewriter Asian"    "CM Typewriter CE"       "CM Typewriter Cyrillic"
## [16] "CM Typewriter Greek"
```

fontcm 包提供数学字体，`grDevices::embedFonts()` 函数调用 Ghostscript 软件将数学字体嵌入 ggplot2 图形中，达到正确显示数学公式的目的，此方法适用于 pdf 设备保存的图形，对 `cairo_pdf()` 保存的 PDF 格式图形无效。


```r
library(fontcm)
library(ggplot2)
library(extrafont)
library(patchwork)
p <- ggplot(
  data = data.frame(x = c(1, 5), y = c(1, 5)),
  aes(x = x, y = y)
) +
  geom_point() +
  labs(
    x = "Made with CM fonts", y = "Made with CM fonts",
    title = "Made with CM fonts"
  )
# 公式
eq <- "italic(sum(frac(1, n*'!'), n==0, infinity) ==
       lim(bgroup('(', 1 + frac(1, n), ')')^n, n %->% infinity))"
# 默认字体
p1 <- p + annotate("text",
  x = 3, y = 3,
  parse = TRUE, label = eq # , family = "CM Roman"
)
# 使用 CM Roman 字体
p2 <- p + annotate("text",
  x = 3, y = 3,
  parse = TRUE, label = eq, family = "CM Roman"
) +
  theme(
    text = element_text(size = 10, family = "CM Roman"),
    axis.title.x = element_text(face = "italic"),
    axis.title.y = element_text(face = "bold")
  )
p1 + p2
```

\begin{figure}

{\centering \includegraphics{data-visualization_files/figure-latex/fontcm-1} 

}

\caption{fontcm 处理数学公式}(\#fig:fontcm)
\end{figure}

为实现图 \@ref(fig:fontcm) 的最终效果，需要启用一个有超级牛力的 [fig.process](https://yihui.org/knitr/options/#plots) 选项，主要是传递一个函数给它，对用 R 语言生成的图形再操作。

```r
# embed math fonts to pdf
embed_math_fonts <- function(fig_path) {
  if(knitr::is_latex_output()){
    embedFonts(
      file = fig_path, outfile = fig_path,
      fontpaths = system.file("fonts", package = "fontcm")
    )
  }
  return(fig_path)
}
```

代码块选项中设置 `fig.process=embed_math_fonts` 可在绘图后，立即插入字体，此操作仅限于以 pdf 格式保存的图形设备，也适用于 Base R 绘制的图形，见图 \@ref(fig:embed-math-fonts)。


```r
par(mar = c(4.1, 4.1, 1.5, 0.5), family = "CM Roman")
x <- seq(-4, 4, len = 101)
y <- cbind(sin(x), cos(x))
matplot(x, y,
  type = "l", xaxt = "n",
  main = expression(paste(
    plain(sin) * phi, "  and  ",
    plain(cos) * phi
  )),
  ylab = expression("sin" * phi, "cos" * phi),
  xlab = expression(paste("Phase Angle ", phi)),
  col.main = "blue"
)
axis(1,
  at = c(-pi, -pi / 2, 0, pi / 2, pi),
  labels = expression(-pi, -pi / 2, 0, pi / 2, pi)
)
```

\begin{figure}

{\centering \includegraphics{data-visualization_files/figure-latex/embed-math-fonts-1} 

}

\caption{嵌入数学字体}(\#fig:embed-math-fonts)
\end{figure}

### TikZ 设备 {#subsec-tikz-device}

与 \@ref(subsec-fontcm) 小节不同，Ralf Stubner 维护的 [**tikzDevice**](https://github.com/daqana/tikzDevice) 包提供了另一种嵌入数学字体的方式，其提供的 `tikzDevice::tikz()` 绘图设备将图形对象转化为 TikZ 代码，调用 LaTeX 引擎编译成 PDF 文档。安装后，先测试一下 LaTeX 编译环境是否正常。


```r
tikzDevice::tikzTest()
```

```
## 
## Active compiler:
## 	/home/runner/.TinyTeX/bin/x86_64-linux/xelatex
## 	XeTeX 3.141592653-2.6-0.999993 (TeX Live 2021)
## 	kpathsea version 6.3.3
```

```
## [1] 7.90259
```

确认没有问题后，下面图 \@ref(fig:tikz-regression) 的坐标轴标签，标题，图例等位置都支持数学公式，使用 **tikzDevice** 打造出版级的效果图。更多功能的介绍见 <https://www.daqana.org/tikzDevice/>。


```r
x <- rnorm(10)
y <- x + rnorm(5, sd = 0.25)
model <- lm(y ~ x)
rsq <- summary(model)$r.squared
rsq <- signif(rsq, 4)
plot(x, y,
  main = "Hello \\LaTeX!", xlab = "$x$", ylab = "$y$",
  sub = "$\\mathcal{N}(x;\\mu,\\Sigma)$"
)
abline(model, col = "red")
mtext(paste0("Linear model: $R^{2}=", rsq, "$"), line = 0.5)
legend("bottomright",
  legend = paste0(
    "$y = ",
    round(coef(model)[2], 3),
    "x +",
    round(coef(model)[1], 3),
    "$"
  ),
  bty = "n"
)
```

\begin{figure}

{\centering \includegraphics[width=0.75\linewidth]{data-visualization_files/figure-latex/tikz-regression-1} 

}

\caption{线性回归模型}(\#fig:tikz-regression)
\end{figure}

推荐的全局 LaTeX 环境配置如下：


```r
options(
  tinytex.engine = "xelatex",
  tikzDefaultEngine = "xetex",
  tikzDocumentDeclaration = "\\documentclass[tikz]{standalone}\n",
  tikzXelatexPackages = c(
    "\\usepackage[fontset=adobe]{ctex}",
    "\\usepackage[default,semibold]{sourcesanspro}",
    "\\usepackage{amsfonts,mathrsfs,amssymb}\n"
  )
)
```

设置默认的 LaTeX 编译引擎为 XeLaTeX，相比于 PDFLaTeX，它对中文的兼容性更好，支持多平台下的中文环境，中文字体这里采用了 Adobe 的字体，默认加载了 mathrsfs 宏包支持 `\mathcal`、`\mathscr` 等命令，此外， LaTeX 发行版采用谢益辉自定义的 [TinyTeX](https://yihui.org/tinytex/)。绘制独立的 PDF 图形的过程如下：


```r
library(tikzDevice)
tf <- file.path(getwd(), "tikz-regression.tex")
tikz(tf, width = 6, height = 5.5, pointsize = 30, standAlone = TRUE)
# 绘图代码
dev.off()
# 编译成 PDF 图形
tinytex::latexmk(file = "tikz-regression.tex")
```

### 漫画字体 {#subsec-xkcd-comic}

下载 XKCD 字体，并刷新系统字体缓存

```bash
mkdir -p ~/.fonts
curl -fLo ~/.fonts/xkcd.ttf http://simonsoftware.se/other/xkcd.ttf
fc-cache -fsv
```

将 XKCD 字体导入到 R 环境，以便后续被 ggplot2 图形设备调用。

```r
R -e 'library(extrafont);font_import(pattern="[X/x]kcd.ttf", prompt = FALSE)'
```

图 \@ref(fig:xkcd-graph) 是一个使用 xkcd 字体的简单例子，更多高级特性请看 **xkcd** 包文档 [@xkcd]


```r
library(extrafont)
library(xkcd)
ggplot(aes(mpg, wt), data = mtcars) +
  geom_point() +
  theme_xkcd()
```

```
## Warning in theme_xkcd(): Not xkcd fonts installed! See vignette("xkcd-intro")
```

\begin{figure}

{\centering \includegraphics[width=0.75\linewidth]{data-visualization_files/figure-latex/xkcd-graph-1} 

}

\caption{漫画风格的字体方案}(\#fig:xkcd-graph)
\end{figure}

### 表情字体 {#subsec-emoji-fonts}

余光创开发的 [emojifont](https://github.com/GuangchuangYu/emojifont) 包和 Hadley 开发的 [emo](https://github.com/hadley/emo) 包，下面使用 Noto Emoji 字体，支持的表情图见 <https://www.google.com/get/noto/help/emoji/food-drink/>，下面给出一个示例。先从 GitHub 安装
**emo** 包，目前它还未正式发布到 CRAN 上。


```r
remotes::install_github("hadley/emo")
```

除了安装 emo 包，系统需要先安装好 emoji 字体，图形才会正确地渲染出来，想调用更多 emoji 图标请参考 [Emoji 速查手册](https://github.com/ikatyang/emoji-cheat-sheet)，给出 emoji 对应的名字。

```bash
# CentOS
sudo dnf install -y google-noto-emoji-color-fonts \
  google-noto-emoji-fonts
# MacOS
brew cask install font-noto-color-emoji font-noto-emoji
```




```r
data.frame(
  category = c("pineapple", "apple", "watermelon", "mango", "pear"),
  value = c(5, 4, 3, 6, 2)
) |> 
  transform(category = sapply(category, emo::ji)) |> 
  ggplot(aes(x = category, y = value)) +
  scale_y_continuous(limits = c(2, 7)) +
  geom_text(aes(label = category), size = 12, vjust = -0.5) +
  theme_minimal()
```

\begin{figure}

{\centering \includegraphics[width=0.75\linewidth]{data-visualization_files/figure-latex/emoji-fonts-online-1} 

}

\caption{表情字体}(\#fig:emoji-fonts-online)
\end{figure}

Noto Color Emoji 字体在 MacOS 上有问题，为了跨平台的便携性，提供 emojifont 包的例子，要引入更多的依赖。


```r
library(ggplot2)
library(emojifont)

names <- c("smile", "school", "office", "blush", "smirk", "heart_eyes")
n <- length(names):1
e <- sapply(names, emojifont::emoji)
dat <- data.frame(emoji_name = names, n = n, emoji = e, stringsAsFactors = F)

ggplot(data = dat, aes(emoji_name, n)) +
  geom_bar(stat = "identity") +
  scale_x_discrete(breaks = dat$emoji_name, labels = dat$emoji) +
  theme(axis.text.y = element_text(size = 20, family = "EmojiOne")) +
  coord_flip()
```

## 配色 {#sec-colors}

配色真的是一门学问，有的人功力非常深厚，仅用黑白灰就可以创造出一个世界，如中国的水墨画，科波拉执导的《教父》，沃卓斯基姐妹执导的《黑客帝国》等。黑西装、白衬衫和黑领带是《黑客帝国》的经典元素，《教父》开场的黑西装、黑领结和白衬衫，尤其胸前的红玫瑰更是点睛之笔。导演将黑白灰和光影混合形成了层次丰富立体的画面，打造了一场视觉盛宴，无论是呈现在纸上还是银幕上都可以给人留下深刻的印象。正所谓食色性也，花花世界，岂能都是法印眼中的白骨！再说《红楼梦》里，芍药丛中，桃花树下，滴翠亭边，栊翠庵里，处处都是湘云、黛玉、宝钗、妙玉留下的四季诗歌。

为什么需要这么多颜色模式呢？主要取决于颜色输出的通道，比如印刷机，照相机，自然界，网页，人眼等，显示器因屏幕和分辨率的不同呈现的色彩数量是不一样的。读者大概都听说过 RGB、CMYK、AdobeRGB、sRGB、P3 广色域等名词，我想这主要归功于各大电子设备厂商的宣传。普清、高清、超高清、全高清、2K、4K、5K、视网膜屏，而 HSV、HCL 估计听说的人就少很多了。本节的目的是简单阐述背后的色彩原理，颜色模式及其之间的转化，在应对天花乱坠的销售时少交一些智商税，同时，告诉读者如何在 R 环境中使用色彩。早些时候我在统计之都论坛上发帖 -- R语言绘图用调色板大全 <https://d.cosx.org/d/419378>，如果读者希望拿来即用，不妨去看看。


```r
filled.contour(volcano, nlevels = 10, color.palette = terrain.colors)
filled.contour(volcano, nlevels = 10, color.palette = heat.colors)
filled.contour(volcano, nlevels = 10, color.palette = topo.colors)
filled.contour(volcano, nlevels = 10, color.palette = cm.colors)
```

\begin{figure}

{\centering \subfloat[terrain.colors 调色板(\#fig:old-color-palette-1)]{\includegraphics[width=0.45\linewidth]{data-visualization_files/figure-latex/old-color-palette-1} }\subfloat[heat.colors 调色板(\#fig:old-color-palette-2)]{\includegraphics[width=0.45\linewidth]{data-visualization_files/figure-latex/old-color-palette-2} }\newline\subfloat[topo.colors 调色板(\#fig:old-color-palette-3)]{\includegraphics[width=0.45\linewidth]{data-visualization_files/figure-latex/old-color-palette-3} }\subfloat[cm.colors 调色板(\#fig:old-color-palette-4)]{\includegraphics[width=0.45\linewidth]{data-visualization_files/figure-latex/old-color-palette-4} }

}

\caption{R 3.6.0 以前的调色板}(\#fig:old-color-palette)
\end{figure}


```r
filled.contour(volcano,
  nlevels = 10,
  color.palette = function(n, ...) hcl.colors(n, "Grays", rev = TRUE, ...)
)
filled.contour(volcano,
  nlevels = 10,
  color.palette = function(n, ...) hcl.colors(n, "YlOrRd", rev = TRUE, ...)
)
filled.contour(volcano,
  nlevels = 10,
  color.palette = function(n, ...) hcl.colors(n, "purples", rev = TRUE, ...)
)
filled.contour(volcano,
  nlevels = 10,
  color.palette = function(n, ...) hcl.colors(n, "viridis", rev = FALSE, ...)
)
```

\begin{figure}

{\centering \subfloat[Grays 调色板(\#fig:new-color-palette-1)]{\includegraphics[width=0.45\linewidth]{data-visualization_files/figure-latex/new-color-palette-1} }\subfloat[YlOrRd 调色板(\#fig:new-color-palette-2)]{\includegraphics[width=0.45\linewidth]{data-visualization_files/figure-latex/new-color-palette-2} }\newline\subfloat[Purples 3 调色板(\#fig:new-color-palette-3)]{\includegraphics[width=0.45\linewidth]{data-visualization_files/figure-latex/new-color-palette-3} }\subfloat[Viridis 调色板(\#fig:new-color-palette-4)]{\includegraphics[width=0.45\linewidth]{data-visualization_files/figure-latex/new-color-palette-4} }

}

\caption{R 3.6.0 以后的调色板}(\#fig:new-color-palette)
\end{figure}

::: {.rmdnote data-latex="{注意}"}
`hcl.colors()` 函数是在 R 3.6.0 引入的，之前的 R 软件版本中没有，同时内置了 110 个调色板，详见 `hcl.pals()`。
:::

<!--
R Colors in CSS for R Markdown HTML Documents
https://www.garrickadenbuie.com/blog/r-colors-css/

https://www.garrickadenbuie.com/blog/ 及其系列博客
-->

### 调色板 {#subsec-color-palettes}

R 预置的灰色有224种，挑出其中的调色板


```r
grep("^gr(a|e)y", grep("gr(a|e)y", colors(), value = TRUE), 
     value = TRUE, invert = TRUE)
```

```
##  [1] "darkgray"       "darkgrey"       "darkslategray"  "darkslategray1"
##  [5] "darkslategray2" "darkslategray3" "darkslategray4" "darkslategrey" 
##  [9] "dimgray"        "dimgrey"        "lightgray"      "lightgrey"     
## [13] "lightslategray" "lightslategrey" "slategray"      "slategray1"    
## [17] "slategray2"     "slategray3"     "slategray4"     "slategrey"
```


```r
gray_colors <- paste0(rep(c("slategray", "darkslategray"), each = 4), seq(4))
barplot(1:8, col = gray_colors, border = NA)
```

\begin{figure}

{\centering \includegraphics{data-visualization_files/figure-latex/gray-palettes-1} 

}

\caption{灰度调色板}(\#fig:gray-palettes)
\end{figure}

gray 与 grey 是一样的，类似 color 和 colour 的关系，可能是美式和英式英语的差别，且看


```r
all.equal(
  col2rgb(paste0("gray", seq(100))),
  col2rgb(paste0("grey", seq(100)))
)
```

```
## [1] TRUE
```

`gray100` 代表白色，`gray0` 代表黑色，提取灰色调色板，去掉首尾部分是必要的


```r
barplot(1:8,
  col = gray.colors(8, start = .3, end = .9),
  main = "gray.colors function", border = NA
)
```

\begin{figure}

{\centering \includegraphics{data-visualization_files/figure-latex/gray-colors-1} 

}

\caption{提取 10 种灰色做调色板}(\#fig:gray-colors)
\end{figure}

首先选择一组合适的颜色，比如从桃色到梨色，选择6种颜色，以此为基础，可以借助 `grDevices::colorRampPalette()` 函数扩充至想要的数目，用 `graphics::rect()` 函数预览这组颜色配制的调色板


```r
# Colors from https://github.com/johannesbjork/LaCroixColoR
colors_vec <- c("#FF3200", "#E9A17C", "#E9E4A6", 
                "#1BB6AF", "#0076BB", "#172869")
# 代码来自 ?colorspace::rainbow_hcl
pal <- function(n = 20, colors = colors, border = "light gray", ...) {
  colorname <- (grDevices::colorRampPalette(colors))(n)
  plot(0, 0,
    type = "n", xlim = c(0, 1), ylim = c(0, 1),
    axes = FALSE, ...
  )
  rect(0:(n - 1) / n, 0, 1:n / n, 1, col = colorname, border = border)
}
par(mar = rep(0, 4))
pal(n = 20, colors = colors_vec, xlab = "Colors from Peach to Pear", ylab = "")
```

\begin{figure}

{\centering \includegraphics{data-visualization_files/figure-latex/peach-pear-palette-1} 

}

\caption{桃色至梨色的渐变}(\#fig:peach-pear-palette)
\end{figure}

`colorRampPalette()` 自制调色板


```r
create_palette <- function(n = 1000, colors = c("blue", "orangeRed")) {
  color_palette <- colorRampPalette(colors)(n)
  barplot(rep(1, times = n), col = color_palette, 
          border = color_palette, axes = FALSE)
}
par(mfrow = c(3, 1), mar = c(0.1, 0.1, 0.5, 0.1), xaxs = "i", yaxs = "i")
create_palette(n = 1000, colors = c("blue", "orangeRed"))
create_palette(n = 1000, colors = c("darkgreen", "yellow", "orangered"))
create_palette(n = 1000, colors = c("blue", "white", "orangered"))
```

\begin{figure}

{\centering \includegraphics{data-visualization_files/figure-latex/custom-palettes-1} 

}

\caption{colorRampPalette 自制调色板}(\#fig:custom-palettes)
\end{figure}


```r
par(mar = c(0, 4, 0, 0))
RColorBrewer::display.brewer.all()
```

\begin{figure}

{\centering \includegraphics{data-visualization_files/figure-latex/rcolorbrewer-palette-1} 

}

\caption{RColorBrewer 调色板}(\#fig:rcolorbrewer-palette)
\end{figure}


```r
# 代码来自 ?palettes
demo.pal <- function(n, border = if (n < 32) "light gray" else NA,
           main = paste("color palettes: alpha = 1,  n=", n),
           ch.col = c(
             "rainbow(n, start=.7, end=.1)", "heat.colors(n)",
             "terrain.colors(n)", "topo.colors(n)",
             "cm.colors(n)", "gray.colors(n, start = 0.3, end = 0.9)"
           )) {
    nt <- length(ch.col)
    i <- 1:n
    j <- n / nt
    d <- j / 6
    dy <- 2 * d
    plot(i, i + d, type = "n", axes = FALSE, ylab = "", xlab = "", main = main)
    for (k in 1:nt) {
      rect(i - .5, (k - 1) * j + dy, i + .4, k * j,
        col = eval(parse(text = ch.col[k])), border = border
      )
      text(2 * j, k * j + dy / 4, ch.col[k])
    }
  }
n <- if (.Device == "postscript") 64 else 16
# Since for screen, larger n may give color allocation problem
par(mar = c(0, 0, 2, 0))
demo.pal(n)
```

\begin{figure}

{\centering \includegraphics{data-visualization_files/figure-latex/builtin-palettes-1} 

}

\caption{grDevices 调色板 }(\#fig:builtin-palettes)
\end{figure}


```r
par(mfrow = c(33, 1), mar = c(0, 0, .8, 0))
for (i in seq(32)) {
  pal(
    n = length((1 + 20 * (i - 1)):(20 * i)),
    colors()[(1 + 20 * (i - 1)):(20 * i)],
    main = paste(1 + 20 * (i - 1), "to", 20 * i)
  )
}
pal(n = 17, colors()[641:657], main = "641 to 657")
```

\begin{figure}

{\centering \includegraphics[width=1\linewidth]{data-visualization_files/figure-latex/demo-colors-1} 

}

\caption{grDevices 调色板}(\#fig:demo-colors)
\end{figure}


```r
library(colorspace)
## a few useful diverging HCL palettes
par(mar = c(0,0,2,0), mfrow = c(16, 2))

pal(n = 16, diverge_hcl(16), main = "diverging HCL palettes")
pal(n = 16, diverge_hcl(16, h = c(246, 40), c = 96, l = c(65, 90)))
pal(n = 16, diverge_hcl(16, h = c(130, 43), c = 100, l = c(70, 90)))
pal(n = 16, diverge_hcl(16, h = c(180, 70), c = 70, l = c(90, 95)))

pal(n = 16, diverge_hcl(16, h = c(180, 330), c = 59, l = c(75, 95)))
pal(n = 16, diverge_hcl(16, h = c(128, 330), c = 98, l = c(65, 90)))
pal(n = 16, diverge_hcl(16, h = c(255, 330), l = c(40, 90)))
pal(n = 16, diverge_hcl(16, c = 100, l = c(50, 90), power = 1))

## sequential palettes
pal(n = 16, sequential_hcl(16), main= "sequential palettes")
pal(n = 16, heat_hcl(16, h = c(0, -100), 
                     l = c(75, 40), c = c(40, 80), power = 1))
pal(n = 16, terrain_hcl(16, c = c(65, 0), l = c(45, 95), power = c(1/3, 1.5)))
pal(n = 16, heat_hcl(16, c = c(80, 30), l = c(30, 90), power = c(1/5, 1.5)))

## compare base and colorspace palettes
## (in color and desaturated)
## diverging red-blue colors
pal(n = 16, diverge_hsv(16), main = "diverging red-blue colors")
pal(n = 16, diverge_hcl(16, c = 100, l = c(50, 90)))
pal(n = 16, desaturate(diverge_hsv(16)))
pal(n = 16, desaturate(diverge_hcl(16, c = 100, l = c(50, 90))))

## diverging cyan-magenta colors
pal(n = 16, cm.colors(16), main = "diverging cyan-magenta colors")
pal(n = 16, diverge_hcl(16, h = c(180, 330), c = 59, l = c(75, 95)))
pal(n = 16, desaturate(cm.colors(16)))
pal(n = 16, desaturate(diverge_hcl(16, h = c(180, 330), c = 59, l = c(75, 95))))

## heat colors
pal(n = 16, heat.colors(16), main = "heat colors")
pal(n = 16, heat_hcl(16))
pal(n = 16, desaturate(heat.colors(16)))
pal(n = 16, desaturate(heat_hcl(16)))

## terrain colors
pal(n = 16, terrain.colors(16), main = "terrain colors")
pal(n = 16, terrain_hcl(16))
pal(n = 16, desaturate(terrain.colors(16)))
pal(n = 16, desaturate(terrain_hcl(16)))

pal(n = 16, rainbow_hcl(16, start = 30, end = 300), main = "dynamic")
pal(n = 16, rainbow_hcl(16, start = 60, end = 240), main = "harmonic")
pal(n = 16, rainbow_hcl(16, start = 270, end = 150), main = "cold")
pal(n = 16, rainbow_hcl(16, start = 90, end = -30), main = "warm")
```

\begin{figure}

{\centering \includegraphics{data-visualization_files/figure-latex/colorspace-palette-1} 

}

\caption{colorspace 调色板}(\#fig:colorspace-palette)
\end{figure}

除之前提到的 **grDevices** 包， [**colorspace**](https://colorspace.r-forge.r-project.org/) (<https://hclwizard.org/>) 包 [@colorspace_2009_rainbow; @colorspace_2009_rgb; @colorspace_2019]，[RColorBrewer](https://CRAN.R-project.org/package=RColorBrewer) 包 [@RColorBrewer] <https://colorbrewer2.org/>，[viridis](https://github.com/sjmgarnier/viridis) 包、[colourvalues](https://github.com/SymbolixAU/colourvalues)、[wesanderson](https://github.com/karthik/wesanderson)、[dichromat](https://CRAN.R-project.org/package=dichromat) 包、[pals](https://github.com/kwstat/pals) 包，[palr](https://github.com/AustralianAntarcticDivision/palr) 包，[colorRamps](https://cran.r-project.org/package=colorRamps) 包、[ColorPalette](https://cran.r-project.org/package=ColorPalette) 包、[colortools](https://cran.r-project.org/package=colortools) 包就不一一详细介绍了。

[colormap](https://github.com/bhaskarvk/colormap) 包基于 node.js 的 colormap 模块提供 44 个预定义的调色板
[paletteer](https://github.com/EmilHvitfeldt/paletteer) 包收集了很多 R 包提供的调色板，同时也引入了很多依赖。根据电影 Harry Potter 制作的调色板 [harrypotter](https://github.com/aljrico/harrypotter)，根据网站 [CARTO](https://carto.com/) 设计的 [rcartocolor](https://github.com/Nowosad/rcartocolor) 包，[colorblindr](https://github.com/clauswilke/colorblindr) 模拟色盲环境下的配色方案。

[yarrr](https://github.com/ndphillips/yarrr) 包主要是为书籍 [《YaRrr! The Pirate's Guide to R》](https://bookdown.org/ndphillips/YaRrr/) <https://github.com/ndphillips/ThePiratesGuideToR> 提供配套资源，兼顾收集了一组[调色板](https://bookdown.org/ndphillips/YaRrr/more-colors.html)。


::: {.rmdnote data-latex="{注意}"}
RColorBrewer 调色板数量必须至少 3 个，这是上游 colorbrewer 的 [问题](https://github.com/axismaps/colorbrewer/issues/23)，具体体现在调用
`RColorBrewer::brewer.pal(n = 2, name = "Set2")` 时会有警告。 plotly 调用

```
[1] "#66C2A5" "#FC8D62" "#8DA0CB"
Warning message:
In RColorBrewer::brewer.pal(n = 2, name = "Set2") :
  minimal value for n is 3, returning requested palette with 3 different levels
```
:::


```r
par(mar = c(1, 2, 1, 0), mfrow = c(3, 2))
set.seed(1234)
x <- sample(seq(8), 8, replace = FALSE)
barplot(x, col = palette(), border = "white")
barplot(x, col = heat.colors(8), border = "white")
barplot(x, col = gray.colors(8), border = "white")
barplot(x, col = "lightblue", border = "white")
barplot(x, col = colorspace::sequential_hcl(8), border = "white")
barplot(x, col = colorspace::diverge_hcl(8,
  h = c(130, 43),
  c = 100, l = c(70, 90)
), border = "white")
```

\begin{figure}

{\centering \includegraphics{data-visualization_files/figure-latex/select-color-1} 

}

\caption{源起}(\#fig:select-color)
\end{figure}

与图 \@ref(fig:geom-tile) 对比，图\@ref(fig:palette-spectral) 的层次更加丰富，识别性更高


```r
expand.grid(months = month.abb, years = 1949:1960) |> 
  transform(num = as.vector(AirPassengers)) |> 
  ggplot(aes(x = years, y = months, fill = num)) +
  scale_fill_distiller(palette = "Spectral") +
  geom_tile(color = "white", size = 0.4) +
  scale_x_continuous(
    expand = c(0.01, 0.01),
    breaks = seq(1949, 1960, by = 1),
    labels = 1949:1960
  ) +
  theme_minimal(
    base_size = 10.54,
    base_family = "source-han-serif-cn"
  ) +
  labs(x = "年", y = "月", fill = "人数")
```

\begin{figure}

{\centering \includegraphics{data-visualization_files/figure-latex/palette-spectral-1} 

}

\caption{Spectral 调色板}(\#fig:palette-spectral)
\end{figure}

再举例子，图 \@ref(fig:faithfuld) 是正负例对比，其中好在哪里呢？这张图要表达美国黄石国家公园的老忠实泉间歇喷发的时间规律，那么好的标准就是层次分明，以突出不同颜色之间的时间差异。这个差异，还要看起来不那么费眼睛，一目了然最好。


```r
erupt <- ggplot(faithfuld, aes(waiting, eruptions, fill = density)) +
  geom_raster() +
  scale_x_continuous(NULL, expand = c(0, 0)) +
  scale_y_continuous(NULL, expand = c(0, 0)) +
  theme(legend.position = "none")
p1 <- erupt + scale_fill_gradientn(colours = gray.colors(7))
p2 <- erupt + scale_fill_distiller(palette = "Spectral")
p3 <- erupt + scale_fill_gradientn(colours = terrain.colors(7))
p4 <- erupt + scale_fill_continuous(type = 'viridis')
(p1 + p2) / (p3 + p4)
```

\begin{figure}

{\centering \includegraphics{data-visualization_files/figure-latex/faithfuld-1} 

}

\caption{美国黄石国家公园的老忠实泉}(\#fig:faithfuld)
\end{figure}

RColorBrewer 包 提供了有序 (Sequential) 、定性 (Qualitative) 和发散 (Diverging) 三类调色板，一般来讲，分别适用于连续或有序分类变量、无序分类变量、两类分层对比变量的绘图。再加上强大的 ggplot2 包内置的对颜色处理的函数，如 `scale_alpha_*` 、 `scale_colour_*` 和 `scale_fill_*` 等，详见：


```r
ls("package:ggplot2", pattern = "scale_col(ou|o)r_")
```

```
##  [1] "scale_color_binned"      "scale_color_brewer"     
##  [3] "scale_color_continuous"  "scale_color_date"       
##  [5] "scale_color_datetime"    "scale_color_discrete"   
##  [7] "scale_color_distiller"   "scale_color_fermenter"  
##  [9] "scale_color_gradient"    "scale_color_gradient2"  
## [11] "scale_color_gradientn"   "scale_color_grey"       
## [13] "scale_color_hue"         "scale_color_identity"   
## [15] "scale_color_manual"      "scale_color_ordinal"    
## [17] "scale_color_steps"       "scale_color_steps2"     
## [19] "scale_color_stepsn"      "scale_color_viridis_b"  
## [21] "scale_color_viridis_c"   "scale_color_viridis_d"  
## [23] "scale_colour_binned"     "scale_colour_brewer"    
## [25] "scale_colour_continuous" "scale_colour_date"      
## [27] "scale_colour_datetime"   "scale_colour_discrete"  
## [29] "scale_colour_distiller"  "scale_colour_fermenter" 
## [31] "scale_colour_gradient"   "scale_colour_gradient2" 
## [33] "scale_colour_gradientn"  "scale_colour_grey"      
## [35] "scale_colour_hue"        "scale_colour_identity"  
## [37] "scale_colour_manual"     "scale_colour_ordinal"   
## [39] "scale_colour_steps"      "scale_colour_steps2"    
## [41] "scale_colour_stepsn"     "scale_colour_viridis_b" 
## [43] "scale_colour_viridis_c"  "scale_colour_viridis_d"
```

```r
ls("package:ggplot2", pattern = "scale_fill_")
```

```
##  [1] "scale_fill_binned"     "scale_fill_brewer"     "scale_fill_continuous"
##  [4] "scale_fill_date"       "scale_fill_datetime"   "scale_fill_discrete"  
##  [7] "scale_fill_distiller"  "scale_fill_fermenter"  "scale_fill_gradient"  
## [10] "scale_fill_gradient2"  "scale_fill_gradientn"  "scale_fill_grey"      
## [13] "scale_fill_hue"        "scale_fill_identity"   "scale_fill_manual"    
## [16] "scale_fill_ordinal"    "scale_fill_steps"      "scale_fill_steps2"    
## [19] "scale_fill_stepsn"     "scale_fill_viridis_b"  "scale_fill_viridis_c" 
## [22] "scale_fill_viridis_d"
```

colourlovers 包借助 XML, jsonlite 和 httr 包可以在线获取网站 [COLOURlovers](https://www.colourlovers.com/) 的调色板


```r
library(colourlovers)
palette1 <- clpalette('113451')
palette2 <- clpalette('92095')
palette3 <- clpalette('629637')
palette4 <- clpalette('694737')
```

使用调色板


```r
layout(matrix(1:4, nrow = 2))
par(mar = c(2, 2, 2, 2))

barplot(VADeaths, col = swatch(palette1)[[1]], border = NA)
barplot(VADeaths, col = swatch(palette2)[[1]], border = NA)
barplot(VADeaths, col = swatch(palette3)[[1]], border = NA)
barplot(VADeaths, col = swatch(palette4)[[1]], border = NA)
```

调色板的描述信息


```r
palette1
```

获取调色板中的颜色向量


```r
swatch(palette1)[[1]]
```

### 颜色模式 {#subsec-color-schames}

不同的颜色模式，从 RGB 到 HCL 的基本操作 <https://stat545.com/block018_colors.html>


```r
# https://github.com/hadley/ggplot2-book
hcl <- expand.grid(x = seq(-1, 1, length = 100), y = seq(-1, 1, length = 100)) |>
  subset(subset = x^2 + y^2 < 1) |>
  transform(
    r = sqrt(x^2 + y^2)
  ) |>
  transform(
    h = 180 / pi * atan2(y, x),
    c = 100 * r,
    l = 65
  ) |>
  transform(
    colour = hcl(h, c, l)
  )

# sin(h) = y / (c / 100)
# y = sin(h) * c / 100

cols <- scales::hue_pal()(5)
selected <- colorspace::RGB(t(col2rgb(cols)) / 255) %>%
  as("polarLUV") %>%
  colorspace::coords() %>%
  as.data.frame() %>%
  transform(
    x = cos(H / 180 * pi) * C / 100,
    y = sin(H / 180 * pi) * C / 100,
    colour = cols
  )

ggplot(hcl, aes(x, y)) +
  geom_raster(aes(fill = colour)) +
  scale_fill_identity() +
  scale_colour_identity() +
  coord_equal() +
  scale_x_continuous("", breaks = NULL) +
  scale_y_continuous("", breaks = NULL) +
  geom_point(data = selected, size = 10, color = "white") +
  geom_point(data = selected, size = 5, aes(colour = colour))
```

\begin{figure}

{\centering \includegraphics{data-visualization_files/figure-latex/unnamed-chunk-26-1} 

}

\caption{HCL调色}(\#fig:unnamed-chunk-26)
\end{figure}

R 内置了 502 种不同颜色的名称，下面随机地选取 20 种颜色


```r
sample(colors(TRUE), 20)
```

```
##  [1] "royalblue4"      "plum1"           "papayawhip"      "darkslategray"  
##  [5] "darkturquoise"   "gray79"          "darkred"         "maroon4"        
##  [9] "darkolivegreen4" "springgreen2"    "orchid4"         "lemonchiffon2"  
## [13] "paleturquoise4"  "gray49"          "cyan"            "antiquewhite1"  
## [17] "yellow2"         "gray13"          "cadetblue2"      "gray77"
```

R 包 grDevices 提供 hcl 调色板[^hcl-palettes] 调制两个色板

[^hcl-palettes]: https://developer.r-project.org/Blog/public/2019/04/01/hcl-based-color-palettes-in-grdevices/index.html


```r
# Colors from https://github.com/johannesbjork/LaCroixColoR
color_pal <- c("#FF3200", "#E9A17C", "#E9E4A6", "#1BB6AF", "#0076BB", "#172869")
n <- 16
more_colors <- (grDevices::colorRampPalette(color_pal))(n)
scales::show_col(colours = more_colors)
```

\begin{figure}

{\centering \includegraphics{data-visualization_files/figure-latex/color-pal-1} 

}

\caption{桃色至梨色的渐变}(\#fig:color-pal)
\end{figure}


```r
# colors in colortools from http://www.gastonsanchez.com/
fish_pal <- c(
  "#69D2E7", "#6993E7", "#7E69E7", "#BD69E7",
  "#E769D2", "#E76993", "#E77E69", "#E7BD69",
  "#D2E769", "#93E769", "#69E77E", "#69E7BD"
)
more_colors <- (grDevices::colorRampPalette(fish_pal))(n)
scales::show_col(colours = more_colors)
```

\begin{figure}

{\centering \includegraphics{data-visualization_files/figure-latex/fish-hsv-pal-1} 

}

\caption{Hue-Saturation-Value (HSV) 颜色模型}(\#fig:fish-hsv-pal)
\end{figure}


```r
rgb(red = 86, green = 180, blue = 233, maxColorValue = 255) # "#56B4E9"
```

```
## [1] "#56B4E9"
```

```r
rgb(red = 0, green = 158, blue = 115, maxColorValue = 255) # "#009E73"
```

```
## [1] "#009E73"
```

```r
rgb(red = 240, green = 228, blue = 66, maxColorValue = 255) # "#F0E442"
```

```
## [1] "#F0E442"
```

```r
rgb(red = 0, green = 114, blue = 178, maxColorValue = 255) # "#0072B2"
```

```
## [1] "#0072B2"
```

举例子，直方图配色与不配色


```r
# library(pander)
# evalsOptions('graph.unify', TRUE)
# panderOptions('graph.colors') 获取调色板
# https://www.fontke.com/tool/rgbschemes/ 在线配色
cols <- c(
  "#56B4E9", "#009E73", "#F0E442", "#0072B2",
  "#D55E00", "#CC79A7", "#999999", "#E69F00"
)
hist(mtcars$hp, col = "#56B4E9", border = "white", grid = grid())
```

\begin{figure}

{\centering \includegraphics{data-visualization_files/figure-latex/unnamed-chunk-29-1} 

}

\caption{直方图}(\#fig:unnamed-chunk-29)
\end{figure}


```r
ggplot(mtcars) +
  geom_histogram(aes(x = hp, fill = as.factor(..count..)),
    color = "white", bins = 6
  ) +
  scale_fill_manual(values = rep("#56B4E9", 10)) +
  ggtitle("Histogram with ggplot2") +
  theme_minimal() +
  theme(legend.position = "none") 
```

\begin{figure}

{\centering \includegraphics{data-visualization_files/figure-latex/unnamed-chunk-30-1} 

}

\caption{直方图}(\#fig:unnamed-chunk-30)
\end{figure}

#### RGB

红(red)、绿(green)、蓝(blue)是三原色


```r
rgb(red, green, blue, alpha, names = NULL, maxColorValue = 1)
```

函数参数说明：

- `red, blue, green, alpha` 取值范围$[0,M]$，$M$ 是 *maxColorValue*
- `names` 字符向量，给这组颜色值取名
- `maxColorValue` 红，绿，蓝三色范围的最大值

The colour specification refers to the standard sRGB colorspace (IEC standard 61966).

rgb 产生一种颜色，如 `rgb(255, 0, 0, maxColorValue = 255)` 的颜色是 `"#FF0000"` ，这是一串16进制数，每两个一组，那么一组有 $16^2 = 256$ 种组合，整个一串有 $256^3 = 16777216$ 种组合，这就是RGB表达的所有颜色。

#### HSL

色相饱和度亮度 hue--saturation--luminance (HSL)

#### HSV

Create a vector of colors from vectors specifying hue, saturation and value. 色相饱和度值

```r
hsv(h = 1, s = 1, v = 1, alpha)
```

This function creates a vector of colors corresponding to the given values in HSV space. rgb and rgb2hsv for RGB to HSV conversion;

hsv函数通过设置色调、饱和度和亮度获得颜色，三个值都是0-1的相对量

RGB HSV HSL 都是不连续的颜色空间，缺点

#### HCL

基于感知的颜色空间替代RGB颜色空间

通过指定色相(hue)，色度(chroma)和亮度(luminance/lightness)，创建一组（种）颜色


```r
hcl(h = 0, c = 35, l = 85, alpha, fixup = TRUE)
```

函数参数说明：

- **h** 颜色的色调，取值范围为[0,360]，0、120、240分别对应红色、绿色、蓝色

- **c** 颜色的色度，其上界取决于色调和亮度

- **l** 颜色的亮度，取值范围[0,100]，给定色调和色度，只有一部分子集可用

- **alpha** 透明度，取值范围[0,1]，0 和1分别表示透明和不透明

This function corresponds to polar coordinates in the CIE-LUV color space

选色为什么这么难

色相与阴影相比是无关紧要的，色相对于标记和分类很有用，但表示（精细的）空间数据或形状的效果较差。颜色是改善图形的好工具，但糟糕的配色方案 (color schemes) 可能会导致比灰度调色板更差的效果。[@colorspace_2009_rainbow]

黑、白、灰，看似有三种颜色，其实只有一种颜色，黑和白只是灰色的两极，那么如何设置灰色梯度，使得人眼比较好区分它们呢？这样获得的调色板适用于什么样的绘图环境呢？

#### CMYK

印刷三原色：青 (cyan)、品红 (magenta)、黄 (yellow)

- 颜色模式转化

`col2rgb()` 、`rgb2hsv()` 和 `rgb()` 函数 `hex2RGB()` 函数 colorspace `col2hcl()` 函数 scales `col2HSV()` colortools `col2hex()`


```r
col2rgb("lightblue") # color to  RGB
```

```
##       [,1]
## red    173
## green  216
## blue   230
```

```r
scales::col2hcl("lightblue") # color to HCL
```

```
## [1] "#ADD8E6"
```

```r
# palr::col2hex("lightblue") # color to HEX
# colortools::col2HSV("lightblue") # color to HSV

rgb(173, 216, 230, maxColorValue = 255) # RGB to HEX
```

```
## [1] "#ADD8E6"
```

```r
colorspace::hex2RGB("#ADD8E6") # HEX to RGB
```

```
##              R         G         B
## [1,] 0.6784314 0.8470588 0.9019608
```

```r
rgb(.678, .847, .902, maxColorValue = 1) # RGB to HEX
```

```
## [1] "#ADD8E6"
```

```r
rgb2hsv(173, 216, 230, maxColorValue = 255) # RGB to HSV
```

```
##        [,1]
## h 0.5409357
## s 0.2478261
## v 0.9019608
```

### LaTeX 配色 {#subsec-latex-colors}

LaTeX 宏包 [xcolor](https://www.ctan.org/pkg/xcolor) 中定义颜色的常用方式有两种，其一，`\textcolor{green!40!yellow}`{.TeX} 表示 40% 的绿色和 60% 的黄色混合色彩，其二，`\textcolor[HTML]{34A853}`{.TeX} HEX 表示的色彩直接在 LaTeX 文档中使用的方式，类似地 `\textcolor[RGB]{52,168,83}`{.TeX} 也表示 Google 图标中的绿色。

```tex
\documentclass[tikz,border=10pt]{standalone}
\begin{document}
\begin{tikzpicture}
\draw (0,0) rectangle (2,1) node [midway] {\textcolor[RGB]{52,168,83}{Hello} \textcolor[HTML]{34A853}{\TeX}};
\end{tikzpicture}
\end{document}
```

对应于 R 中的调用方式为：


```r
rgb(52, 168, 83, maxColorValue = 255)
```

```
## [1] "#34A853"
```

### ggplot2 配色 {#subsec-ggplot2-colors}


```r
boxplot(weight ~ group,
  data = PlantGrowth, col = "lightgray",
  notch = FALSE, varwidth = TRUE
)
# 类似 boxplot
ggplot(data = PlantGrowth, aes(x = group, y = weight)) +
  geom_boxplot(notch = FALSE, varwidth = TRUE, fill = "lightgray")

# 默认调色板
ggplot(data = PlantGrowth, aes(x = group, y = weight, fill = group)) +
  geom_boxplot(notch = FALSE, varwidth = TRUE)

# Google 调色板
ggplot(data = PlantGrowth, aes(x = group, y = weight, fill = group)) +
  geom_boxplot(notch = FALSE, varwidth = TRUE) +
  scale_fill_manual(values = c("#4285f4", "#34A853", "#FBBC05", "#EA4335"))
```

\begin{figure}

{\centering \subfloat[简单箱线图(\#fig:colorize-boxplot-1)]{\includegraphics[width=0.45\linewidth]{data-visualization_files/figure-latex/colorize-boxplot-1} }\subfloat[ggplot2 绘制的箱线图(\#fig:colorize-boxplot-2)]{\includegraphics[width=0.45\linewidth]{data-visualization_files/figure-latex/colorize-boxplot-2} }\newline\subfloat[ggplot2 调用默认调色板(\#fig:colorize-boxplot-3)]{\includegraphics[width=0.45\linewidth]{data-visualization_files/figure-latex/colorize-boxplot-3} }\subfloat[ggplot2 调用 Google 调色板(\#fig:colorize-boxplot-4)]{\includegraphics[width=0.45\linewidth]{data-visualization_files/figure-latex/colorize-boxplot-4} }

}

\caption{几种不同的箱线图}(\#fig:colorize-boxplot)
\end{figure}

## 图库 {#sec-gallery}

### 饼图 {#sec-ggplot2-pie}

我对饼图是又爱又恨，爱的是它表示百分比的时候，往往让读者联想到蛋糕，份额这类根深蒂固的情景，从而让数字通俗易懂、深入人心，是一种很好的表达方式，恨的也是这一点，我用柱状图表达不香吗？人眼对角度的区分度远不如柱状图呢，特别是当两个类所占的份额比较接近的时候，所以很多时候，除了用饼图表达份额，还会在旁边标上百分比，从数据可视化的角度来说，如图 \@ref(fig:bod-pie) 所示，这是信息冗余！


```r
BOD %>% transform(., ratio = demand / sum(demand)) %>% 
  ggplot(., aes(x = "", y = demand, fill = reorder(Time, demand))) +
  geom_bar(stat = "identity", show.legend = FALSE, color = "white") +
  coord_polar(theta = "y") +
  geom_text(aes(x = 1.6, label = paste0(round(ratio, digits = 4) * 100, "%")),
    position = position_stack(vjust = 0.5), color = "black"
  ) +
  geom_text(aes(x = 1.2, label = Time),
    position = position_stack(vjust = 0.5), color = "black"
  ) +
  theme_void(base_size = 14)
```

\begin{figure}

{\centering \includegraphics{data-visualization_files/figure-latex/bod-pie-1} 

}

\caption{饼图}(\#fig:bod-pie)
\end{figure}

`plot_ly(type = "pie", ... )` 和添加图层 `add_pie()` 的效果是一样的


```r
dat = aggregate(formula = carat ~ cut, data = diamonds, FUN = length)
plotly::plot_ly() %>%
  plotly::add_pie(
    data = dat, labels = ~cut, values = ~carat,
    name = "简单饼图1", domain = list(row = 0, column = 0)
  ) %>%
  plotly::add_pie(
    data = dat, labels = ~cut, values = ~carat, hole = 0.6,
    textposition = "inside", textinfo = "label+percent",
    name = "简单饼图2", domain = list(row = 0, column = 1)
  ) %>%
  plotly::layout(
    title = "多图布局", showlegend = F,
    grid = list(rows = 1, columns = 2),
    xaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
    yaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE)
  ) %>% 
  plotly::config(displayModeBar = FALSE)
```

设置参数 hole 可以绘制环形饼图，比如 hole = 0.6

### 地图 {#sec-ggplot2-map}

USArrests 数据集描述了1973年美国50个州每10万居民中因袭击、抢劫和强奸而逮捕的人，以及城市人口占比。这里的地图是指按照行政区划为边界的示意图，比如图 \@ref(fig:state-crimes)


```r
library(maps)
crimes <- data.frame(state = tolower(rownames(USArrests)), USArrests)
# 等价于 crimes %>% tidyr::pivot_longer(Murder:Rape)
vars <- lapply(names(crimes)[-1], function(j) {
  data.frame(state = crimes$state, variable = j, value = crimes[[j]])
})
crimes_long <- do.call("rbind", vars)
states_map <- map_data("state")
ggplot(crimes, aes(map_id = state)) +
  geom_map(aes(fill = Murder), map = states_map) +
  expand_limits(x = states_map$long, y = states_map$lat) +
  scale_fill_binned(type = "viridis") +
  coord_map() +
  theme_minimal()
```

\begin{figure}

{\centering \includegraphics{data-visualization_files/figure-latex/state-crimes-1} 

}

\caption{1975年美国各州犯罪事件}(\#fig:state-crimes)
\end{figure}

先来看看中国及其周边，见图\@ref(fig:incorrect-map)，这个地图的缺陷就是中国南海及九段线没有标记，台湾和中国大陆不是一种颜色标记，这里的地图数据来自 R 包 **maps** 和 **mapdata**，像这样的地图就不宜在国内正式刊物上出现。


```r
library(maps)
library(mapdata)
east_asia <- map_data("worldHires",
  region = c(
    "Japan", "Taiwan", "China",
    "North Korea", "South Korea"
  )
)
ggplot(east_asia, aes(x = long, y = lat, group = group, fill = region)) +
  geom_polygon(colour = "black") +
  scale_fill_brewer(palette = "Set2") +
  theme_minimal()
```

\begin{figure}

{\centering \includegraphics{data-visualization_files/figure-latex/incorrect-map-1} 

}

\caption{中国及其周边}(\#fig:incorrect-map)
\end{figure}

绘制真正的地图需要考虑投影坐标系，观察角度、分辨率、政策法规等一系列因素，它是一种复杂的图形，如图 \@ref(fig:draw-map) 所示。


```r
worldmap <- map_data("world")

# 默认 mercator 投影下的默认视角 c(90, 0, mean(range(x)))
ggplot(worldmap, aes(long, lat, group = group)) +
  geom_polygon(aes(fill = region), show.legend = FALSE) +
  coord_map(
    xlim = c(-120, 40), ylim = c(30, 90)
  )

# 换观察角度
ggplot(worldmap, aes(long, lat, group = group)) +
  geom_polygon(aes(fill = region), show.legend = FALSE) +
  coord_map(
    xlim = c(-120, 40), ylim = c(30, 90),
    orientation = c(90, 0, 0)
  )

# 换投影坐标系
ggplot(worldmap, aes(long, lat, group = group)) +
  geom_polygon(aes(fill = region), show.legend = FALSE) +
  coord_map("ortho",
    xlim = c(-120, 40), ylim = c(30, 90)
  )

# 二者皆换
ggplot(worldmap, aes(long, lat, group = group)) +
  geom_polygon(aes(fill = region), show.legend = FALSE) +
  coord_map("ortho",
    xlim = c(-120, 40), ylim = c(30, 90),
    orientation = c(90, 0, 0)
  )
```

\begin{figure}

{\centering \subfloat[墨卡托投影(\#fig:draw-map-1)]{\includegraphics[width=0.45\linewidth]{data-visualization_files/figure-latex/draw-map-1} }\subfloat[北极观察(\#fig:draw-map-2)]{\includegraphics[width=0.45\linewidth]{data-visualization_files/figure-latex/draw-map-2} }\newline\subfloat[正交投影(\#fig:draw-map-3)]{\includegraphics[width=0.45\linewidth]{data-visualization_files/figure-latex/draw-map-3} }\subfloat[正交投影北极观察(\#fig:draw-map-4)]{\includegraphics[width=0.45\linewidth]{data-visualization_files/figure-latex/draw-map-4} }

}

\caption{画地图的正确姿势}(\#fig:draw-map)
\end{figure}

<!-- 世界地图引发的 <https://d.cosx.org/d/420808> -->

Google 地图


```r
library(RgoogleMaps)
# 一组坐标的中心位置
lat <- c(40.702147, 40.718217, 40.711614)
lon <- c(-74.012318, -74.015794, -73.998284)
center <- c(mean(lat), mean(lon))
zoom <- min(MaxZoom(range(lat), range(lon)))
# 矩形对角线的两个顶点
bb <- qbbox(lat, lon)
# 获取地图数据
myMap <- GetMap(center, size = c(640, 640), zoom = zoom, type = "osm")
# 在地图上添加红、蓝、绿三个点
PlotOnStaticMap(myMap,
  lat = lat, lon = lon, pch = 20, cex = 10,
  col = c("red", "blue", "green")
)
```

\begin{figure}

{\centering \includegraphics[width=0.75\linewidth]{data-visualization_files/figure-latex/google-map-1} 

}

\caption{Google 地图示例}(\#fig:google-map)
\end{figure}

### 热图 {#sec-ggplot2-heatmap}

<!-- [heatmap3](https://cran.r-project.org/package=heatmap3) 包提供兼容 Base R 的 heatmap() 函数 -->

Zuguang Gu 开发的 [ComplexHeatmap](https://github.com/jokergoo/ComplexHeatmap) 包实现复杂数据的可视化，用以发现关联数据集之间的模式。特别地，比如基因数据、生存数据等，更多应用见开发者的书籍 [ComplexHeatmap 完全手册](https://jokergoo.github.io/ComplexHeatmap-reference/book/) 。 R 包发布在 Bioconductor 上 <https://www.bioconductor.org/packages/ComplexHeatmap>。使用之前我要确保已经安装 **BiocManager** 包，这个包负责管理 Bioconductor 上所有的包，需要先安装它，然后安装 **ComplexHeatmap** 包 [@Gu_2016_heatmap]。


```r
if (!requireNamespace("BiocManager", quietly = TRUE))
    install.packages("BiocManager")
BiocManager::install("ComplexHeatmap")
```

### 散点图 {#ggplot2-scatter}

下面以 diamonds 数据集为例展示 ggplot2 的绘图过程，首先加载 diamonds 数据集，查看数据集的内容


```r
data(diamonds)
str(diamonds)
```

```
## tibble [53,940 x 10] (S3: tbl_df/tbl/data.frame)
##  $ carat  : num [1:53940] 0.23 0.21 0.23 0.29 0.31 0.24 0.24 0.26 0.22 0.23 ...
##  $ cut    : Ord.factor w/ 5 levels "Fair"<"Good"<..: 5 4 2 4 2 3 3 3 1 3 ...
##  $ color  : Ord.factor w/ 7 levels "D"<"E"<"F"<"G"<..: 2 2 2 6 7 7 6 5 2 5 ...
##  $ clarity: Ord.factor w/ 8 levels "I1"<"SI2"<"SI1"<..: 2 3 5 4 2 6 7 3 4 5 ...
##  $ depth  : num [1:53940] 61.5 59.8 56.9 62.4 63.3 62.8 62.3 61.9 65.1 59.4 ...
##  $ table  : num [1:53940] 55 61 65 58 58 57 57 55 61 61 ...
##  $ price  : int [1:53940] 326 326 327 334 335 336 336 337 337 338 ...
##  $ x      : num [1:53940] 3.95 3.89 4.05 4.2 4.34 3.94 3.95 4.07 3.87 4 ...
##  $ y      : num [1:53940] 3.98 3.84 4.07 4.23 4.35 3.96 3.98 4.11 3.78 4.05 ...
##  $ z      : num [1:53940] 2.43 2.31 2.31 2.63 2.75 2.48 2.47 2.53 2.49 2.39 ...
```

数值型变量 carat 作为 x 轴


```r
ggplot(diamonds, aes(x = carat))
ggplot(diamonds, aes(x = carat, y = price))
ggplot(diamonds, aes(x = carat, color = cut))
ggplot(diamonds, aes(x = carat), color = "steelblue")
```

\begin{figure}

{\centering \subfloat[指定 x 轴(\#fig:diamonds-axis-1)]{\includegraphics[width=0.35\linewidth]{data-visualization_files/figure-latex/diamonds-axis-1} }\subfloat[数值变量 price 作为纵轴(\#fig:diamonds-axis-2)]{\includegraphics[width=0.35\linewidth]{data-visualization_files/figure-latex/diamonds-axis-2} }\newline\subfloat[有序分类变量 cut 指定颜色(\#fig:diamonds-axis-3)]{\includegraphics[width=0.35\linewidth]{data-visualization_files/figure-latex/diamonds-axis-3} }\subfloat[指定统一颜色(\#fig:diamonds-axis-4)]{\includegraphics[width=0.35\linewidth]{data-visualization_files/figure-latex/diamonds-axis-4} }

}

\caption{绘图过程}(\#fig:diamonds-axis)
\end{figure}

图 \@ref(fig:diamonds-axis) 的基础上添加数据图层


```r
sub_diamonds <- diamonds[sample(1:nrow(diamonds), 1000), ]
ggplot(sub_diamonds, aes(x = carat, y = price)) +
  geom_point()
```

\begin{figure}

{\centering \includegraphics{data-visualization_files/figure-latex/scatter-1} 

}

\caption{添加数据图层}(\#fig:scatter)
\end{figure}

给散点图\@ref(fig:scatter)上色


```r
ggplot(sub_diamonds, aes(x = carat, y = price)) +
  geom_point(color = "steelblue")
```

\begin{figure}

{\centering \includegraphics{data-visualization_files/figure-latex/scatter-color-1-1} 

}

\caption{散点图配色}(\#fig:scatter-color-1)
\end{figure}



```r
ggplot(sub_diamonds, aes(x = carat, y = price)) +
  geom_point(color = "steelblue") +
  scale_y_continuous(
    labels = scales::unit_format(unit = "k", scale = 1e-3),
    breaks = seq(0, 20000, 4000)
  )
```

\begin{figure}

{\centering \includegraphics{data-visualization_files/figure-latex/scatter-scale-1-1} 

}

\caption{格式化坐标轴刻度标签}(\#fig:scatter-scale-1)
\end{figure}

让另一变量 cut 作为颜色分类指标


```r
ggplot(sub_diamonds, aes(x = carat, y = price, color = cut)) +
  geom_point()
```

\begin{figure}

{\centering \includegraphics{data-visualization_files/figure-latex/scatter-color-2-1} 

}

\caption{分类散点图}(\#fig:scatter-color-2)
\end{figure}

当然还有一种类似的表示就是分组，默认情况下，ggplot2将所有观测点视为一组，以分类变量 cut 来分组


```r
ggplot(sub_diamonds, aes(x = carat, y = price, group = cut)) +
  geom_point()
```

\begin{figure}

{\centering \includegraphics{data-visualization_files/figure-latex/scatter-group-1} 

}

\caption{分组}(\#fig:scatter-group)
\end{figure}

在图\@ref(fig:scatter-group) 上没有体现出来分组的意思，下面以 cut 分组线性回归为例


```r
ggplot(sub_diamonds, aes(x = carat, y = price)) +
  geom_point() +
  geom_smooth(method = "lm")
```

\begin{figure}

{\centering \includegraphics{data-visualization_files/figure-latex/group-lm-1} 

}

\caption{分组线性回归}(\#fig:group-lm-1)
\end{figure}

```r
ggplot(sub_diamonds, aes(x = carat, y = price, group = cut)) +
  geom_point() +
  geom_smooth(method = "lm")
```

\begin{figure}

{\centering \includegraphics{data-visualization_files/figure-latex/group-lm-2} 

}

\caption{分组线性回归}(\#fig:group-lm-2)
\end{figure}

我们当然可以选择更加合适的拟合方式，如局部多项式平滑 `loess` 但是该方法不太适用观测值比较多的情况，因为它会占用比较多的内存，建议使用广义可加模型作平滑拟合


```r
ggplot(sub_diamonds, aes(x = carat, y = price, group = cut)) +
  geom_point() +
  geom_smooth(method = "loess")
```

\begin{figure}

{\centering \includegraphics{data-visualization_files/figure-latex/unnamed-chunk-36-1} 

}

\caption{局部多项式平滑}(\#fig:unnamed-chunk-36)
\end{figure}


```r
ggplot(sub_diamonds, aes(x = carat, y = price, group = cut)) +
  geom_point() +
  geom_smooth(method = "gam", formula = y ~ s(x, bs = "cs"))
```

\begin{figure}

{\centering \includegraphics{data-visualization_files/figure-latex/group-gam-1} 

}

\caption{数据分组应用广义可加平滑}(\#fig:group-gam)
\end{figure}

[ggfortify](https://github.com/sinhrks/ggfortify) 包支持更多的统计分析结果的可视化。

为了更好地区分开组别，我们在图\@ref(fig:group-gam)的基础上分面或者配色


```r
ggplot(sub_diamonds, aes(x = carat, y = price, group = cut)) +
  geom_point() +
  geom_smooth(method = "gam", formula = y ~ s(x, bs = "cs")) +
  facet_grid(~cut)
```

\begin{figure}

{\centering \includegraphics{data-visualization_files/figure-latex/group-facet-1} 

}

\caption{分组分面}(\#fig:group-facet-1)
\end{figure}

```r
ggplot(sub_diamonds, aes(x = carat, y = price, group = cut, color = cut)) +
  geom_point() +
  geom_smooth(method = "gam", formula = y ~ s(x, bs = "cs"))
```

\begin{figure}

{\centering \includegraphics{data-visualization_files/figure-latex/group-facet-2} 

}

\caption{分组配色}(\#fig:group-facet-2)
\end{figure}

在分类散点图的另一种表示方法就是分面图，以 cut 变量作为分面的依据


```r
ggplot(sub_diamonds, aes(x = carat, y = price)) +
  geom_point() +
  facet_grid(~cut)
```

\begin{figure}

{\centering \includegraphics{data-visualization_files/figure-latex/scatter-facet-1} 

}

\caption{分面散点图}(\#fig:scatter-facet)
\end{figure}

给图 \@ref(fig:scatter-facet) 上色


```r
ggplot(sub_diamonds, aes(x = carat, y = price)) +
  geom_point(color = "steelblue") +
  facet_grid(~cut)
```

\begin{figure}

{\centering \includegraphics{data-visualization_files/figure-latex/scatter-facet-color-1-1} 

}

\caption{给分面散点图上色}(\#fig:scatter-facet-color-1)
\end{figure}

在图\@ref(fig:scatter-facet-color-1)的基础上，给不同的类上不同的颜色


```r
ggplot(sub_diamonds, aes(x = carat, y = price, color = cut)) +
  geom_point() +
  facet_grid(~cut)
```

\begin{figure}

{\centering \includegraphics{data-visualization_files/figure-latex/scatter-facet-color-2-1} 

}

\caption{给不同的类上不同的颜色}(\#fig:scatter-facet-color-2)
\end{figure}

去掉图例，此时图例属于冗余信息了


```r
ggplot(sub_diamonds, aes(x = carat, y = price, color = cut)) +
  geom_point(show.legend = FALSE) +
  facet_grid(~cut)
```

\begin{figure}

{\centering \includegraphics{data-visualization_files/figure-latex/scatter-facet-color-3-1} 

}

\caption{去掉图例}(\#fig:scatter-facet-color-3)
\end{figure}

四块土地，所施肥料不同，肥力大小顺序 4 < 2 < 3 < 1 小麦产量随肥力的变化


```r
data(Wheat2, package = "nlme") # Wheat Yield Trials
library(colorspace)
ggplot(Wheat2, aes(longitude, latitude)) +
  geom_point(aes(size = yield, colour = Block)) +
  scale_color_discrete_sequential(palette = "Viridis") +
  scale_x_continuous(breaks = seq(0, 30, 5)) +
  scale_y_continuous(breaks = seq(0, 50, 10))
```

\begin{figure}

{\centering \includegraphics{data-visualization_files/figure-latex/unnamed-chunk-37-1} 

}

\caption{多个图例}(\#fig:unnamed-chunk-37)
\end{figure}
  

```r
ggplot(mtcars, aes(x = hp, y = mpg, color = factor(am))) +
  geom_point()
```

\begin{figure}

{\centering \includegraphics{data-visualization_files/figure-latex/category-ggplot-1} 

}

\caption{分类散点图}(\#fig:category-ggplot)
\end{figure}

图层、分组、分面和散点图介绍完了，接下来就是其它统计图形，如箱线图，小提琴图和条形图


```r
dat <- as.data.frame(cbind(rep(1948 + seq(12), each = 12), rep(seq(12), 12), AirPassengers))
colnames(dat) <- c("year", "month", "passengers")

ggplot(data = dat, aes(x = as.factor(year), y = as.factor(month))) +
  stat_sum(aes(size = passengers), colour = "lightblue") +
  scale_size(range = c(1, 10), breaks = seq(100, 650, 50)) +
  labs(x = "Year", y = "Month", colour = "Passengers") +
  theme_minimal()
```

\begin{figure}

{\centering \includegraphics{data-visualization_files/figure-latex/unnamed-chunk-38-1} 

}

\caption{1948年至1960年航班乘客人数变化}(\#fig:unnamed-chunk-38)
\end{figure}

### 条形图 {#sec-ggplot2-barplot}

条形图特别适合分类变量的展示，我们这里展示钻石切割质量 cut 不同等级的数量，当然我们可以直接展示各类的数目，在图层 `geom_bar` 中指定 `stat="identity"`


```r
# 需要映射数据框的两个变量，相当于自己先计算了每类的数量
with(diamonds, table(cut))
```

```
## cut
##      Fair      Good Very Good   Premium     Ideal 
##      1610      4906     12082     13791     21551
```

```r
cut_df <- as.data.frame(table(diamonds$cut))
ggplot(cut_df, aes(x = Var1, y = Freq)) + geom_bar(stat = "identity")
```



\begin{center}\includegraphics{data-visualization_files/figure-latex/unnamed-chunk-39-1} \end{center}

```r
ggplot(diamonds, aes(x = cut)) + geom_bar()
```

\begin{figure}

{\centering \includegraphics{data-visualization_files/figure-latex/diamonds-barplot-1-1} 

}

\caption{频数条形图}(\#fig:diamonds-barplot-1)
\end{figure}

还有另外三种表示方法


```r
ggplot(diamonds, aes(x = cut)) + geom_bar(stat = "count")
```



\begin{center}\includegraphics{data-visualization_files/figure-latex/unnamed-chunk-40-1} \end{center}

```r
ggplot(diamonds, aes(x = cut, y = ..count..)) + geom_bar()
```



\begin{center}\includegraphics{data-visualization_files/figure-latex/unnamed-chunk-40-2} \end{center}

```r
ggplot(diamonds, aes(x = cut, y = stat(count))) + geom_bar()
```



\begin{center}\includegraphics{data-visualization_files/figure-latex/unnamed-chunk-40-3} \end{center}

我们还可以在图 \@ref(fig:diamonds-barplot-1) 的基础上再添加一个分类变量钻石的纯净度 clarity，形成堆积条形图


```r
ggplot(diamonds, aes(x = cut, fill = clarity)) + geom_bar()
```

\begin{figure}

{\centering \includegraphics{data-visualization_files/figure-latex/diamonds-barplot-2-1} 

}

\caption{堆积条形图}(\#fig:diamonds-barplot-2)
\end{figure}

再添加一个分类变量钻石颜色 color 比较好的做法是分面


```r
ggplot(diamonds, aes(x = color, fill = clarity)) +
  geom_bar() +
  facet_grid(~cut)
```

\begin{figure}

{\centering \includegraphics{data-visualization_files/figure-latex/diamonds-barplot-3-1} 

}

\caption{分面堆积条形图}(\#fig:diamonds-barplot-3)
\end{figure}

实际上，绘制图\@ref(fig:diamonds-barplot-3)包含了对分类变量的分组计数过程，如下


```r
with(diamonds, table(cut, color))
```

```
##            color
## cut            D    E    F    G    H    I    J
##   Fair       163  224  312  314  303  175  119
##   Good       662  933  909  871  702  522  307
##   Very Good 1513 2400 2164 2299 1824 1204  678
##   Premium   1603 2337 2331 2924 2360 1428  808
##   Ideal     2834 3903 3826 4884 3115 2093  896
```

还有一种堆积的方法是按比例，而不是按数量，如图\@ref(fig:diamonds-barplot-4)


```r
ggplot(diamonds, aes(x = color, fill = clarity)) +
  geom_bar(position = "fill") +
  facet_grid(~cut)
```

\begin{figure}

{\centering \includegraphics{data-visualization_files/figure-latex/diamonds-barplot-4-1} 

}

\caption{比例堆积条形图}(\#fig:diamonds-barplot-4)
\end{figure}

接下来就是复合条形图


```r
ggplot(diamonds, aes(x = color, fill = clarity)) +
  geom_bar(position = "dodge")
```

\begin{figure}

{\centering \includegraphics{data-visualization_files/figure-latex/diamonds-barplot-5-1} 

}

\caption{复合条形图}(\#fig:diamonds-barplot-5)
\end{figure}

再添加一个分类变量，就是需要分面大法了，图 \@ref(fig:diamonds-barplot-5) 展示了三个分类变量，其实我们还可以再添加一个分类变量用作分面的列依据


```r
ggplot(diamonds, aes(x = color, fill = clarity)) +
  geom_bar(position = "dodge") +
  facet_grid(rows = vars(cut))
```

\begin{figure}

{\centering \includegraphics{data-visualization_files/figure-latex/diamonds-barplot-6-1} 

}

\caption{分面复合条形图}(\#fig:diamonds-barplot-6)
\end{figure}

图 \@ref(fig:diamonds-barplot-6) 展示的数据如下


```r
with(diamonds, table(color, clarity, cut))
```

```
## , , cut = Fair
## 
##      clarity
## color   I1  SI2  SI1  VS2  VS1 VVS2 VVS1   IF
##     D    4   56   58   25    5    9    3    3
##     E    9   78   65   42   14   13    3    0
##     F   35   89   83   53   33   10    5    4
##     G   53   80   69   45   45   17    3    2
##     H   52   91   75   41   32   11    1    0
##     I   34   45   30   32   25    8    1    0
##     J   23   27   28   23   16    1    1    0
## 
## , , cut = Good
## 
##      clarity
## color   I1  SI2  SI1  VS2  VS1 VVS2 VVS1   IF
##     D    8  223  237  104   43   25   13    9
##     E   23  202  355  160   89   52   43    9
##     F   19  201  273  184  132   50   35   15
##     G   19  163  207  192  152   75   41   22
##     H   14  158  235  138   77   45   31    4
##     I    9   81  165  110  103   26   22    6
##     J    4   53   88   90   52   13    1    6
## 
## , , cut = Very Good
## 
##      clarity
## color   I1  SI2  SI1  VS2  VS1 VVS2 VVS1   IF
##     D    5  314  494  309  175  141   52   23
##     E   22  445  626  503  293  298  170   43
##     F   13  343  559  466  293  249  174   67
##     G   16  327  474  479  432  302  190   79
##     H   12  343  547  376  257  145  115   29
##     I    8  200  358  274  205   71   69   19
##     J    8  128  182  184  120   29   19    8
## 
## , , cut = Premium
## 
##      clarity
## color   I1  SI2  SI1  VS2  VS1 VVS2 VVS1   IF
##     D   12  421  556  339  131   94   40   10
##     E   30  519  614  629  292  121  105   27
##     F   34  523  608  619  290  146   80   31
##     G   46  492  566  721  566  275  171   87
##     H   46  521  655  532  336  118  112   40
##     I   24  312  367  315  221   82   84   23
##     J   13  161  209  202  153   34   24   12
## 
## , , cut = Ideal
## 
##      clarity
## color   I1  SI2  SI1  VS2  VS1 VVS2 VVS1   IF
##     D   13  356  738  920  351  284  144   28
##     E   18  469  766 1136  593  507  335   79
##     F   42  453  608  879  616  520  440  268
##     G   16  486  660  910  953  774  594  491
##     H   38  450  763  556  467  289  326  226
##     I   17  274  504  438  408  178  179   95
##     J    2  110  243  232  201   54   29   25
```



```r
# 漫谈条形图 https://cosx.org/2017/10/discussion-about-bar-graph
set.seed(2020)
dat <- data.frame(
  age = rep(1:30, 2),
  gender = rep(c("man", "woman"), each = 30),
  num = sample(x = 1:100, size = 60, replace = T)
)
# 重叠
p1 <- ggplot(data = dat, aes(x = age, y = num, fill = gender)) +
  geom_col(position = "identity", alpha = 0.5)
# 堆积
p2 <- ggplot(data = dat, aes(x = age, y = num, fill = gender)) +
  geom_col(position = "stack")
# 双柱
p3 <- ggplot(data = dat, aes(x = age, y = num, fill = gender)) +
  geom_col(position = "dodge")
# 百分比
p4 <- ggplot(data = dat, aes(x = age, y = num, fill = gender)) +
  geom_col(position = "fill") +
  scale_y_continuous(labels = scales::percent_format()) +
  labs(y = "%")
(p1 + p2) / (p3 + p4)
```

\begin{figure}

{\centering \includegraphics{data-visualization_files/figure-latex/barplot-1-1} 

}

\caption{条形图的四种常见形态}(\#fig:barplot-1)
\end{figure}

以数据集 diamonds 为例，按照纯净度 clarity 和切工 cut 分组统计钻石的数量，再按切工分组统计不同纯净度的钻石数量占比，如表 \@ref(tab:diamonds-table) 所示


```r
library(data.table)
diamonds <- as.data.table(diamonds)
dat <- diamonds[, .(cnt = .N), by = .(cut, clarity)] %>% 
  .[, pct := cnt / sum(cnt), by = .(cut)] %>% 
  .[, pct_pp := paste0(cnt, " (", scales::percent(pct, accuracy = 0.01), ")") ]
# 分组计数 with(diamonds, table(clarity, cut))
dcast(dat, formula = clarity ~ cut, value.var = "pct_pp") %>% 
  knitr::kable(align = "crrrrr", caption = "数值和比例组合呈现")
```

\begin{table}

\caption{(\#tab:diamonds-table)数值和比例组合呈现}
\centering
\begin{tabular}[t]{c|r|r|r|r|r}
\hline
clarity & Fair & Good & Very Good & Premium & Ideal\\
\hline
I1 & 210 (13.04\%) & 96 (1.96\%) & 84 (0.70\%) & 205 (1.49\%) & 146 (0.68\%)\\
\hline
SI2 & 466 (28.94\%) & 1081 (22.03\%) & 2100 (17.38\%) & 2949 (21.38\%) & 2598 (12.06\%)\\
\hline
SI1 & 408 (25.34\%) & 1560 (31.80\%) & 3240 (26.82\%) & 3575 (25.92\%) & 4282 (19.87\%)\\
\hline
VS2 & 261 (16.21\%) & 978 (19.93\%) & 2591 (21.45\%) & 3357 (24.34\%) & 5071 (23.53\%)\\
\hline
VS1 & 170 (10.56\%) & 648 (13.21\%) & 1775 (14.69\%) & 1989 (14.42\%) & 3589 (16.65\%)\\
\hline
VVS2 & 69 (4.29\%) & 286 (5.83\%) & 1235 (10.22\%) & 870 (6.31\%) & 2606 (12.09\%)\\
\hline
VVS1 & 17 (1.06\%) & 186 (3.79\%) & 789 (6.53\%) & 616 (4.47\%) & 2047 (9.50\%)\\
\hline
IF & 9 (0.56\%) & 71 (1.45\%) & 268 (2.22\%) & 230 (1.67\%) & 1212 (5.62\%)\\
\hline
\end{tabular}
\end{table}

分别以堆积条形图和百分比堆积条形图展示，添加注释到条形图上，见 \@ref(fig:barplot-2)


```r
p1 = ggplot(data = dat, aes(x = cut, y = cnt, fill = clarity)) +
  geom_col(position = "dodge") +
  geom_text(aes(label = cnt), position = position_dodge(1), vjust = -0.5) +
  geom_text(aes(label = scales::percent(pct, accuracy = 0.1)),
    position = position_dodge(1), vjust = 1, hjust = 0.5
  ) +
  scale_fill_brewer(palette = "Spectral") +
  labs(fill = "clarity", y = "", x = "cut") +
  theme_minimal() + 
  theme(legend.position = "top")

p2 = ggplot(data = dat, aes(y = cut, x = cnt, fill = clarity)) +
  geom_col(position = "fill") +
  geom_text(aes(label = cnt), position = position_fill(1), vjust = -0.5) +
  geom_text(aes(label = scales::percent(pct, accuracy = 0.1)),
    position = position_fill(1), vjust = 1, hjust = 0.5
  ) +
  scale_fill_brewer(palette = "Spectral") +
  scale_x_continuous(labels = scales::percent) +
  labs(fill = "clarity", y = "", x = "cut") +
  theme_minimal() + 
  theme(legend.position = "top")

p1 / p2
```

\begin{figure}

{\centering \includegraphics{data-visualization_files/figure-latex/barplot-2-1} 

}

\caption{添加注释到条形图}(\#fig:barplot-2)
\end{figure}

借助 plotly 制作相应的动态百分比堆积条形图


```r
ggplot(data = diamonds, aes(x = cut, fill = clarity)) +
  geom_bar(position = "dodge2") +
  scale_fill_brewer(palette = "Spectral")

# 百分比堆积条形图
plotly::plot_ly(dat,
  x = ~cut, color = ~clarity, y = ~pct,
  colors = "Spectral", type = "bar",
  text = ~ paste0(
    cnt, "颗 <br>",
    "占比：", scales::percent(pct, accuracy = 0.1), "<br>"
  ),
  hoverinfo = "text"
) %>%
  plotly::layout(
    barmode = "stack",
    yaxis = list(tickformat = ".0%")
  ) %>%
  plotly::config(displayModeBar = FALSE)

# `type = "histogram"` 以 cut 和 clarity 分组计数
plotly::plot_ly(diamonds,
  x = ~cut, color = ~clarity,
  colors = "Spectral", type = "histogram"
) %>%
  plotly::config(displayModeBar = FALSE)

# 堆积图
plotly::plot_ly(diamonds,
  x = ~cut, color = ~clarity,
  colors = "Spectral", type = "histogram"
) %>%
  plotly::layout(
    barmode = "stack", 
    yaxis = list(title = "cnt"),
    legend = list(title = list(text = "clarity"))
  ) %>%
  plotly::config(displayModeBar = FALSE)
```

### 直方图 {#ggplot2-histogram}

直方图用来查看连续变量的分布


```r
ggplot(diamonds, aes(price)) + geom_histogram(bins = 30)
```

\begin{figure}

{\centering \includegraphics{data-visualization_files/figure-latex/unnamed-chunk-43-1} 

}

\caption{钻石价格的分布}(\#fig:unnamed-chunk-43)
\end{figure}

堆积直方图


```r
ggplot(diamonds, aes(x = price, fill = cut)) + geom_histogram(bins = 30)
```

\begin{figure}

{\centering \includegraphics{data-visualization_files/figure-latex/unnamed-chunk-44-1} 

}

\caption{钻石价格随切割质量的分布}(\#fig:unnamed-chunk-44)
\end{figure}

基础 R 包与 Ggplot2 包绘制的直方图的对比，Base R 绘图速度快，代码更加稳定，Ggplot2 代码简洁，更美观


```r
par(mar = c(2.1, 2.1, 1.5, 0.5))
plot(c(50, 350), c(0, 10),
  type = "n", font.main = 1,
  xlab = "", ylab = "", frame.plot = FALSE, axes = FALSE,
  # xlab = "hp", ylab = "Frequency",
  main = paste("Histogram with Base R", paste(rep(" ", 60), collapse = ""))
)
axis(
  side = 1, at = seq(50, 350, 50), labels = seq(50, 350, 50),
  tick = FALSE, las = 1, padj = 0, mgp = c(3, 0.1, 0)
)
axis(
  side = 2, at = seq(0, 10, 2), labels = seq(0, 10, 2),
  # col = "white", 坐标轴的颜色
  # col.ticks 刻度线的颜色
  tick = FALSE, # 取消刻度线
  las = 1, # 水平方向
  hadj = 1, # 右侧对齐
  mgp = c(3, 0.1, 0) # 纵轴边距线设置为 0.1
)
abline(h = seq(0, 10, 2), v = seq(50, 350, 50), col = "gray90", lty = "solid")
abline(h = seq(1, 9, 2), v = seq(75, 325, 50), col = "gray95", lty = "solid")
hist(mtcars$hp,
  col = "#56B4E9", border = "white",
  freq = TRUE, add = TRUE
  # labels = TRUE, axes = TRUE, ylim = c(0, 10.5),
  # xlab = "hp",main = "Histogram with Base R"
)
mtext("hp", 1, line = 1.0)
mtext("Frequency", 2, line = 1.0)

ggplot(mtcars) +
  geom_histogram(aes(x = hp), fill = "#56B4E9", color = "white", breaks = seq(50, 350, 50)) +
  scale_x_continuous(breaks = seq(50, 350, 50)) +
  scale_y_continuous(breaks = seq(0, 12, 2)) +
  labs(x = "hp", y = "Frequency", title = "Histogram with Ggplot2") +
  theme_minimal(base_size = 12)
```

\begin{figure}

{\centering \subfloat[Base R 直方图(\#fig:base-vs-ggplot2-hist-1)]{\includegraphics[width=0.45\linewidth]{data-visualization_files/figure-latex/base-vs-ggplot2-hist-1} }\subfloat[Ggplot2 直方图(\#fig:base-vs-ggplot2-hist-2)]{\includegraphics[width=0.45\linewidth]{data-visualization_files/figure-latex/base-vs-ggplot2-hist-2} }

}

\caption{直方图}(\#fig:base-vs-ggplot2-hist)
\end{figure}



### 箱线图 {#ggplot2-boxplot}

以 PlantGrowth 数据集为例展示箱线图，在两组不同实验条件下，植物生长的情况，纵坐标是干燥植物的量，横坐标表示不同的实验条件。这是非常典型的适合用箱线图来表达数据的场合，Y 轴对应数值型变量，X 轴对应分类变量，在 R 语言中，分类变量的类型是 factor


```r
data("PlantGrowth")
str(PlantGrowth)
```

```
## 'data.frame':	30 obs. of  2 variables:
##  $ weight: num  4.17 5.58 5.18 6.11 4.5 4.61 5.17 4.53 5.33 5.14 ...
##  $ group : Factor w/ 3 levels "ctrl","trt1",..: 1 1 1 1 1 1 1 1 1 1 ...
```


```r
ggplot(data = PlantGrowth, aes(x = group, y = weight)) + geom_boxplot()
```



\begin{center}\includegraphics{data-visualization_files/figure-latex/PlantGrowth-boxplot-1} \end{center}

PlantGrowth 数据量比较小，此时比较适合采用抖动散点图，抖动是为了避免点之间相互重叠，为了增加不同类别之间的识别性，我们可以用不同的点的形状或者不同的颜色来表示类别


```r
ggplot(data = PlantGrowth, aes(x = group, y = weight, shape = group)) + geom_jitter()
```



\begin{center}\includegraphics{data-visualization_files/figure-latex/PlantGrowth-jitter-1} \end{center}

```r
ggplot(data = PlantGrowth, aes(x = group, y = weight, color = group)) + geom_jitter()
```



\begin{center}\includegraphics{data-visualization_files/figure-latex/PlantGrowth-jitter-2} \end{center}



```r
boxplot(weight ~ group,
  data = PlantGrowth,
  ylab = "Dried weight of plants", col = "lightgray",
  notch = FALSE, varwidth = TRUE
)
```



\begin{center}\includegraphics{data-visualization_files/figure-latex/unnamed-chunk-46-1} \end{center}


以钻石切割质量 cut 为分面依据，以钻石颜色类别 color 为 x 轴，钻石价格为 y 轴，绘制箱线图\@ref(fig:boxplot-facet-color)


```r
ggplot(diamonds, aes(x = color, y = price, color = cut)) +
  geom_boxplot(show.legend = FALSE) +
  facet_grid(~cut)
```

\begin{figure}

{\centering \includegraphics{data-visualization_files/figure-latex/boxplot-facet-color-1} 

}

\caption{箱线图}(\#fig:boxplot-facet-color)
\end{figure}

我们当然还可以添加钻石的纯净度 clarity 作为分面依据，那么箱线图可以为图 \@ref(fig:boxplot-facet-color-clarity-1)


```r
ggplot(diamonds, aes(x = color, y = price, color = cut)) +
  geom_boxplot(show.legend = FALSE) +
  facet_grid(clarity ~ cut)
```

\begin{figure}

{\centering \includegraphics{data-visualization_files/figure-latex/boxplot-facet-color-clarity-1-1} 

}

\caption{复合分面箱线图}(\#fig:boxplot-facet-color-clarity-1)
\end{figure}

经过观察，我们发现水平分类过多，考虑用切割质量 cut 替换钻石颜色 color 绘图，但是由于分类过细，图信息展示不简练，反而不好，如图 \@ref(fig:boxplot-facet-color-clarity-2)


```r
ggplot(diamonds, aes(x = cut, y = price, color = cut)) +
  geom_boxplot(show.legend = FALSE) +
  facet_grid(clarity ~ color)
ggplot(diamonds, aes(x = cut, y = price, color = color)) +
  geom_boxplot(show.legend = FALSE) +
  facet_grid(clarity ~ color)
```

\begin{figure}

{\centering \subfloat[切割质量cut上色(\#fig:boxplot-facet-color-clarity-2-1)]{\includegraphics{data-visualization_files/figure-latex/boxplot-facet-color-clarity-2-1} }\newline\subfloat[钻石颜色配色(\#fig:boxplot-facet-color-clarity-2-2)]{\includegraphics{data-visualization_files/figure-latex/boxplot-facet-color-clarity-2-2} }

}

\caption{箱线图配色}(\#fig:boxplot-facet-color-clarity-2)
\end{figure}

### 函数图 {#sec-ggplot2-function}

蝴蝶图的参数方程如下

\begin{align}
x &= \sin t \big(\mathrm e^{\cos t} - 2 \cos 4t + \sin^5(\frac{t}{12})\big) \\
y &= \cos t \big(\mathrm e^{\cos t} - 2 \cos 4t + \sin^5(\frac{t}{12})\big), t \in [- \pi, \pi]
\end{align}

### 密度图 {#sec-ggplot2-density}



```r
ggplot(mpg, aes(cty)) +
  geom_density(aes(fill = factor(cyl)), alpha = 0.8) +
  labs(
    title = "Density plot",
    subtitle = "City Mileage Grouped by Number of cylinders",
    caption = "Source: mpg",
    x = "City Mileage",
    fill = "# Cylinders"
  )
```

\begin{figure}

{\centering \includegraphics{data-visualization_files/figure-latex/mpg-cyl-density-1} 

}

\caption{按汽缸数分组的城市里程}(\#fig:mpg-cyl-density)
\end{figure}

添加透明度，解决遮挡


```r
ggplot(diamonds, aes(x = price, fill = cut)) + geom_density()
```

\begin{figure}

{\centering \includegraphics{data-visualization_files/figure-latex/density-1} 

}

\caption{密度图}(\#fig:density-1)
\end{figure}

```r
ggplot(diamonds, aes(x = price, fill = cut)) + geom_density(alpha = 0.5)
```

\begin{figure}

{\centering \includegraphics{data-visualization_files/figure-latex/density-2} 

}

\caption{添加透明度的密度图}(\#fig:density-2)
\end{figure}

堆积密度图


```r
ggplot(diamonds, aes(x = price, fill = cut)) +
  geom_density(position = "stack")
```

\begin{figure}

{\centering \includegraphics{data-visualization_files/figure-latex/stack-density-1} 

}

\caption{堆积密度图}(\#fig:stack-density)
\end{figure}

条件密度估计


```r
# You can use position="fill" to produce a conditional density estimate
ggplot(diamonds, aes(carat, stat(count), fill = cut)) +
  geom_density(position = "fill")
```

\begin{figure}

{\centering \includegraphics{data-visualization_files/figure-latex/unnamed-chunk-47-1} 

}

\caption{条件密度估计图}(\#fig:unnamed-chunk-47)
\end{figure}


岭线图是密度图的一种变体，可以防止密度曲线重叠在一起


```r
ggplot(diamonds) +
  ggridges::geom_density_ridges(aes(x = price, y = color, fill = color))
```



\begin{center}\includegraphics{data-visualization_files/figure-latex/unnamed-chunk-48-1} \end{center}

二维的密度图又是一种延伸


```r
ggplot(diamonds, aes(x = carat, y = price)) +
  geom_density_2d(aes(color = cut)) +
  facet_grid(~cut)
```



\begin{center}\includegraphics{data-visualization_files/figure-latex/unnamed-chunk-49-1} \end{center}

`stat` 函数，特别是 nlevel 参数，在密度曲线之间填充我们又可以得到热力图


```r
ggplot(diamonds, aes(x = carat, y = price)) +
  stat_density_2d(aes(fill = stat(nlevel)), geom = "polygon") +
  facet_grid(. ~ cut)
```



\begin{center}\includegraphics{data-visualization_files/figure-latex/unnamed-chunk-50-1} \end{center}

`gemo_hex` 也是二维密度图的一种变体，特别适合数据量比较大的情形


```r
ggplot(diamonds, aes(x = carat, y = price)) + geom_hex() +
  scale_fill_viridis_c()
```



\begin{center}\includegraphics{data-visualization_files/figure-latex/unnamed-chunk-51-1} \end{center}


[heatmaps in ggplot2](https://themockup.blog/posts/2020-08-28-heatmaps-in-ggplot2/) 二维密度图


```r
ggplot(faithful, aes(x = eruptions, y = waiting)) +
  stat_density_2d(aes(fill = ..level..), geom = "polygon") +
  xlim(1, 6) +
  ylim(40, 100)

ggplot(faithful, aes(x = eruptions, y = waiting)) +
  stat_density2d(aes(fill = stat(level)), geom = "polygon") +
  scale_fill_viridis_c(option = "viridis") +
  xlim(1, 6) +
  ylim(40, 100)
```

\begin{figure}

{\centering \subfloat[默认调色板(\#fig:density-2d-1)]{\includegraphics[width=0.45\linewidth]{data-visualization_files/figure-latex/density-2d-1} }\subfloat[viridis 调色板(\#fig:density-2d-2)]{\includegraphics[width=0.45\linewidth]{data-visualization_files/figure-latex/density-2d-2} }

}

\caption{二维密度图}(\#fig:density-2d)
\end{figure}

::: {.rmdtip data-latex="{提示}"}
`MASS::kde2d()` 实现二维核密度估计，**ggplot2** 包提供了两种等价的绘图方式

1. `stat_density_2d()` 和 `..`
1. `stat_density2d()` 和 `stat()`
:::


```r
plotly::plot_ly(
  data = faithful, x = ~eruptions,
  y = ~waiting, type = "histogram2dcontour"
) %>%
  plotly::config(displayModeBar = FALSE)

# plot_ly(faithful, x = ~waiting, y = ~eruptions) %>% 
#   add_histogram2d() %>% 
#   add_histogram2dcontour()
```

延伸一下，热力图


```r
library(KernSmooth)
den <- bkde2D(x = faithful, bandwidth = c(0.7, 7))
# 热力图
p1 <- plotly::plot_ly(x = den$x1, y = den$x2, z = den$fhat) %>%
  plotly::config(displayModeBar = FALSE) %>%
  plotly::add_heatmap()

# 等高线图
p2 <- plotly::plot_ly(x = den$x1, y = den$x2, z = den$fhat) %>%
  plotly::config(displayModeBar = FALSE) %>%
  plotly::add_contour()

htmltools::tagList(p1, p2)
```

### 提琴图 {#sec-ggplot2-violin}

2004 年 Daniel Adler 开发 [vioplot](https://github.com/TomKellyGenetics/vioplot) 包实现提琴图的绘制，它可能是最早实现此功能的 R 包，随后10余年没有更新却一直坚挺在 CRAN 上，非常难得，好在 Thomas Kelly 已经接手维护。另一款绘制提琴图的 R 包是 Peter Kampstra 开发的 [beanplot](https://cran.r-project.org/package=beanplot) [@beanplot_2008_jss]，也存在很多年了，不过随着时间的变迁，比较现代的方式是 **ggplot2** 带来的 `geom_violin()` 扔掉了很多依赖，也是各种图形的汇集地，可以看作是最佳实践。提琴图比起箱线图优势在于呈现更多的分布信息，其次在于更加美观，但是就目前来说箱线图的受众比提琴图要多很多，毕竟前者是包含更多统计信息，如图\@ref(fig:boxplot-violin) 所示。


```r
boxplot(count ~ spray, data = InsectSprays)
vioplot::vioplot(count ~ spray, data = InsectSprays, col = "lightgray")
ggplot(InsectSprays, aes(x = spray, y = count)) +
  geom_violin(fill = "lightgray") +
  theme_minimal()
beanplot::beanplot(count ~ spray, data = InsectSprays, col = "lightgray")
```

\begin{figure}

{\centering \subfloat[简单箱线图(\#fig:boxplot-violin-1)]{\includegraphics[width=0.45\linewidth]{data-visualization_files/figure-latex/boxplot-violin-1} }\subfloat[vioplot 绘制的提琴图(\#fig:boxplot-violin-2)]{\includegraphics[width=0.45\linewidth]{data-visualization_files/figure-latex/boxplot-violin-2} }\newline\subfloat[ggplot2 绘制的提琴图(\#fig:boxplot-violin-3)]{\includegraphics[width=0.45\linewidth]{data-visualization_files/figure-latex/boxplot-violin-3} }\subfloat[beanplot 绘制的提琴图(\#fig:boxplot-violin-4)]{\includegraphics[width=0.45\linewidth]{data-visualization_files/figure-latex/boxplot-violin-4} }

}

\caption{几种不同的提琴图}(\#fig:boxplot-violin)
\end{figure}

[ggnormalviolin](https://github.com/wjschne/ggnormalviolin) 包在给定均值和标准差的情况下，绘制正态分布的概率密度曲线，如图 \@ref(fig:normal-violin) 所示。


```r
library(ggnormalviolin)
with(
  aggregate(
    data = iris, Sepal.Length ~ Species,
    FUN = function(x) c(dist_mean = mean(x), dist_sd = sd(x))
  ),
  cbind.data.frame(Sepal.Length, Species)
) %>%
  ggplot(aes(x = Species, mu = dist_mean, sigma = dist_sd, fill = Species)) +
  geom_normalviolin() +
  theme_minimal()
```

\begin{figure}

{\centering \includegraphics{data-visualization_files/figure-latex/normal-violin-1} 

}

\caption{正态分布的概率密度曲线}(\#fig:normal-violin)
\end{figure}


### 抖动图 {#ggplot2-jitter}


抖动图适合数据量比较小的情况


```r
ggplot(mpg, aes(x = class, y = hwy, color = class)) + geom_jitter()
```



\begin{center}\includegraphics{data-visualization_files/figure-latex/unnamed-chunk-53-1} \end{center}

抖不抖，还是抖一下


```r
ggplot(iris, aes(x = Species, y = Sepal.Length)) +
  geom_point(aes(fill = Species), size = 5, shape = 21, colour = "grey20") +
  # geom_boxplot(outlier.colour = NA, fill = NA, colour = "grey20") +
  labs(title = "Not Jittered")
```



\begin{center}\includegraphics{data-visualization_files/figure-latex/unnamed-chunk-54-1} \end{center}

```r
ggplot(iris, aes(x = Species, y = Sepal.Length)) +
  geom_point(aes(fill = Species),
    size = 5, shape = 21, colour = "grey20",
    position = position_jitter(width = 0.2, height = 0.1)
  ) +
  # geom_boxplot(outlier.colour = NA, fill = NA, colour = "grey20") +
  labs(title = "Jittered")
```



\begin{center}\includegraphics{data-visualization_files/figure-latex/unnamed-chunk-54-2} \end{center}

在数据量比较大的时候，可以用箱线图、密度图、提琴图


```r
ggplot(sub_diamonds, aes(x = cut, y = price)) + geom_jitter()
```

\begin{figure}

{\centering \includegraphics{data-visualization_files/figure-latex/unnamed-chunk-55-1} 

}

\caption{抖动图的反例}(\#fig:unnamed-chunk-55)
\end{figure}

上色和分面都不好使的抖动图，因为区分度变小


```r
ggplot(sub_diamonds, aes(x = color, y = price, color = color)) +
  geom_jitter() +
  facet_grid(clarity ~ cut)
```

\begin{figure}

{\centering \includegraphics{data-visualization_files/figure-latex/unnamed-chunk-56-1} 

}

\caption{根据钻石颜色上色}(\#fig:unnamed-chunk-56)
\end{figure}

箱线图此时不宜分的过细


```r
ggplot(diamonds, aes(x = color, y = price, color = color)) +
  geom_boxplot() +
  facet_grid(cut ~ clarity)
```

\begin{figure}

{\centering \includegraphics{data-visualization_files/figure-latex/boxplot-facet-cut-clarity-1} 

}

\caption{箱线图}(\#fig:boxplot-facet-cut-clarity)
\end{figure}

所以这样更好，先按纯净度分面，再对比不同的颜色，钻石价格的差异


```r
ggplot(diamonds, aes(x = color, y = price, color = color)) +
  geom_boxplot() +
  facet_grid(~clarity)
```

\begin{figure}

{\centering \includegraphics{data-visualization_files/figure-latex/boxplot-facet-clarity-1} 

}

\caption{钻石按纯净度分面}(\#fig:boxplot-facet-clarity)
\end{figure}

最好只比较一个维度，不同颜色钻石的价格对比


```r
ggplot(diamonds, aes(x = color, y = price, color = color)) +
  geom_boxplot()
```

\begin{figure}

{\centering \includegraphics{data-visualization_files/figure-latex/boxplot-color-1} 

}

\caption{不同颜色钻石的价格比较}(\#fig:boxplot-color)
\end{figure}


### 蜂群图 {#sec-ggplot2-beeswarm}

在样本点有限的情况下，用蜜蜂图代替普通的抖动图，可视化效果会好很多，如图 \@ref(fig:beeswarm) 所示。Erik Clarke 开发的 [ggbeeswarm](https://github.com/eclarke/ggbeeswarm) 包可以将随机抖动的散点图朝着比较规律的方向聚合，又不丢失数据本身的准确性。


```r
library(ggbeeswarm)
p1 <- ggplot(iris, aes(Species, Sepal.Length)) +
  geom_jitter() +
  theme_minimal()
p2 <- ggplot(iris, aes(Species, Sepal.Length)) +
  geom_quasirandom() +
  theme_minimal()
p1 + p2
```

\begin{figure}

{\centering \includegraphics{data-visualization_files/figure-latex/beeswarm-1} 

}

\caption{蜜蜂图可视化效果比抖动图好}(\#fig:beeswarm)
\end{figure}



### 玫瑰图 {#ggplot2-rose}

南丁格尔风玫瑰图[^nightingale-rose] 可以作为堆积条形图，分组条形图


```r
ggplot(diamonds, aes(x = color, fill = clarity)) +
  geom_bar()
```

\begin{figure}

{\centering \includegraphics{data-visualization_files/figure-latex/stack-to-rose-1} 

}

\caption{堆积条形图转风玫瑰图}(\#fig:stack-to-rose-1)
\end{figure}

```r
ggplot(diamonds, aes(x = color, fill = clarity)) +
  geom_bar() +
  coord_polar()
```

\begin{figure}

{\centering \includegraphics{data-visualization_files/figure-latex/stack-to-rose-2} 

}

\caption{堆积条形图转风玫瑰图}(\#fig:stack-to-rose-2)
\end{figure}


```r
# 风玫瑰图 http://blog.csdn.net/Bone_ACE/article/details/47624987
set.seed(2018)
# 随机生成100次风向，并汇集到16个区间内
direction <- cut_interval(runif(100, 0, 360), n = 16)
# 随机生成100次风速，并划分成4种强度
mag <- cut_interval(rgamma(100, 15), 4)
dat <- data.frame(direction = direction, mag = mag)
# 将风向映射到X轴，频数映射到Y轴，风速大小映射到填充色，生成条形图后再转为极坐标形式即可
p <- ggplot(dat, aes(x = direction, y = ..count.., fill = mag))
p + geom_bar(colour = "white") +
  coord_polar() +
  theme(axis.ticks = element_blank(), axis.text.y = element_blank()) +
  labs(x = "", y = "", fill = "Magnitude")
```

\begin{figure}

{\centering \includegraphics{data-visualization_files/figure-latex/wind-rose-1} 

}

\caption{风玫瑰图}(\#fig:wind-rose)
\end{figure}


```r
p + geom_bar(position = "fill") +
  coord_polar() +
  theme(axis.ticks = element_blank(), axis.text.y = element_blank()) +
  labs(x = "", y = "", fill = "Magnitude")
```



\begin{center}\includegraphics{data-visualization_files/figure-latex/unnamed-chunk-57-1} \end{center}


[^nightingale-rose]: https://mbostock.github.io/protovis/ex/crimea-rose-full.html

### 瓦片图 {#sec-ggplot2-tile}


```r
p1 <- expand.grid(months = month.abb, years = 1949:1960) %>%
  transform(num = as.vector(AirPassengers)) %>%
  ggplot(aes(x = years, y = months, fill = num)) +
  scale_fill_continuous(type = "viridis") +
  geom_tile(color = "white", size = 0.4) +
  scale_x_continuous(
    expand = c(0.01, 0.01),
    breaks = seq(1949, 1960, by = 1), labels = 1949:1960
  ) +
  theme_minimal(base_size = 10.54, base_family = "source-han-serif-cn") +
  theme(legend.position = "top") +
  labs(x = "年", y = "月", fill = "人数")

p2 <- expand.grid(months = month.abb, years = 1949:1960) %>%
  transform(num = as.vector(AirPassengers)) %>%
  ggplot(aes(x = years, y = months, color = num)) +
  geom_point(pch = 15, size = 8) +
  scale_color_distiller(palette = "Spectral") +
  scale_x_continuous(
    expand = c(0.01, 0.01),
    breaks = seq(1949, 1960, by = 1), labels = 1949:1960
  ) +
  theme_minimal(base_size = 10.54, base_family = "source-han-sans-cn") +
  theme(legend.position = "top") +
  labs(x = "年", y = "月", color = "人数")
p1 + p2
```

\begin{figure}

{\centering \includegraphics{data-visualization_files/figure-latex/geom-tile-1} 

}

\caption{1949-1960年国际航线乘客数量的月度趋势}(\#fig:geom-tile)
\end{figure}

### 日历图 {#sec-ggplot2-calendar}

airquality 数据集记录了1973年5月至9月纽约的空气质量，包括气温（华氏度）、风速（米/小时）、紫外线强度、臭氧含量四个指标，图 \@ref(fig:calendar-airquality) 展示了每日的气温变化。


```r
airquality %>%
  transform(Date = seq.Date(
    from = as.Date("1973-05-01"),
    to = as.Date("1973-09-30"), by = "day"
  )) %>%
  transform(
    Week = as.integer(format(Date, "%W")),
    Year = as.integer(format(Date, "%Y")),
    Weekdays = factor(weekdays(Date, abbreviate = T),
      levels = c("Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun")
    )
  ) %>%
  ggplot(aes(x = Week, y = Weekdays, fill = Temp)) +
  scale_fill_distiller(name = "Temp (F)", palette = "Spectral") +
  geom_tile(color = "white", size = 0.4) +
  facet_wrap("Year", ncol = 1) +
  scale_x_continuous(
    expand = c(0, 0),
    breaks = seq(1, 52, length = 12),
    labels = month.abb
  )
```

\begin{figure}

{\centering \includegraphics{data-visualization_files/figure-latex/calendar-airquality-1} 

}

\caption{1973年5月至9月纽约的气温变化}(\#fig:calendar-airquality)
\end{figure}

::: {.rmdnote data-latex="{注意}"}
图 \@ref(fig:calendar-airquality) 横轴的刻度标签换成了月份，一个月为四周，一年 52～53 周，每周的第一天约定为星期一，1973年05月01日为星期二。代码中颇为技巧的在于 `format()` 函数从 Date 日期类型的数据提取第几周， 用 `weekdays()` 函数提取星期几，而 month.abb 则是一个内置常量，12个月份的英文缩写。在调用其它 R 包处理日期数据时要特别小心，要留意一周的的第一天是星期几，有的是星期一，有的是星期日，这往往和宗教信仰相关，星期日在西方也叫礼拜天。 上面 Base R 提供的日期函数认为一周的第一天是星期一，而调用 **data.table** 的话，默认一周是从星期日（礼拜天）开始的。


```r
# https://d.cosx.org/d/421230
weekdays(Sys.Date(), abbreviate = TRUE)
```

```
## [1] "Tue"
```

```r
data.table::wday(Sys.Date())
```

```
## [1] 3
```

:::




```r
library(gert)
library(ggplot2)
git_config_set("user.name", "XiangyunHuang")
git_config_set("user.email", "xiangyunfaith@outlook.com")

dat <- git_log(max = 1000)

dat <- transform(dat,
  date = format(time, "%Y-%m-%d"),
  year = format(time, "%Y") ,
  month = format(time, "%m"),
  weekday = factor(format(time, "%a"),
    levels = c("Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat")
  ),
  week = as.integer(format(time, "%W"))
)
```

本书的活跃情况


```r
dat1 <- aggregate(formula = commit ~ year + month, data = dat, FUN = length)
# 条形图
ggplot(data = dat1, aes(x = month, y = commit, fill = year)) +
  geom_bar(stat = "identity", position = "identity")
```



\begin{center}\includegraphics{data-visualization_files/figure-latex/unnamed-chunk-60-1} \end{center}



```r
# 日历图
dat2 <- aggregate(formula = commit ~ year + week + weekday, data = dat, FUN = length)

dat2 <- transform(dat2, colorBin = cut(commit, breaks = c(0, 5, 10, 15, 20, 25)))

ggplot(data = dat2, aes(x = week, y = weekday, fill = colorBin)) +
  scale_fill_brewer(name = "commit", palette = "Greens") +
  geom_tile(color = "white", size = 0.4) +
  facet_wrap("year", ncol = 1) +
  scale_x_continuous(
    expand = c(0, 0),
    breaks = seq(1, 52, length = 12),
    labels = month.abb
  ) +
  labs(x = "", y = "")
```

\begin{figure}

{\centering \includegraphics{data-visualization_files/figure-latex/calendar-masr-1} 

}

\caption{《现代统计图形》的活跃情况}(\#fig:calendar-masr)
\end{figure}

### 岭线图 {#sec-ggplot2-ridgeline}

**ggridges** 包，[于淼](https://yufree.cn/) 对此图形的来龙去脉做了比较系统的阐述，详见统计之都主站文章[叠嶂图的前世今生](https://cosx.org/2018/04/ridgeline-story/)


```r
library(ggridges)
ggplot(lincoln_weather, aes(x = `Mean Temperature [F]`, y = Month, fill = stat(x))) +
  geom_density_ridges_gradient(scale = 3, rel_min_height = 0.01, gradient_lwd = 1.) +
  scale_x_continuous(expand = c(0, 0)) +
  scale_y_discrete(expand = expansion(mult = c(0.01, 0.25))) +
  scale_fill_viridis_c(name = "Temp. [F]", option = "C") +
  labs(
    title = 'Temperatures in Lincoln NE',
    subtitle = 'Mean temperatures (Fahrenheit) by month for 2016'
  ) +
  theme_ridges(font_size = 13, grid = TRUE) + 
  theme(axis.title.y = element_blank())
```

\begin{figure}

{\centering \includegraphics{data-visualization_files/figure-latex/lincoln-weather-1} 

}

\caption{2016年在内布拉斯加州林肯市的天气变化}(\#fig:lincoln-weather)
\end{figure}

通过数据可视化的手段帮助肉眼检查两组数据的分布


```r
p1 <- ggplot(sleep, aes(x = extra, y = group, fill = group)) +
  geom_density_ridges() +
  theme_ridges()

p2 <- ggplot(diamonds, aes(x = price, y = color, fill = color)) +
  geom_density_ridges() +
  theme_ridges()

p1 / p2
```

\begin{figure}

{\centering \includegraphics{data-visualization_files/figure-latex/sleep-diamonds-1} 

}

\caption{比较数据的分布}(\#fig:sleep-diamonds)
\end{figure}

[ridgeline](https://github.com/R-CoderDotCom/ridgeline) 提供 Base R 绘图方案


\begin{figure}

{\centering \includegraphics[width=0.65\linewidth]{data-visualization_files/figure-latex/ridge-1} 

}

\caption{岭线图}(\#fig:ridge)
\end{figure}

### 椭圆图 {#sec-ggplot2-ellipse}

type 指定多元分布的类型，`type = "t"` 和 `type = "norm"` 分别表示 t 分布和正态分布，`geom = "polygon"`，以 `eruptions > 3` 分为两组


```r
ggplot(faithful, aes(x = waiting, y = eruptions)) +
  geom_point() +
  stat_ellipse()

ggplot(faithful, aes(waiting, eruptions, color = eruptions > 3)) +
  geom_point() +
  stat_ellipse(type = "norm", linetype = 2) +
  stat_ellipse(type = "t") +
  theme(legend.position = "none")

ggplot(faithful, aes(waiting, eruptions, fill = eruptions > 3)) +
  stat_ellipse(geom = "polygon") +
  theme(legend.position = "none")
```

\begin{figure}

{\centering \subfloat[简单椭圆图(\#fig:ellipse-1)]{\includegraphics[width=0.45\linewidth]{data-visualization_files/figure-latex/ellipse-1} }\subfloat[正态和 t 分布(\#fig:ellipse-2)]{\includegraphics[width=0.45\linewidth]{data-visualization_files/figure-latex/ellipse-2} }\newline\subfloat[填充几何图形(\#fig:ellipse-3)]{\includegraphics[width=0.45\linewidth]{data-visualization_files/figure-latex/ellipse-3} }

}

\caption{几种不同的椭圆图}(\#fig:ellipse)
\end{figure}

### 包络图 {#sec-ggplot2-chull}

ggpubr 包提供了 `stat_chull()` 图层


```r
library(ggpubr)
ggscatter(mpg, x = "displ", y = "hwy", color = "drv")+
 stat_chull(aes(color = drv, fill = drv), alpha = 0.1, geom = "polygon")
```

\begin{figure}

{\centering \includegraphics{data-visualization_files/figure-latex/stat-chull-1} 

}

\caption{包络图}(\#fig:stat-chull)
\end{figure}

其背后的原理如下


```r
stat_chull
```

```
## function (mapping = NULL, data = NULL, geom = "path", position = "identity", 
##     na.rm = FALSE, show.legend = NA, inherit.aes = TRUE, ...) 
## {
##     layer(stat = StatChull, data = data, mapping = mapping, geom = geom, 
##         position = position, show.legend = show.legend, inherit.aes = inherit.aes, 
##         params = list(na.rm = na.rm, ...))
## }
## <bytecode: 0x56509116ee08>
## <environment: namespace:ggpubr>
```


```r
StatChull <- ggproto("StatChull", Stat,
  compute_group = function(data, scales) {
    data[chull(data$x, data$y), , drop = FALSE]
  },
  required_aes = c("x", "y")
)

stat_chull <- function(mapping = NULL, data = NULL, geom = "polygon",
                       position = "identity", na.rm = FALSE, show.legend = NA,
                       inherit.aes = TRUE, ...) {
  layer(
    stat = StatChull, data = data, mapping = mapping, geom = geom,
    position = position, show.legend = show.legend, inherit.aes = inherit.aes,
    params = list(na.rm = na.rm, ...)
  )
}

ggplot(mpg, aes(displ, hwy)) + 
  geom_point() + 
  stat_chull(fill = NA, colour = "black")

ggplot(mpg, aes(displ, hwy, colour = drv)) + 
  geom_point() + 
  stat_chull(fill = NA)
```

### 拟合图 {#sec-ggplot2-fit}


```r
xx <- -9:9
yy <- sqrt(abs(xx))
plot(xx, yy,
  col = "red",
  xlab = expression(x),
  ylab = expression(sqrt(abs(x)))
)
lines(spline(xx, yy, n = 101, method = "fmm", ties = mean), col = "pink")

myspline <- function(formula, data, ...) {
  dat <- model.frame(formula, data)
  res <- splinefun(dat[[2]], dat[[1]])
  class(res) <- "myspline"
  res
}

predict.myspline <- function(object, newdata, ...) {
  object(newdata[[1]])
}

data.frame(x = -9:9) %>%
  transform(y = sqrt(abs(x))) %>%
  ggplot(aes(x = x, y = y)) +
  geom_point(color = "red", pch = 1, size = 2) +
  stat_smooth(method = myspline, formula = y~x, se = F, color = "pink") +
  labs(x = expression(x), y = expression(sqrt(abs(x)))) +
  theme_minimal()
```

\begin{figure}

{\centering \includegraphics[width=0.45\linewidth]{data-visualization_files/figure-latex/spline-fun-1} \includegraphics[width=0.45\linewidth]{data-visualization_files/figure-latex/spline-fun-2} 

}

\caption{自定义样条函数}(\#fig:spline-fun)
\end{figure}

下面以真实数据集 trees 为例，介绍 `geom_smooth()` 支持的拟合方法，比如 `"lm"` 线性回归和 `"nls"` 非线性回归


```r
ggplot(trees, aes(x = log(Girth), y = log(Volume))) +
  geom_point() +
  geom_smooth(method = "lm", formula = y ~ x, se = FALSE)

ggplot(trees, aes(x = Girth, y = Volume)) +
  geom_point() +
  geom_smooth(
    method = "nls", formula = y ~ a * x^2 + b, se = F,
    method.args = list(start = list(a = 5, b = -36))
  )
```

\begin{figure}

{\centering \includegraphics[width=0.45\linewidth]{data-visualization_files/figure-latex/smooth-methods-1} \includegraphics[width=0.45\linewidth]{data-visualization_files/figure-latex/smooth-methods-2} 

}

\caption{平滑方法}(\#fig:smooth-methods)
\end{figure}

### 地形图 {#sec-ggplot2-raster}

区域之间以轮廓分割，轮廓之间以相同的颜色填充，Cleveland 把这个叫做 level plot， **lattice** 包中 `levelplot()` 函数正来源于此。

[Auckland's Maunga Whau Volcano](https://en.wikipedia.org/wiki/Maungawhau) 是火山喷发后留下的碴堆，位于新西兰奥克兰伊甸山郊区。[Ross Ihaka](https://www.stat.auckland.ac.nz/~ihaka/) 收集了它的地形数据，命名为 volcano，打包在 R 软件环境中，见图 \@ref(fig:elevation-volcano)


```r
filled.contour(volcano,
  color.palette = terrain.colors,
  plot.title = title(
    main = "The Topography of Maunga Whau",
    xlab = "Meters North", ylab = "Meters West"
  ),
  plot.axes = {
    axis(1, seq(100, 800, by = 100))
    axis(2, seq(100, 600, by = 100))
  },
  key.title = title(main = "Height\n(meters)"),
  key.axes = axis(4, seq(90, 190, by = 10))
)
```

\begin{figure}

{\centering \includegraphics{data-visualization_files/figure-latex/elevation-volcano-1} 

}

\caption{image 图形}(\#fig:elevation-volcano)
\end{figure}

美国西南部犹他州锡安国家公园的高程珊格数据 elevation，该数据集由 [Jakub Nowosad](https://nowosad.github.io/) 收集于 [spDataLarge](https://github.com/Nowosad/spDataLarge) 包内，由于该 R 包收集的地理信息数据很多又很大，超出了 CRAN 对 R 包的大小限制，需要从作者制作的 drat 站点下载。


```r
install.packages("spDataLarge", repos = "https://nowosad.github.io/drat/")
```

elevation 数据集通过雷达地形测绘 SRTM (Shuttle Radar Topography Mission) 获得，其分辨率为 90m $\times$ 90m，属于高精度地形网格数据，更多细节描述见 <http://srtm.csi.cgiar.org/>，图 \@ref(fig:elevation-zion) 将公园的地形清晰地展示出来了，读者不妨再借助维基百科词条 (<https://en.wikipedia.org/wiki/Zion_National_Park>) 从整体上了解该公园的情况，结合丰富的实景图可以获得更加直观的感受。


```r
data("elevation", package = "spDataLarge")
raster::plot(elevation, asp = NA)
```

\begin{figure}

{\centering \includegraphics{data-visualization_files/figure-latex/elevation-zion-1} 

}

\caption{锡安国家公园的高程珊格数据}(\#fig:elevation-zion)
\end{figure}

### 树状图 {#sec-ggplot2-treemap}

数据集 GNI2014 来自 [**treemap**](https://github.com/mtennekes/treemap) 包，是一个 data.frame 类型的数据对象，记录了 2014 年每个国家的人口总数 population 和国民人均收入 GNI，数据样例见下方：


```r
library(treemap)
data(GNI2014, package = "treemap")
subset(GNI2014, subset = grepl(x = country, pattern = 'China'))
```

```
##    iso3              country continent population   GNI
## 7   MAC     Macao SAR, China      Asia     559846 76270
## 33  HKG Hong Kong SAR, China      Asia    7061200 40320
## 87  CHN                China      Asia 1338612970  7400
```

数据呈现明显的层级结构，从大洲到国家记录人口数量和人均收入，矩阵树图以方块大小表示人口数量，以颜色深浅表示人均收入，见图\@ref(fig:treemap-grid)


```r
treemap(GNI2014,
  index = c("continent", "iso3"),
  vSize = "population", 
  vColor = "GNI",
  type = "value",
  format.legend = list(scientific = FALSE, big.mark = " ")
)
```

\begin{figure}

{\centering \includegraphics{data-visualization_files/figure-latex/treemap-grid-1} 

}

\caption{矩阵树图}(\#fig:treemap-grid)
\end{figure}

::: {.rmdtip data-latex="{提示}"}
数据集 GNI2014 的另一种呈现方式是将数据铺到地图上，可以借助 **highcharter** 包的 `hcmap()` 函数来实现。


```r
# 代码块不要启用缓存
data(GNI2014, package = "treemap")
library(highcharter)
hcmap(
  "custom/world-robinson-lowres",
  data = GNI2014,
  name = "Gross national income per capita",
  value = "GNI",
  borderWidth = 0,
  nullColor = "gray",
  joinBy = c("iso-a3", "iso3")
) %>%
  hc_colorAxis(
    stops = color_stops(
      colors = terrain.colors(n = 10)
    ),
    type = "logarithmic"
  )
```

:::

[**treemapify**](https://github.com/wilkox/treemapify) 包基于 ggplot2 制作树状图，类似地，该 R 包内置了数据集 G20，记录了世界主要经济体 G20 (<https://en.wikipedia.org/wiki/G20>) 的经济和人口信息，国家 GDP （单位：百万美元）`gdp_mil_usd` 和人类发展指数 `hdi`。相比于 GNI2014，它还包含了两列标签信息：经济发展阶段和所处的半球。图@(fig:treemap-ggplot2)以南北半球 hemisphere 分面，以色彩填充区域 region，以 `gdp_mil_usd` 表示区域大小


```r
library(treemapify)
ggplot(G20, aes(
  area = gdp_mil_usd, fill = region,
  label = country, subgroup = region
)) +
  geom_treemap() +
  geom_treemap_text(grow = T, reflow = T, colour = "black") +
  facet_wrap(~hemisphere) +
  scale_fill_brewer(palette = "Set1") +
  theme(legend.position = "bottom") +
  labs(
    title = "The G-20 major economies by hemisphere",
    caption = "The area of each tile represents the country's GDP as a
      proportion of all countries in that hemisphere",
    fill = "Region"
  )
```

\begin{figure}

{\centering \includegraphics{data-visualization_files/figure-latex/treemap-ggplot2-1} 

}

\caption{世界主要经济体G20的人口和经济信息}(\#fig:treemap-ggplot2)
\end{figure}

<!-- https://github.com/DaphneGiorgi/IBMPopSim 钻石数据集 diamonds 对比，连续变量离散化，直方图，分布对比 -->

### 留存图 {#sec-ggplot2-cohort}


```r
cohort <- data.frame(
  cohort = rep(1:5, times = 5:1),
  week = c(1:5, 1:4, 1:3, 1:2, 1),
  value = c(
    75, 73, 54, 23, 3,
    98, 94, 70, 25,
    52, 5, 3,
    44, 15,
    88
  )
)

ggplot(cohort, aes(x = week, y = cohort, fill = value)) +
  geom_tile(color = "white") +
  geom_text(aes(label = value), color = "white") +
  scale_y_reverse() +
  scale_fill_binned(type = "viridis")
```



\begin{center}\includegraphics{data-visualization_files/figure-latex/cohort-ggplot2-1} \end{center}

留存是 [Cohort 分析](https://en.wikipedia.org/wiki/Cohort_analysis) 中的一种情况，还有转化等，首先
定义你的问题，确定度量问题的指标，确定和问题相关的 Cohort （比如时间、空间和用户属性等关键的影响因素），然后数据处理、可视化获得 Cohort 分析结果，最后在实际决策和行动中检验分析结论。

### 瀑布图 {#sec-ggplot2-waterfall}

瀑布图 waterfall 与上月相比，谁增谁减，用瀑布图分别表示占比和绝对数值。[瀑布图 waterfall](https://vita.had.co.nz/papers/ggplot2-wires.pdf)


```r
balance <- data.frame(
  event = c(
    "Starting\nCash", "Sales", "Refunds",
    "Payouts", "Court\nLosses", "Court\nWins", "Contracts", "End\nCash"
  ),
  change = c(2000, 3400, -1100, -100, -6600, 3800, 1400, -2800)
)

balance$balance <- cumsum(c(0, balance$change[-nrow(balance)])) # 累计值
balance$time <- 1:nrow(balance)
balance$flow <- factor(sign(balance$change)) # 变化为正还是为负

ggplot(balance) +
  geom_hline(yintercept = 0, colour = "white", size = 2) +
  geom_rect(aes(
    xmin = time - 0.45, xmax = time + 0.45,
    ymin = balance, ymax = balance + change, fill = flow
  )) +
  geom_text(aes(
    x = time,
    y = pmin(balance, balance + change) - 50,
    label = scales::dollar(change)
  ),
  hjust = 0.5, vjust = 1, size = 3
  ) +
  scale_x_continuous(
    name = "",
    breaks = balance$time,
    labels = balance$event
  ) +
  scale_y_continuous(
    name = "Balance",
    labels = scales::dollar
  ) +
  scale_fill_brewer(palette = "Spectral") +
  theme_minimal()
```

\begin{figure}

{\centering \includegraphics{data-visualization_files/figure-latex/waterfall-1} 

}

\caption{瀑布图}(\#fig:waterfall)
\end{figure}



```r
library(ggplot2)
# AtherEnergy/ggTimeSeries
# 个人收入，国家地区收入
library(ggTimeSeries) # https://github.com/AtherEnergy/ggTimeSeries
dat <- data.frame(year = 2000:2021, dpc = 10:31)
ggplot(data = dat, aes(x = year, y = dpc)) +
  stat_waterfall()
```

### 桑基图 {#sec-ggplot2-sankey}

[ggalluvial](https://github.com/corybrunson/ggalluvial)


```r
titanic_wide <- data.frame(Titanic)
```



```r
head(titanic_wide)
```

```
##   Class    Sex   Age Survived Freq
## 1   1st   Male Child       No    0
## 2   2nd   Male Child       No    0
## 3   3rd   Male Child       No   35
## 4  Crew   Male Child       No    0
## 5   1st Female Child       No    0
## 6   2nd Female Child       No    0
```



```r
library(ggalluvial)
ggplot(data = titanic_wide,
       aes(axis1 = Class, axis2 = Sex, axis3 = Age,
           y = Freq)) +
  scale_x_discrete(limits = c("Class", "Sex", "Age"), expand = c(.2, .05)) +
  xlab("Demographic") +
  geom_alluvium(aes(fill = Survived)) +
  geom_stratum() +
  geom_text(stat = "stratum", aes(label = after_stat(stratum))) +
  theme_minimal() +
  ggtitle("passengers on the maiden voyage of the Titanic",
          "stratified by demographics and survival")
```

\begin{figure}

{\centering \includegraphics{data-visualization_files/figure-latex/ggalluvial-1} 

}

\caption{桑基图}(\#fig:ggalluvial)
\end{figure}

### 词云图 {#ggplot2-wordcloud}

词云 [ggwordcloud](https://github.com/lepennec/ggwordcloud)

### 甘特图 {#ggplot2-gantt}

描述项目进展的甘特图
[ganttrify](https://github.com/giocomai/ganttrify)


### 马赛克图 {#sec-ggplot2-ggmosaic}


```r
library(ggmosaic)
ggplot(data = as.data.frame(UCBAdmissions)) +
  geom_mosaic(aes(weight = Freq, x = product(Gender, Admit), fill = Dept)) +
  coord_flip() +
  theme_minimal() +
  labs(x = "Admit", y = "Gender")
```

\begin{figure}

{\centering \includegraphics{data-visualization_files/figure-latex/ucb-admissions-1} 

}

\caption{UCBAdmissions 马赛克图}(\#fig:ucb-admissions)
\end{figure}


### 凹凸图 {#sec-ggplot2-bump}

[ggbump](https://github.com/davidsjoberg/ggbump) 排序随位置的变化


```r
# remotes::install_github("davidsjoberg/ggbump")
library(ggbump)
# 代码修改自 https://github.com/davidsjoberg/ggbump
df <- data.frame(
  season = c(
    "Spring", "Pre-season", "Summer", "Season finale", "Autumn", "Winter",
    "Spring", "Pre-season", "Summer", "Season finale", "Autumn", "Winter",
    "Spring", "Pre-season", "Summer", "Season finale", "Autumn", "Winter",
    "Spring", "Pre-season", "Summer", "Season finale", "Autumn", "Winter"
  ),
  rank = c(
    1, 3, 4, 2, 1, 4,
    2, 4, 1, 3, 2, 3,
    4, 1, 2, 4, 4, 1,
    3, 2, 3, 1, 3, 2
  ),
  player = c(
    rep("David", 6),
    rep("Anna", 6),
    rep("Franz", 6),
    rep("Ika", 6)
  )
)

# Create factors and order factor
df <- transform(df, season = factor(season, levels = unique(season)))

# Add manual axis labels to plot
ggplot(df, aes(season, rank, color = player)) +
  geom_bump(size = 2, smooth = 20, show.legend = F) +
  geom_point(size = 5, aes(shape = player)) +
  theme_minimal(base_size = 10, base_line_size = 0) +
  theme(panel.grid.major = element_blank(),
        axis.ticks = element_blank()) +
  scale_color_manual(values = RColorBrewer::brewer.pal(name = "Set2", n = 4))
```

```
## Warning in f(...): 'StatBump' needs at least two observations per group

## Warning in f(...): 'StatBump' needs at least two observations per group

## Warning in f(...): 'StatBump' needs at least two observations per group

## Warning in f(...): 'StatBump' needs at least two observations per group

## Warning in f(...): 'StatBump' needs at least two observations per group

## Warning in f(...): 'StatBump' needs at least two observations per group

## Warning in f(...): 'StatBump' needs at least two observations per group

## Warning in f(...): 'StatBump' needs at least two observations per group

## Warning in f(...): 'StatBump' needs at least two observations per group

## Warning in f(...): 'StatBump' needs at least two observations per group

## Warning in f(...): 'StatBump' needs at least two observations per group

## Warning in f(...): 'StatBump' needs at least two observations per group

## Warning in f(...): 'StatBump' needs at least two observations per group

## Warning in f(...): 'StatBump' needs at least two observations per group

## Warning in f(...): 'StatBump' needs at least two observations per group

## Warning in f(...): 'StatBump' needs at least two observations per group

## Warning in f(...): 'StatBump' needs at least two observations per group

## Warning in f(...): 'StatBump' needs at least two observations per group

## Warning in f(...): 'StatBump' needs at least two observations per group

## Warning in f(...): 'StatBump' needs at least two observations per group

## Warning in f(...): 'StatBump' needs at least two observations per group

## Warning in f(...): 'StatBump' needs at least two observations per group

## Warning in f(...): 'StatBump' needs at least two observations per group

## Warning in f(...): 'StatBump' needs at least two observations per group
```

\begin{figure}

{\centering \includegraphics[width=0.75\linewidth]{data-visualization_files/figure-latex/ggbump-1} 

}

\caption{凹凸图}(\#fig:ggbump)
\end{figure}

### 水流图 {#sec-ggplot2-streamgraph}

常用于时间序列数据展示的堆积区域图，[ggstream](https://github.com/davidsjoberg/ggstream) 和 [streamgraph](https://github.com/hrbrmstr/streamgraph)

<!-- 纵轴是怎么计算出来的？宽窄变化表达什么含义？ <https://hrbrmstr.github.io/streamgraph/> -->


```r
library(ggstream)

ggplot(blockbusters, aes(year, box_office, fill = genre)) +
  geom_stream() +
  theme_minimal()
```

\begin{figure}

{\centering \includegraphics[width=0.75\linewidth]{data-visualization_files/figure-latex/stream-graph-1} 

}

\caption{堆积区域图}(\#fig:stream-graph)
\end{figure}

### 时间线 {#sec-ggplot2-vistime}


```r
# 交互动态图 https://github.com/shosaco/vistime
# 刘思喆 2018 数据科学的时间轴 https://bjt.name/2018/11/18/timeline.html
x <- read.table(
  textConnection("
The Future of Data Analysis,1962
Relational Database,1970
Data science(Peter Naur),1974
Two-Way Communication,1975
Exploratory Data Analysis,1977
Business Intelligence,1989
The First Database Report,1992
The World Wide Web Explodes,1995
Data Mining and Knowledge Discovery,1997
S(ACM Software System Award),1998
Statistical Modeling: The Two Cultures,2001
Hadoop,2006
Data scientist,2008
NOSQL,2009
Deep Learning,2015
"),
  sep = ","
)
names(x) <- c("Event", "EventDate")
x$EventDate <- as.Date(paste(x$EventDate, "/01/01", sep = ""))

library(timelineS)
timelineS(x,
  labels = paste(x[[1]], format(x[[2]], "%Y")),
  line.color = "blue", label.angle = 15
)
```

\begin{figure}

{\centering \includegraphics{data-visualization_files/figure-latex/vis-timeline-1} 

}

\caption{数据科学的时间轴}(\#fig:vis-timeline)
\end{figure}


```r
library(timeline)
data(ww2, package = 'timeline')
timeline(ww2, ww2.events, event.spots=2, event.label='', event.above=FALSE)
```


```r
# 适合放在动态幻灯片
# 美团风格的写轮眼
# 时间线
library(vistime)
# presidents and vice presidents
pres <- data.frame(
  Position = rep(c("President", "Vice"), each = 3),
  Name = c("Washington", rep(c("Adams", "Jefferson"), 2), "Burr"),
  start = c("1789-03-29", "1797-02-03", "1801-02-03"),
  end = c("1797-02-03", "1801-02-03", "1809-02-03"),
  color = c("#cbb69d", "#603913", "#c69c6e")
)

hc_vistime(pres, col.event = "Position", col.group = "Name", 
           title = "Presidents of the USA")
```

### 三元图 {#sec-ggplot2-ternary}

[Ternary](https://github.com/ms609/Ternary/) 使用基础图形库，而 [ggtern](https://bitbucket.org/nicholasehamilton/ggtern) 使用 ggplot2 绘制


```r
library(ggtern)
library(ggalt)
data("Fragments")
ggtern(Fragments, aes(
  x = Qm, y = Qp, z = Rf + M,
  fill = GrainSize, shape = GrainSize
)) +
  geom_encircle(alpha = 0.5, size = 1) +
  geom_point() +
  labs(
    title = "Example Plot",
    subtitle = "using geom_encircle"
  ) +
  theme_bw() +
  theme_legend_position("tr")
```

### 四象限图 {#sec-ggplot2-eisenhower}


```r
dat <- data.frame(
  perc = c(54, 18, 5, 15),
  wall_policy = c("oppose", "favor", "oppose", "favor"),
  dreamer_policy = c("favor", "favor", "oppose", "oppose"),
  stringsAsFactors = FALSE
) %>%
  transform(
    xmin = ifelse(wall_policy == "oppose", -sqrt(perc), 0),
    xmax = ifelse(wall_policy == "favor", sqrt(perc), 0),
    ymin = ifelse(dreamer_policy == "oppose", -sqrt(perc), 0),
    ymax = ifelse(dreamer_policy == "favor", sqrt(perc), 0)
  )

ggplot(data = dat) +
  geom_rect(aes(
    xmin = xmin, xmax = xmax,
    ymin = ymin, ymax = ymax
  ), fill = "grey") +
  geom_text(aes(
    x = xmin + 0.5 * sqrt(perc),
    y = ymin + 0.5 * sqrt(perc),
    label = perc
  ),
  color = "white", size = 10
  ) +
  coord_equal() +
  geom_hline(yintercept = 0) +
  geom_vline(xintercept = 0) +
  theme_minimal() +
  labs(x = "", y = "", title = "")
```

\begin{figure}

{\centering \includegraphics{data-visualization_files/figure-latex/eisenhower-1} 

}

\caption{四象限图}(\#fig:eisenhower)
\end{figure}

### 韦恩图 {#sec-ggplot2-venn}

[ggVennDiagram](https://github.com/gaospecial/ggVennDiagram)

### 龙卷风图 {#sec-ggplot2-tornado}


```r
dat <- data.frame(
  variable = c("A", "B", "A", "B"),
  Level = c("Top-2", "Top-2", "Bottom-2", "Bottom-2"),
  value = c(.8, .7, -.2, -.3)
)
ggplot(dat, aes(x = variable, y = value, fill = Level)) +
  geom_bar(position = "identity", stat = "identity") +
  scale_y_continuous(labels = abs) +
  coord_flip() +
  theme_minimal()
```

\begin{figure}

{\centering \includegraphics{data-visualization_files/figure-latex/tornado-ggplot2-1} 

}

\caption{龙卷风图展示变量重要性}(\#fig:tornado-ggplot2)
\end{figure}

[Tornado diagram](https://en.wikipedia.org/wiki/Tornado_diagram) 主要用于敏感性分析，比较不同变量的重要性程度。条形图 `geom_bar()` 图层的变体，模型权重可视化的手段，仅限于广义线性模型。

### 聚类图 {#sec-ggplot2-hclust}

ggdendro 的 `dendro_data()` 函数支持 `tree` 、`hclust` 、`dendrogram` 和 `rpart` 结果的整理，进而绘图


```r
library(ggdendro)
hc <- hclust(dist(USArrests), "ave")
hcdata <- dendro_data(hc, type = "rectangle")
ggplot() +
  geom_segment(data = segment(hcdata), 
               aes(x = x, y = y, xend = xend, yend = yend)
  ) +
  geom_text(data = label(hcdata), 
            aes(x = x, y = y, label = label, hjust = 0), 
            size = 3
  ) +
  coord_flip() +
  scale_y_reverse(expand = c(0.2, 0)) +
  theme_minimal()
```



\begin{center}\includegraphics{data-visualization_files/figure-latex/unnamed-chunk-70-1} \end{center}

### 主成分图 {#sec-ggplot2-prcomp}

借助 [**autoplotly**](https://github.com/terrytangyuan/autoplotly) 包 [@autoplotly] 可将函数 `stats::prcomp` 生成的结果转化为交互图形


```r
pca <- prcomp(iris[c(1, 2, 3, 4)])
plot(pca)
```



\begin{center}\includegraphics{data-visualization_files/figure-latex/pac-plot-1} \end{center}


```r
library(autoplotly)
autoplotly(pca,
  data = iris, colour = "Species",
  label = TRUE, label.size = 3, frame = TRUE
)
```

[**ggfortify**](https://github.com/sinhrks/ggfortify) [@Tang_2016_ggfortify] 包将主成分分析图转化为静态图形


```r
library(ggfortify)
autoplot(pca, data = iris, colour = 'Species')
```

\begin{figure}

{\centering \includegraphics{data-visualization_files/figure-latex/pca-ggplot2-1} 

}

\caption{主成分分析}(\#fig:pca-ggplot2)
\end{figure}

### 组合图 {#sec-ggplot2-composite}

<!-- 也许可以加一个复杂的例子 [Tidy Tuesday Vacination](http://paulnice.datasorcery.tech/posts/tidy-tuesday-vacination/) 
[ggprism](https://github.com/csdaw/ggprism) 提供 [GraphPad](https://www.graphpad.com/) 风格的主题
-->

组合的意思是将不同种类的图形绘制在一个区域中，比如密度曲线和地毯图[^rug-plot]组合。
[**GGally**](https://github.com/ggobi/ggally)、 [**ggupset**](https://github.com/const-ae/ggupset)、 [ggcharts](https://github.com/thomas-neitmann/ggcharts) 和 [**ggpubr**](https://github.com/kassambara/ggpubr) 高度定制了一些组合统计图形，以 ggpubr 为例，见图 \@ref(fig:ggpubr-composite)。


```r
library(ggpubr)
ggdensity(sleep,
  x = "extra", add = "mean", rug = TRUE, color = "group",
  fill = "group", palette = c("#00AFBB", "#E7B800")
)
```

\begin{figure}

{\centering \includegraphics{data-visualization_files/figure-latex/ggpubr-composite-1} 

}

\caption{组合图形}(\#fig:ggpubr-composite)
\end{figure}

上面介绍的都是已经固化的组合方式，一般地，将多个图形组合到一个图中，可以有很多办法，比如 Claus Wilke 开发的 [**cowplot**](https://github.com/wilkelab/cowplot) ，在他的书里 [Fundamentals of Data Visualization](http://serialmentor.com/dataviz) 大量使用，后起之秀 [**patchwork**](https://github.com/thomasp85/patchwork) 则提供更加简洁的组合语法，非常受欢迎，更加底层的拼接方法可以去看 [一页多图](https://msg-book.netlify.app/tricks.html#sec-multipage) 和 R 内置的 grid 系统。

[^rug-plot]: 其实是轴须图 rug plot，只因样子看起来像铺在地上的毛毯，故而称之为地毯图，对应于 R 内置的 `rug()` 函数或 ggplot2 提供的图层 `geom_rug()`，更多解释详见 <https://en.wikipedia.org/wiki/Rug_plot>。

### 动态图 {#sec-ggplot2-animation}

[**av**](https://github.com/ropensci/av) 包基于 [FFmpeg](https://github.com/FFmpeg/FFmpeg) 将静态图片合成视频，而 [**gifski**](https://github.com/r-rust/gifski/) 包基于 [gifski](https://gif.ski/) 将静态图片合成 GIF 动画，[**animation**](https://github.com/yihui/animation) 包 [@Xie_2013_animation] 将 Base R 绘制的图形转化为动画或视频，[mapmate](https://github.com/leonawicz/mapmate) 制作地图相关的三维可视化图形，[**gganimate**](https://github.com/thomasp85/gganimate) 包支持将 ggplot2 生成的图形，**magick** 可以将一系列静态图形合成动态图形，借助 **gifski** 包转化为动态图片或视频。推荐读者从 [gganimate 案例合集](https://github.com/ropenscilabs/learngganimate) 开始制作动态图形。 [**rgl**](https://r-forge.r-project.org/projects/rgl/) 可以制作真三维动态图形，支持缩放、拖拽、旋转等操作， [**rayshader**](https://github.com/tylermorganwall/rayshader) 还支持转化 ggplot2 对象为 3D 图形。

数据集 Indometh 记录了药物在人体中的代谢情况，给 6 个人分别静脉注射了吲哚美辛，每隔一段时间抽血检查药物在血浆中的浓度，收集的数据见表 \@ref(tab:indometh-data)


```r
reshape(Indometh, v.names = "conc", idvar = "Subject", 
        timevar = "time", direction = "wide", sep = "") %>%
  knitr::kable(.,
    caption = "吲哚美辛在人体中的代谢情况",
    row.names = FALSE, col.names = gsub("(conc)", "", names(.)),
    align = "c"
  )
```

\begin{table}

\caption{(\#tab:indometh-data)吲哚美辛在人体中的代谢情况}
\centering
\begin{tabular}[t]{c|c|c|c|c|c|c|c|c|c|c|c}
\hline
Subject & 0.25 & 0.5 & 0.75 & 1 & 1.25 & 2 & 3 & 4 & 5 & 6 & 8\\
\hline
1 & 1.50 & 0.94 & 0.78 & 0.48 & 0.37 & 0.19 & 0.12 & 0.11 & 0.08 & 0.07 & 0.05\\
\hline
2 & 2.03 & 1.63 & 0.71 & 0.70 & 0.64 & 0.36 & 0.32 & 0.20 & 0.25 & 0.12 & 0.08\\
\hline
3 & 2.72 & 1.49 & 1.16 & 0.80 & 0.80 & 0.39 & 0.22 & 0.12 & 0.11 & 0.08 & 0.08\\
\hline
4 & 1.85 & 1.39 & 1.02 & 0.89 & 0.59 & 0.40 & 0.16 & 0.11 & 0.10 & 0.07 & 0.07\\
\hline
5 & 2.05 & 1.04 & 0.81 & 0.39 & 0.30 & 0.23 & 0.13 & 0.11 & 0.08 & 0.10 & 0.06\\
\hline
6 & 2.31 & 1.44 & 1.03 & 0.84 & 0.64 & 0.42 & 0.24 & 0.17 & 0.13 & 0.10 & 0.09\\
\hline
\end{tabular}
\end{table}

如图 \@ref(fig:indometh-concentration) 所示，药物在人体中浓度变化情况


```r
p <- ggplot(
  data = Indometh,
  aes(x = time, y = conc, color = Subject)
) +
  geom_point() +
  geom_line() +
  theme_minimal() +
  labs(
    x = "time (hr)",
    y = "plasma concentrations of indometacin (mcg/ml)"
  )
p
```

\begin{figure}

{\centering \includegraphics{data-visualization_files/figure-latex/indometh-concentration-1} 

}

\caption{药物在人体中的代谢情况}(\#fig:indometh-concentration)
\end{figure}


```r
library(gganimate)
p + transition_reveal(time)
```



\begin{center}\animategraphics[,controls,loop]{10}{data-visualization_files/figure-latex/indometh-animate-}{1}{100}\end{center}



::: {.rmdtip data-latex="{提示}"}
书籍目标输出格式是 PDF，则在代码块选项设置里必须指定参数 `fig.show='animate'` 否则插入的只是图片而不是动画，
目标格式是 HTML 网页， 就不必指定参数，默认会将图片合成 GIF 动态图，嵌入 PDF 里面的动画需要 Acrobat Reader 阅读器才能正确地显示。
:::

动态图形制作的原理，简单来说，就是将一帧帧静态图形以较快的速度播放，人眼形成视觉残留，以为是连续的画面，相比于 animation， **gganimate** 借助 **tweenr** 包添加了过渡效果，动态图形显得非常自然。下面以 cup 函数[^breast-cup]为例

[^breast-cup]: 函数来自余光创的博客 --- [3D 版邪恶的曲线](https://guangchuangyu.github.io/cn/2017/09/3d-breast/) ，此处借用 gganimate 将其动态化，前方高能，少儿不宜，R 还能这么不正经的玩。

$$f(x;\theta,\phi) = \theta x\log(x)-\frac{1}{\phi}\mathit{e}^{-\phi^4(x-\frac{1}{\mathit{e}})^4}, \quad \theta \in (2,3), \phi \in (30,50), x \in (0,1)$$ 函数图像随着 $\theta$ 和 $\phi$ 的变化情况见图 \@ref(fig:cup-curve)。


```r
library(tweenr)
cup_curve <- function(n = 100, theta = 3, phi = 30, cup = "A") {
  data.frame(x = seq(0.00001, 1, length.out = n), cup = cup) %>%
    transform(y = theta * x * log(x, base = 10) 
              - 1 / phi * exp(-(phi * x - phi / exp(1))^4))
}
mapply(
  FUN = cup_curve, theta = c(E = 3, D = 2.8, C = 2.5, B = 2.2, A = 2),
  phi = c(30, 33, 36, 40, 50), cup = c("E", "D", "C", "B", "A"),
  MoreArgs = list(n = 50), SIMPLIFY = FALSE, USE.NAMES = TRUE
) %>%
  tween_states(
    data = .,
    tweenlength = 2, statelength = 1,
    ease = rep("cubic-in-out", 4), nframes = 100
  ) %>%
  ggplot(data = ., aes(x, y, color = cup, frame = .frame)) +
  geom_path() +
  coord_flip() +
  theme_void()
```

\begin{figure}

{\centering \includegraphics{data-visualization_files/figure-latex/cup-curve-1} 

}

\caption{添加过渡效果}(\#fig:cup-curve)
\end{figure}
