#Original Claim: MI-PMM mechanism gives trustworthy answer, complete-case does not, once dropout is not random i.e. MNAR. The evaluate table mirrors this - complete-case is more biased under MAR/MNAR and MI-PMM does better under MAR but MI=PMM is still biased under MNAR.
#Delta sweeping is saying how much should I rely on the "dropouts are different". More delta means I know dropout people spent more/less than similar people who stayed.
#Need to confirm the claim about MI estimate
#We define the original claim as flipped is delta-adjusted MI estimate's 95% CI no longer overlaps the complete-case estimate's 95%. This would mean that the two methods cliearly point to differnet numbers and on emethod says expenditure is meaningfully higher/;ower than the other says. This addresses original study question of "does method choise matter more under MNAR?", and if the claim is flipped, then the method choice starts the matter once hidden MNAR efect is at least delta big.
#After results: "The two methods' confidence intervals stop overlapping once delta reaches approximately $X, meaning dropouts would need to have spent about $X more than similar-looking respondents who stayed before the choice of method visibly changes the reported estimate. [Given typical income/health spending gaps in this population, that magnitude is plausible / is unrealistically large], so the conclusion is [fragile / robust]."
source("R/estimators.R")
library(dplyr)
delta_sweep <- function(truth_set, seed){
  set.seed(seed)
  amputated_data <- amputate_data(truth_set, "MNAR")
  imputed_data <- mice(amputated_data, m = 20, method = "pmm", printFlag = FALSE)
  test_delta_values <- c(0, 500, 1000, 2000, 3000, 5000, 7500, 10000)
  mi_delta_results <- list()
  complete_case_CI <- est_complete_case(amputated_data) %>% { c(.$ci_low, .$ci_high) }
  for (d in test_delta_values){
    est_delta <- est_mi_delta(imputed_data, d)
    new_row <- data.frame(delta = d, estimate = est_delta$estimate, ci_low = est_delta$ci_low, ci_high = est_delta$ci_high)
    mi_delta_results <- append(mi_delta_results, list(new_row))
  }
  combined <- bind_rows(mi_delta_results)
  tipping_point_i <- which(combined$ci_high < complete_case_CI[1] | combined$ci_low > complete_case_CI[2])
  tipping_delta <- if(length(tipping_point_i) > 0) combined$delta[tipping_point_i[1]] else NA

  return(list(table = combined, tipping_point = tipping_delta))
}