#!/usr/bin/env Rscript
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
