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

# The list of CSVs is NOT kept here. _scripts/release-assets.txt is the single
# source of truth for what every release must carry, and publish-release.sh reads
# the same file, so the uploader and the downloader cannot drift apart. They did
# once: two new Igeo tables were added to the manifest and uploaded, and this
# script still held its own hand-maintained copy of the list, so the render 404'd
# on a file that was sitting on the release (2026-08-26).
manifest <- "_scripts/release-assets.txt"
if (!file.exists(manifest)) {
  stop("missing ", manifest, ": run the pre-render from the repository root")
}
csvs <- readLines(manifest)
csvs <- trimws(csvs)
csvs <- csvs[nzchar(csvs) & !startsWith(csvs, "#")]
csvs <- csvs[endsWith(csvs, ".csv")]
if (!length(csvs)) stop("no CSV assets listed in ", manifest)

for (f in csvs) {
  dest <- file.path(csv_dir, f)
  if (!file.exists(dest)) {
    download.file(file.path(release, f), dest, mode = "wb")
    message(f, " downloaded.")
  } else {
    message("Using existing ", dest)
  }
}
