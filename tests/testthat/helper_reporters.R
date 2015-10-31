# This file contains custom test reporters.

library(stringr)

DetailedReporter <- setRefClass('DetailedReporter', where = .GlobalEnv, contains = 'Reporter',
  fields = list(
    'width' = 'integer',
    'n_tests' = 'integer',
    'n_failed' = 'integer',
    'failures' = 'list',
    'start_time' = 'ANY'
  ),
  methods = list(

    start_reporter = function() {
      failed <<- FALSE

      width <<- getOption('width')
      n_tests <<- 0L
      n_failed <<- 0L
      failures <<- list()
      start_time <<- NULL

      cat(str_c(rep('=', width), collapse=''), '\n')
    },

    start_context = function(desc) {
      cat(str_c('\n', desc, '\n'))
      cat(str_c(rep('-', nchar(desc)), collapse=''), '\n')

      context <<- desc
      n_tests <<- 0L
      n_failed <<- 0L
      failures <<- list()
    },

    start_test = function(desc){
      cat(desc)
      test <<- desc
      start_time <<- Sys.time()
    },

    add_result = function(result) {
      spacer <- paste(rep(' ',width - nchar(test) - 5),
        collapse = '')
      if (result$passed) {
        cat(spacer, crayon::green("PASS\n"))
      } else {
        failed <<- TRUE
        n_failed <<- n_failed + 1L
        result$test <- test
        failures[[n_failed]] <<- result

        cat(spacer, crayon::red("FAIL\n"))
      }
    },

    end_test = function(){
      elapsed_time <- as.numeric(difftime(Sys.time(), start_time,
        units='secs'))
      cat('  Elapsed Time: ', sprintf("%6.2f", elapsed_time), ' seconds\n')
      test <<- NULL
      start_time <<- NULL
      n_tests <<- n_tests + 1L
    },

    end_context = function() {
      cat(paste(rep('-', width), collapse=''), '\n')
      n_success <- n_tests - n_failed
      success_per <- round( n_success / n_tests * 100, 2 )

      test_status <- paste(n_success, '/', n_tests,
        ' (', success_per, '%)', sep = '')
      test_status <- ifelse(n_failed == 0L,
                            crayon::green(test_status),
                            crayon::red(test_status))

      cat(test_status, 'tests successfully executed in this context.\n' )

      if( n_failed > 0L ){
        cat('\nOutput from failed tests:\n\n')

        charrep <- function(char, times) {
          sapply(times, function(i) str_c(rep.int(char, i), collapse = ""))
        }

        type <- ifelse(sapply(failures, "[[", "error"), "Error", "Failure")
        tests <- sapply(failures, "[[", "test")
        header <- str_c(type, ": ", tests, " ")
        linewidth <- ifelse(nchar(header) > getOption("width"),
          0, getOption("width") - nchar(header))
        line <- charrep("-", linewidth )

        message <- sapply(failures, "[[", "failure_msg")

        cat(str_c(
          crayon::red(header), line, "\n",
          message, "\n", collapse = "\n"))

      }
    },

    end_reporter = function() {
      cat(str_c(rep('=', width), collapse=''), '\n\n')
    }
  ) # End methods list
) # End DetailedReporter class

# This reporter is used by the graphics tests. It is very similar to the
# DetailedReporter, but contains specialized functionality for displaying the
# results of graphics tests.
GraphicsReporter <- setRefClass('GraphicsReporter', where = .GlobalEnv, contains = 'DetailedReporter',
  fields = list(
    'cmp_command' = 'character',
    'ran_vis_diff' = 'logical',
    'pixel_error' = 'ANY',
    'n_ctx_failed' = 'integer'
  ),
  methods = list(

    start_reporter = function() {
      width <<- getOption('width')

      ran_vis_diff <<- FALSE
      pixel_error <<- 'SKIP'
      n_tests <<- 0L
      n_failed <<- 0L
      n_ctx_failed <<- 0L

      cat(str_c(rep('=', width), collapse=''), '\n')
      cat('Graphics Tests', '\n')
      cat(str_c(rep('~', width), collapse=''), '\n')
    },

    start_context = function(desc) {
      cat(str_c('\n', desc, '\n'))
      failed <<- FALSE
    },

    start_test = function(desc){
      cat('  ', desc)
      test <<- desc
      start_time <<- Sys.time()
    },

    set_cmp_command = function(the_cmp_command) {
      cmp_command <<- the_cmp_command
    },

    vis_result = function(the_error) {
      ran_vis_diff <<- TRUE
      pixel_error <<- the_error
    },

    add_result = function(result) {
      if ( ran_vis_diff ) {
        if ( is.na(pixel_error) ) {
          spacer <- paste(rep(' ', width - nchar(test) - 19),
            collapse = '')
          cat(spacer, crayon::yellow("UNKNOWN"), "\n")
        } else if ( pixel_error == 'SKIP' ) {
          spacer <- paste(rep(' ', width - nchar(test) - 19),
            collapse = '')
          cat(spacer, crayon::yellow("SKIP"), "\n")
        } else {
          spacer <- paste(rep(' ', width - nchar(test) - 29),
            collapse = '')
          cat(spacer, 'Error of:',
            crayon::yellow(sprintf("%8.2g pixels", pixel_error)),
            "\n"
          )
          if (pixel_error > 0)
            cat('   Command for comparison:', "\n", cmp_command, "\n")
        }
      }

      spacer <- paste(rep(' ', width - nchar(test) - 19),
        collapse = '')
      if (result$passed) {
        cat(spacer, crayon::green("PASS"))
      } else {
        failed <<- TRUE
        n_failed <<- n_failed + 1L
        result$test <- test
        failures[[n_failed]] <<- result

        cat(spacer, crayon::red("FAIL"))
      }
    },

    end_test = function(){
      if( ran_vis_diff ) {
        ran_vis_diff <<- FALSE
      } else {
        elapsed_time <- as.numeric(difftime(Sys.time(), start_time,
          units='secs'))
        cat(sprintf(" %6.2f sec\n", elapsed_time))
      }
    },

    end_context = function() {
      if ( failed ) {
        n_ctx_failed <<- n_ctx_failed + 1L
      }
      n_tests <<- n_tests + 1L
    },

    end_reporter = function() {
      cat(paste(rep('-', width), collapse=''), '\n')
      n_success <- n_tests - n_ctx_failed
      success_per <- round( n_success / n_tests * 100, 2 )

      test_status <- paste(n_success, '/', n_tests,
        ' (', success_per, '%)', sep = '')
      test_status <- ifelse(n_ctx_failed == 0L,
                            crayon::green(test_status),
                            crayon::red(test_status))

      cat(test_status, 'tests successfully executed.\n' )

      if( n_failed > 0L ){
        cat('\nOutput from failed tests:\n\n')

        charrep <- function(char, times) {
          sapply(times, function(i) str_c(rep.int(char, i), collapse = ""))
        }

        type <- ifelse(sapply(failures, "[[", "error"), "Error", "Failure")
        tests <- sapply(failures, "[[", "test")
        header <- str_c(type, ": ", tests, " ")
        linewidth <- ifelse(nchar(header) > getOption("width"),
          0, getOption("width") - nchar(header))
        line <- charrep("-", linewidth )

        message <- sapply(failures, "[[", "failure_msg")

        cat(str_c(
          crayon::red(header), line, "\n",
          message, "\n", collapse = "\n"))

      }
      cat(str_c(rep('=', width), collapse=''), '\n\n')
    }

  ) # End methods list
) # End GraphicsReporter
