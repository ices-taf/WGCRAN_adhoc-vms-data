library(icesTAF)
library(sf)
library(dplyr)

mkdir("data")


# read eez
eez <- st_read(taf.data.path("eez", "eez.gpkg"), quiet = TRUE)

# simplify eez
eez_simple <-
  eez %>%
  st_union() %>%
  st_simplify(dTolerance = .02)

if (FALSE) {
  plot(eez, reset = FALSE)
  plot(eez_simple, add = TRUE, col = "red")
}

# get square info
cs <- st_read(taf.data.path("csquares", "csquares.gpkg"))

# filter data by simplified eez
csquare_eez <-
  filter(
    cs,
    st_intersects(eez_simple, cs, sparse = FALSE)[1, ]
  )

st_write(csquare_eez, "data/csquare_eez.gpkg")
