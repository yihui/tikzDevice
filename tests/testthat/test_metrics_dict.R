# Switch to the detailed reporter implemented in helper_reporters.R
with_reporter(DetailedReporter$new(), {

context('Metrics dictionary')

test_that('Temporary metrics dictionary is created, but only once', {
  expect_equal(getOption('tikzMetricsDictionary'), NULL)

  rm(list = ls(envir = .tikzInternal), envir = .tikzInternal)
  expect_that(checkDictionaryStatus(), shows_message("Creating"))
  expect_that(checkDictionaryStatus(), not(shows_message()))
})



testthat:::end_context() # Needs to be done manually due to reporter swap
}) # End reporter swap

