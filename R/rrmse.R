############################################
# 'rrmse': Relative Root Mean Square Error #
############################################
#   15-Dic-2008; 06-Sep-09; 14-Apr-17      #
############################################
# 'obs'   : numeric 'data.frame', 'matrix' or 'vector' with observed values
# 'sim'   : numeric 'data.frame', 'matrix' or 'vector' with simulated values
# 'Result': Root Mean Square Error between 'sim' and 'obs', in the same units of 'sim' and 'obs'
# Modified from hydroGOF's RMSE Function

#' Outputs relative root mean square error (modified from hydroGOF's RMSE function)
#'
#' @param sim numeric 'data.frame', 'matrix' or 'vector' with simulated values
#' @param obs numeric 'data.frame', 'matrix' or 'vector' with simulated values
#' @param na.rm a logical value indicating whether 'NA' should be stripped before the computation proceeds.
#' @export

rrmse <- function(sim, obs, na.rm = TRUE, ...) UseMethod("rrmse")

rrmse.default <- function(sim, obs, na.rm=TRUE, ...) {

  if ( is.na(match(class(sim), c("integer", "numeric", "ts", "zoo"))) |
       is.na(match(class(obs), c("integer", "numeric", "ts", "zoo")))
  ) stop("Invalid argument type: 'sim' & 'obs' have to be of class: c('integer', 'numeric', 'ts', 'zoo')")

  if ( length(obs) != length(sim) )
    stop("Invalid argument: 'sim' & 'obs' doesn't have the same length !")

  rrmse <- sqrt( mean( (sim - obs)^2, na.rm = na.rm)) /  (length(obs) * mean(obs))

  return(rrmse)

}

rrmse.zoo <- function(sim, obs, na.rm=TRUE, ...){

  sim <- zoo::coredata(sim)
  if (is.zoo(obs)) obs <- zoo::coredata(obs)

  if (is.matrix(sim) | is.data.frame(sim)) {
    rmse.matrix(sim, obs, na.rm = na.rm, ...)
  } else NextMethod(sim, obs, na.rm = na.rm, ...)

}
