# Introducción

Este proyecto fue creado para obtener un reporte automatizado de la información recolectada en Unidades Centinelas.

# Objetivo del análisis

Analizar las características clínicas, de laboratorio y epidemiológicas de las personas con IRAG e IRAG extendida correspondientes a las Unidades Centinela de las jurisdicciones de Santa Fe y Entre Ríos.

<<<<<<< HEAD
library(tidyverse)

library(readr)

library(readxl)

library(janitor)

library(stringr)

library(lubridate)
=======
# Período de estudio
>>>>>>> efc8f202114934f6cc36206933380a398eb8398b

El análisis abarca el año 2025.

# Unidad de análisis

El análisis se realizará de forma individual, teniendo en cuenta cada caso internado por IRAG o IRAG extendida en cualquiera de los establecimientos incluidos en la estrategia de Santa Fe y Entre Ríos.

# Fuentes de datos

Notificaciones nominales de casos al SNVS 2.0 por Unidad Centinela de cada jurisdicción.

# Variables

### Características sociodemográficas

-   Clasificación de la edad en dos grupos: pediátricos (menos de 15 años) y adultos (15 años y más).

-   Grupos de edad con mayor nivel de desagregación: “Menores de 6 Meses", "6 a 11 Meses" "12 a 23 Meses", '02 a 04 Años', '05 a 09 Años', '10 a 14 Años', '15 a 19 Años', '20 a 24 Años', '25 a 29 Años', "30 a 34 Años", "35 a 39 Años", "40 a 44 Años", "45 a 49 Años", "50 a 54 Años", "55 a 59 Años", "60 a 64 Años", "65 a 69 Años", "70 a 74 Años", "75 y más Años".

-   Provincia de Notificación: Provincia a la cual pertenece el establecimiento que notificó el caso.

-   Departamento de Notificación: Departamento al cual pertenece el establecimiento que notificó el caso.

-   Localidad de Notificación: Localidad a la cual pertenece el establecimiento que notificó el caso.

-   Establecimiento notificador: Hospital que notificó el caso.

-   Coordenada geográficas del establecimiento: latitud y longitud para la localización de los establecimientos en un mapa.

### Clasificación del caso:

<<<<<<< HEAD
library(tidyverse)

library(readr)

library(readxl)

library(janitor)

library(stringr)

library(lubridate)

library(plotly)
=======
Clasificación manual: Definición de caso (IRAG o IRAG extendida) de acuerdo a lo registrado por el usuario que notificó el caso. Se considerarán todas las clasificación con excepción de los casos “invalidades por epidemiología”.
>>>>>>> efc8f202114934f6cc36206933380a398eb8398b

A partir de las determinaciones de laboratorio, se actualiza la clasificación manual en la base para lo cual quien clasificó el caso, debió considerar lo suguiente:

-   Determinación influenza: realización de PCR para influenza positiva.

-   Determinación VSR: realización de PCR para VSR positiva.

-   Determinación SARS-COV-2: realización de PCR para SARS-COV-2 positiva.

-   Resultado de las pruebas de laboratorio: negativo para cada determinación.

-   Resultado de las pruebas de laboratorio: sin resultados, a los que se considerará “en estudio”

<<<<<<< HEAD
library(tidyverse)

library(readr)

library(readxl)

library(janitor)

library(stringr)

library(lubridate)

library(plotly)
=======
### Información clínica asociada al caso:
>>>>>>> efc8f202114934f6cc36206933380a398eb8398b

-   Fecha de internación: Fecha en la que el caso fue internado debido a la IRAG.

-   Semana Epidemiológica de internación: Semana epidemiológica que corresponde a la fecha de internación.

-   Año de internación: Año que corresponde a la fecha de internación.

-   Comorbilidades: presencia de al menos una comorbilidad en el caso.

-   Fallecimiento: desenlace fatal del caso.

# Criterios de inclusión y exclusión

<<<<<<< HEAD
library(tidyverse)

library(readr)

library(readxl)

library(janitor)

library(stringr)

library(lubridate)

library(plotly)
=======
### Inclusión:
>>>>>>> efc8f202114934f6cc36206933380a398eb8398b

-   Casos que cumplen con las definiciones de caso de IRAG e IRAG extendida (\< 2 años y \>= 60 años).

### Exclusión:

-   Pacientes internados previamente en otra institución y posteriormente derivado al establecimiento que funciona como UC por la gravedad del caso;

-   Infección respiratoria de posible origen nosocomial con fecha de inicio de síntomas 24 hs posterior al ingreso o antecedente de internación por cualquier causa dentro de los 14 días previos al nuevo ingreso por IRAG.

-   Sintomatología que pueda explicarse por procesos no infecciosos (por ejemplo, insuficiencia cardiaca aguda, tromboembolismo pulmonar).

# Limpieza y tratamiento de datos

Se utilizó la base proporcionada semanalmente por el Ministerio de Salud de la nación a cada provincia de las Unidades Centinelas, a fin de poder contar con la información procesada con un único registro por paciente.

# Análisis descriptivo de los datos

-   distribución de los casos de IRAG e IRAG extendida por grandes grupos de edad (pediátrico y adultos).

-   distribución de los casos de IRAG e IRAG extendida por grupos de edad con mayor nivel de desagregación.

-   distribución de los casos de IRAG e IRAG extendida por determinaciones.

-   distribución de los casos de IRAG e IRAG extendida por grupos de edad según presencia o no de comorbilidades.

<<<<<<< HEAD
library(geoAr)

library(tidyverse)

library(leaflet)
=======
-   distribución de los de los casos de IRAG e IRAG extendida por grupos de edad según condición de fallecido o no.
>>>>>>> efc8f202114934f6cc36206933380a398eb8398b

# Mapa del circuito de datos

El flujo de los datos desde la captación hasta su análisis final es el siguiente:

1)  en el establecimiento (Unidad Centinela) se recolecta la información y carga en el SNVS 2.0.

2)  procesamiento de la base en nación para tener una base con un único registro por paciente.

<<<<<<< HEAD
library(tidyverse)

library(readr)

library(readxl)

library(janitor)

library(stringr)

library(lubridate)

library(plotly)
=======
3)  envío semanal desde nación a las provincias de la base.
>>>>>>> efc8f202114934f6cc36206933380a398eb8398b

4)  descarga de la base de datos en la provincia.

5)  automatización del reporte.

6)  auditoría del reporte.

7)  difusión del reporte.

# Reportes

### Reporte semanal

Se actualizará la información de los casos con el siguiente análisis:

-   distribución de los casos de IRAG e IRAG extendida por grandes grupos de edad (pediátrico y adultos).

-   distribución de los casos de IRAG e IRAG extendida por grupos de edad con mayor nivel de desagregación.

-   distribución de los casos de IRAG e IRAG extendida por determinaciones.

### Reporte mensual

Se actualizará la información de los casos con el siguiente análisis:

-   distribución de los casos de IRAG e IRAG extendida por grandes grupos de edad (pediátrico y adultos).

-   distribución de los casos de IRAG e IRAG extendida por grupos de edad con mayor nivel de desagregación.

-   distribución de los casos de IRAG e IRAG extendida por determinaciones.

-   distribución de los casos de IRAG e IRAG extendida por grupos de edad según presencia o no de comorbilidades.

<<<<<<< HEAD
Tabla_Comorbilidades_Flu\<-B_COMORBILIDADES_IRAG %\>% filter(INFLUENZA_FINAL!="Sin resultado" & INFLUENZA_FINAL!="Negativo") %\>% group_by(EDAD_UC_IRAG_2, PRESENCIA_COMORBILIDADES) %\>% summarise(N= n(), .groups = "drop")%\>% mutate(EDAD_UC_IRAG_2 = as.character(EDAD_UC_IRAG_2))

Tabla_Comorbilidades_Flu \<- Tabla_Comorbilidades_Flu %\>% mutate( EDAD_UC_IRAG_2 = factor(EDAD_UC_IRAG_2, levels = grupos_edad) )

Tabla_Comorbilidades_Flu \<- Tabla_Comorbilidades_Flu %\>% complete( PRESENCIA_COMORBILIDADES, EDAD_UC_IRAG_2, fill = list(N = 0) )

colores_fijos \<- c( "Con Comorbilidades" = "#FFB6C1",\
"Sin Comorbilidades" = "#C7F0B0",\
"Sin Dato de Comorbilidades" = "grey80"\
)

FLU_COMORBILIDADES_BARRAS_FIG \<- plot_ly( Tabla_Comorbilidades_Flu, x = \~EDAD_UC_IRAG_2, y = \~N, color = \~PRESENCIA_COMORBILIDADES, colors = colores_fijos, type = 'bar' )

FLU_COMORBILIDADES_BARRAS_FIG \<- FLU_COMORBILIDADES_BARRAS_FIG %\>% layout( barmode = 'stack', title = "Distribución de IRAG con diagnóstico de Influenza por grupo de edad y presencia de comorbilidades", yaxis = list(title = "IRAG con diagnóstico de Influenza"), xaxis = list(title = "Grupo de Edad") )

### Comorbilidad en casos de VSR

Tabla_Comorbilidades_VSR\<-B_COMORBILIDADES_IRAG %\>% filter(VSR_FINAL!="Sin resultado" & VSR_FINAL!="Negativo") %\>% group_by(EDAD_UC_IRAG_2, PRESENCIA_COMORBILIDADES) %\>% summarise(N= n(), .groups = "drop")%\>% mutate(EDAD_UC_IRAG_2 = as.character(EDAD_UC_IRAG_2))

Tabla_Comorbilidades_VSR \<- Tabla_Comorbilidades_VSR %\>% mutate( EDAD_UC_IRAG_2 = factor(EDAD_UC_IRAG_2, levels = grupos_edad) )

Tabla_Comorbilidades_VSR \<- Tabla_Comorbilidades_VSR %\>% complete( PRESENCIA_COMORBILIDADES, EDAD_UC_IRAG_2, fill = list(N = 0) )

VSR_COMORBILIDADES_BARRAS_FIG \<- plot_ly( Tabla_Comorbilidades_VSR, x = \~EDAD_UC_IRAG_2, y = \~N, color = \~PRESENCIA_COMORBILIDADES, colors = colores_fijos, type = 'bar' )

VSR_COMORBILIDADES_BARRAS_FIG \<- VSR_COMORBILIDADES_BARRAS_FIG %\>% layout( barmode = 'stack', title = "Distribución de IRAG con diagnóstico de VSR por grupo de edad y presencia de comorbilidades", yaxis = list(title = "IRAG con diagnóstico de VSR"), xaxis = list(title = "Grupo de Edad") )

### Comorbilidad en SARS COV2: crear función sino hay casos que no se describa y si hay casos que si se informen.

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
=======
-   distribución de los de los casos de IRAG e IRAG extendida por grupos de edad según condición de fallecido o no.
>>>>>>> efc8f202114934f6cc36206933380a398eb8398b
