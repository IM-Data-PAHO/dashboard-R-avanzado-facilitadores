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
dosis <- rnve %>% 
  # Filtramos solo para Primera dosis
  filter(dosis == "Primera") %>% 
  # Calculemos el año de cada evento de vacunación
  mutate(ano = substr(fecha_vac, 1, 4)) %>% 
  mutate(ano = as.numeric(ano)) %>% 
  # Agrupemos por año y dosis
  group_by(ano, dosis) %>% 
  # Calculemos cuantas vacunas fueron aplicadas para cada año y dosis
  tally(name = "total_dosis")
cobertura <- dosis %>% 
  # Juntemos el numero de dosis por año y vacuna (dosis) con la población
  # objetivo para ese año (pop_LT1).
  left_join(., POPLT1, by = c("ano" = "year")) %>% 
  # De tal forma que la cobertura resulta ser:
  mutate(across(c(total_dosis, n), ~ as.numeric(.))) %>% 
  mutate(cobertura = total_dosis / n  * 100) %>% 
  mutate(cobertura = round(cobertura, 0)) %>%
  # Falla primaria
  mutate(falla_primaria = 5) %>% 
  # Inmunizados
  mutate(inmunizados = cobertura - falla_primaria) %>% 
  # Susceptibles
  mutate(susceptibles = round( n * ((100 - inmunizados) / 100), 0 )) %>% 
  # Desagrupamos para hacer el calculo de susceptibles acumulado
  ungroup %>% 
  arrange(ano) %>% 
  mutate(susceptibles_acumulado = cumsum(susceptibles))


