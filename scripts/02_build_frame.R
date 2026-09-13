source("R/build_frame.R")

result <- build_analysis_frame(file.path("data", "raw", "h217.dta"))
saveRDS(result, file = file.path("data", "analysis_frame.rds"))

print(nrow(result))
print(colMeans(is.na(result)) * 100)
print(summary(result$TOTEXPY2))


