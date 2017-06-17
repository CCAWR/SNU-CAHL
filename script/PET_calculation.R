# Running Potential Evapotranspiration Calculations
#
# 
# 

library("SPEI")

hargreaves <- hargreaves(Yongdam$Tmin, Yongdam$Tmax, lat = 35.93965614) # From Google Maps
