#' VMS data from the ICES VMS and Logbook Database
#'
#' VMS data from the ICES VMS and Logbook Database
#'
#' @name vms
#' @format csv file
#' @tafOriginator ICES
#' @tafYear 2022
#' @tafAccess Restricted
#' @tafSource script

# monthly cumulated values for fishing effort (hours) and total landings (tonnes)
# at a resolution of 0.05 x 0.05 degrees) from the nations Denmark, Germany and the Netherlands.
# These values are needed for one metier (TBB_CRU_16-31) for the years 2009 – 2018 and the geographical
# scope is the Danish, German and Dutch EEZ’s.

library(icesVMS)
library(icesVocab)
library(dplyr)
library(sf)

# to get all the data we need years (year = 0)
vms_all <-
  get_vms(
    metier = c("TBB_CRU_16-31", "TBB_CRU_16-31_0_0"),
    country = c("DK", "DE", "BE", "NL"),
    year = 0
  ) %>%
  tibble()

maxna <- function(x) {
  x[is.na(x)] <- 0
  max(x, na.rm = TRUE)
}

maxna(NA)

# now aggregate
vms <-
  vms_all %>%
  group_by(year, month, cSquare, vesselLengthCategory, country) %>%
  summarise(
    fishingHours = sum(fishingHours, na.rm = TRUE),
    totweight = sum(totweight, na.rm = TRUE),
    uniqueVessels = maxna(uniqueVessels),
    .groups = "drop"
  ) %>%
  group_by(year, month, cSquare) %>%
  summarise(
    fishingHours = sum(fishingHours, na.rm = TRUE),
    totweight = sum(totweight, na.rm = TRUE),
    uniqueVessels = sum(uniqueVessels, na.rm = TRUE),
    .groups = "drop"
  ) %>%
  rename(c_square = cSquare, unique_vessels = uniqueVessels) %>%
  mutate(
    unique_vessels = ifelse(unique_vessels > 2, NA, unique_vessels)
  ) %>%
  select(
    year, month, c_square, unique_vessels, fishingHours, totweight
  )

# save
write.taf(vms, quote = TRUE)
