if (file.exists("~/.Rprofile")) sys.source("~/.Rprofile", envir = environment())
if (is.na(Sys.getenv("CI", NA))) {
  # Local macOS 环境
  Sys.setenv(R_CRAN_WEB = "https://mirrors.tuna.tsinghua.edu.cn/CRAN")
  # 用于 tools::CRAN_package_db()
}
options(
  citation.bibtex.max = 999,
  htmltools.dir.version = FALSE,
  kableExtra.latex.load_packages = FALSE,
  tinytex.engine = 'xelatex',
  tikzDefaultEngine = "xetex",
  tikzDocumentDeclaration = "\\documentclass[tikz]{standalone}\n",
  tikzXelatexPackages = c(
    "\\usepackage[fontset=adobe]{ctex}",
    "\\usepackage[default,semibold]{sourcesanspro}",
    "\\usepackage{amsfonts,mathrsfs,amssymb}\n"
  )
)
