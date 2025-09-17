library(flextable)

#fallecidos

n_fallecidos<- sum(base$FALLECIDO=="SI",na.rm=T)
falle_flu<-sum(
  base$FALLECIDO == "SI" &
    base$INFLUENZA_FINAL != "Sin resultado" &
    base$INFLUENZA_FINAL != "Negativo",
  na.rm = TRUE
)

falle_VSR<-sum(
  base$FALLECIDO == "SI" &
    base$VSR_FINAL != "Sin resultado" &
    base$VSR_FINAL != "Negativo",
  na.rm = TRUE
)

falle_COVID<- sum(
  base$FALLECIDO == "SI" &
    base$COVID_19_FINAL != "Sin resultado" &
    base$COVID_19_FINAL != "Negativo",
  na.rm = TRUE
) 

#frases según si hay o no fallecidos

frase_nro_falle <- ifelse (n_fallecidos==0, "Durante el período no se registraron casos fallecidos", 
                           paste0("Durante el período se registraron ", n_fallecidos, " personas fallecidas."))


falle_etiología_flu <- ifelse (falle_flu>=1 , paste0(falle_flu, " tuvieron diagnóstico Influenza"),
                          )

falle_etiología_COVID <- ifelse (falle_COVID>=1 , paste0(falle_COVID, " tuvieron diagnóstico a COVID"),
"Ningún fallecido tuvo diagnóstico de COVID")

falle_etiología_VSR <- ifelse (falle_VSR>=1 , paste0(falle_VSR, " tuvieron diagnóstico a VSR"),
"Ningún fallecido tuvo diagnóstico de VSR")


#Casos fallecidos por diagnóstico etiológico

base_fallecidos <- base %>% 
  filter(FALLECIDO == "SI")

#Genero base de dx final y evaluación de codetecciones

base_fallecidos <- base_fallecidos %>% 
  mutate( DX_FINAL = case_when (
    (INFLUENZA_FINAL=="Influenza A H1N1"|
       INFLUENZA_FINAL=="Influenza A H3N2"|
       INFLUENZA_FINAL=="Influenza A (sin subtipificar)"|
       INFLUENZA_FINAL=="Influenza B Victoria"|
       INFLUENZA_FINAL=="Influenza B Yamagata"|
       INFLUENZA_FINAL=="Influenza B (sin linaje)"|
       INFLUENZA_FINAL=="Influenza positivo-Sin Tipo") &  
      ( VSR_FINAL=="Negativo" | VSR_FINAL == "Sin resultado") &
      ( COVID_19_FINAL=="Negativo" | COVID_19_FINAL == "Sin resultado")  ~ INFLUENZA_FINAL,
    
    (VSR_FINAL=="VSR B"|
       VSR_FINAL=="VSR A"|
       VSR_FINAL=="VSR") &
      ( INFLUENZA_FINAL=="Negativo" | INFLUENZA_FINAL == "Sin resultado") &
      ( COVID_19_FINAL=="Negativo" | COVID_19_FINAL == "Sin resultado")  ~ "VSR",
    
    (COVID_19_FINAL=="Positivo") &
      ( INFLUENZA_FINAL=="Negativo" | INFLUENZA_FINAL == "Sin resultado") &
      ( VSR_FINAL=="Negativo" | VSR_FINAL == "Sin resultado")  ~ "SARS-CoV-2",
    
    
    ( INFLUENZA_FINAL!="Negativo" & INFLUENZA_FINAL != "Sin resultado") &
      ( VSR_FINAL!="Negativo" & VSR_FINAL != "Sin resultado")  ~ "Co detección VSR - Influenza",
    
    ( INFLUENZA_FINAL!="Negativo" & INFLUENZA_FINAL != "Sin resultado") &
      ( COVID_19_FINAL!="Negativo" & COVID_19_FINAL != "Sin resultado")  ~ "Co detección SARS CoV 2 - Influenza",
    
    ( VSR_FINAL!="Negativo" & VSR_FINAL != "Sin resultado") &
      ( COVID_19_FINAL!="Negativo" & COVID_19_FINAL != "Sin resultado")  ~ "Co detección SARS CoV 2 - VSR",
    
    VSR_FINAL=="Negativo" &
      INFLUENZA_FINAL=="Negativo" &
      COVID_19_FINAL=="Negativo"  ~ "Estudiado Negativo",
    
    TRUE  ~ "En estudio" ))

orden_dx = c(
  "Influenza A H1N1",
  "Influenza A H3N2",
  "Influenza A (sin subtipificar)",
  "Influenza B Victoria",
  "Influenza B Yamagata",
  "Influenza B (sin linaje)",
  "Influenza positivo-Sin Tipo",
  "VSR",
  "SARS-CoV-2",
  "Co detección VSR - Influenza",
  "Co detección SARS CoV 2 - Influenza",
  "Co detección SARS CoV 2 - VSR",
  "Estudiado Negativo",
  "En estudio"
)

base_fallecidos$DX_FINAL<-as.factor(base_fallecidos$DX_FINAL)
base_fallecidos$DX_FINAL <- factor(base_fallecidos$DX_FINAL,
                                              levels = orden_dx)

unique(base$EDAD_UC_IRAG_2)

#Tabla por etiologia

frec_falle <- base_fallecidos %>% 
  group_by(EDAD_UC_IRAG_2, DX_FINAL) %>% 
  summarise(cantidad = n () )%>% 
 spread(DX_FINAL, cantidad )

orden_edad<- c(
      "Menores de 6 Meses",
      "6 a 11 Meses",
      "12 a 23 Meses",
      "02 a 04 Años",
      "05 a 09 Años",
      "10 a 14 Años",
      "15 a 19 Años",
      "20 a 24 Años",
      "25 a 29 Años",
      "30 a 34 Años",
      "35 a 39 Años",
      "40 a 44 Años",
      "45 a 49 Años",
      "50 a 54 Años",
      "55 a 59 Años",
      "60 a 64 Años",
      "65 a 69 Años",
      "70 a 74 Años",
      "75 y más Años",
      "Sin Especificar"
    )

tabla_edad <- as.data.frame(orden_edad )


# frec_falle <- tabla_edad %>% 
#   left_join(frec_falle, by = c("orden_edad" = "EDAD_UC_IRAG_2" )) %>% 
#   rename( "Grupo de Edad" = "orden_edad")


frec_falle <- frec_falle %>%
  rename( "Grupo de Edad" = "EDAD_UC_IRAG_2")

frec_falle <- frec_falle %>%
  mutate(across(where(is.numeric), ~replace_na(., 0)))



tbl_frec_falle <- flextable(frec_falle) %>% 
  theme_vanilla() %>% 
  align(align = "right",  j = 2) %>% 
  bg(bg='#708993', part = 'header')  %>% 
  color(color = 'white', part = 'header') 



