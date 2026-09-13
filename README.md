# MEPS Missing-Data Simulation Study

Does the choice of missing-data method change a national estimate of healthcare expenditure, and does it matter more under ignorable missing data (MAR) than non-ignorable (MNAR) missing data?

This project uses data from the Medical Expenditure Panel Survey (MEPS) to build a "ground truth" for respondents, simulate 3 kinds of missing data schematics (MCAR, MAR, MNAR), and compare four handling methods: complete case analysis, mean imputation, multiple imputation, and delta-adjusted MI. I measure these methods against the known truth with 500 replicates per mechanism.

## How to run
1. Install R and Quarto (https://quarto.org)
2. Open this project in RStudio or VSCode and run `renv::restore()` to install the exact package version used in my build.
3. Run the scripts in `scripts/` in order: download, build frame, run simulation.
4. Render the report: `quarto render report/report.qmd.`

## Project Status
Work in progress!

Using MEPS HC-217 (Panel 23, 2018-2019), to study an ordinary dropout mechanism rather than a dataset that muddles the attrition with pandemic-attributed dropout. Cleaner, pre-pandemic, simpler story for my study.
Null Values for my Variables
Demographic:
- Age: AGEY1X (-1 Inapplicable)
- Sex: SEX (none)
- Region: REGIONY1 (-1 Inapplicable)
Socioeconomic:
- Income Category: POVCATY1 (-1 Inapplicable)
- Insurance Status: INSCOVY1 (-1 Inapplicable)
Health:
- Self-rated health: RTHLTH1 (-8 DK, -7 Refused, -1 Inapplicable)
- Diabetes: DIABDXY1_M18 (-8 DK, -7 Refused, -1 Inapplicable)
Outcome (Year 1) - Predictor:
- Total Annual Expenditure, Year 1: TOTEXPY1 (-1 Inapplicable)
Outcome (Year 2) - Estimand target:
- Total Annual Expenditure, Year 2: TOTEXPY2 (-1 Inapplicable)