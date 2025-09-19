 library(tidyverse)
 library(readr)
 library(readxl)
 library(janitor)
 library(stringr)
 library(lubridate)
 library(plotly)


tbl_curvas <- base %>% 
              count(SEPI_FECHA_INTER, poblacion)


g <- ggplot(tbl_curvas) +
  geom_bar(aes(x = SEPI_FECHA_INTER, y = n, fill = poblacion,
               text = paste( 'Semana ', SEPI_FECHA_INTER, '<br>',
                            'Eventos:',  n)), 
           stat = 'identity', width = 1) +
  facet_wrap(~poblacion, ncol = 1) +
  theme_bw() +
  scale_x_continuous(breaks = seq(1,52,1)) +
  scale_y_continuous(breaks = seq(0, 20, 2)) +
  scale_fill_manual(values = c('#748DAE', '#78C841'))+
  labs( title = 'Eventos según semana de internación', 
        fill = '',
        x = 'Semana de Internación', y = 'Eventos',) +
  theme(plot.title = element_text(hjust = 0.5, size = 13), legend.position = 'none')

  
grafico_curvas <- ggplotly(g, tooltip = c("text")) 

  
# cantidad de semanas con al menos un caso
semanas_con_casos <- tbl_curvas %>%
  filter(n > 0) %>%
  summarise(cant = n_distinct(SEPI_FECHA_INTER)) %>%
  pull(cant)

# semana con mayor número de casos
semana_max_casos <- tbl_curvas %>%
  filter(n == max(n)) %>%
  slice(1) %>%   # por si hay más de una semana empatada
  select(SEPI_FECHA_INTER, n)

# armar frases para incluir en el informe
frase_semanas <- paste0("Se registraron casos en ", semanas_con_casos, 
                        " semanas del año.")

frase_max <- paste0("La mayor notificación se observó en la semana ", 
                    semana_max_casos$SEPI_FECHA_INTER, 
                    " con ", semana_max_casos$n, " casos.")




  
