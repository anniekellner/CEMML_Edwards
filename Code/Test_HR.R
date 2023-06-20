##########################################
##    RHR Home Range Package    ##########
##########################################

# Script written by Annie Kellner 6/20/23 annie.kellner@colostate.edu

library(tidyverse)
library(ggplot2)
library(amt)
library(readr)
library(conflicted) # will show errors if functions used appear in >1 package

rm(list = ls())

# ----------- LOAD AND PREP DATA ---------------------   #

# You will get an error if you try loading this without the locale argument
# https://stackoverflow.com/questions/71532975/trying-to-read-csv-file-says-error-in-ncharx-width-invalid-multibyte-s

# Trying with 1 csv first before using multiple animals

cat1 <- read_csv('./Data/GPS_Collar82327_clean.csv', 
                 col_names = TRUE, 
                 locale=locale(encoding="latin1"), 
                 show_col_types = FALSE) 

# Combine date and time columns

#Change column types to tidyverse style (package {lubridate})

cat1$UTC_Date <- mdy(cat1$UTC_Date) # change column type from chr to date
cat1$UTC_Time <- hms::as_hms(cat1$UTC_Time)

cat1$Datetime <- paste(cat1$UTC_Date, cat1$UTC_Time)
cat1$Datetime <- ymd_hms(cat1$Datetime)

# ----- Use {amt} package to make track

track1 <- make_track(cat1, .x = "Latitude", .y = "Longitude", .t = "Datetime") 

# ERROR: "negative time differences"