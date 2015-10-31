.onLoad <-
function(libname, pkgname) {

  # Ensure options are set.
  setTikzDefaults( overwrite = FALSE )

  # Perform a search for executable TeX compilers. R options, environment
  # variables and common paths will be checked. If PdfLaTeX can not be found,
  # loading of this package will be aborted as a LaTeX compiler is required in
  # order to determine string metrics. Other compilers, such as XeLaTeX, are
  # optional.
  foundLatex <- FALSE
  foundXelatex <- FALSE
  foundLualatex <- FALSE

  latexLocs <- list(
    OPTION('tikzLatex'),
    ENV_VAR('R_LATEXCMD'),
    ENV_VAR('R_PDFLATEXCMD'),
    OPTION('latexcmd'),
    PATH('pdflatex'),
    PATH('latex')
  )

  # Only check for xelatex and lualatex in the options and the PATH variable
  # since there are no R environment variables for these compilers.
  xelatexLocs <- list(
    OPTION('tikzXelatex'),
    PATH('xelatex')
  )

  lualatexLocs <- list(
    OPTION('tikzLualatex'),
    PATH('lualatex')
  )

  # Non-Windows users are likely to use some derivative of TeX Live. This next
  # test primarily covers the fact that R.app does not include `/usr/texbin` on
  # the search path on OS X.
  if( .Platform[['OS.type']] == 'unix' ){
    # Using explicit list insertion because the `c` function drops attributes
    # and thus destroys S3 objects. Writing 3 new class methods for PATH,
    # OBJECT and ENV_VAR is just overkill.
    latexLocs[[length(latexLocs) + 1]] <- PATH('/usr/texbin/pdflatex')
    xelatexLocs[[length(xelatexLocs) + 1]] <- PATH('/usr/texbin/xelatex')
    lualatexLocs[[length(lualatexLocs) + 1]] <- PATH('/usr/texbin/lualatex')
  }

  for ( latexPath in latexLocs ) {
    if ( isExecutable(latexPath) ) {
      foundLatex <- TRUE
      options(tikzLatex = as.character(latexPath), tikzLatexDefault = as.character(latexPath))
      break
    }
  }

  for( xelatexPath in xelatexLocs ) {
    if( isExecutable(xelatexPath) ) {
      foundXelatex <- TRUE
      options(tikzXelatex = as.character(xelatexPath), tikzXelatexDefault = as.character(xelatexPath))
      break
    }
  }

  for( lualatexPath in lualatexLocs ) {
    if( isExecutable(lualatexPath) ) {
      foundLualatex <- TRUE
      options(tikzLualatex = as.character(lualatexPath), tikzLualatexDefault = as.character(lualatexPath))
      break
    }
  }

  if (!foundLatex ) {
    warning("\n\ntikzDevice: No appropriate LaTeX compiler could be found.\n",
      "Access to LaTeX is required in order for the TikZ device\n",
      "to produce output.\n\n",
      "The following places were tested for a valid LaTeX compiler:\n\n\t",
      paste( sapply(latexLocs, format),collapse='\n\t'),
      "\n\nIf you have a working LaTeX compiler, try one of the\n",
      "following solutions:",

      "\n\n\tSet the path to your compiler as the value of either latexcmd or",
      "\n\ttikzLatex in .Rprofile using options().",

      "\n\n\tSet the path to your compiler as the value of either R_LATEXCMD or",
      "\n\tR_PDFLATEXCMD in .Renviron.",

      "\n\n\tEnsure the folder containing your compiler is included in PATH.\n"
    )
  }

}

# Any variables defined in here will be hidden
# from normal users.
.tikzInternal <- new.env()
