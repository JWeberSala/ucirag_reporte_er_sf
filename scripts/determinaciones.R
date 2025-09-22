library(tidyverse)
library(readr)
library(readxl)
library(janitor)
library(stringr)
library(lubridate)
library(plotly)
library(flextable)

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







det_ <- determinacion %>% 
  mutate(COVID_19_FINAL = ifelse(COVID_19_FINAL =='Positivo','Sars-Cov2',COVID_19_FINAL),
         covid_num = ifelse(COVID_19_FINAL != 'Negativo', 1, 0),
         vsr_num = ifelse(!VSR_FINAL %in%c('Negativo', 'Sin resultado'), 1,0),
         flu_num = ifelse(INFLUENZA_FINAL != 'Negativo', 1, 0),
         suma = (covid_num + vsr_num + flu_num)
  ) %>% 
  mutate(determ_final = case_when(suma == 0 ~ 'Negativos',
                                  suma == 1 & covid_num == 1 ~ COVID_19_FINAL,
                                  suma == 1 & vsr_num == 1 ~ VSR_FINAL,
                                  suma == 1 & flu_num == 1 ~ INFLUENZA_FINAL,
                                  suma >1 ~  paste( COVID_19_FINAL,'-', VSR_FINAL,'-', INFLUENZA_FINAL)
  ))




num_determ_detectadas <- nrow(det_ %>% filter(determ_final != 'Negativos'))

num_codeteccion <- nrow(det_ %>% filter(suma >1))

tbl_determ <- det_ %>% filter(determ_final != 'Negativos', suma == 1) %>% 
  count(poblacion, determ_final) %>% 
  pivot_wider(names_from = poblacion, values_from = n, values_fill = 0) %>% 
  adorn_totals()

num_virus <- nrow(tbl_determ)

tabla_virus <- flextable(tbl_determ) %>% 
  set_header_labels (determ_final = 'Agente etiológico', Pediatrica = 'Pediatricos') %>% 
  width(j = 1, width = 2.5) %>% 
  width(j = c(2:3)  , width = 0.7) %>% 
  bold(i = num_virus) 




#frases según si hay o no codeteccion

frase_codeteccion <- ifelse (num_codeteccion==0, 
                             "Durante el período no se registraron casos positivos con más de un agente etiológico.", 
                             paste0("Durante el período se registraron ", num_codeteccion, "casos con detección de más de un agente etiológico."))




