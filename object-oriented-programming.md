# 面向对象编程 {#chap-object-oriented-programming}

进入这一章的读者都是对编程感兴趣的读者，希望在工程能力上有所提升的读者。那么最重要的是：

> Code should be written to minimize the time it would take for someone else to understand it.
>
> — The Art of Readable Code, Boswell, D. / Foucher, T.

代码可读性，代码复用性，代码维护性，代码扩展性，代码简洁性，代码高效性，代码容错性，我们共勉吧！如果读者已投身商业公司，应当以完成任务为第一，这自不必说！


## 环境 {#sec-environment}

```r
environment(fun = NULL)
environment(fun) <- value

is.environment(x)

.GlobalEnv
globalenv()
.BaseNamespaceEnv

emptyenv()
baseenv()

new.env(hash = TRUE, parent = parent.frame(), size = 29L)

parent.env(env)
parent.env(env) <- value

environmentName(env)

env.profile(env)
```


## 引用 {#sec-quote}


```r
get(x, pos = -1, envir = as.environment(pos), mode = "any",
    inherits = TRUE)

mget(x, envir = as.environment(-1), mode = "any", ifnotfound,
     inherits = FALSE)

dynGet(x, ifnotfound = , minframe = 1L, inherits = FALSE)
```



```r
get Return the Value of a Named Object

exists Is an Object Defined?

exists(x, where = -1, envir = , frame, mode = "any",
       inherits = TRUE)

get0(x, envir = pos.to.env(-1L), mode = "any", inherits = TRUE,
     ifnotfound = NULL)
```


## 调用栈 {#sec-call-stack}

Functions to Access the Function Call Stack

```r
sys.call(which = 0)
sys.frame(which = 0)
sys.nframe()
sys.function(which = 0)
sys.parent(n = 1)

sys.calls()
sys.frames()
sys.parents()
sys.on.exit()
sys.status()
parent.frame(n = 1)

sys.source Parse and Evaluate Expressions from a File
```

## 闭包 {#sec-closure}

An illustration of lexical scoping.

```r
demo(scoping)
```

## 递归 {#sec-recursion}

Using recursion for adaptive integration

```r
demo(recursion)
```

斐波那契数列


```r
# 递归 Recall
fibonacci <- function(n) {
  if (n <= 2) {
    if (n >= 0) 1 else 0
  } else {
    Recall(n - 1) + Recall(n - 2)
  }
}
fibonacci(10) # 55
```

```
## [1] 55
```

## 异常 {#sec-catching-and-handling-errors}

异常捕获和处理

```r
demo(error.catching)
```

## 对象 {#sec-is-things}

判断对象类型

```r
demo(is.things)
```

## 泛型 {#sec-generic}

> I'd like to prefix all these solutions with 'Here's how to do it, but don't actually do it you crazy fool'. It's on a par with redefining pi, or redefining '+'. And then redefining '<-'. These techniques have their proper place, and that would be in the currently non-existent obfuscated R contest. No, the R-ish (iRish?) way is to index vectors from 1. That's what the R gods intended!
> 
>   --- Barry Rowlingson [^BR-help-2004]

[^BR-help-2004]: <https://stat.ethz.ch/pipermail/r-help/2004-March/048688.html>



如果要让下标从 0 开始的话，我们需要在现有的向量类型 vector 上定义新的向量类型 vector0，在其上并且实现索引运算 `[` 和赋值修改元素的运算 `[<-`


```r
# https://stat.ethz.ch/pipermail/r-help/2004-March/048682.html
as.vector0 <- function(x) structure(x, class = "vector0") # 创建一种新的数据结构 vector0
as.vector.vector0 <- function(x) unclass(x)
"[.vector0" <- function(x, i) as.vector0(as.vector.vector0(x)[i + 1]) # 索引操作
"[<-.vector0" <- function(x, i, value) { # 赋值操作
  x <- as.vector.vector0(x)
  x[i + 1] <- value
  as.vector0(x)
}
print.vector0 <- function(x) print(as.vector.vector0(x)) # 实现 print 方法
```

举个例子看看


```r
1:10 # 是一个内置的现有向量类型 vector
```

```
##  [1]  1  2  3  4  5  6  7  8  9 10
```

```r
x <- as.vector0(1:10) # 转化为新建的 vector0 类型
x[0:4] <- 100 * x[0:4] # 对 x 的元素替换修改
x
```

```
##  [1] 100 200 300 400 500   6   7   8   9  10
```

第三方 R 包大大扩展了 Base R 函数 `plot()` 的功能，比如 **mgcv** ，**nlme** 包和 **lattice** 包等，表 \@ref(tab:generic-functions) 列出当前环境下， `plot()` 绘图方法。

\begin{table}

\caption{(\#tab:generic-functions)泛型函数}
\centering
\begin{tabular}[t]{l|l|l}
\hline
A & B & C\\
\hline
plot.acf & plot.HoltWinters & plot.profile.nls\\
\hline
plot.ACF & plot.intervals.lmList & plot.ranef.lme\\
\hline
plot.augPred & plot.isoreg & plot.ranef.lmList\\
\hline
plot.compareFits & plot.jam & plot.raster\\
\hline
plot.data.frame & plot.lm & plot.shingle\\
\hline
plot.decomposed.ts & plot.lme & plot.simulate.lme\\
\hline
plot.default & plot.lmList & plot.spec\\
\hline
plot.dendrogram & plot.medpolish & plot.spline\\
\hline
plot.density & plot.mlm & plot.stepfun\\
\hline
plot.ecdf & plot.nffGroupedData & plot.stl\\
\hline
plot.factor & plot.nfnGroupedData & plot.table\\
\hline
plot.formula & plot.nls & plot.trellis\\
\hline
plot.function & plot.nmGroupedData & plot.ts\\
\hline
plot.gam & plot.pdMat & plot.tskernel\\
\hline
plot.gls & plot.ppr & plot.TukeyHSD\\
\hline
plot.hclust & plot.prcomp & plot.Variogram\\
\hline
plot.histogram & plot.princomp & plot.xyVector\\
\hline
\end{tabular}
\end{table}

## 除虫 {#sec-code-debug}

[Debugging with RStudio](https://support.rstudio.com/hc/en-us/articles/205612627)

## 性能 {#sec-code-performance}

## 质量 {#sec-code-quality}

Github Action 提供的测试环境支持单元测试 testthat、静态代码检查 lintr、覆盖测试 covr、集成测试 Travis-CI、集成部署 Netlify 等一系列代码检查，还有额外的辅助工具，见 [Github Action 工具合集](https://github.com/sdras/awesome-actions)，相关学习材料见快速参考手册 <https://github.com/github/actions-cheat-sheet> [PDF 版本](https://github.github.io/actions-cheat-sheet/actions-cheat-sheet.pdf)，以创建 R 包为例，展示工程开发的流程 <https://mdneuzerling.com/post/data-science-workflows/>

标准计算和非标准计算 Standard and non-standard evaluation in R <https://www.brodieg.com/2020/05/05/on-nse/>
