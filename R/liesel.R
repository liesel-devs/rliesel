fill_mb <- function(mb, response, predictors, data, knots,
                    diagonalize_penalties) {
  for (name in names(predictors)) {
    inverse_link <- predictors[[name]]$inverse_link
    mb$add_predictor(name, get_bijector(inverse_link))

    formula <- predictors[[name]]$formula
    gam <- set_up_gam(response, formula, data, knots)

    p_smooth_name <- predictors[[name]]$p_smooth_name
    p_smooth <- get_p_smooth(gam, name, p_smooth_name)
    do.call(mb$add_p_smooth, p_smooth)

    np_smooths <- get_np_smooths(gam, name, diagonalize_penalties)

    for (np_smooth in np_smooths) {
      not_fixed <- "K" %in% names(np_smooth)
      fn <- if (not_fixed) mb$add_np_smooth else mb$add_p_smooth
      do.call(fn, np_smooth)
    }
  }
}


#' Set up a Liesel regression predictor specification
#'
#' Helper function to set up a Liesel regression predictor specification.
#'
#' @param formula A one-sided formula.
#' @param inverse_link A string identifying a
#'                     [TensorFlow bijector](https://www.tensorflow.org/probability/api_docs/python/tfp/bijectors)
#'                     to be used as the inverse link.
#' @param p_smooth_name The name of the parametric smooth. If `NULL`,
#'                      the name is set automatically.
#'
#' @export

predictor <- function(formula = ~1, inverse_link = "Identity",
                      p_smooth_name = NULL) {
  list(formula = formula, inverse_link = inverse_link,
       p_smooth_name = p_smooth_name)
}


#' Set up a Liesel distributional regression model
#'
#' Set up a probabilistic graphical model (PGM) representation of a
#' distributional regression model (also known as generalized additive model
#' for location, scale, and shape (GAMLSS)) with Liesel.
#'
#' @usage
#'
#' liesel(
#'   response,
#'   distribution = "Normal",
#'   predictors = list(
#'     loc = predictor(~1, inverse_link = "Identity"),
#'     scale = predictor(~1, inverse_link = "Exp")
#'   ),
#'   data = NULL,
#'   knots = NULL,
#'   diagonalize_penalties = TRUE,
#'   builder = FALSE
#' )
#'
#' @param response The response vector (or matrix).
#' @param distribution A string identifying a
#'                     [TensorFlow distribution](https://www.tensorflow.org/probability/api_docs/python/tfp/distributions)
#'                     to be used as the response distribution.
#' @param predictors A list of [`predictor()`] specifications. The names of
#'                   the list must match the names of the parameters of the
#'                   TensorFlow distribution.
#' @param data A data frame or list containing the data for the model.
#'             By default, the data is extracted from the environment of
#'             the formulas.
#' @param knots A list containing the knots per term.
#'              Passed on to [`mgcv::gam()`].
#' @param diagonalize_penalties Whether to diagonalize the smooth penalties.
#' @param builder Whether to return the model builder or the model.
#'
#' @export

liesel <- function(response,
                   distribution = "Normal",
                   predictors = list(
                     loc = predictor(~1, inverse_link = "Identity"),
                     scale = predictor(~1, inverse_link = "Exp")
                   ),
                   data = NULL,
                   knots = NULL,
                   diagonalize_penalties = TRUE,
                   builder = FALSE) {
  check_liesel_version()
  response <- substitute(response)
  response <- eval(response, data, parent.frame())

  mb <- .lsl$DistRegBuilder()
  mb$add_response(np_array(response), get_distribution(distribution))
  fill_mb(mb, response, predictors, data, knots, diagonalize_penalties)
  if (builder) mb else mb$build_model()
}
