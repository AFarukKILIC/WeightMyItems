#' Calculate Weighted Sum Scores Using the Kılıç & Doğan (2019) Method
#'
#' This function first weights an item-response matrix using the
#' `item_weighting` function and then calculates the total (sum) score for
#' each individual.
#'
#' @param x A numeric data.frame or matrix. Rows should represent individuals,
#'   and columns should represent items. The method was designed for
#'   dichotomous (0-1) data.
#' @param threshold The threshold value for applying the weighting, passed to
#'   the `item_weighting` function. The article uses a value of 1.
#'
#' @return A numeric vector containing the total weighted score for each
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
#' # Calculate weighted sum scores
#' total_scores <- weighted_sum_score(my_data, threshold = 1)
#'
#' # View the first few scores
#' cat("--- Weighted Total Scores (Head) ---\n")
#' print(head(total_scores))
#'
#' # Compare with simple unweighted scores
#' unweighted_scores <- rowSums(my_data)
#' cat("\n--- Unweighted Total Scores (Head) ---\n")
#' print(head(unweighted_scores))
#' }
weighted_sum_score <- function(x, threshold = 1) {

  # Step 1: Weight the data using the provided item_weighting function.
  # The threshold argument is passed directly to the weighting function.
  weighted_data <- item_weighting(x = x, threshold = threshold)

  # Step 2: Calculate the sum of scores for each row (individual).
  # na.rm = TRUE is used for robustness in case of missing values.
  total_scores <- rowSums(weighted_data, na.rm = TRUE)

  # Return the vector of total scores
  return(total_scores)
}