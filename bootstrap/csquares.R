#' VMS data from the ICES VMS and Logbook Database
#'
#' VMS data from the ICES VMS and Logbook Database
#'
#' @name csquares
#' @format csv file
#' @tafOriginator ICES
#' @tafYear 2020
#' @tafAccess Restricted
#' @tafSource script

library(icesVMS)
library(sf)

# get square info
csquares <- get_csquare(ecoregion = "Greater North Sea")

csquares <- st_as_sf(csquares, wkt = "wkt", crs = 4326)

st_write(csquares, "csquares.gpkg")
