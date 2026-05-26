# Set up a Liesel regression predictor specification

Helper function to set up a Liesel regression predictor specification.

## Usage

``` r
predictor(formula = ~1, inverse_link = "Identity", p_smooth_name = NULL)
```

## Arguments

- formula:

  A one-sided formula.

- inverse_link:

  A string identifying a [TensorFlow
  bijector](https://www.tensorflow.org/probability/api_docs/python/tfp/bijectors)
  to be used as the inverse link.

- p_smooth_name:

  The name of the parametric smooth. If `NULL`, the name is set
  automatically.
