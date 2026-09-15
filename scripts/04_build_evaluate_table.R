source("R/build_truth_set.R")
source("R/evaluate.R")

data_frame <- readRDS("data/analysis_frame.rds")
truth <- build_truth_set(data_frame)
raw_results <- readRDS("results/raw_results.rds")

evaluate_table <- evaluate(truth$true_mean_exp, raw_results)
saveRDS(evaluate_table, "results/evaluate_table.rds")