## GIS Data Selection and Extraction
#
# This script is used to import Raster datasets within R, select and output the data present only within the study area.  The code here is fairly dependent on our local data storage format, but can be modified to fit your own needs.

## Importing Libraries
library("raster")
library("maptools")

## Configuration
# Input File Information
inputbaselocation <- '/datastore/Korea/'

startingdate <- "20210101"
endingdate <- "20210102"
variable <- 'tmax'
model <- 'WRFv34'
scenario <- 'RCP45'
weighting <- 'IC400'
timestep <- 'daily'
studyarea <- 'skorea'

# Location of the Mask File
maskfilelocation <- "/datastore/GIS/shapes/4001.shp" # Mask Shapefile

# Output File Information
outputbaselocation <- '/datastore/Korea/4001-sliced/prcp/' # With trailing slash

## Script
# Date Organizing System
startingd <- as.Date(startingdate, "%Y%m%d")
endingd <- as.Date(endingdate, "%Y%m%d")
dates <- seq(from = startingd, to = endingd, by = "days")

maskfile <- readShapePoly(maskfilelocation)

for (i in seq_along(dates))
{
    formatteddate <- format(dates[i], format = "%Y%m%d")
  inputrastername <- paste(weighting,scenario,studyarea,model,variable,timestep,formatteddate, sep = "_")
  inputrastername <- paste(inputbaselocation,inputrastername, ".txt", sep = "")
  rasterfile <- raster(inputrastername)
  # rasterfile <- flip(rasterfile, direction = "y") # If the raster is flipped depending on DEM

  ## Output Raster Filename Generation
  outputrasterfilename <- paste(weighting,scenario,studyarea,model,variable,timestep,formatteddate, sep = "_")
  outputrasterfilename <- paste(outputbaselocation,outputrasterfilename, ".asc", sep = "")

  ## Masking/Clipping
  croppedraster <- crop(rasterfile, maskfile)
  clippedraster <- mask(croppedraster, maskfile)

  # Writing as ASCII
  writeRaster(clippedraster, outputrasterfilename)

}



