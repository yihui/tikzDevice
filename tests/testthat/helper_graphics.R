# This file contains functions that help set up and run the tikzDevice through
# test graphs.

get_graphics_reporter <- function() {
  get_reporter()$reporters[[2]]
}

do_graphics_test <- function(short_name, description, graph_code, fuzz = 0,
                             engine = "pdftex", graph_options = NULL, skip_if = NULL, tags = NULL, ...) {
  context(description)

  if (Sys.getenv("R_TESTS") != "") {
    # `R CMD check` is running. Skip test and return so our graphics testsuite
    # does not slow down the CRAN daily checks.
    return(FALSE)
  }

  if (!is.null(skip_if)) {
    if (skip_if()) {
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

  graph_file <- file.path(test_work_dir, paste0(short_name, ".tex"))

  test_that("Graph is created cleanly", {
    # Set random number generator to a known state so results will be
    # reproducible
    set.seed(4) # As specified by RFC 1149.5 ;)

    # Keep dictionaries for one day only
    dict_path <- file.path(".tikzMetrics", short_name)
    if (file.exists(dict_path) && (Sys.time() - file.info(dict_path)$mtime) > 86400) {
      unlink(dict_path)
    }

    withr::with_options(
      list(tikzMetricsDictionary = dict_path),
      expect_warning(create_graph(graph_code, graph_file, engine), NA)
    )
  })

  test_that("Graph compiles cleanly", {
    expect_warning(graph_created <<- compile_graph(graph_file, engine), NA)
  })

  test_that("Output regression check", {

    # Uses the `compare` utility in imagemagick/graphicsmagick to diff the
    # generated graph against a "standard". If there are any differences, we
    # changed the code in a way that broke the behavior of the TikzDevice.
    # This test always "passes" as the real result is the number of pixels that
    # were found to be different between the test graph and the standard graph.
    # Such a result must be interpreted by a human.
    eval(bquote(
      expect_lt(compare_graph(.(short_name), tags), .(fuzz) + 0.1)
    ))
  })


  return(graph_created)
}

create_graph <- function(graph_code, graph_file, engine) {
  tikz(file = graph_file, standAlone = TRUE, engine = engine)
  on.exit(dev.off())

  eval(graph_code)

  invisible()
}

compile_graph <- function(graph_file, engine) {
  # Have to compile in the same directory as the .tex file so that things like
  # raster images can be found.
  oldwd <- getwd()
  setwd(test_work_dir)
  on.exit(setwd(oldwd))

  tex_cmd <- get_latex_cmd(engine)

  silence <- system(
    paste(
      shQuote(tex_cmd), "-interaction=batchmode",
      "-output-directory", test_work_dir,
      graph_file
    ), intern = TRUE
  )

  output_pdf <- sub("tex$", "pdf", graph_file)
  if (file.exists(output_pdf)) {
    file.rename(output_pdf, file.path(test_output_dir, basename(output_pdf)))
    graph_created <- TRUE
  } else {
    graph_created <- FALSE
  }

  return(graph_created)
}

compare_graph <- function(graph_name, tags) {
  if (is.null(compare_cmd)) {
    return(TRUE)
  }

  test_output <- file.path(test_output_dir, paste0(graph_name, ".pdf"))
  if ("ggplot2" %in% tags && exists("scale_y_probit")) {
    # We are using a version of ggplot2 that predates 0.9.
    #
    # FIXME: Remove this once we drop support for 2.13.x.
    standard_graph <- file.path(test_standard_dir, "ggplot_old", paste0(graph_name, ".pdf"))
  } else {
    standard_graph <- file.path(test_standard_dir, paste0(graph_name, ".pdf"))
  }

  if (!file.exists(test_output) || !file.exists(standard_graph)) {
    return(TRUE)
  }


  # Normalize and quote some paths in case we are running on Windows
  compare_output <- file.path(test_work_dir, paste0(graph_name, "_diff.png"))
  command_line <- paste(
    shQuote(compare_cmd), "-density 300", "-metric AE",
    shQuote(test_output), shQuote(standard_graph), shQuote(compare_output),
    "2>&1 | awk '{metric=$NF};END{print metric}'"
  )

  result <- as.double(system(
    paste(
      # Force the command to be executed through bash
      "bash -c ", shQuote(command_line)
    ),
    intern = TRUE, ignore.stderr = TRUE
  ))

  return(as.numeric(result))
}
