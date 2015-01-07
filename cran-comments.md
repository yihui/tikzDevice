## Reason
Failing installation on OS X and Solaris

## Test environments
* local Ubuntu 14.10 install, R 3.1.2
* Ubuntu 12.04 (on travis-ci), R-devel, 3.1.2 to 3.1.0
* OS X 10.9.1, R 3.1.2
* win-builder (devel and release)

## R CMD check results
There were no ERRORs or WARNINGs. 

## Downstream dependencies
I have also run R CMD check on the one downstream dependency, dplR.
The check passed.
