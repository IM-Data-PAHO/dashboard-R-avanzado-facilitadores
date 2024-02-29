# preprocessing.R ---------------------------------------------------------------------
# Description: Este script carga toda la información y paquetes necesarios
# para ejecutar el dashboard. Almacena el resultado en un archivo .RData
# Created by -------------------------------------------------------------------
# Name: CIM Data Team
# Created on: 2024-02-29
# Editorial --------------------------------------------------------------------
# Section for editorial changes or notes
# ______________________________________________________________________________

# Carga de paquetes
source("requirements.R")

con <- DBI::dbConnect(RPostgres::Postgres(),
                      host = "curso-r-avanzado.ct46escu0d28.us-east-1.rds.amazonaws.com",
                      dbname = "curso-r-2024",
                      user = "postgres",
                      password = "cursor2024",
                      port = 5432)


registro_civil <- dbReadTable(con, "registro-civil")
rnve <- dbReadTable(con, "rnve")
POPLT1 <- dbReadTable(con, "poplt1")

dbDisconnect(con)

# Justificación ----------------------------------------------------------------
## Cálculos para cuadro x municipio --------------------------------------------
# Eliminar cuando tengamos municipio
municipios <- c("prueba1", "prueba2")
registro_civil$cod_municipio <- sample(municipios, size = nrow(registro_civil), replace = TRUE)
# Calcular numero de vacunados a partir de RNVe
vacunados_rnve <- rnve %>% 
  filter(dosis == "Primera") %>% 
  mutate(ano = lubridate::year(fecha_vac)) %>% 
  left_join(., registro_civil %>% select(ID, cod_municipio), by = "ID") %>% 
  group_by(ano, cod_municipio) %>% 
  tally(name = "vacunados_primera")
# Calcular poblacion a partir de RNVe
pop_municipio <- registro_civil %>% 
  # Obtenemos los años de cada fecha de nacimiento
  mutate(ano = lubridate::year(fecha_nac)) %>% 
  # Para cada año, calculamos cuántas filas hay (o sea, cuántos nacimientos)
  group_by(ano, cod_municipio) %>% 
  tally(name = "poblacion")
# Calcular cobertura y susceptibles --------------------------------------------
cobertura_municipio <- vacunados_rnve %>% 
  # Obtenemos el municipio a partir del registro civil
  left_join(., pop_municipio, by = c("ano", "cod_municipio")) %>% 
  # Calculamos cobertura
  mutate(cobertura = vacunados_primera / poblacion  * 100) %>% 
  mutate(cobertura = round(cobertura, 0)) %>%
  # Falla primaria
  mutate(falla_primaria = 5) %>% 
  # Inmunizados
  mutate(inmunizados = cobertura - falla_primaria) %>% 
  # Susceptibles
  mutate(susceptibles = round( poblacion * ((100 - inmunizados) / 100), 0 )) %>% 
  # Desagrupamos para hacer el calculo de susceptibles acumulado
  ungroup %>% 
  arrange(ano) %>% 
  mutate(susceptibles_acumulado = cumsum(susceptibles))
# Resumen para grafica 1 -------------------------------------------------------
cobertura <- cobertura_municipio %>% 
  # Resumimos para año, sin tomar en cuenta al municipio
  group_by(ano) %>% 
  summarise(
    across(c(vacunados_primera, poblacion), ~ sum(.))
  ) %>% 
  # El mismo calculo de cobertura que se hizo arriba
  mutate(cobertura = vacunados_primera / poblacion  * 100) %>% 
  mutate(cobertura = round(cobertura, 0)) %>%
  # Falla primaria
  mutate(falla_primaria = 5) %>% 
  # Inmunizados
  mutate(inmunizados = cobertura - falla_primaria) %>% 
  # Susceptibles
  mutate(susceptibles = round( poblacion * ((100 - inmunizados) / 100), 0 )) %>% 
  # Desagrupamos para hacer el calculo de susceptibles acumulado
  ungroup %>% 
  arrange(ano) %>% 
  mutate(susceptibles_acumulado = cumsum(susceptibles))
# Resumen para cuadro 1 --------------------------------------------------------
cobertura_cuadro <- cobertura_municipio %>% 
  # Elejimos las columnas que queremos mostrar
  select(ano, cod_municipio, poblacion, vacunados_primera, susceptibles)
