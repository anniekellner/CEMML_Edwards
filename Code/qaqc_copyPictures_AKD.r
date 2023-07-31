#######################################     DESCRIPTION     #####################################################
#####                                                                                                       #####
#####   This code reads the survey file(s) and                                                              #####
#####       1) copies pictures categorized by species into "by species" subfolders created by the code and  #####
#####       2) copies pictures by camera into "by camera" subfolders created by the code                    #####
#####                                                                                                       #####    
#####   OBJECTIVE: Check that pics were assigned to the correct species and camera                          #####
#####                                                                                                       #####  
#################################################################################################################

### DATE 7/31/2023 - Adapted by Annie Kellner annie.kellner@colostate.edu

### UPDATE 6/23/2023 (Val Steen): I added the description above; 
#                                 deleted previous pictures in the QAQC folder (30gb!); 
#                                 and switched to the AllAnimalCaptures xls

##################################################################################################################

N:\RStor\jaw\goea\Edwards Large Mammal\Images\Image_Duplicates

# SCRIPT START

library(tidyverse)
library(readxl)
library(conflicted)

conflicts_prefer(
  dplyr::select()
)

# ------  LOAD AND PREP DATA  ----------------------- #

allanimalcaptures <- read_excel("Data/AllAnimalCaptures06232023.xlsx")
head(allanimalcaptures)

all <- allanimalcaptures %>% # Disregarding secondary species in photos
  select(-species2) %>%
  rename(Species = species1)


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
  year = all[i, "Folder"]
  RelativePath = all[i, "RelativePath"]
  picture = all[i, "File"]
  file.copy(from = paste0(mainstem,"\\", year,"\\",RelativePath,"\\",picture),
            to = )

RelativePath <- pics.df[i,"RelativePath"]
picture <- pics.df[i,"File"]
file.copy(from = paste0(mainstem,"\\", year,"\\",RelativePath,"\\",picture),
          to = to)
}
}  #end function

### SURVEY A1

uni.spp <- unique(c(cam_surveyA1$species1,cam_surveyA1$species2))
uni.spp <- uni.spp[!is.na(uni.spp)]#doesn't seem to work to remove the NA
uni.spp
uni.spp <- uni.spp[-1]#remove the NA manually but check in line above this is the correct position
uni.spp

for(j in 1:length(uni.spp)){
  copyBySpeciesFcn(species=uni.spp[j],survey=cam_surveyA1)
  
}


###SURVEY A2
uni.spp <- unique(c(cam_surveyA2$species1,cam_surveyA2$species2))
uni.spp <- uni.spp[!(uni.spp %in% "NA")]

for(j in 1:length(uni.spp)){
  copyBySpeciesFcn(species=uni.spp[j],survey=cam_surveyA2)
  
}

###SURVEY B1
uni.spp <- unique(c(cam_surveyB1$species1,cam_surveyB1$species2))
uni.spp <- uni.spp[!(uni.spp %in% "NA")]

for(j in 1:length(uni.spp)){
  copyBySpeciesFcn(species=uni.spp[j],survey=cam_surveyB1)
  
}

###SURVEY B2
uni.spp <- unique(c(cam_surveyB2$species1,cam_surveyB2$species2))
uni.spp <- uni.spp[!(uni.spp %in% "NA")]

for(j in 1:length(uni.spp)){
  copyBySpeciesFcn(species=uni.spp[j],survey=cam_surveyB2)
  
}


############
####Copy pics by camera into QAQC, creating subfolders for each camera
###########

copyByCameraFcn <- function(camera,survey){
  pics.camera <- survey[which(survey$RelativePath %in% camera),]
  to = paste0(mainstem,"\\","QAQC","\\",camera,"\\")
  if (!dir.exists(to)){
    dir.create(to)
  }else{
    print("dir.exists")
  }
  print(camera)
  print("number of pics")
  print(nrow(pics.camera))
  for(i in 1:nrow(pics.camera)){
    year <- pics.camera[i,"Folder"]
    RelativePath <- pics.camera[i,"RelativePath"]
    picture <- pics.camera[i,"File"]
    file.copy(from = paste0(mainstem,"\\", year,"\\",RelativePath,"\\",picture),
              to = to)
  }
}#end function


###SURVEY A1
uni.camera <- unique(cam_surveyA1$RelativePath)
table(uni.camera)#make sure no weird names

#fix a weird name:
uni.camera[which(uni.camera %in% "A_178_CL\\N:\\RStor\\jaw\\goea\\Edwards Large Mammal\\Images\\2021\\A_178_CL")] <- "A_178_CL"
#check again
table(uni.camera)

uni.camera <- unique(uni.camera)

for(j in 1:length(uni.camera)){
  copyByCameraFcn(camera=uni.camera[j],survey=cam_surveyA1)
}
rm(uni.camera)

###SURVEY A2
uni.camera <- unique(cam_surveyA2$RelativePath)
table(uni.camera)#make sure no weird names

for(j in 1:length(uni.camera)){
  copyByCameraFcn(camera=uni.camera[j],survey=cam_surveyA2)
  }
rm(uni.camera)

###SURVEY B1
uni.camera <- unique(cam_surveyB1$RelativePath)
table(uni.camera)#make sure no weird names
#Fix them, e.g.:
uni.camera[which(uni.camera %in% "B_215_CL\\B_215_CL_PT1 B_215_CL\\B_215_CL_PT2")] <- "B_215_CL_PT2"


for(j in 1:length(uni.camera)){
  copyByCameraFcn(camera=uni.camera[j],survey=cam_surveyB1)
 }
rm(uni.camera)

###SURVEY B2
uni.camera <- unique(cam_surveyB2$RelativePath)
table(uni.camera)#make sure no weird names

for(j in 1:length(uni.camera)){
  copyByCameraFcn(camera=uni.camera[j],survey=cam_surveyB2)
  }
rm(uni.camera)

