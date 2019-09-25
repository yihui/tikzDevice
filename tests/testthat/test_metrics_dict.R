context("Metrics dictionary")

test_that("Temporary metrics dictionary is created, but only once", {
  expect_equal(getOption("tikzMetricsDictionary"), NULL)

  rm(list = ls(envir = .tikzInternal), envir = .tikzInternal)
  expect_message(checkDictionaryStatus(verbose = TRUE), "Creating")
  expect_silent(checkDictionaryStatus(verbose = TRUE))
  expect_true(file.exists(.tikzInternal[["db_file"]]))
})

test_that("Silent creation of temporary metrics dictionary", {
  expect_equal(getOption("tikzMetricsDictionary"), NULL)

  rm(list = ls(envir = .tikzInternal), envir = .tikzInternal)
  expect_silent(checkDictionaryStatus(verbose = FALSE))
  expect_silent(checkDictionaryStatus(verbose = FALSE))
  expect_true(file.exists(.tikzInternal[["db_file"]]))
})

test_that("Switching metrics dictionary", {
  expect_equal(getOption("tikzMetricsDictionary"), NULL)

  tempA <- file.path(getwd(), ".tikzTempA")
  tempB <- file.path(getwd(), ".tikzTempB")

  tryCatch(
    {
      options(tikzMetricsDictionary = tempA)
      expect_message(checkDictionaryStatus(verbose = TRUE), "Creating")
      expect_silent(checkDictionaryStatus(verbose = FALSE))
      options(tikzMetricsDictionary = tempB)
      expect_message(checkDictionaryStatus(verbose = TRUE), "Creating")
      expect_silent(checkDictionaryStatus(verbose = FALSE))
      options(tikzMetricsDictionary = tempA)
      expect_message(checkDictionaryStatus(verbose = TRUE), "Using")
      expect_silent(checkDictionaryStatus(verbose = FALSE))
      options(tikzMetricsDictionary = tempB)
      expect_message(checkDictionaryStatus(verbose = TRUE), "Using")
      expect_silent(checkDictionaryStatus(verbose = FALSE))
      options(tikzMetricsDictionary = tempA)
      expect_silent(checkDictionaryStatus(verbose = FALSE))
      expect_silent(checkDictionaryStatus(verbose = FALSE))
      options(tikzMetricsDictionary = tempB)
      expect_silent(checkDictionaryStatus(verbose = FALSE))
      expect_silent(checkDictionaryStatus(verbose = FALSE))
    },
    finally = {
      options(tikzMetricsDictionary = NULL)
      unlink(tempA, recursive = TRUE)
      unlink(tempB, recursive = TRUE)
    }
  )
})

test_that("Turning custom metrics dictionary on and off", {
  expect_equal(getOption("tikzMetricsDictionary"), NULL)

  temp <- file.path(getwd(), ".tikzTemp")

  tryCatch(
    {
      options(tikzMetricsDictionary = temp)
      expect_message(checkDictionaryStatus(verbose = TRUE), "Creating")
      expect_silent(checkDictionaryStatus(verbose = FALSE))
      options(tikzMetricsDictionary = NULL)
      expect_message(checkDictionaryStatus(verbose = TRUE), "Creating")
      expect_silent(checkDictionaryStatus(verbose = FALSE))
      options(tikzMetricsDictionary = temp)
      expect_message(checkDictionaryStatus(verbose = TRUE), "Using")
      expect_silent(checkDictionaryStatus(verbose = FALSE))
      options(tikzMetricsDictionary = NULL)
      expect_message(checkDictionaryStatus(verbose = TRUE), "Creating")
      expect_silent(checkDictionaryStatus(verbose = FALSE))
    },
    finally = {
      options(tikzMetricsDictionary = NULL)
      unlink(temp, recursive = TRUE)
    }
  )
})
