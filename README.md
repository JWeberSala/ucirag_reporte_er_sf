# Introducción

Este proyecto fue creado para obtener un reporte automatizado de la información recolectada en Unidades Centinelas.

# Objetivo del análisis

Analizar las características clínicas, de laboratorio y epidemiológicas de las personas con IRAG e IRAG extendida correspondientes a las Unidades Centinela de las jurisdicciones de Santa Fe y Entre Ríos.

# Período de estudio

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

Clasificación manual: Definición de caso (IRAG o IRAG extendida) de acuerdo a lo registrado por el usuario que notificó el caso. Se considerarán todas las clasificación con excepción de los casos “invalidades por epidemiología”.

A partir de las determinaciones de laboratorio, se actualiza la clasificación manual en la base para lo cual quien clasificó el caso, debió considerar lo suguiente:

-   Determinación influenza: realización de PCR para influenza positiva.

-   Determinación VSR: realización de PCR para VSR positiva.

-   Determinación SARS-COV-2: realización de PCR para SARS-COV-2 positiva.

-   Resultado de las pruebas de laboratorio: negativo para cada determinación.

-   Resultado de las pruebas de laboratorio: sin resultados, a los que se considerará “en estudio”

### Información clínica asociada al caso:

-   Fecha de internación: Fecha en la que el caso fue internado debido a la IRAG.

-   Semana Epidemiológica de internación: Semana epidemiológica que corresponde a la fecha de internación.

-   Año de internación: Año que corresponde a la fecha de internación.

-   Comorbilidades: presencia de al menos una comorbilidad en el caso.

-   Fallecimiento: desenlace fatal del caso.

# Criterios de inclusión y exclusión

### Inclusión:

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

-   distribución de los de los casos de IRAG e IRAG extendida por grupos de edad según condición de fallecido o no.

# Mapa del circuito de datos

El flujo de los datos desde la captación hasta su análisis final es el siguiente:

1)  en el establecimiento (Unidad Centinela) se recolecta la información y carga en el SNVS 2.0.

2)  procesamiento de la base en nación para tener una base con un único registro por paciente.

3)  envío semanal desde nación a las provincias de la base.

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

-   distribución de los de los casos de IRAG e IRAG extendida por grupos de edad según condición de fallecido o no.
