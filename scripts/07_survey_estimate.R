source("R/survey_estimate.R")
real_data <- readRDS("data/analysis_frame.rds")

complete_case <- weighted_est_complete_case(real_data)
mi <- weighted_est_mi(real_data)
diff <- unname(mi$estimate - complete_case$estimate)
national_diff <- diff * sum(real_data$LONGWT)

cat(sprintf("Weighted complete-case estimate: $%s\n", format(round(complete_case$estimate, 2), big.mark = ",")))
cat(sprintf("Weighted MI estimate: $%s\n", format(round(mi$estimate, 2), big.mark = ",")))
cat(sprintf("Difference (MI - complete case): $%s per person\n", format(round(diff, 2), big.mark = ",")))
cat(sprintf("Scaled to population: $%s total\n", format(round(national_diff, 0), big.mark = ",", scientific = FALSE)))

saveRDS(
  list(complete_case = complete_case, mi = mi, diff = diff, national_diff = national_diff),
  file = "results/survey_estimate.rds"
)
