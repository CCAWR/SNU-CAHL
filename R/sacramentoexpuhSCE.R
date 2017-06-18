#' Runs SCE Calibration for Sacramento Model
#'
#' Outputs Sacramento Parameters and NSE value with expuh routing model.
#'
#' @param inputdata Input data (requires Data$Q, Data$P, and Data$E) (mm/day)
#' @param seed Random number for sampling within SCE
#' @param delay Time-delay for hydrologic routing
#' @param uztwm Upper zone maximum tension water capacity (mm)
#' @param uzfwm Upper zone maximum free water capacity (mm).
#' @param uzk Lateral drainage rate of upper zone free water expressed as a fraction of contents per day.
#' @param pctim The fraction of the catchment which produces impervious runoff during low flow conditions.
#' @param adimp The additional fraction of the catchment which exhibits impervious characteristics when the catchment's tension water requirements are met.
#' @param zperc Maximum percolation (from upper zone free water into the lower zone) rate coefficient.
#' @param rexp An exponent determining the rate of change of the percolation rate with changing lower zone water contents.
#' @param lztwm Lower zone maximum tension water capacity (mm)
#' @param lzfsm Lower zone maximum supplemental free water capacity (mm)
#' @param lzfpm Lower zone maximum primary free water capacity (mm)
#' @param lzsk Lateral drainage rate of lower zone supplemental free water expressed as a fraction of contents per day
#' @param lzpk Lateral drainage rate of lower zone primary free water expressed as a fraction of contents per day
#' @param pfree Direct percolation fraction from upper to lower zone free water (the percentage of percolated water which is available to the lower zone free water aquifers before all lower zone tension water deficiencies are satisfied)
#' @param etmult Multiplier applied to Data$E to estimate potential evapotranspiration (default is 1)
#' @param tau_s time constraints
#' @param tau_q time constraints
#' @param v_s fractional volume
#' @param warmup Number of Days to Warmup the hydrologic model
#' @param ncomplex Number of Complexes for SCE
#' @param maxit Maximum number of iterations
#' @export
#'

sacramentoexpuhSCE <- function(inputdata, seed, delay = 0, uztwm = c(1, 150), uzfwm = c(1, 150), uzk = c(0.1, 0.5), pctim = c(1e-06, 1e-01), adimp = c(0, 0.4), zperc = c(1, 250), rexp = c(0, 5), lztwm = c(1, 500), lzfsm = c(1, 1000), lzfpm = c(1, 1000), lzsk = c(0.01, 0.25), lzpk = c(0.0001, 0.25), pfree = c(0, 0.6), etmult = 1, tau_s = c(10,1000), tau_q = c(0,10), v_s = c(0,1), warmup = 365, ncomplex = 20, maxit = 200) {
  
  # Preparing Hydromad Framework
  runmodel <- hydromad(as.zoo(inputdata), sma = "sacramento", routing = "expuh")
  runmodel <- update(runmodel, uztwm = uztwm)
  runmodel <- update(runmodel, uzfwm = uzfwm)
  runmodel <- update(runmodel, uzk = uzk)
  runmodel <- update(runmodel, pctim = pctim)
  runmodel <- update(runmodel, adimp = adimp)
  runmodel <- update(runmodel, zperc = zperc)
  runmodel <- update(runmodel, rexp = rexp)
  runmodel <- update(runmodel, lztwm = lztwm)
  runmodel <- update(runmodel, lzfsm = lzfsm)
  runmodel <- update(runmodel, lzfpm = lzfpm)
  runmodel <- update(runmodel, lzsk = lzsk)
  runmodel <- update(runmodel, lzpk = lzpk)
  runmodel <- update(runmodel, pfree = pfree)
  runmodel <- update(runmodel, etmult = etmult)
  
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
  
  output <- list(Qmod, Qobs, parameterlist, nse)
  
  return(output)
}


