# 图形基础 {#chap-graphics-foundations}


```r
library(survival)
library(lattice)
library(nlme)
library(MASS)
library(RColorBrewer)
library(latticeExtra)
library(shape)
library(splines)
library(mgcv)
library(maps)
library(mapproj)
```

<!--
作为知识介绍，本章所有数据都来源于基础 R 包，即安装 R 软件后自带的数据集，图库在以 base R 中的数据集介绍完后，以相应真实数据扩展为案列，结合统计意义和探索性数据分析介绍各种常见统计图形
-->

数据可视化是一种重要的数据分析手段， R 提供了两套图形系统，分别是 graphics 包提供的基础绘图系统和 grid 包提供的栅格绘图系统，后者主要以两个 R 包为大家所熟知，一个是 lattice 包，另一个是 ggplot2 包。

Base 图形系统的扩展包 [basetheme](https://github.com/KKPMW/basetheme) 可以设置主题，[prettyB](https://github.com/jumpingrivers/prettyB) 和 [gridGraphics](https://github.com/pmur002/gridgraphics)

为了方便记忆函数 `par` 的各个参数，Paul Murrell 整理了一份 [助记符](https://www.stat.auckland.ac.nz/~paul/R/parMemnonics.html)，此外，LaTeX 宏包 [geometry](https://github.com/latexstudio/LaTeXPackages-CN) 对版面设置有很多专业的说明

## 绘图基本要素 {#graphics-elements} 

### 点线 {#base-points}

点和线是最常见的画图元素，在 `plot` 函数中，分别用参数 `pch` 和 `lty` 来设定类型，点的大小、线的宽度分别用参数 `cex` 和 `lwd` 来指定，颜色由参数 `col` 设置。参数 `type` 不同的值设置如下，`p` 显示点，`l` 绘制线，`b` 同时绘制空心点，并用线连接，`c` 只有线，`o` 在线上绘制点，`s` 和 `S` 点线连接绘制阶梯图，`h` 绘制类似直方图一样的垂线，最后 `n` 表示什么也不画。

点 points 、线 grid 背景线 abline lines rug 刻度线（线段segments、箭头arrows）、


```r
## -------- Showing all the extra & some char graphics symbols ---------
pchShow <-
  function(extras = c("*", ".", "o", "O", "0", "+", "-", "|", "%", "#"),
             cex = 2, ## good for both .Device=="postscript" and "x11"
             col = "red3", bg = "gold", coltext = "brown", cextext = 1.2,
             main = paste(
               "plot symbols :  points (...  pch = *, cex =",
               cex, ")"
             )) {
    nex <- length(extras)
    np <- 26 + nex
    ipch <- 0:(np - 1)
    k <- floor(sqrt(np))
    dd <- c(-1, 1) / 2
    rx <- dd + range(ix <- ipch %/% k)
    ry <- dd + range(iy <- 3 + (k - 1) - ipch %% k)
    pch <- as.list(ipch) # list with integers & strings
    if (nex > 0) pch[26 + 1:nex] <- as.list(extras)
    plot(rx, ry, type = "n", axes = FALSE, xlab = "", ylab = "", main = main)
    abline(v = ix, h = iy, col = "lightgray", lty = "dotted")
    for (i in 1:np) {
      pc <- pch[[i]]
      ## 'col' symbols with a 'bg'-colored interior (where available) :
      points(ix[i], iy[i], pch = pc, col = col, bg = bg, cex = cex)
      if (cextext > 0) {
        text(ix[i] - 0.3, iy[i], pc, col = coltext, cex = cextext)
      }
    }
  }

pchShow()
```

\begin{figure}

{\centering \includegraphics[width=0.75\linewidth]{graphics-foundations_files/figure-latex/unnamed-chunk-2-1} 

}

\caption{不同的 pch 参数值}(\#fig:unnamed-chunk-2)
\end{figure}



```r
## ------------ test code for various pch specifications -------------
# Try this in various font families (including Hershey)
# and locales.  Use sign = -1 asserts we want Latin-1.
# Standard cases in a MBCS locale will not plot the top half.
TestChars <- function(sign = 1, font = 1, ...) {
  MB <- l10n_info()$MBCS
  r <- if (font == 5) {
    sign <- 1
    c(32:126, 160:254)
  } else if (MB) 32:126 else 32:255
  if (sign == -1) r <- c(32:126, 160:255)
  par(pty = "s")
  plot(c(-1, 16), c(-1, 16),
    type = "n", xlab = "", ylab = "",
    xaxs = "i", yaxs = "i",
    main = sprintf("sign = %d, font = %d", sign, font)
  )
  grid(17, 17, lty = 1)
  mtext(paste("MBCS:", MB))
  for (i in r) try(points(i %% 16, i %/% 16, pch = sign * i, font = font, ...))
}
TestChars()
```

\begin{figure}

{\centering \includegraphics[width=0.45\linewidth]{graphics-foundations_files/figure-latex/unnamed-chunk-3-1} 

}

\caption{pch 支持的字符}(\#fig:unnamed-chunk-3-1)
\end{figure}

```r
try(TestChars(sign = -1))
```

\begin{figure}

{\centering \includegraphics[width=0.45\linewidth]{graphics-foundations_files/figure-latex/unnamed-chunk-3-2} 

}

\caption{pch 支持的字符}(\#fig:unnamed-chunk-3-2)
\end{figure}

```r
TestChars(font = 5) # Euro might be at 160 (0+10*16).
```

\begin{figure}

{\centering \includegraphics[width=0.45\linewidth]{graphics-foundations_files/figure-latex/unnamed-chunk-3-3} 

}

\caption{pch 支持的字符}(\#fig:unnamed-chunk-3-3)
\end{figure}

```r
# macOS has apple at 240 (0+15*16).
try(TestChars(-1, font = 2)) # bold
```

\begin{figure}

{\centering \includegraphics[width=0.45\linewidth]{graphics-foundations_files/figure-latex/unnamed-chunk-3-4} 

}

\caption{pch 支持的字符}(\#fig:unnamed-chunk-3-4)
\end{figure}


```r
x <- 0:12
y <- sin(pi / 5 * x)
par(mfrow = c(3, 3), mar = .1 + c(2, 2, 3, 1))
for (tp in c("p", "l", "b", "c", "o", "h", "s", "S", "n")) {
  plot(y ~ x, type = tp, main = paste0("plot(*, type = \"", tp, "\")"))
  if (tp == "S") {
    lines(x, y, type = "s", col = "red", lty = 2)
    mtext("lines(*, type = \"s\", ...)", col = "red", cex = 0.8)
  }
}
```

\begin{figure}

{\centering \includegraphics{graphics-foundations_files/figure-latex/unnamed-chunk-4-1} 

}

\caption{不同的 type 参数值}(\#fig:unnamed-chunk-4)
\end{figure}

颜色 col 连续型和离散型

线帽/端和字体的样式 


```r
# 合并为一个图 三条粗横线 横线上三种字形
plot(c(1, 20), c(1, 20), type = "n", ann = FALSE)
lines(x = c(5, 15), y = c(5, 5), lwd = 15, lend = "round")
text(10, 5, "Hello, Helvetica", cex = 1.5, family = "sans", pos = 1, offset = 1.5)
text(5, 5, "sans", cex = 1.5, family = "sans", pos = 2, offset = .5)
text(15, 5, "lend = round", pos = 4, offset = .5)

lines(x = c(5, 15), y = c(10, 10), lwd = 15, lend = "butt")
text(10, 10, "Hello, Helvetica", cex = 1.5, family = "mono", pos = 1, offset = 1.5)
text(5, 10, "mono", cex = 1.5, family = "mono", pos = 2, offset = .5)
text(15, 10, "lend = butt", pos = 4, offset = .5)

lines(x = c(5, 15), y = c(15, 15), lwd = 15, lend = "square")
text(10, 15, "Hello, Helvetica", cex = 1.5, family = "serif", pos = 1, offset = 1.5)
text(5, 15, "serif", cex = 1.5, family = "serif", pos = 2, offset = .5)
text(15, 15, "lend = square", pos = 4, offset = .5)
```

\begin{figure}

{\centering \includegraphics[width=0.55\linewidth]{graphics-foundations_files/figure-latex/unnamed-chunk-5-1} 

}

\caption{不同的线端样式}(\#fig:unnamed-chunk-5)
\end{figure}


lend：线端的样式，可用一个整数或字符串指定：

- 0 或 "round" 圆形（默认）
- 1 或 "butt" 对接形
- 2 或 "square" 方形


### 区域 {#base-rect}

矩形，多边形，曲线交汇出来的区域
面（矩形rect，多边形polygon）、路径 polypath
面/多边形 rect 颜色填充


```r
# From the manual
ch.col <- c(
  "rainbow(n, start=.7, end=.1)",
  "heat.colors(n)",
  "terrain.colors(n)",
  "topo.colors(n)",
  "cm.colors(n)"
) # 选择颜色
n <- 16
nt <- length(ch.col)
i <- 1:n
j <- n / nt
d <- j / 6
dy <- 2 * d
plot(i, i + d,
  type = "n",
  yaxt = "n",
  ylab = "",
  xlab = "",
  main = paste("color palettes; n=", n)
)
for (k in 1:nt) {
  rect(i - .5, (k - 1) * j + dy, i + .4, k * j,
    col = eval(parse(text = ch.col[k]))
  ) # 咬人的函数/字符串解析为/转函数
  text(2 * j, k * j + dy / 4, ch.col[k])
}
```

\begin{figure}

{\centering \includegraphics{graphics-foundations_files/figure-latex/unnamed-chunk-6-1} 

}

\caption{rect 函数画长方形}(\#fig:unnamed-chunk-6)
\end{figure}

`clip(x1, x2, y1, y2)` 在用户坐标中设置剪切区域


```r
x <- rnorm(1000)
hist(x, xlim = c(-4, 4))
usr <- par("usr")
clip(usr[1], -2, usr[3], usr[4])
hist(x, col = "red", add = TRUE)
clip(2, usr[2], usr[3], usr[4])
hist(x, col = "blue", add = TRUE)
```



\begin{center}\includegraphics{graphics-foundations_files/figure-latex/unnamed-chunk-7-1} \end{center}

```r
do.call("clip", as.list(usr)) # reset to plot region
```



```r
my.col <- function(f, g, xmin, xmax, col, N = 200,
                   xlab = "", ylab = "", main = "") {
  x <- seq(xmin, xmax, length = N)
  fx <- f(x)
  gx <- g(x)
  plot(0, 0,
    type = "n",
    xlim = c(xmin, xmax),
    ylim = c(min(fx, gx), max(fx, gx)),
    xlab = xlab, ylab = ylab, main = main
  )
  polygon(c(x, rev(x)), c(fx, rev(gx)),
    col = "#EA4335", border = 0
  )
  lines(x, fx, lwd = 3, col = "#34A853")
  lines(x, gx, lwd = 3, col = "#4285f4")
}
my.col(function(x) x^2, function(x) x^2 + 10 * sin(x),
  -6, 6,
  main = "The \"polygon\" function"
)
```

\begin{figure}

{\centering \includegraphics[width=0.55\linewidth]{graphics-foundations_files/figure-latex/unnamed-chunk-8-1} 

}

\caption{区域重叠 polygon 函数}(\#fig:unnamed-chunk-8)
\end{figure}


各种符号 \@ref(fig:cex-symbol) 


```r
plot(0, 0,
  xlim = c(1, 5), ylim = c(-.5, 4),
  axes = F,
  xlab = "", ylab = ""
)
for (i in 0:4) {
  for (j in 1:5) {
    n <- 5 * i + j
    points(j, i,
      pch = n,
      cex = 3
    )
    text(j, i - .3, as.character(n))
  }
}
```

\begin{figure}

{\centering \includegraphics[width=0.55\linewidth]{graphics-foundations_files/figure-latex/cex-symbol-1} 

}

\caption{cex 支持的符号}(\#fig:cex-symbol)
\end{figure}

点、线、多边形和圆聚集在图 \@ref(fig:symbols) 中


```r
# https://jeroen.github.io/uros2018/#23
plot.new()
plot.window(xlim = c(0, 100), ylim = c(0, 100))
polygon(c(10, 40, 80), c(10, 80, 40), col = "hotpink")
text(40, 90, labels = "My drawing", col = "navyblue", cex = 3)
symbols(c(70, 80, 90), c(20, 50, 80),
  circles = c(10, 20, 10),
  bg = c("#4285f4", "#EA4335", "red"), add = TRUE, lty = "dashed"
)
```

\begin{figure}

{\centering \includegraphics{graphics-foundations_files/figure-latex/symbols-1} 

}

\caption{多边形和符号元素}(\#fig:symbols)
\end{figure}

在介绍各种统计图形之前，先介绍几个绘图函数 `plot` 和 `text` 还有 `par` 参数设置， 作为最简单的开始，尽量依次介绍其中的每个参数的含义并附上图形对比。


```r
y <- x <- 1:4
plot(x, y, ann = F, col = "blue", pch = 16)
text(x, y,
  labels = c("1st", "2nd", "3rd", "4th"),
  col = "red", pos = c(3, 4, 4, 1), offset = 0.6
)
ahat <- "sigma"
# title(substitute(hat(a) == ahat, list(ahat = ahat)))
title(bquote(hat(a) == .(ahat)))
```

\begin{figure}

{\centering \includegraphics[width=0.55\linewidth]{graphics-foundations_files/figure-latex/pos-1} 

}

\caption{pos 位置参数}(\#fig:pos)
\end{figure}

其中 labels， pos 都是向量化的参数

### 参考线 {#base-lines}

矩形网格线是用做背景参考线的，常常是淡灰色的细密虚线，`plot` 函数的 `panel.first` 参数和 `grid` 函数常用来画这种参考线


```r
# modified from https://yihui.name/cn/2018/02/cohen-s-d/
n <- 30 # 样本量（只是一个例子）
x <- seq(0, 12, 0.01)
par(mar = c(4, 4, 0.2, 0.1))
plot(x / sqrt(n), 2 * (1 - pt(x, n - 1)),
  xlab = expression(d = x / sqrt(n)),
  type = "l", panel.first = grid()
)
abline(v = c(0.01, 0.2, 0.5, 0.8, 1.2, 2), lty = 2)
```

\begin{figure}

{\centering \includegraphics{graphics-foundations_files/figure-latex/bg-grid-lines-1} 

}

\caption{添加背景参考线}(\#fig:bg-grid-lines)
\end{figure}



### 坐标轴 {#base-axis}

图形控制参数默认设置下 `par` 通常的一幅图形，改变坐标轴标签是很简单的


```r
x <- 1:100
y <- runif(100, -2, 2)
plot(x, y)
```



\begin{center}\includegraphics{graphics-foundations_files/figure-latex/unnamed-chunk-9-1} \end{center}

```r
plot(x, y, xlab = "Index", ylab = "Uniform draws")
```



\begin{center}\includegraphics{graphics-foundations_files/figure-latex/unnamed-chunk-9-2} \end{center}

改变坐标轴标签和标题


```r
op <- par(no.readonly = TRUE) # 保存默认的 par 设置
par(cex.lab = 1.5, cex.axis = 1.3)
plot(x, y, xlab = "Index", ylab = "Uniform draws")

# 设置更大的坐标轴标签内容
par(mar = c(6, 6, 3, 3), cex.axis = 1.5, cex.lab = 2)
plot(x, y, xlab = "Index", ylab = "Uniform draws")
```



\begin{center}\includegraphics{graphics-foundations_files/figure-latex/unnamed-chunk-10-1} \end{center}

使用 axis 函数可以更加精细地控制坐标轴


```r
par(op) # 恢复默认的 par 设置
plot(x, y, xaxt = "n") # 去掉 x 轴
axis(side = 1, at = c(5, 50, 100)) # 添加指定的刻度标签
```



\begin{center}\includegraphics{graphics-foundations_files/figure-latex/unnamed-chunk-11-1} \end{center}

指定刻度标签的内容


```r
plot(x, y, yaxt = "n")
axis(side = 2, at = c(-2, 0, 2), labels = c("Small", "Medium", "Big"))
```



\begin{center}\includegraphics{graphics-foundations_files/figure-latex/unnamed-chunk-12-1} \end{center}

控制刻度线和轴线和刻度标签


```r
plot(x, y)
axis(side = 3, at = c(5, 25, 75), lwd = 4, lwd.ticks = 2, col.ticks = "red")
```



\begin{center}\includegraphics{graphics-foundations_files/figure-latex/unnamed-chunk-13-1} \end{center}

还可以把 box 移除，绘图区域的边框去掉，只保留坐标轴


```r
plot(x, y, bty = "n", xaxt = "n", yaxt = "n")
axis(side = 1, at = seq(0, 100, 20), lwd = 3)
axis(side = 2, at = seq(-2, 2, 2), lwd = 3)
```



\begin{center}\includegraphics{graphics-foundations_files/figure-latex/unnamed-chunk-14-1} \end{center}




```r
# 双Y轴
N <- 200
x <- seq(-4, 4, length = N)
y1 <- sin(x)
y2 <- cos(x)
op <- par(mar = c(5, 4, 4, 4)) # Add some space in the right margin
# The default is c(5,4,4,2) + .1
xlim <- range(x)
ylim <- c(-1.1, 1.1)
plot(x, y1,
  col = "blue", type = "l",
  xlim = xlim, ylim = ylim,
  axes = F, xlab = "", ylab = "", main = "Title"
)
axis(1)
axis(2, col = "blue")
par(new = TRUE)
plot(x, y2,
  col = "red", type = "l",
  xlim = xlim, ylim = ylim,
  axes = F, xlab = "", ylab = "", main = ""
)
axis(4, col = "red")
mtext("First Y axis", 2, line = 2, col = "blue", cex = 1.2)
mtext("Second Y axis", 4, line = 2, col = "red", cex = 1.2)
```

\begin{figure}

{\centering \includegraphics[width=0.65\linewidth]{graphics-foundations_files/figure-latex/unnamed-chunk-15-1} 

}

\caption{两个 Y 轴}(\#fig:unnamed-chunk-15)
\end{figure}

```r
# 1,2,3,4 分别代表下左上右四个位置
```

调整坐标轴标签的距离


```r
## Changing default gap between labels:
plot(c(0, 100), c(0, 50), type = "n", axes = FALSE, ann = FALSE)
title(quote("axis(1, .., gap.axis = f)," ~ ~ f >= 0))
axis(2, at = 5 * (0:10), las = 1, gap.axis = 1 / 4)
gaps <- c(4, 2, 1, 1 / 2, 1 / 4, 0.1, 0)
chG <- paste0(
  ifelse(gaps == 1, "default:  ", ""),
  "gap.axis=", formatC(gaps)
)
jj <- seq_along(gaps)
linG <- -2.5 * (jj - 1)
for (j in jj) {
  isD <- gaps[j] == 1 # is default
  axis(1,
    at = 5 * (0:20), gap.axis = gaps[j], padj = -1, line = linG[j],
    col.axis = if (isD) "forest green" else 1, font.axis = 1 + isD
  )
}
mtext(chG,
  side = 1, padj = -1, line = linG - 1 / 2, cex = 3 / 4,
  col = ifelse(gaps == 1, "forest green", "blue3")
)
```

\begin{figure}

{\centering \includegraphics[width=0.55\linewidth]{graphics-foundations_files/figure-latex/gap-axis-1} 

}

\caption{gap.axis用法}(\#fig:gap-axis)
\end{figure}

```r
## now shrink the window (in x- and y-direction) and observe the axis labels drawn
```

旋转坐标轴标签


```r
# Rotated axis labels in R plots
# https://menugget.blogspot.com/2014/08/rotated-axis-labels-in-r-plots.html
# Example data
tmin <- as.Date("2000-01-01")
tmax <- as.Date("2001-01-01")
tlab <- seq(tmin, tmax, by = "month")
lab <- format(tlab, format = "%Y-%b")
set.seed(111)
x <- seq(tmin, tmax, length.out = 100)
y <- cumsum(rnorm(100))

# Plot
# png("plot_w_rotated_axis_labels.png", height = 3,
#     width = 6, units = "in", res = 300)
op <- par(mar = c(6, 4, 1, 1))
plot(x, y, t = "l", xaxt = "n", xlab = "")
axis(1, at = tlab, labels = FALSE)
text(
  x = tlab, y = par()$usr[3] - 0.1 * (par()$usr[4] - par()$usr[3]),
  labels = lab, srt = 45, adj = 1, xpd = TRUE
)
```



\begin{center}\includegraphics{graphics-foundations_files/figure-latex/unnamed-chunk-16-1} \end{center}

```r
par(op)
# dev.off()
```

旋转坐标抽标签的例子来自手册《R FAQ》的第7章第27个问题 [@R-FAQ]，在基础图形中，旋转坐标轴标签需要 `text()` 而不是 `mtext()`，因为后者不支持`par("srt")` 


```r
## Increase bottom margin to make room for rotated labels
par(mar = c(5, 4, .5, 2) + 0.1)
## Create plot with no x axis and no x axis label
plot(1:8, xaxt = "n", xlab = "")
## Set up x axis with tick marks alone
axis(1, labels = FALSE)
## Create some text labels
labels <- paste("Label", 1:8, sep = " ")
## Plot x axis labels at default tick marks
text(1:8, par("usr")[3] - 0.5,
  srt = 45, adj = 1,
  labels = labels, xpd = TRUE
)
## Plot x axis label at line 6 (of 7)
mtext(side = 1, text = "X Axis Label", line = 4)
```

\begin{figure}

{\centering \includegraphics{graphics-foundations_files/figure-latex/rotate-axis-labels-1} 

}

\caption{旋转坐标轴标签}(\#fig:rotate-axis-labels)
\end{figure}

`srt = 45` 表示文本旋转角度， `xpd = TRUE` 允许文本越出绘图区域，`adj = 1` to place the right end of text at the tick marks；You can adjust the value of the 0.5 offset as required to move the axis labels up or down relative to the x axis. 详细地参考 [@Paul_2003_Integrating]

### 刻度线 {#base-tick}

通过 `par` 或 `axis` 函数实现刻度线的精细操作，tcl 控制刻度线的长度，正值让刻度画在绘图区域内，负值正好相反，画在外面，mgp 参数有三个值，第一个值控制绘图区域和坐标轴标题之间的行数，第二个是绘图区域与坐标轴标签的行数，第三个绘图区域与轴线的行数，行数表示间距


```r
par(tcl = 0.4, mgp = c(1.5, 0, 0))
plot(x, y)
```



\begin{center}\includegraphics{graphics-foundations_files/figure-latex/unnamed-chunk-17-1} \end{center}

```r
# 又一个例子
par(op)
plot(x, y, xaxt = "n", yaxt = "n", xlab = "", ylab = "")
axis(side = 1, at = seq(5, 95, 30), tcl = 0.4, lwd.ticks = 3, mgp = c(0, 0.5, 0))
mtext(side = 1, text = "X axis", line = 1.5) 
# mtext 设置坐标轴标签
axis(side = 2, at = seq(-2, 2, 2), tcl = 0.3, lwd.ticks = 3, col.ticks = "orange", mgp = c(0, 0, 2))
mtext(side = 2, text = "Numbers taken randomly", line = 2.2)
```



\begin{center}\includegraphics{graphics-foundations_files/figure-latex/unnamed-chunk-17-2} \end{center}


### 标题 {#base-title}

添加多个标题


```r
N <- 200
x <- runif(N, -4, 4)
y <- sin(x) + .5 * rnorm(N)
plot(x, y, xlab = "", ylab = "", main = "")
mtext("Subtitle", 3, line = .8)
mtext("Title", 3, line = 2, cex = 1.5)
mtext("X axis", 1, line = 2.5, cex = 1.5)
mtext("X axis subtitle", 1, line = 3.7)
```

\begin{figure}

{\centering \includegraphics{graphics-foundations_files/figure-latex/unnamed-chunk-18-1} 

}

\caption{图标题/子标题 x轴标题/子标题}(\#fig:unnamed-chunk-18)
\end{figure}

### 注释 {#base-annotation}

数学符号注释，图\@ref(fig:math-annotation) 自定义坐标轴 [@Paul_2000_Approach]。


```r
# 自定义坐标轴
plot(c(1, 1e6), c(-pi, pi),
  type = "n",
  axes = FALSE, ann = FALSE, log = "x"
)
axis(1,
  at = c(1, 1e2, 1e4, 1e6),
  labels = expression(1, 10^2, 10^4, 10^6)
)
axis(2,
  at = c(-pi, -pi / 2, 0, pi / 2, pi),
  labels = expression(-pi, -pi / 2, 0, pi / 2, pi)
)
text(1e3, 0, expression(italic("Customized Axes")))
box()
```

\begin{figure}

{\centering \includegraphics[width=0.45\linewidth]{graphics-foundations_files/figure-latex/math-annotation-1} 

}

\caption{创建自定义的坐标轴和刻度标签}(\#fig:math-annotation)
\end{figure}

在标题中添加数学公式


```r
x <- seq(-5, 5, length = 200)
y <- sqrt(1 + x^2)
plot(y ~ x,
  type = "l",
  ylab = expression(sqrt(1 + x^2))
)
title(main = expression(
  "graph of the function f"(x) == sqrt(1 + x^2)
))
```

\begin{figure}

{\centering \includegraphics[width=0.45\linewidth]{graphics-foundations_files/figure-latex/unnamed-chunk-19-1} 

}

\caption{标题含有数学公式}(\#fig:unnamed-chunk-19)
\end{figure}

修改参数使用 `substitute` 函数批量生成


```r
x <- seq(-5, 5, length = 200)
for (i in 1:4) { # 画四个图
  y <- sqrt(i + x^2)
  plot(y ~ x,
    type = "l",
    ylim = c(0, 6),
    ylab = substitute(
      expression(sqrt(i + x^2)),
      list(i = i)
    )
  )
  title(main = substitute(
    "graph of the function f"(x) == sqrt(i + x^2),
    list(i = i)
  ))
}
```

\begin{figure}

{\centering \includegraphics[width=0.45\linewidth]{graphics-foundations_files/figure-latex/unnamed-chunk-20-1} 

}

\caption{批量生成函数图形}(\#fig:unnamed-chunk-20-1)
\end{figure}
\begin{figure}

{\centering \includegraphics[width=0.45\linewidth]{graphics-foundations_files/figure-latex/unnamed-chunk-20-2} 

}

\caption{批量生成函数图形}(\#fig:unnamed-chunk-20-2)
\end{figure}
\begin{figure}

{\centering \includegraphics[width=0.45\linewidth]{graphics-foundations_files/figure-latex/unnamed-chunk-20-3} 

}

\caption{批量生成函数图形}(\#fig:unnamed-chunk-20-3)
\end{figure}
\begin{figure}

{\centering \includegraphics[width=0.45\linewidth]{graphics-foundations_files/figure-latex/unnamed-chunk-20-4} 

}

\caption{批量生成函数图形}(\#fig:unnamed-chunk-20-4)
\end{figure}

基础绘图函数，如 plot 标签 `xlab` 支持 Unicode 代码表示的希腊字母，常用字母表备查，公式环境下，也可以用在绘图中

Table: (\#tab:letters) 希腊字母表

 希腊字母      | LaTeX 代码     | Unicode 代码 |  希腊字母   |  LaTeX 代码   |  Unicode 代码
:------------- | :------------- | :----------- | :---------- | :------------ | :-------------
 $\alpha$      | `\alpha`       | `\u03B1`     |  $\mu$      | `\mu`         |   `\u03BC`
 $\beta$       | `\beta`        | `\u03B2`     |  $\nu$      | `\nu`         |   `\u03BD`
 $\gamma$      | `\gamma`       | `\u03B3`     |  $\xi$      | `\xi`         |   `\u03BE`
 $\delta$      | `\delta`       | `\u03B4`     |  $\varphi$  | `\varphi`     |   `\u03C6`
 $\epsilon$    | `\epsilon`     | `\u03B5`     |  $\pi$      | `\pi`         |   `\u03C0`
 $\zeta$       | `\zeta`        | `\u03B6`     |  $\rho$     | `\rho`        |   `\u03C1`
 $\eta$        | `\eta`         | `\u03B7`     |  $\upsilon$ | `\upsilon`    |   `\u03C5`
 $\theta$      | `\theta`       | `\u03B8`     |  $\phi$     | `\phi`        |   `\u03C6`
 $\iota$       | `\iota`        | `\u03B9`     |  $\chi$     | `\chi`        |   `\u03C7`
 $\kappa$      | `\kappa`       | `\u03BA`     |  $\psi$     | `\psi`        |   `\u03C8`
 $\lambda$     | `\lambda`      | `\u03BB`     |  $\omega$   | `\omega`      |   `\u03C9`
 $\sigma$      | `\sigma`       | `\u03C3`     |  $\tau$     | `\tau`        |   `\u03C4`  

Table: (\#tab:super-sub-script) 数字上下标

  上标数字 | LaTeX 代码| Unicode 代码 | 下标数字   | LaTeX 代码 |  Unicode 代码
:--------- |:--------- | :---------   | :--------- | :--------- | :---------
 ${}^0$    | `{}^0`    |   `\u2070`   |   ${}_0$   |   `{}_0`   |  `\u2080`
 ${}^1$    | `{}^1`    |   `\u00B9`   |   ${}_1$   |   `{}_1`   |  `\u2081`
 ${}^2$    | `{}^2`    |   `\u00B2`   |   ${}_2$   |   `{}_2`   |  `\u2082`
 ${}^3$    | `{}^3`    |   `\u00B2`   |   ${}_3$   |   `{}_3`   |  `\u2083`
 ${}^4$    | `{}^4`    |   `\u2074`   |   ${}_4$   |   `{}_4`   |  `\u2084`
 ${}^5$    | `{}^5`    |   `\u2075`   |   ${}_5$   |   `{}_5`   |  `\u2085`
 ${}^6$    | `{}^6`    |   `\u2076`   |   ${}_6$   |   `{}_6`   |  `\u2086`
 ${}^7$    | `{}^7`    |   `\u2077`   |   ${}_7$   |   `{}_7`   |  `\u2087`
 ${}^8$    | `{}^8`    |   `\u2078`   |   ${}_8$   |   `{}_8`   |  `\u2088`
 ${}^9$    | `{}^9`    |   `\u2079`   |   ${}_9$   |   `{}_9`   |  `\u2089`
 ${}^n$    | `{}^n`    |   `\u207F`   |   ${}_n$   |   `{}_n`   |  -

其它字母，请查看 [Unicode 字母表][unicode-tab]

[unicode-tab]: https://www.ssec.wisc.edu/~tomw/java/unicode.html


### 图例 {#base-legend}


```r
x <- seq(-6, 6, length = 200)
y <- sin(x)
z <- cos(x)
plot(y ~ x,
  type = "l", lwd = 3,
  ylab = "", xlab = "angle", main = "Trigonometric functions"
)
abline(h = 0, lty = 3)
abline(v = 0, lty = 3)
lines(z ~ x, type = "l", lwd = 3, col = "red")
legend(-6, -1,
  yjust = 0,
  c("Sine", "Cosine"),
  lwd = 3, lty = 1, col = c(par("fg"), "red")
)
```

\begin{figure}

{\centering \includegraphics{graphics-foundations_files/figure-latex/unnamed-chunk-21-1} 

}

\caption{三角函数添加图例}(\#fig:unnamed-chunk-21)
\end{figure}


```r
xmin <- par("usr")[1]
xmax <- par("usr")[2]
ymin <- par("usr")[3]
ymax <- par("usr")[4]

plot(y ~ x,
  type = "l", lwd = 3,
  ylab = "", xlab = "angle", main = "Trigonometric functions"
)
abline(h = 0, lty = 3)
abline(v = 0, lty = 3)
lines(z ~ x, type = "l", lwd = 3, col = "red")
legend("bottomleft",
  c("Sine", "Cosine"),
  lwd = 3, lty = 1, col = c(par("fg"), "red")
)
```

\begin{figure}

{\centering \includegraphics{graphics-foundations_files/figure-latex/unnamed-chunk-22-1} 

}

\caption{设置图例的位置}(\#fig:unnamed-chunk-22)
\end{figure}


```r
plot(y ~ x,
  type = "l", lwd = 3,
  ylab = "", xlab = "angle", main = "Trigonometric functions"
)
abline(h = 0, lty = 3)
abline(v = 0, lty = 3)
lines(z ~ x, type = "l", lwd = 3, col = "red")
legend("bottomleft",
  c("Sine", "Cosine"),
  inset = c(.03, .03),
  lwd = 3, lty = 1, col = c(par("fg"), "red")
)
```

\begin{figure}

{\centering \includegraphics{graphics-foundations_files/figure-latex/unnamed-chunk-23-1} 

}

\caption{insert 函数微调图例位置}(\#fig:unnamed-chunk-23)
\end{figure}



```r
op <- par(no.readonly = TRUE)
plot(y ~ x,
  type = "l", lwd = 3,
  ylab = "", xlab = "angle", main = "Trigonometric functions"
)
abline(h = 0, lty = 3)
abline(v = 0, lty = 3)
lines(z ~ x, type = "l", lwd = 3, col = "red")
par(xpd = TRUE) # Do not clip to the drawing area 关键一行/允许出界
lambda <- .025
legend(par("usr")[1],
  (1 + lambda) * par("usr")[4] - lambda * par("usr")[3],
  c("Sine", "Cosine"),
  xjust = 0, yjust = 0,
  lwd = 3, lty = 1, col = c(par("fg"), "red")
)
```

\begin{figure}

{\centering \includegraphics{graphics-foundations_files/figure-latex/unnamed-chunk-24-1} 

}

\caption{将图例放在绘图区域外面}(\#fig:unnamed-chunk-24)
\end{figure}

```r
par(op)
```

Hmisc 包的 labcurve 函数可以在曲线上放置名称，而不是遥远的图例上

### 边空 {#base-par}

边空分为内边空和外边空

\begin{figure}

{\centering \subfloat[内边空(\#fig:par-mai-oma-1)]{\includegraphics[width=0.35\linewidth]{../../../../../opt/R/4.2.0/lib/R/library/graphics/help/figures/mai} }\subfloat[外边空(\#fig:par-mai-oma-2)]{\includegraphics[width=0.35\linewidth]{../../../../../opt/R/4.2.0/lib/R/library/graphics/help/figures/oma} }

}

\caption{边空}(\#fig:par-mai-oma)
\end{figure}


`line` 第一行


```r
N <- 200
x <- runif(N, -4, 4)
y <- sin(x) + .5 * rnorm(N)
plot(x, y,
  xlab = "", ylab = "",
  main = paste(
    "The \"mtext\" function",
    paste(rep(" ", 60), collapse = "")
  )
)
for (i in seq(from = 0, to = 1, by = 1)) {
  mtext(paste("Line", i), 3, line = i)
}
```

\begin{figure}

{\centering \includegraphics{graphics-foundations_files/figure-latex/unnamed-chunk-25-1} 

}

\caption{外边空在图的边缘添加文字}(\#fig:unnamed-chunk-25)
\end{figure}


`par`


```r
# 多图排列/分屏 page 47
# 最常用的是 par mfrow mfcol分别按行/列放置图形
op <- par(
  mfrow = c(2, 2),
  oma = c(0, 0, 4, 0) # Outer margins
)
for (i in 1:4) {
  plot(runif(20), runif(20),
    main = paste("random plot (", i, ")", sep = "")
  )
}
par(op)
mtext("Four plots, without enough room for this title",
  side = 3, font = 2, cex = 1.5, col = "red"
) # 总/大标题放不下
```

\begin{figure}

{\centering \includegraphics{graphics-foundations_files/figure-latex/unnamed-chunk-26-1} 

}

\caption{多图排列共享一个大标题}(\#fig:unnamed-chunk-26)
\end{figure}

`par` 的 oma 用来设置外边空的大小，默认情形下没有外边空的


```r
par()$oma
```

```
## [1] 0 0 0 0
```

我们可以自己设置外边空


```r
op <- par(
  mfrow = c(2, 2),
  oma = c(0, 0, 3, 0) # Outer margins
)
for (i in 1:4) {
  plot(runif(20), runif(20),
    main = paste("random plot (", i, ")", sep = "")
  )
}
par(op)
mtext("Four plots, with some room for this title",
  side = 3, line = 1.5, font = 1, cex = 1.5, col = "red"
)
```

\begin{figure}

{\centering \includegraphics{graphics-foundations_files/figure-latex/unnamed-chunk-28-1} 

}

\caption{设置外边空放置大标题}(\#fig:unnamed-chunk-28)
\end{figure}

除了内边空还有外边空，内外边空用来放注释说明


```r
op <- par(no.readonly = TRUE)
par(oma = c(2, 2, 2, 2))
plot(1, 1, type = "n", xlab = "", ylab = "", xaxt = "n", yaxt = "n")
for (side in 1:4) {
  inner <- round(par()$mar[side], 0) - 1
  for (line in 0:inner) {
    mtext(text = paste0("Inner line ", line), side = side, line = line)
  }
  outer <- round(par()$oma[side], 0) - 1
  for (line in 0:inner) {
    mtext(text = paste0("Outer line ", line), side = side, line = line, outer = TRUE)
  }
}
```



\begin{center}\includegraphics{graphics-foundations_files/figure-latex/unnamed-chunk-29-1} \end{center}

外边空可以用来放图例


```r
set.seed(1234)
x <- runif(10)
y <- runif(10)
cols <- rep(hcl.colors(5), each = 2)
op <- par(oma = c(2, 2, 0, 4), mar = c(3, 3, 2, 0), mfrow = c(2, 2), pch = 16)
for (i in 1:4) {
  plot(x, y, col = cols, ylab = "", xlab = "")
}
mtext(text = "A common x-axis label", side = 1, line = 0, outer = TRUE)
mtext(text = "A common y-axis label", side = 2, line = 0, outer = TRUE)
legend(
  x = 1, y = 1.2, legend = LETTERS[1:5],
  col = unique(cols), pch = 16, bty = "n", xpd = NA
)
```



\begin{center}\includegraphics{graphics-foundations_files/figure-latex/unnamed-chunk-30-1} \end{center}

```r
par(op)
```

坐标轴标签 `xlab` 和 `ylab` 的内容很长的时候需要内边空


```r
par(cex.lab = 1.7)
plot(1, 1,
  ylab = "A very very long axis title\nthat need special care",
  xlab = "", type = "n"
)

# 增加内边空的大小
par(mar = c(5, 7, 4, 2))
plot(1, 1,
  ylab = "A very very long axis title\nthat need special care",
  xlab = "", type = "n"
)
```



\begin{center}\includegraphics{graphics-foundations_files/figure-latex/unnamed-chunk-31-1} \end{center}

有时候，仅仅增加内边空还不够，坐标轴标签内容甚至可以出现在绘图区域外面，设置 `outer = TRUE`


```r
par(oma = c(0, 4, 0, 0))
plot(1, 1, ylab = "", xlab = "", type = "n")
mtext(
  text = "A very very long axis title\nthat need special care",
  side = 2, line = 0, outer = TRUE, cex = 1.7
)
```



\begin{center}\includegraphics{graphics-foundations_files/figure-latex/unnamed-chunk-32-1} \end{center}



```r
op <- par(
  mfrow = c(2, 2),
  oma = c(0, 0, 3, 0),
  mar = c(3, 3, 4, 1) + .1 # Margins
)
for (i in 1:4) {
  plot(runif(20), runif(20),
    xlab = "", ylab = "",
    main = paste("random plot (", i, ")", sep = "")
  )
}
par(op)
mtext("Title",
  side = 3, line = 1.5, font = 2, cex = 2, col = "red"
)
```

\begin{figure}

{\centering \includegraphics{graphics-foundations_files/figure-latex/unnamed-chunk-33-1} 

}

\caption{设置每个子图的边空 mar}(\#fig:unnamed-chunk-33)
\end{figure}


### 图层 {#base-layer}

覆盖图形 `add = T` or `par(new=TRUE)`


```r
plot(runif(5), runif(5),
  xlim = c(0, 1), ylim = c(0, 1)
)
points(runif(5), runif(5),
  col = "#EA4335", pch = 16, cex = 3
)
lines(runif(5), runif(5), col = "red")
segments(runif(5), runif(5), runif(5), runif(5),
  col = "blue"
)
title(main = "Overlaying points, segments, lines...")
```

\begin{figure}

{\centering \includegraphics{graphics-foundations_files/figure-latex/unnamed-chunk-34-1} 

}

\caption{添加图层}(\#fig:unnamed-chunk-34)
\end{figure}


### 布局 {#base-layout}

`layout` 函数布局， 绘制复杂组合图形


```r
op <- par(oma = c(0, 0, 3, 0))
layout(matrix(c(
  1, 1, 1,
  2, 3, 4,
  2, 3, 4
), nr = 3, byrow = TRUE))
hist(rnorm(n), col = "light blue")
hist(rnorm(n), col = "light blue")
hist(rnorm(n), col = "light blue")
hist(rnorm(n), col = "light blue")
mtext("The \"layout\" function",
  side = 3, outer = TRUE,
  font = 2, cex = 1.2
)
```

\begin{figure}

{\centering \includegraphics{graphics-foundations_files/figure-latex/unnamed-chunk-35-1} 

}

\caption{更加复杂的组合图形}(\#fig:unnamed-chunk-35)
\end{figure}

### 组合 {#base-combine}

`par` 之 `fig` 参数很神奇，使得多个图可以叠加在一起，它接受一个数值向量`c(x1, x2, y1, y2)` ，是图形设备显示区域中的绘图区域的(NDC, normalized device coordinates)坐标。


```r
plot(1:12,
  type = "b", main = "'fg' : axes, ticks and box in gray",
  fg = gray(0.7), bty = "7", sub = R.version.string
)
par(fig = c(1, 6, 5, 10) / 10, new = T)
plot(6:10,
  type = "b", main = "",
  fg = gray(0.7), bty = "7", xlab = R.version.string
)
```

\begin{figure}

{\centering \includegraphics{graphics-foundations_files/figure-latex/unnamed-chunk-36-1} 

}

\caption{多图叠加}(\#fig:unnamed-chunk-36)
\end{figure}

`fig` 参数控制图形的位置，用来绘制组合图形


```r
n <- 1000
x <- rt(n, df = 10)
hist(x,
  col = "light blue",
  probability = "TRUE", main = "",
  ylim = c(0, 1.2 * max(density(x)$y))
)
lines(density(x),
  col = "red",
  lwd = 3
)
op <- par(
  fig = c(.02, .4, .5, .98),
  new = TRUE
)
qqnorm(x,
  xlab = "", ylab = "", main = "",
  axes = FALSE
)
qqline(x, col = "red", lwd = 2)
box(lwd = 2)
```

\begin{figure}

{\centering \includegraphics{graphics-foundations_files/figure-latex/unnamed-chunk-37-1} 

}

\caption{组合图形}(\#fig:unnamed-chunk-37)
\end{figure}

```r
par(op)
```


### 分屏 {#base-screen}

`split.screen` 分屏组合


```r
random.plot <- function() {
  N <- 200
  f <- sample(
    list(
      rnorm,
      function(x) {
        rt(x, df = 2)
      },
      rlnorm,
      runif
    ),
    1
  ) [[1]]
  x <- f(N)
  hist(x, col = "lightblue", main = "", xlab = "", ylab = "", axes = F)
  axis(1)
}
op <- par(bg = "white", mar = c(2.5, 2, 1, 2))
split.screen(c(2, 1))
```

```
## [1] 1 2
```

```r
split.screen(c(1, 3), screen = 2)
```

```
## [1] 3 4 5
```

```r
screen(1)
random.plot()
# screen(2); random.plot() # Screen 2 was split into three screens: 3, 4, 5
screen(3)
random.plot()
screen(4)
random.plot()
screen(5)
random.plot()
```

\begin{figure}

{\centering \includegraphics{graphics-foundations_files/figure-latex/unnamed-chunk-38-1} 

}

\caption{分屏}(\#fig:unnamed-chunk-38)
\end{figure}

```r
close.screen(all = TRUE)
par(op)
```



### 交互 {#identify-locator}

辅助绘图 identify locator

## 基础统计图形 {#base-graphics}

按图的类型划分，最后在小结部分给出各图适用的数据类型

根据数据类型划分： 对于一元数据，可用什么图来描述；多元数据呢，连续数据和离散数据（分类数据）

先找一个不重不漏的划分，指导原则是根据数据类型选择图，根据探索到的数据中的规律，选择图

其它 assocplot fourfoldplot sunflowerplot

### 条形图 {#plot-bar}

[条形图](https://rpubs.com/chidungkt/392980) 

简单条形图


```r
data(diamonds, package = "ggplot2") # 加载数据
par(mar = c(2, 5, 1, 1))
barCenters <- barplot(table(diamonds$cut),
  col = "lightblue", axes = FALSE,
  axisnames = FALSE, horiz = TRUE, border = "white"
)
text(
  y = barCenters, x = par("usr")[3],
  adj = 1, labels = names(table(diamonds$cut)), xpd = TRUE
)
axis(1,
  labels = seq(0, 25000, by = 5000), at = seq(0, 25000, by = 5000),
  las = 1, col = "gray"
)
grid()
```

\begin{figure}

{\centering \includegraphics{graphics-foundations_files/figure-latex/diamonds-base-barplot-1} 

}

\caption{条形图}(\#fig:diamonds-base-barplot)
\end{figure}



简单柱形图




```r
set.seed(123456)
barPois <- table(stats::rpois(1000, lambda = 5))
plot(barPois, col = "lightblue", type = "h", lwd = 10, main = "")
box(col = "gray")
```

\begin{figure}

{\centering \includegraphics{graphics-foundations_files/figure-latex/unnamed-chunk-39-1} 

}

\caption{柱形图}(\#fig:unnamed-chunk-39)
\end{figure}



复合条形图



```r
par(mar = c(4.1, 2.1, 0.5, 4.5))
barplot(VADeaths,
  border = "white", horiz = FALSE, col = hcl.colors(5),
  legend.text = rownames(VADeaths), xpd = TRUE, beside = TRUE,
  cex.names = 0.9,
  args.legend = list(
    x = "right", border = "white", title = "Age",
    box.col = NA, horiz = FALSE, inset = c(-.2, 0),
    xpd = TRUE
  ),
  panel.first = grid(nx = 0, ny = 7)
)
```

\begin{figure}

{\centering \includegraphics{graphics-foundations_files/figure-latex/barplot-VADeaths-1-1} 

}

\caption{复合条形图}(\#fig:barplot-VADeaths-1)
\end{figure}

堆积条形图


```r
par(mar = c(4.1, 2.1, 0.5, 4.5))
barplot(VADeaths,
  border = "white", horiz = FALSE, col = hcl.colors(5),
  legend.text = rownames(VADeaths), xpd = TRUE, beside = FALSE,
  cex.names = 0.9,
  args.legend = list(
    x = "right", border = "white", title = "Age",
    box.col = NA, horiz = FALSE, inset = c(-.2, 0),
    xpd = TRUE
  ),
  panel.first = grid(nx = 0, ny = 4)
)
```

\begin{figure}

{\centering \includegraphics{graphics-foundations_files/figure-latex/barplot-VADeaths-2-1} 

}

\caption{堆积条形图}(\#fig:barplot-VADeaths-2)
\end{figure}

- 堆积条形图 spineplot

简单条形图


```r
barplot(
  data = BOD, demand ~ Time, ylim = c(0, 20),
  border = "white", horiz = FALSE, col = hcl.colors(1)
)
```



\begin{center}\includegraphics{graphics-foundations_files/figure-latex/barplot-BOD-1} \end{center}




```r
pg_mean <- aggregate(weight ~ group, data = PlantGrowth, mean)
barplot(
  data = pg_mean, weight ~ group,
  border = "white", horiz = FALSE, col = hcl.colors(3)
)
```



\begin{center}\includegraphics{graphics-foundations_files/figure-latex/barplot-PlantGrowth-1} \end{center}

Titanic 数据集是 table 数据类型

简单条形图

复合条形图


```r
barplot(Freq ~ Class + Survived,
  data = Titanic,
  subset = Age == "Adult" & Sex == "Male",
  beside = TRUE,
  border = "white", horiz = FALSE, col = hcl.colors(4),
  args.legend = list(
    border = "white", title = "Class",
    box.col = NA, horiz = FALSE,
    xpd = TRUE
  ),
  ylab = "# {passengers}", legend = TRUE
)
```



\begin{center}\includegraphics{graphics-foundations_files/figure-latex/unnamed-chunk-40-1} \end{center}


堆积条形图


```r
barplot(Freq ~ Class + Survived,
  data = Titanic,
  subset = Age == "Adult" & Sex == "Male",
  border = "white", horiz = FALSE, col = hcl.colors(4),
  args.legend = list(
    border = "white", title = "Class",
    box.col = NA, horiz = FALSE,
    xpd = TRUE
  ),
  ylab = "# {passengers}", legend = TRUE
)
```



\begin{center}\includegraphics{graphics-foundations_files/figure-latex/unnamed-chunk-41-1} \end{center}

### 直方图 {#plot-hist}


```r
set.seed(1234)
n <- 2^24
x <- runif(n, 0, 1)
delta <- 0.01
len <- diff(c(0, which(x < delta), n + 1)) - 1
ylim <- seq(0, 1800, by = 300)
xlim <- seq(0, 100, by = 20)
p <- hist(len[len < 101], breaks = -1:100 + 0.5, plot = FALSE)
plot(p, ann = FALSE, axes = FALSE, col = "lightblue", border = "white", main = "")
axis(1, labels = xlim, at = xlim, las = 1) # x 轴
axis(2, labels = ylim, at = ylim, las = 0) # y 轴
box(col = "gray")
```

\begin{figure}

{\centering \includegraphics[width=0.55\linewidth]{graphics-foundations_files/figure-latex/unnamed-chunk-42-1} 

}

\caption{直方图}(\#fig:unnamed-chunk-42)
\end{figure}



```r
with(faithful, plot(eruptions ~ waiting, pch = 16))
```



\begin{center}\includegraphics{graphics-foundations_files/figure-latex/unnamed-chunk-43-1} \end{center}


```r
with(faithful, hist(waiting,
  main = "Time between Old Faithful eruptions",
  xlab = "Minutes", ylab = "",
  cex.main = 1.5, cex.lab = 1.5, cex.axis = 1.4
))
```



\begin{center}\includegraphics{graphics-foundations_files/figure-latex/unnamed-chunk-44-1} \end{center}



```r
with(data = faithful, {
  hist(eruptions, seq(1.6, 5.2, 0.2),
    prob = TRUE,
    main = "", col = "lightblue", border = "white"
  )
  lines(density(eruptions, bw = 0.1), col = "#EA4335")
  rug(eruptions, col = "#EA4335") # 添加数据点
})
```

\begin{figure}

{\centering \includegraphics{graphics-foundations_files/figure-latex/eruptions-1} 

}

\caption{老忠实泉间歇性喷水的时间间隔分布}(\#fig:eruptions)
\end{figure}


```r
hist(longley$Unemployed,
  probability = TRUE,
  col = "light blue", main = ""
)
# 添加密度估计
lines(density(longley$Unemployed),
  col = "red",
  lwd = 3
)
```

\begin{figure}

{\centering \includegraphics{graphics-foundations_files/figure-latex/unnamed-chunk-45-1} 

}

\caption{概率密度分布}(\#fig:unnamed-chunk-45)
\end{figure}

直方图有很多花样的，添加阴影线，angle 控制倾斜的角度


```r
# hist(longley$Unemployed, density = 1, angle = 45)
# hist(longley$Unemployed, density = 3, angle = 15)
# hist(longley$Unemployed, density = 1, angle = 15)
hist(longley$Unemployed, density = 3, angle = 45, main = "")
```

\begin{figure}

{\centering \includegraphics{graphics-foundations_files/figure-latex/unnamed-chunk-46-1} 

}

\caption{density 数值越大阴影线越密}(\#fig:unnamed-chunk-46)
\end{figure}

### 密度图 {#plot-density}



```r
data(galaxies, package = "MASS")
galaxies <- galaxies / 1000
# Bandwidth Selection by Pilot Estimation of Derivatives
c(MASS::width.SJ(galaxies, method = "dpi"), MASS::width.SJ(galaxies))
```

```
## [1] 3.256151 2.566423
```



```r
plot(
  x = c(5, 40), y = c(0, 0.2), type = "n", bty = "l",
  xlab = "velocity of galaxy (km/s)", ylab = "density"
)
rug(galaxies)
lines(density(galaxies, width = 3.25, n = 200), col = "blue", lty = 1)
lines(density(galaxies, width = 2.56, n = 200), col = "red", lty = 3)
```



\begin{center}\includegraphics{graphics-foundations_files/figure-latex/unnamed-chunk-48-1} \end{center}


```r
x <- seq(from = 100, to = 174, by = 0.5)
y1 <- dnorm(x, mean = 145, sd = 9)
y2 <- dnorm(x, mean = 128, sd = 8)
plot(x, y1,
  type = "l", lwd = 2, col = "firebrick3",
 main = "Systolic Blood Pressure Before and After Treatment",
  xlab = "Systolic Blood Pressure (mmHg)",
  ylab = "Frequency", yaxt = "n",
  xlim = c(100, 175), ylim = c(0, 0.05)
)

lines(x, y2, col = "dodgerblue4")
polygon(c(117, x, 175), c(0, y2, 0),
  col = "dodgerblue4",
  border = "white"
)

polygon(c(100, x, 175), c(0, y1, 0),
  col = "firebrick3",
  border = "white"
)

axis(2,
  at = seq(from = 0, to = 0.05, length.out = 8),
  labels = seq(from = 0, to = 175, by = 25), las = 1
)

text(x = 100, y = 0.0445, "Pre-Treatment BP", col = "dodgerblue4", cex = 0.9, pos = 4)
text(x = 100, y = 0.0395, "Post-Treatment BP", col = "firebrick3", cex = 0.9, pos = 4)
points(100, 0.0445, pch = 15, col = "dodgerblue4")
points(100, 0.0395, pch = 15, col = "firebrick3")
abline(v = c(145, 128), lwd = 2, lty = 2, col = 'gray')
```



\begin{center}\includegraphics[width=0.65\linewidth]{graphics-foundations_files/figure-latex/unnamed-chunk-49-1} \end{center}



```r
days <- abs(rnorm(1000, 80, 125))
plot(density(days, from = 0),
  main = "Density plot",
  xlab = "Number of days since trial started"
)
```



\begin{center}\includegraphics[width=0.55\linewidth]{graphics-foundations_files/figure-latex/unnamed-chunk-50-1} \end{center}

```r
plot(density(days, from = 0, to = 180, adjust = 0.2),
  main = "Density plot - Up to 180 days (86% of data)",
  xlab = "Number of days since trial started"
)
```



\begin{center}\includegraphics[width=0.55\linewidth]{graphics-foundations_files/figure-latex/unnamed-chunk-50-2} \end{center}


```r
library(survival)
surv.days <- Surv(days)
surv.fit <- survfit(surv.days ~ 1)
plot(surv.fit,
  main = "Kaplan-Meier estimate with 95% confidence bounds (86% of data)",
  xlab = "Days since trial started",
  xlim = c(0, 180),
  ylab = "Survival function"
)
grid(20, 10, lwd = 2)
```



\begin{center}\includegraphics[width=0.75\linewidth]{graphics-foundations_files/figure-latex/unnamed-chunk-51-1} \end{center}

[visualize-distributions]: https://www.displayr.com/using-heatmap-coloring-density-plot-using-r-visualize-distributions/

### 经验图 {#plot-ecdf}


```r
with(data = faithful, {
  long <- eruptions[eruptions > 3]
  plot(ecdf(long), do.points = FALSE, verticals = TRUE, main = "")
  x <- seq(3, 5.4, 0.01)
  lines(x, pnorm(x, mean = mean(long), sd = sqrt(var(long))), lty = 3)
})
```

\begin{figure}

{\centering \includegraphics{graphics-foundations_files/figure-latex/faithful-ecdf-1} 

}

\caption{累积经验分布图}(\#fig:faithful-ecdf)
\end{figure}

### QQ 图 {#plot-qqnorm}


```r
with(data = faithful, {
  long <- eruptions[eruptions > 3]
  par(pty = "s") # arrange for a square figure region
  qqnorm(long, main = "")
  qqline(long)
})
```



\begin{center}\includegraphics{graphics-foundations_files/figure-latex/faithful-eruptions-1} \end{center}


### 时序图 {#plot-ts}

时序图最适合用来描述股价走势


```r
matplot(time(EuStockMarkets), EuStockMarkets,
  main = "",
  xlab = "Date", ylab = "closing prices",
  pch = 17, type = "l", col = 1:4
)
legend("topleft", colnames(EuStockMarkets), pch = 17, lty = 1, col = 1:4)
```

\begin{figure}

{\centering \includegraphics{graphics-foundations_files/figure-latex/unnamed-chunk-52-1} 

}

\caption{1991–1998年间主要欧洲股票市场日闭市价格指数图 
 德国 DAX (Ibis), Switzerland SMI, 法国 CAC 和 英国 FTSE}(\#fig:unnamed-chunk-52)
\end{figure}

### 饼图 {#plot-pie}

clockwise 参数


```r
pie.sales <- c(0.12, 0.3, 0.26, 0.16, 0.04, 0.12)
names(pie.sales) <- c(
  "Blueberry", "Cherry",
  "Apple", "Boston Cream", "Other", "Vanilla Cream"
)
pie(pie.sales, clockwise = TRUE, main = "")
segments(0, 0, 0, 1, col = "red", lwd = 2)
text(0, 1, "init.angle = 90", col = "red")
```



\begin{center}\includegraphics{graphics-foundations_files/figure-latex/unnamed-chunk-53-1} \end{center}


### 茎叶图 {#plot-stem-leaf}


```r
stem(longley$Unemployed)
```

```
## 
##   The decimal point is 2 digit(s) to the right of the |
## 
##   1 | 99
##   2 | 134899
##   3 | 46789
##   4 | 078
```


### 散点图 {#plot-scatter}

在一维空间上，绘制散点图，其实是在看散点的疏密程度随坐标轴的变化


```r
stripchart(longley$Unemployed,
  method = "jitter",
  jitter = 0.1, pch = 16, col = "lightblue"
)
stripchart(longley$Unemployed,
  method = "overplot",
  pch = 16, col = "lightblue"
)
```

\begin{figure}

{\centering \subfloat[抖动图(\#fig:unnamed-chunk-55-1)]{\includegraphics{graphics-foundations_files/figure-latex/unnamed-chunk-55-1} }\subfloat[疏密图(\#fig:unnamed-chunk-55-2)]{\includegraphics{graphics-foundations_files/figure-latex/unnamed-chunk-55-2} }

}

\caption{一维散点图}(\#fig:unnamed-chunk-55)
\end{figure}

气泡图是二维散点图的一种变体，气泡的大小可以用来描述第三个变量，下面以数据集 topo 为例展示气泡图


```r
# 加载数据集
data(topo, package = "MASS")
# 查看数据集
str(topo)
```

```
## 'data.frame':	52 obs. of  3 variables:
##  $ x: num  0.3 1.4 2.4 3.6 5.7 1.6 2.9 3.4 3.4 4.8 ...
##  $ y: num  6.1 6.2 6.1 6.2 6.2 5.2 5.1 5.3 5.7 5.6 ...
##  $ z: int  870 793 755 690 800 800 730 728 710 780 ...
```

topo 是空间地形数据集，包含有52行3列，数据点是310平方英尺范围内的海拔高度数据，x 坐标每单位50英尺，y 坐标单位同 x 坐标，海拔高度 z 单位是英尺


```r
plot(y ~ x,
  cex = (960 - z) / (960 - 690) * 3, data = topo,
  xlab = "X Coordinates", ylab = "Y coordinates"
)
```

\begin{figure}

{\centering \includegraphics{graphics-foundations_files/figure-latex/unnamed-chunk-57-1} 

}

\caption{地形图之海拔高度}(\#fig:unnamed-chunk-57)
\end{figure}

散点图也适合分类数据的展示，在图中用不同颜色或符号标记数据点所属类别，即在普通散点图的基础上添加一分类变量的描述


```r
plot(mpg ~ hp,
  data = subset(mtcars, am == 1), pch = 16, col = "blue",
  xlim = c(50, 350), ylim = c(10, 35)
)
points(mpg ~ hp,
  col = "red", pch = 16,
  data = subset(mtcars, am == 0)
)
legend(300, 35,
  c("1", "0"),
  title = "am",
  col = c("blue", "red"),
  pch = c(16, 16)
)
```

\begin{figure}

{\centering \includegraphics[width=0.75\linewidth]{graphics-foundations_files/figure-latex/category-base-1} 

}

\caption{分类散点图}(\#fig:category-base)
\end{figure}

iris 数据


```r
plot(Sepal.Length ~ Sepal.Width, data = iris, col = Species, pch = 16)
legend("topright",
  legend = unique(iris$Species), box.col = "gray",
  pch = 16, col = unique(iris$Species)
)
box(col = "gray")
```

\begin{figure}

{\centering \includegraphics[width=0.75\linewidth]{graphics-foundations_files/figure-latex/iris-scatter-1} 

}

\caption{分类散点图}(\#fig:iris-scatter)
\end{figure}

分组散点图和平滑


```r
library(carData)
library(car)
scatterplot(Sepal.Length ~ Sepal.Width,
  col = c("black", "red", "blue"), pch = c(16, 16, 16),
  smooth = TRUE, boxplots = "xy", groups = iris$Species,
  xlab = "Sepal.Width", ylab = "Sepal.Length", data = iris
)
```

有时为了实现特定的目的，需要高亮其中某些点，按类别或者因子变量分组绘制散点图，这里继续采用 `stripchart` 函数绘制二维散点图\@ref(fig:scatter-iris)，由左图可知，函数 `stripchart` 提供的参数 `pch` 不接受向量，实际只是取了前三个值 16 16 17 对应于 Species 的三类，关键是高亮的分界点是有区分意义的


```r
data("iris")
pch <- rep(16, length(iris$Petal.Length))
pch[which(iris$Petal.Length < 1.4)] <- 17
stripchart(Petal.Length ~ Species,
  data = iris,
  vertical = TRUE, method = "jitter",
  pch = pch
)
# 对比一下
stripchart(Petal.Length ~ Species,
  data = iris, subset = Petal.Length > 1.4,
  vertical = TRUE, method = "jitter", ylim = c(1, 7),
  pch = 16
)
stripchart(Petal.Length ~ Species,
  data = iris, subset = Petal.Length < 1.4,
  vertical = TRUE, method = "jitter", add = TRUE,
  pch = 17, col = "red"
)
```

\begin{figure}

{\centering \subfloat[原图(\#fig:scatter-iris-1)]{\includegraphics[width=0.45\linewidth]{graphics-foundations_files/figure-latex/scatter-iris-1} }\subfloat[高亮(\#fig:scatter-iris-2)]{\includegraphics[width=0.45\linewidth]{graphics-foundations_files/figure-latex/scatter-iris-2} }

}

\caption{高亮图中部分散点}(\#fig:scatter-iris)
\end{figure}

如果存在大量散点


```r
densCols(x,
  y = NULL, nbin = 128, bandwidth,
  colramp = colorRampPalette(blues9[-(1:3)])
)
```

`densCols` 函数根据点的局部密度生成颜色，密度估计采用核平滑法，由 **KernSmooth** 包的 `bkde2D` 函数实现。参数 `colramp` 传递一个函数，`colorRampPalette` 根据给定的几种颜色生成函数，参数 `bandwidth` 实际上是传给 `bkde2D` 函数


```r
plot(faithful,
  col = densCols(faithful),
  pch = 20, panel.first = grid()
)
```

\begin{figure}

{\centering \includegraphics[width=0.75\linewidth]{graphics-foundations_files/figure-latex/densCols-1} 

}

\caption{根据点的密度生成颜色}(\#fig:densCols)
\end{figure}

气泡图也是散点图的一种


```r
plot(Volume ~ Height,
  data = trees, pch = 16, cex = Girth / 8,
  col = rev(terrain.colors(nrow(trees), alpha = .5))
)
box(col = "gray")
```

\begin{figure}

{\centering \includegraphics{graphics-foundations_files/figure-latex/unnamed-chunk-60-1} 

}

\caption{气泡图}(\#fig:unnamed-chunk-60)
\end{figure}

气泡图


```r
# 空白画布
plot(c(1, 5, 10), c(1, 5, 10), panel.first = grid(10, 10),
     type = "n", axes = FALSE, ann = FALSE)
# 添加坐标轴
axis(1, at = seq(10), labels = TRUE)
axis(2, at = seq(10), labels = TRUE)
par(new = TRUE) # 在当前图形上添加图形
# axes 坐标轴上的刻度 "xaxt" or "yaxt"  ann 坐标轴和标题的标签
set.seed(1234)
plot(rnorm(100, 5, 1), rnorm(100, 5, 1),
  cex = runif(100, 0, 2),
  col = hcl.colors(4)[rep(seq(4), 100)],
  bg = paste0("gray", replicate(100, sample(seq(100), 1, replace = TRUE))),
  axes = FALSE, ann = FALSE, pch = 21, lwd = 2
)
legend("top",
  legend = paste0("class", seq(4)), col = hcl.colors(4),
  pt.lwd = 2, pch = 21, box.col = "gray", horiz = TRUE
)
```



\begin{center}\includegraphics{graphics-foundations_files/figure-latex/unnamed-chunk-61-1} \end{center}

除了`par(new=TRUE)`设置外，有些函数本身就具有 `add` 选项


```r
set.seed(1234)
plot(dist ~ speed, data = cars, pch = 17, col = "red", cex = 1)
with(cars, symbols(dist ~ speed,
  circles = runif(length(speed), 0, 1),
  pch = 16, inches = .5, add = TRUE
))
z <- lm(dist ~ speed, data = cars)
abline(z, col = "blue")
curve(tan, from = 0, to = 8 * pi, n = 100, add = TRUE)
lines(stats::lowess(cars))
points(10, 100, pch = 16, cex = 3, col = "green")
text(10, 80, "text here", cex = 3)
```



\begin{center}\includegraphics{graphics-foundations_files/figure-latex/unnamed-chunk-62-1} \end{center}

### 抖动图 {#base-jitter}

抖动散点图


```r
mat <- matrix(1:length(colors()), ncol = 9, byrow = TRUE)
df <- data.frame(
  col = colors(),
  x = as.integer(cut(1:length(colors()), 9)),
  y = rep(1:73, 9), stringsAsFactors = FALSE
)
par(mar = c(4, 4, 1, 0.1))
plot(y ~ jitter(x),
  data = df, col = df$col,
  pch = 16, main = "Visualizing colors() split in 9 groups",
  xlab = "Group",
  ylab = "Element of the group (min = 1, max = 73)",
  sub = "x = 3, y = 1 means that it's the 2 * 73 + 1 = 147th color"
)
```

\begin{figure}

{\centering \includegraphics{graphics-foundations_files/figure-latex/jitter-scatter-1} 

}

\caption{抖动散点图}(\#fig:jitter-scatter)
\end{figure}

### 箱线图 {#plot-box}

boxplotdbl: Double Box Plot for Two-Axes Correlation. Correlation chart of two set (x and y) of data. Using Quartiles with boxplot style. Visualize the effect of factor. 

[复合箱线图](https://tomizonor.wordpress.com/2013/03/15/double-box-plot/)


```r
with(data = iris, {
  op <- par(mfrow = c(2, 2), mar = c(4, 4, 2, .5))
  plot(Sepal.Length ~ Species)
  plot(Sepal.Width ~ Species)
  plot(Petal.Length ~ Species)
  plot(Petal.Width ~ Species)
  par(op)
  mtext("Edgar Anderson's Iris Data", side = 3, line = 4)
})
```

\begin{figure}

{\centering \includegraphics{graphics-foundations_files/figure-latex/iris-1} 

}

\caption{安德森的鸢尾花数据}(\#fig:iris)
\end{figure}

箱线图的花样也很多


```r
data(InsectSprays)
par(mar = c(4, 4, .5, .5))
boxplot(
  data = InsectSprays, count ~ spray,
  col = "gray", xlab = "Spray", ylab = "Count"
)

boxplot(
  data = InsectSprays, count ~ spray,
  col = "gray", horizontal = TRUE,
  las = 1, xlab = "Count", ylab = "Spray"
)
```

\begin{figure}

{\centering \subfloat[垂直放置(\#fig:unnamed-chunk-63-1)]{\includegraphics{graphics-foundations_files/figure-latex/unnamed-chunk-63-1} }\newline\subfloat[水平放置(\#fig:unnamed-chunk-63-2)]{\includegraphics{graphics-foundations_files/figure-latex/unnamed-chunk-63-2} }

}

\caption{箱线图}(\#fig:unnamed-chunk-63)
\end{figure}


Notched Boxplots


```r
set.seed(1234)
n <- 8
g <- gl(n, 100, n * 100) # n水平个数 100是重复次数
x <- rnorm(n * 100) + sqrt(as.numeric(g))
boxplot(split(x, g), col = gray.colors(n), notch = TRUE)
title(
  main = "Notched Boxplots", xlab = "Group",
  font.main = 4, font.lab = 1
)
```



\begin{center}\includegraphics{graphics-foundations_files/figure-latex/unnamed-chunk-64-1} \end{center}

真实的情况是这样的


```r
cumcm2011A <- readRDS(file = "cumcm2011A.RDS")
par(mfrow = c(2, 4), mar = c(4, 3, 1, 1))
with(cumcm2011A, boxplot(As, xlab = "As"))
abline(h = c(1.8, 3.6, 5.4), col = c("green", "blue", "red"), lty = 2)

with(cumcm2011A, boxplot(Cd, xlab = "Cd"))
abline(h = c(70, 130, 190), col = c("green", "blue", "red"), lty = 2)

with(cumcm2011A, boxplot(Cr, xlab = "Cr"))
abline(h = c(13, 31, 49), col = c("green", "blue", "red"), lty = 2)

with(cumcm2011A, boxplot(Cu, xlab = "Cu"))
abline(h = c(6.0, 13.2, 20.4), col = c("green", "blue", "red"), lty = 2)

with(cumcm2011A, boxplot(Hg, xlab = "Hg"))
abline(h = c(19, 35, 51), col = c("green", "blue", "red"), lty = 2)

with(cumcm2011A, boxplot(Ni, xlab = "Ni"))
abline(h = c(4.7, 12.3, 19.9), col = c("green", "blue", "red"), lty = 2)

with(cumcm2011A, boxplot(Pb, xlab = "Pb"))
abline(h = c(19, 31, 43), col = c("green", "blue", "red"), lty = 2)

with(cumcm2011A, boxplot(Zn, xlab = "Zn"))
abline(h = c(41, 69, 97), col = c("green", "blue", "red"), lty = 2)
```


```r
boxplot(As ~ area,
  data = cumcm2011A,
  col = hcl.colors(5)
)
abline(
  h = c(1.8, 3.6, 5.4), col = c("green", "blue", "red"),
  lty = 2, lwd = 2
)
```

### 残差图 {#error-bars}

iris 四个测量指标


```r
vec_mean <- colMeans(iris[, -5])
vec_sd <- apply(iris[, -5], 2, sd)
plot(seq(4), vec_mean,
  ylim = range(c(vec_mean - vec_sd, vec_mean + vec_sd)),
  xlab = "Species", ylab = "Mean +/- SD", lwd = 1, pch = 19,
  axes = FALSE
)
axis(1, at = seq(4), labels = colnames(iris)[-5])
axis(2, at = seq(7), labels = seq(7))
arrows(seq(4), vec_mean - vec_sd, seq(4), vec_mean + vec_sd,
  length = 0.05, angle = 90, code = 3
)
box()
```

\begin{figure}

{\centering \includegraphics{graphics-foundations_files/figure-latex/unnamed-chunk-67-1} 

}

\caption{带标准差的均值散点图}(\#fig:unnamed-chunk-67)
\end{figure}


### 提琴图 {#plot-violin}

Tom Kelly 维护的 vioplot 包 <https://github.com/TomKellyGenetics/vioplot>

### 轮廓图 {#plot-contour}

topo 是地形数据

等高线图

### 折线图 {#plot-line}

函数曲线，样条曲线，核密度曲线，平行坐标图

- 折线图
- 点线图 `plot(type="b")` 函数曲线图 `curve` `matplot`  X 样条曲线 `xspline`
- 时序图 

太阳黑子活动数据

sunspot.month          Monthly Sunspot Data, from 1749 to "Present"
sunspot.year           Yearly Sunspot Data, 1700-1988
sunspots               Monthly Sunspot Numbers, 1749-1983


```r
plot(AirPassengers)
box(col = "gray")
```

\begin{figure}

{\centering \includegraphics{graphics-foundations_files/figure-latex/unnamed-chunk-68-1} 

}

\caption{折线图}(\#fig:unnamed-chunk-68)
\end{figure}

### 函数图 {#function}


```r
x0 <- 2^(-20:10)
nus <- c(0:5, 10, 20)
x <- seq(0, 4, length.out = 501)

plot(x0, x0^-8,
  frame.plot = TRUE, # 添加绘图框
  log = "xy", # x 和 y 轴都取对数尺度
  axes = FALSE, # 去掉坐标轴
  xlab = "$u$", ylab = "$\\mathcal{K}_{\\kappa}(u)$", # 设置坐标轴标签
  type = "n", # 清除绘图区域的内容
  ann = TRUE, # 添加标题 x和y轴标签
  panel.first = grid() # 添加背景参考线
)

axis(1,
  at = 10^seq(from = -8, to = 2, by = 2),
  labels = paste0("$\\mathsf{10^{", seq(from = -8, to = 2, by = 2), "}}$")
)
axis(2,
  at = 10^seq(from = -8, to = 56, by = 16),
  labels = paste0("$\\mathsf{10^{", seq(from = -8, to = 56, by = 16), "}}$"), las = 1
)

for (i in seq(length(nus))) {
  lines(x0, besselK(x0, nu = nus[i]), col = hcl.colors(9)[i], lwd = 2)
}
legend("topright",
  legend = paste0("$\\kappa=", rev(nus), "$"),
  col = hcl.colors(9, rev = T), lwd = 2, cex = 1
)
```

\begin{figure}

{\centering \includegraphics[width=0.65\linewidth]{graphics-foundations_files/figure-latex/bessel-function-1} 

}

\caption{贝塞尔函数}(\#fig:bessel-function)
\end{figure}



还有 eta 函数和 gammaz 函数

### 马赛克图 {#plot-mosaic}

马赛克图 mosaicplot


```r
plot(HairEyeColor, col = "lightblue", border = "white", main = "")
```

\begin{figure}

{\centering \includegraphics{graphics-foundations_files/figure-latex/unnamed-chunk-69-1} 

}

\caption{马赛克图}(\#fig:unnamed-chunk-69)
\end{figure}

### 点图 {#plot-dotchart}


dotchart 克利夫兰点图

条件图 coplot

### 矩阵图 {#plot-matrix}

在对角线上添加平滑曲线、密度曲线


```r
pairs(longley,
  gap = 0,
  diag.panel = function(x, ...) {
    par(new = TRUE)
    hist(x,
      col = "light blue",
      probability = TRUE,
      axes = FALSE,
      main = ""
    )
    lines(density(x),
      col = "red",
      lwd = 3
    )
    rug(x)
  }
)
```

\begin{figure}

{\centering \includegraphics[width=0.75\linewidth]{graphics-foundations_files/figure-latex/unnamed-chunk-70-1} 

}

\caption{变量关系}(\#fig:unnamed-chunk-70)
\end{figure}


```r
# 自带 layout
plot(iris[, -5], col = iris$Species)
```

\begin{figure}

{\centering \includegraphics[width=0.75\linewidth]{graphics-foundations_files/figure-latex/unnamed-chunk-71-1} 

}

\caption{矩阵图}(\#fig:unnamed-chunk-71)
\end{figure}


### 雷达图 {#plot-radar}

星图 stars 多元数据

### 玫瑰图 {#plot-rose}


注意与 image 函数区别


```r
x <- 10 * (1:nrow(volcano))
y <- 10 * (1:ncol(volcano))
image(x, y, volcano, col = terrain.colors(100), axes = FALSE)
contour(x, y, volcano,
  levels = seq(90, 200, by = 5),
  add = TRUE, col = "peru"
)
axis(1, at = seq(100, 800, by = 100))
axis(2, at = seq(100, 600, by = 100))
box()
title(main = "Maunga Whau Volcano", font.main = 4)
```

\begin{figure}

{\centering \includegraphics[width=0.75\linewidth]{graphics-foundations_files/figure-latex/unnamed-chunk-72-1} 

}

\caption{image 图形}(\#fig:unnamed-chunk-72)
\end{figure}

### 透视图 {#plot-persp}



```r
par(mar = c(.5, 2.1, .5, .5))
x1 <- seq(-10, 10, length = 51)
x2 <- x1 
f <- function(x1, x2, mu1 = 0, mu2 = 0, s11 = 10, s12 = 15, s22 = 10, rho = 0.5) {
  term1 <- 1 / (2 * pi * sqrt(s11 * s22 * (1 - rho^2)))
  term2 <- -1 / (2 * (1 - rho^2))
  term3 <- (x1 - mu1)^2 / s11
  term4 <- (x2 - mu2)^2 / s22
  term5 <- -2 * rho * ((x1 - mu1) * (x2 - mu2)) / (sqrt(s11) * sqrt(s22))
  term1 * exp(term2 * (term3 + term4 - term5))
} 
z <- outer(x1, x2, f) 
library(shape)
persp(x1, x2, z,
  xlab = "", ylab = "", zlab = "",
  col = drapecol(z, col = terrain.colors(20)),
  border = NA, shade = 0.1, r = 50, d = 0.1, expand = 0.5,
  theta = 120, phi = 15, ltheta = 90, lphi = 180,
  ticktype = "detailed", nticks = 5
)
```

\begin{figure}

{\centering \includegraphics[width=0.75\linewidth]{graphics-foundations_files/figure-latex/normal-dist-1} 

}

\caption{统计学的世界}(\#fig:normal-dist)
\end{figure}


## 栅格统计图形 {#lattice-graphics}

> If you imagine that this pen is Trellis, then Lattice is not this pen.
>
>   --- Paul Murrell [^lattice-2001]

[^lattice-2001]:  Paul 在 DSC 2001 大会上的幻灯片 见<https://www.stat.auckland.ac.nz/~paul/Talks/dsc2001.pdf>

把网站搬出来，汉化 <http://latticeextra.r-forge.r-project.org/>


### 箱线图 {#lattice-boxplot}


```r
library(lattice)
# plot(data = InsectSprays, count ~ spray)
bwplot(count ~ spray, data = InsectSprays)
```



\begin{center}\includegraphics{graphics-foundations_files/figure-latex/unnamed-chunk-73-1} \end{center}


### 折线图 {#lattice-line}

latticeExtra 包提供了强大的图层函数 `layer()`

多元时间序列


```r
library(RColorBrewer)
library(latticeExtra)
xyplot(EuStockMarkets) +
  layer(panel.scaleArrow(
    x = 0.99, append = " units", col = "grey", srt = 90, cex = 0.8
  ))
```



\begin{center}\includegraphics{graphics-foundations_files/figure-latex/unnamed-chunk-74-1} \end{center}


如何解释

时序图

Plot many time series in parallel


```r
horizonplot(EuStockMarkets,
  colorkey = TRUE,
  origin = 4000, horizonscale = 1000
) +
  layer(panel.scaleArrow(
    x = 0.99, digits = 1, col = "grey",
    srt = 90, cex = 0.7
  )) +
  layer(
    lim <- current.panel.limits(),
    panel.text(lim$x[1], lim$y[1], round(lim$y[1], 1),
      font = 2,
      cex = 0.7, adj = c(-0.5, -0.5), col = "#9FC8DC"
    )
  )
```



\begin{center}\includegraphics{graphics-foundations_files/figure-latex/unnamed-chunk-75-1} \end{center}



```r
# # https://stackoverflow.com/questions/25109196/r-lattice-package-add-legend-to-a-figure
library(lattice)
library(nlme)

plot(Orange,
  outer = ~1,
  key = list(
    space = "right", title = "Tree", cex.title = 1,
    lines = list(lty = 1, col = gray.colors(5)),
    # points = list(pch = 1, col = gray.colors(5)),
    text = list(c("3", "1", "5", "2", "4"))
  ),
  par.settings = list(
    # plot.line = list(col = gray.colors(5), border = "transparent"),
    # plot.symbol = list(col = gray.colors(5), border = "transparent"),
    strip.background = list(col = "white"),
    strip.border = list(col = "black")
  )
)
```



\begin{center}\includegraphics{graphics-foundations_files/figure-latex/unnamed-chunk-76-1} \end{center}


```r
library(MASS)
library(lattice)
## Plot the claims frequency against age group by engine size and district

barchart(Claims / Holders ~ Age | Group,
  groups = District,
  data = Insurance, origin = 0, auto.key = TRUE
)
```



\begin{center}\includegraphics{graphics-foundations_files/figure-latex/unnamed-chunk-77-1} \end{center}



```r
barchart(Claims / Holders ~ Age | Group,
  groups = District, data = Insurance,
  main = "Claims frequency",
  auto.key = list(
    space = "top", columns = 4,
    title = "District", cex.title = 1
  )
)
```



\begin{center}\includegraphics{graphics-foundations_files/figure-latex/unnamed-chunk-78-1} \end{center}

lattice 图形的参数设置


```r
show.settings()
```



\begin{center}\includegraphics[width=1\linewidth]{graphics-foundations_files/figure-latex/lattice-settings-1} \end{center}



```r
myColours <- brewer.pal(6, "Blues")
my.settings <- list(
  superpose.polygon = list(col = myColours[2:5], border = "transparent"),
  strip.background = list(col = myColours[6]),
  strip.border = list(col = "black")
)

# 获取参数设置
trellis.par.get()

# 全局参数设置
trellis.par.set(my.settings)
```



```r
library(MASS)
library(lattice)

barchart(Claims / Holders * 100 ~ Age | Group,
  groups = District, data = Insurance,
  origin = 0, main = "Motor insurance claims frequency",
  xlab = "Age", ylab = "Claims frequency %",
  scales = list(alternating = 1),
  auto.key = list(
    space = "top", columns = 4, 
    points = FALSE, rectangles = TRUE,
    title = "District", cex.title = 1
  ),
  par.settings = list(
    superpose.polygon = list(col = gray.colors(4), border = "transparent"),
    strip.background = list(col = "gray80"),
    strip.border = list(col = "black")
  ),
  par.strip.text = list(col = "gray40", font = 2),
  panel = function(x, y, ...) {
    panel.grid(h = -1, v = 0)
    panel.barchart(x, y, ...)
  }
)
```



\begin{center}\includegraphics{graphics-foundations_files/figure-latex/unnamed-chunk-80-1} \end{center}

### 平滑图 {#lattice-smooth}


```r
set.seed(1)
xy <- data.frame(
  x = runif(100),
  y = rt(100, df = 5)
)

xyplot(y ~ x, xy, panel = function(...) {
  panel.xyplot(...)
  panel.smoother(..., span = 0.9)
})
```



\begin{center}\includegraphics{graphics-foundations_files/figure-latex/unnamed-chunk-81-1} \end{center}

```r
library(splines)
xyplot(y ~ x, xy) +
  layer(panel.smoother(y ~ ns(x, 5), method = "lm"))
```



\begin{center}\includegraphics{graphics-foundations_files/figure-latex/unnamed-chunk-81-2} \end{center}

```r
library(nlme)
library(mgcv)
xyplot(y ~ x, xy) +
  layer(panel.smoother(y ~ s(x), method = "gam"))
```



\begin{center}\includegraphics{graphics-foundations_files/figure-latex/unnamed-chunk-81-3} \end{center}

Trellis Displays of Tukey's Hanging Rootograms


```r
x <- rpois(1000, lambda = 50)
rootogram(~x, dfun = function(x) dpois(x, lambda = 50))
```



\begin{center}\includegraphics{graphics-foundations_files/figure-latex/unnamed-chunk-82-1} \end{center}

### 点图 {#lattice-dotplot}


```r
# 添加背景网格线作为参考线
segplot(reorder(factor(county), rate.male) ~ LCL95.male + UCL95.male,
  data = subset(USCancerRates, state == "Washington"),
  draw.bands = FALSE, centers = rate.male
)
```



\begin{center}\includegraphics{graphics-foundations_files/figure-latex/unnamed-chunk-83-1} \end{center}

### 阶梯图 {#lattice-step}

经验累积分布图


```r
ecdfplot(~height | voice.part, data = singer)
```



\begin{center}\includegraphics{graphics-foundations_files/figure-latex/unnamed-chunk-84-1} \end{center}

### 分面图 {#lattice-facet}


```r
## a variant of Figure 5.6 from Sarkar (2008)
## http://lmdvr.r-forge.r-project.org/figures/figures.html?chapter=05;figure=05_06

depth.ord <- rev(order(quakes$depth))
quakes$Magnitude <- equal.count(quakes$mag, 4)
quakes.ordered <- quakes[depth.ord, ]

levelplot(depth ~ long + lat | Magnitude,
  data = quakes.ordered,
  panel = panel.levelplot.points, type = c("p", "g"),
  aspect = "iso", prepanel = prepanel.default.xyplot
)
```



\begin{center}\includegraphics[width=1\linewidth]{graphics-foundations_files/figure-latex/unnamed-chunk-85-1} \end{center}

### 等高线图 {#lattice-contour}


```r
set.seed(1)
xyz <- data.frame(x = rnorm(100), y = rnorm(100))
xyz$z <- with(xyz, x * y + rnorm(100, sd = 1))

## GAM smoother with smoothness by cross validation
library(mgcv)
levelplot(z ~ x * y, xyz,
  panel = panel.2dsmoother,
  form = z ~ s(x, y), method = "gam"
)
```



\begin{center}\includegraphics[width=0.75\linewidth]{graphics-foundations_files/figure-latex/smoothness-1} \end{center}

### 透视图 {#lattice-persp}


```r
library(shape)
persp(volcano, 
  theta = 30, phi = 20, 
  r = 50, d = 0.1, expand = 0.5, ltheta = 90, lphi = 180,
  shade = 0.1, ticktype = "detailed", nticks = 5, box = TRUE,
  col = drapecol(volcano, col = terrain.colors(100)),
  xlab = "X", ylab = "Y", zlab = "Z", border = "transparent",
  main = "Topographic Information \n on Auckland's Maunga Whau Volcano"
)
```

\begin{figure}

{\centering \includegraphics{graphics-foundations_files/figure-latex/volcano-topo-1} 

}

\caption{(ref:volcano-topo)}(\#fig:volcano-topo)
\end{figure}



### 聚类图 {#lattice-cluster}



```r
xyplot(Sepal.Length ~ Petal.Length,
  groups = Species,
  data = iris, scales = "free",
  par.settings = list(
    superpose.symbol = list(pch = c(15:17)),
    superpose.line = list(lwd = 2, lty = 1:3)
  ),
  panel = function(x, y, ...) {
    panel.xyplot(x, y, ...)
    panel.ellipse(x, y, ...)
  },
  auto.key = list(x = .1, y = .8, corner = c(0, 0))
)
```



\begin{center}\includegraphics[width=0.75\linewidth]{graphics-foundations_files/figure-latex/unnamed-chunk-86-1} \end{center}




```r
# lattice 书 6.3.1 节 参数曲面

kx <- function(u, v) cos(u) * (r + cos(u / 2))
ky <- function(u, v) {
  sin(u) * (r + cos(u / 2) * sin(t * v) -
    sin(u / 2) * sin(2 * t * v)) * sin(t * v) -
    sin(u / 2) * sin(2 * t * v)
}


kz <- function(u, v) sin(u / 2) * sin(t * v) + cos(u / 2) * sin(t * v)
n <- 50
u <- seq(0.3, 1.25, length = n) * 2 * pi
v <- seq(0, 1, length = n) * 2 * pi
um <- matrix(u, length(u), length(u))
vm <- matrix(v, length(v), length(v), byrow = TRUE)
r <- 2
t <- 1

wireframe(kz(um, vm) ~ kx(um, vm) + ky(um, vm),
  shade = TRUE, xlab = expression(x[1]),
  ylab = expression(x[2]),
  zlab = list(expression(italic(f) ~ group("(", list(x[1], x[2]), ")")), rot = 90),
  screen = list(z = 170, x = -60),
  alpha = 0.75, panel.aspect = 0.6, aspect = c(1, 0.4),
  scales = list(arrows = FALSE, col = "black"),
  lattice.options = list(
    layout.widths = list(
      left.padding = list(x = -.6, units = "inches"),
      right.padding = list(x = -1.0, units = "inches")
    ),
    layout.heights = list(
      bottom.padding = list(x = -.8, units = "inches"),
      top.padding = list(x = -1.0, units = "inches")
    )
  ),
  par.settings = list(
    axis.line = list(col = "transparent")
  )
)
```



## 运行环境 {#graphics-sessioninfo}


```r
xfun::session_info()
```

```
## R version 4.2.0 (2022-04-22)
## Platform: x86_64-pc-linux-gnu (64-bit)
## Running under: Ubuntu 20.04.6 LTS
## 
## Locale:
##   LC_CTYPE=en_US.UTF-8       LC_NUMERIC=C              
##   LC_TIME=en_US.UTF-8        LC_COLLATE=en_US.UTF-8    
##   LC_MONETARY=en_US.UTF-8    LC_MESSAGES=en_US.UTF-8   
##   LC_PAPER=en_US.UTF-8       LC_NAME=C                 
##   LC_ADDRESS=C               LC_TELEPHONE=C            
##   LC_MEASUREMENT=en_US.UTF-8 LC_IDENTIFICATION=C       
## 
## Package version:
##   base64enc_0.1.3     bookdown_0.26       bslib_0.3.1        
##   cli_3.3.0           compiler_4.2.0      curl_4.3.2         
##   digest_0.6.29       evaluate_0.15       fastmap_1.1.0      
##   fs_1.5.2            glue_1.6.2          graphics_4.2.0     
##   grDevices_4.2.0     grid_4.2.0          highr_0.9          
##   htmltools_0.5.2     jpeg_0.1-9          jquerylib_0.1.4    
##   jsonlite_1.8.0      KernSmooth_2.23-20  knitr_1.39         
##   lattice_0.20-45     latticeExtra_0.6-29 magrittr_2.0.3     
##   mapproj_1.2.8       maps_3.4.0          MASS_7.3-57        
##   Matrix_1.4-1        methods_4.2.0       mgcv_1.8-40        
##   nlme_3.1-157        png_0.1-7           R6_2.5.1           
##   rappdirs_0.3.3      RColorBrewer_1.1-3  rlang_1.0.2        
##   rmarkdown_2.14      sass_0.4.1          shape_1.4.6        
##   splines_4.2.0       stats_4.2.0         stringi_1.7.6      
##   stringr_1.4.0       survival_3.3-1      sysfonts_0.8.8     
##   tinytex_0.39        tools_4.2.0         utils_4.2.0        
##   xfun_0.31           yaml_2.3.5
```

