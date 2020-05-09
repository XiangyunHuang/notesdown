gitbook:
	xvfb-run --auto-servernum Rscript -e 'bookdown::render_book("index.Rmd", quiet = TRUE)'

pdf:
	xvfb-run --auto-servernum Rscript -e 'bookdown::render_book("index.Rmd", "bookdown::pdf_book", quiet = TRUE)'

all:
	xvfb-run --auto-servernum Rscript -e 'bookdown::render_book("index.Rmd", "all", quiet = TRUE)'
