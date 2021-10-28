#' VMS data from the ICES VMS and Logbook Database
#'
#' VMS data from the ICES VMS and Logbook Database
#'
#' @name eez
#' @format csv file
#' @tafOriginator VLIZ
#' @tafYear 2020
#' @tafAccess Restricted
#' @tafSource script

library(icesTAF)
library(dplyr)
library(sf)

unzip(
  taf.boot.path("initial", "data", "World_EEZ_v11_20191118_gpkg.zip"),
  exdir = "temp"
)

eez <-
  st_read(
    "temp/World_EEZ_v11_20191118_gpkg/eez_v11.gpkg", quiet = TRUE
  )

unlink("temp", recursive = TRUE)

eez_sub <-
  eez %>%
  filter(grepl("Dut|Dan|Ger|Belg", GEONAME)) %>%
  select(
    TERRITORY1
  ) %>%
  rename(
    country = TERRITORY1
  )

if (FALSE) {
  eco <- icesFO::load_ecoregion("Greater North Sea")
  plot(eco, reset = FALSE)
  plot(sf::st_union(eez_sub), add = TRUE, col = "red")
}

st_write(eez_sub, "eez.gpkg")
