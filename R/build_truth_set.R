library(tidyr)
library(dplyr)

build_truth_set <- function (data_frame){
  true_set <- data_frame %>%
  select(all_of(c("AGEY1X", "SEX", "REGIONY1", "POVCATY1", "INSCOVY1", "RTHLTH1", "DIABDXY1_M18", "TOTEXPY1", "TOTEXPY2"))) %>%
  drop_na()
  estimand <- mean(true_set$TOTEXPY2)
  return(list(true_data = true_set, true_mean_exp = estimand))
}