# Switch to the detailed reporter implemented in helper_reporters.R
testthat:::with_reporter(DetailedReporter$new(), {

context('Test tikzDevice error and warning messages')

test_that('Null device is not a tikzDevice',{

    expect_that(
      isTikzDevice(),
      is_false()
    )

})

test_that('Device produces an error for unescaped characters',{

  expect_that(
    getLatexStrWidth('_'),
    throws_error('TeX was unable to calculate metrics')
  )

})

test_that('Device warns about the lower bound of the ASCII table when using pdftex',{

  expect_that(
    getLatexCharMetrics(31, engine = 'pdftex'),
    gives_warning('pdftex can only generate metrics for character codes between 32 and 126!')
  )

})

test_that('Device warns about the upper bound of the ASCII table when using pdftex',{

  expect_that(
    getLatexCharMetrics(127),
    gives_warning('pdftex can only generate metrics for character codes between 32 and 126!')
  )

})

test_that("Device won't accept non-numeric ASCII codes",{

  expect_that(
    getLatexCharMetrics('a'),
    gives_warning('getLatexCharMetrics only accepts integers!')
  )

})

test_that('Device throws error when a path cannot be opened',{

  expect_that(
    tikz('/why/would/you/have/a/path/like/this.tex'),
    throws_error('directory does not exist or is not writable')
  )

})

test_that('tikzAnnotate refuses to work with a non-tikzDevice',{

  expect_that(
    tikzAnnotate('test'),
    throws_error('The active device is not a tikz device')
  )

})

test_that('XeTeX warns about unrecognized UTF8 characters',{

  expect_that(
    getLatexStrWidth('α', engine = 'xetex'),
    gives_warning('XeLaTeX was unable to calculate metrics')
  )

})

test_that('tikzNode warns about more than one X coordinate value',{
  tikz()
  plot.new()
  on.exit(dev.off())

  expect_that(
    tikzCoord(c(1,2), 2, 'test'),
    gives_warning('More than one X coordinate specified')
  )

})

test_that('tikzNode warns about more than one Y coordinate value',{
  tikz()
  plot.new()
  on.exit(dev.off())

  expect_that(
    tikzCoord(1, c(1,2), 'test'),
    gives_warning('More than one Y coordinate specified')
  )

})

testthat:::end_context() # Needs to be done manually due to reporter swap
}) # End reporter swap

