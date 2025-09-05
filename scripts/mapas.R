library(geoAr)
library(tidyverse)
library(leaflet)



establecimientos <- read_excel('data/establ_coord.xlsx')



mapa_establ<- leaflet() %>%
  addArgTiles() %>% 
  addCircleMarkers(
    data = establecimientos,
    ~long, ~lat,
    popup = ~paste0("<b>Nombre:</b> ", Establecimiento, "<br>",
                    "<b>Localidad:</b> ", Localidad, "<br>",
                    "<b>Provincia:</b> ", Provincia, "<br>"),
    color = "blue",
    radius = 5,
    fillOpacity = 0.7
  )



