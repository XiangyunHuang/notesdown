# 神经网络 {#chap:neural-networks}



> A big computer, a complex algorithm and a long time does not equal science.
>
>   --- Robert Gentleman, SSC 2003, Halifax (June 2003)


R 实现的部分，没有 tensorflow 等框架

Norm Matloff 等开发的 [polyreg](https://github.com/matloff/polyreg) 包以多元多项式回归替代神经网络

Brian Ripley 开发的 nnet 包以单层前馈神经网络用于多项对数线性模型


```r
library(nnet)
```

## tensorflow {#sec:tensorflow}

::: {.rmdinfo data-latex="{信息}"}
本地使用 miniconda3 创建了一个叫 tensorflow 的虚拟环境，且已经把 tensorflow 框架安装好
:::

安装 tensorflow

```bash
conda activate r-reticulate
pip install -i https://pypi.tuna.tsinghua.edu.cn/simple tensorflow
```


```r
library(tensorflow)
```

测试 tensorflow 安装环境


```r
tf$constant("Hello Tensorflow")
```

```
## tf.Tensor(b'Hello Tensorflow', shape=(), dtype=string)
```

<https://github.com/henry090/fastai>


::: sidebar
如果调用了 mxnet 包，就不要使用 reticulate 包将 Python 模块 mxnet 也导入进来，这会造成混乱
:::

如果同时安装了 R 包 mxnet，可以直接将 R 环境中矩阵类型的数据对象转化为 R 中的 MXNDArray 对象


```r
(m <- matrix(data = 1:12, nrow = 3, ncol = 4, byrow = TRUE))
class(m)
library(mxnet)
(mm <- mxnet::mx.nd.array(m)) # 转成 R 中的 MXNDArray
class(mm)
```

借助 mxnet 包，亦可以直接创建 MXNDArray 类型的数据对象


```r
# R 中的 MXNDArray
(y <- mxnet::mx.rnorm(shape = 10L, mean = 0L, sd = 1L))
class(y)
```

multiply 是子模块 mxnet.ndarray 下的一个函数，Python 中的两个 mx.nd.array 数据对象做矩阵乘法


```r
3 * y
```


::: sidebar
如果调用了 mxnet 包，就不要使用 reticulate 包将 Python 模块 mxnet 也导入进来，这会造成混乱
:::

mxnet 的 R 接口比 Python 接口弱很多，所以本文使用 reticulate 包，将 mxnet 模块导入到 R 环境中来介绍。mxnet 框架包含很多子模块，比如 ndarray，gluon，symbol 等等，下面具体以多维数组 ndarray 为例展开 [^mxnet-ndarray]。

[^mxnet-ndarray]: mxnet 的 Python 接口 <https://mxnet.apache.org/api/python/docs/api/ndarray/ndarray.html>，此篇介绍源起 [在 R 中使用 gluon](https://d.cosx.org/d/419785-r-gluon)


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

将 Python 中的数据对象 mx.nd.array 转化为 R 中的矩阵，而数据对象具 mx.nd.array 有 `asnumpy()` 方法


```r
(m <- x$asnumpy()) # 得到 R 中的 matrix
```

```
## [[0. 0. 0. 0.]
##  [0. 0. 0. 0.]
##  [0. 0. 0. 0.]]
```

```r
class(m)
```

```
## [1] "numpy.ndarray"         "python.builtin.object"
```

```r
m = matrix(data = 1:12, nrow = 3, ncol = 4, byrow = TRUE)
class(m)
```

```
## [1] "matrix" "array"
```


## 安装配置 {#setup-mxnet}

[^mxnet-centos]: 当前系统是红帽系的 Fedora 29，安装过程参照 CentOS <https://mxnet.apache.org/get_started/centos_setup.html>

下载 mxnet 源码 [^mxnet-centos]

```bash
git clone --depth=1 --branch=master https://github.com/apache/incubator-mxnet.git
cd incubator-mxnet
git submodule update --init 
```

安装系统依赖

```bash
sudo dnf install -y openblas-devel lapack-devel atlas-devel opencv-devel jemalloc-devel \
  ccache llvm doxygen graphviz clang libomp-devel fftw-devel
```

编译 mxnet 动态库

```bash
mkdir build; cd build; cmake -DUSE_CUDA=OFF ..; make -j $(nproc); cd ..
```

安装 R 包依赖

```r
remotes::install_deps('~/incubator-mxnet/R-package')
```

编译并安装 R 包

```bash
make -f R-package/Makefile rpkg
```


## 运行环境 {#mxnet-session-info}


```r
sessionInfo()
```

```
## R version 4.0.3 (2020-10-10)
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
## [1] tensorflow_2.4.0 nnet_7.3-14      reticulate_1.20 
## 
## loaded via a namespace (and not attached):
##  [1] Rcpp_1.0.6        whisker_0.4       knitr_1.33        magrittr_2.0.1   
##  [5] lattice_0.20-41   R6_2.5.0          rlang_0.4.11      stringr_1.4.0    
##  [9] tools_4.0.3       grid_4.0.3        xfun_0.22         png_0.1-7        
## [13] jquerylib_0.1.4   tfruns_1.5.0      htmltools_0.5.1.1 yaml_2.2.1       
## [17] digest_0.6.27     bookdown_0.22     Matrix_1.2-18     base64enc_0.1-3  
## [21] sass_0.3.1        codetools_0.2-16  evaluate_0.14     rmarkdown_2.8    
## [25] stringi_1.6.1     compiler_4.0.3    bslib_0.2.4       jsonlite_1.7.2
```


mxnet 提供了 R 语言
[安装指导](https://mxnet.apache.org/get_started/ubuntu_setup.html#install-the-mxnet-package-for-r) 和 [R参考手册](https://mxnet.apache.org/api/r/docs/api/R-package/build/mxnet-r-reference-manual.pdf)

