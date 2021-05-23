# (APPENDIX) 附录 {#appendix .unnumbered}

# 命令行操作 {#chap:linux-command-bash}

<!-- 提供一个表格左边 R 命令函数，右边系统命令 -->

Bash 文件查找、查看（内容、大小）、移动（重命名）、删除、创建、修改权限

Linux 命令行工具是非常强大的，命令行中的数据科学 <https://www.datascienceatthecommandline.com/>，Linux 命令行 <https://github.com/jaywcjlove/linux-command>

[optparse](https://github.com/trevorld/r-optparse)、[docopt](https://github.com/docopt/docopt.R) 、[littler](https://github.com/eddelbuettel/littler) 包提供了很多便捷的命令行工具，[sys](https://github.com/jeroen/sys)， [fs](https://github.com/r-lib/fs) 在 R 中运行操作系统命令

如表\@ref(tab:r-vs-shell)所示，总结了 R 和 Shell 命令的等价表示，下面以 `list.files()` 和 `ls` 为例，介绍其等价的内容

Table: (\#tab:r-vs-shell) R 和 Shell 命令的等价表示 [^tree]

|          | R                | Shell  |
| :------- | ---------------- | :----- |
| 查看文件 | `list.files()`   | `ls`   |
| 查看目录 | `list.dirs()`    | `dir`  |
| 目录层次 | `fs::dir_tree()` | `tree` |

[^tree]: CentOS 系统默认没有安装 tree 软件，需要先安装才能使用此命令 `sudo dnf install -y tree`

## 查看文件 {#sec:ls}

`ls`/`mkdir`/`mv`/`du`

查看文件

    ```bash
    ls -a
    ```

    列出目录下所有文件

    ```bash
    ls -1 
    ```

    一行显示一个文件或文件夹

    ```bash
    ls -l 
    ```

	按从 aA-zZ 的顺序列出所有文件以及所属权限

	```bash
	ls -rl 
	```

	相比于 `ls -l` 文件是逆序排列

	```bash
	ls -lh
	```

	列出文件或文件夹（不包含子文件夹）的大小 

	```bash
	ls -ld 
	```

	列出当前目录本身，而不是其所包含的内容

## 创建文件夹 {#sec:mkdir}

	```bash
	mkdir images
	```

	创建文件用 `touch` 如 `touch .Rprofile` 

	```bash
	# 删除文件夹及子文件夹，递归删除
	rm -rf images/
	# 删除文件
	rm .Rprofile
	```

## 移动文件 {#sec:mv}

	在当前目录下

	```bash
	# 移动文件夹 images 下的所有文件到 figures 文件夹下
	mv images/* figures/
	# images 文件夹移动到 figures 文件夹下
	mv images/ figures/
	# 移动特定的文件
	mv images/*.png figures/
	```

	同一目录下有两个文件 `R-3.5.1.tar.gz` 未下载完整 和 `R-3.5.1.tar.gz.1` 完全下载

	```bash
	# 删除 R-3.5.1.tar.gz
	rm R-3.5.1.tar.gz
	# 重命名 R-3.5.1.tar.gz.1 
	mv R-3.5.1.tar.gz.1  R-3.5.1.tar.gz
	```

## 查看文件大小 {#sec:du}

	当前目录下各文件夹的大小， `-h` 表示人类（相对于机器来说）可读的方式显示，如 Kb、Mb、Gb，`-d` 表示目录深度 `du --human-readable --max-depth=1 ./`

	```bash
	du -h -d 1 ./
	```

	```bash
	# 对当前目录下的文件/夹 按大小排序
	du -sh * | sort -nr
	```


## 终端模拟器 {#sec:shell}

[oh-my-zsh](https://ohmyz.sh/) 是 [Z Shell](https://www.zsh.org/) 扩展，开发在 Github 上 <https://github.com/ohmyzsh/ohmyzsh>。

zsh 相比于 bash， 在语法高亮、自动补全等方面有优势

```bash
sudo dnf install -y zsh
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

RStudio 集成的终端支持 Zsh，操作路径 Tools -> Global Options -> Terminal， 见图 \@ref(fig:zsh-rstudio)

![(\#fig:zsh-rstudio) RStudio IDE 集成的 Zsh 终端模拟器](screenshots/zsh-rstudio.png){ width=75% }

## 压缩和解压缩 {#sec:tar}

最常见的压缩文件格式有 `.tar`、`.tar.gz`、`.tar.bz2`、`.zip` 和 `.rar`，分别对应于 Tar <https://www.gnu.org/software/tar/>、 Gzip <https://www.gzip.org/> 、 Bzip2 <https://www.bzip.org/> 、 UnZip/Zip <http://www.info-zip.org>  和 WinRAR <https://www.rarlab.com/>。 Tar 提供了基本的打包和解包工具，Gzip 和 Bzip2 在 Tar 打包的基础上提供了压缩功能， UnZip/Zip 是兼容 Windows 原生压缩/解压缩功能的程序，WinRAR 是广泛流行于 Windows 系统的压缩/解压缩收费软件，除了 WinRAR，其它都是免费甚至开源软件。 下面以 `.tar.gz` 和`.tar.bz2` 两种格式的压缩文件为例，介绍文件压缩和解压缩的操作，其它文件格式的操作类似[^zip]。WinRAR <https://www.rarlab.com/> 是收费的压缩和解压缩工具，也支持 Linux 和 macOS 系统，鉴于它是收费软件，这里就不多展开介绍了，详情请见官网。

[^zip]: zip 格式的文件需要额外安装 zip 和 unzip 两款软件实现压缩和解压缩。


:::::: {.columns}
::: {.column width="47.5%" data-latex="{0.475\textwidth}"}

```bash
sudo dnf install -y tar gzip zip unzip 
# 将目录 ~/tmp 压缩成文件 filename.tar.gz
tar -czf **.tar.gz ~/tmp
# 将文件 filename.tar.gz 解压到目录 ~/tmp
tar -xzf **.tar.gz -C ~/tmp
```
:::
::: {.column width="5%" data-latex="{0.05\textwidth}"}
\ 
<!-- an empty Div (with a white space), serving as
a column separator -->
:::
::: {.column width="47.5%" data-latex="{0.475\textwidth}"}

```bash
sudo dnf install -y bzip2
# 将目录 ~/tmp 压缩成文件 filename.tar.bz2
tar -cjf filename.tar.bz2 ~/tmp
# 将文件 filename.tar.bz2 解压到目录 ~/tmp
tar -xjf filename.tar.bz2 -C ~/tmp
```
:::
::::::

解压不带 tar 的 .gz 文件，比如 [tex.eps.gz](http://www-cs-faculty.stanford.edu/~knuth/tex.eps.gz) 解压后变成 tex.eps

```bash
gzip filename.gz -d ~/tmp
```


## 从源码安装 R {#sec:build-source-code}

从源码编译 R 的需求大概有以下几点：

1. 爱折腾的极客：玩配置，学习 make 相关工具和 Linux 世界的依赖
2. 追求性能：如 [LFS 支持](http://users.suse.com/~aj/linux_lfs.html) 和 [Intel MKL 加速](http://dirk.eddelbuettel.com/blog/2018/04/15/#018_mkl_for_debian_ubuntu)
3. 环境限制：CentOS 或者红帽系统，自带的 R 版本比较落后

```bash
./configure --prefix=/opt/R/R-devel \
  --enable-R-shlib --enable-byte-compiled-packages \
  --enable-BLAS-shlib --enable-memory-profiling --with-blas="-lopenblas"
```
```
R is now configured for x86_64-pc-linux-gnu

  Source directory:            .
  Installation directory:      /opt/R/R-devel

  C compiler:                  gcc  -g -O2
  Fortran fixed-form compiler: gfortran -fno-optimize-sibling-calls -g -O2

  Default C++ compiler:        g++ -std=gnu++11  -g -O2
  C++14 compiler:              g++ -std=gnu++14  -g -O2
  C++17 compiler:              g++ -std=gnu++17  -g -O2
  C++20 compiler:              g++ -std=gnu++2a  -g -O2
  Fortran free-form compiler:  gfortran -fno-optimize-sibling-calls -g -O2
  Obj-C compiler:               

  Interfaces supported:        X11, tcltk
  External libraries:          pcre2, readline, BLAS(OpenBLAS), curl
  Additional capabilities:     PNG, JPEG, TIFF, NLS, cairo, ICU
  Options enabled:             shared R library, shared BLAS, R profiling, memory profiling

  Capabilities skipped:        
  Options not enabled:         

  Recommended packages:        yes
```

配置好了以后，可以编译安装了

```bash
make && sudo make install
```


[flexiblas](https://github.com/Enchufa2/r-flexiblas) 支持多种 BLAS 库自由切换

## 安装软件 {#install-softwares}

本书在后续章节中陆续用到新的 R 包，其安装过程不会在正文中呈现，下面以在 CentOS 8 上安装 **sf** 包为例介绍。首先需要安装一些系统依赖，具体安装哪些依赖参见 **sf** 包开发站点 <https://github.com/r-spatial/sf>。

```bash
sudo dnf config-manager --set-disabled PowerTools # openblas-devel
sudo dnf install -y sqlite-devel gdal-devel \
  proj-devel geos-devel udunits2-devel
```

然后，在 R 命令行窗口中，执行安装命令：

```r
install.packages('sf')
```

至此，安装完成。如遇本地未安装的新 R 包，可从其官方文档中找寻安装方式。如果你完全不知道自己应该安装哪些，考虑把下面的依赖都安装上

```bash
sudo dnf install -y \
  # magick
  ImageMagick-c++-devel \ 
  # pdftools
  poppler-cpp-devel \ 
  # gifski
  cargo 
```

软件包管理器架构图，各个命令分别担负什么样的功能，每个命令学习的一般路径是什么，而不是详细介绍每个命令、每个参数的使用，只需给出一个命令的完整使用即可，其余给出一个查询命令帮助手册

```bash
dnf copr
dnf config-manager
```


## 安装 R 包 {#sec:install-r-pkgs}

Iñaki Ucar 开发的 [cran2copr](https://github.com/Enchufa2/cran2copr) 项目实现在 Fedora 上安装预编译好的二进制 R 包，项目目的类似 Debian 平台上的 [cran2deb](https://github.com/r-builder/cran2deb)


1. [devtools](https://github.com/r-lib/devtools) 是开发 R 包的常用工具，同时具有很重的依赖，请看

   
   ```r
   tools::package_dependencies('devtools', recursive = TRUE)
   ```
   
   ```
   ## $devtools
   ##  [1] "usethis"     "callr"       "cli"         "desc"        "ellipsis"   
   ##  [6] "fs"          "httr"        "lifecycle"   "memoise"     "pkgbuild"   
   ## [11] "pkgload"     "rcmdcheck"   "remotes"     "rlang"       "roxygen2"   
   ## [16] "rstudioapi"  "rversions"   "sessioninfo" "stats"       "testthat"   
   ## [21] "tools"       "utils"       "withr"       "processx"    "R6"         
   ## [26] "glue"        "crayon"      "rprojroot"   "methods"     "curl"       
   ## [31] "jsonlite"    "mime"        "openssl"     "cachem"      "prettyunits"
   ## [36] "digest"      "xopen"       "brew"        "commonmark"  "knitr"      
   ## [41] "purrr"       "Rcpp"        "stringi"     "stringr"     "xml2"       
   ## [46] "brio"        "evaluate"    "magrittr"    "praise"      "ps"         
   ## [51] "waldo"       "clipr"       "gert"        "gh"          "rappdirs"   
   ## [56] "whisker"     "yaml"        "graphics"    "grDevices"   "fastmap"    
   ## [61] "askpass"     "credentials" "sys"         "zip"         "gitcreds"   
   ## [66] "ini"         "highr"       "markdown"    "xfun"        "diffobj"    
   ## [71] "fansi"       "rematch2"    "tibble"      "pillar"      "pkgconfig"  
   ## [76] "vctrs"       "utf8"
   ```

   其中，依赖关系见表 \@ref(tab:devtools-sys-dep)
   
   Table: (\#tab:devtools-sys-dep) devtools 的系统依赖  

   |               |       curl     |         git2r  |    openssl
   |:------------- | :------------- | :------------- | :------------- 
   |  Ubuntu       | libcurl-dev[^curl-dev] |  libgit2-dev   |   libssl-dev  
   |  CentOS       | libcurl-devel  |  libgit2-devel |  openssl-devel

[^curl-dev]: libcurl-dev 是一个虚包 virtual package，由 libcurl4-openssl-dev 或 libcurl4-nss-dev 或 libcurl4-gnutls-dev 实际提供，选择其中一个安装即可。

1. [sf](https://github.com/r-spatial/sf) 是处理空间数据的常用工具

   
   ```r
   tools::package_dependencies('sf', recursive = TRUE)
   ```
   
   ```
   ## $sf
   ##  [1] "methods"    "classInt"   "DBI"        "graphics"   "grDevices" 
   ##  [6] "grid"       "magrittr"   "Rcpp"       "stats"      "tools"     
   ## [11] "units"      "utils"      "e1071"      "class"      "KernSmooth"
   ## [16] "MASS"       "proxy"
   ```
   
   其主要的系统依赖分别是 GEOS 3.5.1, GDAL 2.2.2, PROJ 4.9.2
   
   ```bash
   sudo add-apt-repository -y ppa:ubuntugis/ubuntugis-unstable
   sudo apt-get update
   sudo apt-get install -y libudunits2-dev libgdal-dev libgeos-dev libproj-dev 
   ```

   这样也同时解决了 [udunits2](https://github.com/pacificclimate/Rudunits2)、 [rgdal](https://r-forge.r-project.org/projects/rgdal/) 和 [rgeos](https://r-forge.r-project.org/projects/rgeos/) 等 3个 R 包的系统依赖，其中 udunits2 使用如下命令安装
   
   
   ```r
   install.packages(’udunits2’, configure.args = '--with-udunits2-include=/usr/include/udunits2')
   ```
   
1. 图形设备支持 cairo png jpeg tiff

   ```bash
   sudo apt-get install -y libcairo2-dev libjpeg-dev libpng-dev libtiff-dev 
   ```

1. 图像处理 [imager](https://github.com/dahtah/imager) 和 [magick](https://github.com/ropensci/magick)

   ```bash
   sudo yum install fftw-devel # CentOS
   sudo apt-get install libfftw3-dev # Ubuntu
   ```
   
   在 Ubuntu 系统上安装最新的 libmagick++-dev 库
   
   ```bash
   sudo add-apt-repository -y ppa:opencpu/imagemagick
   sudo apt-get update
   sudo apt-get install -y libmagick++-dev 
   ```
   
   在 CentOS 系统上
   
   ```bash
   sudo yum install -y ImageMagick-c++-devel
   ```
   
   然后安装 R 包 `install.packages(c('imager', 'magick'))`

1. [rgl](https://r-forge.r-project.org/projects/rgl/) 是绘制真三维图形的重量级 R 包

   ```bash
   sudo apt-get install libcgal-dev libglu1-mesa-dev libx11-dev # Ubuntu
   sudo yum install mesa-libGLU mesa-libGLU-devel # CentOS
   ```
   
   然后安装 R 包
   
   ```r
   install.packages('rgl')
   ```
   
   在 Ubuntu 系统上还可以这样安装
   
   ```bash
   sudo add-apt-repository ppa:marutter/rrutter3.5
   sudo apt-get update
   sudo apt-get install r-cran-rgl
   ```

1. [rJava](https://github.com/s-u/rJava) 是 Java 语言和 R 语言之间实现通信交流的桥梁

   ```bash
   sudo apt-get install -y default-jdk
   sudo R CMD javareconf
   ```
   
   然后安装 rJava 包 `install.packages(’rJava’)`


1. [igraph](https://igraph.org/) 是网络数据分析的必备 R 包，为了发挥其最大性能，需要安装三个系统依赖

   ```bash
   sudo apt-get install -y libgmp-dev libxml2-dev libglpk-dev
   ```

   然后安装 R 包

   ```r
   install.packages('igraph')
   ```
   
1. [gpuR](https://github.com/cdeterman/gpuR) 是基于 GPU 进行矩阵计算的扩展包，依赖 RcppEigen 确保安装 OpenCL 和 RViennaCL 或者 安装 Nvidia 驱动和 CUDA，使用 [gpuRcuda](https://github.com/gpuRcore/gpuRcuda) 和 [gputools](https://github.com/nullsatz/gputools) 扩展包，下面安装指导来自其 Wiki

    ```bash
    # Install OpenCL headers
    sudo apt-get install opencl-headers opencv-dev
    
    # Install NVIDIA Drivers and CUDA
    sudo add-apt-repository -y ppa:xorg-edgers/ppa
    sudo apt-get update
    sudo apt-get install nvidia-346 nvidia-settings
    ```

1. [nloptr](https://github.com/jyypma/nloptr) 是 [NLopt](https://github.com/stevengj/NLopt/) 的 R 语言接口，首先安装 NLopt 程序库 `sudo apt-get install libnlopt-dev` 然后安装 R 包`install.packages('nloptr')`，nloptr 被 700+ R 包依赖，如 **lme4**， **spaMM**， **glmmTMB**， **rstanarm** 等。

1. Rmpfr

    ```bash
    sudo apt-get install libmpfr-dev
    ```
    
    ```r
    install.packages(’Rmpfr’)
    ```

1. geojson

    ```bash
    sudo yum install jq-devel protobuf-devel
    ```
    
    ```r
    install.packages(c('geojson','geojsonio','jqr','protolite'))
    ```

1. lgcp

    ```bash
    sudo yum install bwidget
    ```
    
    ```r
    install.packages(c('rpanel','lgcp'))
    ```

1. ijtiff

    ```bash
    sudo yum install jbigkit-devel
    ```
    
    ```r
    install.packages('ijtiff')
    ```

1. webshot 包用于截图

    ```bash
    sudo apt install phantomjs
    ```
    ```r
    install.packages(’webshot’)
    ```

1. gifski 包合成 GIF 动图

    ```bash
    sudo apt-get install cargo
    ```
    
    ```r
    install.packages('gifski')
    ```


## 软件包管理器 {#sec:software-manager}

### dnf {#subsec:dnf-yum}

1. 清理升级后的 CentOS 8 系统内核

查找系统安装的内核

```bash
rpm -qa | sort | grep kernel
```
```
kernel-4.18.0-147.8.1.el8_1.x86_64
kernel-4.18.0-193.6.3.el8_2.x86_64
kernel-core-4.18.0-147.8.1.el8_1.x86_64
kernel-core-4.18.0-193.6.3.el8_2.x86_64
kernel-headers-4.18.0-193.6.3.el8_2.x86_64
kernel-modules-4.18.0-147.8.1.el8_1.x86_64
kernel-modules-4.18.0-193.6.3.el8_2.x86_64
kernel-tools-4.18.0-193.6.3.el8_2.x86_64
kernel-tools-libs-4.18.0-193.6.3.el8_2.x86_64
```

仅保留一个版本的内核，其它旧的内核都删除掉

```bash
sudo dnf remove $(dnf repoquery --installonly --latest-limit=-1 -q)
```
```
模块依赖问题

 问题 1: conflicting requests
  - nothing provides module(perl:5.26) needed by module perl-DBD-MySQL:4.046:8010020191114030811:073fa5fe-0.x86_64
 问题 2: conflicting requests
  - nothing provides module(perl:5.26) needed by module perl-DBI:1.641:8010020191113222731:16b3ab4d-0.x86_64
 问题 3: conflicting requests
  - nothing provides module(perl:5.26) needed by module perl-YAML:1.24:8010020191114031501:a5949e2e-0.x86_64
依赖关系解决。
=======================================================================================================================
 软件包                        架构                  版本                                 仓库                    大小
=======================================================================================================================
移除:
 kernel                        x86_64                4.18.0-147.8.1.el8_1                 @BaseOS                  0  
 kernel-core                   x86_64                4.18.0-147.8.1.el8_1                 @BaseOS                 58 M
 kernel-modules                x86_64                4.18.0-147.8.1.el8_1                 @BaseOS                 20 M

事务概要
=======================================================================================================================
移除  3 软件包

将会释放空间：78 M
确定吗？[y/N]： y
运行事务检查
事务检查成功。
运行事务测试
事务测试成功。
运行事务
  准备中  :                                                                                                        1/1 
  删除    : kernel-4.18.0-147.8.1.el8_1.x86_64                                                                     1/3 
  运行脚本: kernel-4.18.0-147.8.1.el8_1.x86_64                                                                     1/3 
  删除    : kernel-modules-4.18.0-147.8.1.el8_1.x86_64                                                             2/3 
  运行脚本: kernel-modules-4.18.0-147.8.1.el8_1.x86_64                                                             2/3 
  运行脚本: kernel-core-4.18.0-147.8.1.el8_1.x86_64                                                                3/3 
  删除    : kernel-core-4.18.0-147.8.1.el8_1.x86_64                                                                3/3 
  运行脚本: kernel-core-4.18.0-147.8.1.el8_1.x86_64                                                                3/3 
  验证    : kernel-4.18.0-147.8.1.el8_1.x86_64                                                                     1/3 
  验证    : kernel-core-4.18.0-147.8.1.el8_1.x86_64                                                                2/3 
  验证    : kernel-modules-4.18.0-147.8.1.el8_1.x86_64                                                             3/3 

已移除:
  kernel-4.18.0-147.8.1.el8_1.x86_64                          kernel-core-4.18.0-147.8.1.el8_1.x86_64                 
  kernel-modules-4.18.0-147.8.1.el8_1.x86_64                 

完毕！
```

[解决上述模块依赖问题的办法](https://unix.stackexchange.com/questions/587853/centos-8-modular-dependency-problems) 是重置三个 Perl 模块

```bash
sudo dnf module reset perl-DBD-MySQL perl-YAML perl-DBI
```
```
依赖关系解决。
=======================================================================================================================
 软件包                      架构                       版本                         仓库                         大小
=======================================================================================================================
重置模块:
 perl-DBD-MySQL                                                                                                       
 perl-DBI                                                                                                             
 perl-YAML                                                                                                            

事务概要
=======================================================================================================================

确定吗？[y/N]： y
完毕！
```


### apt {#subsec:apt-get}

添加或删除 PPA (Personal Package Archive)，比如在 Ubuntu 20.04 及之前的版本上安装[新版 Inkscape](https://inkscape.org/release/inkscape-1.0/gnulinux/ubuntu/ppa/dl/) 

```bash
sudo add-apt-repository ppa:inkscape.dev/stable
sudo add-apt-repository --remove ppa:inkscape.dev/stable
```


```bash
sudo apt-get install build-essential # 修复依赖问题
sudo apt update # 更新资源列表
sudo apt-get upgrade # 更新软件包
sudo apt-get autoclean # 删除已卸的软件的备份
sudo apt-get clean # 删除已装或已卸的软件的备份
sudo apt-get autoremove --purge * # 推荐卸载软件的方式
apt-get list --upgradable # 列出可升级的包
```


找到并删除旧的内核

```bash
dpkg --list | grep linux-image
sudo apt-get purge linux-image-3.19.0-{18,20,21,25}
sudo update-grub2
```


```bash
# 搜索
apt-cache search octave | grep octave
# 查询
apt show octave
# 安装
sudo apt install octave
```

```bash
sudo apt-get install lsb-core
lsb_release -a
```

```bash
adduser cloud2016 # 添加用户
passwd cloud2016  # 用户密码设为 cloud
whereis sudoers   # 查找文件位置
chmod -v u+w /etc/sudoers # 给文件 sudoers 添加写权限
vim /etc/sudoers # 添加 cloud2016 管理员权限
chmod -v u-w /etc/sudoers # 收回权限
```


安装确认 openssh-server 服务

```bash
sudo apt install openssh-server
sudo /etc/init.d/ssh start
ps -aux | grep ssh
```

