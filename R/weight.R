#' Weighting items via Kilic & Dogan's method
#'
#' @param x The dataframe. Columns show items and rows show individuals.
#'
#' @return Weighted scores as data frame
#'
#' @examples
#' set.seed(1234)
#' data <- psych::sim.VSS(1000,16,1,0.5,dichot = TRUE)
#' weighted_scores <- item_weighting(data)
#' weighted_scores
#' @export
#' @import psych
#' @importFrom psychometric item.exam


item_weighting <- function(x) {
  item_stats <- psychometric::item.exam(x = x, discrim = T)
  item_diff <- item_stats$Difficulty/max(x)
  ind_averages <- rowSums(x)/(ncol(x)*max(x))
  new_data <- data.frame(matrix(NA, nrow = (nrow(x)), ncol = ncol(x)))
  colnames(new_data) <- paste("V", seq(1:ncol(x)), sep = "")
  weighted_data <- data.frame(matrix(NA, nrow = (nrow(x)), ncol = ncol(x)))
  colnames( weighted_data) <- paste("V", seq(1:ncol(x)), sep = "")
  for (i in 1:ncol(x)) {
    for(t in 1:nrow(x)){
      new_data[t,i] = ind_averages[t] + item_diff[i]
    }
  }
  for (i in 1:ncol(x)) {
    for(t in 1:nrow(x)){
      if (new_data[t,i] >= 1) {
        weighted_data[t,i] = x[t,i] + item_stats$Item.Rel.woi[i]
      } else {
        weighted_data[t,i] = x[t,i]
      }
    }
  }
  return(weighted_data)
}
