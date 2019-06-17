tikzDevice
==========

[![Build Status](https://travis-ci.org/daqana/tikzDevice.svg?branch=master)](https://travis-ci.org/daqana/tikzDevice) 
[![AppVeyor Build Status](https://ci.appveyor.com/api/projects/status/github/daqana/tikzDevice?branch=master&svg=true)](https://ci.appveyor.com/project/rstub/tikzDevice)   
[![Coverage status](https://codecov.io/gh/daqana/tikzDevice/branch/master/graph/badge.svg)](https://codecov.io/github/daqana/tikzDevice?branch=master) [![CRAN_Status_Badge](https://www.r-pkg.org/badges/version/tikzDevice)](https://cran.r-project.org/package=tikzDevice)

The tikzDevice package provides a graphics output device for R that records
plots in a LaTeX-friendly format. The device transforms plotting commands
issued by R functions into LaTeX code blocks. When included in a paper typeset
by LaTeX, these blocks are interpreted with the help of TikZ---a graphics
package for TeX and friends written by Till Tantau.

Using the tikzDevice, the text of R plots can contain LaTeX commands such as
mathematical formula. The device also allows arbitrary LaTeX code to be
inserted into the output stream.

The tikzDevice supports three main modes of output:

  - Figure chunks: placed in .tex files and suitable for inclusion in LaTeX
    documents via the \input{} command.

  - Stand alone figures: Complete LaTeX documents containing figure code that
    can be compiled into stand-alone images. Pages are cropped to the size of
    the figure using the LaTeX preview package.

  - Console output: TikZ code is returned directly to the R console as a
    character vector for further manipulation.


Obtaining the Package
---------------------

Stable versions of the tikzDevice may be installed from CRAN:

```r
install.packages( 'tikzDevice' )
```

Development builds may be installed from RForge:

```r
install.packages( 'tikzDevice', repos = 'https://rforge.net', type = 'source' )
```

Alternatively, install directly from GitHub:

```r
devtools::install_github( 'daqana/tikzDevice' )
```

Bleeding-edge source code is available from GitHub, too:

```sh
git clone git://github.com/daqana/tikzDevice.git
```

After cloning, install via

```r
devtools::install()
```

Reporting Bugs and Getting Help
-------------------------------

Primary development takes place on GitHub.  The preferred way to communicate
bugs and feature requests is to open an issue at the primary repository:

  https://github.com/daqana/tikzDevice/issues

(Unfortunately, the original repository by Charlie Sharpsteen,
https://github.com/Sharpie/RTikZDevice, has not been updated for over a year,
and the package was not even installable anymore with current versions of R.
This was the reason to continue development in a fork.)

The tikzDevice has also a dedicated mailing list courtesy of R-Forge.  The
mailing list is the easiest way to get answers for questions related
to usage:

  tikzdevice-bugs @at@ lists.r-forge.r-project.org

The mailing list may also be accessed through Google Groups:

  https://groups.google.com/forum/#!forum/tikzdevice

Adventurous users are encouraged to fork the repository and contribute
to the development of the package!


Latest Changes
--------------

*See the [NEWS][2] file for latest changes*

  [2]:https://github.com/daqana/tikzDevice/blob/master/NEWS.md
