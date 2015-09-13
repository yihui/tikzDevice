tikzDevice
==========

[![Build Status](https://travis-ci.org/yihui/tikzDevice.svg)](https://travis-ci.org/yihui/tikzDevice) [![Coverage Status](https://coveralls.io/repos/yihui/tikzDevice/badge.svg)](https://coveralls.io/r/yihui/tikzDevice)

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
