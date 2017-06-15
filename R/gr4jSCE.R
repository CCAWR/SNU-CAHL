#' Runs SCE Calibration
#'
#' @param inputdata Input data for GR4J model (requires Data$Q, Data$P, and Data$E)
#' @param seed Random number for sampling within SCE
#' @param x1 X1 range
#' @param x2 X2 range
#' @param x3 X3 range
#' @param x4 X4 range
#' @param transformed Transformed parameters before use to improve identifiability
#' @param warmup Number of Days to Warmup for GR4J
#' @param ncomplex Number of Complexes for SCE
#' @export
#'

gr4jSCE <- function(inputdata, seed, x1 = log(c(1, 5000)), x2 = asinh(c(-10, 5)), x3 = log(c(1, 500)), x4 = log(c(0.5, 4) - 0.5), transformed = FALSE, warmup = 365, ncomplex = 20) {

  # Preparing Hydromad Framework
  runmodel <- hydromad(inputdata, sma = "gr4j", routing = "gr4jrouting", trasnformed = transformed)

  hydromad.options(warmup = warmup)
  hydromad.options(objective = ~hmadstat("r.squared")(Q, X))
  hydromad.options(polish = FALSE)
  hydromad.options(trace = TRUE)
  hydromad.options(normalise = FALSE)
  hydromad.options(gr4j = list(x1 = x1, etmult = 1))
  hydromad.options(gr4jrouting = list(x2 = x2, x3 = x3, x4 = x4))

  set.seed(seed)

  # Run SCE
  hydromodel <- fitBySCE(runmodel, control = list(ncomplex = ncomplex))

  # Preparing Output
  parameterlist <- hydromodel$parlist

  Qmod <- fitted(hydromodel)
  Qobs <- observed(hydromodel)

  nse <- NSE(Qmod, Qobs)

  output <- data.frame(parameterlist, nse)

  return(output)
}
