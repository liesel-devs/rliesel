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
#' Starting from version 1.41, [reticulate] can manage Python environments
#' and dependencies automatically. If reticulate finds no installed version
#' of Liesel or an incompatible one, it will install a compatible version
#' automatically. Users who wish to manage their Python environment manually,
#' please use [reticulate::use_virtualenv()] or [reticulate::use_condaenv()].
#' See also `vignette("package", "reticulate")`.
#'
#' @usage
#' check_liesel_version()
#' use_liesel_venv(...)
#' @param ... Defunct.
#' @name rliesel-defunct
#' @aliases check_liesel_version use_liesel_venv

NULL


#' @export

check_liesel_version <- function() {
  .Defunct("reticulate::py_require", "rliesel")
}


#' @export

use_liesel_venv <- function(...) {
  .Defunct("reticulate::use_virtualenv", "rliesel")
}
