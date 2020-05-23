knitr::opts_chunk$set(width = 69, dpi = 300, message = FALSE, fig.align='center')

# convert pdf to png
to_png <- function(fig_path) {
  png_path <- sub("\\.pdf$", ".png", fig_path)
  magick::image_write(magick::image_read_pdf(fig_path), format = "png", path = png_path,
                      density = 300, quality = 100)
  return(png_path)
}
