#!/usr/bin/env Rscript
if (nchar(Sys.getenv('R_TESTS')) == 0){
  library(methods)
  # Protects against R CMD check
  library(tikzDevice)
  library(testthat)
  require(stringr)

  require(tools)
  require(evaluate)

  # Process command arguments
  test_args <- commandArgs(TRUE)
  torture_mem <- any(str_detect(test_args, '^--use-gctorture'))

  if ( length(tags_to_run <- test_args[str_detect(test_args, '^--run-tests')]) ) {
    tags_to_run <- unlist(str_split(
        str_split(tags_to_run, '=')[[1]][2],
        ',' ))
  }

  if (torture_mem) { gctorture(TRUE) }
  using_windows <- Sys.info()['sysname'] == 'Windows'

  # Ensure tikzDevice options have been set to their default values.
  setTikzDefaults(overwrite = TRUE)
  options(tikzMetricsDictionary = NULL)

  expand_test_path <- function(path) {
    call_args = list(path = path)
    if( version$major > 2 || version$minor >= '13.0' ) {
      # After R 2.13.0, normalizePath bitches and moans if the path does not
      # exist. Squelch this warning.
      #
      # FIXME: Remove this once we drop support for R 2.12.x
      call_args[['mustWork']] = FALSE
    }

    do.call(normalizePath, call_args)
  }

  # Set up directories for test output.
  test_output_dir <- expand_test_path(file.path(getwd(), 'test_output'))
  if( !file.exists(test_output_dir) ) dir.create(test_output_dir)
  test_work_dir <- expand_test_path(file.path(getwd(), 'test_work'))
  if( !file.exists(test_work_dir) ) dir.create(test_work_dir)

  test_standard_dir <- normalizePath(file.path(getwd(), '..', 'inst', 'tests', 'standard_graphs'))

  # Locate required external programs
  gs_cmd <- Sys.which(ifelse(using_windows, 'gswin32c', 'gs'))
  if ( nchar(gs_cmd) == 0 ) {
    gs_cmd <- NULL
  } else {
    gs_cmd <- normalizePath(gs_cmd)
  }

  compare_cmd <- Sys.which("compare")
  if ( nchar(compare_cmd) == 0 || is.null(gs_cmd) ) {
    compare_cmd <- NULL
  } else {
    compare_cmd <- normalizePath(compare_cmd)
  }

  convert_cmd <- normalizePath(ifelse(using_windows,
    system("bash -c 'which convert'", intern = TRUE, ignore.stderr = TRUE),
    Sys.which('convert')
  ))
  if ( nchar(convert_cmd) == 0 || is.null(gs_cmd) ) {
    convert_cmd <- NULL
  } else {
    convert_cmd <- normalizePath(convert_cmd)
  }


  test_package('tikzDevice')

}

