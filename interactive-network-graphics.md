# 交互式网络图形 {#chap:network}

[networkD3](https://github.com/christophergandrud/networkD3) 非常适合绘制网络图


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
forceNetwork(Links = MisLinks, Nodes = MisNodes, Source = "source",
             Target = "target", Value = "value", NodeID = "name",
             Group = "group", opacity = 0.4)
```

```{=html}
<div id="htmlwidget-eb2c3d558a615966cfc8" style="width:672px;height:480px;" class="forceNetwork html-widget"></div>
<script type="application/json" data-for="htmlwidget-eb2c3d558a615966cfc8">{"x":{"links":{"source":[1,2,3,3,4,5,6,7,8,9,11,11,11,11,12,13,14,15,17,18,18,19,19,19,20,20,20,20,21,21,21,21,21,22,22,22,22,22,22,23,23,23,23,23,23,23,23,23,24,24,25,25,25,26,26,26,26,27,27,27,27,27,28,28,29,29,29,30,31,31,31,31,32,33,33,34,34,35,35,35,36,36,36,36,37,37,37,37,37,38,38,38,38,38,38,39,40,41,41,42,42,42,43,43,43,44,44,45,47,48,48,48,48,49,49,50,50,51,51,51,52,52,53,54,54,54,55,55,55,55,55,55,55,55,55,55,56,56,57,57,57,58,58,58,58,58,59,59,59,59,60,60,60,61,61,61,61,61,61,62,62,62,62,62,62,62,62,63,63,63,63,63,63,63,63,64,64,64,64,64,64,64,64,64,64,65,65,65,65,65,65,65,65,65,65,66,66,66,66,66,66,66,66,66,67,68,68,68,68,68,68,69,69,69,69,69,69,69,70,70,70,70,70,70,70,70,71,71,71,71,71,71,71,71,72,72,72,73,74,74,75,75,75,75,75,75,75,76,76,76,76,76,76,76],"target":[0,0,0,2,0,0,0,0,0,0,10,3,2,0,11,11,11,11,16,16,17,16,17,18,16,17,18,19,16,17,18,19,20,16,17,18,19,20,21,16,17,18,19,20,21,22,12,11,23,11,24,23,11,24,11,16,25,11,23,25,24,26,11,27,23,27,11,23,30,11,23,27,11,11,27,11,29,11,34,29,34,35,11,29,34,35,36,11,29,34,35,36,37,11,29,25,25,24,25,41,25,24,11,26,27,28,11,28,46,47,25,27,11,26,11,49,24,49,26,11,51,39,51,51,49,26,51,49,39,54,26,11,16,25,41,48,49,55,55,41,48,55,48,27,57,11,58,55,48,57,48,58,59,48,58,60,59,57,55,55,58,59,48,57,41,61,60,59,48,62,57,58,61,60,55,55,62,48,63,58,61,60,59,57,11,63,64,48,62,58,61,60,59,57,55,64,58,59,62,65,48,63,61,60,57,25,11,24,27,48,41,25,68,11,24,27,48,41,25,69,68,11,24,27,41,58,27,69,68,70,11,48,41,25,26,27,11,48,48,73,69,68,25,48,41,70,71,64,65,66,63,62,48,58],"value":[1,8,10,6,1,1,1,1,2,1,1,3,3,5,1,1,1,1,4,4,4,4,4,4,3,3,3,4,3,3,3,3,5,3,3,3,3,4,4,3,3,3,3,4,4,4,2,9,2,7,13,1,12,4,31,1,1,17,5,5,1,1,8,1,1,1,2,1,2,3,2,1,1,2,1,3,2,3,3,2,2,2,2,1,2,2,2,2,1,2,2,2,2,2,1,1,1,2,3,2,2,1,3,1,1,3,1,2,1,2,1,1,1,3,2,1,1,9,2,2,1,1,1,2,1,1,6,12,1,1,21,19,1,2,5,4,1,1,1,1,1,7,7,6,1,4,15,5,6,2,1,4,2,2,6,2,5,1,1,9,17,13,7,2,1,6,3,5,5,6,2,4,3,2,1,5,12,5,4,10,6,2,9,1,1,5,7,3,5,5,5,2,5,1,2,3,3,1,2,2,1,1,1,1,3,5,1,1,1,1,1,6,6,1,1,2,1,1,4,4,4,1,1,1,1,1,1,2,2,2,1,1,1,1,2,1,1,2,2,3,3,3,3,1,1,1,1,1,1,1,1,1,1,1],"colour":["#666","#666","#666","#666","#666","#666","#666","#666","#666","#666","#666","#666","#666","#666","#666","#666","#666","#666","#666","#666","#666","#666","#666","#666","#666","#666","#666","#666","#666","#666","#666","#666","#666","#666","#666","#666","#666","#666","#666","#666","#666","#666","#666","#666","#666","#666","#666","#666","#666","#666","#666","#666","#666","#666","#666","#666","#666","#666","#666","#666","#666","#666","#666","#666","#666","#666","#666","#666","#666","#666","#666","#666","#666","#666","#666","#666","#666","#666","#666","#666","#666","#666","#666","#666","#666","#666","#666","#666","#666","#666","#666","#666","#666","#666","#666","#666","#666","#666","#666","#666","#666","#666","#666","#666","#666","#666","#666","#666","#666","#666","#666","#666","#666","#666","#666","#666","#666","#666","#666","#666","#666","#666","#666","#666","#666","#666","#666","#666","#666","#666","#666","#666","#666","#666","#666","#666","#666","#666","#666","#666","#666","#666","#666","#666","#666","#666","#666","#666","#666","#666","#666","#666","#666","#666","#666","#666","#666","#666","#666","#666","#666","#666","#666","#666","#666","#666","#666","#666","#666","#666","#666","#666","#666","#666","#666","#666","#666","#666","#666","#666","#666","#666","#666","#666","#666","#666","#666","#666","#666","#666","#666","#666","#666","#666","#666","#666","#666","#666","#666","#666","#666","#666","#666","#666","#666","#666","#666","#666","#666","#666","#666","#666","#666","#666","#666","#666","#666","#666","#666","#666","#666","#666","#666","#666","#666","#666","#666","#666","#666","#666","#666","#666","#666","#666","#666","#666","#666","#666","#666","#666","#666","#666","#666","#666","#666","#666","#666","#666","#666","#666","#666","#666","#666","#666"]},"nodes":{"name":["Myriel","Napoleon","Mlle.Baptistine","Mme.Magloire","CountessdeLo","Geborand","Champtercier","Cravatte","Count","OldMan","Labarre","Valjean","Marguerite","Mme.deR","Isabeau","Gervais","Tholomyes","Listolier","Fameuil","Blacheville","Favourite","Dahlia","Zephine","Fantine","Mme.Thenardier","Thenardier","Cosette","Javert","Fauchelevent","Bamatabois","Perpetue","Simplice","Scaufflaire","Woman1","Judge","Champmathieu","Brevet","Chenildieu","Cochepaille","Pontmercy","Boulatruelle","Eponine","Anzelma","Woman2","MotherInnocent","Gribier","Jondrette","Mme.Burgon","Gavroche","Gillenormand","Magnon","Mlle.Gillenormand","Mme.Pontmercy","Mlle.Vaubois","Lt.Gillenormand","Marius","BaronessT","Mabeuf","Enjolras","Combeferre","Prouvaire","Feuilly","Courfeyrac","Bahorel","Bossuet","Joly","Grantaire","MotherPlutarch","Gueulemer","Babet","Claquesous","Montparnasse","Toussaint","Child1","Child2","Brujon","Mme.Hucheloup"],"group":[1,1,1,1,1,1,1,1,1,1,2,2,3,2,2,2,3,3,3,3,3,3,3,3,4,4,5,4,0,2,3,2,2,2,2,2,2,2,2,4,6,4,4,5,0,0,7,7,8,5,5,5,5,5,5,8,5,8,8,8,8,8,8,8,8,8,8,9,4,4,4,4,5,10,10,4,8]},"options":{"NodeID":"name","Group":"group","colourScale":"d3.scaleOrdinal(d3.schemeCategory20);","fontSize":7,"fontFamily":"serif","clickTextSize":17.5,"linkDistance":50,"linkWidth":"function(d) { return Math.sqrt(d.value); }","charge":-30,"opacity":0.4,"zoom":false,"legend":false,"arrows":false,"nodesize":false,"radiusCalculation":" Math.sqrt(d.nodesize)+6","bounded":false,"opacityNoHover":0,"clickAction":null}},"evals":[],"jsHooks":[]}</script>
```

[visNetwork](https://github.com/datastorm-open/visNetwork) 使用 vis.js 库绘制网络关系图 <https://datastorm-open.github.io/visNetwork>


```r
library(visNetwork)
```

可视化分类模型结果


```r
library(rpart)
library(sparkline) # 函数 visTree 需要导入 sparkline 包
res <- rpart(Species~., data=iris)
visTree(res, main = "鸢尾花分类树", width = "100%")
```

```{=html}
<div id="htmlwidget-010ed171e98aac66f022" style="width:100%;height:600px;" class="visNetwork html-widget"></div>
<script type="application/json" data-for="htmlwidget-010ed171e98aac66f022">{"x":{"nodes":{"id":[1,2,3,6,7],"label":["Petal.Length","setosa","Petal.Width","versicolor","virginica"],"level":[1,2,2,3,3],"color":["#F1B8C2","#7D91B6","#B4C7ED","#AC83AE","#B9828C"],"value":[150,50,100,54,46],"shape":["dot","square","dot","square","square"],"title":["<div style=\"text-align:center;\">N : <b>100%<\/b> (150)<br>Complexity : <b>0.5<\/b><br>setosa : <b>33.3%<\/b> (50)<br>versicolor : <b>33.3%<\/b> (50)<br>virginica : <b>33.3%<\/b> (50)<\/div>","<div style=\"text-align:center;\">N : <b>33.3%<\/b> (50)<br>Complexity : <b>0.01<\/b><br>setosa : <b>100%<\/b> (50)<br>versicolor : <b>0%<\/b> (0)<br>virginica : <b>0%<\/b> (0)<hr class = \"rPartvisNetwork\">\n<div class =\"showOnMe2\"><div style=\"text-align:center;\"><U style=\"color:blue;\" class = \"classActivePointer\">Rules<\/U><\/div>\n<div class=\"showMeRpartTTp2\" style=\"display:none;\">\n<b> Petal.Length <\/b> < 2.45<\/script><script type=\"text/javascript\">$(document).ready(function(){\n$(\".showOnMe2\").click(function(){\n$(\".showMeRpartTTp2\").toggle();\n$.sparkline_display_visible();\n});\n  });<\/script><\/div><\/div>\n\n<\/div>","<div style=\"text-align:center;\">N : <b>66.7%<\/b> (100)<br>Complexity : <b>0.44<\/b><br>setosa : <b>0%<\/b> (0)<br>versicolor : <b>50%<\/b> (50)<br>virginica : <b>50%<\/b> (50)<hr class = \"rPartvisNetwork\">\n<div class =\"showOnMe2\"><div style=\"text-align:center;\"><U style=\"color:blue;\" class = \"classActivePointer\">Rules<\/U><\/div>\n<div class=\"showMeRpartTTp2\" style=\"display:none;\">\n<b> Petal.Length <\/b> >= 2.45<\/script><script type=\"text/javascript\">$(document).ready(function(){\n$(\".showOnMe2\").click(function(){\n$(\".showMeRpartTTp2\").toggle();\n$.sparkline_display_visible();\n});\n  });<\/script><\/div><\/div>\n\n<\/div>","<div style=\"text-align:center;\">N : <b>36%<\/b> (54)<br>Complexity : <b>0<\/b><br>setosa : <b>0%<\/b> (0)<br>versicolor : <b>90.7%<\/b> (49)<br>virginica : <b>9.3%<\/b> (5)<hr class = \"rPartvisNetwork\">\n<div class =\"showOnMe2\"><div style=\"text-align:center;\"><U style=\"color:blue;\" class = \"classActivePointer\">Rules<\/U><\/div>\n<div class=\"showMeRpartTTp2\" style=\"display:none;\">\n<b> Petal.Length <\/b> >= 2.45<br><b> Petal.Width <\/b> < 1.75<\/script><script type=\"text/javascript\">$(document).ready(function(){\n$(\".showOnMe2\").click(function(){\n$(\".showMeRpartTTp2\").toggle();\n$.sparkline_display_visible();\n});\n  });<\/script><\/div><\/div>\n\n<\/div>","<div style=\"text-align:center;\">N : <b>30.7%<\/b> (46)<br>Complexity : <b>0.01<\/b><br>setosa : <b>0%<\/b> (0)<br>versicolor : <b>2.2%<\/b> (1)<br>virginica : <b>97.8%<\/b> (45)<hr class = \"rPartvisNetwork\">\n<div class =\"showOnMe2\"><div style=\"text-align:center;\"><U style=\"color:blue;\" class = \"classActivePointer\">Rules<\/U><\/div>\n<div class=\"showMeRpartTTp2\" style=\"display:none;\">\n<b> Petal.Length <\/b> >= 2.45<br><b> Petal.Width <\/b> >= 1.75<\/script><script type=\"text/javascript\">$(document).ready(function(){\n$(\".showOnMe2\").click(function(){\n$(\".showMeRpartTTp2\").toggle();\n$.sparkline_display_visible();\n});\n  });<\/script><\/div><\/div>\n\n<\/div>"],"fixed":[true,true,true,true,true],"colorClust":["#7D91B6","#7D91B6","#AC83AE","#AC83AE","#B9828C"],"labelClust":["setosa","setosa","versicolor","versicolor","virginica"],"Leaf":[0,1,0,1,1],"font.size":[16,16,16,16,16],"scaling.min":[22.5,22.5,22.5,22.5,22.5],"scaling.max":[22.5,22.5,22.5,22.5,22.5]},"edges":{"id":["edge1","edge2","edge3","edge4"],"from":[1,1,3,3],"to":[2,3,6,7],"label":["< 2.45",">= 2.45","< 1.75",">= 1.75"],"value":[50,100,54,46],"title":["<div style=\"text-align:center;\"><b>Petal.Length<\/b><\/div><div style=\"text-align:center;\"><2.45<\/div>","<div style=\"text-align:center;\"><b>Petal.Length<\/b><\/div><div style=\"text-align:center;\">>=2.45<\/div>","<div style=\"text-align:center;\"><b>Petal.Width<\/b><\/div><div style=\"text-align:center;\"><1.75<\/div>","<div style=\"text-align:center;\"><b>Petal.Width<\/b><\/div><div style=\"text-align:center;\">>=1.75<\/div>"],"color":["#8181F7","#8181F7","#8181F7","#8181F7"],"font.size":[14,14,14,14],"font.align":["horizontal","horizontal","horizontal","horizontal"],"smooth.enabled":[true,true,true,true],"smooth.type":["cubicBezier","cubicBezier","cubicBezier","cubicBezier"],"smooth.roundness":[0.5,0.5,0.5,0.5]},"nodesToDataframe":true,"edgesToDataframe":true,"options":{"width":"100%","height":"100%","nodes":{"shape":"dot"},"manipulation":{"enabled":false},"layout":{"hierarchical":{"enabled":true,"direction":"UD"}},"interaction":{"dragNodes":false,"selectConnectedEdges":false,"tooltipDelay":500},"edges":{"scaling":{"label":{"enabled":false}}}},"groups":null,"width":"100%","height":"600px","idselection":{"enabled":false,"style":"width: 150px; height: 26px","useLabels":true,"main":"Select by id"},"byselection":{"enabled":false,"style":"width: 150px; height: 26px","multiple":false,"hideColor":"rgba(200,200,200,0.5)","highlight":false},"main":{"text":"鸢尾花分类树","style":"font-family:Georgia, Times New Roman, Times, serif;font-weight:bold;font-size:20px;text-align:center;"},"submain":{"text":"","style":"font-family:Georgia, Times New Roman, Times, serif;font-size:12px;text-align:center;"},"footer":{"text":"","style":"font-family:Georgia, Times New Roman, Times, serif;font-size:12px;text-align:center;"},"background":"rgba(0, 0, 0, 0)","highlight":{"enabled":true,"hoverNearest":false,"degree":{"from":50000,"to":0},"algorithm":"hierarchical","hideColor":"rgba(200,200,200,0.5)","labelOnly":true},"collapse":{"enabled":true,"fit":true,"resetHighlight":true,"clusterOptions":{"fixed":true,"physics":false},"keepCoord":true,"labelSuffix":"(cluster)"},"tooltipStay":300,"tooltipStyle":"position: fixed;visibility:hidden;padding: 5px;\n                      white-space: nowrap;\n                      font-family: cursive;font-size:12px;font-color:purple;background-color: #E6E6E6;\n                      border-radius: 15px;","OnceEvents":{"stabilized":"function() { \n        this.setOptions({layout:{hierarchical:false}, physics:{solver:'barnesHut', enabled:true, stabilization : false}, nodes : {physics : false, fixed : true}});\n    }"},"legend":{"width":0.1,"useGroups":false,"position":"left","ncol":1,"stepX":100,"stepY":100,"zoom":true,"nodes":{"label":["Petal.Length","Petal.Width","setosa","versicolor","virginica"],"color":["#F1B8C2","#B4C7ED","#7D91B6","#AC83AE","#B9828C"],"shape":["dot","dot","square","square","square"],"size":[22,22,22,22,22],"Leaf":[0,0,1,1,1],"font.size":[16,16,16,16,16],"id":[10000,10001,10002,10003,10004]},"nodesToDataframe":true},"tree":{"updateShape":true,"shapeVar":"dot","shapeY":"square","colorVar":{"variable":["Petal.Length","Petal.Width"],"color":["#F1B8C2","#B4C7ED"]},"colorY":{"colorY":{"modality":["setosa","versicolor","virginica"],"color":["#7D91B6","#AC83AE","#B9828C"]},"vardecidedClust":["setosa","setosa","versicolor","versicolor","virginica"]}},"export":{"type":"png","css":"float:right;-webkit-border-radius: 10;\n                  -moz-border-radius: 10;\n                  border-radius: 10px;\n                  font-family: Arial;\n                  color: #ffffff;\n                  font-size: 12px;\n                  background: #090a0a;\n                  padding: 4px 8px 4px 4px;\n                  text-decoration: none;","background":"#fff","name":"network.png","label":"Export as png"}},"evals":["OnceEvents.stabilized"],"jsHooks":[]}</script>
```

节点、边的属性都可以映射数据指标

