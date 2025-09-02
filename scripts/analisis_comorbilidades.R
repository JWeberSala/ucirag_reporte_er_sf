library(tidyverse)
library(readr)
library(readxl)
library(janitor)
library(stringr)
library(lubridate)
library(plotly)

#análisis para las comorbildiades de IRAG

B_COMORBILIDADES_IRAG<-base %>% 
  filter(CLASIFICACION_MANUAL=="Infección respiratoria aguda grave (IRAG)") %>% 
  mutate(PRESENCIA_COMORBILIDADES=case_when(
    PRESENCIA_COMORBILIDADES == 1 ~ "Con Comorbilidades",
    PRESENCIA_COMORBILIDADES == 2 ~ "Sin Comorbilidades",
    PRESENCIA_COMORBILIDADES == 9 ~ "Sin Dato de Comorbilidades",
  )
  )


grupos_edad <- c("Menores de 6 Meses", "6 a 11 Meses",
                 "12 a 23 Meses", '02 a 04 Años', 
                 '05 a 09 Años','10 a 14 Años', 
                 '15 a 19 Años','20 a 24 Años', 
                 '25 a 29 Años', "30 a 34 Años",
                 "35 a 39 Años", "40 a 44 Años",
                 "45 a 49 Años","50 a 54 Años",
                 "55 a 59 Años", "60 a 64 Años",
                 "65 a 69 Años", "70 a 74 Años",
                 "75 y más Años")


IRAG_COMORBILIDADES<-B_COMORBILIDADES_IRAG %>%
  group_by(EDAD_UC_IRAG_2, PRESENCIA_COMORBILIDADES) %>%
  summarise(N= n())

  
 #Gráfico IRAG ABSOLUTO

IRAG_COMORBILIDADES_BARRAS_FIG <- plot_ly(
  IRAG_COMORBILIDADES,
  x = ~EDAD_UC_IRAG_2,
  y = ~N,
  color = ~PRESENCIA_COMORBILIDADES,
  type = 'bar'
)

IRAG_COMORBILIDADES_BARRAS_FIG <- IRAG_COMORBILIDADES_BARRAS %>% layout(
  barmode = 'stack',
  yaxis = list(title = "Casos de IRAG"),
  xaxis = list(title = "Grupo de Edad")
)

IRAG_COMORBILIDADES_BARRAS_FIG



#Gráfico IRAG RELATIVO
IRAG_COMORBILIDADES_RELATIVO<- IRAG_COMORBILIDADES %>% 
  group_by(EDAD_UC_IRAG_2) %>%
  mutate(Proporcion = N / sum(N) * 100)


IRAG_COMORBILIDADES_RELATIV_FIG<- plot_ly(
  IRAG_COMORBILIDADES_RELATIVO,
  x = ~EDAD_UC_IRAG_2,
  y = ~Proporcion,
  color = ~PRESENCIA_COMORBILIDADES,
  type = 'bar'
)

IRAG_COMORBILIDADES_RELATIV_FIG <- IRAG_COMORBILIDADES_RELATIV_FIG %>% layout(
  barmode = 'stack',
  yaxis = list(title = "Porcentaje", ticksuffix = "%"),
  xaxis = list(title = "Grupo de Edad")
)

IRAG_COMORBILIDADES_RELATIV_FIG



#Según resultado de laboratorio, para casos de Influenza, VSR y SARS CoV 2

#Influenza

Tabla_Comorbilidades_Flu<-B_COMORBILIDADES_IRAG %>% 
  filter(INFLUENZA_FINAL!="Sin resultado" & INFLUENZA_FINAL!="Negativo") %>% 
  group_by(EDAD_UC_IRAG_2, PRESENCIA_COMORBILIDADES) %>%
  summarise(N= n(), .groups = "drop")%>%
  mutate(EDAD_UC_IRAG_2 = as.character(EDAD_UC_IRAG_2))

Tabla_Comorbilidades_Flu <- Tabla_Comorbilidades_Flu %>%
  mutate(
    EDAD_UC_IRAG_2 = factor(EDAD_UC_IRAG_2, levels = grupos_edad)
  )

Tabla_Comorbilidades_Flu <- Tabla_Comorbilidades_Flu %>%
  complete(
    PRESENCIA_COMORBILIDADES,
    EDAD_UC_IRAG_2,
    fill = list(N = 0)
  )



FLU_COMORBILIDADES_BARRAS_FIG <- plot_ly(
  Tabla_Comorbilidades_Flu,
  x = ~EDAD_UC_IRAG_2,
  y = ~N,
  color = ~PRESENCIA_COMORBILIDADES,
  type = 'bar'
)

FLU_COMORBILIDADES_BARRAS_FIG <- FLU_COMORBILIDADES_BARRAS_FIG %>% layout(
  barmode = 'stack',
  yaxis = list(title = "IRAG con diagnóstico de Influenza"),
  xaxis = list(title = "Grupo de Edad")
)

FLU_COMORBILIDADES_BARRAS_FIG





#VSR


Tabla_Comorbilidades_VSR<-B_COMORBILIDADES_IRAG %>% 
  filter(VSR_FINAL!="Sin resultado" & VSR_FINAL!="Negativo") %>% 
  group_by(EDAD_UC_IRAG_2, PRESENCIA_COMORBILIDADES) %>%
  summarise(N= n(), .groups = "drop")%>%
  mutate(EDAD_UC_IRAG_2 = as.character(EDAD_UC_IRAG_2))

Tabla_Comorbilidades_VSR <- Tabla_Comorbilidades_VSR %>%
  mutate(
    EDAD_UC_IRAG_2 = factor(EDAD_UC_IRAG_2, levels = grupos_edad)
  )

Tabla_Comorbilidades_VSR <- Tabla_Comorbilidades_VSR %>%
  complete(
    PRESENCIA_COMORBILIDADES,
    EDAD_UC_IRAG_2,
    fill = list(N = 0)
  )


VSR_COMORBILIDADES_BARRAS_FIG <- plot_ly(
  Tabla_Comorbilidades_VSR,
  x = ~EDAD_UC_IRAG_2,
  y = ~N,
  color = ~PRESENCIA_COMORBILIDADES,
  type = 'bar'
)

VSR_COMORBILIDADES_BARRAS_FIG <- VSR_COMORBILIDADES_BARRAS_FIG %>% layout(
  barmode = 'stack',
  yaxis = list(title = "IRAG con diagnóstico de SARS-CoV-2"),
  xaxis = list(title = "Grupo de Edad")
)

VSR_COMORBILIDADES_BARRAS_FIG




#SARS COV2  



##ACA NO HAY CASOS DE SARS, POR LO QUE DEBERÍAMOS VER COMO CREAR UNA FUNCION QUE SI NO HAY CASOS, NO LOS DESCRIBA. PERO SI APARECEN SI DESCRIBIRLOS####
unique(B_COMORBILIDADES_IRAG$COVID_19_FINAL)
Tabla_Comorbilidades_COVID<-B_COMORBILIDADES_IRAG %>% 
  filter(COVID_19_FINAL!="Sin resultado" & COVID_19_FINAL!="Negativo") %>% 
  group_by(EDAD_UC_IRAG_2, PRESENCIA_COMORBILIDADES) %>%
  summarise(N= n(), .groups = "drop")%>%
  mutate(EDAD_UC_IRAG_2 = as.character(EDAD_UC_IRAG_2))

Tabla_Comorbilidades_COVID <- Tabla_Comorbilidades_COVID %>%
  mutate(
    EDAD_UC_IRAG_2 = factor(EDAD_UC_IRAG_2, levels = grupos_edad)
  )

Tabla_Comorbilidades_COVID <- Tabla_Comorbilidades_COVID %>%
  complete(
    PRESENCIA_COMORBILIDADES,
    EDAD_UC_IRAG_2,
    fill = list(N = 0)
  )


covid_COMORBILIDADES_BARRAS_FIG <- plot_ly(
  Tabla_Comorbilidades_COVID,
  x = ~EDAD_UC_IRAG_2,
  y = ~N,
  color = ~PRESENCIA_COMORBILIDADES,
  type = 'bar'
)

covid_COMORBILIDADES_BARRAS_FIG <- covid_COMORBILIDADES_BARRAS_FIG %>% layout(
  barmode = 'stack',
  yaxis = list(title = "IRAG con diagnóstico de VSR"),
  xaxis = list(title = "Grupo de Edad")
)

covid_COMORBILIDADES_BARRAS_FIG

















Tabla_Comorbilidades_IRAG<-orden_edad_uc_irag %>% 
  left_join(Tabla_Comorbilidades_Flu, by="EDAD_UC_IRAG") %>% 
  left_join(Tabla_Comorbilidades_VSR, by="EDAD_UC_IRAG") %>% 
  left_join(Tabla_Comorbilidades_COVID, by="EDAD_UC_IRAG") 

rm(Tabla_Comorbilidades_Flu, Tabla_Comorbilidades_VSR,
   Tabla_Comorbilidades_COVID)



#PARA IRAG EXTENDIDA


B_COMORBILIDADES_IRAG_ext<-base %>% 
  filter(CLASIFICACION_MANUAL=="IRAG extendida") %>% 
  filtrar_por_rango(anio_actual, 
                    se_actual, 
                    rango = 1, 
                    col_anio = "ANIO_MIN_INTERNACION", 
                    col_semana = "SEPI_MIN_INTERNACION")






Tabla_Comorbilidades_Flu<-B_COMORBILIDADES_IRAG_ext %>% 
  filter(INFLUENZA_FINAL!="Sin resultado" & INFLUENZA_FINAL!="Negativo") %>% 
  group_by(EDAD_UC_IRAG, PRESENCIA_COMORBILIDADES) %>%
  summarise(N= n()) %>% 
  spread( PRESENCIA_COMORBILIDADES, N) %>% 
  rename("Influenza Con Comorbilidades"="1", 
         "Influenza Sin Comorbilidades"="2",
         "Influenza SD Comorbilidades"="9")


Tabla_Comorbilidades_VSR<-B_COMORBILIDADES_IRAG_ext %>% 
  filter(VSR_FINAL!="Sin resultado" & VSR_FINAL!="Negativo") %>% 
  group_by(EDAD_UC_IRAG, PRESENCIA_COMORBILIDADES) %>%
  summarise(N= n()) %>% 
  spread( PRESENCIA_COMORBILIDADES, N) %>% 
  rename("VSR Con Comorbilidades"="1", 
         "VSR Sin Comorbilidades"="2",
         "VSR SD Comorbilidades"="9")

Tabla_Comorbilidades_COVID<-B_COMORBILIDADES_IRAG_ext %>% 
  filter(COVID_19_FINAL!="Sin resultado" & COVID_19_FINAL!="Negativo") %>% 
  group_by(EDAD_UC_IRAG, PRESENCIA_COMORBILIDADES) %>%
  summarise(N= n()) %>% 
  spread( PRESENCIA_COMORBILIDADES, N) %>% 
  rename("SARS COV2 Con Comorbilidades"="1", 
         "SARS COV2  Sin Comorbilidades"="2",
         "SARS COV2  SD Comorbilidades"="9")


Tabla_Comorbilidades_IRAG_ext<-orden_edad_uc_irag %>% 
  left_join(Tabla_Comorbilidades_Flu, by="EDAD_UC_IRAG") %>% 
  left_join(Tabla_Comorbilidades_VSR, by="EDAD_UC_IRAG") %>% 
  left_join(Tabla_Comorbilidades_COVID, by="EDAD_UC_IRAG") 

rm(Tabla_Comorbilidades_Flu, Tabla_Comorbilidades_VSR,
   Tabla_Comorbilidades_COVID)

