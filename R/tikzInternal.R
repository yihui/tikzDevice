# These are unexported functions that are called by the C routines of the tikz
# device to execute tasks that are difficult to do at the C level.

getDateStampForTikz <- function(){

  # This function retrieves the current date stamp using
  # sys.time() and formats it to a string. This function
  # is used by the C routine Print_TikZ_Header to add
  # date stamps to output files.

  return( strftime( Sys.time() ) )

}

getTikzDeviceVersion <- function() {
  as.character(packageVersion('tikzDevice'))
}

tikz_writeRaster <- function(fileName, rasterCount, nativeRaster) {
  raster_file <- paste0(
    tools::file_path_sans_ext(fileName),
    '_ras', rasterCount, '.png')

  png::writePNG(nativeRaster, raster_file)

  return(
    basename(tools::file_path_sans_ext(raster_file))
  )
}
