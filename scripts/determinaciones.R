library(tidyverse)
library(readr)
library(readxl)
library(janitor)
library(stringr)
library(lubridate)
library(plotly)


determinacion  <- base %>% select(IDEVENTOCASO,poblacion, SEPI_FECHA_INTER,
                                  COVID_19_FINAL, VSR_FINAL, INFLUENZA_FINAL)


negativos <- determinacion %>% 
  filter(COVID_19_FINAL == 'Negativo',
         VSR_FINAL == 'Negativo',
         INFLUENZA_FINAL == 'Negativo') %>% 
  select(IDEVENTOCASO, poblacion, SEPI_FECHA_INTER, COVID_19_FINAL) %>% 
  rename(Determinacion = COVID_19_FINAL)






vsr <- determinacion %>% filter(VSR_FINAL != 'Negativo') %>% 
       select(IDEVENTOCASO,poblacion, SEPI_FECHA_INTER, VSR_FINAL) %>% 
       rename(Determinacion = VSR_FINAL)


influenza <- determinacion %>% filter(INFLUENZA_FINAL != 'Negativo') %>% 
             select(IDEVENTOCASO,poblacion, SEPI_FECHA_INTER, INFLUENZA_FINAL) %>% 
              rename(Determinacion = INFLUENZA_FINAL)


sar_cov <- determinacion %>% filter(COVID_19_FINAL != 'Negativo') %>% 
           select(IDEVENTOCASO, poblacion, SEPI_FECHA_INTER, COVID_19_FINAL) %>% 
           rename(Determinacion = COVID_19_FINAL)



deteterm_resumen <- rbind(negativos, vsr, influenza, sar_cov) %>% 
                    mutate(Determinacion = case_when(Determinacion == 'Sin resultado'~ 'En estudio',
                                                     Determinacion == 'Positivo' ~ 'Sars-Cov2',
                                         str_detect(Determinacion, 'VSR') ~ 'VSR',
                                         str_detect(Determinacion, 'Influenza') ~ 'Influenza',
                                                     T ~ Determinacion) ) %>% 
                    count(SEPI_FECHA_INTER,poblacion, Determinacion) 
                    





deteterm_resumen$Determinacion <- factor(deteterm_resumen$Determinacion,
                                         levels = c("Negativo", "En estudio","Sars-Cov2",
                                                    "Influenza", "VSR"))



g <- ggplot(deteterm_resumen) +
  geom_bar(aes(x = SEPI_FECHA_INTER, y =n , fill = Determinacion ,
               text = paste( 'Semana ', SEPI_FECHA_INTER, '<br>',
                             Determinacion, '<br>',
                             n)), 
           stat = 'identity', width = 1) +
  theme_classic() +
  scale_x_continuous(breaks = seq(1, 52,2)) +
  scale_y_continuous(breaks = seq(0,100,2)) +
  scale_fill_manual(values = c('#bdbdbd', '#969696', '#74a9cf', 
                                '#78c679', '#fecc5c' )) +
  labs( title = '', 
        fill = '',
        x = 'Semana de Internación', y = 'Eventos',) +
  theme(plot.title = element_text(hjust = 0.5, size = 13))+
#  theme(legend.position = 'none') +
  facet_wrap(~ poblacion, ncol = 1)

grafico_virus <- ggplotly(g, tooltip = c("text"))










