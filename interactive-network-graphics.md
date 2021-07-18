# 交互网络图形 {#chap:dynamic-network-visualization}

## 网络分析 {#sec:network-analysis}


```r
library(igraph)
```


## 交互图形 {#sec:javascript-network}

### networkD3 {#subsec:networkD3}

[networkD3](https://github.com/christophergandrud/networkD3) [D3](https://github.com/d3/d3) 非常适合绘制网络图，如网络、树状、桑基图


```r
library(networkD3)
data(MisLinks, MisNodes) # 加载数据
head(MisLinks) # 边
```

```
##   source target value
## 1      1      0     1
## 2      2      0     8
## 3      3      0    10
## 4      3      2     6
## 5      4      0     1
## 6      5      0     1
```

```r
head(MisNodes) # 节点
```

```
##              name group size
## 1          Myriel     1   15
## 2        Napoleon     1   20
## 3 Mlle.Baptistine     1   23
## 4    Mme.Magloire     1   30
## 5    CountessdeLo     1   11
## 6        Geborand     1    9
```

构造网络图


```r
forceNetwork(
  Links = MisLinks, Nodes = MisNodes, Source = "source",
  Target = "target", Value = "value", NodeID = "name",
  Group = "group", opacity = 0.4
)
```

### visNetwork {#subsec:visNetwork}

[visNetwork](https://github.com/datastorm-open/visNetwork) 使用 [vis-network.js](https://github.com/visjs/vis-network) 库绘制网络关系图 <https://datastorm-open.github.io/visNetwork>


```r
library(visNetwork)
```

调用函数 `visTree()` 可视化分类模型结果


```r
library(rpart)
library(sparkline) # 函数 visTree 需要导入 sparkline 包
res <- rpart(Species~., data=iris)
visTree(res, main = "鸢尾花分类树", width = "100%")
```



\begin{center}\includegraphics{interactive-network-graphics_files/figure-latex/unnamed-chunk-5-1} \end{center}

节点、边的属性都可以映射数据指标

### r2d3 {#subsec:r2d3}

[D3](https://d3js.org/) 是非常流行的 JavaScript 库，[r2d3](https://github.com/rstudio/r2d3) 提供了 R 接口

<!-- 介绍网络图的做法 -->


```r
library(r2d3)
```

