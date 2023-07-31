###DESCRIPTION This code reads the survey file(s) and 1) copies pictures categorized by species into 
#by species subfolders the code creates and 2) copies pictures by camera into
#by camera subfolders the code creates to facilitate checking that (1) pics were 
#assigned correctly to species and (2) pics were assigned correctly to camera

###DATE 5/8/2023
###UPDATE 6/23/2023 I added the description above; deleted previous pictures in the QAQC folder (30gb!); and switched to the AllAnimalCaptures xls

library(readxl)

##PATHS AND FILES HERE WILL NEED TO BE UDPATED:
# cam_surveyA1 <- read_excel("C:\\Users\\vasteen\\Documents\\EAFB\\Analysis_camera\\Task 1 - Camera Trapping Data-20230427T203950Z-001\\Task 1 - Camera Trapping Data\\CameraTrappingData_SurveyA1.xlsx")
# #two sheets:
# cam_surveyA2.1 <- read_excel("C:\\Users\\vasteen\\Documents\\EAFB\\Analysis_camera\\Task 1 - Camera Trapping Data-20230427T203950Z-001\\Task 1 - Camera Trapping Data\\CameraTrappingData_SurveyA2.xlsx",sheet = 1)
# cam_surveyA2.2 <- read_excel("C:\\Users\\vasteen\\Documents\\EAFB\\Analysis_camera\\Task 1 - Camera Trapping Data-20230427T203950Z-001\\Task 1 - Camera Trapping Data\\CameraTrappingData_SurveyA2.xlsx",sheet = 2)
# cam_surveyA2 <- rbind(cam_surveyA2.1,cam_surveyA2.2);rm(cam_surveyA2.1);rm(cam_surveyA2.2)
# 
# #two sheets:
# cam_surveyB1.1 <- read_excel("C:\\Users\\vasteen\\Documents\\EAFB\\Analysis_camera\\Task 1 - Camera Trapping Data-20230427T203950Z-001\\Task 1 - Camera Trapping Data\\CameraTrappingData_SurveyB1.xlsx",sheet = 1)
# cam_surveyB1.2 <- read_excel("C:\\Users\\vasteen\\Documents\\EAFB\\Analysis_camera\\Task 1 - Camera Trapping Data-20230427T203950Z-001\\Task 1 - Camera Trapping Data\\CameraTrappingData_SurveyB1.xlsx",sheet = 2)
# cam_surveyB1 <- rbind(cam_surveyB1.1,cam_surveyB1.2);rm(cam_surveyB1.1);rm(cam_surveyB1.2)
# cam_surveyB2 <- read_excel("C:\\Users\\vasteen\\Documents\\EAFB\\Analysis_camera\\Task 1 - Camera Trapping Data-20230427T203950Z-001\\Task 1 - Camera Trapping Data\\CameraTrappingData_SurveyB2.xlsx")

allanimalcaptures <- read_excel("C:\\Users\\vasteen\\Documents\\EAFB\\Analysis_camera\\AllAnimalCaptures06232023.xlsx")
head(allanimalcaptures)
mainstem <- "N:\\RStor\\jaw\\goea\\Edwards Large Mammal\\Images"


############
#####Copy pics by species into QAQC, creating subfolders for each species
############

copyBySpeciesFcn <- function(species,survey){
pics.sppColumn1 <- survey[which(survey$species1 %in% species),]
pics.sppColumn2 <- survey[which(survey$species2 %in% species),]
pics.df <- rbind(pics.sppColumn1,pics.sppColumn2)
to = paste0(mainstem,"\\","QAQC","\\",species,"\\")
if (!dir.exists(to)){
  dir.create(to)
}else{
  print("dir.exists")
}
print(species)
print("number of pics")
print(nrow(pics.df))
for(i in 1:nrow(pics.df)){
year <- pics.df[i,"Folder"]
RelativePath <- pics.df[i,"RelativePath"]
picture <- pics.df[i,"File"]
file.copy(from = paste0(mainstem,"\\", year,"\\",RelativePath,"\\",picture),
          to = to)
}
}#end function

###SURVEY A1
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

