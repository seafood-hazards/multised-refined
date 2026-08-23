options(timeout = 600)

# ── Refined database ───────────────────────────────────────────────────────
# The refined SQLite database, served as a static file for the in-browser Tables
# viewer (loaded client-side via WebAssembly). Downloaded once from this repo's
# release; a local copy (e.g. from the pipeline output) is reused if present.
#
# Everything comes from the LATEST release, so no tag is edited here. That means
# EVERY release must carry all of these assets, or the next render 404s: use
# _scripts/publish-release.sh, which uploads them in one command. Set DB_RELEASE
# to pin an older release (e.g. DB_RELEASE=v0.1.0) when reproducing a build.
repo <- "seafood-hazards/multised-refined"
tag  <- Sys.getenv("DB_RELEASE", "latest")
db_release <- if (identical(tag, "latest")) {
  sprintf("https://github.com/%s/releases/latest/download", repo)
} else {
  sprintf("https://github.com/%s/releases/download/%s", repo, tag)
}
if (!file.exists("multised_refined.sqlite")) {
  download.file(file.path(db_release, "multised_refined.sqlite"),
                "multised_refined.sqlite", mode = "wb")
  message("multised_refined.sqlite downloaded.")
} else {
  message("Using existing multised_refined.sqlite")
}

# ── Downloadable flat dataset ──────────────────────────────────────────────
# The denormalised TSV served on the Dataset Download page (also read at render
# for the row count and preview). Same release, reused locally if present.
if (!file.exists("multised_refined_dataset.tsv.gz")) {
  download.file(file.path(db_release, "multised_refined_dataset.tsv.gz"),
                "multised_refined_dataset.tsv.gz", mode = "wb")
  message("multised_refined_dataset.tsv.gz downloaded.")
} else {
  message("Using existing multised_refined_dataset.tsv.gz")
}

# ── Analysis summary CSVs ──────────────────────────────────────────────────
# Tidy tables written by the processing pipeline (R/analysis/*/01_refined_*.R) and
# read at render time by the Analyses pages. Downloaded once from this repo's GitHub
# release; a local copy (e.g. copied from the pipeline output) is reused if present.
release <- db_release
csv_dir <- "data/refined_summary"
dir.create(csv_dir, recursive = TRUE, showWarnings = FALSE)

csvs <- c("refined_background_percentiles.csv",
          "refined_background_compare.csv",
          "refined_background_sitewise.csv",
          "refined_repeat_pressure.csv",
          "refined_background_meta.csv",
          "refined_gsnorm_percentiles.csv",
          "refined_gsnorm_compare.csv",
          "refined_gsnorm_meta.csv",
          "refined_pressure_percentiles.csv",
          "refined_pressure_compare.csv",
          "refined_pressure_meta.csv",
          "refined_temporal_alignment.csv",
          "refined_pressure_controls.csv",
          "refined_matched_municipality.csv",
          "refined_control_covariates.csv",
          "refined_pressure_controls_meta.csv",
          "refined_ef_background.csv",
          "refined_ef_dist.csv",
          "refined_ef_pressure.csv",
          "refined_ef_source.csv",
          "refined_ef_region.csv",
          "refined_ef_basis.csv",
          "refined_ef_basis_refs.csv",
          "refined_censoring.csv",
          "refined_method_changes.csv",
          "refined_method_changes_meta.csv",
          "refined_pristine_validation_source.csv",
          "refined_ef_meta.csv",
          "refined_mixture_components.csv",
          "refined_mixture_hist.csv",
          "refined_mixture_meta.csv",
          "refined_pristine_summary.csv",
          "refined_pristine_coverage.csv",
          "refined_pristine_validation.csv",
          "refined_pristine_meta.csv",
          "refined_dataset_dictionary.csv")

for (f in csvs) {
  dest <- file.path(csv_dir, f)
  if (!file.exists(dest)) {
    download.file(file.path(release, f), dest, mode = "wb")
    message(f, " downloaded.")
  } else {
    message("Using existing ", dest)
  }
}
