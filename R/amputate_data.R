library(mice)
library(haven)

amputate_data <- function(data, mechanism, prop = 0.30){
  unlabeled_data <- zap_labels(data)
  amputated_data <- switch(mechanism,
  #missing completely at random, randomize the NAs of TOTEXPY2 so set only it to 0 in patterns, and none of the variables correlate to the missingness, so weights = 0
  MCAR = ampute(unlabeled_data, prop, patterns = matrix(c(1, 1, 1, 1, 1, 1, 1, 1, 0), nrow=1), weights = NULL, mech = mechanism),
  #missing at random, randomize the NAs of TOTEXPY2 so set only it to 0 in patterns, and this missingness depend on observed variables of RTHLTH1 and TOTEXPY1, so set those corresponding columns in weights to 1
  MAR = ampute(unlabeled_data, prop, patterns = matrix(c(1, 1, 1, 1, 1, 1, 1, 1, 0), nrow=1), weights = matrix(c(0, 0, 0, 0, 0, 1, 0, 1, 0), nrow=1), mech = mechanism),
  #missing not at random, randomize the NAs of TOTEXPY2 so set only it to 0 in patterns, and this missingness depend on unobserved variableitself TOTEXPY2, so set that corresponding column in weights to 1
  MNAR = ampute(unlabeled_data, prop, patterns = matrix(c(1, 1, 1, 1, 1, 1, 1, 1, 0), nrow=1), weights = matrix(c(0, 0, 0, 0, 0, 0, 0, 0, 1), nrow=1), mech = mechanism),
  stop("Unknown mechanism: ", mechanism))
  return(amputated_data$amp)
}