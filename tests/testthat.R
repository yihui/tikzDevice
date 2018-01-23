if (nchar(Sys.getenv("R_TESTS")) == 0) {
  library(testthat)
  library(tikzDevice)

  test_check("tikzDevice")
}
