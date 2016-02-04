# Switch to the detailed reporter implemented in helper_reporters.R
with_reporter(MultiReporter$new(reporters = list(get_reporter(), GraphicsReporter$new())), {

test_graphs <- list(
  list(
    short_name = 'hello_TeX',
    description = 'Draw a circle and some simple text',
    tags = c('base', 'text'),
    graph_code = quote({
      plot(1, axes=F, xlab='', ylab='')
      text(1, 1.1, 'Hello TeX')
    })
  ),

  list(
    short_name = 'graph_box',
    description = 'Draw a box around a graph',
    tags = c('base'),
    graph_code = quote({
      plot(1, type='n', axes=F)
      box()
    })
  ),

  list(
    short_name = 'text_color',
    description  = 'Draw colorized text',
    tags = c('base', 'text'),
    graph_code = quote({
      plot(1, type='n')
      text(0.8,0.8,'red',col='red')
      text(1.2,1.2,'blue',col=rgb(0,0,1,0.5),cex=2)
    })
  ),

  list(
    short_name = 'plot_legend',
    description = 'Draw a legend box',
    tags = c('base'),
    graph_code = quote({
      plot(1,1, xlim=c(0,10), ylim=c(0,10))

      legend( x='top', title='Legend Test', legend=c('Hello, world!'), inset=0.05 )

      legend( 6, 4, title='Another Legend Test', legend=c('Test 1','Test 2'), pch=c(1,16))
    })
  ),

  list(
    short_name = 'pch_caracters',
    description = 'Draw common plotting characters',
    tags = c('base'),
    graph_code = quote({
      # Magic stuff taken from example(points)
      n <- floor(sqrt(26))
      npchIndex <- 0:(25)

      ix <- npchIndex %/% n
      iy <- 3 + (n-1) - npchIndex %% n

      rx <- c(-1,1)/2 + range(ix)
      ry <- c(-1,1)/2 + range(iy)

      # Set up plot area
      plot(rx, ry, type="n", axes=F, xlab='', ylab='', sub="Standard R plotting characters")

      # Plot characters.
      for( i in 1:26 ){

        points(ix[i], iy[i], pch=i-1)
        # Place text label so we know which character is being plotted.
        text(ix[i]-0.3, iy[i], i-1 )

      }
    })
  ),

  list(
    short_name = 'draw_circles',
    description = 'Draw circles',
    tags = c('base'),
    graph_code = quote({
      plot(-2:2, -2:2, type = "n", axes=F, xlab='', ylab='')
      points(rnorm(10), rnorm(10), col = "red")
      points(rnorm(10)/2, rnorm(10)/2, col = "blue")
    })
  ),

  list(
    short_name = 'draw_filled_circles',
    description = 'Draw filled circles',
    tags = c('base'),
    graph_code = quote({
       plot(-2:2, -2:2, type = "n", axes=F, xlab='', ylab='')
       points(rnorm(10), rnorm(10), pch=21, col='blue', bg='forestgreen')
    })
  ),

  list(
    short_name = 'line_color',
    description = 'Draw colored lines',
    tags = c('base'),
    graph_code = quote({
      plot(c(0,1), c(0,1), type = "l", axes=F,
              xlab='', ylab='', col='red3')
    })
  ),

  list(
    short_name = 'line_color_width',
    description = 'Draw colored lines with changed line width',
    tags = c('base'),
    graph_options = list(
      tikzLwdUnit = 72.27/96
    ),
    graph_code = quote({
      plot(c(0,1), c(0,1), type = "l", axes=F,
           xlab='', ylab='', col='red3')
    })
  ),

  list(
    short_name = "character_expansion",
    description = "Test character expansion",
    tags = c('base'),
    graph_code = quote({
       plot(1, axes=F, xlab='', ylab='', cex=10)
       points(1, cex=.5)
    })
  ),

  list(
    short_name = 'filled_rectangle',
    description = 'Test filled rectangles',
    tags = c('base'),
    graph_code = quote({
      plot(-2:2, -2:2, type = "n", axes=F, xlab='', ylab='')
      points(rnorm(10), rnorm(10), pch=22, col='red', bg='gold')
    })
  ),

  list(
    short_name = 'line_types',
    description = 'Test line types',
    tags = c('base'),
    graph_code = quote({
      plot(0, type='n', xlim=c(0,1), ylim=c(0,6),
              axes=F, xlab='', ylab='')
      for(i in 0:6)
        lines(c(0, 1), c(i, i), lty=i)
    })
  ),

  list(
    short_name = 'line_weights',
    description = 'Test line weights',
    tags = c('base'),
    graph_code = quote({
      plot(0, type='n', xlim=c(0,1), ylim=c(0,6),
              axes=F, xlab='', ylab='')
      for(i in 0:6)
        lines(c(0,1), c(i,i), lwd=i)
    })
  ),

  list(
    short_name = 'transparency',
    description = 'Test transparency',
    tags = c('base'),
    graph_code = quote({
      plot(-2:2, -2:2, type = "n", axes=F, xlab='', ylab='')
      points(rnorm(50), rnorm(50), pch=21, bg=rainbow(50,alpha=.5), cex=10)
    })
  ),

  list(
    short_name = 'lots_of_elements',
    description = 'Test of many points for file size',
    tags = c('base'),
    graph_code = quote({
      plot(-2:2, -2:2, type = "n", axes=F, xlab='', ylab='')
      points(rnorm(500), rnorm(500), pch=21, bg=rainbow(50,alpha=.5), cex=10)
    })
  ),

  list(
    short_name = 'contour_lines',
    description = 'Test contour lines and associated text',
    tags = c('base', 'text'),
    graph_code = quote({
      x <- -6:16
      op <- par(mfrow = c(2, 2))
      contour(outer(x, x), method = "edge")
      z <- outer(x, sqrt(abs(x)), FUN = "/")
      image(x, x, z)
      contour(x, x, z, col = "pink", add = TRUE, method = "edge")
      contour(x, x, z, ylim = c(1, 6), method = "simple", labcex = 1)
      contour(x, x, z, ylim = c(-6, 6), nlev = 20, lty = 2, method = "simple")
      par(op)
    })
  ),

  list(
    short_name = 'string_placement',
    description = 'Test string placement and TeX symbol generation',
    tags = c('base', 'text'),
    graph_code = quote({
      syms <-c('alpha','theta','tau','beta','vartheta','pi','upsilon',
            'gamma','gamma','varpi','phi','delta','kappa','rho','varphi',
            'epsilon','lambda','varrho','chi','varepsilon','mu','sigma',
            'psi','zeta','nu','varsigma','omega','eta','xi','Gamma',
            'Lambda','Sigma','Psi','Delta','Xi','Upsilon','Omega',
            'Theta','Pi','Phi')
      x <- rnorm(length(syms))
      y <- rnorm(length(syms))
      plot(-2:2, -2:2, type = "n", axes=F, xlab='', ylab='')
      points(x, y, pch=21,  bg='black', cex=.5)
      text(x,y,paste('\\Large$\\',syms,'$',sep=''))
    })
  ),

  list(
    short_name = 'text_alignment',
    description = 'Test text alignment',
    tags = c('base', 'text'),
    graph_code = quote({
      plot(1,1,type='n',xlab='',ylab='',axes=F)
      abline(v=1)

      #left justified
      par(adj = 0)
      text(1,1.1,'Left')

      #Center Justified
      par(adj = 0.5)
      text(1,1,'Center')

      #Right Justified
      par(adj = 1)
      text(1,0.9,'Right')
    })
  ),

  list(
    short_name = 'persp_3D',
    description = 'Test of 3D graphs with persp',
    tags = c('base', '3D'),
    graph_code = quote({
      x <- seq( -1.95, 1.95, length=30 )
      y <- seq( -1.95, 1.95, length=35 )

      z <- outer( x, y, function(a,b){ a*b^2 } )

      nrz <- nrow(z)
      ncz <- ncol(z)

      jet.colors <- colorRampPalette( c("blue", "green") )

      nbcol <- 100

      color <- jet.colors(nbcol)

      zfacet <- z[-1,-1] + z[-1,-ncz] + z[-nrz, -1] + z[-nrz, -ncz]
      facetcol <- cut(zfacet, nbcol)

      persp(x, y, z, col=color[facetcol], phi=30, theta=-30, ticktype='detailed')
    })
  ),

  list(
    short_name = 'base_annotation',
    description = 'Annotation of base graphics',
    tags = c('base', 'annotation'),
    graph_options = list(
      tikzLatexPackages = c(getOption('tikzLatexPackages'),
        "\\usetikzlibrary{decorations.pathreplacing}",
        "\\usetikzlibrary{positioning}",
        "\\usetikzlibrary{shapes.arrows,shapes.symbols}"
      )
    ),
    fuzz = 130,
    graph_code = quote({

      p <- rgamma (300 ,1)
      outliers <- which( p > quantile(p,.75)+1.5*IQR(p) )
      boxplot(p)

      # Add named coordinates that other TikZ commands can hook onto
      tikzCoord(1, min(p[outliers]), 'min outlier')
      tikzCoord(1, max(p[outliers]), 'max outlier')

      # Use tikzAnnotate to insert arbitrary code, such as drawing a fancy path
      # between min outlier and max outlier.
      tikzAnnotate(c("\\draw[very thick,red,",
        # Turn the path into a brace.
        'decorate,decoration={brace,amplitude=12pt},',
        # Shift it 1em to the left of the coordinates
        'transform canvas={xshift=-1em}]',
        '(min outlier) --',
        # Add a node with some text in the middle of the path
        'node[single arrow,anchor=tip,fill=white,draw=green,',
        'left=14pt,text width=0.70in,align=center]',
        '{Holy Outliers Batman!}', '(max outlier);'))

      # tikzNode can be used to place nodes with customized options and content
      tikzNode(
        opts='starburst,fill=green,draw=blue,very thick,right=of max outlier',
        content='Wow!'
      )

    })
  ),

  list(
    short_name = 'grid_annotation',
    description = 'Annotation of grid graphics',
    tags = c('grid', 'annotation'),
    graph_options = list(
      tikzLatexPackages = c(getOption('tikzLatexPackages'),
        "\\usetikzlibrary{shapes.callouts}"
      )
    ),
    fuzz = 745,
    graph_code = quote({

      library(grid)

      pushViewport(plotViewport())
      pushViewport(dataViewport(1:10, 1:10))

      grid.rect()
      grid.xaxis()
      grid.yaxis()
      grid.points(1:10, 1:10)

      for ( i in seq(2,8,2) ){
        grid.tikzNode(i,i,opts='ellipse callout,draw,anchor=pointer',content=i)
      }

    })
  ),

  list(
    short_name = 'annotation_noflush',
    description = 'Annotation prior to any graphics output',
    tags = c('base', 'annotation'),
    graph_code = quote({
        plot.new()
        plot.window(0:1, 0:1)
        tikzCoord(0, 0, name="ll")
        tikzCoord(1, 1, name="ur")
        tikzAnnotate('\\draw (ll) rectangle (ur);');
    })
  ),

  list(
    short_name = 'ggplot2_test',
    description = 'Test of ggplot2 graphics',
    tags = c('ggplot2'),
    graph_code = quote({
      sink(tempfile())
      suppressPackageStartupMessages(library(mgcv))
      suppressPackageStartupMessages(library(ggplot2))
      sink()
      print(qplot(carat, price, data = diamonds, geom = "smooth",
      colour = color))
    })
  ),

  list(
    short_name = 'ggplot2_superscripts',
    description = 'Test of grid text alignment with ggplot2',
    tags = c('ggplot2', 'text'),
    graph_code =  quote({
      sink(tempfile())
      suppressPackageStartupMessages(library(ggplot2))
      sink()

      soilSample <- structure(list(`Grain Diameter` = c(8, 5.6, 4, 2.8, 2, 1, 0.5, 0.355, 0.25),
        `Percent Finer` = c(0.951603145795523, 0.945553539019964,
           0.907239362774753, 0.86771526517443, 0.812865497076023, 0.642064932446058,
           0.460375075620085, 0.227465214761041, 0.0389191369227667)),
        .Names = c("Grain Diameter", "Percent Finer"), row.names = c(NA, 9L),
        class = "data.frame")

      # R 2.12.x and 2.13.x have to test with ggplot2 v0.8.9 which is very
      # different from 0.9.0.
      #
      # FIXME: Remove this once we drop support for 2.13.x
      if( exists('scale_y_probit') ){
        # We are using a ggplot2 version that is earlier than 0.9.0
        testPlot <- qplot( `Grain Diameter`, `Percent Finer`, data = soilSample) +
          scale_x_log10() + scale_y_probit() + theme_bw()
      } else {
        sink(tempfile())
        suppressPackageStartupMessages(library(scales))
        sink()
        testPlot <- qplot(log10(`Grain Diameter`), `Percent Finer`, data = soilSample) +
          scale_x_continuous(labels = math_format(10^.x)) +
          scale_y_continuous(trans = 'probit', breaks = seq(0.2, 0.8, 0.2)) +
          theme_bw()
      }

      print( testPlot )
    })
  ),

  list(
    short_name = 'polypath',
    description = 'Test polypath support',
    tags = c('base', 'polypath'),
    graph_code = quote({
      # From example(polypath)
       plotPath <- function(x, y, col="grey", rule="winding") {
           plot.new()
           plot.window(range(x, na.rm=TRUE), range(y, na.rm=TRUE))
           polypath(x, y, col=col, rule=rule)
           if (!is.na(col))
               mtext(paste("Rule:", rule), side=1, line=0)
       }

       plotRules <- function(x, y, title) {
           plotPath(x, y)
           plotPath(x, y, rule="evenodd")
           mtext(title, side=3, line=0)
           plotPath(x, y, col=NA)
       }

       op <- par(mfrow=c(5, 3), mar=c(2, 1, 1, 1))

       plotRules(c(.1, .1, .9, .9, NA, .2, .2, .8, .8),
                 c(.1, .9, .9, .1, NA, .2, .8, .8, .2),
                 title="Nested rectangles, both clockwise")
       plotRules(x=c(.1, .1, .9, .9, NA, .2, .8, .8, .2),
                 y=c(.1, .9, .9, .1, NA, .2, .2, .8, .8),
                 title="Nested rectangles, outer clockwise, inner anti-clockwise")
       plotRules(x=c(.1, .1, .4, .4, NA, .6, .9, .9, .6),
                 y=c(.1, .4, .4, .1, NA, .6, .6, .9, .9),
                 title="Disjoint rectangles")
       plotRules(x=c(.1, .1, .6, .6, NA, .4, .4, .9, .9),
                 y=c(.1, .6, .6, .1, NA, .4, .9, .9, .4),
                 title="Overlapping rectangles, both clockwise")
       plotRules(x=c(.1, .1, .6, .6, NA, .4, .9, .9, .4),
                 y=c(.1, .6, .6, .1, NA, .4, .4, .9, .9),
                 title="Overlapping rectangles, one clockwise, other anti-clockwise")

       par(op)

    })
  ),

  list(
    short_name = 'base_raster',
    description = 'Test raster support in base graphics',
    tags = c('base', 'raster', 'reflection'),
    fuzz = 642,
    graph_code = quote({

      plot(c(100, 250), c(300, 450), type = "n", xlab="", ylab="")
      image <- as.raster(matrix(rep(c(rep(0:1, 4), rep(1:0, 4)), each = 3), ncol=6, nrow=4))
      rasterImage(image, 100, 300, 150, 350, interpolate=FALSE)
      rasterImage(image, 100, 400, 150, 450)
      rasterImage(image, 200, 300, 200 + xinch(.5), 300 + yinch(.3),
                  interpolate=FALSE)
      rasterImage(image, 200, 400, 250, 450, angle=15,
                  interpolate=FALSE)
      rasterImage(image, 175 + xinch(.5), 350, 175, 350 + yinch(.3), angle=-30,
                  interpolate=FALSE)
      rasterImage(image, 200 + xinch(.5), 350 + yinch(.3), 200, 350, angle=-45,
                  interpolate=FALSE)
      rasterImage(image, 225, 350 + yinch(.3), 225 + xinch(.5), 350, angle=-60,
                  interpolate=FALSE)

    })
  ),

  list(
    short_name = 'raster_reflection',
    description = 'Test raster handling in graphics with reflected axes',
    tags = c('base', 'raster', 'reflection'),
    graph_code = quote({

      par(mfrow = c(2,2))
      image(volcano, useRaster = TRUE)
      image(volcano, xlim = c(1,0), useRaster = TRUE)
      image(volcano, ylim = c(1,0), useRaster = TRUE)
      image(volcano, xlim = c(1,0), ylim = c(1,0), useRaster = TRUE)

    })
  ),

  list(
    short_name = 'grid_raster',
    description = 'Test raster support in grid graphics',
    tags = c('grid', 'raster'),
    graph_code = quote({

      suppressPackageStartupMessages(library(grid))
      suppressPackageStartupMessages(library(lattice))

      plt <- levelplot(volcano, panel = panel.levelplot.raster,
           col.regions = topo.colors, cuts = 30, interpolate = TRUE)

      print(plt)

    })
  ),

  list(
    short_name = 'base_raster_noresample',
    description = 'Test noresampling raster support in base graphics',
    tags = c('base', 'raster'),
    fuzz = 1400,
    graph_code = quote({
      plot.new()
      suppressWarnings(rasterImage(as.raster(matrix(seq(0,1,len=9),3)),0,0,1,1,interpolate=TRUE))
    })
  ),

  list(
    short_name = 'base_symbolic_simple',
    description = 'Test symbolic colors for a simple image',
    tags = c('base', 'symbolic'),
    graph_options = list(
      tikzSymbolicColors=TRUE, tikzMaxSymbolicColors=3),
    graph_code = quote({
      plot.new()
      points(0,0)
      points(0,1, col="red")
      suppressWarnings(points(1,1, col="green"))
      points(1,0, col="gray50")
      points(0.5,0.5, col="#F3346A")
    })
  ),
  # New pdfLaTeX tests go here
  #list(
  #  short_name = 'something_suitable_as_a_filename',
  #  description = 'Longer description of what the test does',
  #  tags = c('plot', 'tags'),
  #  graph_options = list(optional stuff to pass to options() during this test)
  #  graph_code = quote({
  #
  #  })
  #)

  ### XeLaTeX Tests
  list(
    short_name = 'utf8_characters',
    description = 'Test of UTF8 characters',
    tags = c('base', 'xetex', 'utf8'),
    engine = 'xetex',
    graph_code =  quote({
      n <- 8
      chars <- intToUtf8(seq(187,,1,n*n),multiple=T)

      plot(1:n,type='n',xlab='',ylab='',axes=FALSE, main="UTF-8 Characters")
      text(rep(1:n, n), rep(1:n, rep(n, n)), chars)
    })
  ),


  list(
    short_name = 'xetex_variants',
    description = 'Test of XeLaTeX font variants',
    tags = c('xetex', 'utf8'),
    engine = 'xetex',
    # Only OS X is likely to have the required fonts installed
    skip_if = function(){Sys.info()['sysname'] != 'Darwin'},
    graph_options = list(
      tikzXelatexPackages = c(
        "\\usepackage{fontspec}",
        "\\usepackage[colorlinks, breaklinks, pdftitle={The Beauty of LaTeX},pdfauthor={Taraborelli, Dario}]{hyperref}",
        "\\usepackage{tikz}",
        "\\usepackage{color}",
        "\\definecolor{Gray}{rgb}{.7,.7,.7}",
        "\\definecolor{lightblue}{rgb}{.2,.5,1}",
        "\\definecolor{myred}{rgb}{1,0,0}",
        "\\newcommand{\\red}[1]{\\color{myred} #1}",
        "\\newcommand{\\reda}[1]{\\color{myred}\\fontspec[Variant=2]{Zapfino}#1}",
        "\\newcommand{\\redb}[1]{\\color{myred}\\fontspec[Variant=3]{Zapfino}#1}",
        "\\newcommand{\\redc}[1]{\\color{myred}\\fontspec[Variant=4]{Zapfino}#1}",
        "\\newcommand{\\redd}[1]{\\color{myred}\\fontspec[Variant=5]{Zapfino}#1}",
        "\\newcommand{\\rede}[1]{\\color{myred}\\fontspec[Variant=6]{Zapfino}#1}",
        "\\newcommand{\\redf}[1]{\\color{myred}\\fontspec[Variant=7]{Zapfino}#1}",
        "\\newcommand{\\redg}[1]{\\color{myred}\\fontspec[Variant=8]{Zapfino}#1}",
        "\\newcommand{\\lbl}[1]{\\color{lightblue} #1}",
        "\\newcommand{\\lbla}[1]{\\color{lightblue}\\fontspec[Variant=2]{Zapfino}#1}",
        "\\newcommand{\\lblb}[1]{\\color{lightblue}\\fontspec[Variant=3]{Zapfino}#1}",
        "\\newcommand{\\lblc}[1]{\\color{lightblue}\\fontspec[Variant=4]{Zapfino}#1}",
        "\\newcommand{\\lbld}[1]{\\color{lightblue}\\fontspec[Variant=5]{Zapfino}#1}",
        "\\newcommand{\\lble}[1]{\\color{lightblue}\\fontspec[Variant=6]{Zapfino}#1}",
        "\\newcommand{\\lblf}[1]{\\color{lightblue}\\fontspec[Variant=7]{Zapfino}#1}",
        "\\newcommand{\\lblg}[1]{\\color{lightblue}\\fontspec[Variant=8]{Zapfino}#1}",
        "\\newcommand{\\old}[1]{",
        "\\fontspec[Ligatures={Common, Rare},Variant=1,Swashes={LineInitial, LineFinal}]{Zapfino}",
        "\\fontsize{25pt}{30pt}\\selectfont #1}%",
        "\\newcommand{\\smallprint}[1]{\\fontspec{Hoefler Text}\\fontsize{10pt}{13pt}\\color{Gray}\\selectfont #1}%\n",
        "\\usepackage[active,tightpage,xetex]{preview}",
        "\\PreviewEnvironment{pgfpicture}",
        "\\setlength\\PreviewBorder{0pt}"
    )),
    graph_code =  quote({

      label <- c(
        "\\noindent{\\red d}roo{\\lbl g}",
        "\\noindent{\\reda d}roo{\\lbla g}",
        "\\noindent{\\redb d}roo{\\lblb g}",
        "\\noindent{\\redf d}roo{\\lblf g}\\\\[.3cm]",
        "\\noindent{\\redc d}roo{\\lblc g}",
        "\\noindent{\\redd d}roo{\\lbld g}",
        "\\noindent{\\rede d}roo{\\lble g}",
        "\\noindent{\\redg d}roo{\\lblg g}\\\\[.2cm]"
      )
      title <- c(
        "\\smallprint{D. Taraborelli (2008), \\href{http://nitens.org/taraborelli/latex}{The Beauty of \\LaTeX}}",
        "\\smallprint{\\\\\\emph{Some rights reserved}. \\href{http://creativecommons.org/licenses/by-sa/3.0/}{\\textsc{cc-by-sa}}}"
      )

      lim <- 0:(length(label)+1)
      plot(lim,lim,cex=0,pch='.',xlab = title[2],ylab='', main = title[1])
      for(i in 1:length(label))
        text(i,i,label[i])
    })
  ),

  ### LuaLaTeX Tests
  list(
    short_name = 'luatex_utf8_characters',
    description = 'Test of UTF8 characters w/ LuaTeX',
    tags = c('base', 'luatex', 'utf8'),
    engine = 'luatex',
    # Travis CI runs Ubuntu Precise with a fontspec package that doesn't accept
    # LuaLaTeX yet
    skip_if = function(){ Sys.getenv("TRAVIS") != "" },
    graph_code =  quote({
      n <- 8
      chars <- intToUtf8(seq(187,,1,n*n),multiple=T)

      plot(1:n,type='n',xlab='',ylab='',axes=FALSE, main="UTF-8 Characters")
      text(rep(1:n, n), rep(1:n, rep(n, n)), chars)
    })
  ),

  # New UTF8/XeLaTeX/LuaLatex tests go here
  #list(
  #  short_name = 'something_suitable_as_a_filename',
  #  description = 'Longer description of what the test does',
  #  tags = c('plot', 'tags'),
  #  uses_xetex = TRUE,
  #  graph_options = list(optional stuff to pass to options() during this test)
  #  graph_code = quote({
  #
  #  })
  #)

  NULL

)

test_graphs <- test_graphs[!vapply(test_graphs, is.null, logical(1L))]

if ( length(tags_to_run) ) {
  test_graphs <- Filter(
    function(graph){ any(graph$tags %in% tags_to_run) },
    test_graphs )
}


run_test <- function(graph){ do.call(do_graphics_test, graph) }
graphs_produced <- Filter(run_test, test_graphs)

context('Graph test cleanup')

test_that('All graphics devices closed',{

  expect_that(length(dev.list()), equals(0))

})

}) # End reporter swap


message('\nFinished generating TikZ test graphs.')
message('PDF files are in:\n\t', test_output_dir)
message('\nTeX sources and log files are in:\n\t', test_work_dir)

if ( !is.null(gs_cmd) ) {
  # Combine all test PDFs into one big file for easy viewing
  graph_files <- Map(function(graph) {
    file.path(test_output_dir, str_c(graph$short_name, '.pdf'))
    }, graphs_produced)
  test_output <- file.path(test_output_dir, 'test_results.pdf')

  silence <- system(paste(shQuote(gs_cmd), '-dNOPAUSE', '-sDEVICE=pdfwrite',
    str_c('-sOUTPUTFILE=', test_output),
    '-dBATCH', paste(shQuote(graph_files), collapse = ' ')),
    intern = TRUE, ignore.stderr = TRUE)

  message('\nAll test outputs combined into:\n\t', test_output)
}


if ( !is.null(compare_cmd) && !is.null(convert_cmd) ) {
  # Combine all visual diffs into one big PDF file for easy viewing
  graph_files <- Map(function(graph) {
    file.path(test_work_dir, str_c(graph$short_name, '_diff.png'))
    }, graphs_produced)
  diff_output <- file.path(test_output_dir, 'test_diffs.pdf')

  silence <- system(paste(shQuote(convert_cmd),
    paste(shQuote(graph_files), collapse = ' '),
    diff_output),
    intern = TRUE, ignore.stderr = TRUE)

  message('\nResults of all visual diffs combined into:\n\t', diff_output)

}
