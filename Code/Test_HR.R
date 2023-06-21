##########################################
##   Edwards Home Range Analysis    ######
##########################################

# Script written by Annie Kellner 6/20/23 annie.kellner@colostate.edu

library(tidyverse)
#library(ggplot2)
library(amt)
library(readr)
library(terra)
library(sf)
library(tmap)
library(tmaptools)
library(conflicted) # will show errors if functions used appear in >1 package

conflicts_prefer(
  dplyr::filter()
)

rm(list = ls()) # If you get weird errors about a cachekey, just restart RStudio rather than erase the environment

## Begin Script

# ----------- LOAD AND PREP DATA ---------------------   #

# You will get an error if you try loading the csv files without the locale argument
# https://stackoverflow.com/questions/71532975/trying-to-read-csv-file-says-error-in-ncharx-width-invalid-multibyte-s

# Trying with 1 csv first before using multiple animals

cat1 <- read_csv('./Data/GPS_Collar82327_clean.csv', 
                 col_names = TRUE, 
                 locale=locale(encoding="latin1"), 
                 show_col_types = FALSE) 

## Combine date and time columns

# Change column types to tidyverse style datetimes (package {lubridate})

# I have left these dates and times in UTC but you can change that to suit your analysis. 
  # This will be more important when you're looking at habitat use than HR 
  # (eg, it may be valuable to examine temporal habitat use, in which case you will want to use local time)

cat1$UTC_Date <- mdy(cat1$UTC_Date) # change column type from chr to date
cat1$UTC_Time <- hms::as_hms(cat1$UTC_Time)

cat1$Datetime <- paste(cat1$UTC_Date, cat1$UTC_Time)
cat1$Datetime <- ymd_hms(cat1$Datetime)

# ----- Use {amt} package to make track -------------------- #

# NOTE: I would use the projected columns for (X,Y) within the csv rather than lat/long. 
# Because I did not know what projection was used, I used lat/long for this script. 
# Find the EPSG code for your projection and replace '4326' with the EPSG code or proj notation for your projected coordinates.

track1 <- make_track(cat1, .x = "Longitude [°]", .y = "Latitude [°]" , .t = "Datetime", crs = 4326) # 4326 is the EPSG code for lat/long

# If you get an error about "negative time differences", follow these steps:

#negTimes <- cat1 %>%
  #mutate(next_time = lead(Datetime, 1)) %>%
  #mutate(timediff = next_time - Datetime) %>%
  #dplyr::filter(timediff < 0) %>%
  #select(No, UTC_Date, UTC_Time, Datetime, next_time, timediff)

#negTimes # Occasionally R will conflate times when written in AM/PM rather than military time.
#which(cat1$No == 1800) # 1631 (this is the row number)

#cat1[1631,53] <- "2023-02-12 02:00:37" # change time manually as necessary


# ----- Calculate values and visualize results -------- #

# Note: you can find the calculated estimates stored within the objects generated. 
# I do not show any results explicitly in this script, but if you look within the object in the environment,
# you can see what all is calculated. You can then extract the values from within the object (usually using $)

## Create home range objects 
# Values returned are usually lists, the components of which can be accessed using the $ sign)

mcp <- hr_mcp(track1) # default is 95% MCP, but this can be changed using the 'levels' argument
akde <- hr_akde(track1) # example for using AKDE. Same as above.


## Accessing and visualizing spatial objects

mcp_geom <- mcp$mcp$geometry # accessing the spatial object (i.e. vector 'shapefile')

plot(akde$ud) # plotting the raster file that shows density of use and GPS coordinates

plot(mcp_geom) # simple plot showing raster image without spatial context


## Quick interactive plot to ensure your HR's are where and roughly what size you expect them to be
# You can check the actual size within the object or use the hr_area function

tmap_mode('view') # this allows you to view the location in space (ie Earth). You can use your mouse to zoom in and out. 

tm_shape(mcp_geom) + 
  tm_polygons()