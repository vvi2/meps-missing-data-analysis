library(tibble)
library(tidyr)
library(mice)
library(dplyr)
#Delete anyone missing
est_complete_case <- function(amputated_data){
  complete_case_data <- amputated_data %>% drop_na(TOTEXPY2)
  estimate <- mean(complete_case_data$TOTEXPY2)
  #standard error measures how much estimate of observed variable totexpy2 would wobble from sample to sample
  se <- sd(complete_case_data$TOTEXPY2) / sqrt(length(complete_case_data$TOTEXPY2))
  ci_low <- estimate - (1.96 * se)
  ci_high <- estimate + (1.96 * se)
  return(tibble(estimate = estimate, se = se, ci_low = ci_low, ci_high = ci_high))
}

#Fill in with average observed totexpy2 value
est_mean_imputation <- function(amputated_data){
  observed_mean <- mean(amputated_data$TOTEXPY2, na.rm = TRUE)
  amputated_data$TOTEXPY2[is.na(amputated_data$TOTEXPY2)] <- observed_mean
  estimate <- mean(amputated_data$TOTEXPY2)
  se <- sd(amputated_data$TOTEXPY2) / sqrt(length(amputated_data$TOTEXPY2))
  ci_low <- estimate - (1.96 * se)
  ci_high <- estimate + (1.96 * se)
  return(tibble(estimate = estimate, se = se, ci_low = ci_low, ci_high = ci_high))
}

#Fill in guesses for observed totexpy2 value multiple times and average them
est_mi_pmm <- function(imputed_data){
  fit_lin_reg_model <- with(imputed_data, lm(TOTEXPY2 ~ 1))
  pooled_summary <- summary(pool(fit_lin_reg_model), conf.int = TRUE) %>%
  select(estimate, se = std.error, ci_low = `2.5 %`, ci_high = `97.5 %`)
  return(as_tibble(pooled_summary))
}

#idk yet
est_mi_delta <- function(imputed_data, delta){
  imputed_data$imp$TOTEXPY2 <- imputed_data$imp$TOTEXPY2 + delta
  fit_lin_reg_model <- with(imputed_data, lm(TOTEXPY2 ~ 1))
  pooled_summary <- summary(pool(fit_lin_reg_model), conf.int = TRUE) %>%
  select(estimate, se = std.error, ci_low = `2.5 %`, ci_high = `97.5 %`)
  return(as_tibble(pooled_summary))
}