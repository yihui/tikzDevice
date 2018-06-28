# tikzDevice 0.12 (2018-06-28)

Contributors
------------

- New package maintainer: Ralf Stubner.

Internal
--------

- add missing `Suggests:` to fix WARNING on R-devel
- Separate `Rf_eval` and `Rf_lang1` cals to fix "Additional issues" from rchk.
- Use `codecov` instead of `coverall` for test coverage (not fully working yet)


# tikzDevice 0.11 (2018-03-10)

Bug fixes
---------

- Fix potential protection issues (#161).
- Zero-length strings are not treated as multibyte character strings anymore.
- Registering native methods to fix `R CMD check` warnings.
- Updating the filehash package no longer causes the tikzDevice package to fail (#168).
- Remove probably harmless extra space from text being measured.
- Don't overwrite string's encoding in `anyMultibyteUTF8Characters()` (#158, @jszhao).
- Enforce the encoding of temporary TeX file to UTF-8 (#159, @jszhao).
- Don't call `library(grid)` from package code anymore.
- Code from manual now contains simple apostrophes to allow copy-paste (#139).

Features
--------

- The new `tikzTest()` function (via `getLatexStrWidth(diagnose = TRUE)`) now writes a complete LaTeX document, which allows e.g. MikTeX to install missing LaTeX packages (#142, #149).
- If measurement fails, the `.tex` and `.log` files are not printed anymore,
  instead the location of these files is shown.
- Support LuaLaTeX > 0.85 by loading the luatex85 package if it exists and avoiding loading xunicode (#150).
- Temporary .tex and .log files are created in a separate directory for each run.

Internal
--------

- Consistent code style with the help of the styler package.
- `load_all()` works now.


Version 0.10-1 (2016-02-09)
===

- Use `CDR(CDDR())` instead of `CDDDR()`, the latter is available only in R 3.2.0 (#136).


Changes in version 0.10 (2016-02-04)
===

Features
---

- Use `png::writePNG()` to output raster images to avoid reentrancy issues with capturing and playback and to reduce size of raster images. The `tikzRasterResolution` option is now obsolete (#132).

Bug Fixes
---

- The setting `sanitize = TRUE` works even if the `tikzDevice` package is not attached to the search path (#129).

Internal
---

- Update `ggplot2` results to account for minor differences due to the package's update (#131).
- Add test for combined rotation and reflection of raster images.
- Add tracing code to the beginning of almost every C function.


Changes in version 0.9 (2015-11-16)
===

Features
---

- PNG images now use `png(type = "cairo")` on all platforms (#121)
- New argument `verbose` to `tikz()` function (#117, #124)

Bug Fixes
---

- Fix segfault when no file extension is provided (#101)
- Fix quoting issue with spaces in the tempdir name (#99, #105, #106)
- Fix the error from getMetricsFromLatex() when options(OutDec) is set to "," (#57)
- Allow loading package even if LaTeX is not available, with a warning instead of a fatal error (#112, 125)
- Bump dependency for `filehash` (#109)

Internal
---

- R compatibility update: Explicit imports from recommended pacakges (#116)
- Use `crayon` for coloring test output (#112)


Changes in version 0.8.1 (2015-01-07)
===

Bug Fixes
---

- Renamed `strlcpy` to `strlcpy_` to avoid name clashes on OS X and Solaris (#97).
- Reduced size of archive on CRAN.

Changes in version 0.8 (2015-01-07)
===

Compatibility
---

- This release doesn't work on OS X and Solaris. This will be resolved soon.

Contributors
---

- Thanks to Greg Jefferis, Bill Venables, Sam Mason, Gvozden Neskovic,
  Martin Bergner and Casper Ti. Vector for contributing to this release.

Features
---

- Add parameter `timestamp` to `tikz` to make the output of the timestamp optional (#28,
  #73, thanks Martin Bergner).
- Add parameter `lwdUnit` to `tikz` to specify the physical width of a line
  (in points) that is 1 unit wide in R. By default, the value of option
  `tikzLwdUnit` is used; this option has a value of 0.4 at startup (#68,
  thanks Casper Ti. Vector).
- Optionally use symbolic colors defined in a single external file instead of
  hard-coded colors defined in-place.  New parameters `symbolicColors`,
  `colorFileName` and `maxSymbolicColors`; new options `tikzSymbolicColors`
  and `tikzMaxSymbolicColors`. The external file is only created if requested;
  in this case, symbolic color names are used instead of `fillColor` and
  `drawColor` (#70, thanks Martin Bergner).

Bug Fixes
---

- Ignore fill color for lines to remove thin line (1 pixel wide) that was shown
  with dashed or dotted lines on some viewers (#63, thanks Martin Bergner).
- More robust handling of metrics dictionary.  Changes to the
  `tikzMetricsDictionary` option are recognized even if a metrics dictionary
  already has been initialized, a message is printed the first time a dictionary
  is used (in addition to the message that is printed when the dictionary is
  created).  A missing dictionary file is recreated (#21).
- Performance improvements with zero-width strings (#66, thanks Gvozden Neskovic)
- Add parameter `checkstate` to allow adding annotations to a new plot (#52,
  thanks Sam Mason)
- Allow raster images to be output without resampling by setting
  `options(tikzRasterResolution = NA)` (#54, thanks Sam Mason)
- In console mode, print a `\relax` statement after the comment to allow using
  `tikzDevice` in a Sweave code chunk with `results=tex`, as advertised in the
  vignette.  (The default is `strip.white=TRUE` which makes the following
  `\begin{tikzpicture}` appear on the same line as the encoding comment in the
  resulting `.tex` file.)  (#47, thanks Bill Venables)

Vignette
---

- Use `knitr` as vignette builder (#37).
- Fixed typos (#45, thanks Greg Jefferis).
- Vignette now also compiles if the `zi4` TeX package is installed instead of
  `inconsolata`.  This should fix the CRAN notes and warnings on Windows.
- Loading `babel` TeX package to avoid printing tilde in references (#49).

Internal
---

- Tests perform strict image comparison (#18).
- Testing now also works in RStudio.


Changes in version 0.7.0 (2013-12-10, CRAN release)
===

Contributors
---

- New package maintainers: Kirill Müller and Yihui Xie.

- Zack Weinberg for suggestions and comments that led to optimizations in the
  quality and quantity of TikZ output.

- Romain Franconville for bugreports that led to the discovery of two bugs in
  the raster routines.

- corecode for fixing the getDocumentPointsize routines for corner cases

- Sietse Brouwer for enumerating the exact list of LaTeX packages
  `tikzDevice` requires and for vignette spelling/style corrections.

- Stéphane Laurent for reporting a bug in the detection of the document font size.

New Features
---

- The `tikz` function now has a `onefile` argument that behaves similar to
  the `onefile` argument of the `pdf` device (#40).

- LuaLaTeX is now supported directly and can be selected by passing
  `engine = 'luatex'` to `tikz` (#28).

- New function `tikzCompilerInfo`, reports information concerning the compilers
  used by the tikzDevice

- Updated vignette (yihui/tikzDevice#36).

Bug Fixes
---

- Colorized text now obeys transparency settings.

- The tikzDevice no longer produces output for plots that are completely
  empty.

- The `tikz` option `footer` now works as described by the documentation.
  Previously, it had no effect (#52).

- The `tikz` device can now handle raster images with negative widths or
  heights that arise from calling a raster plotting function using reversed
  axes (#53).

- Creating raster output with the tikzDevice could mess with the behavior of
  some graphical paramaters such as par('mfrow'). This has been fixed (#54).

- Calls to the `filehash` package have been protected from user interruptions.
  This should prevent rogue lockfiles and corrupted metrics dictionaries.

- The `documentDeclaration` and `packages` arguments to the `tikz` function
  are now used in metric calculations. Previously, only global options were
  consulted.

- Properly copy strings containing LaTeX info, avoiding use of freed memory.

- Point size of main font in document is now inferred correctly (even if the option
  tikzDocumentDeclaration contains newlines), again fixed
  regexp in getDocumentPointsize (yihui/tikzDevice#34).

- Package can be installed in R 3.0.2.

- No C warnings when installing (#68).

- Function `grid.tikzNode` works again, had no effect due to a missing S3
  export.

- Fixed formatting of documentation.

Behind the scenes
---

- The tikzDevice now requires R 2.14.0 or later.

- Semantic versioning will be used from now on

- Package is uploaded to RForge (http://rforge.net)

- Enable continuous integration via craigcitro/r-travis.  All supported R
  versions are tested.

- Upgrade documentation generation from Roxygen to Roxygen2.

- Testing framework updated to use testthat 0.6. Earlier versions of testthat
  are no longer supported due to a switch from Mutatr classes to standard R
  Reference Classes (#56).

- Some magic numbers that control the leading used in the margin text of base
  graphics were adjusted to values used by the PDF device. Hopefully this
  will make the spacing used by x axis labels and y axis labels a bit more
  symmetric (#49).

- The tikzDevice now delays the creation of clipping scopes until a drawing
  operation occurs that can be clipped. This prevents empty clipping scopes
  from appearing in the output and can reduce the size of the output by ~3/4
  in some cases (#45).

- The code that handles line color and fill color has been completely
  refactored to avoid useless operations such as 0 transparency fills and
  draws (#46).

- Defer starting new tikzpicture environments (#12).

- Replace library.dynam with useDynLib (#50).

- Reduce verbosity of start-up message.

- Support ggplot 0.9.0.

Changes in version 0.6.2 (2011-11-13)
===

New Features
---

- The annotation system has been improved. A new function `tikzNode` has been
  added that makes it easy to insert TikZ nodes with custom options and
  content. `tikzCoord` is now a wrapper for `tikzNode` that simplifies the
  function call required to get a plain coordinate.

- Annotation of Grid graphics is now supported. New functions
  `tikzAnnotateGrob`, `tikzNodeGrob` and `tikzCoordGrob` allow the creation of
  Grid grobs that execute annotiation commands when drawn to a `tikz` device.
  Wrapper functions `grid.tikzAnnotate`, `grid.tikzNode` and `grid.tikzCoord`
  are also provided. The necessary transformations between Grid coordinates,
  which are viewport-centric, to absolute device coordinates are handled by a
  new function `gridToDevice`.

- Support has been added for the `dev.capabilities` function in R 2.14.0.

Bug Fixes
---

- Fixed a bug where the outline of the background bounding box was being drawn
  with the forground color instead of the background color. This was
  unnoticible except when a non-white background was used. Thanks to Matthieu
  Stigler for reporting.

Behind the Scenes
---

- The tikzDevice is now checked with "visual regression testing" which compares
  the results of graphics tests against a set of standard images using a visual
  diff. If a change occurs that significantly affects font metrics or graphics
  primitives the effects will show up in the diff. Currently, ImageMagick's
  `compare` utility is used to calculate differences. This process was inspired
  by the work of Paul Murrell and Stephen Gardiner on the graphicsQC package.
  Future versions of the tikzDevice may use graphicsQC to perform this task.

- The tikzDevice Vignette used to employ a rather ugly hack that re-wrote the
  internals of the Sweave driver during processing in order to gain more
  control over syntax highlighting. This hack has been replaced by TeX macros
  that achieve the same result without messing with R.


Changes in version 0.6.1 (2011-4-14)
===

Bug Fixes
---

- Fixed a bug where `tikz` was not applying background color to the plot
  canvas.

- Fixed a Vignette bug caused by an incorrect merge that was breaking the CRAN
  build.


Changes in version 0.6.0 (2011-4-13)
===

New Features
---

- Unicode Support!!!! XeLaTeX may now be used calculate metrics and widths for
  Unicode characters. PdfLaTeX remains the default LaTeX compiler, but this may
  be changed by setting the global option `tikzDefaultEngine` to `xetex`.

- New global option `tikzXelatexPackages` which contains packages necessary to
  use unicode characters with xelatex.  Specifically, the fontspec and the
  xunicode packages as well as the xetex option to the preview package.

- New global option `tikzUnicodeMetricPackages` which contains the packages
  necessary to calculate metrics for multibyte unicode characters with xelatex.

- New function anyMultibyteUTF8Characters() which will check if the given
  string contains any multibyte unicode characters.  Exposed in the package
  namespace since it is general and may be useful in other applications.

- The TikZ device now fully supports the `Raster` graphics primitive that was
  added in R 2.11.0 and no longer throws "not implemented" warnings when this
  functionality is used. This is accompilshed by writing raster images to PNG
  files, `Rplots_ras#.png`, which are then included in the main TeX file
  `Rplots.tex`.

- The TikZ device now fully supports the `polypath` graphics primitive that was
  added in R 2.12.0 and no longer throws "not implemented" warnings when this
  functionality is used.


Bug Fixes
---

- Fixed a bug where the `lwd` parameter used to control line widths was
  declared by tikzDevice to be of type `int` when it is actually a `double`.
  This was causing line widths to be ignored or miscalculated. Many thanks to
  Baptiste Auguie for reporting this issue.


Depreciation Notices
---

- Versions of R < 2.11.0 are no longer supported due to lack of required
  functions for handling Unicode strings.


Behind the Scenes
---

- New Makefile for executing common development tasks.

- Package documentation now handled by `roxygen`.  Many thanks to Hadley
  Wickham and Yihui Xie for the `Rd2roxygen` package which facilitated this
  switch.

- Package test suite completely overhauled and now based on Hadley Wickham's
  `test_that` unit testing framework.


Changes in version 0.5.3
===

Bug Fixes
---

- R 2.12.x now throws a warning message when shell commands run via `system()`
  have non-zero exit conditions.  The metric calculation runs LaTeX on a file
  containing an \@@end command.  This causes a non zero exit condition.  The end
  result was that users were getting spammed by warning messages.  These
  messages have been gagged for now and a better way to run LaTeX such that a
  non-zero condition can meaningfully indicate an error is being investigated.

- The range of characters the default sanitizer looks for has been extended.  It
  should now process all characters that are special to TeX with the exception
  of backslashes.  Documentation has been improved.

- Detection of failed string metric calculations has been strengthened and the
  resulting error message has been improved.


Changes in version 0.5.2
===

Contributors
---

- mlt for reporting problems with the Sanitize function that led to the
  discovery of two situations where buffer overflows were occurring.


Bug Fixes
---

- Fixed buffer overflows and memory leaks related to string pointers in
  tikzDevice.c.

- Fixed compilation of the tikzDevice vignette under R 2.12.0.

- Reduced the verbosity of the package startup message.


Changes in version 0.5.1
===

Bug Fixes
---

- A stub function has been added so that the `polypath()` function
  introduced in R 2.12.0 won't crash the device.

- Fixed bug where no string output was shown when the sanitize=TRUE option was
  used.

- The path to a LaTeX compiler returned by `Sys.which()` is now checked by
  `file.access()` to check that it is actually an executable and not an error
  message.  This fixes issues arising from `Sys.which()` on Solaris.

- On UNIX platforms, `/usr/texbin/pdflatex` is added to the end of the list of
  places to search for a LaTeX compiler.  This should help people using R.app on
  OS X find a LaTeX compiler without having to manually specify it.

- `tikz()` produces a better error message when it cannot open a file for output.

- In the event that LaTeX crashes during a metric calculation, the LaTeX log
  output is echoed using `message()` instead of `cat()`.  This makes it show up
  during operations that supperss `cat()` output such as `R CMD build` and
  `R CMD Sweave`.


Changes in version 0.5.0
===

Contributors
---

- Lorenzo Isella contributed bug reports and examples that led to the
  discovery of a bug in fontsize calculations that appeared when
  certain LaTeX commands were used to change the active font.

- Vivianne Vilar for spotting spelling and grammar errors in the
  vignette.

- Gabor Grothendieck for the idea for sending output to the screen
  for use with sink() (i.e. the "console" option)

New Features
---

- "console" option for directing tikz() output back into the R console
  instead of to a file.

- Preliminary support for a "sanitize" option which allows automatic
  escaping of characters that have special meaning to TeX like "$" and
  "%".

- tikzAnnotate() and tikzCoord() functions.  tikzAnnotate() allows
  arbitrary LaTeX code to be injected into the output stream of an
  active tikz() graphics device.  tikzCoord() is a wrapper for
  tikzAnnotate() that inserts named locations into the graphics code.
  These locations may be referenced by other TikZ drawing commands.


Bug Fixes
---

- Removed bad colon in the DESCRIPTION file.

- Proper fontsize calculations now include ps from par() and fontsize
  from gpar().  This fixes issues with lattice-based graphics such as
  ggplot2.

- Metrics are now calculated properly when commands like
  \renewcommand\rmdefault are used to adjust the active font.

- Sanitization of % signs in labels.

- The package no longer overwrites user customizations set in places like
  .Rprofile with default values when loaded.

- Attempting to use new graphics functions such as rasterImage() now
  produces error messages instead of fatal crashes in R 2.11.0 and
  above.

Changes in version 0.4.0
===

- Initial Beta Release

- Support for all essential graphical parameters: colors, line types,
  line weights, semi-transparency, line endings and line joining.

- String width and character metrics are calculated by direct calls to a LaTeX
  compiler. This is an inefficient but robust method. Some of the inefficiency
  of this method is compensated for by storing calculated string widths in a
  database managed by the filehash package. This way if we pay a computational
  price to compute the width of a string, we
  hopefully only pay it once.

