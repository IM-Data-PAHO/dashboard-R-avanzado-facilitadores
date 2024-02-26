# server.R ---------------------------------------------------------------------
# Description: Este script crea un servidor, que representa una sesión de R
# que corre código y devuelve resultados (p. ej., una gráfica).
# Created by -------------------------------------------------------------------
# Name: CIM Data Team
# Created on: 2024-01-29
# Editorial --------------------------------------------------------------------
# Section for editorial changes or notes
# ______________________________________________________________________________

# Inicializar el servidor ------------------------------------------------------
shinyServer(function(input, output) {
  ## Elementos del UI ----------------------------------------------------------
  ### Inicio -------------------------------------------------------------------
  # Cuadro informativo para seccion de Inicio
  output$inicio_textbox <- renderUI({
    box(p("Descripción"), width = 12, title = "Inicio")
  })
  ### Justificacion ------------------------------------------------------------
  # Cuadro informativo para seccion de Justificacion
  output$justificacion_textbox <- renderUI({
    box(p("Descripción"), width = 12, title = "Justificacion")
  })
  
  # Gráfica --------------------------------------------------------------------
  output$justificacion_graph <- renderPlot({
    plot(x = 1:10, y = 11:20)
  })
  
  # Cuadro ---------------------------------------------------------------------
  output$justificacion_table <- renderDataTable({
    data(iris)
    datatable(iris)
  })
  
  
  ### Avance de campaña --------------------------------------------------------
  # Cuadro informativo para seccion de Avance de campaña
  output$avance_campana_textbox <- renderUI({
    box(p("Descripción"), width = 12, title = "Avance de Campaña")
  })
  ### Georreferenciación -------------------------------------------------------
  # Cuadro informativo para seccion de Georreferenciación
  output$georreferenciacion_textbox <- renderUI({
    box(p("Descripción"), width = 12, title = "Georreferenciación")
  })
})