# Setup

## Platform

|setting  |value                        |
|:--------|:----------------------------|
|version  |R version 3.2.3 (2015-12-10) |
|system   |x86_64, linux-gnu            |
|ui       |X11                          |
|language |en_US:en                     |
|collate  |en_US.UTF-8                  |
|tz       |NA                           |
|date     |2016-02-04                   |

## Packages

|package  |*  |version |date       |source         |
|:--------|:--|:-------|:----------|:--------------|
|crayon   |   |1.3.1   |2015-07-13 |CRAN (R 3.2.3) |
|evaluate |   |0.8     |2015-09-18 |CRAN (R 3.2.3) |
|filehash |   |2.3     |2015-08-16 |CRAN (R 3.2.3) |
|ggplot2  |   |2.0.0   |2015-12-18 |CRAN (R 3.2.3) |
|knitr    |   |1.12.3  |2016-01-22 |CRAN (R 3.2.3) |
|maps     |   |3.0.2   |2016-01-04 |CRAN (R 3.2.3) |
|png      |   |0.1-7   |2013-12-03 |CRAN (R 3.2.3) |
|stringr  |   |1.0.0   |2015-04-30 |CRAN (R 3.2.3) |
|testthat |   |0.11.0  |2015-10-14 |CRAN (R 3.2.3) |

# Check results
3 checked out of 3 dependencies 

## dplR (1.6.3)
Maintainer: Andy Bunn <andy.bunn@wwu.edu>

__OK__

## knitr (1.12.3)
Maintainer: Yihui Xie <xie@yihui.name>  
Bug reports: https://github.com/yihui/knitr/issues

__OK__

## sfsmisc (1.0-29)
Maintainer: Martin Maechler <maechler@stat.math.ethz.ch>

```
checking package dependencies ... NOTE
Packages which this enhances but not available for checking:
  ‘nor1mix’ ‘polycor’
```
```
checking R code for possible problems ... NOTE
Found the following calls to attach():
File ‘sfsmisc/R/sourceAttach.R’:
  attach(ENV, pos = pos, name = name, warn.conflicts = warn.conflicts)
See section ‘Good practice’ in ‘?attach’.
```
```
checking Rd cross-references ... NOTE
Packages unavailable to check Rd xrefs: ‘pastecs’, ‘polycor’, ‘polynom’
```
```
DONE
Status: 3 NOTEs
```

