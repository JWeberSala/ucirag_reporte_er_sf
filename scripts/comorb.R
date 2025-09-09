library(tidyverse)
library(readr)
library(readxl)
library(janitor)
library(stringr)
library(lubridate)
library(highcharter)
library(plotly)


base_comorb <- base %>%
  mutate(comorb = case_when(
            PRESENCIA_COMORBILIDADES == 1 ~ "Con Comorbilidades",
            PRESENCIA_COMORBILIDADES == 2 ~ "Sin Comorbilidades",
            PRESENCIA_COMORBILIDADES == 9 ~ "Sin Dato de Comorbilidades"))





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



