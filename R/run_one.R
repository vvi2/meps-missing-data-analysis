source("R/amputate_data.R")
source("R/estimators.R")
library(dplyr)
run_one <- function(truth_set, mechanism, seed){
  set.seed(seed)
  boot_sample <- truth_set[sample(nrow(truth_set), replace = TRUE), ]
  amputated_data <- amputate_data(boot_sample, mechanism)
  imputed_data <- mice(amputated_data, m = 20, method = "pmm", printFlag = FALSE)
  complete_case <- est_complete_case(amputated_data)
  mean_imputation <- est_mean_imputation(amputated_data)
  mi_pmm <- est_mi_pmm(imputed_data)
  mi_delta <- est_mi_delta(imputed_data, 0)
  combined <- bind_rows(complete_case, mean_imputation, mi_pmm, mi_delta) %>%
  mutate(method = c("complete_case", "mean_imputation", "mi_pmm", "mi_delta"), mechanism = mechanism, seed = seed)
  return(as_tibble(combined))
}