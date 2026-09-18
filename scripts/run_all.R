# Runs the full pipeline: download MEPS data, build the analysis frame,
# run the simulation, build results, and render the report.
# Usage: Rscript scripts/run_all.R   (run from the project root)

message("Step 1/8: Downloading MEPS data...")
source("scripts/01_download.R")

message("Step 2/8: Building analysis frame...")
source("scripts/02_build_frame.R")

message("Step 3/8: Checking amputation mechanisms...")
source("scripts/03_check_amputation.R")

message("Step 4/8: Running simulation (500 replicates x 3 mechanisms x 4 methods)...")
source("scripts/04_run_study.R")

message("Step 5/8: Building ADEMP performance table...")
source("scripts/05_build_evaluate_table.R")

message("Step 6/8: Running delta sweep and finding tipping point...")
source("scripts/06_delta_sweep.R")

message("Step 7/8: Computing survey-weighted estimates...")
source("scripts/07_survey_estimate.R")

message("Step 8/8: Rendering report...")
render_status <- system2("quarto", c("render", "report/report.qmd"))
if (render_status != 0) stop("quarto render failed")

message("Done. Report is at report/report.pdf")
