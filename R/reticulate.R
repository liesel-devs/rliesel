LIESEL_REPO <- "github.com/liesel-devs/liesel.git"
LIESEL_REV <- "main"

.lsl <- NULL
.lsld <- NULL
.lslb <- NULL
.tfd <- NULL
.tfb <- NULL


#' @importFrom reticulate import

.onLoad <- function(libname, pkgname) {
  .lsl <<- import("liesel.model", convert = FALSE, delay_load = TRUE)
  .lsld <<- import("liesel.distributions", convert = FALSE, delay_load = TRUE)
  .lslb <<- import("liesel.bijectors", convert = FALSE, delay_load = TRUE)

  .tfd <<- import("tensorflow_probability.substrates.jax.distributions",
                  convert = FALSE, delay_load = TRUE)

  .tfb <<- import("tensorflow_probability.substrates.jax.bijectors",
                  convert = FALSE, delay_load = TRUE)

  invisible(NULL)
}

.onAttach <- function(libname, pkgname) {
  packageStartupMessage(
    'Please make sure you are using a virtual or conda environment with Liesel installed, ',
    'e.g. using `reticulate::use_virtualenv()` or `reticulate::use_condaenv()`. ',
    'See `vignette("versions", "reticulate")`.'
  )

  invisible(NULL)
}


#' Use a Liesel virtual environment
#'
#' This function is defunct. Please configure the Liesel virtual or
#' conda environment manually, e.g. using [reticulate::use_virtualenv()] or
#' [reticulate::use_condaenv()]. See `vignette("versions", "reticulate")`.
#'
#' @inheritParams reticulate::use_virtualenv
#' @inheritParams reticulate::virtualenv_create
#' @export

use_liesel_venv <- function(virtualenv = NULL, python = NULL, version = NULL) {
  .Defunct("reticulate::use_virtualenv", "rliesel")
}


#' Defunct Functions in Package **rliesel**
#'
#' The functions or variables listed here are no longer part of **rliesel** as
#' they are no longer needed.
#'
#' @usage
#' use_liesel_venv()
#' @name rliesel-defunct

NULL


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
