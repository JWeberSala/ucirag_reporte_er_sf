library(tidyverse)
library(readr)
library(readxl)
library(janitor)
library(stringr)
library(lubridate)
library(plotly)

#análisis para las comorbildiades de IRAG
unique(base$CLASIFICACION_MANUAL)
B_COMORBILIDADES_IRAG<-base %>% 
  #filter(CLASIFICACION_MANUAL=="Infección respiratoria aguda grave (IRAG)") %>% 
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
  group_by(CLASIFICACION_MANUAL, EDAD_UC_IRAG_2, PRESENCIA_COMORBILIDADES) %>%
  summarise(N= n())

  
 #Gráfico IRAG/IRAG EXTENDIDO ABSOLUTO

IRAG_COMORBILIDADES_BARRAS_FIG <- ggplot(IRAG_COMORBILIDADES, aes(
  x = EDAD_UC_IRAG_2,
  y = N,
  fill = PRESENCIA_COMORBILIDADES
)) +
  geom_bar(stat = "identity", position = "stack") +
  facet_wrap(~ CLASIFICACION_MANUAL, ncol=1) +   # facetado por clasificación
  labs(
    title = 'Distribución de casos de IRAG e IRAG extendida por grupo de edad según presencia de comorbilidades',
    x = "Grupo de Edad",
    y = "Casos de IRAG",
    fill = "Comorbilidades"
  ) +
  scale_fill_manual(
    values = c(
      "Con Comorbilidades" = "#FFB6C1",   # verde pastel
      "Sin Comorbilidades" = "#C7F0B0",   # rosa pastel
      "Sin Dato de Comorbilidades" = "grey80"             # gris claro
    )) +
 
  theme_bw() +
     
  theme(
    axis.text.x = element_text(angle = 45, hjust = 1) # gira etiquetas si son largas
  )

# Convertir a plotly interactivo
IRAG_COMORBILIDADES_BARRAS_FIG <- ggplotly(IRAG_COMORBILIDADES_BARRAS_FIG)%>% 
  layout(
    legend = list(
      orientation = "h", 
      x = 0.3,             
      xanchor = "center",
      y = -0.2,            
      font = list(size = 10)  
    )
  )
#IRAG_COMORBILIDADES_BARRAS_FIG



#Gráfico IRAG RELATIVO

unique(IRAG_COMORBILIDADES_RELATIVO$CLASIFICACION_MANUAL)
IRAG_COMORBILIDADES_RELATIVO <- IRAG_COMORBILIDADES %>%
  group_by(CLASIFICACION_MANUAL, EDAD_UC_IRAG_2) %>%
  mutate(Proporcion = N / sum(N) * 100) %>% 
  mutate(CLASIFICACION_MANUAL=case_when(
    CLASIFICACION_MANUAL=="Infección respiratoria aguda grave (IRAG)" ~ "IRAG",
    CLASIFICACION_MANUAL=="IRAG extendida" ~ "IRAG ext."))

IRAG_COMORBILIDADES_RELATIV_FIG <- ggplot(IRAG_COMORBILIDADES_RELATIVO, aes(
  x = EDAD_UC_IRAG_2,
  y = Proporcion,
  fill = PRESENCIA_COMORBILIDADES
)) +
  geom_bar(stat = "identity", position = "stack") +
  facet_grid(rows = vars(CLASIFICACION_MANUAL))  +   # 
  labs(
    title = 'Distribución Relativa de Casos de IRAG e IRAG extendida por grupo de edad según presencia de comorbilidades',
    
    x = "Grupo de Edad",
    y = "Porcentaje",
    fill = "Comorbilidades"
  ) +
  scale_fill_manual(
    values = c(
      "Con Comorbilidades" = "#FFB6C1",   # verde pastel
      "Sin Comorbilidades" = "#C7F0B0",   # rosa pastel
      "Sin Dato de Comorbilidades" = "grey80"             # gris claro
    )) +
  
  theme_bw() +
  theme(
    axis.text.x = element_text(angle = 45, hjust = 1),
    strip.text.y = element_text(size = 8))

IRAG_COMORBILIDADES_RELATIV_FIG <- ggplotly(IRAG_COMORBILIDADES_RELATIV_FIG)  %>% 
  layout(
    legend = list(
      orientation = "h", 
      x = 0.3,             
      xanchor = "center",
      y = -0.2,            
      font = list(size = 10)  
    )
  )
#IRAG_COMORBILIDADES_RELATIV_FIG





#Según resultado de laboratorio, para casos de Influenza, VSR y SARS CoV 2
#SOLO PARA CASOS DE IRAG, PORQUE EXTENDIDA SON MUY POCOS.
#PODEMOS VER SI TAL VEZ PARA PEDIATRIA SE PUEDE INCLUIR, PERO DEBERIA SER SEPARADOS. 
B_COMORBILIDADES_IRAG<-B_COMORBILIDADES_IRAG %>% filter(CLASIFICACION_MANUAL=="Infección respiratoria aguda grave (IRAG)")

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

colores_fijos <- c(
  "Con Comorbilidades" = "#FFB6C1",   
  "Sin Comorbilidades" = "#C7F0B0",   
  "Sin Dato de Comorbilidades" = "grey80"            
)

FLU_COMORBILIDADES_BARRAS_FIG <- plot_ly(
  Tabla_Comorbilidades_Flu,
  x = ~EDAD_UC_IRAG_2,
  y = ~N,
  color = ~PRESENCIA_COMORBILIDADES,
  colors = colores_fijos,
  type = 'bar'
)

FLU_COMORBILIDADES_BARRAS_FIG <- FLU_COMORBILIDADES_BARRAS_FIG %>% layout(
  barmode = 'stack',
  title = "Distribución de IRAG con diagnóstico de Influenza por grupo de edad y presencia de comorbilidades",
  yaxis = list(title = "IRAG con diagnóstico de Influenza"),
  xaxis = list(title = "Grupo de Edad")
)

#FLU_COMORBILIDADES_BARRAS_FIG


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
  colors = colores_fijos,
  type = 'bar'
)

VSR_COMORBILIDADES_BARRAS_FIG <- VSR_COMORBILIDADES_BARRAS_FIG %>% layout(
  barmode = 'stack',
  title = "Distribución de IRAG con diagnóstico de VSR por grupo de edad y presencia de comorbilidades",
    yaxis = list(title = "IRAG con diagnóstico de VSR"),
  xaxis = list(title = "Grupo de Edad")
)

#VSR_COMORBILIDADES_BARRAS_FIG




#SARS COV2  



##ACA NO HAY CASOS DE SARS, POR LO QUE DEBERÍAMOS VER COMO CREAR UNA FUNCION QUE SI NO HAY CASOS, NO LOS DESCRIBA. PERO SI APARECEN SI DESCRIBIRLOS####
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
  colors = colores_fijos,
  type = 'bar'
)

covid_COMORBILIDADES_BARRAS_FIG <- covid_COMORBILIDADES_BARRAS_FIG %>% layout(
  barmode = 'stack',
  title = "Distribución de IRAG con diagnóstico de SARS-CoV-2 por grupo de edad y presencia de comorbilidades",
    yaxis = list(title = "IRAG con diagnóstico de SARS-CoV-2"),
  xaxis = list(title = "Grupo de Edad")
)

#covid_COMORBILIDADES_BARRAS_FIG





