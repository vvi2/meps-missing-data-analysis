library(dplyr)
library(tibble)
library(tidyr)
library(furrr)
source("R/run_one.R")

run_study <- function(truth_set, n_reps){
  #Parallelized version of for loop logic below it to spped the replications up
  plan(multisession, workers = parallel::detectCores() - 1)
  grid <- expand_grid(mechanism = c("MCAR", "MAR", "MNAR"), rep_num = 1:n_reps)
  results_list <- future_map2(
    grid$mechanism, grid$rep_num,
    ~ run_one(truth_set, .x, .y),
    .options = furrr_options(seed = TRUE)
  )
  # results_list <- vector("list", 3*n_reps)
  # counter <- 1
  # for (mechanism in c("MCAR", "MAR", "MNAR")){
  #   for (rep_num in 1:n_reps){
  #     results_list[[counter]] <- run_one(truth_set, mechanism, rep_num)
  #     counter <- counter+1
  #   }
  # }
  final_results <- bind_rows(results_list)
  saveRDS(final_results, "results/raw_results.rds")
}