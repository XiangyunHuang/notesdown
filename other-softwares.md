# 其它软件 {#chap-other-softwares}




> I think, therefore I R.
>
> --- William B. King [^William-King]

[^William-King]: https://ww2.coastal.edu/kingw/statistics/R-tutorials/


## 文本编辑器 {#sec-text-editor}

代码文件也是纯文本，RStudio 集成了编辑器，支持语法高亮。Windows 系统上优秀的代码编辑器有 Notepad++ 非常轻量。Markdown 文本编辑器我们推荐 Typora 编辑器，它是跨平台的，下面以 Ubuntu 环境为例，介绍安装和使用过程：

```bash
# or run:
# sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys BA300B7755AFCFAE
wget -qO - https://typora.io/linux/public-key.asc | sudo apt-key add -

# add Typora's repository
sudo add-apt-repository 'deb https://typora.io/linux ./'
sudo apt-get update

# install typora
sudo apt-get install typora
```

\begin{figure}

{\centering \subfloat[默认的主题(\#fig:typora-theme-1)]{\includegraphics[width=0.45\linewidth]{screenshots/typora-theme-default} }\subfloat[Vue 主题(\#fig:typora-theme-2)]{\includegraphics[width=0.45\linewidth]{screenshots/typora-theme-vue} }

}

\caption{Typora 主题}(\#fig:typora-theme)
\end{figure}

设置中文环境，并且将主题风格样式配置为 Vue，见图\@ref(fig:typora-theme)（右），Vue 主题可从 Typora 官网下载 <https://theme.typora.io/theme/Vue/>。

1. Atom 编辑器 <https://atom.io/>

  ```bash
  sudo add-apt-repository ppa:webupd8team/atom
  sudo apt-get update
  sudo apt-get install atom
  ```

1. Code 编辑器微软出品 <https://code.visualstudio.com/>

1. Notepad++ 开源的 Windows 平台上的编辑器 <https://notepad-plus-plus.org/>

1. VI & VIM 开源的跨平台编辑器

1. Atom 和 Code 有商业公司支持的开源免费的跨平台的编辑器

1. VI/VIM 和 Emacs 是跨平台的编辑器

1. Markdown 编辑器 + blogdown 记笔记

1. Typora Markdown 编辑器，支持自定义 CSS 样式


## 代码编辑器 {#sec-code-editor}

VS Code, Sublime Text 和 Atom

## 集成开发环境 {#sec-rstudio-ide}

[RStudio 公司的愿景](https://rstudio.com/slides/rstudio-pbc/)，介绍 RStudio 开发环境提供的效率提升工具或功能


### RStudio 桌面版 {#rstudio-desktop-ide}

\begin{figure}

{\centering \includegraphics[width=0.75\linewidth]{screenshots/rstudio-desktop} 

}

\caption{开源桌面版 RStudio 集成开发环境}(\#fig:rstudio-desktop)
\end{figure}


```bash
# mongolite
sudo dnf install -y  openssl-devel cyrus-sasl-devel
# sodium
sudo dnf install -y  libsodium-devel
# rJava
R CMD javareconf
```


```r
# https://github.com/s-u/rJava
# shinytest::installDependencies()
db <- rstudioapi::getRStudioPackageDependencies()

invisible(lapply(db$name, function(pkg) {
  if (system.file(package = pkg) == "") {
    install.packages(pkg)
  }
}))
```


[rsthemes](https://github.com/gadenbuie/rsthemes) 主题


### RStudio 服务器版 {#rstudio-server-ide}

RStudio Server 开源服务器版可以放在虚拟机里或者容器里，RStudio 桌面版装在服务器上，服务器为 Ubuntu/CentOS/Windows 系统，然后本地是 Windows 系统，可以通过远程桌面连接服务器，使用 RStudio；

\begin{figure}

{\centering \includegraphics[width=0.75\linewidth]{screenshots/rstudio-vbox} 

}

\caption{虚拟机里的 RStudio}(\#fig:vbox-rstudio)
\end{figure}

服务器上启动 Docker ，运行 RStudio 镜像，本地通过桌面浏览器，如谷歌浏览器登陆连接。

\begin{figure}

{\centering \includegraphics[width=0.75\linewidth]{screenshots/rstudio-docker} 

}

\caption{容器里的 RStudio}(\#fig:docker-rstudio)
\end{figure}

1. 下载 RStudio IDE
 
   我们从 RStudio 官网[下载][rstudio-download]开源桌面或服务器版本，服务器版本的使用介绍见[文档](https://docs.rstudio.com/ide/server-pro/)，最常见的就是设置端口

   ```bash
   wget https://download2.rstudio.org/rstudio-server-1.1.456-amd64.deb
   sudo apt-get install gdebi
   sudo gdebi rstudio-server-1.1.456-amd64.deb
   ```

1. 设置端口
   
   在文件 `/etc/rstudio/rserver.conf` 下，设置

   ```
   www-port=8181
   ```

   注意：修改 `rserver.conf` 文件后需要重启才会生效
   
   ```bash
   sudo rstudio-server stop
   sudo rstudio-server start
   ```

   接着获取机器的 IP 地址，如 192.168.141.3

   ```bash
   ip addr
   ```
   ```
   1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host
       valid_lft forever preferred_lft forever
   2: enp0s3: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
       link/ether 08:00:27:59:c0:fb brd ff:ff:ff:ff:ff:ff
       inet 10.0.2.15/24 brd 10.0.2.255 scope global dynamic enp0s3
          valid_lft 83652sec preferred_lft 83652sec
       inet6 fe80::a00:27ff:fe59:c0fb/64 scope link
          valid_lft forever preferred_lft forever
   3: enp0s8: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
       link/ether 08:00:27:09:33:0d brd ff:ff:ff:ff:ff:ff
       inet 192.168.141.3/24 brd 192.168.141.255 scope global dynamic enp0s8
          valid_lft 547sec preferred_lft 547sec
       inet6 fe80::a00:27ff:fe09:330d/64 scope link
          valid_lft forever preferred_lft forever
   ```

   然后，就可以从本地浏览器登陆 RStudio 服务器版本，如 <http://192.168.141.3:8181/>


[rstudio-download]: https://www.rstudio.com/products/rstudio/download/

::: {.rmdtip data-latex="{提示}"}
rstudio-server 已经收录在 Fedora 33+ 仓库中了，详情见 <https://cran.r-project.org/bin/linux/fedora/>
:::


授权问题 [ERROR system error 13 (Permission denied)](https://community.rstudio.com/t/rserver-1692-error-system-error-13-permission-denied/46972/10)
[How to Disable SELinux Temporarily or Permanently](https://www.tecmint.com/disable-selinux-in-centos-rhel-fedora/)



### Shiny 服务器版 {#shiny-server}

shiny 开源服务器版

### Eclipse + StatET {#eclipse-plus-statet}

Eclipse 配合 StatET 插件 <http://www.walware.de/goto/statet> 提供R语言的集成开发环境 <https://projects.eclipse.org/projects/science.statet>

\begin{figure}

{\centering \includegraphics[width=0.75\linewidth]{screenshots/eclipse-statet} 

}

\caption{基于 Eclipse 的 R 集成开发环境 StatET}(\#fig:eclipse-statet)
\end{figure}

StatET 基于 Eclipse 首次建立索引很慢，估计半小时到一个小时，添加新的 R 包后，每次启动 StatET 也会建立索引缓存，此外，Eclipse 开发环境占用内存比较多，配置 StatET 的过程如下


### Emacs + ESS {#emacs-plus-ess}

Emacs 配合 ESS 插件 <https://ess.r-project.org/>


### Nvim-R {#vim-plus-r}

Nvim-R 是一个基于 Vim 的集成开发环境 <https://github.com/jalvesaq/Nvim-R>


## Git 版本控制 {#sec-version-control}

Git 操作

MacOS 上用 Homebrew 安装 [git-delta](https://github.com/dandavison/delta)

```bash
brew install git-delta
```

[gitdown](https://github.com/Thinkr-open/gitdown)

只考虑 Ubuntu 18.04 环境下的三剑客 Git & Github & Gitlab


```r
summary(git2r::repository())
```

```
## Local:    devel /home/runner/work/masr/masr
## Remote:   devel @ origin (https://github.com/XiangyunHuang/masr)
## Head:     [1266732] 2021-10-05: fix ! Unable to load picture or PDF file 'figures/mai.png'.
## 
## Branches:         1
## Tags:             0
## Commits:          5
## Contributors:     1
## Stashes:          0
## Ignored files:   14
## Untracked files: 94
## Unstaged files:   0
## Staged files:     0
## 
## Latest commits:
## [1266732] 2021-10-05: fix ! Unable to load picture or PDF file 'figures/mai.png'.
## [f521da0] 2021-10-05: fix warnings
## [0fe63c5] 2021-10-05: dev fix
## [fe724c6] 2021-10-05: fix
## [0a5f787] 2021-10-05: add deps
```

仓库 [masr](https://github.com/XiangyunHuang/masr) 哪些人给我点赞加星了


```r
library(gh)
my_repos <- gh("GET /repos/:owner/:repo/stargazers", owner = "xiangyunhuang", repo = "masr", page = 1)
vapply(my_repos, "[[", "", "login")
```
```
 [1] "dddd1007"        "boltomli"        "JackieMium"      "AXGL"            "fyemath"        
 [6] "rogerclarkgc"    "swsoyee"         "joegaotao"       "YTLogos"         "Accelerator086" 
[11] "yimingfish"      "gaospecial"      "shenxiangzhuang" "shuaiwang88"     "LusiXie"        
[16] "llxlr"           "TingjieGuo"      "oiatz"           "XiaogangHe"      "xwydq"          
[21] "guohongwang1"    "yinandong"       "algony-tony"     "XiangyunHuang"   "perlatex"       
[26] "talegari"        "hao-shefer"      "zhouyisu"        "tsitong"         "liuyadong" 
```

\begin{figure}

{\centering \href{https://www.ardata.fr/img/hexbin/git.svg}{\includegraphics[width=0.23\linewidth]{images/git} }

}

\caption{Git 代码版本管理}(\#fig:git)
\end{figure}

[Jeroen Ooms](https://github.com/jeroen) 开发的 [gert](https://github.com/r-lib/gert) 包实现在 R 环境中操作 Git，我们可以从幻灯片 --- [Gert: A minimal git client for R](https://jeroen.github.io/gert2019) 学习重点内容。


```r
library(gert)
library(magrittr)
git_log(max = 10) %>% 
  subset(subset = grepl("Yihui Xie", x = author), select = c("author", "message"))
```

提供了 `git_rm()`、 `git_status()`、 `git_add()` 和 `git_commit()` 等函数，其中包含 `git_reset()` 高级的 Git 操作。此外， 还有 `git_branch_*()` 系列分支操作函数

### 安装配置 {#git-setup}

Ubuntu 16.04.5 默认安装的 Git 版本是 2.7.4，下面安装最新版本Git和配置自己的GitHub账户

1. 根据官网安装指导 <https://git-scm.com/download/linux>，在 Ubuntu 14.04.5 和 Ubuntu 16.04.5 安装最新版 GIT 

   ```bash
   sudo add-apt-repository -y ppa:git-core/ppa
   sudo apt update && sudo apt install git
   ```

1. 配置账户

   ```bash
   git config --global user.name "你的名字"
   git config --global user.email "你的邮件地址"
   touch .git-credentials
   # 记住密码
   echo "https://username:password@github.com" >> .git-credentials
   git config --global credential.helper store
   ```


<!-- Git 使用的数据库 -->

以 Fedora 为例 [安装 tig](https://github.com/jonas/tig/blob/master/INSTALL.adoc)，首先安装必要的依赖，然后从官网下载源码，编译安装，之后切到任意本地 Git 仓库下，输入 `tig` 就可以看到如图 \@ref(fig:tig) 所示的样子了

```bash
sudo yum install readline-devel ncurses-devel asciidoc docbook-utils xmlto
```

tig 主要用于查看 git 提交的历史日志

\begin{figure}

{\centering \includegraphics[width=0.55\linewidth]{screenshots/git-tig} 

}

\caption{Git 日志查看器}(\#fig:tig)
\end{figure}

### 追踪文件 {#git-add}


```bash
git add .
```

提交新文件(new)和被修改(modified)文件，不包括被删除(deleted)文件

```bash
git add -u
```

提交被修改(modified)和被删除(deleted)文件，不包括新文件(new)，`git add --update`的缩写

```bash
git add -A
```

提交所有变化，`git add --all` 的缩写

```bash
git init
git remote add origin https://github.com/XiangyunHuang/masr.git
git add -A
git commit -m "添加提交说明"
git push -u origin master
```

往远程的空的 Github 仓库添加本地文件

### 合并上流 {#git-upstream}

```bash
git clone --depth=5 https://github.com/XiangyunHuang/cosx.org.git
git submodule update --init --recursive
```

查看远程分支

```bash
cd cosx.org
git remote -v
```
```
origin  https://github.com/XiangyunHuang/cosx.org.git (fetch)
origin  https://github.com/XiangyunHuang/cosx.org.git (push)
```

```bash
# 添加上流分支
git remote add upstream https://github.com/cosname/cosx.org.git
# 查看远程分支
git remote -v
```
```
origin  https://github.com/XiangyunHuang/cosx.org.git (fetch)
origin  https://github.com/XiangyunHuang/cosx.org.git (push)
upstream        https://github.com/cosname/cosx.org.git (fetch)
upstream        https://github.com/cosname/cosx.org.git (push)
```

```bash
# 获取上流 commit 并且合并到我的 master 分支
git fetch upstream
git merge upstream/master master
git push origin master
```

### 大文件支持 {#git-lfs}

```bash
sudo apt install git-lfs
git lfs install
git lfs track "*.psd"
git add .gitattributes
git commit -m "track *.psd files using Git LFS"
git push origin master
```

这玩意迟早需要你购买存储空间，慎用

### 新建分支 {#git-checkout}


```bash
git checkout -b stan     # 新建 stan 分支
git branch -v            # 查看本地分支 stan 前有个星号标记
git pull --rebase git@github.com:XiangyunHuang/cosx.org.git master
# 同步到远程分支 stan
git push --set-upstream origin stan
git push origin master:stan

git add .
git commit -m "balabala"
git push --set-upstream origin stan
```

本地新建仓库推送至远程分支

```bash
git remote add origin https://github.com/XiangyunHuang/notesdown.git
git add .
git commit -m "init cos-art"
# 此时远程仓库 notesdown 还没有 cos-art 分支
git push origin master:cos-art
```

位于 [Github](https://github.com/liuhui998/gitbook) [Git Community Book 中译本](http://gitbook.liuhui998.com/)


### 创建 Github Pages 站点 {#git-github-pages}

基于 GitHub Pages 创建站点用于存放图片和数据

1. 在Github上创建一个空的仓库，命名为 uploads，没有 readme.md 和 LICENSE
2. 在本地创建目录 uploads 
3. 切换到 uploads 目录下

```bash
git init 
git checkout -b gh-pages
git remote add origin https://github.com/XiangyunHuang/uploads.git
```

添加图片或者数据，并且 git add 和 commit 后

```bash
git push --set-upstream origin gh-pages
```

这样仓库 uploads 只包含 gh-pages 分支，数据地址即为以日期为分割线

<https://xiangyunhuang.github.io/uploads/data/eqList2018_05_18.xls>


### 博客主题 {#blog-hugo-theme}

初始化博客网站

```bash
git subtree add --squash --prefix=themes/hugo-lithium \
  git@github.com:yihui/hugo-lithium.git master
```

在 Github 创建新的空仓库，本地创建空的目录 xiangyun

```bash
cd xiangyun
git init
git remote add origin https://github.com/XiangyunHuang/xiangyun.git

git add .gitignore
git commit -m 'upload' 
git push --set-upstream origin master
```

`git subtree` 将另外一个仓库收缩为当前仓库的一个目录，且只产生一条提交记录

```bash
# 子库分支
git subtree add --squash --prefix=themes/hugo-xmag \
  -m "add hugo-xmag" git@github.com:yihui/hugo-xmag.git master 
# 或者子库分支
git subtree add --squash --prefix=themes/hugo-xmag \
  -m "add hugo-xmag" https://github.com/yihui/hugo-xmag.git master 

# 移除 git subtree 添加的 hugo 主题
git filter-branch --index-filter 'git rm --cached --ignore-unmatch -rf themes/hugo-xmag' --prune-empty -f HEAD
```


### 修改远程仓库的位置 {#transform-repo}

有时候我们将自己的仓库转移给别人/组织，或者我们将远程仓库的名字改变了，这时候需要修改远程仓库的位置。比如最近我将博客仓库从 <https://github.com/XiangyunHuang/xiangyun> 转移到 <https://github.com/rbind/xiangyun>

> 转移前

```bash
git remote -v
```
```
origin  https://github.com/XiangyunHuang/xiangyun.git (fetch)
origin  https://github.com/XiangyunHuang/xiangyun.git (push)
```

转移命令

```bash
git remote set-url origin https://github.com/rbind/xiangyun.git
```

> 转移后

```bash
git remote -v
```
```
origin  https://github.com/rbind/xiangyun.git (fetch)
origin  https://github.com/rbind/xiangyun.git (push)
```

### 统计代码仓库的提交量 {#count-commits}


比如统计之都的主站仓库，提交量最大的20个人

```bash
git shortlog -sn | head -n 20
```
```
  153	Dawei Lang
  106	Yihui Xie
  89	Beilei Bian
  46	王佳
  42	雷博文
  39	Ryan Feng Lin
  35	Xiangyun Huang
  32	fanchao
  32	闫晗
  30	Lin Feng
  28	Jiaao Yu
  25	fyears
  24	Yixuan Qiu
  24	Miao YU
  22	Yuxuan Li
  22	qinwf
  20	Alice敏
  19	yanshi
  18	Shuyi.Yang
  13	黄湘云
```


### 账户共存 {#multi-accounts}

> 本节介绍如何使 Gitlab/Github 账户共存在一台机器上

如何生成 SSH 密钥见 Github 文档 ---  [使用 SSH 连接到 GitHub](https://help.github.com/cn/github/authenticating-to-github/connecting-to-github-with-ssh)。有了密钥之后只需在目录 `~/.ssh` 下创建一个配置文件 config

生成 SSH Key

```bash
ssh-keygen -t rsa -f ~/.ssh/id_rsa_github -C "name1@xxx1.com"
ssh-keygen -t rsa -f ~/.ssh/id_rsa_gitlab -C "name2@xxx2.com"
```

将 GitHub/GitLab 公钥分别上传至服务器，然后创建配置文件

```bash
touch ~/.ssh/config
```

配置文件内容如下

```
#
# Github
#
Host github.com // 个人的代码仓库服务器地址
HostName github.com
User XiangyunHuang
IdentityFile ~/.ssh/id_rsa_github

#
# company
#
Host xx.xx.xx.xx //
IdentityFile ~/.ssh/id_rsa_gitlab
```

配置成功，你会看到

```bash
ssh -T git@xx.xx.xx.xx
```
```
Welcome to GitLab, xiangyunhuang!
```

和

```bash
ssh -T git@github.com
```
```
Hi XiangyunHuang! You've successfully authenticated, but GitHub does not provide shell access.
```

### 回车换行 {#git-crlf}

CR (Carriage Return) 表示回车，LF (Line Feed) 表示换行，Windows 下用回车加换行表示下一行，UNIX/Linux 采用换行符 (LF) 表示下一行，MAC OS 则采用回车符 (CR) 表示下一行

```bash
git config --global core.autocrlf false
```

### 子模块 {#git-submodule}

- 添加子模块到目录 `templates/` 下

```bash
git submodule add git://github.com/jgm/pandoc-templates.git templates
```

- 移除子模块

<https://stackoverflow.com/questions/1260748/how-do-i-remove-a-submodule/>


### 克隆项目 {#git-clone}

```bash
git clone --depth=10 --branch=master --recursive \
    git@github.com:XiangyunHuang/pandoc4everything.git
```



### 创建 PR {#git-create-pr}

```bash
git pull --rebase git@github.com:yihui/xaringan.git master
# then force push to your master branch
```

参考 <https://github.com/yihui/xaringan/pull/107>

> I don't recommend you to use your master branch for pull requests, because all commits will be squashed before merging, e.g. c2c2055 Then you will have some trouble with syncing your master branch with the master branch here (your choices are (1) delete your repo and fork again; or (2) force push; either option is not good). For pull requests, I recommend that you always use different branches for different pull requests.

### 修改 PR {#git-edit-pr}

> 之前一直有一个思想在阻止自己，就是别人的 repo 我是不能修改的，但是在这里，我拥有修改原始仓的权限，那么别人的复制品衍生的分支，我也有修改权限

```bash
git fetch origin refs/pull/771/head:patch-2
# 771 是 PR 对应的编号
git checkout patch-2

# 你的修改

git add -u
git commit -m "描述你的修改"

git remote add LalZzy https://github.com/LalZzy/cosx.org.git

git push --set-upstream LalZzy patch-2
```

> 整理自统计之都论坛的讨论 https://d.cosx.org/d/420363


1. GitHub/Git 小抄英文版 <https://www.runoob.com/manual/github-git-cheat-sheet.pdf>
1. GitHub/Git 小抄中文版 <https://github.github.com/training-kit/downloads/zh_CN/github-git-cheat-sheet/>
1. Github 秘籍 <https://github.com/tiimgreen/github-cheat-sheet/blob/master/README.zh-cn.md>
1. Git 简明指南 <https://rogerdudler.github.io/git-guide/index.zh.html>
1. Git 奇技淫巧 <https://github.com/521xueweihan/git-tips>
1. Git 官方书籍 <https://git-scm.com/book/zh/v2>
1. Git 时代的 VIM 不完全使用教程 <http://beiyuu.com/git-vim-tutorial>
1. 最佳搭档：利用 SSH 及其配置文件节省你的生命 <https://liam.page/2017/09/12/rescue-your-life-with-SSH-config-file/> 


## Pandoc 文档处理 {#sec-pandoc}

Pandoc 是一个万能文档转化器，安装 pandoc，下载网址 <https://github.com/jgm/pandoc/releases/latest>

```bash
sudo apt-get install gdebi-core
wget https://github.com/jgm/pandoc/releases/download/2.9.2/pandoc-2.9.2-1-amd64.deb
sudo chmod +x pandoc-2.9.2-1-amd64.deb
sudo gdebi pandoc-2.9.2-1-amd64.deb
```

rmarkdown 包裹了 Pandoc 工具，使用 `rmarkdown::render()` 函数即可将 R Markdown 文档转化为 HTML、LaTeX 和 Markdown 等格式。

## Calibre 书籍管理 {#sec-calibre}

[Calibre](https://calibre-ebook.com) 是一款电子书转化和管理软件，首先安装 calibre

```bash
sudo -v && wget -nv -O- https://download.calibre-ebook.com/linux-installer.sh | sudo sh /dev/stdin
```

calibre 可以将 epub 格式电子书文档转化为 mobi 格式，bookdown 已经给这个工具穿上了一件马甲，用户只需调用 `bookdown::calibre()` 函数即可实现电子书格式的转换。


## ImageMagick 图像处理 {#sec-ImageMagick}

图像的各种操作，包括合成、转换、旋转等等


首先安装 ImageMagick 软件包中的 convert 程序

```bash
asy -f jpg test.asy
```

指定分辨率

```bash
convert -geometry 1000x3000 -density 300 -units PixelsPerInch example.eps example.png
```

这样不改变图像的像素数，只是给出一个每个像素应该显示多大的提示。

```bash
convert -quality 100 -density 300x300 filename.pdf filename.png
```

高质量大图，给定像素，转化 eps 格式图片，需要先安装 Ghostscript

```bash
convert -geometry 1000x3000 example.eps example.png
```

多页的 PDF 文件转化为多张 PNG 图片

```bash
convert -quality 100 -density 300x300  input.pdf output.png
```

将多页 PDF 文件合成为 GIF 动图

```bash
convert -delay 60 -density 300x300 -background white -alpha remove \
  -dispose previous pdf-mobile.pdf -layers coalesce pdf-mobile.gif
```



## OptiPNG 图片优化 {#sec-optipng}

[OptiPNG](http://optipng.sourceforge.net/) 是一个非常好的图片压缩、优化工具

现在，我们设置 chunk 选项 `optipng` 为非空(non-`NULL`)的值，例如，`''` 去激活这个 hook （益辉称之为钩子，这里勾的是 optipng 这个图片优化工具）


```r
knitr::knit_hooks$set(optipng = knitr::hook_optipng)
```


```r
library(ggplot2)
ggplot(data = iris, aes(x = Sepal.Length, y = Sepal.Width)) +
  geom_point()
```

\begin{figure}

{\centering \includegraphics{other-softwares_files/figure-latex/optipng-1} 

}

\caption{没有优化}(\#fig:optipng)
\end{figure}



```r
library(ggplot2)
ggplot(data = iris, aes(x = Sepal.Length, y = Sepal.Width)) +
  geom_point()
```

\begin{figure}

{\centering \includegraphics{other-softwares_files/figure-latex/optimize-png-1} 

}

\caption{优化}(\#fig:optimize-png)
\end{figure}

```bash
optipng -o5 filename.png
```


## PDFCrop 裁剪边空 {#sec-pdfcrop}

[PDFCrop](http://pdfcrop.sourceforge.net/) 可将 PDF 图片中留白的部分裁去，再也不用纠结 par 了


## PhantomJS 网页截图 {#sec-phantomjs}

Winston Chang 开发了 [webshot](https://github.com/wch/webshot) 包网页截图，它依赖 [PhantomJS](https://github.com/ariya/phantomjs/)，所以首先需要安装


```r
install.packages("webshot")
webshot::install_phantomjs()
```

以截取网页 <https://www.r-project.org/> 为例，


```r
library(webshot)
webshot("https://www.r-project.org/", "r.png")
webshot("https://www.r-project.org/", "r.pdf") # Can also output to PDF
```

还可以截取 R Markdown 文档内容，注意是先编译 R Markdown 文档为 HTML 文档，然后截取网页


```r
rmdshot(system.file("examples/knitr-minimal.Rmd", package = "knitr"), file = "screenshots/knitr-minimal.png")
```

裁剪出特定大小的图片，需要额外的系统依赖 GraphicsMagick (recommended) or ImageMagick installed


```r
# Can specify pixel dimensions for resize()
webshot("https://www.r-project.org/", "r-small.png") %>%
  resize("400x") %>%
  shrink()
```
```
** Processing: r-small.png
400x442 pixels, 4x8 bits/pixel, RGB+alpha
Reducing image to 3x8 bits/pixel, RGB
Input IDAT size = 70570 bytes
Input file size = 70867 bytes

Trying:
  zc = 9  zm = 8  zs = 0  f = 0         IDAT size = 59441
  zc = 9  zm = 8  zs = 1  f = 0
  zc = 1  zm = 8  zs = 2  f = 0
  zc = 9  zm = 8  zs = 3  f = 0
  zc = 9  zm = 8  zs = 0  f = 5
  zc = 9  zm = 8  zs = 1  f = 5
  zc = 1  zm = 8  zs = 2  f = 5
  zc = 9  zm = 8  zs = 3  f = 5
                               
Selecting parameters:
  zc = 9  zm = 8  zs = 0  f = 0         IDAT size = 59441

Output IDAT size = 59441 bytes (11129 bytes decrease)
Output file size = 59714 bytes (11153 bytes = 15.74% decrease)
```

## Inkscape 矢量绘图 {#sec-inkscape}

[Inkscape](https://inkscape.org/) 是一款开源、免费、跨平台的矢量绘图软件。是替代 Adobe Illustrator（简称 AI） 最佳工具，没有之一

```bash
# Ubuntu 20.04 及之前版本
sudo add-apt-repository ppa:inkscape.dev/stable
sudo apt update
sudo apt install inkscape
```


PDF 图片格式转化为 SVG 格式

```bash
inkscape -l output-filename.svg input-filename.pdf
```

SVG 转 PDF 格式

```bash
inkscape -f input-filename.svg -A output-filename.pdf
```

Jeroen Ooms 开发的 [rsvg](https://github.com/jeroen/rsvg) 包支持将 SVG 格式图片导出为 PNG、PDF、PS 等格式。使用它可以批量将 SVG 格式文件转化为其它格式文件，比如 PDF（`rsvg::rsvg_pdf`），PS （`rsvg::rsvg_ps`）和 PNG（`rsvg::rsvg_png`）


```r
svg_paths = list.files(path = "images", pattern = "*.svg", full.names = T)
for (svg in svg_paths) {
  rsvg::rsvg_pdf(svg, file = gsub(pattern  = "\\.svg", replacement=  "\\.pdf", svg))
}
```


## QPDF PDF 文件操作 {#sec-qpdf}

Jeroen Ooms 开发的另一个 [qpdf](https://github.com/ropensci/qpdf) 包将 C++ 库 [qpdf](https://github.com/qpdf/qpdf) 搬运到 R 环境中，用于 PDF 文件的拆分 `pdf_split()`，组合 `pdf_combine()`，加密（ 传递 `password` 参数值即可加密），提取 `pdf_subset()` 和压缩 `pdf_compress()` 等。下面以组合为例，就是将多个 PDF 文件合成一个 PDF 文件。


```r
library(qpdf)
pdf_paths = list.files(path = "images", pattern = "*.pdf", full.names = T)
pdf_combine(input = pdf_paths, output = "images/all.pdf", password = "")
```

PDF 操作：价值数百美元的开源替代方案，参考 Adobe Acrobat 的功能

## UML 标准建模图 {#sec-nomnoml}

UML (Unified Modeling Language) 表示统一建模语言

\begin{figure}

{\centering \includegraphics{other-softwares_files/figure-latex/convert-figure-1} 

}

\caption{图片制作、合成、优化、转换等常用工具}(\#fig:convert-figure)
\end{figure}


[Javier Luraschi](https://github.com/javierluraschi) 将 UML 绘图库 [nomnoml](https://github.com/skanaar/nomnoml) 引入 R 社区，开发了 [nomnoml](https://github.com/rstudio/nomnoml) 包，相比于 DiagrammeR 包，它显得非常轻量，网站 <https://www.nomnoml.com/> 还可以在线编辑、预览、下载 UML 图。 **webshot** 包可以将网页截图并插入 PDF 文档中。其它制作图形的工具见 \@ref(fig:convert-figure)。

nomnoml 调 webshot 包对网页截图生成 PNG 格式的图片，其中 webshot 调 phantomjs 软件。
nomnoml 制作 R Markdown 生态图，导出为 PNG 格式

安装 nomnoml 

```r
install.packages("nomnoml")
```

安装 PhantomJS

```bash
brew install --cask phantomjs 
```


```r
nomnoml::nomnoml(" 
#stroke: #26A63A
#.box: dashed visual=ellipse
#direction: down

[<box>HTML]       -> [网页三剑客]
[<box>JavaScript] -> [网页三剑客]
[<box>CSS]        -> [<table>网页三剑客|htmlwidgets|htmltools||sass|bslib||thematic|jquerylib]

[设计布局|bs4Dash|flexdashboard|shinydashboard] -> [<actor>开发应用|R Shiny]
[设计交互|waiter|shinyFeedback|shinyToastify] -> [<actor>开发应用|R Shiny]
[权限代理|shinyproxy|shinyauthr|shinymanager] -> [<actor>开发应用|R Shiny]

[网页三剑客]  -> [<actor>开发应用|R Shiny]
[网页三剑客]  -> [<actor>开发应用|R Shiny]
[网页三剑客]  -> [<actor>开发应用|R Shiny]

[开发应用] <- [<table>处理数据|Base R|SQL||data.table|dplyr||tidyr|purrr]
[开发应用] <- [<table>制作表格|DT|gt||reactable|formattable||kableExtra|sparkline]
[开发应用] <- [<table>制作图形|ggplot2|plotly||echarts4r|leaflet||dygraphs|visNetwork]
", png = "shiny-app.png")
```


## Graphviz 流程图 {#sec-graphviz}

Graphviz 官网 <http://www.graphviz.org/>，常用于绘制流程图，广泛用于 tensorflow 和 mxnet 的模型描述中

\begin{figure}

{\centering \includegraphics{other-softwares_files/figure-latex/data-workflow-1} 

}

\caption{数据分析流程图}(\#fig:data-workflow)
\end{figure}

[**DiagrammeR**](https://github.com/rich-iannone/DiagrammeR) 包将 Graphviz 引入 R 语言


```r
library(DiagrammeR)
library(DiagrammeRsvg)
library(magrittr)
library(rsvg)

graph <-
  "graph {
        rankdir=LR; // Left to Right, instead of Top to Bottom
        a -- { b c d };
        b -- { c e };
        c -- { e f };
        d -- { f g };
        e -- h;
        f -- { h i j g };
        g -- k;
        h -- { o l };
        i -- { l m j };
        j -- { m n k };
        k -- { n r };
        l -- { o m };
        m -- { o p n };
        n -- { q r };
        o -- { s p };
        p -- { s t q };
        q -- { t r };
        r -- t;
        s -- z;
        t -- z;
    }
"
# 导出图形
grViz(graph) %>%
  export_svg %>% charToRaw %>% rsvg_pdf("graph.pdf")
grViz(graph) %>%
  export_svg %>% charToRaw %>% rsvg_png("graph.png")
grViz(graph) %>%
  export_svg %>% charToRaw %>% rsvg_svg("graph.svg")
```


## LaTeX 排版工具 {#sec-latex}

另外值得一提的是 TikZ 和 PGF（Portable Graphic Format）宏包，支持强大的绘图功能，图形质量达到出版级别，详细的使用说明见宏包手册 <https://pgf-tikz.github.io/pgf/pgfmanual.pdf>。

### TinyTeX 发行版 {#sub:latex-tinytex}


```r
library(tinytex)
# 升级 TinyTeX 发行版
upgrade_tinytex <- function(repos = NULL) {
  # 此处还要考虑用户输错的情况和选择离用户最近（快）的站点
  if(is.null(repos)) repos = "https://mirrors.tuna.tsinghua.edu.cn/CTAN/"
  
  file_ext <- if (.Platform$OS.type == "windows") ".exe" else ".sh"
  tlmgr_url <- paste(repos, "/systems/texlive/tlnet/update-tlmgr-latest", file_ext, sep = "")
  file_name <- paste0("update-tlmgr-latest", file_ext)
  download.file(url = tlmgr_url, destfile = file_name, 
                mode = if (.Platform$OS.type == "windows") "wb" else "w")
  
  # window下 命令行窗口下 如何执行 exe 文件
  if(.Platform$OS.type == "windows"){
    shell.exec(file = file_name)
    file.remove("update-tlmgr-latest.exe")
  }
  else{
    system("sudo sh update-tlmgr-latest.sh  -- --upgrade")
    
    file.remove("update-tlmgr-latest.sh")
  }
  
  # 类似地 Linux 下执行 sh
  # 升级完了 删除 update-tlmgr-latest.exe
}
```

[Winston Chang](https://github.com/wch) 整理了一份 LaTeX 常用命令速查小抄 <https://wch.github.io/latexsheet/latexsheet.pdf>



### 安装和更新 {#subsec-tlmgr-setup}

tlmgr (TeXLive Manager) 是 LaTeX 包管理器

```bash
# 就近选择 CTAN 镜像站点
tlmgr option repository https://mirrors.tuna.tsinghua.edu.cn/CTAN/systems/texlive/tlnet
tlmgr option repository http://mirror.ctan.org/systems/texlive/tlnet
# 可更新的 TeX 包列表
tlmgr update --list
# 更新所有已经安装的 TeX 包
tlmgr update --all
# 更新 tlmgr 管理器本身
tlmgr update --self
# 安装
tlmgr install ctex fandol
# 列出套装
tlmgr list schemes
tlmgr list collections
# 列出已经安装的 TeX 包
tlmgr list --only-installed
# 安装 GPG 公钥（只限Win/Mac）
tlmgr --repository http://www.preining.info/tlgpg/ install tlgpg
```

### 查询和搜索 {#subsec-tlmgr-search}

```bash
tlmgr search *what*
```

参数 `\*what\*` 是正则表达式


```bash
tlmgr search --file tikz.sty
```

```
## langsci:
## 	texmf-dist/tex/xelatex/langsci/langsci-tikz.sty
## pgf:
## 	texmf-dist/tex/latex/pgf/frontendlayer/tikz.sty
```

等价于


```r
tinytex::tlmgr_search('tikz.sty')
```

这样，我们就可以知道要使用 `\usepackage{tikz}` 就得先安装 **pgf** 包，此外，管道命令也是支持的

```bash
tlmgr search --file font | grep math
```

查询 CTAN 仓库列表

```bash
tlmgr repository list
```


一般地， 只显示已安装的 LaTeX 宏包的名字及大小

```bash
tlmgr info --list --only-installed --data name,size
```


更多命令详见[tlmgr 管理器手册](https://www.tug.org/texlive/doc/tlmgr.html#install-option-...-pkg)


### TikZ 绘图工具 {#subsec-latex-tikz}

TikZ 绘制书籍封面 <https://latexdraw.com/how-to-create-a-beautiful-cover-page-in-latex-using-tikz/>

TikZ 绘制知识清单，书籍章节结构等 <https://www.latexstudio.net/index/lists/barsearch/author/1680.html>

更多例子参考 <https://github.com/FriendlyUser/LatexDiagrams>


## Octave 科学计算 {#sec-octave}


```octave
%% fig1
tx = ty = linspace (-8, 8, 41)';
[xx, yy] = meshgrid (tx, ty);
r = sqrt (xx .^ 2 + yy .^ 2) + eps;
tz = sin (r) ./ r;
mesh (tx, ty, tz);
xlabel ("tx");
ylabel ("ty");
zlabel ("tz");
title ("3-D Sombrero plot");


% fig2
x = 0:0.01:3;
hf = figure ();
plot (x, erf (x));
hold on;
plot (x, x, "r");
axis ([0, 3, 0, 1]);
text (0.65, 0.6175, ['$\displaystyle\leftarrow x = {2\over\sqrt{\pi}}'...
                     '\int_{0}^{x}e^{-t^2} dt = 0.6175$']);
xlabel ("x");
ylabel ("erf (x)");
title ("erf (x) with text annotation");
set (hf, "visible", "off");
print (hf, "plot15_7.pdf", "-dpdflatexstandalone");
set (hf, "visible", "on");
system ("pdflatex plot15_7");
open ("plot15_7.pdf");

%% fig3

clf ();
surf (peaks);
peaks(50)
print -dpswrite -PPS_printer

%% images/peaks-inc
hf = figure (1);
surf (peaks);
print (hf, "peaks.pdf", "-dpdflatexstandalone");

%% windows
hf = figure (1);
peaks(10);
print (hf, "peaks.pdf", "-dpdf");
print (hf, "peaks.eps", "-color"," -deps");

print (hf, "peaks.svg", "-color"," -dsvg");


%% windows
hf = figure (1);
peaks(50);
print (hf, "peaks-more.eps", "-color"," -deps");

print (hf, "peaks-more.svg", "-color"," -dsvg");
```

## Python 环境配置 {#sec-setup-python}

首先创建一个 Python 虚拟环境，环境隔离可以减少对系统的侵入，方便迭代更新和项目管理。创建一个虚拟环境，步骤非常简单，下面以 CentOS 8 为例：

1. 安装虚拟模块 virtualenv

   ```bash
   sudo dnf install -y virtualenv
   ```

1. 准备 Python 虚拟环境存放位置

   ```bash
   sudo mkdir -p /opt/.virtualenvs/r-tensorflow
   ```

1. 给虚拟环境必要的访问权限

   ```bash
   sudo chown -R $(whoami):$(whoami) /opt/.virtualenvs/r-tensorflow
   ```

1. 初始化虚拟环境

   ```bash
   virtualenv -p /usr/bin/python3 /opt/.virtualenvs/r-tensorflow
   ```

1. 激活虚拟环境，安装必要的模块

   ```bash
   source /opt/.virtualenvs/r-tensorflow/bin/activate
   pip install numpy
   ```
   

一般来讲，系统自带的 pip 版本较低，可以考虑升级 pip 版本。

```bash
pip install -i https://pypi.tuna.tsinghua.edu.cn/simple pip -U
```

根据项目配置文件 requirements.txt 安装多个 Python 模块，每个 Python 项目都应该有这么个文件来描述项目需要的依赖环境，包含 Python 模块及其版本号。

```bash
pip install -i https://pypi.tuna.tsinghua.edu.cn/simple -r requirements.txt
```

指定 Python 模块的镜像地址，加快下载速度，特别是对于国内的环境，加速镜像站点非常有意义，特别是遇到大型的 Python 模块，比如 tensorflow 框架

```bash
pip install -i https://pypi.tuna.tsinghua.edu.cn/simple tensorflow
```

conda 创建 Python 3.8 虚拟环境，并命名为 tensorflow

```bash
conda create -n tensorflow python=3.8
```

激活 tensorflow 环境

```bash
conda activate tensorflow
```

## Python 基础绘图 {#sec-plot-python}

Python 的 matplotlib 模块支持保存的图片格式有 eps, pdf, pgf, png, ps, raw, rgba, svg, svgz，不支持 cairo\_pdf 绘图设备，所以这里使用 pdf 设备，但是这样会导致图形没有字体嵌入，从而不符合出版要求。一个解决办法是在后期嵌入字体，图形默认使用数学字体 [STIX](http://www.stixfonts.org/) 和英文字体 [DejaVu Sans](https://dejavu-fonts.github.io/)，所以需要预先安装这些字体。

```bash
# CentOS 8
sudo dnf install -y dejavu-fonts-common dejavu-sans-fonts \
  dejavu-serif-fonts dejavu-sans-mono-fonts
```

借助 **grDevices** 包提供的 `embedFonts()` 函数，它支持 postscript 和 pdf 图形设备，嵌入字体借助了 [Ghostscript](https://www.ghostscript.com/) 以及 PDF 阅读器 [MuPDF](https://www.mupdf.com/)

::: {.rmdnote data-latex="{注意}"}
Windows 系统下需要手动指定 Ghostscript 安装路径，特别地，如果你想增加可选字体范围，需要指定相应字体搜索路径，而 Linux/MacOS 平台下不需要关心 Ghostscript 的安装路径问题，


```r
Sys.setenv(R_GSCMD = "C:/Program Files/gs/gs9.26/bin/gswin64c.exe")
embedFonts(
  file = "cm.pdf", outfile = "cm-embed.pdf",
  fontpaths = system.file("fonts", package = "fontcm")
)
embedFonts(file = "cm.pdf", outfile = "cm-embed.pdf") 
```
:::

另一个解决办法是使用 LaTeX 渲染图片中的文字，这就需要额外安装一些 LaTeX 宏包，此时默认执行渲染的 LaTeX 引擎是 PDFLaTeX。

```bash
tlmgr install type1cm cm-super dvipng psnfss ucs ncntrsbk helvetic
```

每年 4 月是 TeX Live 的升级月，升级指导见 <https://www.tug.org/texlive/upgrade.html>，升级之后，需要更新所有 LaTeX 宏包。

```bash
tlmgr update --self --all
```

如图 \@ref(fig:matplotlib) 所示，我们采用第二个方法，它可以支持更好的数学公式显示，更多详情见 <https://matplotlib.org/tutorials/text/mathtext.html>。

\begin{figure}

{\centering \includegraphics[width=0.75\linewidth]{other-softwares_files/figure-latex/matplotlib-1} 

}

\caption{matplotlib 示例}(\#fig:matplotlib)
\end{figure}

::: {.rmdtip data-latex="{提示}"}
如果你的系统是 Windows/MacOS 可以添加 GPG 验证以增加安全性，最简单的方式就是：

```bash
tlmgr --repository http://www.preining.info/tlgpg/ install tlgpg
```
:::


二维函数 $f(x,y) = 20 + x^2 + y^2 - 10*\cos(2*\pi*x) - 10*\cos(2*\pi*y)$ 最小值 0，最大值 80


```python
from math import cos, pi
import numpy as np
from mpl_toolkits.mplot3d import Axes3D
import matplotlib.pyplot as plt
from matplotlib import cm

from matplotlib import rcParams
rcParams.update({'font.size': 18, 'text.usetex': True}) 
# 其它可配置选项见 rcParams.keys()
plt.switch_backend('agg')

xDomain = np.arange(-5.12, 5.12, .08)
yDomain = np.arange(-5.12, 5.12, .08)

X, Y = np.meshgrid(xDomain, yDomain)
z = [20 + x**2 + y**2 - (10*(cos(2*pi*x) + cos(2*pi*y))) for x in xDomain for y in yDomain]
Z = np.array(z).reshape(128,128)

fig = plt.figure(figsize = (12,10))
ax = fig.gca(projection='3d')
## <string>:1: MatplotlibDeprecationWarning: Calling gca() with keyword arguments was deprecated in Matplotlib 3.4. Starting two minor releases later, gca() will take no keyword arguments. The gca() function should only be used to get the current axes, or if no axes exist, create new axes with default keyword arguments. To create a new axes with non-default arguments, use plt.axes() or plt.subplot().
surf = ax.plot_surface(X, Y, Z, cmap=cm.RdYlGn, linewidth=1, antialiased=False)

ax.set_xlim(-5.12, 5.12)
## (-5.12, 5.12)
ax.set_ylim(-5.12, 5.12)
## (-5.12, 5.12)
ax.set_zlim(0, 80)
# fig.colorbar(surf, aspect=30)
# plt.title(r'Rastrigin Function in Two Dimensions')
## (0.0, 80.0)
plt.tight_layout()
plt.show()
```

\begin{figure}

{\centering \includegraphics[width=0.75\linewidth]{other-softwares_files/figure-latex/rastrigin-function-3} 

}

\caption{Python 绘制三维图形：Rastrigin 函数图形}(\#fig:rastrigin-function)
\end{figure}

## Python 基础操作 {#sec-basic-python}


- 张量操作 [numpy](https://github.com/numpy/numpy) <https://numpy.org/> 向量、矩阵操作
- 科学计算 [scipy](https://github.com/scipy/scipy) <https://scipy.org/> 统计、优化和方程
- 数据操作 [pandas](https://github.com/pandas-dev/pandas/) <https://pandas.pydata.org/> 面向数据分析
- 数据可视化 [matplotlib](https://github.com/matplotlib/matplotlib) <https://matplotlib.org/> 静态图形
- 交互可视化 [bokeh](https://github.com/bokeh/bokeh) <https://bokeh.org/>
- 机器学习 [scikit-learn](https://github.com/scikit-learn/scikit-learn) <https://scikit-learn.org/> 面向机器学习
- 深度学习 [tensorflow](https://github.com/tensorflow/tensorflow) <https://tensorflow.org/> 面向深度学习

A Python implementation of global optimization with gaussian processes. [Bayesian Optimization](https://github.com/fmfn/BayesianOptimization)

用 numpy 实现一个统计类的算法，比如线性回归、稳健的线性回归、广义线性回归，数据集用 Python 内置的


```python
import numpy as np
np.zeros(3) # vector
```

```
## array([0., 0., 0.])
```

```python
np.ones(3) # vector
```

```
## array([1., 1., 1.])
```

```python
np.diag([1,1,1]) # identy matrix
# np.multiply()
```

```
## array([[1, 0, 0],
##        [0, 1, 0],
##        [0, 0, 1]])
```

```python
np.cumsum([1,1,1])
```

```
## array([1, 2, 3])
```

Python 模块 scikit-learn [@scikit-learn] 内置的数据集 iris 为例 <https://scikit-learn.org/stable/datasets/index.html>

<!--


```python
# import pandas as pd
# import numpy as np
# import matplotlib.pyplot as plt
from sklearn import datasets
iris = datasets.load_iris(as_frame=True)
# X
iris.data.head()
# Y
```

```
##    sepal length (cm)  sepal width (cm)  petal length (cm)  petal width (cm)
## 0                5.1               3.5                1.4               0.2
## 1                4.9               3.0                1.4               0.2
## 2                4.7               3.2                1.3               0.2
## 3                4.6               3.1                1.5               0.2
## 4                5.0               3.6                1.4               0.2
```

```python
iris.target.head()
```

```
## 0    0
## 1    0
## 2    0
## 3    0
## 4    0
## Name: target, dtype: int64
```

-->

导入正则表达式库，


```python
import re
m = re.search('(?<=abc)def', 'abcdef')
m.group(0) # 必须调用 print 函数打印结果
```

```
## 'def'
```

```python
print(m.group(0))
```

```
## def
```

```python
import sys
print(sys.path)
```

```
## ['', '/usr/bin', '/usr/lib/python38.zip', '/usr/lib/python3.8', '/usr/lib/python3.8/lib-dynload', '/opt/.virtualenvs/r-tensorflow/lib/python3.8/site-packages', '/home/runner/work/_temp/Library/reticulate/python', '/opt/.virtualenvs/r-tensorflow/lib/python38.zip', '/opt/.virtualenvs/r-tensorflow/lib/python3.8', '/opt/.virtualenvs/r-tensorflow/lib/python3.8/lib-dynload']
```

字符串基本操作，如拆分


```python
dir(str)
```

```
## ['__add__', '__class__', '__contains__', '__delattr__', '__dir__', '__doc__', '__eq__', '__format__', '__ge__', '__getattribute__', '__getitem__', '__getnewargs__', '__gt__', '__hash__', '__init__', '__init_subclass__', '__iter__', '__le__', '__len__', '__lt__', '__mod__', '__mul__', '__ne__', '__new__', '__reduce__', '__reduce_ex__', '__repr__', '__rmod__', '__rmul__', '__setattr__', '__sizeof__', '__str__', '__subclasshook__', 'capitalize', 'casefold', 'center', 'count', 'encode', 'endswith', 'expandtabs', 'find', 'format', 'format_map', 'index', 'isalnum', 'isalpha', 'isascii', 'isdecimal', 'isdigit', 'isidentifier', 'islower', 'isnumeric', 'isprintable', 'isspace', 'istitle', 'isupper', 'join', 'ljust', 'lower', 'lstrip', 'maketrans', 'partition', 'replace', 'rfind', 'rindex', 'rjust', 'rpartition', 'rsplit', 'rstrip', 'split', 'splitlines', 'startswith', 'strip', 'swapcase', 'title', 'translate', 'upper', 'zfill']
```

```python
print(dir(str.split))
```

```
## ['__call__', '__class__', '__delattr__', '__dir__', '__doc__', '__eq__', '__format__', '__ge__', '__get__', '__getattribute__', '__gt__', '__hash__', '__init__', '__init_subclass__', '__le__', '__lt__', '__name__', '__ne__', '__new__', '__objclass__', '__qualname__', '__reduce__', '__reduce_ex__', '__repr__', '__setattr__', '__sizeof__', '__str__', '__subclasshook__', '__text_signature__']
```

```python
import re
print(dir(re.split))
```

```
## ['__annotations__', '__call__', '__class__', '__closure__', '__code__', '__defaults__', '__delattr__', '__dict__', '__dir__', '__doc__', '__eq__', '__format__', '__ge__', '__get__', '__getattribute__', '__globals__', '__gt__', '__hash__', '__init__', '__init_subclass__', '__kwdefaults__', '__le__', '__lt__', '__module__', '__name__', '__ne__', '__new__', '__qualname__', '__reduce__', '__reduce_ex__', '__repr__', '__setattr__', '__sizeof__', '__str__', '__subclasshook__']
```



```python
import sys
# 模块存放路径
print(sys.path)
# 已安装的模块
sys.modules.keys()
```



```python
dict_keys(['sys', 'builtins', '_frozen_importlib', '_imp', '_warnings', '_frozen_importlib_external',
'_io', 'marshal', 'posix', '_thread', '_weakref', 'time', 'zipimport', '_codecs', 'codecs',
'encodings.aliases', 'encodings.cp437', 'encodings', 'encodings.utf_8', '_signal', '__main__',
'encodings.latin_1', '_abc', 'abc', 'io', '_stat', 'stat', '_collections_abc', 'genericpath',
'posixpath', 'os.path', 'os', '_sitebuiltins', 'site', 'readline', 'atexit', 'rlcompleter'])
```

```bash
pip3 install virtualenv
virtualenv -p python3 <desired-path>
source <desired-path>/bin/activate
source /opt/virtualenv/tensorflow/bin/activate
```

<!--
## Python 交互图形 {#sec-plotly-python}


```python
import plotly.express as px
px.scatter(px.data.iris(), x = "sepal_width", y = "sepal_length", 
    color = "species", template = "simple_white", 
    title = "Edgar Anderson's Iris Data",
    color_discrete_sequence = px.colors.qualitative.Set2
  )
```

绘图函数 <https://plotly.com/python-api-reference/plotly.express.html>
数据集 <https://plotly.com/python-api-reference/generated/plotly.express.data.html>

seaborn [@Waskom2021]


```r
# plotly.io.templates
plotly_themes <- c(
  "ggplot2", "seaborn", "simple_white", "plotly",
  "plotly_white", "plotly_dark", "presentation", 
  "xgridoff", "ygridoff", "gridon", "none"
)
```

         
```python
# 调色板
import plotly.express as px
fig = px.colors.qualitative.swatches()
fig.show()
# 显示颜色值
print(px.colors.qualitative.Plotly)
```

-->

- LaTeX 专家黄晨成写的译文 [Matplotlib 教程](https://liam.page/2014/09/11/matplotlib-tutorial-zh-cn/)
- [周沫凡](https://morvanzhou.github.io/) 制作的莫烦 Python 系列视频教程之 [Matplotlib 数据可视化神器](https://morvanzhou.github.io/tutorials/data-manipulation/plt/)
- 陈治兵维护的在线 [Matplotlib 中文文档](https://www.matplotlib.org.cn/)
- Sebastian Raschka 和 Vahid Mirjalili 合著的 [Python Machine Learning (3rd Edition)](https://github.com/rasbt/python-machine-learning-book-3rd-edition) [@Raschka_2017_Python]

编译书籍使用的 Python 3 模块有


```bash
pip3 list --format=columns
```


Package                 Version    
----------------------- -----------
absl-py                 0.14.1     
astunparse              1.6.3      
cachetools              4.2.4      
certifi                 2021.5.30  
charset-normalizer      2.0.6      
clang                   5.0        
cycler                  0.10.0     
flatbuffers             1.12       
gast                    0.4.0      
google-auth             1.35.0     
google-auth-oauthlib    0.4.6      
google-pasta            0.2.0      
graphviz                0.8.4      
grpcio                  1.41.0     
h5py                    3.1.0      
idna                    3.2        
joblib                  1.0.1      
kaleido                 0.2.1      
keras                   2.6.0      
Keras-Preprocessing     1.1.2      
kiwisolver              1.3.2      
Markdown                3.3.4      
matplotlib              3.4.3      
mpmath                  1.2.1      
mxnet                   1.8.0.post0
numpy                   1.21.2     
oauthlib                3.1.1      
opt-einsum              3.3.0      
pandas                  1.3.3      
patsy                   0.5.2      
Pillow                  8.3.2      
pip                     20.0.2     
pkg-resources           0.0.0      
plotly                  5.3.1      
protobuf                3.18.0     
pyasn1                  0.4.8      
pyasn1-modules          0.2.8      
pyparsing               2.4.7      
python-dateutil         2.8.2      
pytz                    2021.3     
requests                2.26.0     
requests-oauthlib       1.3.0      
rsa                     4.7.2      
scikit-learn            1.0        
scipy                   1.7.1      
setuptools              44.0.0     
six                     1.15.0     
statsmodels             0.13.0     
sympy                   1.8        
tenacity                8.0.1      
tensorboard             2.6.0      
tensorboard-data-server 0.6.1      
tensorboard-plugin-wit  1.8.0      
tensorflow              2.6.0      
tensorflow-estimator    2.6.0      
termcolor               1.1.0      
threadpoolctl           3.0.0      
typing-extensions       3.7.4.3    
urllib3                 1.26.7     
Werkzeug                2.0.1      
wheel                   0.37.0     
wrapt                   1.12.1     


```bash
# 安装 Python 虚拟环境管理器 virtualenv
sudo dnf install -y python3-pip python3-virtualenv
# 创建虚拟环境
virtualenv -p /usr/bin/python3 $RETICULATE_PYTHON_ENV
# 激活虚拟环境
source $RETICULATE_PYTHON_ENV/bin/activate
# 将虚拟环境位置写入配置文件
echo "export RETICULATE_PYTHON_ENV=$HOME/.virtualenvs/r-tensorflow" >> ~/.bashrc
source ~/.bashrc
# 安装 numpy matplotlib 等模块
pip install -r requirements.txt
# 导出模块版本信息
pip freeze >> requirements.txt
```



```python
import os
os.listdir('.git')
```

```
## ['info', 'logs', 'branches', 'config', 'HEAD', 'hooks', 'objects', 'description', 'FETCH_HEAD', 'shallow', 'index', 'refs']
```

多个代码块共享同一个 Python 进程


```python
os.path
```

```
## <module 'posixpath' from '/usr/lib/python3.8/posixpath.py'>
```

matplotlib 绘图，支持交叉引用[^cross-ref]，如图 \@ref(fig:matplotlib-copy) 所示


```python
import matplotlib.pyplot as plt
from matplotlib import rcParams
# 其它可配置选项见 rcParams.keys()
rcParams.update({'font.size': 10, 'text.usetex': True}) 
# rcParams.update({'font.family':     ['sans-serif'], 
#                  'font.monospace':  ['DejaVu Sans Mono'], 
#                  'font.sans-serif': ['DejaVu Sans'], 
#                  'font.serif':      ['DejaVu Serif']})
plt.switch_backend('agg')
plt.plot([0, 2, 1, 4])
plt.xlabel(r'Coord $x$')
plt.ylabel(r'Coord $y$')
plt.tight_layout()
plt.show()
```

\begin{figure}

{\centering \includegraphics{other-softwares_files/figure-latex/matplotlib-copy-1} 

}

\caption{matplotlib 复制示例}(\#fig:matplotlib-copy)
\end{figure}

有了 reticulate 包，我们可以把任意想要导入到 R 环境中的 Python 模块导进来，实现 R 与 Python 的数据交换和函数调用 [^gluon]


```r
os <- reticulate::import("os") # 导入 Python 模块
x <- os$listdir(".git") # 调用 os.listdir() 函数
x # 得到 python 中的向量 vector 或数组 array
```

```
##  [1] "info"        "logs"        "branches"    "config"      "HEAD"       
##  [6] "hooks"       "objects"     "description" "FETCH_HEAD"  "shallow"    
## [11] "index"       "refs"
```


[^gluon]: 朱俊辉的帖子 --- 在 R 中使用 gluon <https://d.cosx.org/d/419785-r-gluon>
[^cross-ref]: 早些时候，在 R Markdown 中设置 `python.reticulate = TRUE` 调用 reticulate 包，带来的副作用是不支持交叉引用的 <https://d.cosx.org/d/420680-python-reticulate-true>。RStudio 1.2 已经很好地集成了 reticulate，对 Python 的支持更加到位了  <https://blog.rstudio.com/2018/10/09/rstudio-1-2-preview-reticulated-python/>。截至本文写作时间 2021年10月20日 使用 reticulate 版本 1.22，本文没有对之前的版本进行测试。



```python
# https://docs.bokeh.org/en/latest/docs/user_guide/quickstart.html#userguide-quickstart
from bokeh.plotting import figure, output_file, show
# 准备一些数据
x = [1, 2, 3, 4, 5]
y = [6, 7, 2, 4, 5]
# 将动态图形以静态 HTML 文件的方式保存
output_file("lines.html")
# 创建一个简单的图形，设置标题、x,y 轴标签
p = figure(title="simple line example", x_axis_label='x', y_axis_label='y')
# 添加一条折线，设置图例，线宽
p.line(x, y, legend_label="Temp.", line_width=2)
# 显示结果
show(p)
```

将静态图形嵌入到 R Markdown 中

```r
htmltools::includeHTML("lines.html")
```

R 和 Python 之间的交互，Python 负责数据处理和建模， R 负责绘图，有些复杂的机器学习模型及其相关数据操作需要在 Python 中完成，数据集清理至数据框的形式后导入到 R 中，画各种静态或者动态图，这时候需要加载 reticulate 包，只是设置 `python.reticulate = TRUE` 还不够

::: {.rmdtip data-latex="{提示}"}
R Markdown 文档 [@xie2018] 中的 Python 代码块是由 knitr 包 [@xie2015] 负责调度处理的，展示 Matplotlib 绘图的结果使用了 reticulate 包 [@reticulate] 提供的 Python 引擎而不是 knitr 自带的。

在 `knitr::opts_chunk` 中设置 `python.reticulate = TRUE` 意味着所有的 Python 代码块共享一个 Python Session，而 `python.reticulate = FALSE` 意味着使用 knitr 提供的 Python 引擎，所有的 Python 代码块独立运行。
:::

pandas 读取数据，整理后由 reticulate 包传递给 R 环境中的 data.frame 对象，加载 ggplot2 绘图




```r
library(ggplot2)
theme_set(theme_minimal())
library(patchwork)
p1 <- ggplot(py$iris2, aes(x = Sepal.Length, y = Sepal.Width)) +
  geom_point(aes(color = Species)) +
  labs(title = "Call iris from Python")
p2 <- ggplot(iris, aes(x = Sepal.Length, y = Sepal.Width)) +
  geom_point(aes(color = Species)) +
  labs(title = "Call iris from R")
p1 + p2
```

以 NumPy 为例


```python
import numpy as np
a = np.arange(15).reshape(3, 5)
a
```

```
## array([[ 0,  1,  2,  3,  4],
##        [ 5,  6,  7,  8,  9],
##        [10, 11, 12, 13, 14]])
```

```python
a.shape
```

```
## (3, 5)
```

```python
a.ndim
```

```
## 2
```

```python
a.dtype.name
```

```
## 'int64'
```

```python
a.itemsize
```

```
## 8
```

```python
a.size
```

```
## 15
```

```python
type(a)
```

```
## <class 'numpy.ndarray'>
```

```python
b = np.array([6, 7, 8])
b
```

```
## array([6, 7, 8])
```

```python
type(b)
```

```
## <class 'numpy.ndarray'>
```

```python
a.transpose() @ b
```

```
## array([115, 136, 157, 178, 199])
```

Python 里面的点号$\cdot$对应于R里面的 `$`


```r
library(reticulate)
np <- import("numpy", convert=FALSE) # 导入 Python 模块
a <- np$arange(0, 15)$reshape(3L, 5L)
a
```

```
## [[ 0.  1.  2.  3.  4.]
##  [ 5.  6.  7.  8.  9.]
##  [10. 11. 12. 13. 14.]]
```

```r
a$shape
```

```
## (3, 5)
```

```r
a$ndim
```

```
## 2
```

```r
a$dtype$name
```

```
## float64
```

```r
a$itemsize
```

```
## 8
```

```r
a$size
```

```
## 15
```

```r
a$ctypes
```

```
## <numpy.core._internal._ctypes>
```

```r
a$dtype # data type 数据类型
```

```
## float64
```

```r
a$astype
```

```
## <built-in method astype of numpy.ndarray>
```

```r
builtins <- import_builtins() # Python 内建的函数，不需要导入第三方模块
builtins$type(a)
```

```
## <class 'numpy.ndarray'>
```

基本线性代数运算


```r
a$transpose() # 转置
```

```
## [[ 0.  5. 10.]
##  [ 1.  6. 11.]
##  [ 2.  7. 12.]
##  [ 3.  8. 13.]
##  [ 4.  9. 14.]]
```

```r
a$trace() # 迹
```

```
## 18.0
```

```r
np$eye(2L) # 单位矩阵
```

```
## [[1. 0.]
##  [0. 1.]]
```

```r
a$diagonal() # 对角
```

```
## [ 0.  6. 12.]
```

```r
# 两个矩阵的乘法
b <- np$array(c(6, 7, 8, 9, 10))$reshape(5L, 1L)
b
```

```
## [[ 6.]
##  [ 7.]
##  [ 8.]
##  [ 9.]
##  [10.]]
```

```r
b$shape
```

```
## (5, 1)
```

```r
np$multiply(b$transpose(), a) # b 乘以 a
```

```
## [[  0.   7.  16.  27.  40.]
##  [ 30.  42.  56.  72.  90.]
##  [ 60.  77.  96. 117. 140.]]
```

Python 对象转化为 R 对象


```r
py_to_r(b)
```

```
##      [,1]
## [1,]    6
## [2,]    7
## [3,]    8
## [4,]    9
## [5,]   10
```

## VBox 虚拟机 {#sec-virtual-vbox}

### 从命令行启动虚拟机 {#subsec-cmd-start-vbox}

当前我的虚拟机里安装了两个系统 Fedora 29 和 CentOS 8.2

```bash
VBoxManage list vms
```
```
"Fedora 29" {d316fe8d-c053-4941-8a45-a59fd476898d}
"CentOS 8.2" {f1613f26-ea65-4f02-9cb6-6a79a758a60e}
```

以无图形化界面的方式启动虚拟机 CentOS 8.2

```bash
VBoxManage startvm "CentOS 8.2" --type headless
# 或者
VBoxHeadless --startvm "CentOS 8.2"
```

其它常用的命令还有

```bash
VBoxManage list runningvms # 列出运行中的虚拟机
VBoxManage controlvm "CentOS 8.2" acpipowerbutton # 关闭虚拟机，等价于点击系统关闭按钮，正常关机
VBoxManage controlvm "CentOS 8.2" poweroff # 关闭虚拟机，等价于直接关闭电源，非正常关机
VBoxManage controlvm "CentOS 8.2" pause # 暂停虚拟机的运行
VBoxManage controlvm "CentOS 8.2" resume # 恢复暂停的虚拟机
VBoxManage controlvm "CentOS 8.2" savestate # 保存当前虚拟机的运行状态
```

更多细节解释见 [VBox 官方文档](https://www.virtualbox.org/manual/ch07.html#man_vboxheadless)

## Docker 虚拟环境 {#sec-virtual-docker}

docker 创建云实例 rstudio [DigitalOcean](https://cerebralmastication.com/2019/07/10/starting-a-digital-ocean-instance-from-docker-machine/)，docker 支持的驱动类型 <https://docs.docker.com/machine/drivers/>。Rocker 项目组提供的 shiny 容器 <https://github.com/rocker-org/shiny> 和构建过程 <https://hub.docker.com/r/rocker/shiny/dockerfile>

主机 80 端口映射给 shiny 容器 3838 端口


```bash
docker run --user shiny -d -p 80:3838 \
    -v /srv/shinyapps/:/srv/shiny-server/ \
    -v /srv/shinylog/:/var/log/shiny-server/ \
    rocker/shiny
```

shiny 服务器默认支持从 80 端口访问 <http://localhost:80>，shiny 应用放在目录 `/srv/shinyapps/appdir`，访问 Shiny 应用的位置 <http://localhost/appdir/>，使用 boot2docker 则访问 <http://192.168.59.103:80/appdir/>

<!-- 自己基于容器搭建一个 shiny 服务器 -->


Docker 相比虚拟机占用资源少，拉起来就可以用，虚拟机还需要各种环境配置，很多与R有关的项目现在都提供Docker镜像，大大方便了开发人员和数据分析师。当然 docker 的环境隔离性，对主机系统侵入小，即使挂了，再拉起来也就是了，安全性和可靠性高。

基于 [The Rocker Project](https://www.rocker-project.org/) 快速构建数据分析环境，[Rocker项目](https://github.com/rocker-org/rocker) 站在 [Debian](https://www.debian.org/) 和 [R](https://www.r-project.org/) 的肩膀上，在 [Docker](https://www.docker.com/) 内配置众多数据分析和开发的工具，免去用户手动配置的复杂性。此事非有心者不能为之 ，因为需费时费力找寻依赖库，编译 R 包，还要尽可能地给 Docker 镜像减负，以便部署。如果想抢先试水的赶快去 Rocker 项目主页。

- 由 Dirk Eddelbuettel 等人担纲的 Rocker 项目， [项目主页](https://github.com/rocker-org/rocker) 和 [Docker镜像](https://hub.docker.com/u/rocker/) 
- Wei-Chen Chen 等人的大数据编程项目 Programming with Big Data in R， [项目主页](https://rbigdata.github.io/) 和 [Docker 镜像](https://hub.docker.com/u/rbigdata/) 
- [非常详细的 docker 笔记](http://m.blog.csdn.net/sdgihshdv/article/details/75142367) 
- Dockerfile 最佳实践 <https://docs.docker.com/develop/develop-images/dockerfile_best-practices/>
- build 构建 <https://docs.docker.com/engine/reference/builder/#usage>

其它容器相关项目有 [Singularity](https://github.com/bwlewis/r-and-singularity) 和 [Kubernetes 容器集群管理](https://www.kubernetes.org.cn)，更多参见高策的博客 <https://gaocegege.com>
    
    
本节介绍与本书配套的 VBox 镜像和 Docker 容器镜像，方便读者直接运行书籍原稿中的例子，尽量不限于软件环境配置的苦海中，因为对于大多数初学者来说，软件配置是一件不小的麻烦事。

本书依赖的 R 包和配置环境比较复杂，所以将整个运行环境打包成 Docker 镜像，方便读者重现，构建镜像的 Dockerfile 文件随同书籍源文件一起托管在 Github 上，方便读者研究。本地编译书籍只需三步走，先将存放在 Github 上的书籍项目克隆到本地，如果本地环境中没有 Git，你需要从它的官网 <https://git-scm.com/> 下载安装适配本地系统的 Git 软件。

```bash
git clone https://github.com/XiangyunHuang/masr.git
```

然后在 Git Bash 的模拟终端器中，启动虚拟机，拉取准备好的镜像文件。为了方便读者重现本书的内容，特将书籍的编译环境打包成 Docker 镜像。在启动镜像前需要确保本地已经安装 Docker 软件 <https://www.docker.com/products/docker-desktop>，安装过程请看官网教程。

```bash
docker-machine.exe start default
docker pull xiangyunhuang/masr
```

最后 `cd` 进入书籍项目所在目录，运行如下命令编译书籍

```bash
docker run --rm -u docker -v "/${PWD}://home/docker/workspace" \
  xiangyunhuang/masr make gitbook
```

编译成功后，可以在目录 `_book/` 下看到生成的文件，点击文件 `index.html` 选择谷歌浏览器打开，不要使用 IE 浏览器，推荐使用谷歌浏览器获取最佳阅读体验，尽情地阅读吧！

如果你想了解编译书籍的环境和过程，我推荐你阅读随书籍源文件一起的 Dockerfile 文件， [Docker Hub](https://hub.docker.com/) 是根据此文件构建的镜像，打包成功后，大约占用空间 2 Gb，本书在 RStudio IDE 下用 R Markdown [@xie2018] 编辑的，编译本书获得电子版还需要一些 R 包和软件。Pandoc <https://pandoc.org/> 软件是系统 Fedora 30 仓库自带的，版本是 2.2.1，较新的 RStudio IDE 捆绑的 Pandoc 软件一般会高于此版本。如果你打算在本地系统上编译书籍，RStudio IDE 捆绑的 Pandoc 软件版本已经足够，当然你也可以在 <https://github.com/jgm/pandoc/releases/latest> 下载安装最新版本，此外，你还需参考书籍随附的 Dockerfile 文件配置 C++ 代码编译环境，安装所需的 R 包，并确保本地安装的版本不低于镜像内的版本。

镜像中已安装的 R 包列表可运行如下命令查看。

```bash
docker run --rm xiangyunhuang/masr \ 
  Rscript -e 'xfun::session_info(.packages(TRUE))'
```

Docker & Docker Machine & Docker Swarm

1. 容器与镜像的操作

   ```bash
   docker --version
   # Docker version 18.03.0-ce, build 0520e24302
   ```

   查看容器  
   
   ```bash
   docker ps -a
   ```

   删除容器 `docker rm 容器 ID`，删除前要确认已经停止该容器的运行
   
   ```bash
   docker rm 6f932357e6ce
   ```

   查看镜像 
   
   ```bash
   docker images
   ```

   删除镜像 
   
   `docker rmi 镜像 ID`
   
   ```bash
   docker rmi 811281c54b23
   ```

1. 拉取镜像

   ```bash
   docker pull rocker/verse:latest
   ```

1. 运行容器

   ```bash
   docker run --name verse -d -p 8282:8080 -e ROOT=TRUE \
      -e USER=rstudio -e PASSWORD=cloud rocker/verse
   ```
   
   将主机端口 8282 映射给虚拟机/容器的 8080 端口，RStudio Server 默认使用的端口是 8787，因此改为 8080 需要修改 `/etc/rstudio/rserver.conf` 文件，添加
   
   ```
   www-port=8080
   ```
   
   然后重启 RStudio Server，之后可以在浏览器中登陆，登陆网址为 <http://ip-addr:8080>，其中 `ip-addr` 可在容器中运行如下一行命令获得
   
   ```bash
   ip addr
   ```
   
更多关于服务器版本的 RStudio 介绍，请参考 <https://docs.rstudio.com/ide/server-pro/access-and-security.html>

[Docker Machine](https://github.com/docker/machine)

基本命令

* 查看 docker machine 版本信息

   
   ```bash
   docker-machine --version
   # docker-machine.exe version 0.14.0, build 89b8332
   ```

* 列出创建的虚拟机

   
   ```bash
   # 启动前
   docker-machine ls
   # NAME      ACTIVE   DRIVER       STATE     URL   SWARM   DOCKER    ERRORS
   # default   -        virtualbox   Stopped                 Unknown
   # 启动后
   docker-machine ls
   # NAME      ACTIVE   DRIVER       STATE     URL                         SWARM   DOCKER        ERRORS
   # default   *        virtualbox   Running   tcp://192.168.99.100:2376           v18.03.0-ce
   ```

* 查看虚拟机 default 的 ip

   
   ```bash
   docker-machine ip default
   # 192.168.99.100
   ```

* 启动虚拟机

   
   ```bash
   docker-machine start default
   # Starting "default"...
   # (default) Check network to re-create if needed...
   # (default) Windows might ask for the permission to configure a dhcp server. Sometimes, such confirmation window is minimized in the taskbar.
   # (default) Waiting for an IP...
   # Machine "default" was started.
   # Waiting for SSH to be available...
   # Detecting the provisioner...
   # Started machines may have new IP addresses. You may need to re-run the `docker-machine env` command.
   ```

* 进入 Docker 环境

   
   ```bash
   docker-machine ssh default
   ```
   ```
                           ##         .
                     ## ## ##        ==
                  ## ## ## ## ##    ===
              /"""""""""""""""""\___/ ===
         ~~~ {~~ ~~~~ ~~~ ~~~~ ~~~ ~ /  ===- ~~~
              \______ o           __/
                \    \         __/
                 \____\_______/
    _                 _   ____     _            _
   | |__   ___   ___ | |_|___ \ __| | ___   ___| | _____ _ __
   | '_ \ / _ \ / _ \| __| __) / _` |/ _ \ / __| |/ / _ \ '__|
   | |_) | (_) | (_) | |_ / __/ (_| | (_) | (__|   <  __/ |
   |_.__/ \___/ \___/ \__|_____\__,_|\___/ \___|_|\_\___|_|
   Boot2Docker version 18.03.0-ce, build HEAD : 404ee40 - Thu Mar 22 17:12:23 UTC 2018
   Docker version 18.03.0-ce, build 0520e24
   ```

* 查看容器

   
   ```bash
   docker ps -a
   # CONTAINER ID        IMAGE               COMMAND             CREATED            STATUS                   PORTS               NAMES
   # 69e6929d269e        rocker/verse        "/init"             3 weeks ago        Exited (0) 10 days ago                       verse
   ```

* 启动/停止容器

   
   ```bash
   docker start verse
   # verse
   docker stop verse
   # verse
   ```

* 查看虚拟机 default 的环境

   
   ```bash
   docker-machine env default
   # export DOCKER_TLS_VERIFY="1"
   # export DOCKER_HOST="tcp://192.168.99.100:2376"
   # export DOCKER_CERT_PATH="D:\Docker\machines\default"
   # export DOCKER_MACHINE_NAME="default"
   # export COMPOSE_CONVERT_WINDOWS_PATHS="true"
   # # Run this command to configure your shell:
   # # eval $("C:\Program Files\Docker Toolbox\docker-machine.exe" env default)
   ```

* 关闭虚拟机 default

   
   ```bash
   docker-machine stop default
   # Stopping "default"...
   # Machine "default" was stopped.
   ```


更多详情见帮助文档 <https://docs.docker.com/machine/get-started>



## 安装的 R 包 {#setup-r}

::: {.rmdwarn data-latex="{警告}"}
本小节仅用于展示目前书籍写作过程中安装的 R 包依赖，不会出现在最终的书稿中
:::



```r
sessionInfo(sort(.packages(T)))
```

```
## R version 4.1.1 (2021-08-10)
## Platform: x86_64-pc-linux-gnu (64-bit)
## Running under: Ubuntu 20.04.3 LTS
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
##  [1] base      compiler  datasets  graphics  grDevices grid      methods  
##  [8] parallel  splines   stats     stats4    tcltk     tools     utils    
## 
## other attached packages:
##   [1] ABCoptim_0.15.0            abind_1.4-5               
##   [3] agridat_1.18               alabama_2015.3-1          
##   [5] arrow_5.0.0.2              arules_1.6-8              
##   [7] ash_1.0-15                 askpass_1.1               
##   [9] assertive.base_0.0-9       assertive.properties_0.0-4
##  [11] assertive.types_0.0-3      assertthat_0.2.1          
##  [13] autoplotly_0.1.4           backports_1.2.1           
##  [15] base64enc_0.1-3            bayesplot_1.8.1           
##  [17] BB_2019.10-1               bbmle_1.0.24              
##  [19] bdsmatrix_1.3-4            beanplot_1.2              
##  [21] beeswarm_0.4.0             BH_1.75.0-0               
##  [23] BiocGenerics_0.38.0        BiocManager_1.30.16       
##  [25] BiocVersion_3.13.1         bit_4.0.4                 
##  [27] bit64_4.0.5                bitops_1.0-7              
##  [29] blob_1.2.2                 BMA_3.18.15               
##  [31] bookdown_0.24              boot_1.3-28               
##  [33] brew_1.0-6                 bridgesampling_1.1-2      
##  [35] brio_1.1.2                 brms_2.16.1               
##  [37] Brobdingnag_1.2-6          broom_0.7.9               
##  [39] broom.mixed_0.2.7          bslib_0.3.0               
##  [41] cachem_1.0.6               Cairo_1.5-12.2            
##  [43] callr_3.7.0                car_3.0-11                
##  [45] carData_3.0-4              cellranger_1.1.0          
##  [47] checkmate_2.0.0            circlize_0.4.13           
##  [49] class_7.3-19               classInt_0.4-3            
##  [51] cli_3.0.1                  clipr_0.7.1               
##  [53] clue_0.3-59                cluster_2.1.2             
##  [55] cmdstanr_0.4.0             coda_0.19-4               
##  [57] codetools_0.2-18           colorspace_2.0-2          
##  [59] colourpicker_1.1.0         combinat_0.0-8            
##  [61] commonmark_1.7             ComplexHeatmap_2.8.0      
##  [63] config_0.3.1               conquer_1.0.2             
##  [65] corrplot_0.90              countrycode_1.3.0         
##  [67] cowplot_1.1.1              cpp11_0.4.0               
##  [69] cranlogs_2.1.1             crayon_1.4.1              
##  [71] credentials_1.3.1          crosstalk_1.1.1           
##  [73] cubature_2.0.4.2           cubelyr_1.0.1             
##  [75] curl_4.3.2                 data.table_1.14.2         
##  [77] DBI_1.1.1                  dbplyr_2.1.1              
##  [79] deldir_0.2-10              dendextend_1.15.1         
##  [81] DEoptimR_1.0-9             Deriv_4.1.3               
##  [83] desc_1.4.0                 deSolve_1.29              
##  [85] devtools_2.4.2             dfidx_0.0-4               
##  [87] DiagrammeR_1.0.6.1         diffobj_0.3.4             
##  [89] digest_0.6.28              distributional_0.2.2      
##  [91] doParallel_1.0.16          dotCall64_1.0-1           
##  [93] downlit_0.2.1              downloader_0.4            
##  [95] dplyr_1.0.7                DT_0.19                   
##  [97] dtplyr_1.1.0               dygraphs_1.1.1.6          
##  [99] e1071_1.7-9                Ecdat_0.3-9               
## [101] Ecfun_0.2-5                echarts4r_0.4.1           
## [103] egg_0.4.5                  ellipsis_0.3.2            
## [105] emo_0.0.0.9000             equatiomatic_0.3.0        
## [107] evaluate_0.14              evd_2.3-3                 
## [109] expm_0.999-6               extrafont_0.17            
## [111] extrafontdb_1.0            fansi_0.5.0               
## [113] farver_2.1.0               fastmap_1.1.0             
## [115] fda_5.1.9                  fds_1.8                   
## [117] fields_12.5                filehash_2.4-2            
## [119] flexdashboard_0.5.2.9000   FNN_1.1.3                 
## [121] fontawesome_0.2.2          fontcm_1.1                
## [123] forcats_0.5.1              foreach_1.5.1             
## [125] foreign_0.8-81             forge_0.2.0               
## [127] formatR_1.11               formattable_0.2.1         
## [129] Formula_1.2-4              fs_1.5.0                  
## [131] future_1.22.1              GA_3.2.1                  
## [133] gamm4_0.2-6                gapminder_0.3.0           
## [135] gargle_1.2.0               gclus_1.3.2               
## [137] gdata_2.18.0               gdtools_0.2.3             
## [139] generics_0.1.0             geoR_1.8-1                
## [141] gert_1.4.1                 GetoptLong_1.0.5          
## [143] ggalluvial_0.12.3          gganimate_1.0.7           
## [145] ggbeeswarm_0.6.0           ggbump_0.1.0              
## [147] ggdendro_0.1.22            ggfittext_0.9.1           
## [149] ggfortify_0.4.12           ggiraph_0.7.10            
## [151] ggmosaic_0.3.3             ggnormalviolin_0.1.2      
## [153] ggplot2_3.3.5              ggpubr_0.4.0              
## [155] ggrepel_0.9.1              ggridges_0.5.3            
## [157] ggsci_2.9                  ggsignif_0.6.3            
## [159] ggstream_0.1.0             ggthemes_4.2.4            
## [161] gh_1.3.0                   gifski_1.4.3-1            
## [163] git2r_0.28.0               gitcreds_0.1.1            
## [165] glmmTMB_1.1.2.3            glmnet_4.1-2              
## [167] GlobalOptions_0.1.2        globals_0.14.0            
## [169] glue_1.4.2                 gmodels_2.18.1            
## [171] gmp_0.6-2                  googledrive_2.0.0         
## [173] googlesheets4_1.0.0        graph_1.70.0              
## [175] gridBase_0.4-7             gridExtra_2.3             
## [177] gt_0.3.1                   gtable_0.3.0              
## [179] gtools_3.9.2               haven_2.4.3               
## [181] hdrcde_3.4                 heatmaply_1.2.1           
## [183] here_1.0.1                 hexbin_1.28.2             
## [185] highcharter_0.8.2          highr_0.9                 
## [187] HKprocess_0.0-2            Hmisc_4.5-0               
## [189] hms_1.1.1                  hrbrthemes_0.8.0          
## [191] htmlTable_2.2.1            htmltools_0.5.2           
## [193] htmlwidgets_1.5.4          httpuv_1.6.3              
## [195] httr_1.4.2                 hunspell_3.0.1            
## [197] idbr_1.0                   ids_1.0.1                 
## [199] igraph_1.2.6               influenceR_0.1.0.1        
## [201] ini_0.3.1                  INLA_21.02.23             
## [203] inline_0.3.19              IRanges_2.26.0            
## [205] isoband_0.2.5              iterators_1.0.13          
## [207] janeaustenr_0.1.5          janitor_2.1.0             
## [209] jpeg_0.1-9                 jquerylib_0.1.4           
## [211] jsonlite_1.7.2             kableExtra_1.3.4          
## [213] Kendall_2.2                keras_2.6.0               
## [215] kernlab_0.9-29             KernSmooth_2.23-20        
## [217] knitr_1.36                 ks_1.13.2                 
## [219] labeling_0.4.2             later_1.3.0               
## [221] lattice_0.20-45            latticeExtra_0.6-29       
## [223] lazyeval_0.2.2             leaflet_2.0.4.1           
## [225] leaflet.providers_1.9.0    leafletCN_0.2.1           
## [227] leaps_3.1                  LearnBayes_2.15.1         
## [229] lifecycle_1.0.1            lightgbm_3.2.1            
## [231] listenv_0.8.0              lme4_1.1-27.1             
## [233] lmtest_0.9-38              locfit_1.5-9.4            
## [235] loo_2.4.1                  lpSolve_5.6.15            
## [237] lpSolveAPI_5.5.2.0-17.7    lubridate_1.7.10          
## [239] lwgeom_0.2-7               magick_2.7.3              
## [241] magrittr_2.0.1             mapdata_2.3.0             
## [243] mapproj_1.2.7              maps_3.4.0                
## [245] maptools_1.1-2             markdown_1.1              
## [247] MASS_7.3-54                mathjaxr_1.4-0            
## [249] Matrix_1.3-4               MatrixModels_0.5-0        
## [251] matrixStats_0.61.0         maxLik_1.5-2              
## [253] mclust_5.4.7               mcmc_0.9-7                
## [255] MCMCpack_1.5-0             memoise_2.0.0             
## [257] mgcv_1.8-37                microbenchmark_1.4-7      
## [259] mime_0.12                  miniUI_0.1.1.1            
## [261] minqa_1.2.4                misc3d_0.9-0              
## [263] miscTools_0.6-26           mlogit_1.1-1              
## [265] mnormt_2.0.2               modelr_0.1.8              
## [267] mpoly_1.1.1                multicool_0.1-12          
## [269] multipol_1.0-7             munsell_0.5.0             
## [271] mvtnorm_1.1-2              networkD3_0.4             
## [273] nleqslv_3.3.2              nlme_3.1-153              
## [275] nlmeODE_1.1                nloptr_1.2.2.2            
## [277] NMOF_2.4-1                 nnet_7.3-16               
## [279] nomnoml_0.2.3              numDeriv_2016.8-1.1       
## [281] odbc_1.3.2                 openssl_1.4.5             
## [283] openxlsx_4.2.4             optimx_2021-6.12          
## [285] orthopolynom_1.0-5         packagemetrics_0.0.1.9001 
## [287] packrat_0.7.0              palmerpenguins_0.1.0      
## [289] parallelly_1.28.1          partitions_1.10-2         
## [291] patchwork_1.1.1            pbkrtest_0.5.1            
## [293] PBSddesolve_1.12.6         pcaPP_1.9-74              
## [295] pdftools_3.0.1             pdist_1.2                 
## [297] pillar_1.6.3               pixmap_0.4-12             
## [299] pkgbuild_1.2.0             pkgconfig_2.0.3           
## [301] pkgload_1.2.2              plogr_0.2.0               
## [303] plot3D_1.4                 plotly_4.9.4.1            
## [305] plyr_1.8.6                 png_0.1-7                 
## [307] polynom_1.4-0              posterior_1.1.0           
## [309] pracma_2.3.3               praise_1.0.0              
## [311] prettydoc_0.4.1            prettyunits_1.1.1         
## [313] PrevMap_1.5.3              processx_3.5.2            
## [315] productplots_0.1.1         progress_1.2.2            
## [317] projpred_2.0.2             promises_1.2.0.1          
## [319] proxy_0.4-26               ps_1.6.0                  
## [321] pso_1.0.3                  pspearman_0.3-0           
## [323] purrr_0.3.4                pwr_1.3-0                 
## [325] qap_0.1-1                  qpdf_1.1                  
## [327] quadprog_1.5-8             quantmod_0.4.18           
## [329] quantreg_5.86              r2d3_0.2.5                
## [331] R6_2.5.1                   rainbow_3.6               
## [333] RandomFields_3.3.10        RandomFieldsUtils_0.5.4   
## [335] rappdirs_0.3.3             raster_3.4-13             
## [337] rasterly_0.2.0             rasterVis_0.50.3          
## [339] rbibutils_2.2.3            rcmdcheck_1.4.0           
## [341] RColorBrewer_1.1-2         Rcpp_1.0.7                
## [343] RcppArmadillo_0.10.6.0.0   RcppEigen_0.3.3.9.1       
## [345] RcppParallel_5.1.4         RCurl_1.98-1.5            
## [347] Rdpack_2.1.2               reactable_0.2.3           
## [349] reactR_0.4.4               ReacTran_1.4.3.1          
## [351] readr_2.0.2                readxl_1.3.1              
## [353] registry_0.5-1             rematch_1.0.1             
## [355] rematch2_2.1.2             remotes_2.4.1             
## [357] renv_0.14.0                reprex_2.0.1              
## [359] reshape2_1.4.4             reticulate_1.22           
## [361] rgdal_1.5-27               rgeos_0.5-8               
## [363] rgl_0.107.14               RgoogleMaps_1.4.5.3       
## [365] Rgraphviz_2.36.0           rio_0.5.27                
## [367] rJava_1.0-5                rjson_0.2.20              
## [369] rlang_0.4.11               rlist_0.4.6.2             
## [371] rmarkdown_2.11             rnaturalearthdata_0.1.0   
## [373] rngtools_1.5.2             robustbase_0.93-9         
## [375] ROI_1.0-0                  ROI.plugin.alabama_1.0-0  
## [377] ROI.plugin.lpsolve_1.0-1   ROI.plugin.nloptr_1.0-0   
## [379] ROI.plugin.quadprog_1.0-0  rootSolve_1.8.2.3         
## [381] roxygen2_7.1.2             rpart_4.1-15              
## [383] rprojroot_2.0.2            rrcov_1.6-0               
## [385] rsconnect_0.8.24           RSQLite_2.2.8             
## [387] rstan_2.26.3               rstantools_2.1.1          
## [389] rstatix_0.7.0              rstudioapi_0.13           
## [391] Rttf2pt1_1.3.9             rversions_2.1.1           
## [393] rvest_1.0.1                s2_1.0.7                  
## [395] S4Vectors_0.30.0           sandwich_3.0-1            
## [397] sass_0.4.0                 scales_1.1.1              
## [399] scatterplot3d_0.3-41       selectr_0.4-2             
## [401] seriation_1.3.0            sessioninfo_1.1.1         
## [403] sets_1.0-18                sf_1.0-2                  
## [405] sfarrow_0.4.0              shades_1.4.0              
## [407] shape_1.4.6                shiny_1.7.0               
## [409] shinyjs_2.0.0              shinystan_2.5.0           
## [411] shinythemes_1.2.0          showtext_0.9-4            
## [413] showtextdb_3.0             Sim.DiffProc_4.8          
## [415] slam_0.1-48                sm_2.2-5.7                
## [417] sn_2.0.0                   snakecase_0.11.0          
## [419] SnowballC_0.7.0            sourcetools_0.1.7         
## [421] sp_1.4-5                   spam_2.7-0                
## [423] sparkline_2.0              sparklyr_1.7.2            
## [425] SparseM_1.81               spatial_7.3-14            
## [427] spData_0.3.10              spDataLarge_0.5.4         
## [429] spdep_1.1-11               splancs_2.01-42           
## [431] splines2_0.4.5             stackr_0.0.0.9000         
## [433] StanHeaders_2.26.3         stars_0.5-3               
## [435] statmod_1.4.36             stringi_1.7.4             
## [437] stringr_1.4.0              SuppDists_1.1-9.5         
## [439] survival_3.2-13            svglite_2.0.0             
## [441] symengine_0.1.5            symmoments_1.2.1          
## [443] sys_3.4                    sysfonts_0.8.5            
## [445] systemfonts_1.0.2          TeachingDemos_2.12        
## [447] tensorA_0.36.2             tensorflow_2.6.0          
## [449] terra_1.3-22               testthat_3.0.4            
## [451] tfautograph_0.3.2          tfruns_1.5.0              
## [453] threejs_0.3.3              tibble_3.1.5              
## [455] tidyr_1.1.4                tidyselect_1.1.1          
## [457] tidytext_0.3.1             tidyverse_1.3.1           
## [459] tikzDevice_0.12.3.1        timeline_0.9              
## [461] timelineS_0.1.1            tint_0.1.3                
## [463] tinytex_0.34               tis_1.38                  
## [465] TMB_1.7.22                 tmvnsim_1.0-2             
## [467] tokenizers_0.2.1           transformr_0.1.3          
## [469] treemap_2.4-3              treemapify_2.5.5          
## [471] truncnorm_1.0-8            TSP_1.1-10                
## [473] TTR_0.24.2                 tweenr_1.0.2              
## [475] tzdb_0.1.2                 units_0.7-2               
## [477] usethis_2.0.1              utf8_1.2.2                
## [479] uuid_0.1-4                 V8_3.4.2                  
## [481] vctrs_0.3.8                vioplot_0.3.7             
## [483] vipor_0.4.5                viridis_0.6.1             
## [485] viridisLite_0.4.0          visNetwork_2.1.0          
## [487] vistime_1.2.1              vroom_1.5.5               
## [489] waldo_0.3.1                webshot_0.5.2             
## [491] whisker_0.4                withr_2.4.2               
## [493] wk_0.5.0                   xfun_0.26                 
## [495] xgboost_1.4.1.1            xkcd_0.0.6                
## [497] XML_3.99-0.8               xml2_1.3.2                
## [499] xopen_1.0.0                xtable_1.8-4              
## [501] xts_0.12.1                 yaml_2.2.1                
## [503] zeallot_0.1.0              zip_2.2.0                 
## [505] zoo_1.8-9
```



```r
library(magrittr)
pdb <- tools::CRAN_package_db()
pkg <- subset(desc::desc_get_deps(), subset = type == "Imports", select = "package", drop = TRUE)
pkg <- tools::package_dependencies(packages = pkg, db = pdb, recursive = FALSE) %>% # 是否包含递归依赖
  unlist() %>%
  as.vector() %>%
  c(., pkg) %>%
  unique() %>%
  sort()

pkg_quote <- c(
  "Armadillo", "Rcpp", "R", "Stan", "DataTables", "Dygraphs", "ggplot2",
  "Grobs", "Geospatial", "Eigen", "Sundown", "plog", "TeX Live", "Tidyverse",
  "LaTeX", "ADMB", "matplotlib", "Yihui Xie", "With", "Highcharts",
  "kable", "plotly.js", "Python", "Formattable"
)
# 单引号
pkg_regexp <- paste("'(", paste(pkg_quote, collapse = "|"), ")'", sep = "")
# R 包列表
subset(pdb,
  subset = !duplicated(pdb$Package) & Package %in% pkg,
  select = c("Package", "Version", "Title")
) %>%
  transform(.,
    Title = gsub("(\\\n)", " ", Title),
    Package = paste("**", Package, "**", sep = "")
  ) %>%
  transform(., Title = gsub(pkg_regexp, "\\1", Title)) %>%
  transform(., Title = gsub('"(Grid)"', "\\1", Title)) %>%
  knitr::kable(.,
    caption = "依赖的 R 包", format = "pandoc",
    booktabs = TRUE, row.names = FALSE
  )
```



Table: (\#tab:all-pkgs)依赖的 R 包

Package                   Version        Title                                                                                                                       
------------------------  -------------  ----------------------------------------------------------------------------------------------------------------------------
**abind**                 1.4-5          Combine Multidimensional Arrays                                                                                             
**agridat**               1.18           Agricultural Datasets                                                                                                       
**alabama**               2015.3-1       Constrained Nonlinear Optimization                                                                                          
**arrow**                 5.0.0.2        Integration to 'Apache' 'Arrow'                                                                                             
**arules**                1.6-8          Mining Association Rules and Frequent Itemsets                                                                              
**assertive.types**       0.0-3          Assertions to Check Types of Variables                                                                                      
**assertthat**            0.2.1          Easy Pre and Post Assertions                                                                                                
**autoplotly**            0.1.4          Automatic Generation of Interactive Visualizations for Statistical Results                                                  
**backports**             1.2.1          Reimplementations of Functions Introduced Since R-3.0.0                                                                     
**base64enc**             0.1-3          Tools for base64 encoding                                                                                                   
**bayesplot**             1.8.1          Plotting for Bayesian Models                                                                                                
**bbmle**                 1.0.24         Tools for General Maximum Likelihood Estimation                                                                             
**bdsmatrix**             1.3-4          Routines for Block Diagonal Symmetric Matrices                                                                              
**beanplot**              1.2            Visualization via Beanplots (like Boxplot/Stripchart/Violin Plot)                                                           
**beeswarm**              0.4.0          The Bee Swarm Plot, an Alternative to Stripchart                                                                            
**BH**                    1.75.0-0       Boost C++ Header Files                                                                                                      
**BiocManager**           1.30.16        Access the Bioconductor Project Package Repository                                                                          
**bit64**                 4.0.5          A S3 Class for Vectors of 64bit Integers                                                                                    
**bitops**                1.0-7          Bitwise Operations                                                                                                          
**blob**                  1.2.2          A Simple S3 Class for Representing Vectors of Binary Data ('BLOBS')                                                         
**bookdown**              0.24           Authoring Books and Technical Documents with R Markdown                                                                     
**boot**                  1.3-28         Bootstrap Functions (Originally by Angelo Canty for S)                                                                      
**bridgesampling**        1.1-2          Bridge Sampling for Marginal Likelihoods and Bayes Factors                                                                  
**brio**                  1.1.2          Basic R Input Output                                                                                                        
**brms**                  2.16.1         Bayesian Regression Models using Stan                                                                                       
**broom**                 0.7.9          Convert Statistical Objects into Tidy Tibbles                                                                               
**broom.mixed**           0.2.7          Tidying Methods for Mixed Models                                                                                            
**bslib**                 0.3.0          Custom 'Bootstrap' 'Sass' Themes for 'shiny' and 'rmarkdown'                                                                
**cachem**                1.0.6          Cache R Objects with Automatic Pruning                                                                                      
**callr**                 3.7.0          Call R from R                                                                                                               
**checkmate**             2.0.0          Fast and Versatile Argument Checks                                                                                          
**classInt**              0.4-3          Choose Univariate Class Intervals                                                                                           
**cli**                   3.0.1          Helpers for Developing Command Line Interfaces                                                                              
**coda**                  0.19-4         Output Analysis and Diagnostics for MCMC                                                                                    
**colorspace**            2.0-2          A Toolbox for Manipulating and Assessing Colors and Palettes                                                                
**commonmark**            1.7            High Performance CommonMark and Github Markdown Rendering in R                                                              
**config**                0.3.1          Manage Environment Specific Configuration Values                                                                            
**conquer**               1.0.2          Convolution-Type Smoothed Quantile Regression                                                                               
**corrplot**              0.90           Visualization of a Correlation Matrix                                                                                       
**countrycode**           1.3.0          Convert Country Names and Country Codes                                                                                     
**cowplot**               1.1.1          Streamlined Plot Theme and Plot Annotations for ggplot2                                                                     
**crayon**                1.4.1          Colored Terminal Output                                                                                                     
**crosstalk**             1.1.1          Inter-Widget Interactivity for HTML Widgets                                                                                 
**curl**                  4.3.2          A Modern and Flexible Web Client for R                                                                                      
**data.table**            1.14.2         Extension of `data.frame`                                                                                                   
**DBI**                   1.1.1          R Database Interface                                                                                                        
**dbplyr**                2.1.1          A 'dplyr' Back End for Databases                                                                                            
**dendextend**            1.15.1         Extending 'dendrogram' Functionality in R                                                                                   
**Deriv**                 4.1.3          Symbolic Differentiation                                                                                                    
**desc**                  1.4.0          Manipulate DESCRIPTION Files                                                                                                
**deSolve**               1.29           Solvers for Initial Value Problems of Differential Equations ('ODE', 'DAE', 'DDE')                                          
**devtools**              2.4.2          Tools to Make Developing R Packages Easier                                                                                  
**DiagrammeR**            1.0.6.1        Graph/Network Visualization                                                                                                 
**digest**                0.6.28         Create Compact Hash Digests of R Objects                                                                                    
**downlit**               0.2.1          Syntax Highlighting and Automatic Linking                                                                                   
**downloader**            0.4            Download Files over HTTP and HTTPS                                                                                          
**dplyr**                 1.0.7          A Grammar of Data Manipulation                                                                                              
**DT**                    0.19           A Wrapper of the JavaScript Library DataTables                                                                              
**dtplyr**                1.1.0          Data Table Back-End for 'dplyr'                                                                                             
**echarts4r**             0.4.2          Create Interactive Graphs with 'Echarts JavaScript' Version 5                                                               
**egg**                   0.4.5          Extensions for ggplot2: Custom Geom, Custom Themes, Plot Alignment, Labelled Panels, Symmetric Scales, and Fixed Panel Size 
**ellipsis**              0.3.2          Tools for Working with ...                                                                                                  
**equatiomatic**          0.3.0          Transform Models into LaTeX Equations                                                                                       
**evaluate**              0.14           Parsing and Evaluation Tools that Provide More Details than the Default                                                     
**extrafont**             0.17           Tools for using fonts                                                                                                       
**extrafontdb**           1.0            Package for holding the database for the extrafont package                                                                  
**fansi**                 0.5.0          ANSI Control Sequence Aware String Functions                                                                                
**fastmap**               1.1.0          Fast Data Structures                                                                                                        
**filehash**              2.4-2          Simple Key-Value Database                                                                                                   
**fontawesome**           0.2.2          Easily Work with 'Font Awesome' Icons                                                                                       
**fontcm**                1.1            Computer Modern font for use with extrafont package                                                                         
**forcats**               0.5.1          Tools for Working with Categorical Variables (Factors)                                                                      
**foreach**               1.5.1          Provides Foreach Looping Construct                                                                                          
**forge**                 0.2.0          Casting Values into Shape                                                                                                   
**formatR**               1.11           Format R Code Automatically                                                                                                 
**fs**                    1.5.0          Cross-Platform File System Operations Based on 'libuv'                                                                      
**future**                1.22.1         Unified Parallel and Distributed Processing in R for Everyone                                                               
**gapminder**             0.3.0          Data from Gapminder                                                                                                         
**gdtools**               0.2.3          Utilities for Graphical Rendering                                                                                           
**generics**              0.1.0          Common S3 Generics not Provided by Base R Methods Related to Model Fitting                                                  
**geoR**                  1.8-1          Analysis of Geostatistical Data                                                                                             
**ggalluvial**            0.12.3         Alluvial Plots in ggplot2                                                                                                   
**gganimate**             1.0.7          A Grammar of Animated Graphics                                                                                              
**ggbeeswarm**            0.6.0          Categorical Scatter (Violin Point) Plots                                                                                    
**ggbump**                0.1.0          Bump Chart and Sigmoid Curves                                                                                               
**ggfittext**             0.9.1          Fit Text Inside a Box in ggplot2                                                                                            
**ggfortify**             0.4.12         Data Visualization Tools for Statistical Analysis Results                                                                   
**ggmosaic**              0.3.3          Mosaic Plots in the ggplot2 Framework                                                                                       
**ggnormalviolin**        0.1.2          A ggplot2 Extension to Make Normal Violin Plots                                                                             
**ggplot2**               3.3.5          Create Elegant Data Visualisations Using the Grammar of Graphics                                                            
**ggpubr**                0.4.0          ggplot2 Based Publication Ready Plots                                                                                       
**ggrepel**               0.9.1          Automatically Position Non-Overlapping Text Labels with ggplot2                                                             
**ggridges**              0.5.3          Ridgeline Plots in ggplot2                                                                                                  
**ggsci**                 2.9            Scientific Journal and Sci-Fi Themed Color Palettes for ggplot2                                                             
**ggsignif**              0.6.3          Significance Brackets for ggplot2                                                                                           
**ggstream**              0.1.0          Create Streamplots in ggplot2                                                                                               
**gifski**                1.4.3-1        Highest Quality GIF Encoder                                                                                                 
**git2r**                 0.28.0         Provides Access to Git Repositories                                                                                         
**glmmTMB**               1.1.2.3        Generalized Linear Mixed Models using Template Model Builder                                                                
**glmnet**                4.1-2          Lasso and Elastic-Net Regularized Generalized Linear Models                                                                 
**globals**               0.14.0         Identify Global Objects in R Expressions                                                                                    
**glue**                  1.4.2          Interpreted String Literals                                                                                                 
**googledrive**           2.0.0          An Interface to Google Drive                                                                                                
**googlesheets4**         1.0.0          Access Google Sheets using the Sheets API V4                                                                                
**gridBase**              0.4-7          Integration of base and grid graphics                                                                                       
**gridExtra**             2.3            Miscellaneous Functions for Grid Graphics                                                                                   
**gt**                    0.3.1          Easily Create Presentation-Ready Display Tables                                                                             
**gtable**                0.3.0          Arrange Grobs in Tables                                                                                                     
**haven**                 2.4.3          Import and Export 'SPSS', 'Stata' and 'SAS' Files                                                                           
**heatmaply**             1.2.1          Interactive Cluster Heat Maps Using 'plotly' and ggplot2                                                                    
**here**                  1.0.1          A Simpler Way to Find Your Files                                                                                            
**hexbin**                1.28.2         Hexagonal Binning Routines                                                                                                  
**highcharter**           0.8.2          A Wrapper for the Highcharts Library                                                                                        
**highr**                 0.9            Syntax Highlighting for R Source Code                                                                                       
**Hmisc**                 4.5-0          Harrell Miscellaneous                                                                                                       
**hms**                   1.1.1          Pretty Time of Day                                                                                                          
**hrbrthemes**            0.8.0          Additional Themes, Theme Components and Utilities for ggplot2                                                               
**htmltools**             0.5.2          Tools for HTML                                                                                                              
**htmlwidgets**           1.5.4          HTML Widgets for R                                                                                                          
**httpuv**                1.6.3          HTTP and WebSocket Server Library                                                                                           
**httr**                  1.4.2          Tools for Working with URLs and HTTP                                                                                        
**igraph**                1.2.6          Network Analysis and Visualization                                                                                          
**influenceR**            0.1.0.1        Software Tools to Quantify Structural Importance of Nodes in a Network                                                      
**inline**                0.3.19         Functions to Inline C, C++, Fortran Function Calls from R                                                                   
**isoband**               0.2.5          Generate Isolines and Isobands from Regularly Spaced Elevation Grids                                                        
**jquerylib**             0.1.4          Obtain 'jQuery' as an HTML Dependency Object                                                                                
**jsonlite**              1.7.2          A Simple and Robust JSON Parser and Generator for R                                                                         
**kableExtra**            1.3.4          Construct Complex Table with kable and Pipe Syntax                                                                          
**Kendall**               2.2            Kendall rank correlation and Mann-Kendall trend test                                                                        
**knitr**                 1.36           A General-Purpose Package for Dynamic Report Generation in R                                                                
**later**                 1.3.0          Utilities for Scheduling Functions to Execute Later with Event Loops                                                        
**lattice**               0.20-45        Trellis Graphics for R                                                                                                      
**latticeExtra**          0.6-29         Extra Graphical Utilities Based on Lattice                                                                                  
**lazyeval**              0.2.2          Lazy (Non-Standard) Evaluation                                                                                              
**leaflet**               2.0.4.1        Create Interactive Web Maps with the JavaScript 'Leaflet' Library                                                           
**leaflet.providers**     1.9.0          Leaflet Providers                                                                                                           
**leafletCN**             0.2.1          An R Gallery for China and Other Geojson Choropleth Map in Leaflet                                                          
**lifecycle**             1.0.1          Manage the Life Cycle of your Package Functions                                                                             
**lightgbm**              3.2.1          Light Gradient Boosting Machine                                                                                             
**lme4**                  1.1-27.1       Linear Mixed-Effects Models using Eigen and S4                                                                              
**loo**                   2.4.1          Efficient Leave-One-Out Cross-Validation and WAIC for Bayesian Models                                                       
**lpSolve**               5.6.15         Interface to 'Lp_solve' v. 5.5 to Solve Linear/Integer Programs                                                             
**lpSolveAPI**            5.5.2.0-17.7   R Interface to 'lp_solve' Version 5.5.2.0                                                                                   
**lubridate**             1.7.10         Make Dealing with Dates a Little Easier                                                                                     
**magick**                2.7.3          Advanced Graphics and Image-Processing in R                                                                                 
**magrittr**              2.0.1          A Forward-Pipe Operator for R                                                                                               
**mapdata**               2.3.0          Extra Map Databases                                                                                                         
**mapproj**               1.2.7          Map Projections                                                                                                             
**maps**                  3.4.0          Draw Geographical Maps                                                                                                      
**markdown**              1.1            Render Markdown with the C Library Sundown                                                                                  
**MASS**                  7.3-54         Support Functions and Datasets for Venables and Ripley's MASS                                                               
**Matrix**                1.3-4          Sparse and Dense Matrix Classes and Methods                                                                                 
**MatrixModels**          0.5-0          Modelling with Sparse and Dense Matrices                                                                                    
**matrixStats**           0.61.0         Functions that Apply to Rows and Columns of Matrices (and to Vectors)                                                       
**maxLik**                1.5-2          Maximum Likelihood Estimation and Related Tools                                                                             
**mcmc**                  0.9-7          Markov Chain Monte Carlo                                                                                                    
**memoise**               2.0.0          Memoisation of Functions                                                                                                    
**mgcv**                  1.8-37         Mixed GAM Computation Vehicle with Automatic Smoothness Estimation                                                          
**mime**                  0.12           Map Filenames to MIME Types                                                                                                 
**minqa**                 1.2.4          Derivative-free optimization algorithms by quadratic approximation                                                          
**modelr**                0.1.8          Modelling Functions that Work with the Pipe                                                                                 
**mvtnorm**               1.1-2          Multivariate Normal and t Distributions                                                                                     
**networkD3**             0.4            D3 JavaScript Network Graphs from R                                                                                         
**nleqslv**               3.3.2          Solve Systems of Nonlinear Equations                                                                                        
**nlme**                  3.1-153        Linear and Nonlinear Mixed Effects Models                                                                                   
**nloptr**                1.2.2.2        R Interface to NLopt                                                                                                        
**nomnoml**               0.2.3          Sassy 'UML' Diagrams                                                                                                        
**numDeriv**              2016.8-1.1     Accurate Numerical Derivatives                                                                                              
**odbc**                  1.3.2          Connect to ODBC Compatible Databases (using the DBI Interface)                                                              
**openssl**               1.4.5          Toolkit for Encryption, Signatures and Certificates Based on OpenSSL                                                        
**palmerpenguins**        0.1.0          Palmer Archipelago (Antarctica) Penguin Data                                                                                
**patchwork**             1.1.1          The Composer of Plots                                                                                                       
**pdftools**              3.0.1          Text Extraction, Rendering and Converting of PDF Documents                                                                  
**pdist**                 1.2            Partitioned Distance Function                                                                                               
**pillar**                1.6.3          Coloured Formatting for Columns                                                                                             
**pkgbuild**              1.2.0          Find Tools Needed to Build R Packages                                                                                       
**pkgconfig**             2.0.3          Private Configuration for R Packages                                                                                        
**pkgload**               1.2.2          Simulate Package Installation and Attach                                                                                    
**plogr**                 0.2.0          The plog C++ Logging Library                                                                                                
**plotly**                4.9.4.1        Create Interactive Web Graphics via plotly.js                                                                               
**plyr**                  1.8.6          Tools for Splitting, Applying and Combining Data                                                                            
**png**                   0.1-7          Read and write PNG images                                                                                                   
**polynom**               1.4-0          A Collection of Functions to Implement a Class for Univariate Polynomial Manipulations                                      
**posterior**             1.1.0          Tools for Working with Posterior Distributions                                                                              
**prettydoc**             0.4.1          Creating Pretty Documents from R Markdown                                                                                   
**PrevMap**               1.5.3          Geostatistical Modelling of Spatially Referenced Prevalence Data                                                            
**processx**              3.5.2          Execute and Control System Processes                                                                                        
**productplots**          0.1.1          Product Plots for R                                                                                                         
**progress**              1.2.2          Terminal Progress Bars                                                                                                      
**projpred**              2.0.2          Projection Predictive Feature Selection                                                                                     
**promises**              1.2.0.1        Abstractions for Promise-Based Asynchronous Programming                                                                     
**pspearman**             0.3-0          Spearman's rank correlation test                                                                                            
**purrr**                 0.3.4          Functional Programming Tools                                                                                                
**pwr**                   1.3-0          Basic Functions for Power Analysis                                                                                          
**qpdf**                  1.1            Split, Combine and Compress PDF Files                                                                                       
**quadprog**              1.5-8          Functions to Solve Quadratic Programming Problems                                                                           
**quantmod**              0.4.18         Quantitative Financial Modelling Framework                                                                                  
**quantreg**              5.86           Quantile Regression                                                                                                         
**r2d3**                  0.2.5          Interface to 'D3' Visualizations                                                                                            
**R6**                    2.5.1          Encapsulated Classes with Reference Semantics                                                                               
**RandomFields**          3.3.10         Simulation and Analysis of Random Fields                                                                                    
**rappdirs**              0.3.3          Application Directories: Determine Where to Save Data, Caches, and Logs                                                     
**raster**                3.4-13         Geographic Data Analysis and Modeling                                                                                       
**rasterly**              0.2.0          Easily and Rapidly Generate Raster Image Data with Support for 'Plotly.js'                                                  
**rasterVis**             0.50.3         Visualization Methods for Raster Data                                                                                       
**rcmdcheck**             1.4.0          Run 'R CMD check' from R and Capture Results                                                                                
**RColorBrewer**          1.1-2          ColorBrewer Palettes                                                                                                        
**Rcpp**                  1.0.7          Seamless R and C++ Integration                                                                                              
**RcppArmadillo**         0.10.7.0.0     Rcpp Integration for the Armadillo Templated Linear Algebra Library                                                         
**RcppEigen**             0.3.3.9.1      Rcpp Integration for the Eigen Templated Linear Algebra Library                                                             
**RcppParallel**          5.1.4          Parallel Programming Tools for Rcpp                                                                                         
**reactable**             0.2.3          Interactive Data Tables Based on 'React Table'                                                                              
**reactR**                0.4.4          React Helpers                                                                                                               
**readr**                 2.0.2          Read Rectangular Text Data                                                                                                  
**readxl**                1.3.1          Read Excel Files                                                                                                            
**registry**              0.5-1          Infrastructure for R Package Registries                                                                                     
**remotes**               2.4.1          R Package Installation from Remote Repositories, Including 'GitHub'                                                         
**reprex**                2.0.1          Prepare Reproducible Example Code via the Clipboard                                                                         
**reshape2**              1.4.4          Flexibly Reshape Data: A Reboot of the Reshape Package                                                                      
**reticulate**            1.22           Interface to Python                                                                                                         
**rgdal**                 1.5-27         Bindings for the Geospatial Data Abstraction Library                                                                        
**rgeos**                 0.5-8          Interface to Geometry Engine - Open Source ('GEOS')                                                                         
**rjson**                 0.2.20         JSON for R                                                                                                                  
**rlang**                 0.4.11         Functions for Base Types and Core R and Tidyverse Features                                                                  
**rlist**                 0.4.6.2        A Toolbox for Non-Tabular Data Manipulation                                                                                 
**rmarkdown**             2.11           Dynamic Documents for R                                                                                                     
**ROI**                   1.0-0          R Optimization Infrastructure                                                                                               
**ROI.plugin.alabama**    1.0-0          'alabama' Plug-in for the R Optimization Infrastructure                                                                     
**ROI.plugin.lpsolve**    1.0-1          'lp_solve' Plugin for the R Optimization Infrastructure                                                                     
**ROI.plugin.nloptr**     1.0-0          'nloptr' Plug-in for the R Optimization Infrastructure                                                                      
**ROI.plugin.quadprog**   1.0-0          'quadprog' Plug-in for the R Optimization Infrastructure                                                                    
**rootSolve**             1.8.2.3        Nonlinear Root Finding, Equilibrium and Steady-State Analysis of Ordinary Differential Equations                            
**roxygen2**              7.1.2          In-Line Documentation for R                                                                                                 
**rprojroot**             2.0.2          Finding Files in Project Subdirectories                                                                                     
**RSQLite**               2.2.8          'SQLite' Interface for R                                                                                                    
**rstan**                 2.21.2         R Interface to Stan                                                                                                         
**rstantools**            2.1.1          Tools for Developing R Packages Interfacing with Stan                                                                       
**rstatix**               0.7.0          Pipe-Friendly Framework for Basic Statistical Tests                                                                         
**rstudioapi**            0.13           Safely Access the RStudio API                                                                                               
**Rttf2pt1**              1.3.9          'ttf2pt1' Program                                                                                                           
**rversions**             2.1.1          Query R Versions, Including 'r-release' and 'r-oldrel'                                                                      
**rvest**                 1.0.1          Easily Harvest (Scrape) Web Pages                                                                                           
**s2**                    1.0.7          Spherical Geometry Operators Using the S2 Geometry Library                                                                  
**sass**                  0.4.0          Syntactically Awesome Style Sheets ('Sass')                                                                                 
**scales**                1.1.1          Scale Functions for Visualization                                                                                           
**scatterplot3d**         0.3-41         3D Scatter Plot                                                                                                             
**seriation**             1.3.0          Infrastructure for Ordering Objects Using Seriation                                                                         
**sessioninfo**           1.1.1          R Session Information                                                                                                       
**sf**                    1.0-2          Simple Features for R                                                                                                       
**shape**                 1.4.6          Functions for Plotting Graphical Shapes, Colors                                                                             
**shiny**                 1.7.1          Web Application Framework for R                                                                                             
**shinystan**             2.5.0          Interactive Visual and Numerical Diagnostics and Posterior Analysis for Bayesian Models                                     
**showtext**              0.9-4          Using Fonts More Easily in R Graphs                                                                                         
**showtextdb**            3.0            Font Files for the 'showtext' Package                                                                                       
**slam**                  0.1-48         Sparse Lightweight Arrays and Matrices                                                                                      
**sm**                    2.2-5.7        Smoothing Methods for Nonparametric Regression and Density Estimation                                                       
**sourcetools**           0.1.7          Tools for Reading, Tokenizing and Parsing R Code                                                                            
**sp**                    1.4-5          Classes and Methods for Spatial Data                                                                                        
**sparkline**             2.0            'jQuery' Sparkline 'htmlwidget'                                                                                             
**sparklyr**              1.7.2          R Interface to Apache Spark                                                                                                 
**SparseM**               1.81           Sparse Linear Algebra                                                                                                       
**splancs**               2.01-42        Spatial and Space-Time Point Pattern Analysis                                                                               
**splines2**              0.4.5          Regression Spline Functions and Classes                                                                                     
**StanHeaders**           2.21.0-7       C++ Header Files for Stan                                                                                                   
**stringi**               1.7.5          Character String Processing Facilities                                                                                      
**stringr**               1.4.0          Simple, Consistent Wrappers for Common String Operations                                                                    
**SuppDists**             1.1-9.5        Supplementary Distributions                                                                                                 
**survival**              3.2-13         Survival Analysis                                                                                                           
**svglite**               2.0.0          An 'SVG' Graphics Device                                                                                                    
**symengine**             0.1.5          Interface to the 'SymEngine' Library                                                                                        
**sysfonts**              0.8.5          Loading Fonts into R                                                                                                        
**tensorflow**            2.6.0          R Interface to 'TensorFlow'                                                                                                 
**terra**                 1.4-7          Spatial Data Analysis                                                                                                       
**testthat**              3.1.0          Unit Testing for R                                                                                                          
**tfautograph**           0.3.2          Autograph R for 'Tensorflow'                                                                                                
**tfruns**                1.5.0          Training Run Tools for 'TensorFlow'                                                                                         
**tibble**                3.1.5          Simple Data Frames                                                                                                          
**tidyr**                 1.1.4          Tidy Messy Data                                                                                                             
**tidyselect**            1.1.1          Select from a Set of Strings                                                                                                
**tidyverse**             1.3.1          Easily Install and Load the Tidyverse                                                                                       
**tikzDevice**            0.12.3.1       R Graphics Output in LaTeX Format                                                                                           
**timeline**              0.9            Timelines for a Grammar of Graphics                                                                                         
**timelineS**             0.1.1          Timeline and Time Duration-Related Tools                                                                                    
**tint**                  0.1.3          'tint' is not 'Tufte'                                                                                                       
**tinytex**               0.34           Helper Functions to Install and Maintain TeX Live, and Compile LaTeX Documents                                              
**TMB**                   1.7.22         Template Model Builder: A General Random Effect Tool Inspired by ADMB                                                       
**transformr**            0.1.3          Polygon and Path Transformations                                                                                            
**treemap**               2.4-3          Treemap Visualization                                                                                                       
**treemapify**            2.5.5          Draw Treemaps in ggplot2                                                                                                    
**truncnorm**             1.0-8          Truncated Normal Distribution                                                                                               
**TSP**                   1.1-10         Traveling Salesperson Problem (TSP)                                                                                         
**tweenr**                1.0.2          Interpolate Data for Smooth Animations                                                                                      
**units**                 0.7-2          Measurement Units for R Vectors                                                                                             
**usethis**               2.0.1          Automate Package and Project Setup                                                                                          
**uuid**                  0.1-4          Tools for Generating and Handling of UUIDs                                                                                  
**V8**                    3.4.2          Embedded JavaScript and WebAssembly Engine for R                                                                            
**vctrs**                 0.3.8          Vector Helpers                                                                                                              
**vioplot**               0.3.7          Violin Plot                                                                                                                 
**vipor**                 0.4.5          Plot Categorical Data Using Quasirandom Noise and Density Estimates                                                         
**viridis**               0.6.1          Colorblind-Friendly Color Maps for R                                                                                        
**viridisLite**           0.4.0          Colorblind-Friendly Color Maps (Lite Version)                                                                               
**visNetwork**            2.1.0          Network Visualization using 'vis.js' Library                                                                                
**vistime**               1.2.1          Pretty Timelines in R                                                                                                       
**webshot**               0.5.2          Take Screenshots of Web Pages                                                                                               
**withr**                 2.4.2          Run Code With Temporarily Modified Global State                                                                             
**xfun**                  0.26           Supporting Functions for Packages Maintained by Yihui Xie                                                                   
**xgboost**               1.4.1.1        Extreme Gradient Boosting                                                                                                   
**xkcd**                  0.0.6          Plotting ggplot2 Graphics in an XKCD Style                                                                                  
**xml2**                  1.3.2          Parse XML                                                                                                                   
**xtable**                1.8-4          Export Tables to LaTeX or HTML                                                                                              
**xts**                   0.12.1         eXtensible Time Series                                                                                                      
**yaml**                  2.2.1          Methods to Convert R Data to YAML and Back                                                                                  
**zoo**                   1.8-9          S3 Infrastructure for Regular and Irregular Time Series (Z's Ordered Observations)                                          

::: {.rmdtip data-latex="{提示}"}
本书意欲覆盖的内容
:::


```r
inla_pdb <- data.frame(
  Package = "INLA",
  Title = paste(
    "Full Bayesian Analysis of Latent Gaussian Models",
    "using Integrated Nested Laplace Approximations"
  )
)
pkgs <- c(
  "ggplot2", "cowplot", "patchwork", "rgl", "MASS", "nlme", "mgcv",
  "lme4", "gee", "gam", "gamm4", "cgam", "cglm", "pscl",
  "GLMMadaptive", "gee4", "geoR", "LaplacesDemon", "glmnet",
  "betareg", "quantreg", "agridat", "moments", "R2BayesX",
  "geoRglm", "spaMM", "spBayes", "CARBayes", "PrevMap",
  "FRK", "lgcp", "HSAR", "spNNGP", "MuMIn", "BANOVA",
  "rpql", "QGglmm", "glmmsr", "glmmboot", "glmm",
  "glmmML", "glmmEP", "r2glmm", "hglm", "glmmLasso",
  "blme", "MCMCglmm", "MCMCpack", "glmmTMB", "geepack",
  "glmmfields", "rstan", "rstanarm", "brms", "greta",
  "BayesX", "Boom", "nimble", "rjags", "R2OpenBUGS",
  "R2BayesX", "BoomSpikeSlab", "inlabru", "INLABMA",
  "lmtest", "VGAM", "plotly", "leaflet", "LatticeKrig"
)
pdb <- tools::CRAN_package_db()
book_pdb <- subset(pdb,
  subset = !duplicated(pdb$Package) & Package %in% pkgs,
  select = c("Package", "Title")
)
book_pdb <- rbind.data.frame(book_pdb, inla_pdb)
book_pdb$Title <- gsub("(\\\n)", " ", book_pdb$Title)
book_pdb$Title <- gsub("'(Armadillo|BayesX|Eigen|ggplot2|lme4|mgcv|Stan|Leaflet|plotly.js)'", "\\1", book_pdb$Title)
book_pdb$Package <- paste("**", book_pdb$Package, "**", sep = "")
knitr::kable(book_pdb,
  caption = "本书使用的 R 包", format = "pandoc",
  booktabs = TRUE, row.names = FALSE
)
```



Table: (\#tab:book-pkgs)本书使用的 R 包

Package             Title                                                                                           
------------------  ------------------------------------------------------------------------------------------------
**agridat**         Agricultural Datasets                                                                           
**BANOVA**          Hierarchical Bayesian ANOVA Models                                                              
**BayesX**          R Utilities Accompanying the Software Package BayesX                                            
**betareg**         Beta Regression                                                                                 
**blme**            Bayesian Linear Mixed-Effects Models                                                            
**Boom**            Bayesian Object Oriented Modeling                                                               
**BoomSpikeSlab**   MCMC for Spike and Slab Regression                                                              
**brms**            Bayesian Regression Models using Stan                                                           
**CARBayes**        Spatial Generalised Linear Mixed Models for Areal Unit Data                                     
**cgam**            Constrained Generalized Additive Model                                                          
**cglm**            Fits Conditional Generalized Linear Models                                                      
**cowplot**         Streamlined Plot Theme and Plot Annotations for ggplot2                                         
**FRK**             Fixed Rank Kriging                                                                              
**gam**             Generalized Additive Models                                                                     
**gamm4**           Generalized Additive Mixed Models using mgcv and lme4                                           
**gee**             Generalized Estimation Equation Solver                                                          
**geepack**         Generalized Estimating Equation Package                                                         
**geoR**            Analysis of Geostatistical Data                                                                 
**ggplot2**         Create Elegant Data Visualisations Using the Grammar of Graphics                                
**glmm**            Generalized Linear Mixed Models via Monte Carlo Likelihood Approximation                        
**GLMMadaptive**    Generalized Linear Mixed Models using Adaptive Gaussian Quadrature                              
**glmmEP**          Generalized Linear Mixed Model Analysis via Expectation Propagation                             
**glmmfields**      Generalized Linear Mixed Models with Robust Random Fields for Spatiotemporal Modeling           
**glmmLasso**       Variable Selection for Generalized Linear Mixed Models by L1-Penalized Estimation               
**glmmML**          Generalized Linear Models with Clustering                                                       
**glmmsr**          Fit a Generalized Linear Mixed Model                                                            
**glmmTMB**         Generalized Linear Mixed Models using Template Model Builder                                    
**glmnet**          Lasso and Elastic-Net Regularized Generalized Linear Models                                     
**greta**           Simple and Scalable Statistical Modelling in R                                                  
**hglm**            Hierarchical Generalized Linear Models                                                          
**HSAR**            Hierarchical Spatial Autoregressive Model                                                       
**INLABMA**         Bayesian Model Averaging with INLA                                                              
**inlabru**         Bayesian Latent Gaussian Modelling using INLA and Extensions                                    
**LaplacesDemon**   Complete Environment for Bayesian Inference                                                     
**LatticeKrig**     Multi-Resolution Kriging Based on Markov Random Fields                                          
**leaflet**         Create Interactive Web Maps with the JavaScript Leaflet Library                                 
**lgcp**            Log-Gaussian Cox Process                                                                        
**lme4**            Linear Mixed-Effects Models using Eigen and S4                                                  
**lmtest**          Testing Linear Regression Models                                                                
**MASS**            Support Functions and Datasets for Venables and Ripley's MASS                                   
**MCMCglmm**        MCMC Generalised Linear Mixed Models                                                            
**MCMCpack**        Markov Chain Monte Carlo (MCMC) Package                                                         
**mgcv**            Mixed GAM Computation Vehicle with Automatic Smoothness Estimation                              
**moments**         Moments, cumulants, skewness, kurtosis and related tests                                        
**MuMIn**           Multi-Model Inference                                                                           
**nimble**          MCMC, Particle Filtering, and Programmable Hierarchical Modeling                                
**nlme**            Linear and Nonlinear Mixed Effects Models                                                       
**patchwork**       The Composer of Plots                                                                           
**plotly**          Create Interactive Web Graphics via plotly.js                                                   
**PrevMap**         Geostatistical Modelling of Spatially Referenced Prevalence Data                                
**pscl**            Political Science Computational Laboratory                                                      
**QGglmm**          Estimate Quantitative Genetics Parameters from Generalised Linear Mixed Models                  
**quantreg**        Quantile Regression                                                                             
**r2glmm**          Computes R Squared for Mixed (Multilevel) Models                                                
**R2OpenBUGS**      Running OpenBUGS from R                                                                         
**rgl**             3D Visualization Using OpenGL                                                                   
**rjags**           Bayesian Graphical Models using MCMC                                                            
**rpql**            Regularized PQL for Joint Selection in GLMMs                                                    
**rstan**           R Interface to Stan                                                                             
**rstanarm**        Bayesian Applied Regression Modeling via Stan                                                   
**spaMM**           Mixed-Effect Models, with or without Spatial Random Effects                                     
**spBayes**         Univariate and Multivariate Spatial-Temporal Modeling                                           
**spNNGP**          Spatial Regression Models for Large Datasets using Nearest Neighbor Gaussian Processes          
**VGAM**            Vector Generalized Linear and Additive Models                                                   
**INLA**            Full Bayesian Analysis of Latent Gaussian Models using Integrated Nested Laplace Approximations 

