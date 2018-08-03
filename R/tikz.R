#' TikZ Graphics Device
#'
#' `tikz()` is used to open a R graphics device which supports output in the
#' TikZ graphics language. TikZ code may be included inside a LaTeX document by
#' specifying \code{\\usepackage{tikz}} in the document header.
#'
#' The TikZ device enables LaTeX-ready output from graphics functions. This is
#' done by encoding graphics commands using TikZ markup.  All text in a graphic
#' output with `tikz` will be typeset by LaTeX and therefore will match
#' whatever fonts are currently used in the document. This also means that
#' \strong{LaTeX mathematics can be typeset directly into labels and
#' annotations}.
#'
#' The TikZ device currently supports three modes of output depending on the
#' value of the `standAlone` and `bareBones` arguments.  If
#' `standAlone` and `bareBones` are set to the default value of
#' `FALSE`, the resulting file will only contain graphics output wrapped
#' in a LaTeX `tikzpicture` environment.  Since this file is not a
#' complete LaTeX document, it will need to be included in another LaTeX
#' document using the `\\input` command. For example:
#' \preformatted{
#'   \\documentclass{article}
#'   \\usepackage{tikz}
#'   \\begin{document}
#'   \\begin{figure}
#'     \\centering
#'     \\input{Rplots.tex}
#'     \\caption{}
#'   \\end{figure}
#'   \\end{document}
#' }
#'
#' When `standAlone` is set to `TRUE`, the device wraps the
#' `tikzpicture` environment in a complete LaTeX document suitable for
#' direct compilation. In this mode the `preview` package is used to crop
#' the resulting output to the bounding box of the graphic.
#'
#' When `bareBones` is set to `TRUE`, the output is not wrapped in a
#' document or a `tikzpicture` environment.  This is useful for embedding
#' an generated graphic within an existing TikZ picture.
#'
#' In cases where both `standAlone` and `bareBones` have been set to
#' `TRUE`, the `standAlone` option will take precedence.
#'
#' When the option `symbolicColors` is set to `TRUE`, the colors will
#' be written as symbolic names, e.g. `red, gray90` and similar. If the
#' color is not mapped to a symbolic name in R, the color will be named
#' `XXXXX` when `#XXXXXX` is its hexadecimal color. All the color
#' names will have to be defined in the enclosing document, which is
#' automatically written if the path of a color file `colorFileName` is
#' set.
#'
#' @param file,filename A character string indicating the desired path to the output
#'   file. If both arguments are used in the function call, `file` will be
#'   preferred.
#' @param width The width of the output figure, in **inches**.
#' @param height The height of the output figure, in **inches**.
#' @param onefile Should output be directed to separate environments in a
#'   single file (default `TRUE`). If `FALSE` this option works
#'   exactly like the argument of the same name to [pdf()]
#'   (see there for more details).
#' @param bg The starting background color for the plot.
#' @param fg The starting foreground color for the plot.
#' @param pointsize Base pointsize used in the LaTeX document.  This option is
#'   only used if a valid pointsize cannot be extracted from the value of
#'   `getOption("tikzDocumentDeclaration")`.  See the section "Font Size
#'   Calculations" in \link{tikzDevice-package} for more details.
#' @param lwdUnit The number of `pt`s in LaTeX that `lwd = 1` in R is
#'   translated to.  Defaults to 0.4 (LaTeX and TikZ default); for compatibility
#'   with R default, please use 72.27/96 (96 pixels in R is 1 inch, which is 72.27
#'   points in TeX).
#' @param standAlone A logical value indicating whether the output file should
#'   be suitable for direct processing by LaTeX. A value of `FALSE`
#'   indicates that the file is intended for inclusion in a larger document.
#'   See \sQuote{Details}.
#' @param bareBones A logical value.  When `TRUE` the figure will not be
#'   wrapped in a `tikzpicture` environment.  This option is useful for
#'   embedding one TikZ picture within another. When `TRUE` multipage
#'   output will be drawn on a single page.
#' @param console Should the output of tikzDevice be directed to the R console
#'   (default `FALSE`). This is useful for dumping tikz output directly into a
#'   LaTeX document via [sink()].  If TRUE, the `file` argument
#'   is ignored. Setting `file = ''` is equivalent to setting
#'   `console=TRUE`.
#' @param sanitize Should special latex characters be replaced (Default FALSE).
#'   See the section "Options That Affect Package Behavior" for which
#'   characters are replaced.
#' @param engine a string specifying which TeX engine to use. Possible values
#'   are 'pdftex', 'xetex' and 'luatex'. See the Unicode section of
#'   \link{tikzDevice-package} for details.
#' @param documentDeclaration See the sections "Options That Affect Package
#'   Behavior" and "Font Size Calculations" of \link{tikzDevice-package}
#'   for more details.
#' @param packages See the section "Options That Affect Package Behavior" of
#'   \link{tikzDevice-package}.
#' @param footer See the section "Options That Affect Package Behavior" of
#'   \link{tikzDevice-package}.
#' @param symbolicColors A logical value indicating whether colors are written
#'  as RGB values or as symbolic names in which case the need to be defined in
#'  the LaTeX document. These definitions can be generated with the following
#'  `colorFileName` parameter. See also the section "Options That Affect
#'  Package Behavior" of \link{tikzDevice-package}.
#' @param colorFileName a character string indicating where the color map for
#'  symbolic colors is to be stored. It can contain a placeholder \code{\%s}
#'  where the tikz filename is inserted. If the string is empty, no file is
#'  written.
#' @param maxSymbolicColors an integer number indicating the maximal number
#'  of distinct colors to write symbolically. Any excess color will be defined
#'  as if `symbolicColors` was set to `FALSE`. See also the section
#'  "Options That Affect Package Behavior" of \link{tikzDevice-package}.
#' @param timestamp A logical value indicating whether a timestamp is written
#'  to the TeX file.
#' @param verbose A logical value indicating whether diagnostic messages are
#'  printed when measuring dimensions of strings. Defaults to `TRUE` in
#'  interactive mode only, to `FALSE` otherwise.
#'
#' @return `tikz()` returns no values.
#'
#' @note To compile the output of `tikz` a working installation of LaTeX
#'   and PGF is needed.  Current releases of the TikZ package are available
#'   from <http://www.ctan.org>. The package may also be installed through
#'   the MikTeX package manager on Windows or using the TeX Live package
#'   manager, `tlmgr`, on Unix/Linux/OS X. The TeX Live package manager
#'   will only be installed by default for TeX Live distributions dated 2008
#'   and later. Both bleeding-edge and release versions of TikZ may be obtained
#'   from the project website hosted at
#'   <http://sourceforge.net/projects/pgf/>.
#'
#' Multiple plots will be placed as separate environments in the output file.
#'
#' @author Charlie Sharpsteen \email{source@@sharpsteen.net} and Cameron
#'   Bracken \email{cameron.bracken@@gmail.com}
#'
#' @seealso [pictex()], [getLatexCharMetrics()],
#'   [getLatexStrWidth()], [setTikzDefaults()],
#'   [tikzAnnotate()], [sanitizeTexString()]
#' @references The TikZ and PGF Packages: Manual for version 2.00\cr
#'   <http://sourceforge.net/projects/pgf>\cr Till Tantau, February 20,
#'   2008
#' @keywords device
#'
#' @examples
#'
#' \dontrun{
#'
#' ## Example 1 ###################################
#' #Set up temporary work directory
#' td <- tempdir()
#' tf <- file.path(td,'example1.tex')
#' oldwd <- getwd()
#' setwd(td)
#'
#' # Minimal plot
#' tikz(tf,standAlone=TRUE)
#'   plot(1)
#' dev.off()
#'
#' # View the output
#' tools::texi2dvi(tf,pdf=T)
#' system(paste(getOption('pdfviewer'),file.path(td,'example1.pdf')))
#' setwd(oldwd)
#' ################################################
#'
#' ## Example 2 ###################################
#' #Set up temporary work directory
#' td <- tempdir()
#' tf <- file.path(td,'example2.tex')
#' oldwd <- getwd()
#' setwd(td)
#'
#' #LaTeX math symbol names
#' syms <-c('alpha','theta','tau','beta','vartheta','pi','upsilon',
#'          'gamma','gamma','varpi','phi','delta','kappa','rho',
#'          'varphi','epsilon','lambda','varrho','chi','varepsilon',
#'          'mu','sigma','psi','zeta','nu','varsigma','omega','eta',
#'          'xi','Gamma','Lambda','Sigma','Psi','Delta','Xi','Upsilon',
#'          'Omega','Theta','Pi','Phi')
#' x <- rnorm(length(syms))
#' y <- rnorm(length(syms))
#'
#' tikz(tf,standAlone=TRUE)
#'   plot(-2:2, -2:2, type = "n", axes=F,
#'       xlab='', ylab='', main='TikZ Device Math Example')
#'     text(x,y,paste('\\\\Large$\\\\',syms,'$',sep=''))
#' dev.off()
#'
#' #View the output
#' tools::texi2dvi(tf,pdf=TRUE)
#' system(paste(getOption('pdfviewer'),file.path(td,'example2.pdf')))
#' setwd(oldwd)
#' ################################################
#'
#' ## Example 3 ###################################
#' #Set up temporary work directory
#' td <- tempdir()
#' tf <- file.path(td,'example3.tex')
#' oldwd <- getwd()
#' setwd(td)
#'
#' tikz(tf,standAlone=TRUE)
#'   plot(-2:2, -2:2, type = "n", axes=F, xlab='', ylab='', main='Random Circles')
#'     points(rnorm(50), rnorm(50), pch=21,
#'       bg=rainbow(50,alpha=.5), cex=10)
#' dev.off()
#'
#' #View the output
#' tools::texi2dvi(tf,pdf=TRUE)
#' system(paste(getOption('pdfviewer'),file.path(td,'example3.pdf')))
#' setwd(oldwd)
#' ################################################
#' }
#'
#' @export
tikz <- function(file = filename,
                 filename = ifelse(onefile, "./Rplots.tex", "./Rplot%03d.tex"),
                 width = 7, height = 7, onefile = TRUE,
                 bg="transparent", fg="black", pointsize = 10, lwdUnit = getOption("tikzLwdUnit"),
                 standAlone = FALSE, bareBones = FALSE, console = FALSE, sanitize = FALSE,
                 engine = getOption("tikzDefaultEngine"),
                 documentDeclaration = getOption("tikzDocumentDeclaration"),
                 packages,
                 footer = getOption("tikzFooter"),
                 symbolicColors = getOption("tikzSymbolicColors"), colorFileName = "%s_colors.tex",
                 maxSymbolicColors = getOption("tikzMaxSymbolicColors"),
                 timestamp = TRUE,
                 verbose = interactive()) {
  tryCatch(
    {
      # Ok, this sucks. We copied the function signature of pdf() and got `file`
      # as an argument to our function. We should have copied png() and used
      # `filename`.

      # file_path_as_absolute can give us the absolute path to the output
      # file---but it has to exist first. So, we use file() to "touch" the
      # path.
      touch_file <- suppressWarnings(file(file, "w"))
      close(touch_file)

      file <- tools::file_path_as_absolute(file)
    },
    error = function(e) {
      stop(simpleError(paste(
        "Cannot create:\n\t", file,
        "\nBecause the directory does not exist or is not writable."
      )))
    }
  )

  # remove the file if we are outputting to multiple files since the file
  # name will get changed in the C code
  if (!onefile) file.remove(file)

  # Determine which TeX engine is being used.
  switch(engine,
    pdftex = {
      engine <- 1L # In the C routines, a integer value of 1 means pdftex
      if (missing(packages)) {
        packages <- getOption("tikzLatexPackages")
      }
    },
    xetex = {
      engine <- 2L
      if (missing(packages)) {
        packages <- getOption("tikzXelatexPackages")
      }
    },
    luatex = {
      engine <- 3L
      if (missing(packages)) {
        packages <- getOption("tikzLualatexPackages")
      }
    },
    stop(
      "Unsupported TeX engine: ", engine,
      "\nAvailable choices are:\n",
      "\tpdftex\n",
      "\txetex\n",
      "\tluatex\n"
    )
  )

  # Ensure the standAlone option will trump the bareBones option.
  if (standAlone) {
    bareBones <- FALSE
  }
  if (footer != getOption("tikzFooter") && !standAlone) {
    warning("Footers are ignored when standAlone is set to FALSE")
  }

  # Extract the document pointsize from the documentDeclaration
  baseSize <- getDocumentPointsize(documentDeclaration)

  # If a pointsize was not found, we use the value of the pointsize
  # argument.
  if (is.na(baseSize)) {
    baseSize <- pointsize
  }

  # Collapse the character vectors into a single string
  # which is easier to work with in C
  documentDeclaration <-
    paste(paste(documentDeclaration, collapse = "\n"), collapse = "\n")
  packages <- paste(paste(packages, collapse = "\n"), collapse = "\n")
  footer <- paste(paste(footer, collapse = "\n"), collapse = "\n")
  if (maxSymbolicColors < 0) {
    stop("maxSymbolicColors needs to be nonnegative")
  }

  .External(
    TikZ_StartDevice, file, width, height, onefile, bg, fg, baseSize, lwdUnit,
    standAlone, bareBones, documentDeclaration, packages, footer, console,
    sanitize, engine, symbolicColors, colorFileName, maxSymbolicColors,
    timestamp, verbose
  )

  invisible()
}
