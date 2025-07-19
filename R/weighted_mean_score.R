#' Calculate Weighted Mean Scores Using the Kılıç & Doğan (2019) Method
#'
#' This function first weights an item-response matrix using the
#' `item_weighting` function and then calculates the mean score for
#' each individual.
#'
#' @param x A numeric data.frame or matrix. Rows should represent individuals,
#'   and columns should represent items. The method was designed for
#'   dichotomous (0-1) data.
#' @param threshold The threshold value for applying the weighting, passed to
#'   the `item_weighting` function. The article uses a value of 1.
#'
#' @return A numeric vector containing the weighted mean score for each
#'   individual (each row).
#' @export
#' @examples
#' \dontrun{
#' # Generate sample dichotomous data
#' set.seed(123)
#' my_data <- as.data.frame(
#'   matrix(rbinom(200 * 10, 1, 0.6), nrow = 200)
#' )
#'
#' # Calculate weighted mean scores
#' mean_scores <- weighted_mean_score(my_data, threshold = 1)
#'
#' # View the first few mean scores
#' cat("--- Weighted Mean Scores (Head) ---\n")
#' print(head(mean_scores))
#'
#' # Compare with simple unweighted mean scores
#' unweighted_means <- rowMeans(my_data)
#' cat("\n--- Unweighted Mean Scores (Head) ---\n")
#' print(head(unweighted_means))
#' }
weighted_mean_score <- function(x, threshold = 1) {

  # Step 1: Weight the data using the provided item_weighting function.
  # The threshold argument is passed directly to the weighting function.
  weighted_data <- item_weighting(x = x, threshold = threshold)

  # Step 2: Calculate the mean of scores for each row (individual).
  # This is the key difference from weighted_sum_score().
  # na.rm = TRUE is used for robustness in case of missing values.
  mean_scores <- rowMeans(weighted_data, na.rm = TRUE)

  # Return the vector of mean scores
  return(mean_scores)
}