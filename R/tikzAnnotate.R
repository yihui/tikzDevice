#' Convert grid coordinates to device coordinates
#'
#' This function converts a coordinate pair specifying a location in a
#' grid \code{\link{viewport}} in grid units to a coordinate pair specifying a
#' location in device units relative to the lower left corner of the plotting
#' canvas.
#'
#' @param x x coordinate.
#' @param y y coordinate. If no values are given for \code{x} and \code{y}, the
#'   location of the lower-left corner of the current viewport will be
#'   calculated.
#' @param units Character string indicating the units of \code{x} and \code{y}.
#'   See the \code{\link{unit}} function for acceptable unit types.
#'
#' @return A tuple of coordinates in device units.
#'
#' @author Charlie Sharpsteen \email{source@@sharpsteen.net}
#'
#' @keywords graphics grid conversion units
#' @seealso
#'   \code{\link{unit}}
#'   \code{\link{viewport}}
#'   \code{\link{convertX}}
#'   \code{\link{convertY}}
#'   \code{\link{current.transform}}
#'
#'
#' @export
#' @importFrom grid convertX convertY current.transform unit
gridToDevice <- function(x = 0, y = 0, units = 'native') {
  # Converts a coordinate pair from the current viewport to an "absolute
  # location" measured in device units from the lower left corner. This is done
  # by first casting to inches in the current viewport and then using the
  # current.transform() matric to obtain inches in the device canvas.
  x <- convertX(unit(x, units), unitTo = 'inches', valueOnly = TRUE)
  y <- convertY(unit(y, units), unitTo = 'inches', valueOnly = TRUE)

  transCoords <- c(x,y,1) %*% current.transform()
  transCoords <- (transCoords / transCoords[3])

  return(
    # Finally, cast from inches to device coordinates (which are TeX points for
    # the tikzDevice)
    c(
      grconvertX(transCoords[1], from = 'inches', to = 'device'),
      grconvertY(transCoords[2], from = 'inches', to = 'device')
    )
  )

}


#-------------------------------------------------------------------------------
#                         Annotation of Base Graphics
#-------------------------------------------------------------------------------

#' Add Custom TikZ Code to an Active Device
#'
#' These functions allow custom (LaTeX) commands to be added to the output of an
#' active tikzDevice.
#'
#' \code{tikzAnnotate} is intended to allow the insertion of arbitrary TikZ
#' commands into the output stream of a graphic. For LaTeX commands that
#' reference specific locations in an R plot, coordinates must be specified in
#' "device units" which for \code{tikz} output are TeX points relative to the
#' lower left corner of the device canvas. Functions such as
#' \code{\link{grconvertX}} and \code{\link{gridToDevice}} can help make the
#' necessary conversions for base and grid graphics. The \code{tikzNode} and
#' \code{tikzCoord} functions automatically perform unit conversions acording
#' the the value of their \code{units} parameters.
#'
#' \code{tikzNode} is a wrapper for \code{tikzAnnotate} that inserts TikZ
#' \code{\\node} or \code{\\coordinates} commands into the output. The
#' difference between a node and a coordinate is the presence of a
#' \code{content} section that can contain arbitrary LaTeX text. This is
#' useful for adding textual annotations at specific locations in a TikZ
#' graphic. The \code{tikzCoord} function is a wrapper for \code{tikzNode}
#' that simplifies the task of inserting named coordinates.
#'
#' Additionally, the \code{tikzAnnotateGrob}, \code{tikzNodeGrob} and
#' \code{tikzCoordGrob} functions are supplied for creating grid objects
#' or "\code{\link{grob}}s" that can be used in Grid graphics. High level
#' wrapper functions \code{grid.tikzAnnotate}, \code{grid.tikzNode} and
#' \code{grid.tikzCoord} are also supplied which creat and render a \code{grob}
#' in one step.
#'
#' See the TikZ Device vignette for more information and examples and the
#' TikZ manual for the definitive reference on what is possible with nodes.
#'
#' @param annotation A character vector, one element per line to be added to
#'   the open tikz device.
#'
#' @param checkstate A logical, whether to "flush" the device state prior to
#'   writing the \code{annotation}.
#'
#' @return Nothing returned.
#'
#' @author Cameron Bracken <cameron.bracken@@gmail.com> and Charlie Sharpsteen
#'   \email{source@@sharpsteen.net}
#'
#'
#' @examples
#'
#' \dontrun{
#'
#' ### Example 1: Annotations in Base Graphics
#' # Load some additional TikZ libraries
#' tikz("annotation.tex",width=4,height=4,
#'   packages = c(getOption('tikzLatexPackages'),
#'     "\\usetikzlibrary{decorations.pathreplacing}",
#'     "\\usetikzlibrary{positioning}",
#'     "\\usetikzlibrary{shapes.arrows,shapes.symbols}")
#' )
#'
#' p <- rgamma (300 ,1)
#' outliers <- which( p > quantile(p,.75)+1.5*IQR(p) )
#' boxplot(p)
#'
#' # Add named coordinates that other TikZ commands can hook onto
#' tikzCoord(1, min(p[outliers]), 'min outlier')
#' tikzCoord(1, max(p[outliers]), 'max outlier')
#'
#' # Use tikzAnnotate to insert arbitrary code, such as drawing a
#' # fancy path between min outlier and max outlier.
#' tikzAnnotate(c("\\draw[very thick,red,",
#'   # Turn the path into a brace.
#'   'decorate,decoration={brace,amplitude=12pt},',
#'   # Shift it 1em to the left of the coordinates
#'   'transform canvas={xshift=-1em}]',
#'   '(min outlier) --',
#'   # Add a node with some text in the middle of the path
#'   'node[single arrow,anchor=tip,fill=white,draw=green,',
#'   'left=14pt,text width=0.70in,align=center]',
#'   '{Holy Outliers Batman!}', '(max outlier);'))
#'
#' # tikzNode can be used to place nodes with customized options and content
#' tikzNode(
#'   opts='starburst,fill=green,draw=blue,very thick,right=of max outlier',
#'   content='Wow!'
#' )
#'
#' dev.off()
#'
#'
#' ### Example 2: Annotations in Grid Graphics
#' library(grid)
#'
#' tikz("grid_annotation.tex",width=4,height=4,
#'   packages = c(getOption('tikzLatexPackages'),
#'     "\\usetikzlibrary{shapes.callouts}")
#' )
#'
#' pushViewport(plotViewport())
#' pushViewport(dataViewport(1:10, 1:10))
#'
#' grid.rect()
#' grid.xaxis()
#' grid.yaxis()
#' grid.points(1:10, 1:10)
#'
#' for ( i in seq(2,8,2) ){
#'   grid.tikzNode(i,i,opts='ellipse callout,draw,anchor=pointer',content=i)
#' }
#'
#' dev.off()
#'
#' }
#'
#'
#' @keywords tikz device annotation
#' @seealso
#'   \code{\link{grconvertX}}
#'   \code{\link{grconvertY}}
#'   \code{\link{gridToDevice}}
#'   \code{\link{unit}}
#'   \code{\link{tikz}}
#'
#' @useDynLib tikzDevice TikZ_Annotate
#' @export
tikzAnnotate <-
function (annotation, checkstate = TRUE)
{

  if (!isTikzDevice()){
    stop("The active device is not a tikz device, please start a tikz device to use this function. See ?tikz.")
  }

  .C(TikZ_Annotate, as.character(annotation),
    as.integer(length(annotation)), as.logical(checkstate))

  invisible()
}

#' @rdname tikzAnnotate
#'
#' @param x numeric, x location for a named coordinate in user coordinates
#' @param y numeric, y location for a named coordinate in user coordinates
#' @param opts A character string that will be used as options for a \code{node}.
#'   See the "Nodes and Edges" section of the TikZ manual for complete details.
#' @param name Optional character string that will be used as a name for a
#'   \code{coordinate} or \code{node}. Other TikZ commands can use this
#'   name to refer to a location in a graphic.
#' @param content A character string that will be used as the content to be displayed
#'   inside of a \code{node}. If left as \code{NULL} a \code{coordinate} will be
#'   created instead of a \code{node}. If a \code{node} with empty content is truely
#'   desired, pass an empty string \code{""}.
#' @param units Character string specifying the unit system associated with
#'   \code{x} and \code{y}. See \code{\link{grconvertX}} for acceptable
#'   units in base graphics and \code{\link{unit}} for acceptable
#'   units in grid graphics.
#'
#' @export
tikzNode <- function(
  x = NULL, y = NULL,
  opts = NULL,
  name = NULL, content = NULL,
  units = 'user'
) {
  # If there is no node content, we create a coordinate.
  node_string <- ifelse(is.null(content), '\\coordinate', '\\node')

  # Process the other components.
  if ( !is.null(opts) ) {
    node_string <- paste(node_string, '[', opts, ']', sep = '')
  }
  if ( !is.null(name) ) {
    # Ensure we got a character.
    if ( !is.character(name) ) {
      stop( "The coordinate name must be a character!" )
    }

    node_string <- paste(node_string, ' (', name, ')', sep = '')
  }
  if ( !is.null(x) && !is.null(y) ) {
    # For now, we demand that x and y be scalar values.
    # TODO: Vectorize this function
    if ( length(x) > 1 ) {
      warning("More than one X coordinate specified. Only the first will be used!")
      x <- x[1]
    }

    if ( length(y) > 1 ) {
      warning("More than one Y coordinate specified. Only the first will be used!")
      y <- y[1]
    }

    # Convert coordinates to device coordinates.
    if ( units != 'device' ) {
      x <- grconvertX(x, from = units, to = 'device')
      y <- grconvertY(y, from = units, to = 'device')
    }

    node_string <- paste(node_string,
      ' at (', round(x,2), ',', round(y,2), ')', sep = '')
  }
  if ( !is.null(content) ) {
    node_string <- paste(node_string, ' {', content, '}', sep = '')
  }

  # Use tikzAnnotate() to add a coordinate.
  tikzAnnotate(paste(node_string, ';', sep = ''))

}


#' @rdname tikzAnnotate
#' @export
tikzCoord <- function( x, y, name, units = 'user') {

  tikzNode(x = x, y = y, name = name, units = units)

}


#-------------------------------------------------------------------------------
#                         Annotation of Grid Graphics
#
# These functions are merely wrappers that call the base graphics functions in
# the end.
#-------------------------------------------------------------------------------

# Constructors for grid objects (grobs)
#--------------------------------------

#' @rdname tikzAnnotate
#' @importFrom grid grob
#' @export
tikzAnnotateGrob <- function(annotation) {

  grob(annotation = annotation, cl = 'tikz_annotation')

}


#' @rdname tikzAnnotate
#' @importFrom grid grob
#' @export
tikzNodeGrob <- function(
  x = NULL, y = NULL,
  opts = NULL, name = NULL,
  content = NULL,
  units = 'native'
) {

  grob(x = x, y = y, opts = opts, coord_name = name, content = content,
    units = units, cl = 'tikz_node')

}


#' @rdname tikzAnnotate
#' @importFrom grid grob
#' @export
tikzCoordGrob <- function(x, y, name, units = 'native') {

  grob(x = x, y = y, coord_name = name, units = units, cl = 'tikz_coord')

}

# Grid wrapper functions
#-----------------------

#' @rdname tikzAnnotate
#'
#' @param draw A logical value indicating whether graphics output should be
#'   produced.
#'
#' @importFrom grid grid.draw
#' @export
grid.tikzAnnotate <- function(annotation, draw = TRUE) {

  annotate_grob <- tikzAnnotateGrob(annotation)
  if ( draw ) { grid.draw(annotate_grob) }

  invisible( annotate_grob )

}


#' @rdname tikzAnnotate
#' @importFrom grid grid.draw
#' @export
grid.tikzNode <- function(
  x = NULL, y = NULL,
  opts = NULL, name = NULL,
  content = NULL,
  units = 'native',
  draw = TRUE
) {

  node_grob <- tikzNodeGrob(
    x = x, y = y,
    opts = opts, name = name, content = content,
    units = units
  )
  if (draw) { grid.draw(node_grob) }

  invisible(node_grob)

}


#' @rdname tikzAnnotate
#' @importFrom grid grid.draw
#' @export
grid.tikzCoord <- function(x, y, name, units = 'native', draw = TRUE) {

  coord_grob <- tikzCoordGrob(x = x, y = y, name = name, units = units)
  if (draw) { grid.draw(coord_grob) }

  invisible(coord_grob)

}

# Grid execution
#---------------
# These S3 methods get executed when TikZ annotation grobs get drawn to a
# device. They handle the actual "drawing" of the annotations by calling to the
# base graphics functions.

if ('roxygen2' %in% loadedNamespaces()) do.call(library, list('grid'))

#' @importFrom grid drawDetails
#' @export
drawDetails.tikz_annotation <- function(x, recording) {

  tikzAnnotate(x$annotation)

}


#' @importFrom grid drawDetails
#' @export
drawDetails.tikz_node <- function(x, recording) {

  if ( is.null(x$x) && is.null(x$y) ) {
    coords <- c(NULL, NULL)
  } else {
    coords <- gridToDevice(x$x, x$y, x$units)
  }

  tikzNode(coords[1], coords[2], x$opts,
    x$coord_name, x$content, units = 'device')

}


#' @importFrom grid drawDetails
#' @export
drawDetails.tikz_coord <- function(x, recording) {

  coords <- gridToDevice(x$x, x$y, x$units)
  tikzCoord(coords[1], coords[2], x$coord_name, units = 'device')

}
