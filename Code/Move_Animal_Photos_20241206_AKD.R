############################################################################
##      SORTING CAMERA IMAGES - PART TWO                      ##############
##      DECEMBER 2024                                         ##############

# written by Annie Kellner for CEMML Edwards Project
# 12-12-2024

# Temporary image files = all photos
# Create new file directories using Excel file with just animal captures
# Basically same idea as last time; sort photos by species

## START  SCRIPT  ##

#Loading Libraries

library(tidyverse)  
library(conflicted)

#conflicts_prefer(  # Don't know if I need this
  #dplyr::select()
#)

#Load and Prepare Data
allAnimalCaptures <- read_csv("N:/RStor/CEMML/EdwardsAFB/Mohave_Ground_Squirrel/GIS_and_Monitoring_Data/2024/Field Data/MGS_combined_animaldata_20241212.csv")
glimpse(allAnimalCaptures)

# Old Directory
origDir <- "N:/RStor/CEMML/EdwardsAFB/Mohave_Ground_Squirrel/Camera_Images/Temporary_Images_renamed"


#Create Directories
newDir <- "N:/RStor/CEMML/EdwardsAFB/Mohave_Ground_Squirrel/Camera_Images/AnimalCaptures" # where directories should be created
species <- unique(allAnimalCaptures$species)

#Directories
for(i in 1:length(species)){
  to = paste0(newDir,"\\",species[i],"\\")
  if (!dir.exists(to)){
    dir.create(to)
  } else {
    print("dir.exists")
  }
}

#Copy Images
for(i in 1:nrow(allAnimalCaptures)){
  RootFolder = all[i,]$RootFolder 
  RelativePath = all[i,]$RelativePath
  picture = all[i,]$File
  iSpecies = all[i,]$species 
  
#Construct File Paths
from = paste0(origDir,"\\",RootFolder,"\\",RelativePath,"\\",picture)
to = paste0(newPhotos,"\\","\\",iSpecies,"\\",picture)

#Copy Files:
file.copy(from = from,
          to = to,
          overwrite = FALSE)
