#!/usr/bin/env Rscript
if (nchar(Sys.getenv('R_TESTS')) == 0) {
  # Protects against R CMD check
  library(testthat)
  library(methods)
  FailureReporter <- setRefClass(
    "FailureReporter", contains = "Reporter",
    methods = list(
      start_reporter = function() {},

      add_result = function(result) {
        if (result$skipped) {
          return()
        }
        if (result$passed) {
          return()
        }

        failed <<- TRUE
      }
    )
  )

  test_check('tikzDevice', reporter = FailureReporter$new())
} # if (nchar(Sys.getenv('R_TESTS')) == 0) {
