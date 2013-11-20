tikzDevice
==========

[![Build Status](https://travis-ci.org/yihui/tikzDevice.png)](https://travis-ci.org/yihui/tikzDevice)

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

    install.packages( 'tikzDevice' )

Development builds may be installed from RForge:

    install.packages( 'tikzDevice', repos = 'http://rforge.net', type = 'source' )

Alternatively, install directly from GitHub:

    devtools::install_github( 'yihui/tikzDevice' )

Bleeding-edge source code is available from GitHub, too:

    git clone git://github.com/yihui/tikzDevice.git

Source code checked out from GitHub cannot be installed directly by
`R CMD INSTALL`. There are some tasks that need to be executed to prepare the
source for installation. A makefile is provided that can execute these tasks.
To work with source code checked out from GitHub, ensure you are using GNU Make
and execute the following:

    make

That will print out a list of tasks available, including installation.


Reporting Bugs and Getting Help
-------------------------------

Primary development takes place on GitHub.  The preferred way to communicate
bugs and feature requests is to open an issue at the primary repository:

  https://github.com/yihui/tikzDevice/issues

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

  [2]:https://github.com/yihui/tikzDevice/blob/master/NEWS.md
