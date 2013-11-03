# Custom expectations for tests.

runs_cleanly <- function ()
# This expecatation is an inversion and combination of the throws_error and
# gives_warning expectations. That is, the code run under this expectation
# should not throw any errors or generate any warnings.
{
    function(expr) {
        oldwarn = as.numeric(options(warn = 2))
        res = try(eval(substitute(expr), parent.frame()), silent = TRUE)
        options(warn = oldwarn)
        testthat:::expectation( (!inherits(res, 'try-error')),
                                "warnings or errors occurred")
    }
}
