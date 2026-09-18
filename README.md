# MEPS Missing-Data Simulation Study

Does the choice of missing-data method change a national estimate of healthcare expenditure, and does it matter more under ignorable missing data (MAR) than non-ignorable missing data (MNAR)?

**Answer:** Yes, and yes. In simulation, method choice barely matters when data are missing completely at random (MCAR), matters a lot under MAR (complete-case analysis is badly biased with 0% confidence-interval coverage, while multiple imputation is closer to the truth), and matters under MNAR too, though no method tested is trustworthy there. On the real MEPS panel, switching from complete-case to multiple imputation changes the national expenditure estimate by about $77 per person (~$25.6 billion nationally), even though real attrition in this panel is modest.

Full write-up: [`report/report.pdf`](report/report.pdf)

## How the project works

1. Download the MEPS longitudinal panel file (HC-217, Panel 23) and reduce it to 9 variables: 8 covariates plus year-1 and year-2 total expenditure.
2. Build a "truth set" of respondents with complete data, and treat their known year-2 expenditure as ground truth.
3. Artificially delete year-2 expenditure under three mechanisms (MCAR, MAR, MNAR) and apply four methods to handle the missing data: complete-case analysis, mean imputation, multiple imputation (predictive mean matching), and delta-adjusted multiple imputation.
4. Repeat 500 times per mechanism and measure each method's bias, variability, and confidence-interval coverage against the known truth.
5. Run a sensitivity analysis (the delta sweep) to find how large a hidden MNAR effect would need to be before method choice visibly changes the answer.
6. Separately, estimate the real national expenditure figure from the actual MEPS data using survey weights, for a real-data point of comparison.

## Repo map

| Folder | Contents |
|---|---|
| `scripts/` | Numbered, run-in-order scripts (`01`–`07`) that produce the data and results; `run_all.R` runs all of them plus the report |
| `R/` | Functions used by the scripts (data prep, amputation, estimators, evaluation, figures) |
| `data/` | Raw and processed data (not tracked in git — recreated by the scripts) |
| `results/` | Saved `.rds` results used by the report (not tracked in git — recreated by the scripts) |
| `report/` | `report.qmd` (source) and `report.pdf` (rendered output) |

## How to reproduce

Requires [R](https://www.r-project.org/), [Quarto](https://quarto.org), and internet access (to download the MEPS file).

1. Clone this repo and open it in RStudio or VS Code.
2. Install the exact package versions used in this project:
   ```
   renv::restore()
   ```
3. From the project root, run everything — download, simulation, and report — with one command:
   ```
   Rscript scripts/run_all.R
   ```
   Or run the numbered scripts in `scripts/` individually, in order, if you want to inspect intermediate output.
4. The rendered report will be at `report/report.pdf`.

**Runtime:** a few minutes end to end — the 500-replicate simulation is the slowest step, but each replicate is small.

## Project status

Complete. Simulation (500 replicates × 3 mechanisms × 4 methods) with Monte Carlo standard errors, a delta-adjusted sensitivity analysis with a tipping point, three result figures, a real-data survey-weighted comparison, and a full written report.

### Data notes

Using MEPS HC-217 (Panel 23, 2018–2019) rather than a later panel, to study ordinary attrition without the 2020 pandemic-era collection changes muddying the picture.

Missing/non-response codes by variable:

Demographic:
- Age: `AGEY1X` (-1 Inapplicable)
- Sex: `SEX` (none)
- Region: `REGIONY1` (-1 Inapplicable)

Socioeconomic:
- Income category: `POVCATY1` (-1 Inapplicable)
- Insurance status: `INSCOVY1` (-1 Inapplicable)

Health:
- Self-rated health: `RTHLTH1` (-8 DK, -7 Refused, -1 Inapplicable)
- Diabetes: `DIABDXY1_M18` (-8 DK, -7 Refused, -1 Inapplicable)

Outcome (year 1) — predictor:
- Total annual expenditure, year 1: `TOTEXPY1` (-1 Inapplicable)

Outcome (year 2) — estimand target:
- Total annual expenditure, year 2: `TOTEXPY2` (-1 Inapplicable)
