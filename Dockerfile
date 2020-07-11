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
   cairo-devel \
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
 && Rscript -e 'x <- file.path(R.home("doc"), "html"); if (!file.exists(x)) {dir.create(x, recursive=TRUE); file.copy(system.file("html/R.css", package="stats"), x)}' \
 && install.r docopt odbc

# Python virtual env
# COPY requirements.txt ./
# RUN RETICULATE_PYTHON_ENV=/opt/.virtualenvs/r-tensorflow \
#   && virtualenv -p /usr/bin/python3 $RETICULATE_PYTHON_ENV \
#   && /bin/bash -c "source $RETICULATE_PYTHON_ENV/bin/activate; pip3 install -r requirements.txt; pip3 list --format=columns; deactivate"

ENV LANG=en_US.UTF-8 \
    LANGUAGE=en_US.UTF-8
