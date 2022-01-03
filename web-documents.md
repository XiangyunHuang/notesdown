# 网页文档 {#chap-web-documents}

丘怡轩开发的 [prettydoc](https://github.com/yixuan/prettydoc) 包提供了一系列模版，方便快速提高网页逼格。另有 Atsushi Yasumoto 开发的 [minidown](https://github.com/atusy/minidown) 包非常轻量，但是常用功能都覆盖了。

## 幻灯片 {#sec-slides}

谢益辉开发的 [xaringan](https://github.com/yihui/xaringan) 用于制作网页幻灯片，
[xaringanthemer](https://github.com/gadenbuie/xaringanthemer) 为 xaringan 提供主题定制，
[xaringanExtra](https://github.com/gadenbuie/xaringanExtra) 在 xaringan 之上提供各种功能扩展，
[xaringanBuilder](https://github.com/jhelvy/xaringanBuilder) 为 xaringan 提供多种输出格式。


## 电子邮件 {#sec-emails}

[^blastula-group-emails]: <https://thecoatlessprofessor.com/programming/r/sending-an-email-from-r-with-blastula-to-groups-of-students/>

[emayili](https://github.com/datawookie/emayili) 是非常轻量的实现邮件发送的 R 包，其它功能类似的 R 包有 [blastula](https://github.com/rich-iannone/blastula) [mailR](https://github.com/rpremraj/mailR)。Rahul Premraj 基于 rJava 开发的 [mailR](https://github.com/rpremraj/mailR) 虽然还未在 CRAN 上正式发布，但是已得到很多人的关注，也被广泛的使用，目前作者已经不维护了，继续使用有一定风险。 RStudio 公司 Richard Iannone 新开发的 [blastula](https://github.com/rich-iannone/blastula) 扔掉了 Java 的重依赖，更加轻量化、现代化，支持发送群组邮件[^blastula-group-emails]。 [curl](https://github.com/jeroen/curl) 包提供的函数 `send_mail()` 本质上是在利用 [curl](https://curl.haxx.se/) 软件发送邮件，举个例子，邮件内容如下：

```
From: "黄湘云" <邮箱地址>
To: "黄湘云" <邮箱地址>
Subject: 测试邮件

你好：

这是一封测试邮件！
```

将邮件内容保存为 mail.txt 文件，然后使用 curl 命令行工具将邮件内容发出去。


```bash
curl --url 'smtp://公司邮件服务器地址:开放的端口号' \
  --ssl-reqd --mail-from '发件人邮箱地址' \
  --mail-rcpt '收件人邮箱地址' \
  --upload-file data/mail.txt \
  --user '发件人邮箱地址:邮箱登陆密码'
```

::: {.rmdnote data-latex="{注意}"}
Gmail 出于安全性考虑，不支持这种发送邮件的方式，会将邮件内容阻挡，进而接收不到邮件。 
:::

下面以 blastula 包为例怎么支持 Gmail/Outlook/QQ 等邮件发送，先安装系统软件依赖，CentOS 8 上安装依赖

```bash
sudo dnf install -y libsecret-devel libsodium-devel
```

然后安装 [**keyring**]() 和 [**blastula**]()


```r
install.packages(c("keyring", "blastula"))
```

接着配置邮件帐户，这一步需要邮件账户名和登陆密码，配置一次就够了，不需要每次发送邮件的时候都配置一次


```r
library(blastula)
create_smtp_creds_key(
  id = "outlook", 
  user = "xiangyunfaith@outlook.com",
  provider = "outlook"
)
```

第二步，准备邮件内容，包括邮件主题、发件人、收件人、抄送人、密送人、邮件主体和附件等。


```r
attachment <- "data/mail.txt" # 如果没有附件，引号内留空即可。
# 这个Rmd文件渲染后就是邮件的正文，交互图形和交互表格不适用
body <- "examples/html-document.Rmd" 
# 渲染邮件内容，生成预览
email <- render_email(body) |> 
  add_attachment(file = attachment)
email
```

最后，发送邮件


```r
smtp_send(
  from = c("张三" = "xxx@outlook.com"), # 发件人
  to = c("李四" = "xxx@foxmail.com",
         "王五" = "xxx@gmail.com"), # 收件人
  cc = c("赵六" = "xxx@outlook.com"), # 抄送人
  subject = "这是一封测试邮件",
  email = email,
  credentials = creds_key(id = "outlook")
)
```

密送人实现群发单显，即一封邮件同时发送给多个人，每个收件人只能看到发件人地址而看不到其它收件人地址。

```r
email <- compose_email(
  body = md("
Markdown 格式的邮件内容
")
)

smtp_send(
  from = c("发件人" = "xx@outlook.com"),
  to = c("收件人" = "xx@outlook.com"),
  bcc = c(
    "抄送人" = "xx@outlook.com"
    ),
  subject = "邮件主题",
  email = email,
  credentials = creds_key(id = "outlook")
)
```

