cat("/014") # Clear console
rm(list=ls())# Clean workspace

set.seed(2023)  #Set seed for reproducibility

#===============================================================
# Repositories:

dir.repository <- c('C:/Users/famendezrios/Documents/Felipe_MENDEZ/GitHub/Aquatic_vegetation')
dir.data <- c('Data')
dir.source <- c('Source')
dir.cvl <- c('David_Besson_CVL/Extraction_information')
dir.jaugeages <- c('jaugeages')
dir.courbe_corr <- c('courbe_correction_hydrometres')
dir.bourgogne <- c('Erwin_Le_Barbu_Bourgogne') 

setwd(dir.repository)

#===============================================================
# Libraries:
library(stringr)

# Initialization
log_extraction = F

# Load functions
source(file=file.path(dir.repository,dir.source,'Functions.R'))

# File path 
station_extraction <- file.path(dir.repository,dir.data,dir.cvl,dir.jaugeages)

#===============================================================
# script to read information of gauging of Bareme
#===============================================================

extraction(dir_data_ext=station_extraction)


dir_jaugeages <- file.path(dir_data,'jaugeages')
file_stations_info <- list.files(dir_jaugeages,pattern ='.txt')

setwd(dir_jaugeages)

stations_info_jaugeages = NULL
nom_station = NULL

for (i in 1:length(file_stations_info)){
  
  station_temp <- file_stations_info[i]
  nom_station <- rbind(nom_station,gsub('.{4}$', '', file_stations_info[i]))
  
  stations_info_jaugeages[[i]] <- read.table(file= file.path(dir_jaugeages,station_temp),
                                             sep = "\t",
                                             na.string="",
                                             fill=T,
                                             skip = 1)
  colnames(stations_info_jaugeages[[i]]) <- c('Date','No_jau','h(cm)','Q(m3/s)','Dh(cm)','Mode_jau','Inc_rel_Q_val','Inc_rel_Q_cal')
  
  Dh_id <- which(!is.na(stations_info_jaugeages[[i]]$`Dh(cm)`)==T)
  Limit_Dh <- which(!is.na(stations_info_jaugeages[[i]]$`Dh(cm)`)==F)
  
  start_veg <- Limit_Dh[which(diff(Limit_Dh)!=1)]
  end_veg <- Limit_Dh[which(diff(Limit_Dh)!=1)+1]
  
  id_veg_start_end <- sort(c(start_veg,end_veg),decreasing=F)
  
  dh_id_start_end <- sort(c(Dh_id,id_veg_start_end),decreasing=F)
  
  Dh_station_info_jau <- stations_info_jaugeages[[i]][dh_id_start_end,]
  
  write.table(Dh_station_info_jau, file=paste0(dir_jaugeages,
                                               '/jeu_de_donnes_jaugeages/',
                                               nom_station[i],'_tri.txt'), sep = '\t',row.names = F)
  
}

save(stations_info_jaugeages, file=paste0(dir_jaugeages,'/jeu_de_donnes_jaugeages/donnes_explorer_CVL.RData'))
save(nom_station, file=paste0(dir_jaugeages,'/jeu_de_donnes_jaugeages/nom_station_organisation.RData'))


###########################################################
# script to read information of correction curve of Bareme
###########################################################

dir_corr_curve <- file.path(dir_data,'courbe_correction_hydrometres')
file_stations_info <- list.files(dir_corr_curve,pattern ='.txt')

setwd(dir_corr_curve)

stations_info_corr_curve = NULL
nom_station = NULL

for (i in 1:length(file_stations_info)){
  
  station_temp <- file_stations_info[i]
  nom_station <- rbind(nom_station,gsub('.{4}$', '', file_stations_info[i]))
  
  stations_info_corr_curve[[i]] <- read.table(file= file.path(dir_corr_curve,station_temp),
                                              sep = "\t",
                                              skip = 1)
  
  if(length(which(is.na(stations_info_corr_curve[[i]]$V2)==T))!=0){
    stations_info_corr_curve[[i]] <- stations_info_corr_curve[[i]][-c(which(is.na(stations_info_corr_curve[[i]]$V2)==T)),]
  }
  
  stations_info_corr_curve[[i]][,2] <- stations_info_corr_curve[[i]][,2]/100
  
  colnames(stations_info_corr_curve[[i]]) <- c('Date','Dh(cm)')
  
  write.table(stations_info_corr_curve[[i]], file=paste0(dir_corr_curve,
                                                         '/jeu_de_donnes_courbes_correction/',
                                                         nom_station[i],'_tri.txt'), sep = '\t',row.names = F)
  
}

save(stations_info_corr_curve, file=paste0(dir_corr_curve,'/jeu_de_donnes_courbes_correction/donnes_explorer_CVL.RData'))
save(nom_station, file=paste0(dir_corr_curve,'/jeu_de_donnes_courbes_correction/nom_station_organisation.RData'))


