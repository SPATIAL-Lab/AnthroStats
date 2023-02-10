# Setup ----

library(assignR)
library(raster)
library(sp)

# Get and prep data ----

twiso = getIsoscapes("USTap")
plot(twiso)

twiso = stack(twiso$d18o, twiso$d18o_sd)
plot(twiso)

kod = subOrigData("d18O", group = "Modern human", mask = states)

# Create hair isoscape and posterior probability maps ----

hairiso = calRaster(kod, twiso)

ssdata = data.frame("ID" = c("Region_1", "Region_2", "Region_3", "Region_4"), 
                    "d18O" = c(9.9, 8.4, 9.2, 11))
sspost = pdRaster(hairiso, ssdata)

# Post-hoc analysis ----

ca_ut = states[states$STATE_NAME %in% c("California", "Utah"),]
ca_ut$STATE_NAME
oddsRatio(sspost, ca_ut)

ssup = unionP(sspost)

qtlRaster(ssup, 0.1)

slc = SpatialPoints(data.frame(rep(-111.9, 4), rep(40.7, 4)), CRS("+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs"))
sswd = wDist(sspost, slc)
plot(sswd)
