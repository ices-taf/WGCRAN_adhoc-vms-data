## Prepare plots and tables for report

## Before:
## After:

library(icesTAF)
library(ggplot2)
library(sf)

mkdir("report")

# read eez
eez <- st_read(taf.data.path("eez", "eez.gpkg"), quiet = TRUE)

# read vms
wgcran_vms <- st_read("output/wgcran_vms.gpkg", quiet = TRUE)

# a visual check
vms_sum <-
  wgcran_vms %>%
  filter(year == 2017) %>%
    group_by(c_square) %>%
    summarise(
      fishingHours = sum(fishingHours),
      unique_vessels = max(unique_vessels),
      .groups = "drop"
    ) %>%
    select(fishingHours, unique_vessels)

ggplot() +
  geom_sf(data = eez, aes()) +
  geom_sf(data = vms_sum, aes(fill = fishingHours), col = NA)

ggsave("check_total_sum.png", path = "report", dpi = 900, width = 9, height = 9)

ggplot() +
  geom_sf(data = vms_sum, aes(fill = fishingHours), col = NA) +
  geom_sf(data = eez, aes(), fill = NA)

ggsave("check_vms_extend.png", path = "report", dpi = 900, width = 9, height = 9)

ggplot() +
  geom_sf(data = vms_sum, aes(fill = unique_vessels), col = NA) +
  geom_sf(data = eez, aes(), fill = NA)
ggsave("check_unique_vessels.png", path = "report", dpi = 900, width = 9, height = 9)
