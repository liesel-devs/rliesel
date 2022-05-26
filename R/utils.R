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
#' @param ... Passed on to the `plot_model()` function
#'            in the `liesel.liesel.viz` module.
#'
#' @export

plot.liesel.liesel.model.Model <- function(x, ...) {
  .lsl$plot_model(x, ...)
  invisible(NULL)
}
