knitr::opts_chunk$set(width = 69, dpi = 300, message = FALSE, fig.align='center')
knitr::opts_template$set(
  fig.large = list(fig.width = 7, fig.height = 5),
  fig.small = list(fig.width = 3.5, fig.height = 3.5)
)

# convert pdf to png
to_png <- function(fig_path) {
  png_path <- sub("\\.pdf$", ".png", fig_path)
  magick::image_write(magick::image_read_pdf(fig_path), format = "png", path = png_path,
                      density = 300, quality = 100)
  return(png_path)
}

# embed math fonts to pdf
embed_math_fonts <- function(fig_path) {
  if(knitr::is_latex_output()){
    embedFonts(
      file = fig_path, outfile = fig_path,
      fontpaths = system.file("fonts", package = "fontcm")
    )
  }
  return(fig_path)
}
