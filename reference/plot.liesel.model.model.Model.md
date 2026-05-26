# Plot the graph of a Liesel model

Plot the graph of a Liesel model

## Usage

``` r
# S3 method for class 'liesel.model.model.Model'
plot(x, nodes = FALSE, ...)
```

## Arguments

- x:

  The model to plot.

- nodes:

  Whether to plot the computational nodes instead of the statistical
  variables. Defaults to `FALSE`.

- ...:

  Passed on to the `plot_vars()` or `plot_nodes()` function in the
  `liesel.model.viz` module.
