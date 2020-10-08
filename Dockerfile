FROM fedora:33

RUN groupadd staff \
  && useradd -g staff -d /home/docker docker

LABEL org.label-schema.license="GPL-3.0" \
      org.label-schema.vcs-url="https://github.com/XiangyunHuang/masr" \
      org.label-schema.vendor="Book Project" \
      maintainer="Xiangyun Huang <xiangyunfaith@outlook.com>"

ARG CMDSTAN=/opt/cmdstan/cmdstan-2.24.1
ARG CMDSTAN_VERSION=2.24.1

# System dependencies required for R packages
RUN dnf -y upgrade \
  && dnf -y install dnf-plugins-core \
  && dnf -y install pandoc \
   pandoc-citeproc \
   pandoc-pdf \
   glibc-langpack-en \
   NLopt-devel \
   R-devel \
   R-littler \
   R-littler-examples \
   rstudio-server \
   ghostscript \
   google-noto-emoji-fonts \
   google-noto-emoji-color-fonts \
   dejavu-serif-fonts \
   dejavu-sans-fonts \
   dejavu-sans-mono-fonts \
   liberation-narrow-fonts \
   liberation-serif-fonts \
   liberation-sans-fonts \
   liberation-mono-fonts \
   optipng \
   ImageMagick \
   texinfo \
   cargo \
   bzip2 \
   ImageMagick-c++-devel \
   poppler-cpp-devel \
   libjpeg-turbo-devel \
   xorg-x11-server-Xvfb \
   libcurl-devel \
   openssl-devel \
   libssh2-devel \
   libgit2-devel \
   libxml2-devel \
   glpk-devel \
   gmp-devel \
   mariadb \
   mariadb-server \
   mariadb-devel \
   mariadb-connector-odbc \
   unixODBC-devel \
   sqlite-devel \
   gdal-devel \
   proj-devel \
   geos-devel \
   udunits2-devel \
   cairo-devel \
   v8-devel \
   igraph-devel \
   firewalld \
   python3-virtualenv \
   texlive-sourceserifpro \
   texlive-sourcecodepro \
   texlive-sourcesanspro \
   texlive-pdfcrop \
   texlive-dvisvgm \
   texlive-dvips \
   texlive-dvipng \
   texlive-ctex \
   texlive-fandol \
   texlive-xetex \
   texlive-framed \
   texlive-titling \
   texlive-fira \
   texlive-tufte-latex \
   texlive-awesomebox \
   texlive-fontawesome5 \
   texlive-fontawesome \
   texlive-newtx \
   texlive-tcolorbox \
   texlive-pgfornament-han \
   texlive-beamer-verona \
   texlive-beamertheme-metropolis

RUN ln -s /usr/lib64/R/library/littler/examples/install.r /usr/bin/install.r \
 && ln -s /usr/lib64/R/library/littler/examples/install2.r /usr/bin/install2.r \
 && ln -s /usr/lib64/R/library/littler/examples/installGithub.r /usr/bin/installGithub.r \
 && ln -s /usr/lib64/R/library/littler/examples/testInstalled.r /usr/bin/testInstalled.r \
 && mkdir -p /usr/local/lib/R/site-library \
 && echo "options(repos = c(CRAN = 'https://cran.r-project.org/'))" | tee -a /usr/lib64/R/etc/Rprofile.site \
 && chmod a+r /usr/lib64/R/etc/Rprofile.site \
 && echo "LANG=en_US.UTF-8" >> /usr/lib64/R/etc/Renviron.site \
 && echo "export LC_ALL=en_US.UTF-8"  >> /etc/profile \
 && echo "export LANG=en_US.UTF-8"  >> /etc/profile \
 && echo "CXXFLAGS += -Wno-ignored-attributes" >> /usr/lib64/R/etc/Makeconf \
 && Rscript -e 'x <- file.path(R.home("doc"), "html"); if (!file.exists(x)) {dir.create(x, recursive=TRUE); file.copy(system.file("html/R.css", package="stats"), x)}'

RUN dnf -y install R-odbc \
   R-bookdown \
   R-ggplot2


# RUN dnf copr -y enable iucar/cran \
#  && dnf install -y R-CoprManager \
#   R-CRAN-remotes \
#   R-CRAN-docopt \
#   R-CRAN-car \
#   R-CRAN-V8 \
#   R-CRAN-pdftools \
#   R-CRAN-magick \
#   R-CRAN-ggplot2 \
#   R-CRAN-rmarkdown \
#   R-CRAN-bookdown \
#   R-CRAN-sf \
#   R-CRAN-nloptr \
#   R-CRAN-odbc \
#   R-CRAN-kableExtra \
#   R-CRAN-highcharter \
#   R-CRAN-arrow \
#   R-CRAN-agridat \
#   R-CRAN-arules \
#   R-CRAN-bayesplot \
#   R-CRAN-DiagrammeR \
#   R-CRAN-gganimate \
#   R-CRAN-ggridges \
#   R-CRAN-xgboost \
#   R-CRAN-lightgbm \
#   R-CRAN-lme4 \
#   R-CRAN-glmnet \
#   R-CRAN-rstanarm \
#   R-CRAN-brms \
#   R-CRAN-plotly \
#   R-CRAN-prophet \
#   R-CRAN-quadprog \
#   R-CRAN-ggpubr


ENV LANG=en_US.UTF-8 \
    LANGUAGE=en_US.UTF-8

# Set default timezone
ENV TZ UTC

WORKDIR /home/docker/

EXPOSE 8181

CMD ["Rscript", "-e", "sessionInfo()"]
