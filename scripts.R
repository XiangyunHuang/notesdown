library(gert)
library(ggplot2)
git_config_set("user.name", "XiangyunHuang")
git_config_set("user.email", "xiangyunfaith@outlook.com")

showtext::showtext_auto()
dat <- git_log(max = 1000)

dat <- transform(dat,
                 date = format(time, "%Y-%m-%d"),
                 year = format(time, "%Y"),
                 month = format(time, "%m"),
                 weekday = format(time, "%a"),
                 week = as.integer(format(time, "%W"))
)

dat1 <- aggregate(x = commit ~ year + month, data = dat, FUN = length)

# 条形图
ggplot(data = dat1, aes(x = month, y = commit, fill = year)) +
  geom_bar(stat = "identity", position = "identity")

# 日历图
dat2 <- aggregate(x = commit ~ year + week + weekday, data = dat, FUN = length)
dat2 <- transform(dat2, colorBin = cut(commit, breaks = c(0, 5, 10, 15, 20, 25)))

ggplot(data = dat2, aes(x = week, y = weekday, fill = colorBin)) +
  scale_fill_brewer(name = "commit", palette = "Greens") +
  geom_tile(color = "white", size = 0.4) +
  facet_wrap("year", ncol = 1) +
  scale_x_continuous(
    breaks = seq(1, 52, length = 12),
    labels = month.abb
  ) +
  labs(x = "", y = "") +
  coord_fixed(expand = F) +
  theme_bw()
