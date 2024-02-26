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
# Inicio -----------------------------------------------------------------------
# Justificación ----------------------------------------------------------------
registro_civil <- rio::import("./data/Registro civil - Uruguay.csv")
rnve <- rio::import("./data/RNVE - Uruguay.csv")
pop_LT1 <- rio::import("./data/POPLT1 - Uruguay.csv")
dosis <- rnve %>% 
  # Filtramos solo para Primera dosis
  filter(dosis == "Primera") %>% 
  # Calculemos el año de cada evento de vacunación
  mutate(ano = year(fecha_vac)) %>% 
  # Agrupemos por año y dosis
  group_by(ano, dosis) %>% 
  # Calculemos cuantas vacunas fueron aplicadas para cada año y dosis
  # NOTA: tally() es lo mismo que summarise(n = n()); o sea, contar cuántas
  #       filas hay en cada grupo
  # NOTA: Con el argumento name, cambiamos el nombre de la columna. En lugar
  #       de llamarse n, se llamará total_dosis.
  tally(name = "total_dosis")
cobertura <- dosis %>% 
  # Juntemos el numero de dosis por año y vacuna (dosis) con la población
  # objetivo para ese año (pop_LT1).
  # NOTA: Podemos usar la sintaxis c("ano" = "year") para igualar
  #       dos columnas que no tienen el mismo nombre, en lugar de modificar
  #       el nombre solo para este paso.
  left_join(., pop_LT1, by = c("ano" = "year")) %>% 
  # De tal forma que la cobertura resulta ser:
  mutate(cobertura = total_dosis / n  * 100) %>% 
  mutate(cobertura = round(cobertura)) %>% 
  # Falla primaria
  mutate(falla_primaria = 5) %>% 
  # Inmunizados
  mutate(inmunizados = cobertura - falla_primaria) %>% 
  # Susceptibles
  mutate(susceptibles = round( n * ((100 - inmunizados) / 100), 0 )) %>% 
  ungroup %>% 
  arrange(ano) %>% 
  mutate(susceptibles_acumulado = cumsum(susceptibles))
# Avanca de camapaña -----------------------------------------------------------
# Georreferenciación -----------------------------------------------------------
