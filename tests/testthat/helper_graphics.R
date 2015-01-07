# This file contains functions that help set up and run the tikzDevice through
# test graphs.

get_graphics_reporter <- function() {
  get_reporter()$reporters[[2]]
}

do_graphics_test <- function(short_name, description, graph_code, fuzz = 0,
  engine = 'pdftex', graph_options = NULL, skip_if = NULL, tags = NULL, ...) {

  context(description)

  if (str_length(Sys.getenv('R_TESTS')) != 0){
    # `R CMD check` is running. Skip test and return so our graphics testsuite
    # does not slow down the CRAN daily checks.
    cat("SKIP")
    return(FALSE)
  }

  if (!is.null(skip_if)) {
    if (skip_if()) {
      cat("SKIP")
      return(FALSE)
    }
  }

  graph_created <- FALSE

  if (!is.null(graph_options)) {
    # If this test uses custom options, make sure the current options are
    # restored after it finishes.
    orig_opts <- options()
    options(graph_options)
    on.exit(options(orig_opts))
  }

  graph_file <- file.path(test_work_dir, str_c(short_name,'.tex'))

  test_that('Graph is created cleanly',{
    # Set random number generator to a known state so results will be
    # reproducible
    set.seed(4) # As specified by RFC 1149.5 ;)

    expect_that(
      create_graph(graph_code, graph_file, engine),
      runs_cleanly()
    )

  })

  test_that('Graph compiles cleanly',{

    expect_that(graph_created <<- compile_graph(graph_file, engine), runs_cleanly())

  })

  test_that('Output regression check',{

    # Uses the `compare` utility in imagemagick/graphicsmagick to diff the
    # generated graph against a "standard". If there are any differences, we
    # changed the code in a way that broke the behavior of the TikzDevice.
    # This test always "passes" as the real result is the number of pixels that
    # were found to be different between the test graph and the standard graph.
    # Such a result must be interpreted by a human.
    expect_less_than(compare_graph(short_name, tags), fuzz + 0.1, is_true(),
                info = short_name,
                label = "Pixel representation of graph unchanged")

  })


  return( graph_created )

}

create_graph <- function(graph_code, graph_file, engine){

    tikz(file = graph_file, standAlone = TRUE, engine = engine)
    on.exit(dev.off())

    eval(graph_code)

    invisible()

}

compile_graph <- function(graph_file, engine){
  # Have to compile in the same directory as the .tex file so that things like
  # raster images can be found.
  oldwd <- getwd()
  setwd(test_work_dir); on.exit(setwd(oldwd))

  tex_cmd <- switch(engine,
    pdftex = getOption('tikzLatex'),
    xetex = getOption('tikzXelatex'),
    luatex = getOption('tikzLualatex')
  )

  silence <- system(paste(shQuote(tex_cmd), '-interaction=batchmode',
    '-output-directory', test_work_dir,
    graph_file ), intern = TRUE)

  output_pdf = sub('tex$', 'pdf', graph_file)
  if ( file.exists(output_pdf) ) {
    file.rename(output_pdf, file.path(test_output_dir, basename(output_pdf)))
    graph_created <- TRUE
  } else {
    graph_created <- FALSE
  }

  return( graph_created )

}

compare_graph <- function(graph_name, tags){
  if ( is.null(compare_cmd) ) {
    get_graphics_reporter()$vis_result('SKIP')
    return(TRUE)
  }

  test_output <- file.path(test_output_dir, str_c(graph_name, '.pdf'))
  if( 'ggplot2' %in% tags && exists('scale_y_probit') ) {
    # We are using a version of ggplot2 that predates 0.9.
    #
    # FIXME: Remove this once we drop support for 2.13.x.
    standard_graph <- file.path(test_standard_dir, 'ggplot_old', str_c(graph_name, '.pdf'))
  } else {
    standard_graph <- file.path(test_standard_dir, str_c(graph_name, '.pdf'))
  }

  if ( !file.exists(test_output) || !file.exists(standard_graph) ) {
    get_graphics_reporter()$vis_result('SKIP')
    return(TRUE)
  }


  # Normalize and quote some paths in case we are running on Windows
  compare_output <- file.path(test_work_dir, str_c(graph_name, '_diff.png'))
  command_line <- paste(
    shQuote(compare_cmd), '-density 300', '-metric AE',
    shQuote(test_output), shQuote(standard_graph), shQuote(compare_output),
    "2>&1 | awk '{metric=$NF};END{print metric}'"
  )

  get_graphics_reporter()$set_cmp_command(command_line)
  result <- as.double(system(paste(
    # Force the command to be executed through bash
    'bash -c ', shQuote(command_line)),
    intern = TRUE, ignore.stderr = TRUE))

  get_graphics_reporter()$vis_result(result)

  return(as.numeric(result))

}
