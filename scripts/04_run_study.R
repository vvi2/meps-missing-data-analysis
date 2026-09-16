source("R/build_truth_set.R")
source("R/run_study.R")

data_frame <- readRDS("data/analysis_frame.rds")
truth <- build_truth_set(data_frame)
run_study(truth$true_data, 500)