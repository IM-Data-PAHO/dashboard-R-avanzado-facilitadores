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

# Conexión a bases -------------------------------------------------------------
pool <- dbPool(RPostgres::Postgres(),
               host = "curso-r-avanzado.ct46escu0d28.us-east-1.rds.amazonaws.com",
               dbname = "curso-r-2024",
               user = "postgres",
               password = "cursor2024",
               port = 5432)


onStop(function() {
  poolClose(pool)
})

rnve <- tbl(pool, "rnve")
# Inicio -----------------------------------------------------------------------
# Justificación ----------------------------------------------------------------
# Avanca de camapaña -----------------------------------------------------------
# Georreferenciación -----------------------------------------------------------
