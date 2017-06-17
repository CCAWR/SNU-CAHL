#' Outputs IHACRES CMD modelled run with observed flow
#'  
#'  Runs IHACRES CMD model with expuh routing model
#'  
#' @param input Input data (requires Data$P, and Data$E) (mm/day)
#' @param delay Time-delay for hydrologic routing
#' @param f CMD stress threshold as a proportion of d
#' @param e Temperature to PET conversion factor
#' @param d CMD threshold producing flow
#' @param shape shape 
#' @param tau_s time constraints
#' @param tau_q time constraints
#' @param v_s fractional volume
#' @param warmup Number of Days to Warmup the hydrologic model
#' @export


ihacrescmdexpuhSim <- function(input, delay = 0, f, e = 1, d, shape, tau_s, tau_q, v_s, warmup = 365){
  
  # Configuration
  simRun <- hydromad(
    as.zoo(input),
    sma = "cmd",
    routing = "expuh",
    delay = delay,
    f = f,
    e = e,
    d = d,
    shape = shape,
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
