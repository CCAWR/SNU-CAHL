#' Runs SCE Calibration for GR4J Model
#'
#' Outputs GR4J Parameters (non-transformed) and NSE value.
#'
#' @param inputdata Input data for GR4J model (requires Data$Q, Data$P, and Data$E) (mm/day)
#' @param seed Random number for sampling within SCE
#' @param x1 X1 range
#' @param x2 X2 range
#' @param x3 X3 range
#' @param x4 X4 range
#' @param warmup Number of Days to Warmup for GR4J
#' @param ncomplex Number of Complexes for SCE
#' @param maxit Maximum number of iterations
#' @param transformed GR4J Values already transformed for model performance
#' @export
#'

gr4jSCE <- function(inputdata, seed, x1 = c(1,5000), x2 = c(-10,10), x3 = c(1,1000), x4 = c(0.5,4), warmup = 365, ncomplex = 20, maxit = 200, transformed = TRUE) {

  # Preparing Hydromad Framework
  runmodel <- hydromad(as.zoo(inputdata), sma = "gr4j", routing = "gr4jrouting", transformed = transformed)
  runmodel <- update(runmodel,newpars = gr4j.transformpar(c(hydromad.getOption("gr4j"), hydromad.getOption("gr4jrouting"))))
  runmodel <- update(runmodel,etmult = 1)
  runmodel <- update(runmodel, x1 = gr4j.transformpar(list(x1 = x1))[["x1"]])
  runmodel <- update(runmodel, x2 = gr4j.transformpar(list(x2 = x2))[["x2"]])
  runmodel <- update(runmodel, x3 = gr4j.transformpar(list(x3 = x3))[["x3"]])
  runmodel <- update(runmodel, x4 = gr4j.transformpar(list(x4 = x4))[["x4"]])
  
  
  hydromad.options(warmup = warmup)
  hydromad.options(objective = ~hmadstat("r.squared")(Q, X))
  hydromad.options(polish = FALSE)
  hydromad.options(trace = TRUE)
  hydromad.options(normalise = FALSE)

  set.seed(seed)

  # Run SCE
  hydromodel <- fitBySCE(runmodel, control = list(trace = 1, maxit = maxit, ncomplex = ncomplex))

  # Preparing Output
  parameterlist <- coef(hydromodel)
  parameterlist <- gr4j.transformpar(parameterlist, back = T)

  Qmod <- fitted(hydromodel)
  Qobs <- observed(hydromodel)

  nse <- NSE(Qmod, Qobs)

  output <- data.frame(parameterlist, nse)

  return(output)
}
