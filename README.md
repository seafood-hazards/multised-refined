# multised (refined)

Source for the **multised (refined)** website: the **refined** marine-sediment
trace-element database (`multised_refined.sqlite`) and the analyses built on it. The
refined database is an analysis-ready version of the merged database, restructured and
slimmed with the reusable results of the earlier analyses baked in (the Fe / Al and
organic-carbon ratios, the grain-size fines, the aquaculture link and the
repeat-sampling grouping). It is purpose-built for identifying **pristine / background
sediments**. The Norwegian **aquaculture** reference is a table inside this database.

The four earlier generations (per-source **pilot** and **slim**, the per-source
**clean** databases, the single **merged** database) and how the refined database is
**built** from the merged one are documented on the sibling
[merged site](https://github.com/seafood-hazards/multised-merged).

The site is a [Quarto](https://quarto.org) website published to GitHub Pages on every
push to `main`. The current pages (Home, DB Design) are static schema pages; the
pristine / background analyses will be added as they are built.

Published site: <https://seafood-hazards.github.io/multised-refined/>

## Reproducing the site locally

### Prerequisites

- [R](https://www.r-project.org/) 4.1 or newer
- [Quarto](https://quarto.org/docs/get-started/) 1.4 or newer
- The R packages the static DB Design (schema) pages need:

  ```r
  install.packages(c("rmarkdown", "knitr", "tibble"))
  ```

### Render

```sh
quarto render
```

The output is written to `_site/`.
