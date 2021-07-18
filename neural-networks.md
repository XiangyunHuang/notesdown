# 神经网络 {#chap:neural-network}



> A big computer, a complex algorithm and a long time does not equal science.
>
>   --- Robert Gentleman, SSC 2003, Halifax (June 2003)

近年来，深度学习框架越来越多，比较受欢迎的有 [tensorflow](https://github.com/tensorflow/tensorflow)、[pytorch](https://github.com/pytorch/pytorch) 和 [mxnet](https://github.com/apache/incubator-mxnet)，RStudio 团队也陆续给它们提供了 R 接口，[tensorflow](https://github.com/rstudio/tensorflow)、[keras](https://github.com/rstudio/keras) 和 [torch](https://github.com/mlverse/torch)。此外，相关主题的还有 [fastai](https://github.com/henry090/fastai)。

Norm Matloff 等开发的 [polyreg](https://github.com/matloff/polyreg) 包以多元多项式回归替代神经网络，Brian Ripley 开发的 nnet 包以单层前馈神经网络用于多项对数线性模型。

## mxnet {#sec:mxnet}

::: {.rmdinfo data-latex="{信息}"}
mxnet 的 R 接口不太稳定好用，安装也比较麻烦，因此，通过 reticulate 包将 Python 模块 mxnet 导入 R 环境，然后调用其函数。
:::

mxnet 框架包含很多子模块，详见[接口文档](https://mxnet.apache.org/versions/1.8.0/api)，比如 ndarray，gluon，symbol 等等，下面具体以多维数组 ndarray 为例展开。


```r
# 导入 mxnet 中的 ndarray
nd <- reticulate::import("mxnet.ndarray", convert = FALSE)
class(nd)
```

```
## [1] "python.builtin.module" "python.builtin.object"
```
zeros 是子模块 mxnet.ndarray 下的一个函数


```r
x <- nd$zeros(c(3L, 4L)) # 得到 python 中的 mx.nd.array
x
```

```
## 
## [[0. 0. 0. 0.]
##  [0. 0. 0. 0.]
##  [0. 0. 0. 0.]]
## <NDArray 3x4 @cpu(0)>
```

将 Python 中的数据对象 mx.nd.array 转化为 R 中的矩阵，而数据对象 mx.nd.array 有 `asnumpy()` 方法


```r
(m1 <- x$asnumpy()) # 得到 R 中的 matrix
```

```
## [[0. 0. 0. 0.]
##  [0. 0. 0. 0.]
##  [0. 0. 0. 0.]]
```

```r
class(m1)
```

```
## [1] "numpy.ndarray"         "python.builtin.object"
```



```r
m2 = matrix(data = 1:12, nrow = 3, ncol = 4, byrow = TRUE)
class(m2)
```

```
## [1] "matrix" "array"
```

## 运行环境 {#neural-network-session}


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
## [1] reticulate_1.20
## 
## loaded via a namespace (and not attached):
##  [1] Rcpp_1.0.7        bookdown_0.22     codetools_0.2-18  lattice_0.20-44  
##  [5] png_0.1-7         digest_0.6.27     grid_4.1.0        jsonlite_1.7.2   
##  [9] magrittr_2.0.1    evaluate_0.14     rlang_0.4.11      stringi_1.7.3    
## [13] Matrix_1.3-4      rmarkdown_2.9     tools_4.1.0       stringr_1.4.0    
## [17] xfun_0.24         yaml_2.2.1        compiler_4.1.0    htmltools_0.5.1.1
## [21] knitr_1.33
```
