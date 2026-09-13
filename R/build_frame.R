library(haven)
library(dplyr)

build_analysis_frame <- function (datafile_path){
  raw_panel_data <- read_dta(datafile_path)
  observed_variables <- c("AGEY1X", "SEX", "REGIONY1", "POVCATY1", "INSCOVY1", "RTHLTH1", "DIABDXY1_M18", "TOTEXPY1", "TOTEXPY2", "LONGWT", "VARPSU", "VARSTR")
  reformatted_panel_data <- raw_panel_data %>%
  select(all_of(observed_variables)) %>%
  mutate(across(all_of(observed_variables), ~ na_if(na_if(na_if(na_if(.x, -1), -7), -8), -9)))

  return(reformatted_panel_data)
}