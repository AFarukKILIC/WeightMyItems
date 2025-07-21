#' Item Weighting According to the Kilic & Dogan (2019) Method
#'
#' This function weights an item-response matrix using the method proposed by
#' Kilic & Dogan (2019). The method is based on adding the item reliability
#' index (corrected item-total correlation) to the original score if the sum
#' of the person's average score and the item's difficulty index exceeds a
#' certain threshold (default is 1).
#'
#' @references Kilic, A. F., & Dogan, N. (2019). The effect of item weighting on reliability and validity.
#' Journal of Measurement and Evaluation in Education and Psychology, 10(2), 149-164. DOI: 10.21031/epod.516057
#'
#' @param x A numeric data.frame or matrix. Rows should represent individuals, and columns should represent items.
#'          The method was designed for dichotomous (0-1) data.
#' @param threshold The threshold value for applying the weighting. The article uses a value of 1.
#'
#' @return A new data.frame of the same dimensions with weighted scores.
#' @export
#' @importFrom psychometric item.exam
#' @examples
#' ## Example 1: Dichotomous Data (as in the original study)
#' set.seed(123)
#' n_students_dich <- 200
#' n_items_dich <- 10
#' dich_data <- as.data.frame(
#'   matrix(
#'     rbinom(n_students_dich * n_items_dich, 1, 0.6),
#'     nrow = n_students_dich
#'   )
#' )
#' cat("--- Original Dichotomous Data (Head) ---\n")
#' print(head(dich_data))
#'
#' weighted_dich <- item_weighting(dich_data)
#' cat("\n--- Weighted Dichotomous Data (Head) ---\n")
#' print(head(weighted_dich))
#'
#'
#' ## Example 2: 5-Point Likert-Type Data
#' # Note: The function was designed for 0-1 data. With Likert data,
#' # the person's average score will likely be > 1, causing the weighting
#' # condition to be met for almost all responses.
#' set.seed(456)
#' n_students_likert <- 150
#' n_items_likert <- 15
#' likert_data <- as.data.frame(
#'   matrix(
#'     sample(1:5, size = n_students_likert * n_items_likert, replace = TRUE),
#'     nrow = n_students_likert
#'   )
#' )
#' cat("\n--- Original 5-Point Likert Data (Head) ---\n")
#' print(head(likert_data))
#'
#' weighted_likert <- item_weighting(likert_data)
#' cat("\n--- Weighted 5-Point Likert Data (Head) ---\n")
#' print(head(weighted_likert))
item_weighting <- function(x, threshold = 1) {

  # Input checks
  if (!is.data.frame(x) && !is.matrix(x)) {
    stop("Input 'x' must be a data.frame or matrix.")
  }
  if (!all(sapply(x, is.numeric))) {
    stop("All columns in 'x' must be numeric.")
  }

  # Calculate item statistics
  item_stats <- psychometric::item.exam(x = x, discrim = TRUE)

  # Get values as defined in the paper
  # Ij: Person's average score (Total Score / Number of Items), normalized
  person_average_scores <- ((rowSums(x, na.rm = TRUE) / ncol(x)) - min(x, na.rm = TRUE)) /
                           (max(x, na.rm = TRUE) - min(x, na.rm = TRUE))

  # pi: Item difficulty index, normalized
  item_difficulty_indices <- (item_stats$Difficulty - min(x, na.rm = TRUE)) /
                             (max(x, na.rm = TRUE) - min(x, na.rm = TRUE))

  # Item reliability index (Corrected item-total correlation)
  item_reliability_indices <- item_stats$Item.Rel.woi

  # --- Vectorized Weighting Process ---

  # Create the condition matrix: (pi + Ij)
  condition_matrix <- outer(person_average_scores, item_difficulty_indices, FUN = "+")

  # Create the weight matrix
  weight_matrix <- matrix(item_reliability_indices,
                          nrow = nrow(x),
                          ncol = ncol(x),
                          byrow = TRUE)

  # --- Corrected Conditional Weighting using Logical Indexing ---
  # 1. Start with a copy of the original data as a matrix.
  weighted_data <- as.matrix(x)

  # 2. Identify which cells meet the condition. This creates a logical matrix (TRUE/FALSE).
  update_cells <- condition_matrix >= threshold

  # 3. Update only the cells where the condition is TRUE.
  #    The values from (original_data + weight_matrix) are used for the update.
  #    This preserves the matrix structure, unlike ifelse().
  weighted_data[update_cells] <- (weighted_data + weight_matrix)[update_cells]

  # Return as a data.frame with original names
  weighted_data <- as.data.frame(weighted_data)
  colnames(weighted_data) <- colnames(x)
  rownames(weighted_data) <- rownames(x)

  return(weighted_data)
}
