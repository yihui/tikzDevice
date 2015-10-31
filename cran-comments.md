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
due to the "u umlaut" in my name. From my analysis, this is caused by unset
encoding in packages.rds: Almost all entries in the character matrix stored in
http://cran.r-project.org/web/packages/packages.rds
have encoding "unknown", on both Windows and Linux, whereas they probably should
be marked with encoding "UTF-8" where appropriate.

table(Encoding(readRDS("~/Downloads/packages.rds")))

)

## Downstream dependencies
I have also run R CMD check on the one downstream dependency, dplR.
The check passed.
