<!-- README.md is generated from README.Rmd. Please edit that file -->
Supplementary Information for the paper "Identifying patients using antidepressants for the treatment of depression"
====================================================================================================================

This R package contains similar (synthetic) data to the dataset used in the paper, and all R code used in the analysis.

Steps
-----

### Install this package

``` r
install.packages('devtools')
devtools::install_github("strakaps/antidepressants")
```

### Load synthetic data

``` r
library(antidepressants)
data("synthetic")
```

### Bootstrap and fit glinternet models

``` r
bootglinternet(B = 10, nLambda = 20)
```

### Reproduce analysis

-   Open the R Notebook `inst/workflow.nb.html` in a browser
-   Click `Code` in top-right corner, and Download Rmd.
