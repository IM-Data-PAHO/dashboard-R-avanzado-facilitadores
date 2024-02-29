# ui.R -------------------------------------------------------------------------
# Description: Este script crea la interfaz de usuario de la aplicación de
# Shiny.
# Created by -------------------------------------------------------------------
# Name: CIM Data Team
# Created on: 2024-01-29
# Editorial --------------------------------------------------------------------
# Section for editorial changes or notes
# ______________________________________________________________________________

# Inicializar la UI ------------------------------------------------------------
fluidPage(
## CSS -------------------------------------------------------------------------
  includeCSS("style.scss"),
## Inicializar dashboard -------------------------------------------------------
  dashboardPage(
## Header dashboard ------------------------------------------------------------
    dashboardHeader(title = paste0(Sys.Date())),
## Sidebar dashboard -----------------------------------------------------------
    dashboardSidebar(
      sidebarMenu(
        # Modulo 1: Inicio
        menuItem(text = "Inicio",
                 tabName = "inicio",
                 icon = icon("home"),
                 selected = TRUE
        ),
        # Modulo 2: Justificacion
        menuItem(text = "Justificación",
                 tabName = "justificacion",
                 icon = icon("th-large")
        ),
        # Modulo 3: Avance Campaña
        menuItem(text = "Avance Campaña",
                 tabName = "avance_campana",
                 icon = icon("th-large")
        ),
        # Modulo 4: Georreferenciacion
        menuItem(text = "Georreferenciacion",
                 tabName = "georreferenciacion",
                 icon = icon("th-large")
        )
      )
    ),
## Cuerpo dashboard ------------------------------------------------------------
    dashboardBody(
      tabItems(
        ### Inicio -------------------------------------------------------------
        tabItem(tabName = "inicio",
                fluidRow(uiOutput(outputId = "inicio_textbox")),
                fluidRow(
                  box(width = 6, height = 450),
                  box(width = 6, height = 450, uiOutput(outputId = "team_textbox"))
                 )
                ),
        
        ### Justificacion ------------------------------------------------------
        tabItem(tabName = "justificacion",
                fluidRow(uiOutput(outputId = "justificacion_textbox")),
                fluidRow(
                  box(width = 6, height = 450, plotOutput(outputId = "justificacion_graph")),
                  box(width = 6, height = 450, dataTableOutput(outputId = "justificacion_table"))
                  )
                ),
        ### Avance de campaña --------------------------------------------------
        tabItem(tabName = "avance_campana",
                fluidRow(uiOutput(outputId = "avance_campana_textbox"))),
        ### Georreferenciación -------------------------------------------------
        tabItem(tabName = "georreferenciacion",
                fluidRow(uiOutput(outputId = "georreferenciacion_textbox")))
      )
    )
  )
)