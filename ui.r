require(shiny)
require(rCharts)

shinyUI(pageWithSidebar(
  
  headerPanel(title=HTML("TaxaViewer - <i>Species exploration</i> "), windowTitle="TaxaViewer"),
  
  sidebarPanel(
    
    HTML('<style type="text/css">
         .row-fluid .span4{width: 26%;}
         .leaflet {height: 600px; width: 830px;}
         </style>'),
    
    wellPanel(
      HTML('
         <style type="text/css">
          .btn {float: left;}
         </style>'),
      
      submitButton("Submit"),
      
      includeHTML('egsmodal.html'),

      HTML('<textarea id="spec" rows="3" cols="50">Carpobrotus edulis,Rosmarinus officinalis,Ageratina riparia</textarea>')
    ),
    
    # Map options 
    wellPanel(
      h5(strong("Map options:")),
      # number of occurrences for map
      sliderInput(inputId="numocc", label="Select max. number of occurrences to search for per species", min=0, max=500, value=50),
      # color palette for map
      selectInput(inputId="palette", label="Select color palette", 
                  choices=c("Blues","BlueGreen","BluePurple","GreenBlue","Greens","Greys","Oranges","OrangeRed","PurpleBlue","PurpleBlueGreen","PurpleRed","Purples","RedPurple","Reds","YellowGreen","YellowGreenBlue","YlOrBr","YellowOrangeRed",
                            "BrownToGreen","PinkToGreen","PurpleToGreen","PurpleToOrange","RedToBlue","RedToGrey","RedYellowBlue","RedYellowGreen","Spectral"), selected="Blues"),
      selectInput('provider', 'Select map provider for interactive map', 
                  choices = c("OpenStreetMap.Mapnik","OpenStreetMap.BlackAndWhite","OpenStreetMap.DE","OpenCycleMap","Thunderforest.OpenCycleMap","Thunderforest.Transport","Thunderforest.Landscape","MapQuestOpen.OSM","MapQuestOpen.Aerial","Stamen.Toner","Stamen.TonerBackground","Stamen.TonerHybrid","Stamen.TonerLines","Stamen.TonerLabels","Stamen.TonerLite","Stamen.Terrain","Stamen.Watercolor","Esri.WorldStreetMap","Esri.DeLorme","Esri.WorldTopoMap","Esri.WorldImagery","Esri.WorldTerrain","Esri.WorldShadedRelief","Esri.WorldPhysical","Esri.OceanBasemap","Esri.NatGeoWorldMap","Esri.WorldGrayCanvas","Acetate.all","Acetate.basemap","Acetate.terrain","Acetate.foreground","Acetate.roads","Acetate.labels","Acetate.hillshading"),
                  selected = 'MapQuestOpen.OSM'
      ),
      
      includeHTML('providersmodal.html')
    ),
    
    sliderInput(inputId="paperlim", label="Number of papers to return", min=1, max=50, value=10, step=1, ticks=TRUE),
    
    wellPanel(
      includeHTML('infomodal.html')
    )
    
  ),
     
  mainPanel(
    tabsetPanel(
      tabPanel("Name Resolution", includeHTML('tnrs.html'), tableOutput("tnrs")),               
      tabPanel("ITIS Classification", includeHTML('classmodal.html'), tableOutput("rank_names")),
      tabPanel("Phylogeny", includeHTML('phylogenymodal.html'), plotOutput("phylogeny")),
      tabPanel("Interactive map", includeHTML('mapmodal.html'), mapOutput('map_rcharts')),
      tabPanel("Papers", includeHTML('papersmodal.html'), htmlOutput('papers'))
    ),
  includeHTML('gauges.html')
  )
))
