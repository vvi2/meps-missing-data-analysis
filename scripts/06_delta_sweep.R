source("R/delta_sweep.R")

data_frame <- readRDS("data/analysis_frame.rds")
truth <- build_truth_set(data_frame)
delta_sweep_results <- delta_sweep(truth$true_data, 42)
saveRDS(delta_sweep_results, "results/delta_sweep.rds")