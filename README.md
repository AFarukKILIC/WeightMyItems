
# WeightMyItems: Weight Your Scale Items

<!-- badges: start -->
<!-- badges: end -->

Implements the item weighting method from Kilic and Dogan (2019) 
    <doi:10.21031/epod.516057> to improve construct validity in psychological 
    and educational assessments. The methodology adjusts raw scores by adding 
    an item's reliability index (corrected item-total correlation) when a 
    condition based on person ability and item difficulty is met. 
    The package provides a core function, `item_weighting()`, which returns 
    a complete weighted data matrix. For more direct results, 
    `weighted_sum_score()` and `weighted_mean_score()` provide convenience 
    wrappers that return the total or mean weighted score for each 
    individual, respectively


## Installation

You can install the development version of WeightMyItems like so:

``` r
install.packages("devtools")
devtools::install_github("AFarukKILIC/WeightMyItems")
```

## Example


``` r
# 1. Load the Package
library(WeightMyItems)

# 2. Create Sample Data
# Set a seed for reproducible results
set.seed(123)

# Let's create a dataset in the 0-1 (dichotomous) format,
# for which the method was designed
# 200 individuals (rows) and 10 items (columns)
dich_data <- as.data.frame(
  matrix(rbinom(200 * 10, 1, 0.6), nrow = 200)
)

cat("--- Original Data Set (First 6 Rows) ---\n")
print(head(dich_data))


# 3. Using the Functions

# --- Function 1: item_weighting() ---
# This is the core function that weights the entire data matrix.
# The result is a new matrix containing the weighted scores.
cat("\n--- Weighted Data Matrix (First 6 Rows) ---\n")
weighted_matrix <- item_weighting(dich_data)
print(head(weighted_matrix))


# --- Function 2: weighted_sum_score() ---
# It both performs the weighting and calculates the total score for each individual.
# The result is a vector containing a single total score for each individual.
cat("\n--- Weighted Total Scores (First 6) ---\n")
total_scores <- weighted_sum_score(dich_data)
print(head(total_scores))


# --- Function 3: weighted_mean_score() ---
# It both performs the weighting and calculates the mean score for each individual.
# The result is a vector containing a single mean score for each individual.
cat("\n--- Weighted Mean Scores (First 6) ---\n")
mean_scores <- weighted_mean_score(dich_data)
print(head(mean_scores))


# 4. Comparing the Results
# Let's compare with the simple sum and mean to see the effect of the weighting.
unweighted_total <- rowSums(dich_data)
unweighted_mean <- rowMeans(dich_data)

# Let's combine the results into a more readable data.frame.
comparison_df <- data.frame(
  ID = 1:200,
  Weighted_Sum = total_scores,
  Unweighted_Sum = unweighted_total,
  Weighted_Mean = mean_scores,
  Unweighted_Mean = unweighted_mean
)

cat("\n--- Comparison of Weighted and Unweighted Scores (First 10 Individuals) ---\n")
print(head(comparison_df, 10))
```

