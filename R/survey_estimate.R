library(survey)
library(mice)
library(mitools)


weighted_est_complete_case <- function(real_data){
  complete_case_design <- svydesign(
    id = ~VARPSU,
    strata = ~VARSTR,
    weights = ~LONGWT,
    data = real_data,
    nest = TRUE
  )
  filtered_complete_case_design <- subset(complete_case_design, !is.na(TOTEXPY1) & !is.na(TOTEXPY2))
  weighted_complete_case_mean <- svymean(~TOTEXPY2, design = filtered_complete_case_design)
  se <- SE(weighted_complete_case_mean)
  ci_low <- confint(weighted_complete_case_mean, level=0.95)[1]
  ci_high <- confint(weighted_complete_case_mean, level=0.95)[2]
  return(tibble(estimate = weighted_complete_case_mean, se = se, ci_low = ci_low, ci_high = ci_high))
}

weighted_est_mi <- function(real_data){
  imputed_data <- mice(real_data, m = 20, method = "pmm", printFlag = FALSE, seed = 42)
  complete_data <- complete(imputed_data, action = "all")
  weighted_mi_means = list()
  for (i in seq_along(complete_data)){
    dataset <- complete_data[[i]]
    mi_design <- svydesign(
      id = ~VARPSU,
      strata = ~VARSTR,
      weights = ~LONGWT,
      data = dataset,
      nest = TRUE
    )
    weighted_mi_means[[i]] <- svymean(~TOTEXPY2, design = mi_design)
  }
  pooled_summary <- summary(MIcombine(weighted_mi_means)) %>%
  select(estimate = results, se = se, ci_low = `(lower`, ci_high = `upper)`)
  return(as_tibble(pooled_summary))
}