# Data Importing Script
#
# Data importing and preparation for SNU-CAHL
# Input: Area, Prcp data, observed flow data, and PET data
# Output: Vector 'Yongdam'

## Library Import
library("xts")

## Configuration values
# Precipitation, Flow, and Potential Evapotranspiration Data Location
input.prcp.flow <- "script/data/prcp-flow.csv"
input.pet <- "script/data/pet.csv"

# Area (in sq. km)
area <- 930.426


## Script
pqdat <- read.table(input.prcp.flow, sep = ",", col.names = c("P", "Q", "Date"), as.is = TRUE)

pqdat$Date <- as.Date(pqdat$Date, "%Y-%m-%d")

pqdat$P[pqdat$P < 0] <- NA
pqdat$Q[pqdat$Q < 0] <- NA
pqdat$Q <- convertFlow(pqdat$Q, from = "m^3/sec", area.km2 = area)

tsPQ <- xts(pqdat[, 1:2], pqdat$Date, frequency = 1)

tdat <- read.table(input.pet, sep = ",", col.names = c("T", "Date"), as.is = TRUE)

tdat$Date <- as.Date(tdat$Date,"%Y-%m-%d")
tdat <- subset(tdat, !is.na(Date))
tsT <- xts(tdat[, 1], tdat$Date, frequency = 1)

Yongdam <- merge(tsPQ, E = tsT, all = FALSE)

