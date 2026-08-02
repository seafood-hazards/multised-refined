options(timeout = 600)

# ── Analysis summary CSVs ──────────────────────────────────────────────────
# Tidy tables written by the processing pipeline (R/analysis/*/01_refined_*.R) and
# read at render time by the Analyses pages. Downloaded once from this repo's GitHub
# release; a local copy (e.g. copied from the pipeline output) is reused if present.
release <- "https://github.com/seafood-hazards/multised-refined/releases/download/v0.1.0"
csv_dir <- "data/refined_summary"
dir.create(csv_dir, recursive = TRUE, showWarnings = FALSE)

csvs <- c("refined_background_percentiles.csv",
          "refined_background_compare.csv",
          "refined_background_meta.csv")

for (f in csvs) {
  dest <- file.path(csv_dir, f)
  if (!file.exists(dest)) {
    download.file(file.path(release, f), dest, mode = "wb")
    message(f, " downloaded.")
  } else {
    message("Using existing ", dest)
  }
}
