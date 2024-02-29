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
    box(p("Descripción algo mas"), width = 12, title = "Inicio")
  })
  # Integrantes del equipo
  output$team_textbox <- renderUI({
    box(p("Alejandro, Dan, Rafa, Camilo y yo"), width = 12, title = "Equipo de trabajo")
  })
  ### Justificacion ------------------------------------------------------------
  # Cuadro informativo para seccion de Justificacion
  output$justificacion_textbox <- renderUI({
    box(p("Descripción"), width = 12, title = "Justificacion")
  })
  
  # Gráfica --------------------------------------------------------------------
  output$justificacion_graph <- renderPlot({
    ggplot(cobertura, aes(x = ano)) +
      # Nombres de ejes
      labs(
        title = "Susceptibles acumulados en los últimos 5 años",
        x = "Año",
        y = "Susceptibles Acumulados"
      ) +
      # Cobertura en barras
      geom_bar(aes(y = cobertura * 400), position = "dodge", stat = "identity", fill = "#094775") +
      # Susceptibles acumulados en lineas
      geom_line(aes(y = susceptibles_acumulado), colour = "#ff671f", linewidth = 1) +
      # Ajustamos los dos ejes verticales
      scale_y_continuous(
        # Las dosis alcanzan cerca de 40 mil
        limits = c(0, 40e3),
        # Agregamos un segundo eje horizontal para cobertura (con mismo factor
        # de conversion que en geom_bar)
        sec.axis = sec_axis( trans= ~./400, name = "Cobertura (%)")
      ) +
      # Ajuste de eje X
      scale_x_continuous(breaks = seq(2018, 2023, 1)) +
      # Ajustes visuales
      theme_classic() +
      theme(text = element_text(size = 16))
  })
  
  # Cuadro ---------------------------------------------------------------------
  output$justificacion_table <- renderDataTable({
    datatable(
      cobertura_cuadro,
      colnames = c("Año", "Municipio", "Población", "Vacunados", "Susceptibles"),
      options = list(pageLength = 8)
    )
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