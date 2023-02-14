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

# Initialization
log_extraction = T 
data_bareme_extraction = 'jeu_de_donnes_jaugeages'    # jeu_de_donnes_jaugeages or jeu_de_donnes_courbes_correction

# Load functions
source(file=file.path(dir.repository,dir.source,'Functions.R'))

# File path 
station_extraction <- file.path(dir.repository,dir.data,dir.cvl,dir.jaugeages)    #dir.jaugeages or dir.courbe_corr

#===============================================================
# script to read information of gauging of Bareme
#===============================================================

if(log_extraction==T){
  extraction(dir_data_ext=station_extraction,
             data_exraction=data_bareme_extraction)
}


