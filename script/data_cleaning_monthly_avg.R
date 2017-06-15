# NA Data Cleaning Script
#
# Cleans all unavailable data points and replaces them with monthly averages
# Input: Dataframe with Data$P, Data$Q, Data$E Present.
# Output: Vector 'Yongdam'


# Trimming NA Values
Yongdam <- na.trim(Yongdam)

# Converting N/A Values to 0
Yongdam$P[is.na(Yongdam$P)] <- 0

# Filling E NAs with Monthly Averages
monthly.averages <- aggregate(Yongdam$E, by = as.yearmon, FUN = mean, na.rm = T)
toreplace <- is.na(Yongdam$E)
toreplace.yearmonth <- as.yearmon(index(Yongdam)[toreplace])
Yongdam$E[toreplace] <- coredata(monthly.averages)[match(
  toreplace.yearmonth,
  index(monthly.averages))]
