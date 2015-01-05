library(methods)
library(tikzDevice)
library(testthat)
library(stringr)

library(tools)
library(evaluate)

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
  normalizePath(path, mustWork = FALSE)
}

# Set up directories for test output.
test_output_dir <- expand_test_path(file.path(getwd(), 'test_output'))
if( !file.exists(test_output_dir) ) dir.create(test_output_dir)
test_work_dir <- expand_test_path(file.path(getwd(), 'test_work'))
if( !file.exists(test_work_dir) ) dir.create(test_work_dir)

test_standard_dir <- normalizePath('standard_graphs')

oldwarn = options(warn = 1)

# Locate required external programs
gs_cmd <- Sys.which(ifelse(using_windows, 'gswin32c', 'gs'))
if ( nchar(gs_cmd) == 0 ) {
  warning("Ghostscript not found.")
  gs_cmd <- NULL
} else {
  gs_cmd <- normalizePath(gs_cmd)
}

compare_cmd <- Sys.which("compare")
if ( nchar(compare_cmd) == 0 || is.null(gs_cmd) ) {
  warning("compare not found.")
  compare_cmd <- NULL
} else {
  compare_cmd <- normalizePath(compare_cmd)
}

convert_cmd <- normalizePath(
  ifelse(using_windows,
         system("bash -c 'which convert'", intern = TRUE, ignore.stderr = TRUE),
         Sys.which('convert')
  ))

if ( nchar(convert_cmd) == 0 ) {
  convert_cmd <- NULL
  warning("convert not found.")
} else if ( is.null(gs_cmd) ) {
  convert_cmd <- NULL
  warning("Cannot use convert because Ghostscript is missing.")
} else {
  convert_cmd <- normalizePath(convert_cmd)
}

cat("Ghostscript: ", gs_cmd, "\n")
cat("compare: ", compare_cmd, "\n")
cat("convert: ", convert_cmd, "\n")

options(oldwarn)
