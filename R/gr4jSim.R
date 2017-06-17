#' Outputs GR4J modelled run with observed flow
#'  
#' @param input Input data (requires Data$Q, Data$P, and Data$E) (mm/day)
#' @param x1 Value for X1 Parameter in GR4J
#' @param x2 Value for X2 Parameter in GR4J
#' @param x3 Value for X3 Parameter in GR4J
#' @param x4 Value for X4 Parameter in GR4J
#' @param etmult Multiplier applied to Data$E to estimate potential evapotranspiration (default is 1)
#' @param trasnformed Transformed parameters before use to improve identifiability
#' @param warmup Number of Days to Warmup the hydrologic model
#' @export


gr4jSim <- function(input, x1, x2, x3, x4, area, etmult = 1, transformed = TRUE, warmup = 365){

  # Parameter
  simRun <- hydromad(
    as.zoo(input),
    sma = "gr4j",
    routing = "gr4jrouting",
    x1 = x1,
    x2 = as.vector(x2),
    x3 = x3,
    x4 = as.vector(x4),
    etmult = etmult,
    transformed = transformed) ## transform

  hydromad.options(warmup = warmup)
  
  # Simulation and Preparing Output
  Qmod <- fitted(simRun)
  Qobs <- observed(simRun)

  simRunoutput <- data.frame(Qmod, Qobs)

  return(simRunoutput)

}
