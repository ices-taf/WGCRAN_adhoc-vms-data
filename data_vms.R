library(icesTAF)
library(sf)
library(dplyr)

mkdir("data")

# read vms
vms <- read.taf(taf.data.path("vms", "vms.csv")) %>% tibble()

# get csquares for the eez areas
csquares_eez <- st_read("data/csquare_eez.gpkg")

# combine nld with the rest
wgcran_vms <-
  vms %>%
  group_by(year, month, c_square) %>%
  summarise(
    fishingHours = sum(fishingHours, na.rm = TRUE),
    totweight = sum(totweight, na.rm = TRUE),
    unique_vessels = sum(unique_vessels),
    .groups = "drop"
  ) %>%
  mutate(
    unique_vessels = ifelse(unique_vessels > 2, NA, unique_vessels)
  ) %>%
  filter(
    c_square %in% csquares_eez$c_square
  ) %>%
  left_join(csquares_eez, by = "c_square") %>%
  st_as_sf()

st_write(wgcran_vms, "data/wgcran_vms.gpkg")
