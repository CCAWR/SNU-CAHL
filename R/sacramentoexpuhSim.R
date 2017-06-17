#' Outputs Sacramento modelled run with observed flow
#'
#' Runs Sacramento model with expuh routing model
#'
#' @param input Input data (requires Data$Q, Data$P, and Data$E) (mm/day)
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
#' @export
#'


sacramentoexpuhSim <- function(input, delay = 0, uztwm, uzfwm, uzk, pctim, adimp, zperc, rexp, lztwm, lzfsm, lzfpm, lzsk, lzpk, pfree, etmult = 1, tau_s, tau_q, v_s, warmup = 365){
  
  # Configuration
  simRun <- hydromad(
    as.zoo(input),
    sma = "sacramento",
    routing = "expuh",
    delay = delay,
    uztwm = uztwm,
    uzfwm = uzfwm,
    uzk = uzk,
    pctim = pctim,
    adimp = adimp,
    zperc = zperc,
    rexp = rexp,
    lztwm = lztwm,
    lzfsm = lzfsm,
    lzfpm = lzfpm,
    lzsk = lzsk,
    lzpk = lzpk,
    pfree = pfree,
    etmult = etmult,
    tau_s = tau_s,
    tau_q = tau_q,
    v_s = v_s)
  
  hydromad.options(warmup = warmup)
  
  # Simulation and Preparing Output
  Qmod <- fitted(simRun)
  Qobs <- observed(simRun)
  
  simRunoutput <- data.frame(Qmod, Qobs)
  
  return(simRunoutput)
  
}
