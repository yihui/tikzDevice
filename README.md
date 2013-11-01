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


Beta Notice
-----------

The tikzDevice is currently flagged as a beta work.  The package is reasonably
stable and has been used by the authors to produce graphics for academic
publications for over a two years. The reason for beta status is that there are
several open design issues- two of which are:

  - Providing support for UTF8 text.

  - Supporting TeX variants other than LaTeX.

Resolving these issues may require changes to the tikzDevice that break
backwards compatibility with previous versions.  The beta flag is a reminder
that such changes may occur- although we will strive to avoid them if possible.

The beta flag will be removed upon release of version 1.0. At this time the
tikzDevice will switch to [semantic versioning][1] and changes that
break backwards compatibility will happen rarely and will incur a major release.

  [1]: http://www.semver.org


Obtaining the Package
---------------------

Stable versions of the tikzDevice may be installed from CRAN:

    install.packages( 'tikzDevice' )

Development builds may be installed from R-Forge:

    install.packages( 'tikzDevice',
      repos='http://r-forge.r-project.org' )

Bleeding-edge source code is available from GitHub:

    git clone git://github.com/Sharpie/RTikZDevice.git

Source code checked out from GitHub cannot be installed directly by
`R CMD INSTALL`. There are some tasks that need to be executed to prepare the
source for installation. A makefile is provided that can execute these tasks.
To work with source code checked out from GitHub, ensure you are using GNU Make
and execute the following:

    make

That will print out a list of tasks available, including installation.


Reporting Bugs and Getting Help
-------------------------------

The tikzDevice has a dedicated mailing list courtesy of R-Forge.  The
mailing list is the easiest way to get answers for questions related
to usage:

  tikzdevice-bugs @at@ lists.r-forge.r-project.org

The mailing list may also be accessed through Google Groups:

  https://groups.google.com/forum/#!forum/tikzdevice


Primary development takes place on GitHub.  Bugs and feature requests
may be made by opening issues at the primary repository:

  https://github.com/Sharpie/RTikZDevice/issues

Adventurous users are encouraged to fork the repository and contribute
to the development of the package!


Latest Changes
--------------
*See the [NEWS][2] file for changes that occurred in previous releases*

  [2]:https://github.com/Sharpie/RTikZDevice/blob/master/NEWS.md


---

### Version: 0.6.3
*Under development*

---

#### New Features

  - The `tikz` function now has a `onefile` argument that behaves similar to
    the `onefile` argument of the `pdf` device.

  - LuaLaTeX is now supported directly and can be selected by passing
    `engine = 'luatex'` to `tikz`.

#### Bug Fixes

  - Colorized text now obeys transparency settings.

  - The tikzDevice no longer produces output for plots that are completely
    empty.

  - The `tikz` option `footer` now works as described by the documentation.
    Previously, it had no effect.

  - The `tikz` device can now handle raster images with negative widths or
    heights that arise from calling a raster plotting function using reversed
    axes.

  - Creating raster output with the tikzDevice could mess with the behavior of
    some graphical paramaters such as par('mfrow'). This has been fixed.

  - Calls to the Filehash package have been protected from user interruptions.
    This should prevent rogue lockfiles and corrupted metrics dictionaries.

  - The `documentDeclaration` and `packages` arguments to the `tikz` function
    are now used in metric calculations. Previously, only global options were
    consulted.

#### Behind the Scenes

  - The tikzDevice now requires R 2.12.0 or later.

  - Upgrade documentation generation from Roxygen to Roxygen2.

  - Testing framework updated to use testthat 0.6. Earlier versions of testthat
    are no longer supported due to a switch from Mutatr classes to standard R
    Reference Classes.

  - Some magic numbers that control the leading used in the margin text of base
    graphics were adjusted to values used by the PDF device. Hopefully this
    will make the spacing used by x axis labels and y axis labels a bit more
    symmetric.

  - The tikzDevice now delays the creation of clipping scopes until a drawing
    operation occurs that can be clipped. This prevents empty clipping scopes
    from appearing in the output and can reduce the size of the output by ~3/4
    in some cases.

  - The code that handles line color and fill color has been completely
    refactored to avoid useless operations such as 0 transparency fills and
    draws.

#### Contributors
The following people contributed to this release of the tikzDevice:

  - Zack Weinberg for suggestions and comments that led to optimizations in the
    quality and quantity of TikZ output.

  - Romain Franconville for bugreports that led to the discovery of two bugs in
    the raster routines.
