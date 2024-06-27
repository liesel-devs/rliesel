#' @importFrom reticulate np_array

np_array <- function(data, dtype = "float32", order = "C") {
  reticulate::np_array(data, dtype = dtype, order = order)
}

response_dim <- function(response) {
  if (is.null(dim(response))) length(response) else dim(response)[1]
}


#' Save a Liesel model to a pickle file
#'
#' @param model The model to save.
#' @param path The file path to save the model to.
#'
#' @export

save_model <- function(model, path) {
  .lsl$save_model(model, path)
  invisible(NULL)
}


#' Load a Liesel model from a pickle file
#'
#' @param path The file path to load the model from.
#'
#' @export

load_model <- function(path) {
  .lsl$load_model(path)
}


#' Plot the graph of a Liesel model
#'
#' @param x The model to plot.
#' @param nodes Whether to plot the computational nodes instead of the
#'              statistical variables. Defaults to `FALSE`.
#' @param ... Passed on to the `plot_vars()` or `plot_nodes()` function
#'            in the `liesel.model.viz` module.
#'
#' @export

plot.liesel.model.model.Model <- function(x, nodes = FALSE, ...) {
  if (!nodes) .lsl$plot_vars(x, ...) else .lsl$plot_nodes(x, ...)
  invisible(NULL)
}


#' @importFrom reticulate py_get_attr py_has_attr

get_distribution <- function(x) {
  if (is.character(x) & py_has_attr(.lsld, x)) {
    return(py_get_attr(.lsld, x, silent = FALSE))
  }

  if (is.character(x)) {
    return(py_get_attr(.tfd, x, silent = FALSE))
  }

  x
}


#' @importFrom reticulate py_get_attr py_has_attr

get_bijector <- function(x) {
  if (is.character(x) & py_has_attr(.lslb, x)) {
    return(py_get_attr(.lslb, x, silent = FALSE))
  }

  if (is.character(x)) {
    return(py_get_attr(.tfb, x, silent = FALSE))
  }

  x
}
