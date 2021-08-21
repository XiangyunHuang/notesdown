# 文件操作 {#chap-file-operations}



> 考虑添加 Shell 下的命令实现，参考 [命令行的艺术](https://github.com/jlevy/the-art-of-command-line/blob/master/README-zh.md)


```r
library(magrittr) # 提供管道命令 %>%
```

[fs](https://github.com/r-lib/fs) 由 [Jim Hester](https://www.jimhester.com/) 开发，提供文件系统操作的统一接口，相比于 R 默认的文件系统的操作函数有显而易见的优点，详情请看 <https://fs.r-lib.org/>

对于文件操作，Jim Hester 开发了 [fs 包](https://github.com/r-lib/fs) 目的是统一文件操作的命令，由于时间和历史原因，R内置的文件操作函数的命名很不统一，如 `path.expand()` 和 `normalizePath()`，`Sys.chmod()` 和 `file.access()` 等



```r
# 加载 R 包
library(fs)
```


## 查看文件 {#list}

文件夹只包含文件，目录既包含文件又包含文件夹，`list.dirs` 列出目录或文件夹，`list.files` 列出文件或文件夹 

*  `list.dirs(path = ".", full.names = TRUE, recursive = TRUE)`
   +  path: 指定完整路径名，默认使用当前路径 `getwd()`
   +  full.names: TRUE 返回相对路径，FALSE 返回目录的名称
   +  recursive: 是否递归的方式列出目录，如果是的话，目录下的子目录也会列出

   
   ```r
   # list.dirs(path = '.', full.names = TRUE, recursive = TRUE)
   list.dirs(path = '.', full.names = TRUE, recursive = FALSE)
   ```
   
   ```
   ##  [1] "./_book"                           "./_bookdown_files"                
   ##  [3] "./.git"                            "./.github"                        
   ##  [5] "./bayesian-models_files"           "./case-study_cache"               
   ##  [7] "./case-study_files"                "./code"                           
   ##  [9] "./dashboard"                       "./data"                           
   ## [11] "./data-manipulation_files"         "./data-transportation_files"      
   ....
   ```
   
   ```r
   list.dirs(path = '.', full.names = FALSE, recursive = FALSE)
   ```
   
   ```
   ##  [1] "_book"                           "_bookdown_files"                
   ##  [3] ".git"                            ".github"                        
   ##  [5] "bayesian-models_files"           "case-study_cache"               
   ##  [7] "case-study_files"                "code"                           
   ##  [9] "dashboard"                       "data"                           
   ## [11] "data-manipulation_files"         "data-transportation_files"      
   ....
   ```

*  `list.files(path = ".", pattern = NULL, all.files = FALSE, full.names = FALSE, recursive = FALSE,ignore.case = FALSE, include.dirs = FALSE, no.. = FALSE)`

   是否递归的方式列出目录，如果是的话，目录下的子目录也会列出

   +  path: 指定完整路径名，默认使用当前路径 `getwd()`
   +  full.names: TRUE 返回相对路径，FALSE 返回目录的名称
   +  recursive: 是否递归的方式列出目录，如果是的话，目录下的子目录也会列出

* `file.show(..., header = rep("", nfiles), title = "R Information", delete.file = FALSE, pager = getOption("pager"),encoding = "")` 

   打开文件内容，`file.show` 会在R终端中新开一个窗口显示文件

    
    ```r
    rinternals <- file.path(R.home("include"), "Rinternals.h")
    # file.show(rinternals)
    ```

* `file.info(..., extra_cols = TRUE)` 

   获取文件信息，此外 `file.mode(...)` 、 `file.mtime(...)` 和 `file.size(...)` 分别表示文件的读写权限，修改时间和文件大小。

    
    ```r
    file.info(rinternals)
    ```
    
    ```
    ##                                          size isdir mode               mtime
    ## /opt/R/4.1.1/lib/R/include/Rinternals.h 63180 FALSE  644 2021-08-10 08:11:27
    ##                                                       ctime               atime
    ## /opt/R/4.1.1/lib/R/include/Rinternals.h 2021-08-21 12:57:35 2021-08-21 13:04:45
    ##                                         uid gid uname grname
    ## /opt/R/4.1.1/lib/R/include/Rinternals.h   0   0  root   root
    ```
    
    ```r
    file.mode(rinternals)
    ```
    
    ```
    ## [1] "644"
    ```
    
    ```r
    file.mtime(rinternals)
    ```
    
    ```
    ## [1] "2021-08-10 08:11:27 UTC"
    ```
    
    ```r
    file.size(rinternals)
    ```
    
    ```
    ## [1] 63180
    ```
    
    ```r
    # 查看当前目录的权限
    file.info(".")
    ```
    
    ```
    ##    size isdir mode               mtime               ctime               atime
    ## . 16384  TRUE  755 2021-08-21 13:36:41 2021-08-21 13:36:41 2021-08-21 13:36:42
    ##    uid gid  uname grname
    ## . 1001 121 runner docker
    ```
    
    ```r
    # 查看指定目录权限
    file.info("./_book/")    
    ```
    
    ```
    ##           size isdir mode               mtime               ctime
    ## ./_book/ 12288  TRUE  755 2021-08-21 13:32:17 2021-08-21 13:32:17
    ##                        atime  uid gid  uname grname
    ## ./_book/ 2021-08-21 13:32:16 1001 121 runner docker
    ```

* `file.access(names, mode = 0)`  

   文件是否可以被访问，第二个参数 mode 一共有四种取值 0，1，2，4，分别表示文件的存在性，可执行，可写和可读四种，返回值 0 表示成功，返回值 -1 表示失败。

    
    ```r
    file.access(rinternals,mode = 0)
    ```
    
    ```
    ## /opt/R/4.1.1/lib/R/include/Rinternals.h 
    ##                                       0
    ```
    
    ```r
    file.access(rinternals,mode = 1)
    ```
    
    ```
    ## /opt/R/4.1.1/lib/R/include/Rinternals.h 
    ##                                      -1
    ```
    
    ```r
    file.access(rinternals,mode = 2)
    ```
    
    ```
    ## /opt/R/4.1.1/lib/R/include/Rinternals.h 
    ##                                      -1
    ```
    
    ```r
    file.access(rinternals,mode = 4)
    ```
    
    ```
    ## /opt/R/4.1.1/lib/R/include/Rinternals.h 
    ##                                       0
    ```

* `dir(path = ".", pattern = NULL, all.files = FALSE, full.names = FALSE, recursive = FALSE, ignore.case = FALSE, include.dirs = FALSE, no.. = FALSE)`
   
   查看目录，首先看看和目录操作有关的函数列表

    
    ```r
    apropos("^dir.")
    ```
    
    ```
    ##  [1] "dir_copy"   "dir_create" "dir_delete" "dir_exists" "dir_info"  
    ##  [6] "dir_ls"     "dir_map"    "dir_tree"   "dir_walk"   "dir.create"
    ## [11] "dir.exists" "dirname"
    ```
    
   显而易见，`dir.create` 和 `dir.exists` 分别是创建目录和查看目录的存在性。`dirname` 和 `basename` 是一对函数用来操作文件路径。以当前目录/home/runner/work/masr/masr为例，`dirname(getwd())` 返回 /home/runner/work/masr 而 `basename(getwd())` 返回 masr。对于文件路径而言，`dirname(rinternals)` 返回文件所在的目录/opt/R/4.1.1/lib/R/include， `basename(rinternals)` 返回文件名Rinternals.h。`dir` 函数查看指定路径或目录下的文件，支持以模式匹配和递归的方式查找目录下的文件

    
    ```r
    # 当前目录下的子目录和文件
    dir()
    ```
    
    ```
    ##   [1] "_book"                                      
    ##   [2] "_bookdown_files"                            
    ##   [3] "_bookdown.yml"                              
    ##   [4] "_build.sh"                                  
    ##   [5] "_common.R"                                  
    ##   [6] "_deploy-book.R"                             
    ....
    ```
    
    ```r
    # 查看指定目录的子目录和文件
    dir(path = "./")
    ```
    
    ```
    ##   [1] "_book"                                      
    ##   [2] "_bookdown_files"                            
    ##   [3] "_bookdown.yml"                              
    ##   [4] "_build.sh"                                  
    ##   [5] "_common.R"                                  
    ##   [6] "_deploy-book.R"                             
    ....
    ```
    
    ```r
    # 只列出以字母R开头的子目录和文件
    dir(path = "./", pattern = "^R")
    ```
    
    ```
    ## [1] "README.md"
    ```
    
    ```r
    # 列出目录下所有目录和文件，包括隐藏文件
    dir(path = "./", all.files = TRUE)
    ```
    
    ```
    ##   [1] "_book"                                      
    ##   [2] "_bookdown_files"                            
    ##   [3] "_bookdown.yml"                              
    ##   [4] "_build.sh"                                  
    ##   [5] "_common.R"                                  
    ##   [6] "_deploy-book.R"                             
    ....
    ```
    
    ```r
    # 支持正则表达式
    dir(pattern = '^[A-Z]+[.]txt$', full.names=TRUE, system.file('doc', 'SuiteSparse', package='Matrix'))
    ```
    
    ```
    ## [1] "/opt/R/4.1.1/lib/R/library/Matrix/doc/SuiteSparse/AMD.txt"    
    ## [2] "/opt/R/4.1.1/lib/R/library/Matrix/doc/SuiteSparse/CHOLMOD.txt"
    ## [3] "/opt/R/4.1.1/lib/R/library/Matrix/doc/SuiteSparse/COLAMD.txt" 
    ## [4] "/opt/R/4.1.1/lib/R/library/Matrix/doc/SuiteSparse/SPQR.txt"
    ```
    
    ```r
    # 在临时目录下递归创建一个目录
    dir.create(paste0(tempdir(), "/_book/tmp"), recursive = TRUE)
    ```

查看当前目录下的文件和文件夹 `tree -L 2 .` 或者 `ls -l .` 


## 操作文件 {#manipulation}

实现文件增删改查的函数如下


```r
apropos("^file.")
```

```
##  [1] "file_access"    "file_chmod"     "file_chown"     "file_copy"     
##  [5] "file_create"    "file_delete"    "file_exists"    "file_info"     
##  [9] "file_move"      "file_show"      "file_size"      "file_temp"     
## [13] "file_temp_pop"  "file_temp_push" "file_test"      "file_touch"    
## [17] "file.access"    "file.append"    "file.choose"    "file.copy"     
## [21] "file.create"    "file.edit"      "file.exists"    "file.info"     
## [25] "file.link"      "file.mode"      "file.mtime"     "file.path"     
## [29] "file.remove"    "file.rename"    "file.show"      "file.size"     
## [33] "file.symlink"   "fileSnapshot"
```

1. `file.create(..., showWarnings = TRUE)`

   创建/删除文件，检查文件的存在性
   
    
    ```r
    file.create('demo.txt')
    ```
    
    ```
    ## [1] TRUE
    ```
    
    ```r
    file.exists('demo.txt')
    ```
    
    ```
    ## [1] TRUE
    ```
    
    ```r
    file.remove('demo.txt')
    ```
    
    ```
    ## [1] TRUE
    ```
    
    ```r
    file.exists('demo.txt')
    ```
    
    ```
    ## [1] FALSE
    ```

1. `file.rename(from, to)` 文件重命名

    
    ```r
    file.create('demo.txt')
    ```
    
    ```
    ## [1] TRUE
    ```
    
    ```r
    file.rename(from = 'demo.txt', to = 'tmp.txt')
    ```
    
    ```
    ## [1] TRUE
    ```
    
    ```r
    file.exists('tmp.txt')
    ```
    
    ```
    ## [1] TRUE
    ```

1. `file.append(file1, file2)` 追加文件 `file2` 的内容到文件 `file1` 上

    
    ```r
    if(!dir.exists(paths = 'data/')) dir.create(path = 'data/')
    # 创建两个临时文件
    # file.create(c('data/tmp1.md','data/tmp2.md'))
    # 写入内容
    cat("AAA\n", file = 'data/tmp1.md')
    cat("BBB\n", file = 'data/tmp2.md')
    # 追加文件
    file.append(file1 = 'data/tmp1.md', file2 = 'data/tmp2.md')
    ```
    
    ```
    ## [1] TRUE
    ```
    
    ```r
    # 展示文件内容
    readLines('data/tmp1.md')
    ```
    
    ```
    ## [1] "AAA" "BBB"
    ```

1. `file.copy(from, to, overwrite = recursive, recursive = FALSE,copy.mode = TRUE, copy.date = FALSE)` 复制文件，参考 <https://blog.csdn.net/wzj_110/article/details/86497860>

    
    ```r
    file.copy(from = 'Makefile', to = 'data/Makefile')
    ```
    
    ```
    ## [1] FALSE
    ```

1. `file.symlink(from, to)` 创建符号链接 `file.link(from, to)` 创建硬链接

1. `Sys.junction(from, to)` windows 平台上的函数，提供类似符号链接的功能

1. `Sys.readlink(paths)` 读取文件的符号链接（软链接）

1. `choose.files` 在 Windows 环境下交互式地选择一个或多个文件，所以该函数只运行于 Windows 环境

    
    ```r
    # 选择 zip 格式的压缩文件或其它
    if (interactive())
         choose.files(filters = Filters[c("zip", "All"),])
    ```
    
    `Filters` 参数传递一个矩阵，用来描述或标记R识别的文件类型，上面这个例子就能筛选出 zip 格式的文件

1. `download.file` 文件下载

    
    ```r
    download.file(url = 'https://mirrors.tuna.tsinghua.edu.cn/CRAN/src/base/R-latest.tar.gz',
                  destfile = 'data/R-latest.tar.gz', method = 'auto')
    ```
    



## 压缩文件 {#compression}

tar 和 zip 是两种常见的压缩文件工具，具有免费和跨平台的特点，因此应用范围广^[<https://github.com/libarchive/libarchive/wiki/FormatTar>]。 R 内对应的压缩与解压缩命令是 `tar/untar` 

```r
tar(tarfile, files = NULL,
    compression = c("none", "gzip", "bzip2", "xz"),
    compression_level = 6, tar = Sys.getenv("tar"),
    extra_flags = "")
```

比较常用的压缩文件格式是 `.tar.gz` 和 `.tar.bz2`，将目录 `_book/`及其文件分别压缩成 `_book.tar.gz` 和 `_book.tar.bz2` 压缩包的名字可以任意取，后者压缩比率高。`.tar.xz` 的压缩比率最高，需要确保系统中安装了 gzip，bzip2 和 xz-utils 软件，R 软件自带的 tar 软件来自 [Rtools](https://github.com/rwinlib/rtools35)[^rtools40]，我们可以通过设置系统环境变量 `Sys.setenv(tar="path/to/tar")` 指定外部 tar。`tar` 实际支持的压缩类型只有 `.tar.gz`^[<https://github.com/rwinlib/utils>]。`zip/unzip` 压缩与解压缩就不赘述了。


```r
# 打包目录 _book
tar(tarfile = 'data/_book.tar', files = '_book', compression = 'none')
# 文件压缩成 _book.xz 格式
tar(tarfile = 'data/_book.tar.xz', files = 'data/_book', compression = 'xz')
# tar -cf data/_book.tar _book 然后 xz -z data/_book.tar.xz data/_book.tar
# 或者一次压缩到位 tar -Jcf data/_book.tar.xz _book/

# 解压 xz -d data/_book.tar.xz 再次解压 tar -xf data/_book.tar
# 或者一次解压 tar -Jxf data/_book.tar.xz

# 文件压缩成 _book.tar.gz 格式
# tar -czf data/_book.tar.gz _book
tar(tarfile = 'data/_book.tar.gz', files = '_book', compression = 'gzip')
# 解压 tar -xzf data/_book.tar.gz

# 文件压缩成 .tar.bz2 格式
# tar -cjf data/book2.tar.bz2 _book
tar(tarfile = 'data/_book.tar.bz2', files = '_book', compression = 'bzip2')
# 解压 tar -xjf data/book2.tar.bz2
```

```r
untar(tarfile, files = NULL, list = FALSE, exdir = ".",
      compressed = NA, extras = NULL, verbose = FALSE,
      restore_times =  TRUE, tar = Sys.getenv("TAR"))
```

[^rtools40]: 继 Rtools35 之后， [RTools40](https://cloud.r-project.org/bin/windows/testing/rtools40.html) 主要为 R 3.6.0 准备的，包含有 GCC 8 及其它编译R包需要的[工具包](https://github.com/r-windows/rtools-packages)，详情请看的[幻灯片](https://jeroen.github.io/uros2018)


## 路径操作 {#paths}

环境变量算是路径操作


```r
# 获取环境变量
Sys.getenv("PATH")
```

```
## [1] "/home/runner/.TinyTeX/bin/x86_64-linux:/home/linuxbrew/.linuxbrew/bin:/home/linuxbrew/.linuxbrew/sbin:/home/runner/.local/bin:/opt/pipx_bin:/usr/share/rust/.cargo/bin:/home/runner/.config/composer/vendor/bin:/usr/local/.ghcup/bin:/home/runner/.dotnet/tools:/snap/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin"
```

```r
# 设置环境变量 Windows
# Sys.setenv(R_GSCMD = "C:/Program Files/gs/gs9.26/bin/gswin64c.exe")
# 设置 pandoc 环境变量
pandoc_path <- Sys.getenv("RSTUDIO_PANDOC", NA)
if (Sys.which("pandoc") == "" && !is.na(pandoc_path)) {
  Sys.setenv(PATH = paste(
    Sys.getenv("PATH"), pandoc_path,
    sep = if (.Platform$OS.type == "unix") ":" else ";"
  ))
}
```

操作文件路径

1. `file.path` Construct Path to File

    
    ```r
    file.path('./_book')
    ```
    
    ```
    ## [1] "./_book"
    ```

1. `path.expand(path)` Expand File Paths

    
    ```r
    path.expand('./_book')
    ```
    
    ```
    ## [1] "./_book"
    ```
    
    ```r
    path.expand('~')
    ```
    
    ```
    ## [1] "/home/runner"
    ```

1. `normalizePath()` Express File Paths in Canonical Form

    
    ```r
    normalizePath('~')
    ```
    
    ```
    ## [1] "/home/runner"
    ```
    
    ```r
    normalizePath('./_book')
    ```
    
    ```
    ## [1] "/home/runner/work/masr/masr/_book"
    ```

1. `shortPathName(path)`  只在 Windows 下可用，Express File Paths in Short Form

    
    ```r
    cat(shortPathName(c(R.home(), tempdir())), sep = "\n")
    ```

1. `Sys.glob`  Wildcard Expansion on File Paths

    
    ```r
    Sys.glob(file.path(R.home(), "library", "compiler", "R", "*.rdx")) 
    ```
    
    ```
    ## [1] "/opt/R/4.1.1/lib/R/library/compiler/R/compiler.rdx"
    ```

## 查找文件 {#find}

[here](https://github.com/r-lib/here) 包用来查找你的文件，查找文件、可执行文件的完整路径、R 包

1. `Sys.which` Find Full Paths to Executables

    
    ```r
    Sys.which('pandoc')
    ```
    
    ```
    ##            pandoc 
    ## "/usr/bin/pandoc"
    ```

1. `system.file`  Find Names of R System Files

    
    ```r
    system.file('CITATION',package = 'base')
    ```
    
    ```
    ## [1] "/opt/R/4.1.1/lib/R/library/base/CITATION"
    ```

1. `R.home`

    
    ```r
    # R 安装目录
    R.home()
    ```
    
    ```
    ## [1] "/opt/R/4.1.1/lib/R"
    ```
    
    ```r
    # R执行文件目录
    R.home('bin')
    ```
    
    ```
    ## [1] "/opt/R/4.1.1/lib/R/bin"
    ```
    
    ```r
    # 配置文件目录
    R.home('etc')
    ```
    
    ```
    ## [1] "/opt/R/4.1.1/lib/R/etc"
    ```
    
    ```r
    # R 基础扩展包存放目录
    R.home('library')
    ```
    
    ```
    ## [1] "/opt/R/4.1.1/lib/R/library"
    ```

1. `.libPaths()` R 包存放的路径有哪些

    
    ```r
    .libPaths()
    ```
    
    ```
    ## [1] "/home/runner/work/_temp/Library" "/opt/R/4.1.1/lib/R/library"
    ```

1. `find.package` 查找R包所在目录

    
    ```r
    find.package(package = 'MASS')
    ```
    
    ```
    ## [1] "/opt/R/4.1.1/lib/R/library/MASS"
    ```

1. `file.exist` 检查文件是否存在

    
    ```r
    file.exists(paste(R.home('etc'),"Rprofile.site",sep = .Platform$file.sep))
    ```
    
    ```
    ## [1] FALSE
    ```

1. `apropos` 和 `find` 查找对象


```r
apropos(what, where = FALSE, ignore.case = TRUE, mode = "any")
find(what, mode = "any", numeric = FALSE, simple.words = TRUE)
```

匹配含有 find 的函数


```r
apropos("find")
```

```
##  [1] "find"                 "Find"                 "find.package"        
##  [4] "findClass"            "findFunction"         "findInterval"        
##  [7] "findLineNum"          "findMethod"           "findMethods"         
## [10] "findMethodSignatures" "findPackageEnv"       "findRestart"         
## [13] "findUnique"
```

问号 `?` 加函数名搜索R软件内置函数的帮助文档，如 `?regrex`。如果不知道具体的函数名，可采用关键词搜索，如


```r
help.search(keyword = "character", package = "base")
```

`browseEnv` 函数用来在浏览器中查看当前环境下，对象的列表，默认环境是 `sys.frame()`

## 文件权限 {#permissions}

操作目录和文件的权限 Manipulation of Directories and File Permissions

1. `dir.exists(paths)` 检查目录是否存在

    
    ```r
    dir.exists(c('./_book','./book'))
    ```
    
    ```
    ## [1]  TRUE FALSE
    ```

1. `dir.create(path, showWarnings = TRUE, recursive = FALSE, mode = "0777")` 创建目录

    
    ```r
    dir.create('./_book/tmp')
    ```
    
    ```
    ## Warning in dir.create("./_book/tmp"): './_book/tmp' already exists
    ```

1. `Sys.chmod(paths, mode = "0777", use_umask = TRUE)` 修改权限

    
    ```r
    Sys.chmod('./_book/tmp')
    ```

1. `Sys.umask(mode = NA)`

    


## 区域设置 {#locale}

1. `Sys.getlocale(category = "LC_ALL")` 查看当前区域设置

    
    ```r
    Sys.getlocale(category = "LC_ALL")
    ```
    
    ```
    ## [1] "LC_CTYPE=en_US.UTF-8;LC_NUMERIC=C;LC_TIME=en_US.UTF-8;LC_COLLATE=en_US.UTF-8;LC_MONETARY=en_US.UTF-8;LC_MESSAGES=en_US.UTF-8;LC_PAPER=en_US.UTF-8;LC_NAME=C;LC_ADDRESS=C;LC_TELEPHONE=C;LC_MEASUREMENT=en_US.UTF-8;LC_IDENTIFICATION=C"
    ```

1. `Sys.setlocale(category = "LC_ALL", locale = "")` 设置区域

    
    ```r
    # 默认设置
    Sys.setlocale(category = "LC_ALL", locale = "")
    ```
    
    ```
    ## [1] "LC_CTYPE=en_US.UTF-8;LC_NUMERIC=C;LC_TIME=en_US.UTF-8;LC_COLLATE=en_US.UTF-8;LC_MONETARY=en_US.UTF-8;LC_MESSAGES=en_US.UTF-8;LC_PAPER=en_US.UTF-8;LC_NAME=C;LC_ADDRESS=C;LC_TELEPHONE=C;LC_MEASUREMENT=en_US.UTF-8;LC_IDENTIFICATION=C"
    ```
    
    ```r
    # 保存当前区域设置
    old <- Sys.getlocale()
    
    Sys.setlocale("LC_MONETARY", locale = "")
    ```
    
    ```
    ## [1] "en_US.UTF-8"
    ```
    
    ```r
    Sys.localeconv()
    ```
    
    ```
    ##     decimal_point     thousands_sep          grouping   int_curr_symbol 
    ##               "."                ""                ""            "USD " 
    ##   currency_symbol mon_decimal_point mon_thousands_sep      mon_grouping 
    ##               "$"               "."               ","        "\003\003" 
    ##     positive_sign     negative_sign   int_frac_digits       frac_digits 
    ##                ""               "-"               "2"               "2" 
    ##     p_cs_precedes    p_sep_by_space     n_cs_precedes    n_sep_by_space 
    ##               "1"               "0"               "1"               "0" 
    ##       p_sign_posn       n_sign_posn 
    ##               "1"               "1"
    ```
    
    ```r
    Sys.setlocale("LC_MONETARY", "de_AT")
    ```
    
    ```
    ## Warning in Sys.setlocale("LC_MONETARY", "de_AT"): OS reports request to set
    ## locale to "de_AT" cannot be honored
    ```
    
    ```
    ## [1] ""
    ```
    
    ```r
    Sys.localeconv()
    ```
    
    ```
    ##     decimal_point     thousands_sep          grouping   int_curr_symbol 
    ##               "."                ""                ""            "USD " 
    ##   currency_symbol mon_decimal_point mon_thousands_sep      mon_grouping 
    ##               "$"               "."               ","        "\003\003" 
    ##     positive_sign     negative_sign   int_frac_digits       frac_digits 
    ##                ""               "-"               "2"               "2" 
    ##     p_cs_precedes    p_sep_by_space     n_cs_precedes    n_sep_by_space 
    ##               "1"               "0"               "1"               "0" 
    ##       p_sign_posn       n_sign_posn 
    ##               "1"               "1"
    ```
    
    ```r
    # 恢复区域设置
    Sys.setlocale(locale = old)
    ```
    
    ```
    ## Warning in Sys.setlocale(locale = old): OS reports request to set locale to
    ## "LC_CTYPE=en_US.UTF-8;LC_NUMERIC=C;LC_TIME=en_US.UTF-8;LC_COLLATE=en_US.UTF-8;LC_MONETARY=en_US.UTF-8;LC_MESSAGES=en_US.UTF-8;LC_PAPER=en_US.UTF-8;LC_NAME=C;LC_ADDRESS=C;LC_TELEPHONE=C;LC_MEASUREMENT=en_US.UTF-8;LC_IDENTIFICATION=C"
    ## cannot be honored
    ```
    
    ```
    ## [1] ""
    ```

1. `Sys.localeconv()` 当前区域设置下，数字和货币的表示

    
    ```r
    Sys.localeconv()
    ```
    
    ```
    ##     decimal_point     thousands_sep          grouping   int_curr_symbol 
    ##               "."                ""                ""            "USD " 
    ##   currency_symbol mon_decimal_point mon_thousands_sep      mon_grouping 
    ##               "$"               "."               ","        "\003\003" 
    ##     positive_sign     negative_sign   int_frac_digits       frac_digits 
    ##                ""               "-"               "2"               "2" 
    ##     p_cs_precedes    p_sep_by_space     n_cs_precedes    n_sep_by_space 
    ##               "1"               "0"               "1"               "0" 
    ##       p_sign_posn       n_sign_posn 
    ##               "1"               "1"
    ```

    本地化信息

    
    ```r
    l10n_info()
    ```
    
    ```
    ## $MBCS
    ## [1] TRUE
    ## 
    ## $`UTF-8`
    ## [1] TRUE
    ## 
    ## $`Latin-1`
    ## [1] FALSE
    ## 
    ## $codeset
    ## [1] "UTF-8"
    ```


## 进程管理 {#process}

 [ps](https://github.com/r-lib/ps) 包用来查询进程信息
 
- `Sys.getpid` 获取当前运行中的 R 控制台（会话）的进程 ID

    
    ```r
    Sys.getpid()
    ```
    
    ```
    ## [1] 25641
    ```

- `proc.time()` R 会话运行时间，常用于计算R程序在当前R控制台的运行时间

    
    ```r
    t1 <- proc.time()
    tmp <- rnorm(1e6)
    proc.time() - t1
    ```
    
    ```
    ##    user  system elapsed 
    ##    0.06    0.00    0.06
    ```

- `system.time` 计算 R 表达式/程序块运行耗费的CPU时间

    
    ```r
    system.time({
      rnorm(1e6)
    }, gcFirst = TRUE)
    ```
    
    ```
    ##    user  system elapsed 
    ##   0.054   0.004   0.058
    ```

- `gc.time`  报告垃圾回收耗费的时间

    
    ```r
    gc.time()
    ```
    
    ```
    ## [1] 0 0 0 0 0
    ```

## 系统命令 {#system-commands}

`system` 和 `system2` 调用系统命令，推荐使用后者，它更灵活更便携。此外，Jeroen Ooms 开发的 [sys 包](https://github.com/jeroen/sys) 可看作 `base::system2` 的替代品


```r
system <- function(...) cat(base::system(..., intern = TRUE), sep = '\n')
system2 <- function(...) cat(base::system2(..., stdout = TRUE), sep = "\n")
```

```r
system(command = "xelatex --version")
```

```
## XeTeX 3.141592653-2.6-0.999993 (TeX Live 2021)
## kpathsea version 6.3.3
## Copyright 2021 SIL International, Jonathan Kew and Khaled Hosny.
## There is NO warranty.  Redistribution of this software is
## covered by the terms of both the XeTeX copyright and
## the Lesser GNU General Public License.
## For more information about these matters, see the file
## named COPYING and the XeTeX source.
## Primary author of XeTeX: Jonathan Kew.
## Compiled with ICU version 68.2; using 68.2
## Compiled with zlib version 1.2.11; using 1.2.11
## Compiled with FreeType2 version 2.10.4; using 2.10.4
## Compiled with Graphite2 version 1.3.14; using 1.3.14
## Compiled with HarfBuzz version 2.7.4; using 2.7.4
## Compiled with libpng version 1.6.37; using 1.6.37
## Compiled with pplib version v2.05 less toxic i hope
## Compiled with fontconfig version 2.11.0; using 2.13.1
```

```r
system2(command = 'pdflatex', args = '--version')
```

```
## pdfTeX 3.141592653-2.6-1.40.23 (TeX Live 2021)
## kpathsea version 6.3.3
## Copyright 2021 Han The Thanh (pdfTeX) et al.
## There is NO warranty.  Redistribution of this software is
## covered by the terms of both the pdfTeX copyright and
## the Lesser GNU General Public License.
## For more information about these matters, see the file
## named COPYING and the pdfTeX source.
## Primary author of pdfTeX: Han The Thanh (pdfTeX) et al.
## Compiled with libpng 1.6.37; using libpng 1.6.37
## Compiled with zlib 1.2.11; using zlib 1.2.11
## Compiled with xpdf version 4.03
```

## 时间管理 {#time}

1. `Sys.timezone` 获取时区信息

    
    ```r
    Sys.timezone(location = TRUE)
    ```
    
    ```
    ## [1] "UTC"
    ```

1. `Sys.time` 系统时间，可以给定时区下，显示当前时间，精确到秒，返回数据类型为 `POSIXct`

    
    ```r
    # 此时美国洛杉矶时间
    format(Sys.time(), tz = 'America/Los_Angeles', usetz = TRUE)
    ```
    
    ```
    ## [1] "2021-08-21 06:36:42 PDT"
    ```
    
    ```r
    # 此时加拿大东部时间
    format(Sys.time(), tz = 'Canada/Eastern', usetz = TRUE)
    ```
    
    ```
    ## [1] "2021-08-21 09:36:42 EDT"
    ```

1. `Sys.Date` 显示当前时区下的日期，精确到日，返回数据类型为 `date`

    
    ```r
    Sys.Date()
    ```
    
    ```
    ## [1] "2021-08-21"
    ```

1. `date` 返回当前系统日期和时间，数据类型是字符串

    
    ```r
    date()
    ```
    
    ```
    ## [1] "Sat Aug 21 13:36:42 2021"
    ```
    
    ```r
    ## 也可以这样表示
    format(Sys.time(), "%a %b %d %H:%M:%S %Y")
    ```
    
    ```
    ## [1] "Sat Aug 21 13:36:42 2021"
    ```

1. `as.POSIX*` 是一个 Date-time 转换函数

    
    ```r
    as.POSIXlt(Sys.time(), "GMT") # the current time in GMT
    ```
    
    ```
    ## [1] "2021-08-21 13:36:42 GMT"
    ```

1. 时间计算

    
    ```r
    (z <- Sys.time())             # the current date, as class "POSIXct"
    ```
    
    ```
    ## [1] "2021-08-21 13:36:42 UTC"
    ```
    
    ```r
    Sys.time() - 3600             # an hour ago
    ```
    
    ```
    ## [1] "2021-08-21 12:36:42 UTC"
    ```

1. `.leap.seconds` 是内置的日期序列

    
    ```r
    .leap.seconds
    ```
    
    ```
    ##  [1] "1972-07-01 GMT" "1973-01-01 GMT" "1974-01-01 GMT" "1975-01-01 GMT"
    ##  [5] "1976-01-01 GMT" "1977-01-01 GMT" "1978-01-01 GMT" "1979-01-01 GMT"
    ##  [9] "1980-01-01 GMT" "1981-07-01 GMT" "1982-07-01 GMT" "1983-07-01 GMT"
    ## [13] "1985-07-01 GMT" "1988-01-01 GMT" "1990-01-01 GMT" "1991-01-01 GMT"
    ## [17] "1992-07-01 GMT" "1993-07-01 GMT" "1994-07-01 GMT" "1996-01-01 GMT"
    ## [21] "1997-07-01 GMT" "1999-01-01 GMT" "2006-01-01 GMT" "2009-01-01 GMT"
    ## [25] "2012-07-01 GMT" "2015-07-01 GMT" "2017-01-01 GMT"
    ```

    计算日期对应的星期`weekdays`，月 `months` 和季度 `quarters`
    
    
    ```r
    weekdays(.leap.seconds)
    ```
    
    ```
    ##  [1] "Saturday"  "Monday"    "Tuesday"   "Wednesday" "Thursday"  "Saturday" 
    ##  [7] "Sunday"    "Monday"    "Tuesday"   "Wednesday" "Thursday"  "Friday"   
    ## [13] "Monday"    "Friday"    "Monday"    "Tuesday"   "Wednesday" "Thursday" 
    ## [19] "Friday"    "Monday"    "Tuesday"   "Friday"    "Sunday"    "Thursday" 
    ## [25] "Sunday"    "Wednesday" "Sunday"
    ```
    
    ```r
    months(.leap.seconds)
    ```
    
    ```
    ##  [1] "July"    "January" "January" "January" "January" "January" "January"
    ##  [8] "January" "January" "July"    "July"    "July"    "July"    "January"
    ## [15] "January" "January" "July"    "July"    "July"    "January" "July"   
    ## [22] "January" "January" "January" "July"    "July"    "January"
    ```
    
    ```r
    quarters(.leap.seconds)
    ```
    
    ```
    ##  [1] "Q3" "Q1" "Q1" "Q1" "Q1" "Q1" "Q1" "Q1" "Q1" "Q3" "Q3" "Q3" "Q3" "Q1" "Q1"
    ## [16] "Q1" "Q3" "Q3" "Q3" "Q1" "Q3" "Q1" "Q1" "Q1" "Q3" "Q3" "Q1"
    ```

1. `Sys.setFileTime()` 使用系统调用 system call 设置文件或目录的时间

    
    ```r
    # 修改时间前
    file.info('./_common.R')
    ```
    
    ```
    ##             size isdir mode               mtime               ctime
    ## ./_common.R 1639 FALSE  644 2021-08-21 13:12:08 2021-08-21 13:12:08
    ##                           atime  uid gid  uname grname
    ## ./_common.R 2021-08-21 13:32:17 1001 121 runner docker
    ```
    
    ```r
    # 修改时间后，对比一下
    Sys.setFileTime(path = './_common.R', time = Sys.time())
    file.info('./_common.R')
    ```
    
    ```
    ##             size isdir mode               mtime               ctime
    ## ./_common.R 1639 FALSE  644 2021-08-21 13:36:42 2021-08-21 13:36:42
    ##                           atime  uid gid  uname grname
    ## ./_common.R 2021-08-21 13:36:42 1001 121 runner docker
    ```

1. `strptime` 用于字符串与 `POSIXlt`、 `POSIXct` 类对象之间的转化，`format` 默认 `tz = ""` 且 `usetz = TRUE` 

    
    ```r
    # 存放时区信息的数据库所在目录
    list.files(file.path(R.home("share"), "zoneinfo"))
    ```
    
    ```
    ## character(0)
    ```
    
    ```r
    # 比较不同的打印方式
    strptime(Sys.time(), format ="%Y-%m-%d %H:%M:%S", tz = "Asia/Taipei")
    ```
    
    ```
    ## [1] "2021-08-21 13:36:42 CST"
    ```
    
    ```r
    format(Sys.time(), format = "%Y-%m-%d %H:%M:%S") # 默认情形
    ```
    
    ```
    ## [1] "2021-08-21 13:36:42"
    ```
    
    ```r
    format(Sys.time(), format = "%Y-%m-%d %H:%M:%S", tz = "Asia/Taipei", usetz = TRUE)
    ```
    
    ```
    ## [1] "2021-08-21 21:36:42 CST"
    ```

1. 设置时区

    
    ```r
    Sys.timezone()
    ```
    
    ```
    ## [1] "UTC"
    ```
    
    ```r
    Sys.setenv(TZ = "Asia/Shanghai")
    Sys.timezone()
    ```
    
    ```
    ## [1] "Asia/Shanghai"
    ```
    
    全局修改，在文件 /opt/R/4.1.1/lib/R/etc/Rprofile.site 内添加`Sys.setenv(TZ="Asia/Shanghai")`。 局部修改，就是在本地R项目下，创建 `.Rprofile`，然后同样添加 `Sys.setenv(TZ="Asia/Shanghai")`。


## R 包管理 {#package}

相关的函数大致有


```r
apropos('package')
```

```
##  [1] ".packages"                      ".packageStartupMessage"        
##  [3] "$.package_version"              "as.package_version"            
##  [5] "aspell_package_C_files"         "aspell_package_R_files"        
##  [7] "aspell_package_Rd_files"        "aspell_package_vignettes"      
##  [9] "available.packages"             "download.packages"             
## [11] "find.package"                   "findPackageEnv"                
## [13] "format.packageInfo"             "getPackageName"                
## [15] "install.packages"               "installed.packages"            
## [17] "is.package_version"             "make.packages.html"            
## [19] "methodsPackageMetaName"         "new.packages"                  
....
```

1. `.packages(T)` 已安装的 R 包

    
    ```r
    .packages(T) %>% length()
    ```
    
    ```
    ## [1] 505
    ```
   
1. `available.packages` 查询可用的 R 包

    
    ```r
    available.packages()[,"Package"] %>% head()
    ```
    
    ```
    ##         A3      aaSEA   AATtools     ABACUS     abbyyR        abc 
    ##       "A3"    "aaSEA" "AATtools"   "ABACUS"   "abbyyR"      "abc"
    ```
    
    查询 repos 的 R 包
    
    
    ```r
    rforge <- available.packages(repos = "https://r-forge.r-project.org/")
    cran <- available.packages(repos = "https://mirrors.tuna.tsinghua.edu.cn/CRAN/")
    setdiff(rforge[, "Package"], cran[, "Package"])
    ```

1. `download.packages` 下载 R 包

    
    ```r
    download.packages("Rbooks", destdir = "~/", repos = "https://r-forge.r-project.org/")
    ```

1. `install.packages` 安装 R 包

    
    ```r
    install.packages("rmarkdown")
    ```

1. `installed.packages` 已安装的 R 包

    
    ```r
    installed.packages(fields = c("Package","Version")) %>% head()
    ```

1. `remove.packages` 卸载/删除/移除已安装的R包

    
    ```r
    remove.packages('rmarkdown')
    ```
 
1. `update.packages` 更新已安装的 R 包

    
    ```r
    update.packages(ask = FALSE)
    ```

1. `old.packages` 查看过时/可更新的 R 包

    
    ```r
    old.packages() %>% head()
    ```
    
    ```
    ##        Package  LibPath                           Installed Built   ReposVer
    ## brms   "brms"   "/home/runner/work/_temp/Library" "2.15.0"  "4.1.1" "2.16.0"
    ## cachem "cachem" "/home/runner/work/_temp/Library" "1.0.5"   "4.1.1" "1.0.6" 
    ## gert   "gert"   "/home/runner/work/_temp/Library" "1.3.1"   "4.1.1" "1.3.2" 
    ## httpuv "httpuv" "/home/runner/work/_temp/Library" "1.6.1"   "4.1.1" "1.6.2" 
    ## later  "later"  "/home/runner/work/_temp/Library" "1.2.0"   "4.1.1" "1.3.0" 
    ## magick "magick" "/home/runner/work/_temp/Library" "2.7.2"   "4.1.1" "2.7.3" 
    ##        Repository                               
    ## brms   "https://cloud.r-project.org/src/contrib"
    ## cachem "https://cloud.r-project.org/src/contrib"
    ## gert   "https://cloud.r-project.org/src/contrib"
    ## httpuv "https://cloud.r-project.org/src/contrib"
    ## later  "https://cloud.r-project.org/src/contrib"
    ## magick "https://cloud.r-project.org/src/contrib"
    ```

1. `new.packages` 还没有安装的 R 包 

    
    ```r
    new.packages() %>% head()
    ```
    
    ```
    ## [1] "A3"       "aaSEA"    "AATtools" "ABACUS"   "abbyyR"   "abc"
    ```

1. `packageStatus` 查看已安装的 R 包状态，可更新、可下载等

    
    ```r
    packageStatus()
    ```
    
    ```
    ## Number of installed packages:
    ##                                  
    ##                                    ok upgrade unavailable
    ##   /home/runner/work/_temp/Library 450      13          13
    ##   /opt/R/4.1.1/lib/R/library       28       1           0
    ## 
    ## Number of available packages (each package counted only once):
    ##                                          
    ##                                           installed not installed
    ##   https://cloud.r-project.org/src/contrib       478         17582
    ```
    
1. `packageDescription` 查询 R 包描述信息

    
    ```r
    packageDescription('graphics')
    ```
    
    ```
    ## Package: graphics
    ## Version: 4.1.1
    ## Priority: base
    ## Title: The R Graphics Package
    ## Author: R Core Team and contributors worldwide
    ## Maintainer: R Core Team <do-use-Contact-address@r-project.org>
    ....
    ```

1. 查询 R 包的依赖关系

    
    ```r
    # rmarkdown 依赖的 R 包
    tools::package_dependencies('rmarkdown', recursive = TRUE)
    ```
    
    ```
    ## $rmarkdown
    ##  [1] "tools"     "utils"     "knitr"     "yaml"      "htmltools" "evaluate" 
    ##  [7] "jsonlite"  "tinytex"   "xfun"      "methods"   "stringr"   "digest"   
    ## [13] "grDevices" "base64enc" "rlang"     "highr"     "markdown"  "glue"     
    ## [19] "magrittr"  "stringi"   "stats"     "mime"
    ```
    
    ```r
    # 依赖 rmarkdown 的 R 包
    tools::dependsOnPkgs('rmarkdown', recursive = TRUE)
    ```
    
    ```
    ##  [1] "bookdown"       "formattable"    "hrbrthemes"     "kableExtra"    
    ##  [5] "prettydoc"      "reprex"         "tint"           "packagemetrics"
    ##  [9] "tidyverse"      "projpred"       "brms"
    ```
    
    ggplot2 生态，仅列出以 gg 开头的 R 包
    
    
    ```r
    pdb <- available.packages()
    gg <- tools::dependsOnPkgs("ggplot2", recursive = FALSE, installed = pdb)
    grep("^gg", gg, value = TRUE)
    ```
    
    ```
    ##   [1] "gg.gap"            "ggallin"           "ggalluvial"       
    ##   [4] "ggalt"             "gganimate"         "ggasym"           
    ##   [7] "ggbeeswarm"        "ggborderline"      "ggbreak"          
    ##  [10] "ggBubbles"         "ggbuildr"          "ggbump"           
    ##  [13] "ggcharts"          "ggChernoff"        "ggcleveland"      
    ##  [16] "ggconf"            "ggcorrplot"        "ggdag"            
    ##  [19] "ggdark"            "ggDCA"             "ggdemetra"        
    ##  [22] "ggdendro"          "ggdist"            "ggdmc"            
    ##  [25] "ggeasy"            "ggedit"            "ggenealogy"       
    ##  [28] "ggetho"            "ggExtra"           "ggfan"            
    ##  [31] "ggfittext"         "ggfocus"           "ggforce"          
    ##  [34] "ggformula"         "ggfortify"         "ggfun"            
    ##  [37] "ggfx"              "gggap"             "gggenes"          
    ##  [40] "ggghost"           "gggibbous"         "ggguitar"         
    ##  [43] "ggh4x"             "gghalfnorm"        "gghalves"         
    ##  [46] "ggheatmap"         "gghighlight"       "gghilbertstrings" 
    ##  [49] "ggimage"           "ggimg"             "gginference"      
    ##  [52] "gginnards"         "ggip"              "ggiraph"          
    ##  [55] "ggiraphExtra"      "ggjoy"             "gglm"             
    ##  [58] "gglogo"            "ggloop"            "gglorenz"         
    ##  [61] "ggmap"             "ggmcmc"            "ggmosaic"         
    ##  [64] "ggmuller"          "ggmulti"           "ggnetwork"        
    ##  [67] "ggnewscale"        "ggnormalviolin"    "ggnuplot"         
    ##  [70] "ggpacman"          "ggpage"            "ggparallel"       
    ##  [73] "ggparliament"      "ggparty"           "ggperiodic"       
    ##  [76] "ggplot.multistats" "ggplotAssist"      "ggplotgui"        
    ##  [79] "ggplotify"         "ggplotlyExtra"     "ggpmisc"          
    ##  [82] "ggPMX"             "ggpointdensity"    "ggpol"            
    ##  [85] "ggpolypath"        "ggpp"              "ggprism"          
    ##  [88] "ggpubr"            "ggpval"            "ggQC"             
    ##  [91] "ggQQunif"          "ggquickeda"        "ggquiver"         
    ##  [94] "ggRandomForests"   "ggraph"            "ggraptR"          
    ##  [97] "ggrasp"            "ggrastr"           "ggrepel"          
    ## [100] "ggResidpanel"      "ggridges"          "ggrisk"           
    ## [103] "ggROC"             "ggsci"             "ggseas"           
    ## [106] "ggseqlogo"         "ggshadow"          "ggside"           
    ## [109] "ggsignif"          "ggsn"              "ggsoccer"         
    ## [112] "ggsolvencyii"      "ggsom"             "ggspatial"        
    ## [115] "ggspectra"         "ggstance"          "ggstar"           
    ## [118] "ggstatsplot"       "ggstream"          "ggstudent"        
    ## [121] "ggswissmaps"       "ggtern"            "ggtext"           
    ## [124] "ggThemeAssist"     "ggthemes"          "ggtikz"           
    ## [127] "ggupset"           "ggvenn"            "ggVennDiagram"    
    ## [130] "ggvoronoi"         "ggwordcloud"       "ggx"
    ```
    

1. 重装R包，与 R 版本号保持一致

    
    ```r
    db <- installed.packages()
    db <- as.data.frame(db, stringsAsFactors = FALSE)
    pkgs <- db[db$Built < getRversion(), "Package"]
    install.packages(pkgs)
    ```

## 查找函数 {#lookup-function}

[lookup](https://github.com/jimhester/lookup) R 函数完整定义，包括编译的代码，S3 和 S4 方法。目前 lookup 包处于开发版，我们可以用 `remotes::install_github` 函数来安装它


```r
# install.packages("remotes")
remotes::install_github("jimhester/lookup")
```

R-level 的源代码都可以直接看


```r
body
```

```
## function (fun = sys.function(sys.parent())) 
## {
##     if (is.character(fun)) 
##         fun <- get(fun, mode = "function", envir = parent.frame())
##     .Internal(body(fun))
## }
## <bytecode: 0x564aa0e2b000>
## <environment: namespace:base>
```

此外，`lookup` 可以定位到 C-level 的源代码，需要联网才能查看，lookup 基于 Winston Chang 在 Github 上维护的 [R 源码镜像](https://github.com/wch/r-source) 


```r
lookup(body)
```
```
base::body [closure] 
function (fun = sys.function(sys.parent())) 
{
    if (is.character(fun)) 
        fun <- get(fun, mode = "function", envir = parent.frame())
    .Internal(body(fun))
}
<bytecode: 0x00000000140d6158>
<environment: namespace:base>
// c source: src/main/builtin.c#L264-L277
SEXP attribute_hidden do_body(SEXP call, SEXP op, SEXP args, SEXP rho)
{
    checkArity(op, args);
    if (TYPEOF(CAR(args)) == CLOSXP) {
        SEXP b = BODY_EXPR(CAR(args));
        RAISE_NAMED(b, NAMED(CAR(args)));
        return b;
    } else {
        if(!(TYPEOF(CAR(args)) == BUILTINSXP ||
             TYPEOF(CAR(args)) == SPECIALSXP))
            warningcall(call, _("argument is not a function"));
        return R_NilValue;
    }
}
```

## 运行环境 {#files-session-info}


```r
sessionInfo()
```

```
## R version 4.1.1 (2021-08-10)
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
## [1] rmarkdown_2.10 fs_1.5.0       magrittr_2.0.1
## 
## loaded via a namespace (and not attached):
##  [1] compiler_4.1.1    bookdown_0.23     htmltools_0.5.1.1 tools_4.1.1      
##  [5] yaml_2.2.1        curl_4.3.2        stringi_1.7.3     knitr_1.33       
##  [9] stringr_1.4.0     digest_0.6.27     xfun_0.25         rlang_0.4.11     
## [13] evaluate_0.14
```

