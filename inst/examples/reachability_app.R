library(shiny)
library(leaflet)
library(leaflet.extras2)

## Include your API-Key
# Sys.setenv("OPRS" = 'Your_API_Key')
apikey <- Sys.getenv("OPRS")

ui <- fluidPage(
  icon("cars"), ## needed to load FontAwesome Lib
  leafletOutput("map")
  ,actionButton("removeReachability", "removeReachability")
)

server <- function(input, output, session) {
  output$map <- renderLeaflet({
    leaflet() %>%
      addTiles(group = "base") %>%
      setView(8, 50, 11) %>%
      addLayersControl(baseGroups = "base") %>%
      addReachability(apikey = apikey,
                      options = reachabilityOptions(
                        collapsed = FALSE,
                        drawButtonContent = as.character(icon("plus")),
                        deleteButtonContent = as.character(icon("minus")),
                        distanceButtonContent = as.character(icon("map-marked")),
                        timeButtonContent = as.character(icon("clock")),
                        travelModeButton1Content = as.character(icon("car")),
                        travelModeButton2Content = as.character(icon("bicycle")),
                        travelModeButton3Content = as.character(icon("walking")),
                        travelModeButton4Content = as.character(icon("wheelchair"))
                      ))
  })
  observeEvent(input$removeReachability, {
    leafletProxy("map") %>%
      removeReachability()
  })
  observeEvent(input$map_reachability_displayed, {
    print("input$map_reachability_displayed")
  })
  observeEvent(input$map_reachability_delete, {
    print("input$map_reachability_delete")
  })
  observeEvent(input$map_reachability_error, {
    print("input$map_reachability_error")
  })
}

shinyApp(ui, server)
