# install_packages.R

packages <- c(
  "shiny",
  "DBI",
  "RMySQL",
  "ggplot2",
  "dotenv",
  "reticulate",
  "gridExtra",
  "chess",
  "reshape2"
)

install_if_missing <- function(pkg) {
  if (!requireNamespace(pkg, quietly = TRUE)) {
    install.packages(pkg, dependencies = TRUE)
  }
}

invisible(lapply(packages, install_if_missing))
