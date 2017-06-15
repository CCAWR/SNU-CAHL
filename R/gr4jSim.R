#' Outputs GR4J Run with Observed Data
#'
#' @param input data frame with P, precipitation, and E, evapotranspiration. (mm/day)
#' @param x1.func Value for X1 Parameter in GR4J
#' @param x2.func Value for X2 Parameter in GR4J
#' @param x3.func Value for X3 Parameter in GR4J
#' @param x4.func Value for X4 Parameter in GR4J
#' @param area Study area in sq. km
#' @param etmult Multiplier applied to Dataset$E to estimate potential evapotranspiration (default is 1, which means input Dataset$E is PET data)
#' @param trasnformed Transformed parameters before use to improve identifiability
#' @export


gr4jSim <- function(input, x1.func, x2.func, x3.func, x4.func, area, etmult = 1, transformed = FALSE){

  # Simulation RCP45
  simRun <- hydromad(
    as.zoo(input),
    sma = "gr4j",
    routing = "gr4jrouting",
    x1 = x1.func,
    x2 = as.vector(x2.func),
    x3 = x3.func,
    x4 = as.vector(x4.func),
    etmult = etmult,
    transformed = transformed) ## transform

  # Preparing Output
  Qmod <- fitted(simRun)
  Qobs <- observed(simRun)

  Qmod <- convertFlow(Qmod, from = "mm/days", to = "m^3/sec", area.km2 = area)
  Qobs <- convertFlow(Qobs, from = "mm/days", to = "m^3/sec", area.km2 = area)

  simRunoutput <- data.frame(Qmod, Qobs)

  return(simRunoutput)

}
