#' Output Performance comparisons for simulated and observed hydrological time series data
#' 
#' Performes Nash-Sutcliffe Efficiency, relative Nash-Sutcliffe Efficiency, Root Mean Square Error, Relative Root Mean Square Error, Ratio of RMSE to the standard deviation of the observations, Percent Bias, and Kling-Gupta Efficiency
#'
#' @param sim numeric 'data.frame', 'matrix', or 'vector' with simulated values
#' @param obs numeric 'data.frame', 'matrix', or 'vector' with observed values
#' @export

GOFperformance <- function(sim,obs) {

  # Collecting performance values
  nse <- NSE(sim, obs)
  rnse <- rNSE(sim, obs)
  rmse <- rmse(sim, obs)
  rrmse <- rrmse(sim, obs)
  rsr <- rsr(sim, obs)
  pbias <- pbias(sim, obs)
  kge <- KGE(sim, obs)

  # Formatting for output
  GOFoutput <- data.frame(nse, rnse, rmse, rrmse, rsr, pbias, kge)

  return(GOFoutput)

}
