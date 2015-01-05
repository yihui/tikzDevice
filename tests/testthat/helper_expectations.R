# Custom expectations for tests.

runs_cleanly <- function ()
# This expecatation is an inversion and combination of the throws_error and
# gives_warning expectations. That is, the code run under this expectation
# should not throw any errors or generate any warnings.
{
    function(expr) {
        oldwarn = options(warn = 2)
        res = try(eval(substitute(expr), parent.frame()), silent = TRUE)
        options(oldwarn)

        is_try_error = inherits(res, 'try-error')
        expectation(!is_try_error,
                    sprintf("warnings or errors occurred:\n%s",
                            as.character(res)))
    }
}
