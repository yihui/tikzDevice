\name{tikzAnnotate}
\alias{grid.tikzAnnotate}
\alias{grid.tikzCoord}
\alias{grid.tikzNode}
\alias{tikzAnnotate}
\alias{tikzAnnotateGrob}
\alias{tikzCoord}
\alias{tikzCoordGrob}
\alias{tikzNode}
\alias{tikzNodeGrob}
\title{Add Custom TikZ Code to an Active Device}
\usage{
tikzAnnotate(annotation, checkstate = TRUE)

tikzNode(x = NULL, y = NULL, opts = NULL, name = NULL, content = NULL,
  units = "user")

tikzCoord(x, y, name, units = "user")

tikzAnnotateGrob(annotation)

tikzNodeGrob(x = NULL, y = NULL, opts = NULL, name = NULL,
  content = NULL, units = "native")

tikzCoordGrob(x, y, name, units = "native")

grid.tikzAnnotate(annotation, draw = TRUE)

grid.tikzNode(x = NULL, y = NULL, opts = NULL, name = NULL,
  content = NULL, units = "native", draw = TRUE)

grid.tikzCoord(x, y, name, units = "native", draw = TRUE)
}
\arguments{
  \item{annotation}{A character vector, one element per
  line to be added to the open tikz device.}

  \item{checkstate}{A logical, whether to "flush" the
  device state prior to writing the \code{annotation}.}

  \item{x}{numeric, x location for a named coordinate in
  user coordinates}

  \item{y}{numeric, y location for a named coordinate in
  user coordinates}

  \item{opts}{A character string that will be used as
  options for a \code{node}.  See the "Nodes and Edges"
  section of the TikZ manual for complete details.}

  \item{name}{Optional character string that will be used
  as a name for a \code{coordinate} or \code{node}. Other
  TikZ commands can use this name to refer to a location in
  a graphic.}

  \item{content}{A character string that will be used as
  the content to be displayed inside of a \code{node}. If
  left as \code{NULL} a \code{coordinate} will be created
  instead of a \code{node}. If a \code{node} with empty
  content is truely desired, pass an empty string
  \code{""}.}

  \item{units}{Character string specifying the unit system
  associated with \code{x} and \code{y}. See
  \code{\link{grconvertX}} for acceptable units in base
  graphics and \code{\link{unit}} for acceptable units in
  grid graphics.}

  \item{draw}{A logical value indicating whether graphics
  output should be produced.}
}
\value{
Nothing returned.
}
\description{
These functions allow custom (LaTeX) commands to be added to the output of an
active tikzDevice.
}
\details{
\code{tikzAnnotate} is intended to allow the insertion of arbitrary TikZ
commands into the output stream of a graphic. For LaTeX commands that
reference specific locations in an R plot, coordinates must be specified in
"device units" which for \code{tikz} output are TeX points relative to the
lower left corner of the device canvas. Functions such as
\code{\link{grconvertX}} and \code{\link{gridToDevice}} can help make the
necessary conversions for base and grid graphics. The \code{tikzNode} and
\code{tikzCoord} functions automatically perform unit conversions acording
the the value of their \code{units} parameters.

\code{tikzNode} is a wrapper for \code{tikzAnnotate} that inserts TikZ
\code{\\node} or \code{\\coordinates} commands into the output. The
difference between a node and a coordinate is the presence of a
\code{content} section that can contain arbitrary LaTeX text. This is
useful for adding textual annotations at specific locations in a TikZ
graphic. The \code{tikzCoord} function is a wrapper for \code{tikzNode}
that simplifies the task of inserting named coordinates.

Additionally, the \code{tikzAnnotateGrob}, \code{tikzNodeGrob} and
\code{tikzCoordGrob} functions are supplied for creating grid objects
or "\code{\link{grob}}s" that can be used in Grid graphics. High level
wrapper functions \code{grid.tikzAnnotate}, \code{grid.tikzNode} and
\code{grid.tikzCoord} are also supplied which creat and render a \code{grob}
in one step.

See the TikZ Device vignette for more information and examples and the
TikZ manual for the definitive reference on what is possible with nodes.
}
\examples{
\dontrun{

### Example 1: Annotations in Base Graphics
# Load some additional TikZ libraries
tikz("annotation.tex",width=4,height=4,
  packages = c(getOption('tikzLatexPackages'),
    "\\\\usetikzlibrary{decorations.pathreplacing}",
    "\\\\usetikzlibrary{positioning}",
    "\\\\usetikzlibrary{shapes.arrows,shapes.symbols}")
)

p <- rgamma (300 ,1)
outliers <- which( p > quantile(p,.75)+1.5*IQR(p) )
boxplot(p)

# Add named coordinates that other TikZ commands can hook onto
tikzCoord(1, min(p[outliers]), 'min outlier')
tikzCoord(1, max(p[outliers]), 'max outlier')

# Use tikzAnnotate to insert arbitrary code, such as drawing a
# fancy path between min outlier and max outlier.
tikzAnnotate(c("\\\\draw[very thick,red,",
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

dev.off()


### Example 2: Annotations in Grid Graphics
require(grid)

tikz("grid_annotation.tex",width=4,height=4,
  packages = c(getOption('tikzLatexPackages'),
    "\\\\usetikzlibrary{shapes.callouts}")
)

pushViewport(plotViewport())
pushViewport(dataViewport(1:10, 1:10))

grid.rect()
grid.xaxis()
grid.yaxis()
grid.points(1:10, 1:10)

for ( i in seq(2,8,2) ){
  grid.tikzNode(i,i,opts='ellipse callout,draw,anchor=pointer',content=i)
}

dev.off()

}
}
\author{
Cameron Bracken <cameron.bracken@gmail.com> and Charlie Sharpsteen
  \email{source@sharpsteen.net}
}
\seealso{
\code{\link{grconvertX}}
  \code{\link{grconvertY}}
  \code{\link{gridToDevice}}
  \code{\link{unit}}
  \code{\link{tikz}}
}
\keyword{annotation}
\keyword{device}
\keyword{tikz}

