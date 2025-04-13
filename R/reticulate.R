.lsl <- NULL
.lsld <- NULL
.lslb <- NULL
.tfd <- NULL
.tfb <- NULL


#' @importFrom reticulate import py_require

.onLoad <- function(libname, pkgname) {
  py_require("liesel>=0.2.4")

  .lsl <<- import("liesel.model", convert = FALSE, delay_load = TRUE)
  .lsld <<- import("liesel.distributions", convert = FALSE, delay_load = TRUE)
  .lslb <<- import("liesel.bijectors", convert = FALSE, delay_load = TRUE)

  .tfd <<- import("tensorflow_probability.substrates.jax.distributions",
                  convert = FALSE, delay_load = TRUE)

  .tfb <<- import("tensorflow_probability.substrates.jax.bijectors",
                  convert = FALSE, delay_load = TRUE)

  invisible(NULL)
}


#' Defunct Functions in Package **rliesel**
#'
#' The functions or variables listed here are no longer part of **rliesel** as
#' they are no longer needed.
#'
#' @usage
#' check_liesel_version()
#' use_liesel_venv()
#' @name rliesel-defunct

NULL


#' Check if the installed versions of RLiesel and Liesel are compatible
#'
#' This function is defunct. If an incompatible version of Liesel is found,
#' reticulate will install a compatible version automatically.
#' See `vignette("package", "reticulate")`.
#'
#' @export

check_liesel_version <- function() {
  .Defunct("reticulate::py_require", "rliesel")
}


#' Use a Liesel virtual environment
#'
#' This function is defunct. Please configure the Liesel virtual or
#' conda environment manually, e.g. using [reticulate::use_virtualenv()]
#' or [reticulate::use_condaenv()]. Alternatively, let reticulate manage
#' the environment automatically. See `vignette("package", "reticulate")`.
#'
#' @inheritParams reticulate::use_virtualenv
#' @inheritParams reticulate::virtualenv_create
#' @export

use_liesel_venv <- function(virtualenv = NULL, python = NULL, version = NULL) {
  .Defunct("reticulate::use_virtualenv", "rliesel")
}
