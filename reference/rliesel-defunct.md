# Defunct Functions in Package **rliesel**

The functions or variables listed here are no longer part of **rliesel**
as they are no longer needed.

## Usage

``` r
check_liesel_version()
use_liesel_venv(...)
```

## Arguments

- ...:

  Defunct.

## Details

Starting from version 1.41, reticulate can manage Python environments
and dependencies automatically. If reticulate finds no installed version
of Liesel or an incompatible one, it will install a compatible version
automatically. Users who wish to manage their Python environment
manually, please use
[`reticulate::use_virtualenv()`](https://rstudio.github.io/reticulate/reference/use_python.html)
or
[`reticulate::use_condaenv()`](https://rstudio.github.io/reticulate/reference/use_python.html).
See also
[`vignette("package", "reticulate")`](https://rstudio.github.io/reticulate/articles/package.html).
