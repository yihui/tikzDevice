#!/usr/bin/env Rscript
if (nchar(Sys.getenv('R_TESTS')) == 0){
  # Protects against R CMD check
  library(testthat)
  test_check('tikzDevice')
}
