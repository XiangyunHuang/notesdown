# 办公文档 {#chap-office-document}

[docxtools](https://github.com/graphdr/docxtools)、[officer](https://github.com/davidgohel/officer) 和 [officedown](https://github.com/davidgohel/officedown) 大大扩展了 rmarkdown 在制作 Word/PPT 方面的功能。

本节探索 Markdown + Pandoc 以 Word 格式作为最终交付的可能性。R Markdown 借助 Pandoc 将 Markdown 转化为 Word 文档，继承自 Pandoc 的扩展性， R Markdown 也支持自定义 Word 模版，那如何自定义呢？首先，我们需要知道 Pandoc 内建的 Word 模版长什么样子，然后我们依样画葫芦，制作适合实际需要的模版。获取 Pandoc 2.10.1 自带的 Word 和 PPT 模版，只需在命令行中执行


```bash
# DOCX 模版
pandoc -o custom-reference.docx --print-default-data-file reference.docx
# PPTX 模版
pandoc -o custom-reference.pptx --print-default-data-file reference.pptx
```

这里其实是将 Pandoc 自带的 docx 文档 reference.docx 拷贝一份到 custom-reference.docx，而后将 custom-reference.docx 文档自定义一番，但仅限于借助 MS Word 去自定义样式。 Word 文档的 YAML 元数据定义详情见 <https://pandoc.org/MANUAL.html#option--reference-doc>，如何深度自定义文档模版见 <https://bookdown.org/yihui/rmarkdown/word-document.html>
，其它模版见 GitHub 仓库 [pandoc-templates](https://github.com/jgm/pandoc-templates)。这里提供一个[Word 文档案例](https://github.com/XiangyunHuang/masr/blob/master/examples/docx-document.Rmd)供读者参考。**bookdown** 提供的函数 `word_document2()` 相比于 **rmarkdown** 提供的 `word_document()` 支持图表的交叉引用，更多细节详见帮助  `?bookdown::word_document2`。

::: {.rmdnote data-latex="{注意}"}
R Markdown 文档支持带编号的 Word 文档格式输出要求 Pandoc 版本 2.10.1 及以上， rmarkdown 版本 2.4 及以上。
:::
