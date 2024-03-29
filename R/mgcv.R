#' @importFrom mgcv gam
#' @importFrom stats update

set_up_gam <- function(response, formula, data, knots) {
  dim <- response_dim(response)
  new <- paste0("rep(0, ", dim, ") ~ .")
  formula <- update(formula, new)

  gam(formula, data = data, knots = knots, fit = FALSE)
}


get_p_smooth <- function(gam, predictor, name) {
  X <- gam$X[, seq(1, gam$nsdf), drop = FALSE]

  list(
    X = np_array(X),
    m = np_array(0),
    s = np_array(100),
    predictor = predictor,
    name = name
  )
}


#' @importFrom mgcv smooth2random

get_np_smooths <- function(gam, predictor, diagonalize_penalties) {
  lapply(gam$smooth, function(smooth) {
    X <- gam$X[, seq(smooth$first.par, smooth$last.par), drop = FALSE]

    if (smooth$fixed) {
      return(
        list(
          X = np_array(X),
          m = np_array(0),
          s = np_array(100),
          predictor = predictor,
          name = smooth$xt$name
        )
      )
    }

    if (diagonalize_penalties) {
      smooth$X <- X
      random <- smooth2random(smooth, vnames = "", type = 2)
      X <- cbind(random$rand$Xr, random$Xf)
      K <- diag(random$pen.ind)
    } else {
      K <- smooth$S[[1]]
    }

    list(
      X = np_array(X),
      K = np_array(K),
      a = np_array(0.01),
      b = np_array(0.01),
      predictor = predictor,
      name = smooth$xt$name
    )
  })
}
