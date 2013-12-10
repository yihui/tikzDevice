\name{setTikzDefaults}
\alias{setTikzDefaults}
\title{Reset tikzDevice options to default values.}
\usage{
setTikzDefaults(overwrite = TRUE)
}
\arguments{
  \item{overwrite}{Should values that are allready set in
  \code{options()} be overwritten?}
}
\value{
Nothing returned.
}
\description{
This function resets the following options:
}
\details{
\itemize{
  \item \code{tikzDefaultEngine}
  \item \code{tikzLatex}
  \item \code{tikzDocumentDeclaration}
  \item \code{tikzFooter}
  \item \code{tikzLatexPackages}
  \item \code{tikzXelatexPackages}
  \item \code{tikzLualatexPackages}
  \item \code{tikzMetricPackages}
  \item \code{tikzUnicodeMetricPackages}
  \item \code{tikzSanitizeCharacters}
  \item \code{tikzReplacementCharacters}
  \item \code{tikzRasterResolution}
  \item \code{tikzPdftexWarnUTF}
}
}
\examples{
print( options( 'tikzDocumentDeclaration' ) )
	options( tikzDocumentDeclaration = 'foo' )
	setTikzDefaults()
	print( options( 'tikzDocumentDeclaration' ) )
}
\author{
Cameron Bracken \email{cameron.bracken@gmail.com} and Charlie
  Sharpsteen \email{source@sharpsteen.net}
}
\seealso{
\code{\link{tikz}}
}

