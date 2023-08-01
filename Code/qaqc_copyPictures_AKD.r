#######################################     DESCRIPTION     ############################################################
#####                                                                                                              #####
#####   This code reads the survey file(s) and copies pictures categorized by species into "by species" subfolders #####
#####                                                                                                              #####    
########################################################################################################################

### DATE 7/31/2023 - Adapted by Annie Kellner -  annie.kellner@colostate.edu

## Adapted script originally written by Valerie Steen (qaqc_copyPictures.R)
## Sorting now by species only, not by folder

##################################################################################################################

# SCRIPT START

library(tidyverse)
library(readxl)
library(conflicted)

conflicts_prefer(
  dplyr::select()
)

rm(list = ls())

# ------  LOAD AND PREP DATA  ----------------------- #

allanimalcaptures <- read_excel("Data/AllAnimalCaptures06232023.xlsx")
head(allanimalcaptures)

all <- allanimalcaptures %>% # Disregarding secondary species in photos
  dplyr::select(-species2) %>%
  rename(Species = species1)

rm(allanimalcaptures)

# ------ CREATE DIRECTORIES ------------------------- #

mainstem <- "N:\\RStor\\jaw\\goea\\Edwards Large Mammal\\Images" 

# Create subfolders within QAQC

species <- unique(all$Species)

for(i in 1:length(species)){
  to = paste0(mainstem,"\\","QAQC","\\",species[i],"\\")
  if (!dir.exists(to)){
    dir.create(to)
  } else {
    print("dir.exists")
  }
}

# --------  COPY IMAGES -------------- #

for(i in 1:nrow(all)){
  year = all[i,]$Folder
  RelativePath = all[i,]$RelativePath
  picture = all[i,]$File
  iSpecies = all[i,]$Species 
  from = paste0(mainstem,"\\",year,"\\",RelativePath,"\\",picture)
  to = paste0(mainstem,"\\","QAQC","\\",iSpecies,"\\",picture)
  file.copy(from = from,
            to = to,
            overwrite = FALSE)
}
  
# SCRIPT END

