
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



