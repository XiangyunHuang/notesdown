if (file.exists('~/.Rprofile')) sys.source('~/.Rprofile', envir = environment())

local({
  pandoc_path = Sys.getenv('RSTUDIO_PANDOC', NA)
  if (Sys.which('pandoc') == '' && !is.na(pandoc_path)) Sys.setenv(PATH = paste(
    Sys.getenv('PATH'), pandoc_path,
    sep = if (.Platform$OS.type == 'unix') ':' else ';'
  ))
})

options(
  citation.bibtex.max = 999,
  bitmapType = "cairo",
  getSymbols.warning4.0 = FALSE,
  getSymbols.auto.assign = FALSE,
  future.supportsMulticore.unstable = FALSE,
  shiny.testmode = TRUE,
  stringsAsFactors = FALSE,
  knitr.graphics.auto_pdf = TRUE,
  rgl.printRglwidget = TRUE,
  rgl.useNULL = TRUE,
  width = 69,
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
  error = function() {
    calls <- sys.calls()
    if (length(calls) >= 2L) {
      sink(stderr())
      on.exit(sink(NULL))
      cat("Backtrace:\n")
      calls <- rev(calls[-length(calls)])
      for (i in seq_along(calls)) {
        cat(i, ": ", deparse(calls[[i]], nlines = 1L), "\n", sep = "")
      }
    }
    if (!interactive()) {
      q(status = 1)
    }
  }
)
