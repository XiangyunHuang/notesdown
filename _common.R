knitr::opts_chunk$set(width = 69, dpi = 300, message = FALSE, fig.align = "center")

# convert pdf to png
to_png <- function(fig_path) {
  png_path <- sub("\\.pdf$", ".png", fig_path)
  magick::image_write(magick::image_read_pdf(fig_path),
    format = "png", path = png_path,
    density = 300, quality = 100
  )
  return(png_path)
}

# embed math fonts to pdf
embed_math_fonts <- function(fig_path) {
  if (knitr::is_latex_output()) {
    embedFonts(
      file = fig_path, outfile = fig_path,
      fontpaths = system.file("fonts", package = "fontcm")
    )
  }
  return(fig_path)
}

knitr::knit_hooks$set(output = local({
  # the default output hook
  hook_output <- knitr::knit_hooks$get("output")
  function(x, options) {
    if (!is.null(n <- options$out.lines)) { # out.lines
      x <- xfun::split_lines(x)
      if (length(x) > n) {
        # truncate the output
        x <- c(head(x, n), "....\n")
      }
      x <- paste(x, collapse = "\n") # paste first n lines together
    }
    hook_output(x, options)
  }
}))

knitr::opts_knit$set(sql.max.print = 20)

palette(c(
  "#4285f4", # GoogleBlue
  "#34A853", # GoogleGreen
  "#FBBC05", # GoogleYellow
  "#EA4335" # GoogleRed
))

is_on_travis <- identical(Sys.getenv("TRAVIS"), "true")
is_online <- curl::has_internet()
is_latex <- identical(knitr::opts_knit$get("rmarkdown.pandoc.to"), "latex")
is_html <- identical(knitr::opts_knit$get("rmarkdown.pandoc.to"), "html")
is_windows <- identical(.Platform$OS.type, "windows")
is_unix <- identical(.Platform$OS.type, "unix")

# 创建临时的目录存放数据集
if (!dir.exists(paths = "./data")) dir.create(path = "./data")
