MIN_LIESEL_VER <- "0.2.4"

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
    'See `vignette("versions", "reticulate")`.\n\n',
    'After setting the environment, check if the installed versions of RLiesel and Liesel ',
    'are compatible with `check_liesel_version()`.'
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
#' @param ... Passed on to [reticulate::virtualenv_create()].
#'
#' @importFrom reticulate use_virtualenv virtualenv_create virtualenv_install
#' @keywords internal

use_tmp_liesel_venv <- function(...) {
  path <- tempdir()

  virtualenv_create(path, packages = NULL, ...)
  virtualenv_install(path, "liesel", ignore_installed = TRUE)
  try(virtualenv_install(path, "pygraphviz", ignore_installed = TRUE))
  use_virtualenv(path, required = TRUE)

  path
}


#' Check if the installed versions of RLiesel and Liesel are compatible
#'
#' Note that this function needs to be called after setting the virtual or
#' conda environment, e.g. using [reticulate::use_virtualenv()] or
#' [reticulate::use_condaenv()].
#'
#' @importFrom reticulate import py_to_r
#' @importFrom utils compareVersion
#' @export

check_liesel_version <- function() {
  liesel <- import("liesel", convert = FALSE)
  packaging <- import("packaging", convert = FALSE)
  installed <- packaging$version$parse(liesel["__version__"])
  required <- packaging$version$parse(MIN_LIESEL_VER)

  if (py_to_r(installed < required)) {
    stop("Installed Liesel version ", liesel["__version__"],
         " is incompatible, need at least version ", MIN_LIESEL_VER)
  } else {
    message("Installed Liesel version ", liesel["__version__"],
            " is compatible, continuing to set up model")
  }

  invisible(NULL)
}
