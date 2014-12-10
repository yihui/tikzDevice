#' Replace LaTeX Special Characters in a String
#'
#' This function is used by tikzDevice when \code{sanitize=TRUE} to replace
#' special LaTeX characters (such as the comment character %) in plotting text
#' where the user does not have direct control over the generated text.
#'
#' \code{sanitizeTexString} searches character by character through a string
#' replacing each occurrence of a special character contained in
#' \code{strip[i]} with the corresponding replacement value in
#' \code{replacement[i]}.  tikzDevice calls back this function for every piece
#' of text when the sanitize option is TRUE. See \code{\link{tikz}} for more
#' information on the default special characters and replacement values.
#'
#' By default, `tikzSanitizeCharacters` replaces the following characters:
#'
#' \itemize{
#'   \item \verb{\%}
#'   \item \verb{$}
#'   \item \verb{\}}
#'   \item \verb{\{}
#'   \item \verb{^}
#'   \item \verb{_}
#'   \item \verb{#}
#'   \item \verb{&}
#'   \item \verb{~}
#' }
#'
#' With the contents of `tikzReplacementCharacters`:
#'
#' \itemize{
#'   \item \verb{\\\%}
#'   \item \verb{\\$}
#'   \item \verb{\\\}}
#'   \item \verb{\\\{}
#'   \item \verb{\\^{}}
#'   \item \verb{\\_{}}
#'   \item \verb{\\#}
#'   \item \verb{\\&}
#'   \item \verb{\char`\~}
#'  }
#'
#' These defaults may be adjusted using the \code{\link{options}} function.
#'
#' @param string A character vector of length 1 (a string).
#' @param strip A character vector of single characters to search for.
#' @param replacement A character vector of replacement values.
#'
#' @return \item{sanitizedString}{A character vector of length 1 with all
#'   special characters replaced.}
#'
#' @author Cameron Bracken \email{cameron.bracken@@gmail.com}
#'
#' @seealso \code{\link{tikz}}
#' @keywords character
#'
#' @examples
#'
#' # Be careful with sanitizing, it may lead to unexpected behavior.
#' # For example, we may want -1 to be a superscript it gets
#' # sanitized away with the other default special characters.
#' # The string appears in LaTeX exactly as shown.
#' \dontrun{
#'   sanitizeTexString('10\% of 10$ is 10^\{-1\}$')
#' }
#'
#' @export
sanitizeTexString <- function(string,
  strip = getOption('tikzSanitizeCharacters'),
  replacement = getOption('tikzReplacementCharacters')){

      #separate the string into a vector of charaters
    explode <- strsplit(string,'')[[1]]
    if(any(is.na(explode))) stop("Unable to sanitize string, you may be trying to pass in an unsupported symbol")

      # Replace each matching character with its replacement characters
    for(i in 1:length(explode)){

      matches <- (explode[i] == strip)
      if(any(matches))
        explode[i] <- paste('{',replacement[which(matches)],'}',sep='')

    }
      # stick the string back together
    return(paste(explode,collapse=''))
}
