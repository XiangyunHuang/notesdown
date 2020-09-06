#!/usr/bin/env Rscript

# This script installs some development packages that are needed for various
# apps. It can be sourced from RStudio, or run with Rscript.


# packages only available on Github
remote_pkgs <- c(equatiomatic = "datalorax")
lapply(
  c(
    "shiny", "shinythemes", "markdown", "DT",
    "formattable", "ggplot2", "remotes", "equatiomatic",
    "ggiraph", "rsconnect", "plotly", "future", "leaflet"
  ),
  function(pkg) {
    if (system.file(package = pkg) != "") {
      return()
    }
    repo <- remote_pkgs[pkg]
    if (is.na(repo)) {
      install.packages(pkg)
    } else {
      remotes::install_github(paste(repo, pkg, sep = "/"))
    }
  }
)
