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
10 checked out of 10 dependencies 

## crayon (1.3.1)
Maintainer: Gabor Csardi <csardi.gabor@gmail.com>  
Bug reports: https://github.com/gaborcsardi/crayon/issues

__OK__

## dplR (1.6.3)
Maintainer: Andy Bunn <andy.bunn@wwu.edu>

__OK__

## evaluate (0.8)
Maintainer: Yihui Xie <xie@yihui.name>  
Bug reports: https://github.com/hadley/evaluate/issues

__OK__

## filehash (2.3)
Maintainer: Roger D. Peng <rdpeng@jhu.edu>

__OK__

## ggplot2 (2.0.0)
Maintainer: Hadley Wickham <hadley@rstudio.com>  
Bug reports: https://github.com/hadley/ggplot2/issues

```
checking examples ... ERROR
Running examples in ‘ggplot2-Ex.R’ failed
The error most likely occurred in:

> base::assign(".ptime", proc.time(), pos = "CheckExEnv")
> ### Name: scale_x_discrete
> ### Title: Discrete position.
> ### Aliases: scale_x_discrete scale_y_discrete
> 
> ### ** Examples
> 
> ## No test: 
> ggplot(diamonds, aes(cut)) + stat_bin()
Error: StatBin requires a continuous x variable the x variable is discrete. Perhaps you want stat="count"?
Execution halted
```
```
DONE
Status: 1 ERROR
```

## knitr (1.12.3)
Maintainer: Yihui Xie <xie@yihui.name>  
Bug reports: https://github.com/yihui/knitr/issues

__OK__

## maps (3.0.2)
Maintainer: Alex Deckmyn <alex.deckmyn@meteo.be>

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

## stringr (1.0.0)
Maintainer: Hadley Wickham <hadley@rstudio.com>

__OK__

## testthat (0.11.0)
Maintainer: Hadley Wickham <hadley@rstudio.com>  
Bug reports: https://github.com/hadley/testthat/issues

__OK__

