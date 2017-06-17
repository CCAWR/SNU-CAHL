#' Runs SCE Calibration for IHACRES CMD Model
#'
#' Outputs IHACRES CMD Parameters and NSE value.
#'
#' @param inputdata Input data for GR4J model (requires Data$Q, Data$P, and Data$E) (mm/day)
#' @param seed Random number for sampling within SCE
#' @param delay Time-delay for hydrologic routing
#' @param f CMD stress threshold as a proportion of d
#' @param e Temperature to PET conversion factor
#' @param d CMD threshold producing flow
#' @param tau_s time constraints
#' @param tau_q time constraints
#' @param v_s fractional volume
#' @param warmup Number of Days to Warmup for GR4J
#' @param ncomplex Number of Complexes for SCE
#' @param maxit Maximum number of iterations
#' @export
#'

ihacrescmdexpuhSCE <- function(inputdata, seed, delay = 0, f = c(0.5, 1.3), e = 1, d = 200, tau_s = c(10,1000), tau_q = c(0,10), v_s = c(0,1), warmup = 365, ncomplex = 20, maxit = 200) {
  
  # Preparing Hydromad Framework
  runmodel <- hydromad(as.zoo(inputdata), sma = "cmd", routing = "expuh")
  runmodel <- update(runmodel, f = f)
  runmodel <- update(runmodel, e = e)
  runmodel <- update(runmodel, d = d)
  runmodel <- update(runmodel, tau_s = tau_s)
  runmodel <- update(runmodel, tau_q = tau_q)
  runmodel <- update(runmodel, v_s = v_s)
  runmodel <- update(runmodel, delay = delay)
  
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
  
  Qmod <- fitted(hydromodel)
  Qobs <- observed(hydromodel)
  
  nse <- NSE(Qmod, Qobs)
  
  parameterlist$nse <- nse
  
  output <- parameterlist
  
  #output <- data.frame(parameterlist, nse)
  
  return(output)
}
