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

tikz_writeRaster <- function(fileName, rasterCount, rasterData,
                             nrows, ncols, finalDims, interpolate) {
  # Convert the 4 vectors of RGBA data contained in rasterData to a raster
  # image.
  rasterData[['maxColorValue']] = 255
  rasterData = do.call( grDevices::rgb, rasterData )
  rasterData = as.raster(
    matrix( rasterData, nrow = nrows, ncol = ncols, byrow = TRUE ) )

  raster_file <- paste0(
      tools::file_path_sans_ext(fileName),
      '_ras', rasterCount, '.png')

  res = getOption('tikzRasterResolution', NA)
  if (is.na(res)) {
      interpolate = FALSE
      width = ncols
      height = nrows
      units = 'px'
      dpi = 1
  } else {
      width = finalDims$width
      height = finalDims$height
      units = 'in'
      dpi = res
  }

  # Cairo should be ubiquitous now.
  png_type = 'cairo'

  # Write the image to a PNG file.
  png(filename = raster_file,
      width = width, height = height,
      units = units, res = dpi,
      type = png_type, antialias = 'none', bg = 'transparent' )

  par(mar=c(0,0,0,0))
  plot.new()
  plotArea = par('usr')
  rasterImage(rasterData, plotArea[1], plotArea[3],
    plotArea[2], plotArea[4], interpolate = interpolate)
  dev.off()

  return(
    basename(tools::file_path_sans_ext(raster_file))
  )
}
