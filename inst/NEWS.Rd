\name{NEWS}
\title{News for Package 'tikzDevice'}
\encoding{UTF-8}
\section{Changes in tikzDevice version 0.8.1 (2015-01-07)}{
  \subsection{Bug Fixes}{
    \itemize{
      \item Renamed \code{strlcpy} to \code{strlcpy_} to avoid name clashes on OS X and Solaris (#97).
    }
  }
}
\section{Changes in tikzDevice version 0.8 (2015-01-07)}{
  \subsection{Compatibility}{
    \itemize{
      \item This release doesn't work on OS X and Solaris. This will be resolved soon.
    }
  }
  \subsection{Contributors}{
    \itemize{
      \item Thanks to Greg Jefferis, Bill Venables, Sam Mason, Gvozden Neskovic,
        Martin Bergner and Casper Ti. Vector for contributing to this release.
    }
  }
  \subsection{Features}{
    \itemize{
      \item Add parameter \code{timestamp} to \code{tikz} to make the output of the timestamp optional (#28,
        #73, thanks Martin Bergner).
      \item Add parameter \code{lwdUnit} to \code{tikz} to specify the physical width of a line
        (in points) that is 1 unit wide in R. By default, the value of option
        \code{tikzLwdUnit} is used; this option has a value of 0.4 at startup (#68,
        thanks Casper Ti. Vector).
      \item Optionally use symbolic colors defined in a single external file instead of
        hard-coded colors defined in-place.  New parameters \code{symbolicColors},
        \code{colorFileName} and \code{maxSymbolicColors}; new options \code{tikzSymbolicColors}
        and \code{tikzMaxSymbolicColors}. The external file is only created if requested;
        in this case, symbolic color names are used instead of \code{fillColor} and
        \code{drawColor} (#70, thanks Martin Bergner).
    }
  }
  \subsection{Bug Fixes}{
    \itemize{
      \item Ignore fill color for lines to remove thin line (1 pixel wide) that was shown
        with dashed or dotted lines on some viewers (#63, thanks Martin Bergner).
      \item More robust handling of metrics dictionary.  Changes to the
        \code{tikzMetricsDictionary} option are recognized even if a metrics dictionary
        already has been initialized, a message is printed the first time a dictionary
        is used (in addition to the message that is printed when the dictionary is
        created).  A missing dictionary file is recreated (#21).
      \item Performance improvements with zero-width strings (#66, thanks Gvozden Neskovic)
      \item Add parameter \code{checkstate} to allow adding annotations to a new plot (#52,
        thanks Sam Mason)
      \item Allow raster images to be output without resampling by setting
        \code{options(tikzRasterResolution = NA)} (#54, thanks Sam Mason)
      \item In console mode, print a \code{\\relax} statement after the comment to allow using
        \code{tikzDevice} in a Sweave code chunk with \code{results=tex}, as advertised in the
        vignette.  (The default is \code{strip.white=TRUE} which makes the following
        \code{\\begin\{tikzpicture\}} appear on the same line as the encoding comment in the
        resulting \code{.tex} file.)  (#47, thanks Bill Venables)
    }
  }
  \subsection{Vignette}{
    \itemize{
      \item Use \code{knitr} as vignette builder (#37).
      \item Fixed typos (#45, thanks Greg Jefferis).
      \item Vignette now also compiles if the \code{zi4} TeX package is installed instead of
        \code{inconsolata}.  This should fix the CRAN notes and warnings on Windows.
      \item Loading \code{babel} TeX package to avoid printing tilde in references (#49).
    }
  }
  \subsection{Internal}{
    \itemize{
      \item Tests perform strict image comparison (#18).
      \item Testing now also works in RStudio.
    }
  }
}
\section{Changes in tikzDevice version 0.7.0}{
  \subsection{Contributors}{
    \itemize{
      \item New package maintainers: Kirill Müller and Yihui Xie.
      \item Zack Weinberg for suggestions and comments that led to optimizations in the
        quality and quantity of TikZ output.
      \item Romain Franconville for bugreports that led to the discovery of two bugs in
        the raster routines.
      \item corecode for fixing the getDocumentPointsize routines for corner cases
      \item Sietse Brouwer for enumerating the exact list of LaTeX packages
        \code{tikzDevice} requires and for vignette spelling/style corrections.
      \item Stéphane Laurent for reporting a bug in the detection of the document font size.
    }
  }
  \subsection{New Features}{
    \itemize{
      \item The \code{tikz} function now has a \code{onefile} argument that behaves similar to
        the \code{onefile} argument of the \code{pdf} device (#40).
      \item LuaLaTeX is now supported directly and can be selected by passing
        \code{engine = 'luatex'} to \code{tikz} (#28).
      \item New function \code{tikzCompilerInfo}, reports information concerning the compilers
        used by the tikzDevice
      \item Updated vignette (yihui/tikzDevice#36).
    }
  }
  \subsection{Bug Fixes}{
    \itemize{
      \item Colorized text now obeys transparency settings.
      \item The tikzDevice no longer produces output for plots that are completely
        empty.
      \item The \code{tikz} option \code{footer} now works as described by the documentation.
        Previously, it had no effect (#52).
      \item The \code{tikz} device can now handle raster images with negative widths or
        heights that arise from calling a raster plotting function using reversed
        axes (#53).
      \item Creating raster output with the tikzDevice could mess with the behavior of
        some graphical paramaters such as par('mfrow'). This has been fixed (#54).
      \item Calls to the \code{filehash} package have been protected from user interruptions.
        This should prevent rogue lockfiles and corrupted metrics dictionaries.
      \item The \code{documentDeclaration} and \code{packages} arguments to the \code{tikz} function
        are now used in metric calculations. Previously, only global options were
        consulted.
      \item Properly copy strings containing LaTeX info, avoiding use of freed memory.
      \item Point size of main font in document is now inferred correctly (even if the option
        tikzDocumentDeclaration contains newlines), again fixed
        regexp in getDocumentPointsize (yihui/tikzDevice#34).
      \item Package can be installed in R 3.0.2.
      \item No C warnings when installing (#68).
      \item Function \code{grid.tikzNode} works again, had no effect due to a missing S3
        export.
      \item Fixed formatting of documentation.
    }
  }
  \subsection{Behind the scenes}{
    \itemize{
      \item The tikzDevice now requires R 2.14.0 or later.
      \item Semantic versioning will be used from now on
      \item Package is uploaded to RForge (http://rforge.net)
      \item Enable continuous integration via craigcitro/r-travis.  All supported R
        versions are tested.
      \item Upgrade documentation generation from Roxygen to Roxygen2.
      \item Testing framework updated to use testthat 0.6. Earlier versions of testthat
        are no longer supported due to a switch from Mutatr classes to standard R
        Reference Classes (#56).
      \item Some magic numbers that control the leading used in the margin text of base
        graphics were adjusted to values used by the PDF device. Hopefully this
        will make the spacing used by x axis labels and y axis labels a bit more
        symmetric (#49).
      \item The tikzDevice now delays the creation of clipping scopes until a drawing
        operation occurs that can be clipped. This prevents empty clipping scopes
        from appearing in the output and can reduce the size of the output by ~3/4
        in some cases (#45).
      \item The code that handles line color and fill color has been completely
        refactored to avoid useless operations such as 0 transparency fills and
        draws (#46).
      \item Defer starting new tikzpicture environments (#12).
      \item Replace library.dynam with useDynLib (#50).
      \item Reduce verbosity of start-up message.
      \item Support ggplot 0.9.0.
    }
  }
}
\section{Changes in tikzDevice version 0.6.2 (2011-11-13)}{
  \subsection{New Features}{
    \itemize{
      \item The annotation system has been improved. A new function \code{tikzNode} has been
        added that makes it easy to insert TikZ nodes with custom options and
        content. \code{tikzCoord} is now a wrapper for \code{tikzNode} that simplifies the
        function call required to get a plain coordinate.
      \item Annotation of Grid graphics is now supported. New functions
        \code{tikzAnnotateGrob}, \code{tikzNodeGrob} and \code{tikzCoordGrob} allow the creation of
        Grid grobs that execute annotiation commands when drawn to a \code{tikz} device.
        Wrapper functions \code{grid.tikzAnnotate}, \code{grid.tikzNode} and \code{grid.tikzCoord}
        are also provided. The necessary transformations between Grid coordinates,
        which are viewport-centric, to absolute device coordinates are handled by a
        new function \code{gridToDevice}.
      \item Support has been added for the \code{dev.capabilities} function in R 2.14.0.
    }
  }
  \subsection{Bug Fixes}{
    \itemize{
      \item Fixed a bug where the outline of the background bounding box was being drawn
        with the forground color instead of the background color. This was
        unnoticible except when a non-white background was used. Thanks to Matthieu
        Stigler for reporting.
    }
  }
  \subsection{Behind the Scenes}{
    \itemize{
      \item The tikzDevice is now checked with "visual regression testing" which compares
        the results of graphics tests against a set of standard images using a visual
        diff. If a change occurs that significantly affects font metrics or graphics
        primitives the effects will show up in the diff. Currently, ImageMagick's
        \code{compare} utility is used to calculate differences. This process was inspired
        by the work of Paul Murrell and Stephen Gardiner on the graphicsQC package.
        Future versions of the tikzDevice may use graphicsQC to perform this task.
      \item The tikzDevice Vignette used to employ a rather ugly hack that re-wrote the
        internals of the Sweave driver during processing in order to gain more
        control over syntax highlighting. This hack has been replaced by TeX macros
        that achieve the same result without messing with R.
    }
  }
}
\section{Changes in tikzDevice version 0.6.1}{
  \subsection{Bug Fixes}{
    \itemize{
      \item Fixed a bug where \code{tikz} was not applying background color to the plot
        canvas.
      \item Fixed a Vignette bug caused by an incorrect merge that was breaking the CRAN
        build.
    }
  }
}
\section{Changes in tikzDevice version 0.6.0}{
  \subsection{New Features}{
    \itemize{
      \item Unicode Support!!!! XeLaTeX may now be used calculate metrics and widths for
        Unicode characters. PdfLaTeX remains the default LaTeX compiler, but this may
        be changed by setting the global option \code{tikzDefaultEngine} to \code{xetex}.
      \item New global option \code{tikzXelatexPackages} which contains packages necessary to
        use unicode characters with xelatex.  Specifically, the fontspec and the
        xunicode packages as well as the xetex option to the preview package.
      \item New global option \code{tikzUnicodeMetricPackages} which contains the packages
        necessary to calculate metrics for multibyte unicode characters with xelatex.
      \item New function anyMultibyteUTF8Characters() which will check if the given
        string contains any multibyte unicode characters.  Exposed in the package
        namespace since it is general and may be useful in other applications.
      \item The TikZ device now fully supports the \code{Raster} graphics primitive that was
        added in R 2.11.0 and no longer throws "not implemented" warnings when this
        functionality is used. This is accompilshed by writing raster images to PNG
        files, \code{Rplots_ras#.png}, which are then included in the main TeX file
        \code{Rplots.tex}.
      \item The TikZ device now fully supports the \code{polypath} graphics primitive that was
        added in R 2.12.0 and no longer throws "not implemented" warnings when this
        functionality is used.
    }
  }
  \subsection{Bug Fixes}{
    \itemize{
      \item Fixed a bug where the \code{lwd} parameter used to control line widths was
        declared by tikzDevice to be of type \code{int} when it is actually a \code{double}.
        This was causing line widths to be ignored or miscalculated. Many thanks to
        Baptiste Auguie for reporting this issue.
    }
  }
  \subsection{Depreciation Notices}{
    \itemize{
      \item Versions of R < 2.11.0 are no longer supported due to lack of required
        functions for handling Unicode strings.
    }
  }
  \subsection{Behind the Scenes}{
    \itemize{
      \item New Makefile for executing common development tasks.
      \item Package documentation now handled by \code{roxygen}.  Many thanks to Hadley
        Wickham and Yihui Xie for the \code{Rd2roxygen} package which facilitated this
        switch.
      \item Package test suite completely overhauled and now based on Hadley Wickham's
        \code{test_that} unit testing framework.
    }
  }
}
\section{Changes in tikzDevice version 0.5.3}{
  \subsection{Bug Fixes}{
    \itemize{
      \item R 2.12.x now throws a warning message when shell commands run via \code{system()}
        have non-zero exit conditions.  The metric calculation runs LaTeX on a file
        containing an \\@@end command.  This causes a non zero exit condition.  The end
        result was that users were getting spammed by warning messages.  These
        messages have been gagged for now and a better way to run LaTeX such that a
        non-zero condition can meaningfully indicate an error is being investigated.
      \item The range of characters the default sanitizer looks for has been extended.  It
        should now process all characters that are special to TeX with the exception
        of backslashes.  Documentation has been improved.
      \item Detection of failed string metric calculations has been strengthened and the
        resulting error message has been improved.
    }
  }
}
\section{Changes in tikzDevice version 0.5.2}{
  \subsection{Contributors}{
    \itemize{
      \item mlt for reporting problems with the Sanitize function that led to the
        discovery of two situations where buffer overflows were occurring.
    }
  }
  \subsection{Bug Fixes}{
    \itemize{
      \item Fixed buffer overflows and memory leaks related to string pointers in
        tikzDevice.c.
      \item Fixed compilation of the tikzDevice vignette under R 2.12.0.
      \item Reduced the verbosity of the package startup message.
    }
  }
}
\section{Changes in tikzDevice version 0.5.1}{
  \subsection{Bug Fixes}{
    \itemize{
      \item A stub function has been added so that the \code{polypath()} function
        introduced in R 2.12.0 won't crash the device.
      \item Fixed bug where no string output was shown when the sanitize=TRUE option was
        used.
      \item The path to a LaTeX compiler returned by \code{Sys.which()} is now checked by
        \code{file.access()} to check that it is actually an executable and not an error
        message.  This fixes issues arising from \code{Sys.which()} on Solaris.
      \item On UNIX platforms, \code{/usr/texbin/pdflatex} is added to the end of the list of
        places to search for a LaTeX compiler.  This should help people using R.app on
        OS X find a LaTeX compiler without having to manually specify it.
      \item \code{tikz()} produces a better error message when it cannot open a file for output.
      \item In the event that LaTeX crashes during a metric calculation, the LaTeX log
        output is echoed using \code{message()} instead of \code{cat()}.  This makes it show up
        during operations that supperss \code{cat()} output such as \code{R CMD build} and
        \code{R CMD Sweave}.
    }
  }
}
\section{Changes in tikzDevice version 0.5.0}{
  \subsection{Contributors}{
    \itemize{
      \item Lorenzo Isella contributed bug reports and examples that led to the
        discovery of a bug in fontsize calculations that appeared when
        certain LaTeX commands were used to change the active font.
      \item Vivianne Vilar for spotting spelling and grammar errors in the
        vignette.
      \item Gabor Grothendieck for the idea for sending output to the screen
        for use with sink() (i.e. the "console" option)
    }
  }
  \subsection{New Features}{
    \itemize{
      \item "console" option for directing tikz() output back into the R console
        instead of to a file.
      \item Preliminary support for a "sanitize" option which allows automatic
        escaping of characters that have special meaning to TeX like "$" and
      \item tikzAnnotate() and tikzCoord() functions.  tikzAnnotate() allows
        arbitrary LaTeX code to be injected into the output stream of an
        active tikz() graphics device.  tikzCoord() is a wrapper for
        tikzAnnotate() that inserts named locations into the graphics code.
        These locations may be referenced by other TikZ drawing commands.
    }
  }
  \subsection{Bug Fixes}{
    \itemize{
      \item Removed bad colon in the DESCRIPTION file.
      \item Proper fontsize calculations now include ps from par() and fontsize
        from gpar().  This fixes issues with lattice-based graphics such as
        ggplot2.
      \item Metrics are now calculated properly when commands like
        \\renewcommand\\rmdefault are used to adjust the active font.
      \item Sanitization of \% signs in labels.
      \item The package no longer overwrites user customizations set in places like
        .Rprofile with default values when loaded.
      \item Attempting to use new graphics functions such as rasterImage() now
        produces error messages instead of fatal crashes in R 2.11.0 and
        above.
    }
  }
}
\section{Changes in tikzDevice version 0.4.0}{
  \itemize{
    \item Initial Beta Release
    \item Support for all essential graphical parameters: colors, line types,
      line weights, semi-transparency, line endings and line joining.
    \item String width and character metrics are calculated by direct calls to a LaTeX
      compiler. This is an inefficient but robust method. Some of the inefficiency
      of this method is compensated for by storing calculated string widths in a
      database managed by the filehash package. This way if we pay a computational
      price to compute the width of a string, we
      hopefully only pay it once.
  }
}
