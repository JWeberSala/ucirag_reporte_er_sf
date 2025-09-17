# Introducción

Este proyecto fue creado para obtener un reporte automatizado de la información recolectada en Unidades Centinelas.

# scripts/leer_base.R

## Librerías utilizadas

library(tidyverse)

library(readr)

library(readxl)

library(janitor)

library(stringr)

library(lubridate)

## año de reporte

anio_reporte \<- year(today())\

## base, variables y decisiones tomadas

### base: UC_IRAG_EST semanal

### variables: fecha mínima para el año del reporte, clasificación manual, edad, semana epidemiológica (SEPI_FECHA_INTER)

### decisiones tomadas:

#### Clasificación manual de los casos, grandes grupos de edad: clasificación manual del caso (todos los casos con excepción de los clasificados como “caso invalidado por epidemiología”), edad agrupada por población pediátrica (\<15años) población adulta (\>15años).

base \<- read_csv2('data/UC_IRAG_EST80089.csv', locale = locale(encoding = "WINDOWS-1252")) %\>% dplyr:: filter( year(FECHA_MINIMA) == anio_reporte , CLASIFICACION_MANUAL != 'Caso invalidado por epidemiología', !is.na(FTM_MOLECULAR) ) %\>% dplyr:: mutate(poblacion = ifelse(EDAD_DIAGNOSTICO \<15, 'Pediatrica', 'Adultos'), EDAD_UC_IRAG_2 = case_when(EDAD_UC_IRAG == '0 a 2 Meses' \~ 'Menores de 6 Meses', EDAD_UC_IRAG == '3 a 5 Meses' \~ 'Menores de 6 Meses', T \~ EDAD_UC_IRAG))\

#### Sacar la última semana: A partir de la SEPI_FECHA_INTER no se contempla la última semana informada para evitar interpretaciones erróneas por la falta de carga de datos y no por la situación epidemiológica.

max_se_int \<- (max(base\$SEPI_FECHA_INTER, na.rm = T) - 1) base \<- base %\>% dplyr::filter(SEPI_FECHA_INTER \<= max_se_int)\

### Crear una secuencia de todas las fechas del año 2025: para poder procesar información por semanas epidemiológicas

fechas_2025 \<- seq(as.Date("2024-12-29"), as.Date("2025-12-27"), by = "day")\

### Crear el calendario: para poder procesar información por semanas epidemiológicas

calendario_completo \<- data.frame(fecha = fechas_2025) %\>% mutate( anio_epi = year(fecha), semana_epi = epiweek(fecha)) inicio_sem \<- format(first(calendario_completo %\>% filter(semana_epi == max_se_int))[1,1], "%d de %B") fin_sem \<- format(last(calendario_completo %\>% filter(semana_epi == max_se_int))[1,1], "%d de %B")

### Construir grupos de edad: para poder procesar información según los grupos de edad detallados

base$EDAD_UC_IRAG_2 <- factor(base$EDAD_UC_IRAG_2, levels = c("Menores de 6 Meses", "6 a 11 Meses", "12 a 23 Meses", '02 a 04 Años', '05 a 09 Años','10 a 14 Años', '15 a 19 Años','20 a 24 Años', '25 a 29 Años', "30 a 34 Años", "35 a 39 Años", "40 a 44 Años", "45 a 49 Años","50 a 54 Años", "55 a 59 Años", "60 a 64 Años", "65 a 69 Años", "70 a 74 Años", "75 y más Años"))

# scripts/curvas_sem.R

## Librerías utilizadas

library(tidyverse)

library(readr)

library(readxl)

library(janitor)

library(stringr)

library(lubridate)

library(plotly)

## Tabla semana epidemiológica y población (pediátrica y adultos): se construye tabla para poder luego graficar las variables que se detallan

tbl_curvas \<- base %\>% count(SEPI_FECHA_INTER, poblacion)

## Grafico semana epidemiológica y población (pediátrica y adultos): se construye tabla para poder luego graficar las variables que se detallan

g \<- ggplot(tbl_curvas) + geom_bar(aes(x = SEPI_FECHA_INTER, y = n, fill = poblacion, text = paste( 'Semana ', SEPI_FECHA_INTER, '<br>', 'Eventos:', n)), stat = 'identity', width = 1) + facet_wrap(\~poblacion, ncol = 1) + theme_bw() + scale_x_continuous(breaks = seq(1,52,1)) + scale_y_continuous(breaks = seq(0, 20, 2)) + scale_fill_manual(values = c('#748DAE', '#78C841'))+ labs( title = 'Eventos según semana de internación', fill = '', x = 'Semana de Internación', y = 'Eventos',) + theme(plot.title = element_text(hjust = 0.5, size = 13), legend.position = 'none') grafico_curvas \<- ggplotly(g, tooltip = c("text"))

# scripts/grupos_edad.R

## Librerías utilizadas

library(tidyverse)

library(readr)

library(readxl)

library(janitor)

library(stringr)

library(lubridate)

library(plotly)

## Tabla clasificación manual y edad: se construye tabla para poder luego graficar las variables que se detallan

tbl_edad \<- base%\>% count(CLASIFICACION_MANUAL, EDAD_UC_IRAG_2)

## Gráfico clasificación manual y edad: se construye tabla para poder luego graficar las variables que se detallan

g \<- ggplot(tbl_edad) + geom_bar(aes(x = EDAD_UC_IRAG_2, y = n, fill = CLASIFICACION_MANUAL, text = paste( CLASIFICACION_MANUAL, '<br>', EDAD_UC_IRAG_2 , '<br>', 'Eventos:', n)), stat = 'identity') + \# theme(legend.position = "bottom")+ theme_bw()+ theme(axis.text.x=element_text(angle= 30, hjust = 1)) + labs( title = 'Grupos Edad', fill = '', x = 'Grupos de edad', y = 'Eventos',) + theme(plot.title = element_text(hjust = 0.5, size = 13),legend.position = 'none') + scale_fill_manual(values = c('#748DAE', '#78C841')) grafico_edad \<- ggplotly(g, tooltip = c("text"))

# scripts/determinaciones.R

## Librerías utilizadas

library(tidyverse)

library(readr)

library(readxl)

library(janitor)

library(stringr)

library(lubridate)

library(plotly)

### Determinaciones: resultados “negativos” (covid, influenzam ó VSR), resultados “positivos” para (covid, influenzam ó VSR) y resultado “Sin resultado” (covid, influenzam ó VSR) los cuales se mencionarán como “En estudio”.

determinacion \<- base %\>% select(IDEVENTOCASO,poblacion, SEPI_FECHA_INTER, COVID_19_FINAL, VSR_FINAL, INFLUENZA_FINAL) negativos \<- determinacion %\>% filter(COVID_19_FINAL == 'Negativo', VSR_FINAL == 'Negativo', INFLUENZA_FINAL == 'Negativo') %\>% select(IDEVENTOCASO, poblacion, SEPI_FECHA_INTER, COVID_19_FINAL) %\>% rename(Determinacion = COVID_19_FINAL)

vsr \<- determinacion %\>% filter(VSR_FINAL != 'Negativo') %\>% select(IDEVENTOCASO,poblacion, SEPI_FECHA_INTER, VSR_FINAL) %\>% rename(Determinacion = VSR_FINAL)

influenza \<- determinacion %\>% filter(INFLUENZA_FINAL != 'Negativo') %\>% select(IDEVENTOCASO,poblacion, SEPI_FECHA_INTER, INFLUENZA_FINAL) %\>% rename(Determinacion = INFLUENZA_FINAL)

sar_cov \<- determinacion %\>% filter(COVID_19_FINAL != 'Negativo') %\>% select(IDEVENTOCASO, poblacion, SEPI_FECHA_INTER, COVID_19_FINAL) %\>% rename(Determinacion = COVID_19_FINAL)

deteterm_resumen \<- rbind(negativos, vsr, influenza, sar_cov) %\>% count(SEPI_FECHA_INTER,poblacion, Determinacion) %\>% mutate(Determinacion = case_when(Determinacion == 'Sin resultado'\~ 'En estudio', Determinacion == 'Positivo' \~ 'Sars-Cov2', T \~ Determinacion) )

deteterm_resumen$Determinacion <- factor(deteterm_resumen$Determinacion, levels = c("Negativo", "En estudio","Sars-Cov2", "VSR", "VSR A", "VSR B", "Influenza A H1N1", "Influenza A (sin subtipificar)"))

### Gráfico Determinaciones: resultados “negativos”, “positivos” y “en estudio”.

g \<- ggplot(deteterm_resumen) + geom_bar(aes(x = SEPI_FECHA_INTER, y =n , fill = Determinacion , text = paste( Determinacion, '<br>', n)), stat = 'identity', width = 1) + theme_classic() + scale_x_continuous(breaks = seq(1, 52,1)) + scale_y_continuous(breaks = seq(0,100,2)) + scale_fill_manual(values = c('#bdbdbd', '#969696', '#74a9cf', '#c2e699', '#78c679', '#238443', '#fecc5c', '#fd8d3c')) + labs( title = '', fill = '', x = 'Semana de Internación', y = 'Eventos',) + theme(plot.title = element_text(hjust = 0.5, size = 13), legend.position = 'none')+ theme(legend.position = 'none') + facet_wrap(\~ poblacion, ncol = 1)

grafico_virus \<- ggplotly(g, tooltip = c("text"))

# scripts/mapas.R

## Librerías utilizadas

library(geoAr)

library(tidyverse)

library(leaflet)

## Lectura de Excel con coordenadas de los establecimientos con Unidad Centinela

establecimientos \<- read_excel('data/establ_coord.xlsx') mapa_establ\<- leaflet() %\>% addArgTiles() %\>% addCircleMarkers( data = establecimientos, \~long, \~lat, popup = \~paste0("<b>Nombre:</b> ", Establecimiento, "<br>", "<b>Localidad:</b> ", Localidad, "<br>", "<b>Provincia:</b> ", Provincia, "<br>"), color = "blue", radius = 5, fillOpacity = 0.7 )

# scripts/análisis_comorbilidad.R

## Librerías utilizadas

library(tidyverse)

library(readr)

library(readxl)

library(janitor)

library(stringr)

library(lubridate)

library(plotly)

## Análisis comorbilidades por grupos de edad:

### Presencia de comorbilidad y grupo de edad: 1 (con comorbilidad), 2 (sin comorbilidad), 9 (sin dato de comorbilidad). Grupos de edad detallados.

B_COMORBILIDADES_IRAG\<-base %\>% #filter(CLASIFICACION_MANUAL=="Infección respiratoria aguda grave (IRAG)") %\>% mutate(PRESENCIA_COMORBILIDADES=case_when( PRESENCIA_COMORBILIDADES == 1 \~ "Con Comorbilidades", PRESENCIA_COMORBILIDADES == 2 \~ "Sin Comorbilidades", PRESENCIA_COMORBILIDADES == 9 \~ "Sin Dato de Comorbilidades", ) ) grupos_edad \<- c("Menores de 6 Meses", "6 a 11 Meses", "12 a 23 Meses", '02 a 04 Años', '05 a 09 Años','10 a 14 Años', '15 a 19 Años','20 a 24 Años', '25 a 29 Años', "30 a 34 Años", "35 a 39 Años", "40 a 44 Años", "45 a 49 Años","50 a 54 Años", "55 a 59 Años", "60 a 64 Años", "65 a 69 Años", "70 a 74 Años", "75 y más Años")

IRAG_COMORBILIDADES\<-B_COMORBILIDADES_IRAG %\>% group_by(CLASIFICACION_MANUAL, EDAD_UC_IRAG_2, PRESENCIA_COMORBILIDADES) %\>% summarise(N= n())

### Gráfico IRAG/IRAG EXTENDIDO ABSOLUTO: comorbilidad por grupos de edad

IRAG_COMORBILIDADES_BARRAS_FIG \<- ggplot(IRAG_COMORBILIDADES, aes( x = EDAD_UC_IRAG_2, y = N, fill = PRESENCIA_COMORBILIDADES )) + geom_bar( stat = "identity", position = "stack") + facet_wrap(\~ CLASIFICACION_MANUAL, ncol=1) + \# facetado por clasificación labs( title = ' ', x = "Grupo de Edad", y = "Casos de IRAG", fill = "Comorbilidades" ) + scale_fill_manual( values = c( "Con Comorbilidades" = "#FFB6C1", \# verde pastel "Sin Comorbilidades" = "#C7F0B0", \# rosa pastel "Sin Dato de Comorbilidades" = "grey80" \# gris claro )) + theme_bw() + theme( axis.text.x = element_text(angle = 45, hjust = 1) \# gira etiquetas si son largas )

### Gráfico de comorbilidad por grupos de edad interactivo (plotly interactivo)

IRAG_COMORBILIDADES_BARRAS_FIG \<- ggplotly(IRAG_COMORBILIDADES_BARRAS_FIG)%\>% layout( legend = list( orientation = "h", x = 0.3,\
xanchor = "center", y = -0.2,\
font = list(size = 8)\
) )

### Gráfico de comorbilidad por grupos de edad por frecuencia relativa

IRAG_COMORBILIDADES_RELATIVO \<- IRAG_COMORBILIDADES %\>% group_by(CLASIFICACION_MANUAL, EDAD_UC_IRAG_2) %\>% mutate(Proporcion = N / sum(N) \* 100) %\>% mutate(CLASIFICACION_MANUAL=case_when( CLASIFICACION_MANUAL=="Infección respiratoria aguda grave (IRAG)" \~ "IRAG", CLASIFICACION_MANUAL=="IRAG extendida" \~ "IRAG ext."))

IRAG_COMORBILIDADES_RELATIV_FIG \<- ggplot(IRAG_COMORBILIDADES_RELATIVO, aes( x = EDAD_UC_IRAG_2, y = Proporcion, fill = PRESENCIA_COMORBILIDADES )) + geom_bar(stat = "identity", position = "stack") + facet_grid(rows = vars(CLASIFICACION_MANUAL)) + \# labs( title = 'Distribución Relativa de Casos de IRAG e IRAG extendida por grupo de edad según presencia de comorbilidades', x = "Grupo de Edad", y = "Porcentaje", fill = "Comorbilidades" ) + scale_fill_manual( values = c( "Con Comorbilidades" = "#FFB6C1", \# verde pastel "Sin Comorbilidades" = "#C7F0B0", \# rosa pastel "Sin Dato de Comorbilidades" = "grey80" \# gris claro )) +

theme_bw() + theme( axis.text.x = element_text(angle = 45, hjust = 1), strip.text.y = element_text(size = 8))

IRAG_COMORBILIDADES_RELATIV_FIG \<- ggplotly(IRAG_COMORBILIDADES_RELATIV_FIG) %\>% layout( legend = list( orientation = "h", x = 0.3,\
xanchor = "center", y = -0.2,\
font = list(size = 10)\
) )

### IRAG_COMORBILIDADES_RELATIV_FIG: según resultado de laboratorio, para casos de Influenza, VSR y SARS CoV 2. Sólo para casos de IRAG, porque extendida son muy pocos.

B_COMORBILIDADES_IRAG\<-B_COMORBILIDADES_IRAG %\>% filter(CLASIFICACION_MANUAL=="Infección respiratoria aguda grave (IRAG)")

#### Comorbilidad en casos de Influenza

Tabla_Comorbilidades_Flu\<-B_COMORBILIDADES_IRAG %\>% filter(INFLUENZA_FINAL!="Sin resultado" & INFLUENZA_FINAL!="Negativo") %\>% group_by(EDAD_UC_IRAG_2, PRESENCIA_COMORBILIDADES) %\>% summarise(N= n(), .groups = "drop")%\>% mutate(EDAD_UC_IRAG_2 = as.character(EDAD_UC_IRAG_2))

Tabla_Comorbilidades_Flu \<- Tabla_Comorbilidades_Flu %\>% mutate( EDAD_UC_IRAG_2 = factor(EDAD_UC_IRAG_2, levels = grupos_edad) )

Tabla_Comorbilidades_Flu \<- Tabla_Comorbilidades_Flu %\>% complete( PRESENCIA_COMORBILIDADES, EDAD_UC_IRAG_2, fill = list(N = 0) )

colores_fijos \<- c( "Con Comorbilidades" = "#FFB6C1",\
"Sin Comorbilidades" = "#C7F0B0",\
"Sin Dato de Comorbilidades" = "grey80"\
)

FLU_COMORBILIDADES_BARRAS_FIG \<- plot_ly( Tabla_Comorbilidades_Flu, x = \~EDAD_UC_IRAG_2, y = \~N, color = \~PRESENCIA_COMORBILIDADES, colors = colores_fijos, type = 'bar' )

FLU_COMORBILIDADES_BARRAS_FIG \<- FLU_COMORBILIDADES_BARRAS_FIG %\>% layout( barmode = 'stack', title = "Distribución de IRAG con diagnóstico de Influenza por grupo de edad y presencia de comorbilidades", yaxis = list(title = "IRAG con diagnóstico de Influenza"), xaxis = list(title = "Grupo de Edad") )

#### Comorbilidad en casos de VSR

Tabla_Comorbilidades_VSR\<-B_COMORBILIDADES_IRAG %\>% filter(VSR_FINAL!="Sin resultado" & VSR_FINAL!="Negativo") %\>% group_by(EDAD_UC_IRAG_2, PRESENCIA_COMORBILIDADES) %\>% summarise(N= n(), .groups = "drop")%\>% mutate(EDAD_UC_IRAG_2 = as.character(EDAD_UC_IRAG_2))

Tabla_Comorbilidades_VSR \<- Tabla_Comorbilidades_VSR %\>% mutate( EDAD_UC_IRAG_2 = factor(EDAD_UC_IRAG_2, levels = grupos_edad) )

Tabla_Comorbilidades_VSR \<- Tabla_Comorbilidades_VSR %\>% complete( PRESENCIA_COMORBILIDADES, EDAD_UC_IRAG_2, fill = list(N = 0) )

VSR_COMORBILIDADES_BARRAS_FIG \<- plot_ly( Tabla_Comorbilidades_VSR, x = \~EDAD_UC_IRAG_2, y = \~N, color = \~PRESENCIA_COMORBILIDADES, colors = colores_fijos, type = 'bar' )

VSR_COMORBILIDADES_BARRAS_FIG \<- VSR_COMORBILIDADES_BARRAS_FIG %\>% layout( barmode = 'stack', title = "Distribución de IRAG con diagnóstico de VSR por grupo de edad y presencia de comorbilidades", yaxis = list(title = "IRAG con diagnóstico de VSR"), xaxis = list(title = "Grupo de Edad") )

#### Comorbilidad en SARS COV2: crear función sino hay casos que no se describa y si hay casos que si se informen.

Tabla_Comorbilidades_COVID\<-B_COMORBILIDADES_IRAG %\>% filter(COVID_19_FINAL!="Sin resultado" & COVID_19_FINAL!="Negativo") %\>% group_by(EDAD_UC_IRAG_2, PRESENCIA_COMORBILIDADES) %\>% summarise(N= n(), .groups = "drop")%\>% mutate(EDAD_UC_IRAG_2 = as.character(EDAD_UC_IRAG_2))

Tabla_Comorbilidades_COVID \<- Tabla_Comorbilidades_COVID %\>% mutate( EDAD_UC_IRAG_2 = factor(EDAD_UC_IRAG_2, levels = grupos_edad) )

Tabla_Comorbilidades_COVID \<- Tabla_Comorbilidades_COVID %\>% complete( PRESENCIA_COMORBILIDADES, EDAD_UC_IRAG_2, fill = list(N = 0) )

covid_COMORBILIDADES_BARRAS_FIG \<- plot_ly( Tabla_Comorbilidades_COVID, x = \~EDAD_UC_IRAG_2, y = \~N, color = \~PRESENCIA_COMORBILIDADES, colors = colores_fijos, type = 'bar' )

covid_COMORBILIDADES_BARRAS_FIG \<- covid_COMORBILIDADES_BARRAS_FIG %\>% layout( barmode = 'stack', title = "Distribución de IRAG con diagnóstico de SARS-CoV-2 por grupo de edad y presencia de comorbilidades", yaxis = list(title = "IRAG con diagnóstico de SARS-CoV-2"), xaxis = list(title = "Grupo de Edad") )

# scripts/comorb.R

## Librerías utilizadas

library(tidyverse)

library(readr)

library(readxl)

library(janitor)

library(stringr)

library(lubridate)

library(highcharter)

library(plotly)

library(flextable)

### Presencia de comorbilidad y grupo de edad: 1 (con comorbilidad), 2 (sin comorbilidad), 9 (sin dato de comorbilidad). Grupos de edad detallados.

base_comorb \<- base %\>% mutate(comorb = case_when( PRESENCIA_COMORBILIDADES == 1 \~ "Con Comorbilidades", PRESENCIA_COMORBILIDADES == 2 \~ "Sin Comorbilidades", PRESENCIA_COMORBILIDADES == 9 \~ "Sin Dato de Comorbilidades")) total_eventos \<- nrow(base_comorb)

### Grafico: IRAG y grupos de edad

tbl_comorb_irag \<- base_comorb %\>% filter(CLASIFICACION_MANUAL == 'Infección respiratoria aguda grave (IRAG)') %\>% count(EDAD_UC_IRAG_2, comorb) %\>% pivot_wider(names_from = comorb, values_from = n)

grafica_comorb_irag \<- highchart() \|\> hc_chart(type = "column") \|\> hc_xAxis(categories = tbl_comorb_irag$EDAD_UC_IRAG_2,
           title = list(text = "Grupo etario"),
           labels = list(rotation = -45)) |>
  hc_yAxis(title = list(text = "Cantidad de casos")) |>
  hc_plotOptions(column = list(stacking = "normal")) |>
  hc_add_series(name = "Sin datos",
          data = tbl_comorb_irag$`Sin Dato de Comorbilidades`, color = "#7f7f7f") \|\> hc_add_series(name = "Sin Comorbilidades", data = tbl_comorb_irag$`Sin Comorbilidades`, color = "#ff7f0e") |>
  hc_add_series(name = "Con Comorbilidades",
                data = tbl_comorb_irag$`Con Comorbilidades`, color = "#1f77b4") \|\> hc_title(text = "Presencia de Comorbilidades: Infección respiratoria aguda grave (IRAG)")

### Grafico: IRAG extendida y grupos de edad

tbl_comorb_irag_ext \<- base_comorb %\>% filter(CLASIFICACION_MANUAL == 'IRAG extendida') %\>% count(EDAD_UC_IRAG_2, comorb) %\>% pivot_wider(names_from = comorb, values_from = n)

tbl_comorb_irag_ext \<- left_join(tbl_comorb_irag[,1], tbl_comorb_irag_ext) grafica_comorb_irag_extend \<- highchart() \|\> hc_chart(type = "column") \|\> hc_xAxis(categories = tbl_comorb_irag_ext$EDAD_UC_IRAG_2,
           title = list(text = "Grupo etario"),
           labels = list(rotation = -45)) |>
  hc_yAxis(title = list(text = "Cantidad de casos")) |>
  hc_plotOptions(column = list(stacking = "normal")) |>
  hc_add_series(name = "Sin datos",
                data = tbl_comorb_irag_ext$`Sin Dato de Comorbilidades`, color = "#7f7f7f") \|\> hc_add_series(name = "Sin Comorbilidades", data = tbl_comorb_irag_ext$`Sin Comorbilidades`, color = "#ff7f0e") |>
  hc_add_series(name = "Con Comorbilidades",
                data = tbl_comorb_irag_ext$`Con Comorbilidades`, color = "#1f77b4") \|\> hc_title(text = "Presencia de Comorbilidades: IRAG extendida")

### Tabla con diferentes comorbilidades: considerar las 5 con más frecuencia

frec_comorb \<- base %\>% filter(PRESENCIA_COMORBILIDADES == 1) %\>% \# 1 select(IDEVENTOCASO, c(54:86), poblacion) %\>% \# 2 pivot_longer(c(2:34), names_to = 'comorbilidad', values_to = 'n') %\>% \# 3 filter(n == 1) %\>% \# 4 count(poblacion, comorbilidad) \# 5 frec_comorb$comorbilidad <- str_replace_all( frec_comorb$comorbilidad,"[ \_ ]", " ") frec_comorb$comorbilidad <- str_to_title(frec_comorb$comorbilidad)

### Gráfico de comorbilidad según población pediátrica o adultos

#### Notas para la construcción de gráficos de comorbilidad según población

##### 1- Filtrar todos los eventos dónde la variable PRESENCIA_COMORBILIDADES == 1, lo que significa que se registró alguna comorbilidad

##### 2- Elegir las variables IDEVENTOCASO, poblacion creada por nosotros (pediatria o adultos) y las columnas que representan la lista de comorbilidades (desde la columna 54 hasta la 86)

##### 3- Agrupo todas las columnas de comorbilidades en una nueva

##### 4- Filtro las filas que tienen valor igual a 1 lo que significa presencia de comorbilidad específica

##### 5- Realizo una tabla de frecuencia para cada comorbilidad y poblacion

#### Gráfico de comorbilidad para población de adultos

adultos_tot \<- nrow(base %\>% filter( poblacion == 'Adultos')) adultos_con_comorb \<- nrow(base %\>% filter(PRESENCIA_COMORBILIDADES == 1, poblacion == 'Adultos')) comorb_adult \<- frec_comorb %\>% filter(poblacion == 'Adultos') %\>% group_by(comorbilidad) %\>% summarise(cantidad = sum(n), Proporción = paste(round(cantidad/adultos_con_comorb \*100,1), '%')) %\>% arrange(desc(cantidad)) %\>% head(5) %\>% select(-cantidad)

tbl_comorb_adult \<- flextable(comorb_adult) %\>% set_header_labels (comorbilidad = 'Comorbilidades') %\>% width(j = \~ comorbilidad, width = 2) %\>% theme_vanilla() %\>% align(align = "right", j = 2) %\>% bg(bg='#708993', part = 'header') %\>% color(color = 'white', part = 'header')

#### Gráfico de comorbilidad para población pediátrica

pediat_tot \<- nrow(base %\>% filter( poblacion == 'Pediatrica')) pediat_con_comorb \<- nrow(base %\>% filter(PRESENCIA_COMORBILIDADES == 1, poblacion == 'Pediatrica'))

comorb_pediat \<- frec_comorb %\>% filter(poblacion == 'Pediatrica') %\>% group_by(comorbilidad) %\>% summarise(cantidad = sum(n), Proporción = paste(round(cantidad/adultos_con_comorb \*100,1), '%'))%\>% arrange(desc(cantidad)) %\>% head(5) %\>% select(-cantidad)

tbl_comorb_pediat \<- flextable(comorb_pediat) %\>% set_header_labels (comorbilidad = 'Comorbilidades') %\>% width(j = \~ comorbilidad, width = 2) %\>% theme_vanilla() %\>% align(align = "right", j = 2) %\>% bg(bg='#708993', part = 'header') %\>% color(color = 'white', part = 'header')
