# global.R ---------------------------------------------------------------------
# Description: Este script carga toda la información y paquetes necesarios
# para ejecutar el dashboard.
# Created by -------------------------------------------------------------------
# Name: CIM Data Team
# Created on: 2024-01-29
# Editorial --------------------------------------------------------------------
# Section for editorial changes or notes
# ______________________________________________________________________________

# Requerimientos ---------------------------------------------------------------
source("requirements.R")
source("local_settings.R")
# Conexión a bases -------------------------------------------------------------
pool <- dbPool(RPostgres::Postgres(),
               host = host,
               dbname = name,
               user = user,
               password = pass,
               port = 5432)


onStop(function() {
  poolClose(pool)
})

rnve <- tbl(pool, "rnve")
pop_LT1 <- tbl(pool, "poplt1")
# Inicio -----------------------------------------------------------------------
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
  left_join(., pop_LT1, by = c("ano" = "year")) %>% 
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
  dbplyr::window_order(ano) %>% 
  mutate(susceptibles_acumulado = cumsum(susceptibles))
# Avanca de camapaña -----------------------------------------------------------
# Georreferenciación -----------------------------------------------------------
