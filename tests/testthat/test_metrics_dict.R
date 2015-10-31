# Switch to the detailed reporter implemented in helper_reporters.R
with_reporter(MultiReporter$new(reporters = list(get_reporter(), DetailedReporter$new())), {

context('Metrics dictionary')

test_that('Temporary metrics dictionary is created, but only once', {
  expect_equal(getOption('tikzMetricsDictionary'), NULL)

  rm(list = ls(envir = .tikzInternal), envir = .tikzInternal)
  expect_that(checkDictionaryStatus(verbose = TRUE), shows_message("Creating"))
  expect_that(checkDictionaryStatus(verbose = TRUE), not(shows_message()))
  expect_true(file.exists(.tikzInternal[["db_file"]]))
})

test_that('Silent creation of temporary metrics dictionary', {
  expect_equal(getOption('tikzMetricsDictionary'), NULL)

  rm(list = ls(envir = .tikzInternal), envir = .tikzInternal)
  expect_that(checkDictionaryStatus(verbose = FALSE), not(shows_message()))
  expect_that(checkDictionaryStatus(verbose = FALSE), not(shows_message()))
  expect_true(file.exists(.tikzInternal[["db_file"]]))
})

test_that('Switching metrics dictionary', {
  expect_equal(getOption('tikzMetricsDictionary'), NULL)

  tempA <- file.path(getwd(), ".tikzTempA")
  tempB <- file.path(getwd(), ".tikzTempB")

  tryCatch(
    {
      options(tikzMetricsDictionary=tempA)
      expect_that(checkDictionaryStatus(verbose = TRUE), shows_message("Creating"))
      expect_that(checkDictionaryStatus(verbose = TRUE), not(shows_message()))
      options(tikzMetricsDictionary=tempB)
      expect_that(checkDictionaryStatus(verbose = TRUE), shows_message("Creating"))
      expect_that(checkDictionaryStatus(verbose = TRUE), not(shows_message()))
      options(tikzMetricsDictionary=tempA)
      expect_that(checkDictionaryStatus(verbose = TRUE), shows_message("Using"))
      expect_that(checkDictionaryStatus(verbose = TRUE), not(shows_message()))
      options(tikzMetricsDictionary=tempB)
      expect_that(checkDictionaryStatus(verbose = TRUE), shows_message("Using"))
      expect_that(checkDictionaryStatus(verbose = TRUE), not(shows_message()))
      options(tikzMetricsDictionary=tempA)
      expect_that(checkDictionaryStatus(verbose = FALSE), not(shows_message()))
      expect_that(checkDictionaryStatus(verbose = FALSE), not(shows_message()))
      options(tikzMetricsDictionary=tempB)
      expect_that(checkDictionaryStatus(verbose = FALSE), not(shows_message()))
      expect_that(checkDictionaryStatus(verbose = FALSE), not(shows_message()))
    },
    finally = {
      options(tikzMetricsDictionary=NULL)
      unlink(tempA, recursive = TRUE)
      unlink(tempB, recursive = TRUE)
    }
  )
})

test_that('Turning custom metrics dictionary on and off', {
  expect_equal(getOption('tikzMetricsDictionary'), NULL)

  temp <- file.path(getwd(), ".tikzTemp")

  tryCatch(
    {
      options(tikzMetricsDictionary=temp)
      expect_that(checkDictionaryStatus(verbose = TRUE), shows_message("Creating"))
      expect_that(checkDictionaryStatus(verbose = TRUE), not(shows_message()))
      options(tikzMetricsDictionary=NULL)
      expect_that(checkDictionaryStatus(verbose = TRUE), shows_message("Creating"))
      expect_that(checkDictionaryStatus(verbose = TRUE), not(shows_message()))
      options(tikzMetricsDictionary=temp)
      expect_that(checkDictionaryStatus(verbose = TRUE), shows_message("Using"))
      expect_that(checkDictionaryStatus(verbose = TRUE), not(shows_message()))
      options(tikzMetricsDictionary=NULL)
      expect_that(checkDictionaryStatus(verbose = TRUE), shows_message("Creating"))
      expect_that(checkDictionaryStatus(verbose = TRUE), not(shows_message()))
    },
    finally = {
      options(tikzMetricsDictionary=NULL)
      unlink(temp, recursive = TRUE)
    }
  )
})

}) # End reporter swap

