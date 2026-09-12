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