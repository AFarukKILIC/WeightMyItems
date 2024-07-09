
# WeightMyItems: Weight Your Scale Items

<!-- badges: start -->
<!-- badges: end -->

This package provides a function to weight items in a dataset using Kilic & Dogan's (2019) <doi:10.21031/epod.516057> method. 
    The `item_weighting` function calculates weighted scores for items based on their difficulty and discrimination, adjusting the individual item responses to improve construct validity.
    This method can be particularly useful in educational and psychological assessments where item response theory is not applied.


## Installation

You can install the development version of FAfA like so:

``` r
install.packages("devtools")
devtools::install_github("AFarukKILIC/WeightMyItems")
```

## Example


``` r
library(WeightMyItems)
item_weighting(x)
#x is a data frame
```

