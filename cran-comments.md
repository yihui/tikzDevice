## Reasons
* Failing installation on OS X and Solaris
* Archive unnecessarily large

## Test environments
* local Ubuntu 14.10 install, R 3.1.2
* Ubuntu 12.04 (on travis-ci), R-devel, 3.1.2 to 3.1.0
* OS X 10.9.1, R 3.1.2
* win-builder (devel and release)

## R CMD check results
There were no ERRORs or WARNINGs, just a NOTE mentioning 0 days
since last update. (A bogus WARNING appeared on winbuilder
due to the "u umlaut" in my name.)

## Downstream dependencies
I have also run R CMD check on the one downstream dependency, dplR.
The check passed.
