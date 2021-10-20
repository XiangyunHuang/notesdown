# 并行化操作 {#chap-parallel-manipulation}

向量化运算、并行运算和分布式运算

- [future](https://github.com/HenrikBengtsson/future) 在 R 语言中提供统一的并行和分布式处理框架
- [future.apply](https://github.com/HenrikBengtsson/future.apply) 可以替代 base R 提供的 apply 族函数
- [future.batchtools](https://github.com/HenrikBengtsson/future.batchtools) 使用 batchtools 实现并行和分布式处理
- [batchtools](https://github.com/mllg/batchtools) Map 函数的并行实现，用于高性能计算系统和分布式处理，可以单机多核并行也可以多机并行，还提供了一种抽象的机制去定义大规模计算机实验。
- [multidplyr](https://github.com/hadley/multidplyr) 是 dplyr 的后端，多核环境下实现数据分块，提高并行处理性能
- [disk.frame](https://github.com/xiaodaigh/disk.frame) 是基于磁盘的超出内存容量的快速并行数据操作框架
- [parallelMap](https://github.com/berndbischl/parallelMap) R package to interface some popular parallelization back-ends with a unified interface
- [big.data.table](https://github.com/jangorecki/big.data.table) 基于 data.table 的分布式并行计算

## apply {#apply}

apply 家族和 `do.call` 

## MapReduce {#map-reduce}

高阶函数，简单来说，就是参数为函数，返回值也是函数。Base R 提供了 `Reduce` 、`Filter` 、`Find` 、`Map` 、`Negate` 和 `Position` 等常用函数，此外还有 `*apply` 族。

与 `purrr::map` 比较

在 R 语言里玩转`apply`， `Map()` 和 `Reduce()`[^apply-family]，下面分别以提取合并多张 XLSX 表格[^openxl-map]，分组计算[^by-group-calculation] 和子集操作 [^subsetting] 为例，从函数式编程到 MapReduce [^funcprog-map-reduce]，制作数据透视表[^pivot-tables]，用于数据处理的函数式编程和单元测试 Functional programming and unit testing for data munging with R 特别是第三章 <https://b-rodrigues.github.io/fput/>，然后是函数式编程与数据建模 Modeling data with functional programming in R[^modeling-funcprog]



```r
add <- function(x) Reduce("+", x)
add(list(1, 2, 3))
```

```
## [1] 6
```

```r
add_accuml <- function(x) Reduce("+", x, accumulate = TRUE)
add_accuml(list(1, 2, 3))
```

```
## [1] 1 3 6
```


## parallel 

[并行计算小抄](https://github.com/ardeeshany/Parallel_Computing) 将共享内存的 R 包整理在一起


```r
library(parallel)
```


## Rmpi 

[Rmpi](http://fisher.stats.uwo.ca/faculty/yu/Rmpi/) 由卡尔顿大学的 [Hao Yu](https://www.uwo.ca/stats/people/bios/hao-yu.html) 开发和维护

首先安装 openmpi-devel 开发环境（以 Fedora 30 为例）


```bash
yum install -y openmpi-devel
echo "export ORTED=/usr/lib64/openmpi/bin" >> ~/.bashrc
# 或者
echo "PATH=/usr/lib64/openmpi/bin:$PATH; export PATH" | tee -a ~/.bashrc
source ~/.bashrc
```

然后进入 R 安装 R 包 Rmpi


```r
install.packages('Rmpi')
```

使用 Rmpi 包生成两组服从均匀分布的随机数


```r
# 加载 R 包
library(Rmpi)
# 检测可用的逻辑 CPU 核心数
parallel::detectCores()
# 虚拟机分配四个逻辑CPU核 
# 1个 master 2个 worker 主机 cloud
mpi.spawn.Rslaves(nslaves=2)
```
```
#         2 slaves are spawned successfully. 0 failed.
# master (rank 0, comm 1) of size 3 is running on: cloud
# slave1 (rank 1, comm 1) of size 3 is running on: cloud
# slave2 (rank 2, comm 1) of size 3 is running on: cloud
```

调用 `mpi.apply` 函数


```r
set.seed(1234)
mpi.apply(c(10, 20), runif)
```
```
[[1]]
 [1] 0.33684269 0.84638494 0.82776590 0.23707947 0.07593769 0.27981368
 [7] 0.45307675 0.02878214 0.32807421 0.92854275

[[2]]
 [1] 0.63474442 0.04025071 0.01996498 0.01922093 0.41258827 0.84150414
 [7] 0.74705002 0.07635368 0.32807392 0.94570363 0.89187667 0.67069020
[13] 0.92996997 0.22486589 0.22118236 0.15807970 0.65619450 0.16473730
[19] 0.85833484 0.11416449
```

用完要关闭


```r
mpi.close.Rslaves()
```

pbdMPI 包处于活跃维护状态，是 [pbdR 项目](https://github.com/RBigData) 的核心组件，能够以分布式计算的方式轻松处理 TB 级数据^[2016年国际 R 语言大会上的介绍<https://github.com/snoweye/user2016.demo> 和2018年 JSM 会 上的介绍 <https://github.com/RBigData/R_JSM2018>]

[Rhpc](https://prs.ism.ac.jp/~nakama/Rhpc/) 包同样基于 MPI 方式，但是集 Rmpi 和 snow 两个包的优点于一身，在保持 apply 编程风格的同时，能够提供更好的高性能计算环境，支持长向量，能够处理一些大数据。

## gpuR

Charles Determan 开发的 [gpuR](https://github.com/cdeterman/gpuR) 基于 OpenCL 加速，目前处于活跃维护状态。而 Charles Determan 开发的另一个 [gpuRcuda](https://github.com/gpuRcore/gpuRcuda) 包是基于 CUDA 加速

[赵鹏](https://github.com/PatricZhao) 的博客 [ParallelR](http://www.parallelr.com/) 关注基于 [CUDA 的 GPU 加速](https://devblogs.nvidia.com/accelerate-r-applications-cuda/)

此外还有 [gputools](https://github.com/nullsatz/gputools)


```r
library(gpuR)
set.seed(2019)
gpuA <- gpuMatrix(rnorm(16), nrow = 4, ncol = 4)
gpuA
```
```
An object of class "fgpuMatrix"
Slot "address":
<pointer: 0x000000000fbe9760>

Slot ".context_index":
[1] 1

Slot ".platform_index":
[1] 1

Slot ".platform":
[1] "Intel(R) OpenCL"

Slot ".device_index":
[1] 1

Slot ".device":
[1] "Intel(R) HD Graphics 4600"
```

```r
gpuB <- gpuA %*% gpuA
print(gpuB)
```
```
Source: gpuR Matrix [4 x 4]

            [,1]      [,2]      [,3]       [,4]
[1,]  2.61787200 -1.274909 -2.150301 -2.0073860
[2,] -0.02231596  1.566433  0.986027  0.7339008
[3,] -0.12862393  1.848340  3.261899  1.6919358
[4,] -1.90084898 -1.863014 -1.312350 -0.2553876
```



## 运行环境 {#parallel-sessioninfo}


```r
xfun::session_info()
```

```
## R version 4.1.1 (2021-08-10)
## Platform: x86_64-pc-linux-gnu (64-bit)
## Running under: Ubuntu 20.04.3 LTS
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
##   base64enc_0.1.3 bookdown_0.24   compiler_4.1.1  curl_4.3.2     
##   digest_0.6.28   evaluate_0.14   fastmap_1.1.0   glue_1.4.2     
##   graphics_4.1.1  grDevices_4.1.1 highr_0.9       htmltools_0.5.2
##   jquerylib_0.1.4 jsonlite_1.7.2  knitr_1.36      magrittr_2.0.1 
##   methods_4.1.1   rlang_0.4.11    rmarkdown_2.11  stats_4.1.1    
##   stringi_1.7.5   stringr_1.4.0   tinytex_0.34    tools_4.1.1    
##   utils_4.1.1     xfun_0.26       yaml_2.2.1
```

[create-an-empty-data-frame](https://stackoverflow.com/questions/10689055)
[pipe-r](https://www.datacamp.com/community/tutorials/pipe-r-tutorial)

[^modeling-funcprog]: https://cartesianfaith.files.wordpress.com/2015/12/rowe-modeling-data-with-functional-programming-in-r.pdf
[^funcprog-map-reduce]: https://cartesianfaith.com/2015/09/17/from-functional-programming-to-mapreduce-in-r/
[^pivot-tables]: https://digitheadslabnotebook.blogspot.com/2010/01/pivot-tables-in-r.html
[^openxl-map]: https://trinkerrstuff.wordpress.com/2018/02/14/easily-make-multi-tabbed-xlsx-files-with-openxlsx/
[^by-group-calculation]: https://statcompute.wordpress.com/2018/09/03/playing-map-and-reduce-in-r-by-group-calculation/
[^subsetting]: https://statcompute.wordpress.com/2018/09/08/playing-map-and-reduce-in-r-subsetting/
[^apply-family]: https://stackoverflow.com/questions/3505701/grouping-functions-tapply-by-aggregate-and-the-apply-family
