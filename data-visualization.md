# 数据可视化 {#chap-data-visualization}


```r
library(ggplot2)
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
2. Kieran Healy 的新书 [Data Visualization: A Practical Introduction](https://kieranhealy.org/publications/dataviz/)
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

{\centering \includegraphics{data-visualization_files/figure-latex/approval-ratings-1} 

}

\caption{美国总统支持率：自1945年第一季度至1974年第四季度}(\#fig:approval-ratings)
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

{\centering \includegraphics{data-visualization_files/figure-latex/text-annotation-1} 

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

{\centering \includegraphics{data-visualization_files/figure-latex/mtcars-annotation-1} 

}

\caption{少量点的情况下可以全部注释，且可以解决注释重叠的问题}(\#fig:mtcars-annotation)
\end{figure}

Claus Wilke 开发的 [ggtext](https://github.com/wilkelab/ggtext) 包支持更加丰富的注释样式，详见网站 <https://wilkelab.org/ggtext/>

### 主题 {#subsec-theme}

[ggcharts](https://github.com/thomas-neitmann/ggcharts) 和 [bbplot](https://github.com/bbc/bbplot)
[prettyB](https://github.com/jumpingrivers/prettyB) 美化 Base R 图形
[ggprism](https://github.com/csdaw/ggprism)


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
在本书中，不要全局加载 showtext 包或调用 `showtext::showtext_auto()`，会和 extrafont 冲突，使得绘图时默认就只能使用 showtext 提供的字体。
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

{\centering \includegraphics[width=0.75\linewidth]{data-visualization_files/figure-latex/font-in-ggplot-1} 

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
##  [1] "Roboto Condensed"       "xkcd"                   "CM Roman"              
##  [4] "CM Roman Asian"         "CM Roman CE"            "CM Roman Cyrillic"     
##  [7] "CM Roman Greek"         "CM Sans"                "CM Sans Asian"         
## [10] "CM Sans CE"             "CM Sans Cyrillic"       "CM Sans Greek"         
## [13] "CM Symbol"              "CM Typewriter"          "CM Typewriter Asian"   
## [16] "CM Typewriter CE"       "CM Typewriter Cyrillic" "CM Typewriter Greek"
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
  parse = TRUE, label = eq
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
all.equal(col2rgb(paste0("gray", seq(100))), col2rgb(paste0("grey", seq(100))))
```

```
## [1] TRUE
```

`gray100` 代表白色，`gray0` 代表黑色，提取灰色调色板，去掉首尾部分是必要的


```r
barplot(1:8, col = gray.colors(8, start = .3, end = .9), 
        main = "gray.colors function", border = NA)
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
[paletteer](https://github.com/EmilHvitfeldt/paletteer) 包收集了很多 R 包提供的调色板，同时也引入了很多依赖。
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

再举栗子，图 \@ref(fig:faithfuld) 是正负例对比，其中好在哪里呢？这张图要表达美国黄石国家公园的老忠实泉间歇喷发的时间规律，那么好的标准就是层次分明，以突出不同颜色之间的时间差异。这个差异，还要看起来不那么费眼睛，一目了然最好。


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


### 颜色模式 {#subsec-color-schames}

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

### 条形图 {#sec-ggplot2-barplot}


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

plotly::plot_ly(dat,
  y = ~cut, color = ~clarity, x = ~cnt,
  colors = "Spectral", type = "bar",
  text = ~ paste0(
    cnt, "颗 <br>",
    "占比：", scales::percent(pct, accuracy = 0.1), "<br>"
  ), 
  hoverinfo = "text"
) %>%
  plotly::layout(barmode = "stack", barnorm = "percent") %>%
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

# 百分比堆积图
plotly::plot_ly(diamonds,
  x = ~cut, color = ~clarity,
  colors = "Spectral", type = "histogram"
) %>%
  plotly::layout(
    barmode = "stack", barnorm = "percent",
    yaxis = list(title = "percent"),
    legend = list(title = list(text = "clarity"))
  ) %>%
  plotly::config(displayModeBar = FALSE)
```


### 函数图 {#sec-ggplot2-function}

蝴蝶图的参数方程如下

\begin{align}
x &= \sin t \big(\mathrm e^{\cos t} - 2 \cos 4t + \sin^5(\frac{t}{12})\big) \\
y &= \cos t \big(\mathrm e^{\cos t} - 2 \cos 4t + \sin^5(\frac{t}{12})\big), t \in [- \pi, \pi]
\end{align}

### 密度图 {#sec-ggplot2-density}

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
## [1] "Sat"
```

```r
data.table::wday(Sys.Date())
```

```
## [1] 7
```

:::




```r
library(gert)
library(ggplot2)

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



\begin{center}\includegraphics{data-visualization_files/figure-latex/unnamed-chunk-15-1} \end{center}



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
## <bytecode: 0x5620a431f1e8>
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

\begin{figure}

{\centering \includegraphics{data-visualization_files/figure-latex/ggbump-1} 

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

{\centering \includegraphics{data-visualization_files/figure-latex/stream-graph-1} 

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



\begin{center}\includegraphics{data-visualization_files/figure-latex/unnamed-chunk-24-1} \end{center}

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
