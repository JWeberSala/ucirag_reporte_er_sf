library(tidyverse)
library(readr)
library(readxl)
library(janitor)
library(stringr)
library(lubridate)


anio_reporte <- year(today())


base <- read_csv2('data/UC_IRAG_EST80089.csv',
                  locale = locale(encoding = "WINDOWS-1252")) %>% 
        dplyr:: filter(
                      year(FECHA_MINIMA) == anio_reporte ,
                      CLASIFICACION_MANUAL != 'Caso invalidado por epidemiología',
                      !is.na(FTM_MOLECULAR)
                      ) %>% 
        dplyr:: mutate(poblacion = ifelse(EDAD_DIAGNOSTICO <15, 'Pediatrica', 'Adultos'),
                       EDAD_UC_IRAG_2 = case_when(EDAD_UC_IRAG == '0 a 2 Meses' ~ 'Menores de 6 Meses',
                                           EDAD_UC_IRAG == '3 a 5 Meses' ~ 'Menores de 6 Meses',
                                           T ~ EDAD_UC_IRAG))
  
             
# Sacamos la última semana
max_se_int <- (max(base$SEPI_FECHA_INTER, na.rm = T) - 1)
base <- base %>% dplyr::filter(SEPI_FECHA_INTER <= max_se_int)


base$EDAD_UC_IRAG_2 <- factor(base$EDAD_UC_IRAG_2,
                              levels = c("Menores de 6 Meses", "6 a 11 Meses",
                                         "12 a 23 Meses", '02 a 04 Años', 
                                         '05 a 09 Años','10 a 14 Años', 
                                         '15 a 19 Años','20 a 24 Años', 
                                         '25 a 29 Años', "30 a 34 Años",
                                         "35 a 39 Años", "40 a 44 Años",
                                         "45 a 49 Años","50 a 54 Años",
                                         "55 a 59 Años", "60 a 64 Años",
                                         "65 a 69 Años", "70 a 74 Años",
                                         "75 y más Años"))



# Total de eventos, pediatricos y adultos

# casos_tot <- base %>% 
#              dplyr:: count(poblacion, CLASIFICACION_MANUAL) %>% 
#              pivot_wider(names_from = CLASIFICACION_MANUAL, values_from = n) %>% 
#              adorn_totals('col') %>% 
#              adorn_totals()









