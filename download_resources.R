options(timeout = 600)

# ── Refined database ───────────────────────────────────────────────────────
# The refined SQLite database, served as a static file for the in-browser Tables
# viewer (loaded client-side via WebAssembly). Downloaded once from this repo's
# release; a local copy (e.g. from the pipeline output) is reused if present.
db_release <- "https://github.com/seafood-hazards/multised-refined/releases/download/v0.1.0"
if (!file.exists("multised_refined.sqlite")) {
  download.file(file.path(db_release, "multised_refined.sqlite"),
                "multised_refined.sqlite", mode = "wb")
  message("multised_refined.sqlite downloaded.")
} else {
  message("Using existing multised_refined.sqlite")
}

# ── Analysis summary CSVs ──────────────────────────────────────────────────
# Tidy tables written by the processing pipeline (R/analysis/*/01_refined_*.R) and
# read at render time by the Analyses pages. Downloaded once from this repo's GitHub
# release; a local copy (e.g. copied from the pipeline output) is reused if present.
release <- "https://github.com/seafood-hazards/multised-refined/releases/download/v0.1.0"
csv_dir <- "data/refined_summary"
dir.create(csv_dir, recursive = TRUE, showWarnings = FALSE)

csvs <- c("refined_background_percentiles.csv",
          "refined_background_compare.csv",
          "refined_background_meta.csv",
          "refined_gsnorm_percentiles.csv",
          "refined_gsnorm_compare.csv",
          "refined_gsnorm_meta.csv",
          "refined_pressure_percentiles.csv",
          "refined_pressure_compare.csv",
          "refined_pressure_meta.csv",
          "refined_ef_background.csv",
          "refined_ef_dist.csv",
          "refined_ef_pressure.csv",
          "refined_ef_meta.csv")

for (f in csvs) {
  dest <- file.path(csv_dir, f)
  if (!file.exists(dest)) {
    download.file(file.path(release, f), dest, mode = "wb")
    message(f, " downloaded.")
  } else {
    message("Using existing ", dest)
  }
}
