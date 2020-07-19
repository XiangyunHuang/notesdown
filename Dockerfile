FROM fedora:33

RUN groupadd staff \
  && useradd -g staff -d /home/docker docker

LABEL org.label-schema.license="GPL-3.0" \
      org.label-schema.vcs-url="https://github.com/XiangyunHuang/masr" \
      org.label-schema.vendor="Book Project" \
      maintainer="Xiangyun Huang <xiangyunfaith@outlook.com>"

# System dependencies required for R packages
RUN dnf -y upgrade \
  && dnf -y install dnf-plugins-core \
  && dnf -y install pandoc \
   pandoc-citeproc \
   pandoc-pdf \
   glibc-langpack-en \
   NLopt-devel \
   unixODBC-devel \
   sqlite-devel \
   R-devel \
   R-littler \
   R-littler-examples \
   octave-devel \
   ghostscript \
   dejavu-serif-fonts \
   dejavu-sans-fonts \
   dejavu-sans-mono-fonts \
   liberation-narrow-fonts \
   liberation-serif-fonts \
   liberation-sans-fonts \
   liberation-mono-fonts \
   inkscape \
   optipng \
   ImageMagick \
   texinfo \
   libcurl-devel \
   openssl-devel \
   libssh2-devel \
   libgit2-devel \
   libxml2-devel \
   glpk-devel \
   gmp-devel \
   sqlite-devel \
   gdal-devel \
   proj-devel \
   geos-devel \
   udunits2-devel \
   cairo-devel \
   v8-devel \
   igraph-devel \
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
   texlive-titling

RUN ln -s /usr/lib64/R/library/littler/examples/install.r /usr/bin/install.r \
 && ln -s /usr/lib64/R/library/littler/examples/install2.r /usr/bin/install2.r \
 && ln -s /usr/lib64/R/library/littler/examples/installGithub.r /usr/bin/installGithub.r \
 && ln -s /usr/lib64/R/library/littler/examples/testInstalled.r /usr/bin/testInstalled.r \
 && mkdir -p /usr/local/lib/R/site-library \
 && echo "options(repos = c(CRAN = 'https://cran.r-project.org/'))" | tee -a /usr/lib64/R/etc/Rprofile.site \
 && chmod a+r /usr/lib64/R/etc/Rprofile.site \
 && echo "LANG=en_US.UTF-8" >> /usr/lib64/R/etc/Renviron.site \
 && echo "CXXFLAGS += -Wno-ignored-attributes" >> /usr/lib64/R/etc/Makeconf \
 && Rscript -e 'x <- file.path(R.home("doc"), "html"); if (!file.exists(x)) {dir.create(x, recursive=TRUE); file.copy(system.file("html/R.css", package="stats"), x)}' \
 && mkdir -p ~/.R \
 && echo "CXXFLAGS += -Wno-ignored-attributes" >> ~/.R/Makevars \
 && echo "CXX14 = g++ -flto=2" >> ~/.R/Makevars \
 && echo "CXX14FLAGS = -mtune=native -march=native -Wno-unused-variable -Wno-unused-function -Wno-unused-local-typedefs -Wno-ignored-attributes -Wno-deprecated-declarations -Wno-attributes -O3" >> ~/.R/Makevars \
 && install.r docopt odbc bookdown ggplot2 shiny reactable lme4 glmmTMB data.table rstan sf brms rstanarm patchwork

# Python virtual env
# COPY requirements.txt ./
# RUN RETICULATE_PYTHON_ENV=/opt/.virtualenvs/r-tensorflow \
#   && virtualenv -p /usr/bin/python3 $RETICULATE_PYTHON_ENV \
#   && /bin/bash -c "source $RETICULATE_PYTHON_ENV/bin/activate; pip3 install -r requirements.txt; pip3 list --format=columns; deactivate"

ENV LANG=en_US.UTF-8 \
    LANGUAGE=en_US.UTF-8

WORKDIR /home/docker/

EXPOSE 8181

CMD ["Rscript", "-e", "sessionInfo()"]
