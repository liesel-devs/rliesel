LIESEL_REPO <- "github.com/liesel-devs/liesel.git"
LIESEL_REV <- "main"

.lsl <- NULL


#' @importFrom reticulate import

.onLoad <- function(libname, pkgname) {
  .lsl <<- import("liesel.liesel", convert = FALSE, delay_load = TRUE)
  invisible(NULL)
}

.onAttach <- function(libname, pkgname) {
  packageStartupMessage("Please set your Liesel venv, ",
                        "e.g. with use_liesel_venv()")

  invisible(NULL)
}


#' Use a Liesel virtual environment
#'
#' Use a Liesel virtual environment with `reticulate`. If the argument
#' `virtualenv` is not set, fall back to the environment variable `LIESELENV`.
#' If `LIESELENV` is not set either, fall back to a temporary Liesel virtual
#' environment.
#'
#' @inheritParams reticulate::use_virtualenv
#' @inheritParams reticulate::virtualenv_create
#'
#' @importFrom reticulate use_virtualenv
#' @export

use_liesel_venv <- function(virtualenv = NULL, python = NULL, version = NULL) {
  if (is.null(virtualenv)) {
    virtualenv <- Sys.getenv("LIESELENV")
  }

  if (virtualenv == "") {
    message("Creating a temporary Liesel venv. Set $LIESELENV to avoid this")
    virtualenv <- use_tmp_liesel_venv(python, version)
  }

  use_virtualenv(virtualenv, required = TRUE)

  virtualenv
}


#' Create and use a temporary Liesel virtual environment
#'
#' Create a temporary Python virtual environment, install Liesel in it,
#' and use it with `reticulate`.
#'
#' @inheritParams reticulate::virtualenv_create
#'
#' @importFrom reticulate use_virtualenv virtualenv_create virtualenv_install
#' @export

use_tmp_liesel_venv <- function(python = NULL, version = NULL) {
  virtualenv <- tempdir()

  virtualenv_create(virtualenv, python = python, version = version,
                    system_site_packages = FALSE)

  package <- paste0("git+https://", LIESEL_REPO, "@", LIESEL_REV)

  virtualenv_install(virtualenv, package, ignore_installed = TRUE)
  try(virtualenv_install(virtualenv, "pygraphviz", ignore_installed = TRUE))
  use_virtualenv(virtualenv, required = TRUE)

  virtualenv
}
