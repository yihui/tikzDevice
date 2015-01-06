# Switch to the detailed reporter implemented in helper_reporters.R
with_reporter(MultiReporter$new(reporters = list(get_reporter(), DetailedReporter$new())), {

context('Querying of pointsize')

test_that('Pointsize is extracted correctly',{
  expect_equal(getDocumentPointsize('\\documentclass[draft,12pt]{article}'), 12)
  expect_equal(getDocumentPointsize('\\documentclass[11pt,draft]{article}'), 11)
  expect_equal(getDocumentPointsize('\\documentclass[ 10pt ,draft]{article}'), 10)
  expect_equal(getDocumentPointsize('\\documentclass[10pt]{article}'), 10)
  expect_true(is.na(getDocumentPointsize('\\documentclass{article}')))
  expect_true(is.na(getDocumentPointsize('\\documentclass{report}')))
  expect_equal(getDocumentPointsize('\\documentclass[12pt]{report}\n'), 12)
  expect_true(is.na(getDocumentPointsize('\\documentclass{report}\n')))
  expect_equal(getDocumentPointsize('\\PassOptionToPackage{x}{y}\n\\documentclass[11pt]{report}\n'), 11)
})

}) # End reporter swap
