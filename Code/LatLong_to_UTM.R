#####################################
##  LAT/LONG TO UTM   ###############
#####################################

# 4-17-2024
# Annie Kellner

library(tidyverse)
library(sf)
library(here)


# ------- DATA  -------------- #
# sent as .xlsx from Adam Dillon



gps82328 <- read_excel("Data/Converting Lat_Long to UTMs/GPS_82328_clean_short.xlsx")
gps82347 <- read_excel("Data/Converting Lat_Long to UTMs/GPS_82347_clean_short.xlsx")
gps82349 <- read_excel("Data/Converting Lat_Long to UTMs/GPS_82349_clean_short.xlsx")
gps82354 <- read_excel("Data/Converting Lat_Long to UTMs/GPS_82354_clean_short.xlsx")
gps84348 <- read_excel("Data/Converting Lat_Long to UTMs/GPS_84348_clean_short.xlsx")
gps84359 <- read_excel("Data/Converting Lat_Long to UTMs/GPS_84359_clean_short.xlsx")
gps84303 <- read_excel("Data/Converting Lat_Long to UTMs/GPS_Collar84303_clean.xlsx")

# Create list of dataframes

dfList <- list(gps84303, gps84359, gps84348, gps82354, gps82349, gps82347, gps82328)

# ----- ADD UTM COLUMNS ------------- #

# Convert to spatial object

df <- dfList[[1]]

UTM <- list() # create list to put all dataframes into 

for(i in 1:length(dfList)){
  df = dfList[i]
  dfSF = st_as_sf(df, coords = c("Longitude", "Latitude"), crs = st_crs(4326))
  
  dfSF = dfSF %>%
    cbind(st_coordinates(df)) %>%
    rename(c(Longitude = X, Latitude = Y)) 
  
  dfUTM = dfSF %>%
    st_transform(dfSF, 32711) %>%
    cbind(st_coordinates(dfSF)) %>%
    rename(Easting = X, Northing = Y) %>%
    st_drop_geometry()
  
  write_csv(dfUTM, file = )
  
  
  
}

df <- st_as_sf(df, coords = c("Longitude", "Latitude"), crs = st_crs(4326))

df <- df %>%
  cbind(st_coordinates(df)) %>%
  rename(c(Longitude = X, Latitude = Y)) 

df2 <- st_transform(df, 32711) %>%
  cbind(st_coordinates(df2)) %>%
  rename(Easting = X, Northing = Y) %>%
  st_drop_geometry()