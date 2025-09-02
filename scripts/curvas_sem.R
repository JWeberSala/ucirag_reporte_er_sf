library(tidyverse)
library(readr)
library(readxl)
library(janitor)
library(stringr)
library(lubridate)
library(plotly)


source('scripts/leer_base.R')


tbl_curvas <- base %>% 
              count(SEPI_FECHA_INTER, poblacion)


g <- ggplot(tbl_curvas) +
  geom_bar(aes(x = SEPI_FECHA_INTER, y = n, fill = poblacion,
               text = paste( 'Semana ', SEPI_FECHA_INTER, '<br>',
                            'Eventos:',  n)), 
           stat = 'identity', width = 1) +
  facet_wrap(~poblacion, ncol = 1) +
  theme_bw() +
  scale_x_continuous(breaks = seq(1,52,1)) +
  scale_y_continuous(breaks = seq(0, 10, 2)) +
  scale_fill_manual(values = c('lightblue', 'lightgreen'))+
  labs( title = 'Eventos según semana de internación', 
        fill = '',
        x = 'Semana de Internación', y = 'Eventos',) +
  theme(plot.title = element_text(hjust = 0.5, size = 13))

  
grafico_curvas <- ggplotly(g, tooltip = c("text")) 

  





  
