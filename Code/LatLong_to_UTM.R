#####################################
##  LAT/LONG TO UTM   ###############
#####################################

# 4-17-2024
# Annie Kellner

library(tidyverse)
library(sf)
library(readxl)
library(here)
library(tmap)
library(tmaptools)

# ------- DATA  -------------- #
# sent as .xlsx from Adam Dillon

directory <- here("Data", "Converting Lat_Long to UTMs")

files <- list.files(directory, full.names = TRUE)
filenames <- list.files(directory, full.names = FALSE)
filenames <- str_remove_all(filenames, pattern = ".xlsx")


# ----- IMPORT FILES AND ADD UTM COLUMNS ------------- #

# Convert to spatial object

for(i in 1:length(files)){
  df = read_excel(files[i])
  dfSF = st_as_sf(df, coords = c("Longitude", "Latitude"), crs = st_crs(4326))
  
  dfSF = dfSF %>%
    cbind(st_coordinates(dfSF)) %>%
    rename(c(Longitude = X, Latitude = Y)) 
  
  dfUTM = st_transform(dfSF, 32711)
  
  dfUTM = dfUTM %>%
    cbind(st_coordinates(dfUTM)) %>%
    rename(UTM_Easting = X, UTM_Northing = Y) %>%
    st_drop_geometry()
  
  spreadsheet = filenames[i]
  name = paste0(spreadsheet,"_UTM.csv")
  
  write_csv(dfUTM, file = here("Results", name))
  
}

# Test to make sure points look the same

tmap_mode('view')

tm_shape(dfSF) + 
  tm_symbols()

tm_shape(dfUTM) + 
  tm_symbols()

