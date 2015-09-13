# Filehash contains a function for generating a SHA1 hash from an R object, but
# doesn't export it. The digest package also contains the exact same code made
# publicly available but it seems redundant to add it to the dependency list.
# This function simplifies access to filehash's unexported SHA1 function.
sha1 <- filehash:::sha1


# Since calling LaTeX to obtain string metrics is inefficient and expensive,
# this function will search a string metrics dictionary to see if we have
# already calculated metrics for this particular object. If so we return the
# cached value.
#
#' @importFrom filehash dbExists dbFetch
queryMetricsDictionary <-
function( key, verbose )
{
  # Ensure the dictionary is available.
  checkDictionaryStatus(verbose = verbose)

  # Check for the string.
  haveMetrics <- evalWithoutInterrupts(dbExists(.tikzInternal[['dictionary']], sha1(key)))
  if ( haveMetrics ) {

    # Yay! The width exists! Recover and return it.
    metrics <- evalWithoutInterrupts(dbFetch(.tikzInternal[['dictionary']], sha1(key)))

  } else {

    # No dice. Return -1 to indicate that metrics for this string
    # are not present in the dictionary.
    return( -1 )

  }
}


# This function enters values into the metrics dictionary. The metrics are
# stored under a key which is a SHA1 hash created from the object they are
# associated with.
#
#' @importFrom filehash dbInsert
storeMetricsInDictionary <-
function( key, metrics )
{
  evalWithoutInterrupts(dbInsert(.tikzInternal[['dictionary']], sha1(key), metrics))

  # Return nothing.
  invisible()
}


# This function checks to see if our dictionary has been created as a variable
# in our private .tikzInternal environment. If not, it either opens a user
# specified dictionary or creates a new one in tempdir().
#
#' @importFrom filehash dbCreate dbInit
checkDictionaryStatus <- function(verbose)
{
  if (!verbose) {
    message <- function(...) invisible()
  }

  dict_path <- getOption('tikzMetricsDictionary')
  old_dict_path <- .tikzInternal[['dict_path']]
  old_dictionary <- .tikzInternal[['dictionary']]
  old_db_file <- .tikzInternal[['db_file']]
  need_create <- FALSE

  # Check for a user specified dictionary.
  if( !is.null( dict_path ) ){
    db_file <- path.expand(dict_path)

    # Create the database file if it does not exist.
    if( !file.exists( db_file ) ){
      message("Creating new TikZ metrics dictionary at:\n\t", db_file)
      need_create <- TRUE
    }
  } else {
    # Create a temporary dictionary- it will disappear after
    # the R session finishes.
    db_file <- old_db_file
    if ( is.null(db_file) || !file.exists(db_file) || !is.null(old_dict_path) ) {
      db_file <- file.path( tempdir(), 'tikzMetricsDictionary' )
      message("Creating temporary TikZ metrics dictionary at:\n\t", db_file)
      need_create <- TRUE
    }
  }

  # Create the database file if it does not exist.
  if ( need_create ) {
    unlink( db_file, recursive = TRUE )
    dbCreate( db_file, type='DB1' )

    # Need to initialize new database
    old_dictionary <- NULL
  }

  if ( !is.null(old_dictionary) && identical(dict_path, old_dict_path) )
    return(invisible())

  # Add the dictionary as an object in the .tikzOptions
  # environment.
  message("Using TikZ metrics dictionary at:\n\t", db_file)
  .tikzInternal[['dictionary']] <- dbInit(db_file)
  .tikzInternal[['dict_path']] <- dict_path
  .tikzInternal[['db_file']] <- db_file

  # Return nothing.
  invisible()

}
