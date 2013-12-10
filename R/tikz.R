#' TikZ Graphics Device
#'
#' \code{tikz} is used to open a R graphics device which supports output in the
#' TikZ graphics language. TikZ code may be included inside a LaTeX document by
#' specifying \code{\\usepackage{tikz}} in the document header.
#'
#' The TikZ device enables LaTeX-ready output from graphics functions. This is
#' done by encoding graphics commands using TikZ markup.  All text in a graphic
#' output with \code{tikz} will be typeset by LaTeX and therefore will match
#' whatever fonts are currently used in the document. This also means that
#' \strong{LaTeX mathematics can be typeset directly into labels and
#' annotations}.
#'
#' The TikZ device currently supports three modes of output depending on the
#' value of the parameter \code{standAlone} and \code{bareBones}.  If
#' \code{standAlone} and \code{bareBones} are set to the default value of
#' \code{FALSE}, the resulting file will only contain graphics output wrapped
#' in a LaTeX \code{tikzpicture} environment.  Since this file is not a
#' complete LaTeX document, it will need to be included in another LaTeX
#' document using the \code{\\input} command. For example:
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
#' When \code{standAlone} is set to \code{TRUE}, the device wraps the
#' \code{tikzpicture} environment in a complete LaTeX document suitable for
#' direct compilation. In this mode the \code{preview} package is used to crop
#' the resulting output to the bounding box of the graphic.
#'
#' When \code{bareBones} is set to \code{TRUE}, the output is not wrapped in a
#' document or a \code{tikzpicture} environment.  This is useful for embedding
#' an generated graphic within an existing TikZ picture.
#'
#' In cases where both \code{standAlone} and \code{bareBones} have been set to
#' \code{TRUE}, the \code{standAlone} option will take precedence.
#'
#' @param file A character string indicating the desired path to the output
#'   file.
#' @param width The width of the output figure, in \bold{inches}.
#' @param height The height of the output figure, in \bold{inches}.
#' @param onefile Should output be directed to separate environments in a
#'   single file (default \code{TRUE}). If \code{FALSE} this option works
#'   exactly like the argument of the same name to \code{\link{pdf}}
#'   (see there for more details).
#' @param bg The starting background color for the plot.
#' @param fg The starting foreground color for the plot.
#' @param pointsize Base pointsize used in the LaTeX document.  This option is
#'   only used if a valid pointsize cannot be extracted from the value of
#'   \code{getOption("tikzDocumentDeclaration")}.  See the section ``Font Size
#'   Calculations'' in \link{tikzDevice-package} for more details.
#' @param standAlone A logical value indicating whether the output file should
#'   be suitable for direct processing by LaTeX. A value of \code{FALSE}
#'   indicates that the file is intended for inclusion in a larger document.
#'   See \sQuote{Details}.
#' @param bareBones A logical value.  When \code{TRUE} the figure will not be
#'   wrapped in a \code{tikzpicture} environment.  This option is useful for
#'   embedding one TikZ picture within another. When \code{TRUE} multipage
#'   output will be drawn on a single page.
#' @param console Should the output of tikzDevice be directed to the R console
#'   (default \code{FALSE}). This is useful for dumping tikz output directly into a
#'   LaTeX document via \code{\link{sink}}.  If TRUE, the \code{file} argument
#'   is ignored. Setting \code{file=''} is equivalent to setting
#'   \code{console=TRUE}.
#' @param sanitize Should special latex characters be replaced (Default FALSE).
#'   See the section ``Options That Affect Package Behavior'' for which
#'   characters are replaced.
#' @param engine a string specifying which TeX engine to use. Possible values
#'   are 'pdftex', 'xetex' and 'luatex'. See the Unicode section of
#'   \link{tikzDevice-package} for details.
#' @param documentDeclaration See the sections ``Options That Affect Package
#'   Behavior'' and ``Font Size Calculations'' of \link{tikzDevice-package}
#'   for more details.
#' @param packages See the section ``Options That Affect Package Behavior'' of
#'   \link{tikzDevice-package}.
#' @param footer See the section ``Options That Affect Package Behavior'' of
#'   \link{tikzDevice-package}.
#'
#'
#' @return \code{tikz()} returns no values.
#'
#' @note To compile the output of \code{tikz} a working installation of LaTeX
#'   and PGF is needed.  Current releases of the TikZ package are available
#'   from \url{http://www.ctan.org}. The package may also be installed through
#'   the MikTeX package manager on Windows or using the TeX Live package
#'   manager, \code{tlmgr}, on Unix/Linux/OS X. The TeX Live package manager
#'   will only be installed by default for TeX Live distributions dated 2008
#'   and later. Both bleeding-edge and release versions of TikZ may be obtained
#'   from the project website hosted at
#'   \url{http://sourceforge.net/projects/pgf/}.
#'
#' Multiple plots will be placed as separate environments in the output file.
#'
#' @author Charlie Sharpsteen \email{source@@sharpsteen.net} and Cameron
#'   Bracken \email{cameron.bracken@@gmail.com}
#'
#' @seealso \code{\link{pictex}}, \code{\link{getLatexCharMetrics}},
#'   \code{\link{getLatexStrWidth}}, \code{\link{setTikzDefaults}},
#'   \code{\link{tikzAnnotate}}, \code{\link{sanitizeTexString}}
#' @references The TikZ and PGF Packages: Manual for version 2.00\cr
#'   \url{http://sourceforge.net/projects/pgf}\cr Till Tantau, February 20,
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
#' 	plot(1)
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
#'    		  'gamma','gamma','varpi','phi','delta','kappa','rho',
#'    		  'varphi','epsilon','lambda','varrho','chi','varepsilon',
#'    		  'mu','sigma','psi','zeta','nu','varsigma','omega','eta',
#'    		  'xi','Gamma','Lambda','Sigma','Psi','Delta','Xi','Upsilon',
#'    		  'Omega','Theta','Pi','Phi')
#' x <- rnorm(length(syms))
#' y <- rnorm(length(syms))
#'
#' tikz(tf,standAlone=TRUE)
#' 	plot(-2:2, -2:2, type = "n", axes=F,
#' 			xlab='', ylab='', main='TikZ Device Math Example')
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
#' 	plot(-2:2, -2:2, type = "n", axes=F, xlab='', ylab='', main='Random Circles')
#'     points(rnorm(50), rnorm(50), pch=21,
#' 			bg=rainbow(50,alpha=.5), cex=10)
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
#' @useDynLib tikzDevice TikZ_StartDevice
tikz <-
function (file = ifelse(onefile, "./Rplots.tex", "./Rplot%03d.tex"),
  width = 7, height = 7, onefile = TRUE,
  bg="transparent", fg="black", pointsize = 10, standAlone = FALSE,
  bareBones = FALSE, console = FALSE, sanitize = FALSE,
  engine = getOption("tikzDefaultEngine"),
  documentDeclaration = getOption("tikzDocumentDeclaration"),
  packages,
  footer = getOption("tikzFooter")
){

  tryCatch({
    # Ok, this sucks. We copied the function signature of pdf() and got `file`
    # as an argument to our function. We should have copied png() and used
    # `filename`.

    # file_path_as_absolute can give us the absolute path to the output
    # file---but it has to exist first. So, we use file() to "touch" the
    # path.
    touch_file <- suppressWarnings(file(file, 'w'))
    close(touch_file)

    file <- tools::file_path_as_absolute(file)
  },
  error = function(e) {
    stop(simpleError(paste(
      "Cannot create:\n\t", file,
      "\nBecause the directory does not exist or is not writable."
    )))
  })

  # remove the file if we are outputting to multiple files since the file
  # name will get changed in the C code
  if( !onefile ) file.remove(file)

  # Determine which TeX engine is being used.
  switch(engine,
    pdftex = {
      engine <- 1L # In the C routines, a integer value of 1 means pdftex
      if (missing(packages)) {packages <- getOption('tikzLatexPackages')}
    },
    xetex = {
      engine <- 2L
      if (missing(packages)) {packages <- getOption('tikzXelatexPackages')}
    },
    luatex = {
      engine <- 3L
      if (missing(packages)) {packages <- getOption('tikzLualatexPackages')}
    },
    {#ELSE
      stop('Unsupported TeX engine: ', engine,
        '\nAvailable choices are:\n',
        '\tpdftex\n',
        '\txetex\n',
        '\tluatex\n')
    })

  # Ensure the standAlone option will trump the bareBones option.
  if( standAlone ) { bareBones = FALSE }
  if( footer != getOption("tikzFooter") && !standAlone)
    warning( "Footers are ignored when standAlone is set to FALSE" )

  # Extract the document pointsize from the documentDeclaration
  baseSize <- getDocumentPointsize( documentDeclaration )

  # If a pointsize was not found, we use the value of the pointsize
  # argument.
  if( is.na( baseSize ) ){ baseSize <- pointsize }

  # Collapse the character vectors into a single string
  # which is easier to work with in C
  documentDeclaration <-
    paste( paste(documentDeclaration, collapse='\n'), collapse='\n')
  packages <- paste( paste( packages, collapse='\n'), collapse='\n')
  footer <- paste( paste( footer,collapse='\n'), collapse='\n')

  .External(TikZ_StartDevice, file, width, height, onefile, bg, fg, baseSize,
    standAlone, bareBones, documentDeclaration, packages, footer, console,
    sanitize, engine)

  invisible()

}
