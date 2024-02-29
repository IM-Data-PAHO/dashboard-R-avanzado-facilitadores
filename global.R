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
#pool <- dbPool(RPostgres::Postgres(),
#               host = host,
#               dbname = name,
#               user = user,
#               password = pass,
#               port = 5432)


#onStop(function() {
#  poolClose(pool)
#})
# Funcionamiento de DB Pool 
#rnve <- tbl(pool, "rnve")
#pop_LT1 <- tbl(pool, "poplt1")
# Carga de RData ---------------------------------------------------------------

# Inicio -----------------------------------------------------------------------
# Justificación ----------------------------------------------------------------
# Avanca de campaña ------------------------------------------------------------
# Georreferenciación -----------------------------------------------------------
