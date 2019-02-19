FROM rocker/r-ver:latest

LABEL org.label-schema.license="GPL-2.0" \
      org.label-schema.vcs-url="https://github.com/daqana/tikzDevice" \
      maintainer="Ralf Stubner <ralf.stubner@daqana.com>"

RUN apt-get update \
 && apt-get install --yes --no-install-recommends \
            ghostscript \
            imagemagick \
            libcurl4-openssl-dev \
            libpng-dev \
            libssl-dev \
            perl \
            qpdf \
            texinfo \
            wget \
 && wget -qO- "https://yihui.name/gh/tinytex/tools/install-unx.sh" \
         | sh -s - --admin --no-path \
 && mv ~/.TinyTeX /usr/local/tinytex \
 && /usr/local/tinytex/bin/*/tlmgr path add \
 && tlmgr install pgf preview xcolor memoir ifetex microtype float \
                  babel-english listings xstring luatex85 \
 && install2.r filehash png evaluate formatR ggplot2 knitr lattice maps \
               testthat tinytex covr devtools \
 && rm -rf /var/lib/apt/lists/* \
 && rm -rf /tmp/*
