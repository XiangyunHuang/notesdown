if (file.exists('~/.Rprofile')) sys.source('~/.Rprofile', envir = environment())

local({
  pandoc_path <- Sys.getenv("RSTUDIO_PANDOC", NA)
  if (Sys.which("pandoc") == "" && !is.na(pandoc_path)) {
    Sys.setenv(PATH = paste(
      Sys.getenv("PATH"), pandoc_path,
      sep = if (.Platform$OS.type == "unix") ":" else ";"
    ))
  }
  # add local PhantomJS Path
  if (Sys.getenv("CI") == "" && grepl("macOS", utils::sessionInfo()$running)) {
    Sys.setenv(PATH = paste(
      normalizePath("~/Library/phantomjs-2.1.1-macosx/bin"),
      Sys.getenv("PATH"),
      sep = .Platform$path.sep
    ))
  }

  if (Sys.getenv("CI") == "" && grepl("CentOS", utils::sessionInfo()$running)) {
    Sys.setenv(PATH = paste(
      normalizePath("/opt/phantomjs/phantomjs-2.1.1-linux-x86_64/bin"),
      Sys.getenv("PATH"),
      sep = .Platform$path.sep
    ))
  }
})

options(
  citation.bibtex.max = 999,
  bitmapType = "cairo",
  getSymbols.warning4.0 = FALSE,
  getSymbols.auto.assign = FALSE,
  future.supportsMulticore.unstable = FALSE,
  stringsAsFactors = FALSE,
  knitr.graphics.auto_pdf = TRUE,
  rgl.printRglwidget = TRUE,
  rgl.useNULL = TRUE, # used in vbox
  yaml.eval.expr = TRUE, # used by yaml.load
  width = 69,
  sciopen = 999,
  demo.ask = FALSE,
  formatR.indent = 2,
  geoR.messages = FALSE,
  rsconnect.force.update.apps = TRUE,
  str = utils::strOptions(strict.width = "cut"),
  knitr.table.format = "pandoc",
  datatable.quiet = TRUE,
  datatable.print.class = TRUE,
  datatable.print.keys = TRUE,
  useFancyQuotes = FALSE,
  kableExtra.latex.load_packages = FALSE,
  dev.args = list(width = 960, height = 600),
  tidyverse.quiet = TRUE,
  crayon.enabled = FALSE,
  tidymodels.quiet = TRUE,
  memory.profiling = TRUE,
  reprex.styler = TRUE,
  bookdown.clean_book = TRUE,
  lifecycle_verbosity = "quiet",
  hrbrthemes.loadfonts = TRUE,
  tinytex.engine = 'xelatex',
  tinytex.tlmgr.path = '~/bin',
  tikzDefaultEngine = "xetex",
  tikzDocumentDeclaration = "\\documentclass[UTF8,fontset=adobe]{ctexart}\n",
  tikzXelatexPackages = c(
    "\\usepackage[colorlinks,breaklinks]{hyperref}",
    "\\usepackage{color,times,tikz}",
    "\\usepackage[active,tightpage,xetex]{preview}",
    "\\PreviewEnvironment{pgfpicture}",
    "\\usepackage{amsmath,amsfonts,mathrsfs,amssymb}"
  )
)
