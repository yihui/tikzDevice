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
function( key )
{
	# Ensure the dictionary is available.
	checkDictionaryStatus()

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
checkDictionaryStatus <-
function()
{

	if( !exists('dictionary', envir=.tikzInternal, inherits=F) ){

		# Check for a user specified dictionary.
		if( !is.null( getOption('tikzMetricsDictionary') ) ){

			dbFile <- path.expand(
				getOption('tikzMetricsDictionary') )

			# Create the database file if it does not exist.
			if( !file.exists( dbFile ) ){
				message("Creating new TikZ metrics dictionary in:\n\t",dbFile)
				dbCreate( dbFile, type='DB1' )
			}


		}else{
			# Create a temporary dictionary- it will disappear after
			# the R session finishes.
			dbFile <- file.path( tempdir(), 'tikzMetricsDictionary' )
      message("Creating temporary TikZ metrics dictionary at:\n\t",dbFile)
			dbCreate( dbFile, type='DB1' )
		}

		# Add the dictionary as an object in the .tikzOptions
		# environment.
		.tikzInternal[['dictionary']] <- dbInit(dbFile)

	}

	# Return nothing.
	invisible()

}
