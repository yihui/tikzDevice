# Switch to the detailed reporter implemented in helper_reporters.R
with_reporter(MultiReporter$new(reporters = list(get_reporter(), DetailedReporter$new())), {

context('Metrics dictionary')

test_that('Temporary metrics dictionary is created, but only once', {
  expect_equal(getOption('tikzMetricsDictionary'), NULL)

  rm(list = ls(envir = .tikzInternal), envir = .tikzInternal)
  expect_that(checkDictionaryStatus(), shows_message("Creating"))
  expect_that(checkDictionaryStatus(), not(shows_message()))
})

}) # End reporter swap

