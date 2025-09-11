library(tidyverse)
library(readr)
library(readxl)
library(janitor)
library(stringr)
library(lubridate)
library(highcharter)
library(plotly)
library(flextable)


base_comorb <- base %>%
  mutate(comorb = case_when(
            PRESENCIA_COMORBILIDADES == 1 ~ "Con Comorbilidades",
            PRESENCIA_COMORBILIDADES == 2 ~ "Sin Comorbilidades",
            PRESENCIA_COMORBILIDADES == 9 ~ "Sin Dato de Comorbilidades"))


total_eventos <- nrow(base_comorb)


# Graficos con ggplot

# tbl_comorb <- base_comorb %>% 
#               count(CLASIFICACION_MANUAL, EDAD_UC_IRAG_2, comorb) 
# 
# g <- ggplot(tbl_comorb) +
#   geom_bar(aes(x = EDAD_UC_IRAG_2, y = n, fill = comorb,
#                text = paste( comorb, '<br>',
#                              EDAD_UC_IRAG_2 , '<br>',
#                              'Eventos:',  n)), 
#            stat = 'identity') +
#   facet_wrap(~CLASIFICACION_MANUAL, ncol = 1) +
#   theme_classic() +
#   theme(axis.text.x=element_text(angle= 30, hjust = 1)) +
#   labs( title = ' ', 
#         fill = '',
#         x = '', y = 'Eventos') +
#   theme(plot.title = element_text(hjust = 0.5, size = 13),legend.position = 'none') +
#   scale_fill_manual(values = c('#748DAE', '#78C841', 'grey')) 
#   
# 
# grafica_comorb <- ggplotly(g, tooltip = c("text"))
# grafica_comorb





# Usando la libreria highcharter

tbl_comorb_irag <- base_comorb %>% 
  filter(CLASIFICACION_MANUAL == 'Infección respiratoria aguda grave (IRAG)') %>% 
  count(EDAD_UC_IRAG_2, comorb) %>% 
  pivot_wider(names_from = comorb, values_from = n)

grafica_comorb_irag <- highchart() |>
  hc_chart(type = "column") |>
  hc_xAxis(categories = tbl_comorb_irag$EDAD_UC_IRAG_2,
           title = list(text = "Grupo etario"),
           labels = list(rotation = -45)) |>
  hc_yAxis(title = list(text = "Cantidad de casos")) |>
  hc_plotOptions(column = list(stacking = "normal")) |>
  hc_add_series(name = "Sin datos", 
          data = tbl_comorb_irag$`Sin Dato de Comorbilidades`, color = "#7f7f7f") |>
  hc_add_series(name = "Sin Comorbilidades", 
                data = tbl_comorb_irag$`Sin Comorbilidades`, color = "#ff7f0e") |>
  hc_add_series(name = "Con Comorbilidades", 
                data = tbl_comorb_irag$`Con Comorbilidades`, color = "#1f77b4") |>
  hc_title(text = "Presencia de Comorbilidades: Infección respiratoria aguda grave (IRAG)")






tbl_comorb_irag_ext <- base_comorb %>% 
  filter(CLASIFICACION_MANUAL == 'IRAG extendida') %>% 
  count(EDAD_UC_IRAG_2, comorb) %>% 
  pivot_wider(names_from = comorb, values_from = n)


tbl_comorb_irag_ext <- left_join(tbl_comorb_irag[,1], tbl_comorb_irag_ext)



grafica_comorb_irag_extend <- highchart() |>
  hc_chart(type = "column") |>
  hc_xAxis(categories = tbl_comorb_irag_ext$EDAD_UC_IRAG_2,
           title = list(text = "Grupo etario"),
           labels = list(rotation = -45)) |>
  hc_yAxis(title = list(text = "Cantidad de casos")) |>
  hc_plotOptions(column = list(stacking = "normal")) |>
  hc_add_series(name = "Sin datos", 
                data = tbl_comorb_irag_ext$`Sin Dato de Comorbilidades`, color = "#7f7f7f") |>
  hc_add_series(name = "Sin Comorbilidades", 
                data = tbl_comorb_irag_ext$`Sin Comorbilidades`, color = "#ff7f0e") |>
  hc_add_series(name = "Con Comorbilidades", 
                data = tbl_comorb_irag_ext$`Con Comorbilidades`, color = "#1f77b4") |>
  hc_title(text = "Presencia de Comorbilidades: IRAG extendida")





# Tabla con diferentes comorbilidades

# compare_df_cols(base) %>% view()


frec_comorb <- base %>% filter(PRESENCIA_COMORBILIDADES == 1) %>%  # 1
  select(IDEVENTOCASO, c(54:86), poblacion) %>%                    # 2
  pivot_longer(c(2:34), names_to = 'comorbilidad', values_to = 'n') %>%   # 3
  filter(n == 1) %>%                                               # 4
  count(poblacion, comorbilidad)                               # 5

frec_comorb$comorbilidad <- str_replace_all( frec_comorb$comorbilidad,"[ _ ]", " ")
frec_comorb$comorbilidad <- str_to_title(frec_comorb$comorbilidad)


# 1- Filtro todos los eventos dónde la variable PRESENCIA_COMORBILIDADES == 1
#    lo que significa que se registro alguna comorbilidad
# 2- Elijo las variables IDEVENTOCASO, poblacion (la creamos nosostros y  
#    puede toma los valores 'Adultos' o 'Pediatrica'), y las columnas que representan
#    la lista de comorbilidades posibles que están desde la columna 54 hasta la 86
# 3- Agrupo todas las columnas de comorbilidades en una nueva
# 4- Filtro las filas que tienen valor igual a 1 lo que significa presencia de comorbilidad específica
# 5- Realizo una tabla de frecuencia para cada comorbilidad y poblacion



# Adultos

adultos_tot <- nrow(base %>% filter( poblacion == 'Adultos'))
adultos_con_comorb <- nrow(base %>% filter(PRESENCIA_COMORBILIDADES == 1, poblacion == 'Adultos'))



comorb_adult <- frec_comorb %>% filter(poblacion == 'Adultos') %>% 
  group_by(comorbilidad) %>% 
  summarise(cantidad = sum(n),
            Proporción = paste(round(cantidad/adultos_con_comorb *100,1), '%')) %>% 
  arrange(desc(cantidad)) %>% head(5) %>% 
  select(-cantidad)


tbl_comorb_adult <- flextable(comorb_adult) %>% 
  set_header_labels (comorbilidad = 'Comorbilidades') %>% 
  width(j = ~ comorbilidad,  width = 2) %>% 
  theme_vanilla() %>% 
  align(align = "right",  j = 2) %>% 
  bg(bg='#708993', part = 'header')  %>% 
  color(color = 'white', part = 'header') 



# Pediatricos

pediat_tot <- nrow(base %>% filter( poblacion == 'Pediatrica'))
pediat_con_comorb <- nrow(base %>% filter(PRESENCIA_COMORBILIDADES == 1, poblacion == 'Pediatrica'))



comorb_pediat <- frec_comorb %>% filter(poblacion == 'Pediatrica') %>% 
  group_by(comorbilidad) %>% 
  summarise(cantidad = sum(n),
            Proporción = paste(round(cantidad/adultos_con_comorb *100,1), '%'))%>% 
  arrange(desc(cantidad)) %>% head(5) %>% 
  select(-cantidad)


tbl_comorb_pediat <- flextable(comorb_pediat) %>% 
  set_header_labels (comorbilidad = 'Comorbilidades') %>% 
  width(j = ~ comorbilidad,  width = 2) %>% 
  theme_vanilla() %>% 
  align(align = "right",  j = 2) %>% 
  bg(bg='#708993', part = 'header')  %>% 
  color(color = 'white', part = 'header') 












