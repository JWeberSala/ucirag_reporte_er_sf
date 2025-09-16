
#Totales para el texto general
total_eventos <- nrow(base)
totalIRAG <- sum(base$CLASIFICACION_MANUAL=="Infección respiratoria aguda grave (IRAG)")
total_IRAGext<- sum(base$CLASIFICACION_MANUAL=="IRAG extendida")
men_15 <- sum(base$EDAD_DIAGNOSTICO<15)
may_15<- sum(base$EDAD_DIAGNOSTICO>=15)


