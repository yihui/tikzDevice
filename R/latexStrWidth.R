#' Obtain Font Metrics from LaTeX
#'
#' These functions calculate the width of a character or string as it would
#' appear after being compiled by LaTeX.
#'
#' These functions are used internally by the \code{tikz} device for proper
#' string placement in graphics.  Both functions check to see if metrics exist
#' in a global or temporary dictionary (as defined in
#' \code{options('tikzMetricsDictionary')}) and if so will pull the metrics
#' from there. If the dictionary does not exist, then a temporary one is
#' created for the current R session. Metrics are calculated via \code{system}
#' calls to LaTeX compilers. Querying compilers to calculate metrics is
#' expensive and so we strongly recommend setting
#' \code{options('tikzMetricsDictionary') <- /path/to/dictionary} to create a
#' global dictionary.
#'
#' @param texString An arbitrary string for which the width is to be
#'   calculated.  May contain LaTeX markup.
#' @param cex a real number that specifies a scaling factor that is to be
#'   applied to device output.
#' @param face an integer in the range [1-5] that specifies the font face to
#'   use. See \link{par} for details.
#' @param engine a string specifying which TeX engine to use. Possible values
#'   are 'pdftex', 'xetex' and 'luatex'. See the Unicode section of \link{tikzDevice} for
#'   details.
#' @param documentDeclaration See the sections ``Options That Affect Package
#'   Behavior'' and ``Font Size Calculations'' of \link{tikzDevice-package}
#'   for more details.
#' @param packages See the section ``Options That Affect Package Behavior'' of
#'   \link{tikzDevice-package}.
#'
#'
#' @return
#'   \item{getLatexStrWidth}{The width of \code{texString} in points.}
#'   \item{getLatexCharMetrics}{A numeric vector holding ascent, descent
#'     and width. Values should all be nonnegative.}
#'
#' @author Charlie Sharpsteen \email{source@@sharpsteen.net} and Cameron
#'   Bracken \email{cameron.bracken@@gmail.com}
#'
#' @keywords string character metrics
#'
#' @examples
#'
#'    getLatexStrWidth('{\\\\tiny Hello \\\\LaTeX!}')
#'
#' @references PGF Manual
#' @export
getLatexStrWidth <-
function(texString, cex = 1, face = 1, engine = getOption('tikzDefaultEngine'),
   documentDeclaration = getOption("tikzDocumentDeclaration"), packages)
{

  switch(engine,
    pdftex = {
      if ( anyMultibyteUTF8Characters(texString) && getOption('tikzPdftexWarnUTF') ) {
        warning("Attempting to calculate the width of a Unicode string",
            "using the pdftex engine. This may fail! See the Unicode",
            "section of ?tikzDevice for more information.")
      }
      if (missing(packages)) {packages <- getOption('tikzLatexPackages')}
    },

    xetex = {
      if (is.null(getOption('tikzXelatex'))) {
        stop("Cannot find XeLaTeX! Please check your system",
            "configuration or manually provide a value for",
            "options(tikzXelatex)")
      }
      if (missing(packages)) {packages <- getOption('tikzXelatexPackages')}
    },

    luatex = {
      if (is.null(getOption('tikzLualatex'))) {
        stop("Cannot find LuaLaTeX! Please check your system",
            "configuration or manually provide a value for",
            "options(tikzLualatex)")
      }
      if (missing(packages)) {packages <- getOption('tikzLualatexPackages')}
    },

    {#ELSE
      stop('Unsupported TeX engine: ', engine,
        '\nAvailable choices are:\n',
        '\tpdftex\n',
        '\txetex\n',
        '\tluatex\n')
    }
  )

  # Create an object that contains the string and it's
  # properties.
  TeXMetrics <- list( type='string', scale=cex, face=face, value=texString,
    documentDeclaration = documentDeclaration,
    packages = packages, engine = engine)


  # Check to see if we have a width stored in
  # our dictionary for this string.
  width <- queryMetricsDictionary( TeXMetrics )

  if( width > 0 ){

    # Positive string width means there was a
    # cached value available. Yay! We're done.
    return( width )

  }else{

    # Bummer. No width on record for this string.
    # Call LaTeX and get one.
    width <- getMetricsFromLatex( TeXMetrics )

    if (is.null(width)) {
      # Something went wrong. Return 0
      return(0)
    } else {
      # Store the width in the dictionary so we don't
      # have to do this again.
      storeMetricsInDictionary( TeXMetrics, width )

      # Return the width.
      return( width )
    }

  }
}


#' @rdname getLatexStrWidth
#'
#' @param charCode an integer that corresponds to a symbol in the ASCII
#'   character table under the Type 1 font encoding. All numeric values are
#'   coerced using \code{as.integer}. Non-numeric values will not be accepted.
#'
#' @examples
#'
#'   # Calculate ascent, descent and width for "A"
#'   getLatexCharMetrics(65)
#'
#' @export
getLatexCharMetrics <-
function(charCode, cex = 1, face = 1, engine = getOption('tikzDefaultEngine'),
  documentDeclaration = getOption("tikzDocumentDeclaration"), packages)
{

  # This function is pretty much an exact duplicate of getLatexStrWidth, these
  # two functions should be generalized and combined.
  switch(engine,
    pdftex = {
      if (missing(packages)) {packages <- getOption('tikzLatexPackages')}
    },

    xetex = {
      if (is.null(getOption('tikzXelatex'))) {
        stop("Cannot find XeLaTeX! Please check your system",
            "configuration or manually provide a value for",
            "options(tikzXelatex)")
      }
      if (missing(packages)) {packages <- getOption('tikzXelatexPackages')}
    },

    luatex = {
      if (is.null(getOption('tikzLualatex'))) {
        stop("Cannot find LuaLaTeX! Please check your system",
            "configuration or manually provide a value for",
            "options(tikzLualatex)")
      }
      if (missing(packages)) {packages <- getOption('tikzLualatexPackages')}
    },

    {#ELSE
      stop('Unsupported TeX engine: ', engine,
        '\nAvailable choices are:\n',
        '\tpdftex\n',
        '\txetex\n',
        '\tluatex\n')
    }
  )

  # We must be given an integer character code.
  if ( !is.numeric(charCode) ) {
    warning("getLatexCharMetrics only accepts integers!")
    return(NULL)
  }

  if ( engine == 'pdftex' && !(charCode > 31 && charCode < 127 ) ) {
    if (getOption('tikzPdftexWarnUTF')) {
      warning("pdftex can only generate metrics for character codes ",
          "between 32 and 126! See the Unicode section of ?tikzDevice ",
          "for more information.")
    }
    return(NULL)
  }

  # Coerce the charCode to integer in case someone was being funny
  # and passed a float.
  #
  # IMPORTANT: The charCode must be in UTF-8 encoding or else funny business
  #            will likely occur.
  charCode <- as.integer( charCode )

  # Create an object that contains the character and it's
  # properties.
  TeXMetrics <- list( type='char', scale=cex, face=face, value=charCode,
    documentDeclaration = documentDeclaration,
    packages = packages, engine = engine)

  # Check to see if we have metrics stored in
  # our dictionary for this character.
  metrics <- queryMetricsDictionary( TeXMetrics )

  if( all(metrics >= 0) ){

    # The metrics should be a vector of three non negative
    # numbers.
    return( metrics )

  }else{

    # Bummer. No metrics on record for this character.
    # Call LaTeX to obtain them.
    metrics <- getMetricsFromLatex( TeXMetrics )

    if (is.null(metrics)) {
      # Couldn't get metrics for some reason, return 0
      return(c(0, 0, 0))
    } else {
      # Store the metrics in the dictionary so we don't
      # have to do this again.
      storeMetricsInDictionary( TeXMetrics, metrics )

      return( metrics )
    }

  }
}

.metricsMethods <- c("robust", "preamble")

getMetricsFromLatex <-
function( TeXMetrics ){

  # Reimplementation of the original C function since
  # the C function causes all kinds of gibberish to
  # hit the screen when called under Windows and
  # Linux.
  #
  #  On both platforms this causes the whole process
  # of calling LaTeX in order to obtain string width
  # to take even longer.
  #
  # Oh. And Windows couldn't nut up and make it through
  # the C process so it shat its self and died.


  # Create the TeX file in a temporary directory so
  # it doesn't clutter anything.
  texDir <- tempdir()
  texLog <- file.path( texDir,'tikzStringWidthCalc.log' )
  texOut <- file.path( texDir,'tikzMetrics.out' )
  texFile <- file.path( texDir,'tikzStringWidthCalc.tex' )

  # Open the TeX file for writing.
  texIn <- file( texFile, 'w')

  # Recover the latex command.
  latexCmd <- getLatexCmd(TeXMetrics$engine)

  method <- getOption('tikzMetricsMethod', )
  method.pos <- pmatch(method, .metricsMethods, 0L)
  if (is.na(method.pos)) method.pos <- 1L
  if (method.pos == 0L) {
    if (is.null(.tikzInternal$warnMetricsMethod) ||
          .tikzInternal$warnMetricsMethod != method) {
      warning("Unsupported value for option tikzMetricsMethod: ", method,
              "\nSupported values: ", paste(.metricsMethods, collapse=", "))
      method.pos <- 1L
      .tikzInternal$warnMetricsMethod <- method
    }
  }
  method <- .metricsMethods[method.pos]

  preamble <- getPreamble(TeXMetrics)
  writePreamble <- TRUE
  if (method == "preamble" && is.null(.tikzInternal$avoidPreambleMetricsMethod)) {
    ppName <- providePrecompiledPreamble(preamble, TeXMetrics$engine, texDir)
    if (!is.na(ppName)) {
      writeLines(sprintf("%%&%s", ppName), texIn)
      writePreamble <- FALSE
    }
  }

  if (writePreamble) {
    writeLines(preamble, texIn)
  }

  # Begin a tikz picture.
  writeLines("\\begin{document}\n\\begin{tikzpicture}", texIn)

  # Open a file for metrics output.
  writeLines(
    c(
      "\\newwrite\\tikzMetrics",
      "\\immediate\\openout\\tikzMetrics=tikzMetrics.out\\relax"),
    texIn
  )

  # Insert the value of cex into the node options.
  nodeOpts <- paste('\\node[inner sep=0pt, outer sep=0pt, scale=',
    TeXMetrics$scale,']', sep='')

  # Create the node contents depending on the type of metrics
  # we are after.

  # First, which font face are we using?
  #
  # From ?par:
  #
  # font
  #
  #    An integer which specifies which font to use for text. If possible,
  #    device drivers arrange so that 1 corresponds to plain text (the default),
  #    2 to bold face, 3 to italic and 4 to bold italic. Also, font 5 is expected
  #    to be the symbol font, in Adobe symbol encoding. On some devices font families
  #    can be selected by family to choose different sets of 5 fonts.

  nodeContent <- ''
  switch( TeXMetrics$face,

    normal = {
      # We do nothing for font face 1, normal font.
    },

    bold = {
      # Using bold, we set in bold *series*
      nodeContent <- '\\bfseries'
    },

    italic = {
      # Using italic, we set in the italic *shape*
      nodeContent <- '\\itshape'
    },

    bolditalic = {
      # With bold italic we set in bold *series* with italic *shape*
      nodeContent <- '\\bfseries\\itshape'
    },

    symbol = {
      # We are currently ignoring R's symbol fonts.
    }

  ) # End output font face switch.


  # Now for the content. For string width we set the whole string in
  # the node. For character metrics we have an integer corresponding
  # to a posistion in the ASCII character table- so we use the LaTeX
  # \char command to translate it to an actual character.
  switch( TeXMetrics$type,

    string = {

      nodeContent <- paste( nodeContent,TeXMetrics$value )

    },

    char = {

      nodeContent <- paste( nodeContent,'\\char',TeXMetrics$value, sep='' )

    }

  )# End switch for metric type.

  writeLines( paste( nodeOpts, ' (TeX) {', nodeContent, "};", sep=''), texIn)

  # We calculate width for both characters and strings.
  writeLines("\\path let \\p1 = ($(TeX.east) - (TeX.west)$),
    \\n1 = {veclen(\\x1,\\y1)} in (TeX.east) -- (TeX.west)
    node{ \\immediate\\write\\tikzMetrics{\\n1} };", texIn)

  # We only want to calculate ascent and descent when dealing with
  # single characters.
  if( TeXMetrics$type == 'char' ){

    # Calculate the ascent and print it to the log.
    writeLines("\\path let \\p1 = ($(TeX.north) - (TeX.base)$),
      \\n1 = {veclen(\\x1,\\y1)} in (TeX.north) -- (TeX.base)
      node{ \\immediate\\write\\tikzMetrics{\\n1} };", texIn)

    # Calculate the descent and print it to the log.
    writeLines("\\path let \\p1 = ($(TeX.base) - (TeX.south)$),
      \\n1 = {veclen(\\x1,\\y1)} in (TeX.base) -- (TeX.south)
      node{ \\immediate\\write\\tikzMetrics{\\n1} };", texIn)

  }

  # Close output file.
  writeLines(
    "\\immediate\\close\\tikzMetrics",
    texIn
  )

  # Stop before creating output
  writeLines("\\makeatletter", texIn)
  writeLines("\\@@end", texIn)

  # Close the LaTeX file, ready to compile
  close( texIn )

  # Append the batchmode flag to increase LaTeX
  # efficiency.
  latexCmdFull <- paste( latexCmd, '-interaction=batchmode', '-halt-on-error',
    '-output-directory', texDir, texFile)

  # avoid warnings about non-zero exit status, we know tex exited abnormally
  # it was designed that way for speed
  suppressWarnings(silence <- system( latexCmdFull, intern=TRUE, ignore.stderr=TRUE))

  if (TeXMetrics$engine == 'xetex') {
    # Read the contents of the log file.
    logContents <- readLines( texLog )

    # Check to see if XeLaTeX was unable to typeset any Unicode characters.
    missing_glyphs <- logContents[grep('^\\s*Missing character: There is no',
        logContents )]

    if (length(missing_glyphs)) {
      warning('XeLaTeX was unable to calculate metrics for some characters:\n',
        paste('\t', missing_glyphs, collapse = '\n') )

      # Bail out of the calculation
      return(NULL)
    }
  }

  # Read the contents of the output file.
  metrics.text <- if (file.exists(texOut)) readLines( texOut ) else character()
  metrics <- extractNum( metrics.text )

  # complete.cases() checks for NULLs, NAs and NaNs
  if( length(metrics) == 0 || any(!complete.cases(metrics)) ){

    message(paste(readLines(texFile),collapse='\n'))
    message(paste(readLines(texLog),collapse='\n'))
    stop('\nTeX was unable to calculate metrics for the following string\n',
      'or character:\n\n\t',
      TeXMetrics$value, '\n\n',
      'Common reasons for failure include:\n',
      '  * The string contains a character which is special to LaTeX unless\n',
      '    escaped properly, such as % or $.\n',
      '  * The string makes use of LaTeX commands provided by a package and\n',
      '    the tikzDevice was not told to load the package.\n\n',
      'The contents of the LaTeX log of the aborted run have been printed above,\n',
      'it may contain additional details as to why the metric calculation failed.\n'
    )

  }

  # If we're dealing with a string, we're done.
  if( TeXMetrics$type == 'string' ){

    return( as.double( metrics[1] ) )

  }else{

    # For a character, we want ascent and descent too.
    return( as.double( metrics[c(2, 3, 1)] ) )

  }

}

getPreamble <- function(TeXMetrics) {
  c(
    getOption("tikzDocumentDeclaration"),

    # Add extra packages, it wont really matter if the user puts
    # in duplicate packages or many irrelevant packages since they
    # mostly wont be used. The packages we do care about are the
    # font ones. I suppose it is possible that the user could add
    # some wacky macros that could screw stuff up but lets pretend
    # that cant happen for now.
    #
    # Also, we load the user packages last so the user can override
    # things if they need to.
    #
    # The user MUST load the tikz package here.
    #
    # Load important packages for calculating metrics, must use different
    # packages for (multibyte) unicode characters.
    TeXMetrics$packages,

    getOption(
      switch(
        TeXMetrics$engine,
        pdftex = 'tikzMetricPackages',
        xetex = 'tikzUnicodeMetricPackages',
        luatex = 'tikzUnicodeMetricPackages'
      )
    ),

    "\\batchmode"
  )
}

providePrecompiledPreamble <- function(preamble, engine, texDir) {
  if (engine != "pdftex") {
    if (is.null(.tikzInternal$warnNonPdfTeXPreamble)) {
      warning("The preamble method is only available with the pdftex engine.\n",
              "Falling back to robust method.")
      .tikzInternal$warnNonPdfTeXPreamble <- TRUE
    }

    return (NA)
  }

  tryCatch(
    {
      preambleHash <- sha1(c(engine, preamble))
      formatFileBase <- sprintf("%s-%s", .tikzInternal$dictionaryFile, preambleHash)
      formatFileName <- sprintf("%s.fmt", formatFileBase)
      if (!file.exists(formatFileName)) {
        message("Creating precompiled preamble at:\n ", formatFileName)
        texFile <- file.path(texDir, 'tikzStringWidthCalc.ltx')
        writeLines(preamble, texFile)
        on.exit(unlink(texFile), add=TRUE)
        latexCmd <- getLatexCmd(engine)
        latexFormat <- basename(latexCmd)
        latexCmdFull <- paste(
          latexCmd, '-ini', '-output-directory', shQuote(texDir),
          shQuote(sprintf("&%s %s\\dump", latexFormat, texFile)) )

        status <- system(latexCmdFull, ignore.stdout=TRUE, ignore.stderr=TRUE)
        stopifnot(status == 0)

        file.copy(file.path(texDir, 'tikzStringWidthCalc.fmt'),
                  formatFileName)
        unlink(file.path(texDir, 'tikzStringWidthCalc.fmt'))
      }

      formatFileBase
    },

    error=function(e) {
      warning("Could not measure using preamble method.\n",
              "Falling back to robust method for this session.")
      .tikzInternal$avoidPreambleMetricsMethod <- TRUE
      NA_character_
    }
  )
}

getLatexCmd <- function(engine) {
  switch(engine,
         pdftex = getOption('tikzLatex'),
         xetex  = getOption('tikzXelatex'),
         luatex  = getOption('tikzLualatex'),
  )
}

extractNum <-
function( string ){

  string <- gsub( '[A-Za-z]', '', string )

  return( string )

}
