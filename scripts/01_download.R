hc_217_url <- "https://meps.ahrq.gov/mepsweb/data_files/pufs/h217/h217dta.zip"
temp_zip <- tempfile(fileext = ".zip")
dir.create("data/raw", recursive=TRUE, showWarnings=FALSE)
download.file(hc_217_url, destfile = temp_zip, mode="wb")
unzip(temp_zip, files = "h217.dta", exdir = "data/raw")
unlink(temp_zip)