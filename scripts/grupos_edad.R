library(tidyverse)
library(readr)
library(readxl)
library(janitor)
library(stringr)
library(lubridate)


source('scripts/leer_base.R')




tbl_edad <- base%>% count(CLASIFICACION_MANUAL, EDAD_UC_IRAG_2) 




g <- ggplot(tbl_edad) +
  geom_bar(aes(x = EDAD_UC_IRAG_2, y = n, fill = CLASIFICACION_MANUAL,
               text = paste( CLASIFICACION_MANUAL, '<br>',
                             EDAD_UC_IRAG_2 , '<br>',
                            'Eventos:',  n)), 
           stat = 'identity') +
 # theme(legend.position = "bottom")+
  theme_bw()+
  theme(axis.text.x=element_text(angle= 30, hjust = 1)) +
  labs( title = 'Grupos Edad', 
        fill = '',
        x = 'Grupos de edad', y = 'Eventos',) +
  theme(plot.title = element_text(hjust = 0.5, size = 13),legend.position = 'none') +
  scale_fill_manual(values = c('lightblue', 'lightgreen'))
 

 
grafico_edad <- ggplotly(g, tooltip = c("text"))









