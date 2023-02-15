cat("/014") # Clear console
rm(list=ls())# Clean workspace

set.seed(2023)  #Set seed for reproducibility

#===============================================================
# Repositories:

dir.repository <- c('C:/Users/famendezrios/Documents/Felipe_MENDEZ/GitHub/Aquatic_vegetation')
dir.data <- c('Data')
dir.source <- c('Sources')
dir.cvl <- c('David_Besson_CVL/Extraction_information')
dir.jaugeages <- c('jaugeages')
dir.courbe_corr <- c('courbe_correction_hydrometres')
dir.bourgogne <- c('Erwin_Le_Barbu_Bourgogne') 

setwd(dir.repository)

#===============================================================
# Libraries:
library(stringr)
library(ggplot2)

# Initialization
log_extraction = F
data_bareme_extraction = 'jeu_de_donnes_courbes_correction'    # jeu_de_donnes_jaugeages or jeu_de_donnes_courbes_correction

# Load functions
source(file=file.path(dir.repository,dir.source,'Functions.R'))

# File path 
station_extraction <- file.path(dir.repository,dir.data,dir.cvl,dir.courbe_corr)    #dir.jaugeages or dir.courbe_corr

#===============================================================
# script to read information of gauging of Bareme
#===============================================================

if(log_extraction==T){
  extraction_data <- extraction(dir_data_ext=station_extraction,
                                data_exraction=data_bareme_extraction)
  stations_info <- extraction_data[[1]]
  Dh_station_info <-   extraction_data[[2]]
  nom_station <-   extraction_data[[3]]
  
}else{   # Only for CVL stations!!
  load(file = file.path(station_extraction,data_bareme_extraction,'database_to_explore.RData')) #Dh_station_info
  load(file = file.path(station_extraction,data_bareme_extraction,'nom_station_organisation.RData')) #nom_station
  load(file = file.path(station_extraction,data_bareme_extraction,'database.RData')) #stations_info
}

stations_info_complet <- NULL
Dh_station_info_complet <- NULL
for(i in 1:length(Dh_station_info)){
  stations_info[[i]]$Date=as.POSIXct(stations_info[[i]]$Date,format="%d/%m/%Y %H:%M",tz = "GMT")
  Dh_station_info[[i]]$Date=as.POSIXct(Dh_station_info[[i]]$Date,format="%d/%m/%Y %H:%M",tz = "GMT")
  
  stations_info_complet <- rbind(stations_info_complet,stations_info[[i]])
  Dh_station_info_complet <- rbind(Dh_station_info_complet,Dh_station_info[[i]])
}

  ggplot(Dh_station_info_complet,aes(Date,`Dh(cm)`))+
    geom_point(aes(colour=factor(id)),alpha=0.5)+
    labs(title='Courbe de correction',
         x='Date (année)',
         y='Dh (cm)',
         colour='Station')+
    theme_bw()+
    scale_y_reverse()+
    theme(plot.title = element_text(size=16,
                                    hjust=0.5),
          )
