context('Querying of pointsize')

test_that('Pointsize is extracted correctly',{
  expect_equal(getDocumentPointsize('\\documentclass[draft,12pt]{article}'), 12)
  expect_equal(getDocumentPointsize('\\documentclass[11pt,draft]{article}'), 11)
  expect_equal(getDocumentPointsize('\\documentclass[ 10pt ,draft]{article}'), 10)
  expect_equal(getDocumentPointsize('\\documentclass[10pt]{article}'), 10)
  expect_equal(getDocumentPointsize('\\documentclass{article}'), NA)
  expect_equal(getDocumentPointsize('\\documentclass{report}'), NA)
  expect_equal(getDocumentPointsize('\\documentclass[12pt]{report}\n'), 12)
  expect_equal(getDocumentPointsize('\\documentclass{report}\n'), NA)
  expect_equal(getDocumentPointsize('\\PassOptionToPackage{x}{y}\n\\documentclass[11pt]{report}\n'), 11)
})
