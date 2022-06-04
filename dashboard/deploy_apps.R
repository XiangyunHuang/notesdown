# 安装 Shiny App 依赖的 R 包
source("install_deps.R")
# 全局设置字符串不要转为因子类型
options(stringsAsFactors = FALSE)

# 配置 Shiny Server 账户
rsconnect::setAccountInfo(
  name = "xiangyun",
  token = Sys.getenv("SHINY_TOKEN"),
  secret = Sys.getenv("SHINY_SECRET")
)
# app 路径
app_paths <- list.files(path = ".", recursive = T, pattern = "app.R")
# app 目录
app_dirs <- dirname(app_paths)

# 部署成功，存一份 app 的 md5 码
# 本地修改某些 app
# 远程读取 md5 文件，和当前生成的 md5 比对，找到改动的 app 文件
# 重新部署改动的 app

# 新增/更新一个 app 的情况
new_app_md5 <- data.frame(app_md5 = tools::md5sum(app_paths), row.names = app_dirs)
# 之前的部署记录
old_app_md5 <- read.table(file = "app-md5.csv")
# 待更新的 App
new_app_dirs <- app_dirs[!new_app_md5[, "app_md5"] == old_app_md5[, "app_md5"]]

## 更新部署
if (length(new_app_dirs) >= 1) {
  new_app_names <- paste("notesdown", new_app_dirs, sep = "-")
  # 部署新的 Shiny App
  for (i in 1:length(new_app_dirs)) {
    rsconnect::deployApp(appDir = new_app_dirs[i], appName = new_app_names[i])
  }
}

# 部署成功后，本地运行下面两行代码更新 md5 码
# renew_app_md5 <- data.frame(app_md5 = tools::md5sum(app_paths), row.names = app_dirs)
# write.table(renew_app_md5, file = "app-md5.csv", row.names = T, quote = F, col.names = TRUE)


# 在容器里运行 Shiny App
#
# ```bash
# docker pull xiangyunhuang/r-shiny
# docker run -it --name=r-shiny-demo -d xiangyunhuang/r-shiny
# docker exec -it -v /data/huangxiangyun/demo:/home/docker r-shiny-demo Rscript -e 'shiny::shinyAppDir(appDir = "hist")'
# ```
