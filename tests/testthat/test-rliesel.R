library(mgcv)
library(reticulate)
set.seed(1337)

n <- 10
x <- runif(n)
y <- rnorm(n, mean = x, sd = exp(x))
data <- data.frame(x = x, y = y)
use_tmp_liesel_venv()

# initialize python. without this line, r crashes on my system
py_config()


# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Test mgcv.R ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

gam <- set_up_gam(y, ~s(x), data, knots = NULL)

test_that("set_up_gam() works", {
  expect_s3_class(gam, "gam.prefit")

  expect_identical(gam$formula, rep(0, 10) ~ s(x), ignore_formula_env = TRUE)
})

p_smooth <- get_p_smooth(gam, "loc", NULL)

test_that("get_p_smooth() works", {
  expect_type(p_smooth, "list")

  expect_s3_class(p_smooth$X, "numpy.ndarray")
  expect_s3_class(p_smooth$m, "numpy.ndarray")
  expect_s3_class(p_smooth$s, "numpy.ndarray")
  expect_type(p_smooth$predictor, "character")
  expect_null(p_smooth$name)

  expect_equal(py_to_r(p_smooth$X), matrix(1, nrow = n))
  expect_equal(py_to_r(p_smooth$m), 0, ignore_attr = "dim")
  expect_equal(py_to_r(p_smooth$s), 100, ignore_attr = "dim")
})

np_smooths <- get_np_smooths(gam, "loc", TRUE)
np_smooth <- np_smooths[[1]]

test_that("get_np_smooths() works", {
  expect_type(np_smooths, "list")
  expect_type(np_smooth, "list")

  expect_s3_class(np_smooth$X, "numpy.ndarray")
  expect_s3_class(np_smooth$K, "numpy.ndarray")
  expect_s3_class(np_smooth$a, "numpy.ndarray")
  expect_s3_class(np_smooth$b, "numpy.ndarray")
  expect_type(np_smooth$predictor, "character")
  expect_null(np_smooth$name)

  p <- ncol(py_to_r(np_smooth$X))
  expect_equal(dim(py_to_r(np_smooth$X)), c(n, p))
  expect_equal(dim(py_to_r(np_smooth$K)), c(p, p))

  expect_equal(py_to_r(np_smooth$a), 0.01,
               tolerance = 2 * testthat_tolerance(),
               ignore_attr = "dim")

  expect_equal(py_to_r(np_smooth$b), 0.01,
               tolerance = 2 * testthat_tolerance(),
               ignore_attr = "dim")
})


# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Test liesel.R ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

pdt_default <- predictor()
pdt_loc <- predictor(~x)

pdt_scale <- predictor(~s(x), "Exp", "my_smooth")

test_that("predictor() works", {
  expect_type(pdt_default, "list")
  expect_identical(pdt_default$formula, ~1, ignore_formula_env = TRUE)
  expect_identical(pdt_default$inverse_link, "Identity")
  expect_null(pdt_default$p_smooth_name)

  expect_type(pdt_loc, "list")
  expect_identical(pdt_loc$formula, ~x, ignore_formula_env = TRUE)
  expect_identical(pdt_loc$inverse_link, "Identity")
  expect_null(pdt_loc$p_smooth_name)

  expect_type(pdt_scale, "list")
  expect_identical(pdt_scale$formula, ~s(x), ignore_formula_env = TRUE)
  expect_identical(pdt_scale$inverse_link, "Exp")
  expect_identical(pdt_scale$p_smooth_name, "my_smooth")
})

m <- liesel(y, "Normal", list(loc = pdt_loc, scale = pdt_scale), data)
mb <- liesel(y, "Normal", list(loc = pdt_loc, scale = pdt_scale), data,
             builder = TRUE)

test_that("liesel() works", {
  expect_s3_class(mb, "liesel.model.distreg.DistRegBuilder")
  expect_s3_class(m, "liesel.model.model.Model")

  vars <- py_eval("dict(r.m.vars)")
  expect_equal(vars$response$value, y)

  expect_s3_class(
    vars$response$dist_node$init_dist(),
    "tensorflow_probability.substrates.jax.distributions.normal.Normal"
  )

  expected_var_names <- c(
    "loc",
    "loc_p0",
    "loc_p0_X",
    "loc_p0_beta",
    "loc_p0_m",
    "loc_p0_s",
    "loc_pdt",
    "my_smooth",
    "my_smooth_X",
    "my_smooth_beta",
    "my_smooth_m",
    "my_smooth_s",
    "response",
    "scale",
    "scale_np0",
    "scale_np0_K",
    "scale_np0_X",
    "scale_np0_a",
    "scale_np0_b",
    "scale_np0_beta",
    "scale_np0_rank",
    "scale_np0_tau2",
    "scale_pdt"
  )

  expect_setequal(names(vars), expected_var_names)
})
