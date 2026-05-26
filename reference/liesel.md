# Set up a Liesel distributional regression model

Set up a probabilistic graphical model (PGM) representation of a
distributional regression model (also known as generalized additive
model for location, scale, and shape (GAMLSS)) with Liesel.

## Usage

``` r
liesel(
  response,
  distribution = "Normal",
  predictors = list(
    loc = predictor(~1, inverse_link = "Identity"),
    scale = predictor(~1, inverse_link = "Exp")
  ),
  data = NULL,
  knots = NULL,
  diagonalize_penalties = TRUE,
  builder = FALSE
)
```

## Arguments

- response:

  The response vector (or matrix).

- distribution:

  A string identifying a [TensorFlow
  distribution](https://www.tensorflow.org/probability/api_docs/python/tfp/distributions)
  to be used as the response distribution.

- predictors:

  A list of
  [`predictor()`](https://liesel-devs.github.io/rliesel/reference/predictor.md)
  specifications. The names of the list must match the names of the
  parameters of the TensorFlow distribution.

- data:

  A data frame or list containing the data for the model. By default,
  the data is extracted from the environment of the formulas.

- knots:

  A list containing the knots per term. Passed on to
  [`mgcv::gam()`](https://rdrr.io/pkg/mgcv/man/gam.html).

- diagonalize_penalties:

  Whether to diagonalize the smooth penalties.

- builder:

  Whether to return the model builder or the model.
