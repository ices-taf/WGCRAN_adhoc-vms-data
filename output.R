## Extract results of interest, write TAF output tables

## Before:
## After:

library(icesTAF)
library(data.table)
library(sf)
library(dplyr)

mkdir("output")

cp("data/wgcran_vms.gpkg", "output")

# read vms
wgcran_vms <- st_read("output/wgcran_vms.gpkg", quiet = TRUE)

st_write(wgcran_vms, "output/wgcran_vms.geojson")

fwrite(st_drop_geometry(wgcran_vms), file = "output/wgcran_vms.csv")

st_write(wgcran_vms %>% filter(year == 2017 & month == 1), "output/wgcran_vms_sub.geojson")
