library(dplyr)

evaluate <- function(true_mean_exp, raw_results){
  evaluate_table <- raw_results %>% group_by(mechanism, method) %>%
  summarize(
    bias = mean(estimate) - true_mean_exp,
    empirical_se = sd(estimate),
    coverage = mean(ci_low <= true_mean_exp & true_mean_exp <= ci_high),
    mcse_bias = sd(estimate) / sqrt(n()),
    mcse_empirical_se = sd(estimate) / sqrt(2*(n()-1)),
    mcse_coverage = sqrt(coverage * (1 - coverage) / n()),
    .groups = "drop_last"
  )
  return(evaluate_table)
}