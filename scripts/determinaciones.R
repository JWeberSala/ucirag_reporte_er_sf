library(tidyverse)
library(readr)
library(readxl)
library(janitor)
library(stringr)
library(lubridate)
library(plotly)


determinacion  <- base %>% select(IDEVENTOCASO, SEPI_FECHA_INTER,
                                  COVID_19_FINAL, VSR_FINAL, INFLUENZA_FINAL)


negativos <- determinacion %>% 
  filter(COVID_19_FINAL == 'Negativo',
         VSR_FINAL == 'Negativo',
         INFLUENZA_FINAL == 'Negativo') %>% 
  select(IDEVENTOCASO, SEPI_FECHA_INTER, COVID_19_FINAL) %>% 
  rename(Determinacion = COVID_19_FINAL)






vsr <- determinacion %>% filter(VSR_FINAL != 'Negativo') %>% 
       select(IDEVENTOCASO, SEPI_FECHA_INTER, VSR_FINAL) %>% 
       rename(Determinacion = VSR_FINAL)


influenza <- determinacion %>% filter(INFLUENZA_FINAL != 'Negativo') %>% 
             select(IDEVENTOCASO, SEPI_FECHA_INTER, INFLUENZA_FINAL) %>% 
              rename(Determinacion = INFLUENZA_FINAL)


sar_cov <- determinacion %>% filter(COVID_19_FINAL != 'Negativo') %>% 
           select(IDEVENTOCASO, SEPI_FECHA_INTER, COVID_19_FINAL) %>% 
           rename(Determinacion = COVID_19_FINAL)



deteterm_resumen <- rbind(negativos, vsr, influenza, sar_cov) %>% 
                    count(SEPI_FECHA_INTER, Determinacion) %>% 
                    mutate(Determinacion = case_when(Determinacion == 'Sin resultado'~ 'En estudio',
                                                     Determinacion == 'Positivo' ~ 'Sars-Cov2',
                                                     T ~ Determinacion) )
                    


deteterm_resumen$Determinacion <- factor(deteterm_resumen$Determinacion,
                                         levels = c("Negativo", "En estudio","Sars-Cov2",
                                                    "VSR", "VSR A", "VSR B", 
                                                    "Influenza A H1N1", "Influenza A (sin subtipificar)"))



g <- ggplot(deteterm_resumen) +
  geom_bar(aes(x = SEPI_FECHA_INTER, y =n , fill = Determinacion ,
               text = paste( Determinacion, '<br>',
                             n)), 
           stat = 'identity', width = 1) +
  theme_classic() +
  scale_x_continuous(breaks = seq(1, 52,1)) +
  scale_fill_manual(values = c('#bdbdbd', '#969696', '#74a9cf', 
                               '#c2e699', '#78c679', '#238443',
                               '#fecc5c', '#fd8d3c')) +
  labs( title = '', 
        fill = '',
        x = 'Semana de Internación', y = 'Eventos',) +
  theme(plot.title = element_text(hjust = 0.5, size = 13), legend.position = 'none')+
  theme(legend.position = 'none')

grafico_virus <- ggplotly(g, tooltip = c("text"))










