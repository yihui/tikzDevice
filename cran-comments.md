New maintainer upload for ORPHANED package. This upload also fixes the missing
Suggestes and the "Additional issues" from rchk. The registration issues where
already corrected by the CRAN team and are included in this version.

## Test environments

* local:  Debian stable with R 3.5.0
* Travis-CI:
    * Ubuntu Trusty, R 3.5.0, R 3.4.4, R-devel
* AppVeyor: Windows, R 3.5.0
* winbuilder: Windows, R-devel

## R CMD check results

0 errors | 0 warnings | 1 note

New maintainer:
  Ralf Stubner <ralf.stubner@daqana.com>
Old maintainer(s):
  ORPHANED

CRAN repository db overrides:
  X-CRAN-Comment: Orphaned and corrected on 2018-02-14 as check errors
    were not corrected despite reminder.

  Included missing Suggests, rchk and registration issues.
  Maintainer: ORPHANED

## revdepcheck results

We checked 8 reverse dependencies, comparing R CMD check results across CRAN and dev versions of this package.

 * We saw 0 new problems
 * We failed to check 0 packages
