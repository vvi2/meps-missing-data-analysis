library(ggplot2)
source("R/build_truth_set.R")

theme_set(theme_minimal(base_size = 12.5, base_family = "serif")+ theme(plot.title = element_text(hjust = 0.5), plot.caption = element_text(hjust = 0.5)))
coverage_by_mechanism_plot <- function(evaluate_table){
  plot <- ggplot(data = evaluate_table, aes(x = method, y = coverage)) + geom_point() + facet_wrap(~ mechanism) + geom_hline(yintercept = 0.95, color="red", linetype = "dashed", linewidth=1) + theme(axis.text.x = element_text(angle = 45, hjust = 1)) + labs(title = "Figure 1: 95% Confidence Interval Coverage by Missing Data Method and Missingness Mechanism", caption = "Dashed red line = 95% target coverage")


  return(plot)

}

bias_by_method_plot <- function(evaluate_table){
  plot <- ggplot(data = evaluate_table, aes(x = method, y = bias)) + geom_point() + facet_wrap(~ mechanism) + geom_hline(yintercept = 0, color="red", linetype = "dashed", linewidth=1) + geom_errorbar(aes(ymin = bias - 2 * mcse_bias, ymax = bias + 2 * mcse_bias), width = 0.3)+ theme(axis.text.x = element_text(angle = 45, hjust = 1)) + labs(title = "Figure 2: Bias by Missing Data Method and Missingness Mechanism", caption = "Dashed red line = zero bias (target). Error bars = bias +/- 2*MCSE")
  return(plot)

}

tipping_point_curve <- function(delta_sweep_results){
  data_frame <- readRDS("data/analysis_frame.rds")
  truth <- build_truth_set(data_frame)
  plot <- ggplot(data = delta_sweep_results$table, aes(x = delta, y = estimate)) + geom_point() + geom_line() + geom_hline(aes(yintercept = truth$true_mean_exp, color="True TOTEXPY2 value"), linetype = "dashed", linewidth=1) + geom_vline(aes(xintercept = delta_sweep_results$tipping_point, color="Tipping point"), linetype = "dashed", linewidth=1) + geom_ribbon(data = delta_sweep_results$table, aes(ymin = ci_low, ymax = ci_high, fill = "95% CI"), alpha = 0.4) + scale_color_manual(name = "", values = c("True TOTEXPY2 value" = "red", "Tipping point" = "green")) + scale_fill_manual(name = "", values = c("95% CI" = "skyblue")) + labs(title = "Figure 3: Delta-Adjusted Multiple Imputation Estimate vs Assumed MNAR Effect")

  return(plot)

}