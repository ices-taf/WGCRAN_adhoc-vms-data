#' VMS data from the ICES VMS and Logbook Database
#'
#' VMS data from the ICES VMS and Logbook Database
#'
#' @name vms_nld
#' @format csv file
#' @tafOriginator ICES
#' @tafYear 2020
#' @tafAccess Restricted
#' @tafSource script

# monthly cumulated values for fishing effort (hours) and total landings (tonnes)
# at a resolution of 0.05 x 0.05 degrees) from the nations Denmark, Germany and the Netherlands.
# These values are needed for one metier (TBB_CRU_16-31) for the years 2009 – 2018 and the geographical
# scope is the Danish, German and Dutch EEZ’s.

library(icesTAF)
library(icesVMS)
library(icesVocab)
library(dplyr)

# to get all the data we need years (year = 0)
vms_nld_all <-
  get_vms(
    country = "NLD",
    metier = "TBB_CRU_16-31_0_0",
    year = 0,
    ecoregion = "Greater North Sea",
    datacall = 2020
  ) %>%
  tibble()

anonsum <- function(x) ifelse(any(is.na(x)), NA, paste(x, collapse = ";"))
nasum <- function(x) ifelse(all(is.na(x)), NA, sum(x, na.rm = TRUE))

vms_nld_all <-
  vms_nld_all %>%
  mutate(
    anonVessels = ifelse(anonVessels == "NA", NA, anonVessels)
  )

# now aggregate
vms_nld <-
  vms_nld_all %>%
  group_by(year, month, cSquare) %>%
  summarise(
    fishingHours = sum(fishingHours, na.rm = TRUE),
    totweight = sum(totweight, na.rm = TRUE),
    anonVessels = anonsum(anonVessels),
    .groups = "drop"
  ) %>%
  rename(c_square = cSquare) %>%
  mutate(
    unique_vessels = nchar(gsub("[a-zA-Z0-9]", "", anonVessels)) + 1
  ) %>%
  mutate(
    unique_vessels = ifelse(unique_vessels > 2, NA, unique_vessels)
  ) %>%
  select(
    year, month, c_square, unique_vessels, fishingHours, totweight
  )

# save
write.taf(vms_nld, quote = TRUE)
