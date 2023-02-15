#====================================================================
# Functions for estimation of discharge on stations impacted 
# by the aquatic vegetation
#====================================================================

#====================================================================
# script to read information of gauging or correction curve of Bareme
#====================================================================

extraction <- function(dir_data_ext,data_exraction){
  
  file_stations_info <- list.files(dir_data_ext,pattern ='.txt')
  
  setwd(dir_data_ext)
  
  stations_info = NULL
  Dh_station_info = NULL
  nom_station = NULL
  
  if(data_exraction=='jeu_de_donnes_jaugeages'){
    colnames_colonnes <- c('Date','No_jau','h(cm)','Q(m3/s)','Dh(cm)','Mode_jau','Inc_rel_Q_val','Inc_rel_Q_cal','id')
  }else{
    colnames_colonnes <- c('Date','Dh(cm)','id')
  }
  
  for (i in 1:length(file_stations_info)){
    
    station_temp <- file_stations_info[i]
    nom_station <- rbind(nom_station,gsub('.{4}$', '', file_stations_info[i]))
    
    stations_info[[i]] <- read.table(file= file.path(dir_data_ext,station_temp),
                                               sep = "\t",
                                               na.string="",
                                               fill=T,
                                               skip = 1)
    stations_info[[i]] <- cbind(stations_info[[i]],rep(i,nrow(stations_info[[i]])))
    
    colnames(stations_info[[i]]) <- colnames_colonnes
    
    if(data_exraction!='jeu_de_donnes_jaugeages'){
      stations_info[[i]]$`Dh(cm)`  <- stations_info[[i]]$`Dh(cm)`/10 
    }
    
    Dh_id <- which(!is.na(stations_info[[i]]$`Dh(cm)`)==T)
    Limit_Dh <- which(!is.na(stations_info[[i]]$`Dh(cm)`)==F)
    
    start_veg <- Limit_Dh[which(diff(Limit_Dh)!=1)]
    end_veg <- Limit_Dh[which(diff(Limit_Dh)!=1)+1]
    
    id_veg_start_end <- sort(c(start_veg,end_veg),decreasing=F)
    
    dh_id_start_end <- sort(c(Dh_id,id_veg_start_end),decreasing=F)
    
    Dh_station_info[[i]] <- stations_info[[i]][dh_id_start_end,]
    
    write.table(Dh_station_info[[i]], file=paste0(dir_data_ext,
                                                 '/',data_exraction,'/',
                                                 nom_station[i],'_tri.txt'), sep = '\t',row.names = F)
    
  }
  
  save(stations_info, file=paste0(dir_data_ext,'/',data_exraction,'/database.RData'))
  save(Dh_station_info, file=paste0(dir_data_ext,'/',data_exraction,'/database_to_explore.RData'))
  save(nom_station, file=paste0(dir_data_ext,'/',data_exraction,'/nom_station_organisation.RData'))
  
  return(list(stations_info,Dh_station_info,nom_station))
}


