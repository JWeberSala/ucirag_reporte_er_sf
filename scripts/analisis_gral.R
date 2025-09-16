
#Totales para el texto general
total_eventos <- nrow(base)
totalIRAG <- sum(base$CLASIFICACION_MANUAL=="Infección respiratoria aguda grave (IRAG)")
total_IRAGext<- sum(base$CLASIFICACION_MANUAL=="IRAG extendida")
men_15 <- sum(base$EDAD_DIAGNOSTICO<15)
may_15<- sum(base$EDAD_DIAGNOSTICO>=15)


#Para determinaciones, por virus
nro_COVID<- sum(
  base$COVID_19_FINAL != "Sin resultado" &
    base$COVID_19_FINAL != "Negativo",
  na.rm = TRUE
) 

nro_FLU<- sum(
  base$INFLUENZA_FINAL != "Sin resultado" &
    base$INFLUENZA_FINAL != "Negativo",
  na.rm = TRUE
) 

nro_VSR<- sum(
  base$VSR_FINAL != "Sin resultado" &
    base$VSR_FINAL != "Negativo",
  na.rm = TRUE
) 


#para frase de determinaciones
frase_COVID <- ifelse(nro_COVID > 0,
                      paste0(nro_COVID, " casos de COVID-19"),
                      NA)

frase_FLU <- ifelse(nro_FLU > 0,
                    paste0(nro_FLU, " casos de Influenza"),
                    NA)

frase_VSR <- ifelse(nro_VSR > 0,
                    paste0(nro_VSR, " casos de VSR"),
                    NA)

# Unir frases que no son NA
frases_pos <- na.omit(c(frase_COVID, frase_FLU, frase_VSR))

# Construir frase final
frase_detecciones <- ifelse(
  length(frases_pos) == 0,
  "No se contó con resultados positivos de COVID-19, Influenza y VSR.",
  paste0("Se detectaron ", paste(frases_pos, collapse = ", "), ".")
)

if (length(frases_pos) > 1) {
  ultima_coma <- sub(", ([^,]+)$", " y \\1", frase_detecciones)
  frase_detecciones <- ultima_coma
}
