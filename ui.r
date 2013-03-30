library(shiny)

shinyUI(pageWithSidebar(
  
  headerPanel(title=HTML("usgs demo"), windowTitle="ropensci-USGS"),
  
  sidebarPanel(
    wellPanel(
    	h4(strong("Input your taxon names:")),
      textInput(inputId="spec", label="We're using Phylomatic on the backend, so plants only for now. Enter species names, spelled correctly, separated by commas", 
                value="Carpobrotus edulis,Rosmarinus officinalis,Ageratina riparia"),
      HTML("<br>"),
      HTML("An example query w/ more species: Bidens pilosa,Ambrosia artemisifolia,Ageratina riparia,Acroptilon repens,Ageratina adenophora,Aegilops triuncialis,Agrostis capillaris,Cinchona pubescens,Salix babylonica,Pinus caribaea")
    ),
    
    wellPanel(
    	h4(strong("ITIS options:")),
      checkboxInput(inputId = "gethierarchyupfromtsn",
                    label = strong("Parent taxon"),
                    value = FALSE),
    	
    	checkboxInput(inputId = "gethierarchyupfromtsn",
                    label = strong("Downstream hierarchy"),
                    value = FALSE),
    	
    	checkboxInput(inputId = "gethierarchyupfromtsn",
                    label = strong("Etc"),
                    value = FALSE),
    	
    	checkboxInput(inputId = "gethierarchyupfromtsn",
                    label = strong("Get synonyms"),
                    value = FALSE)
    ),
    
    submitButton("Update View"),
    
    HTML("<br><br>")
    
  ),
  
  mainPanel(
    tabsetPanel(
    	tabPanel("ITIS Data", tableOutput("itis_data")),
      tabPanel("Invasive?", tableOutput("invasiveness")),
      tabPanel("Phylogeny", plotOutput("phylogeny")),
      tabPanel("Map", plotOutput("map"))
    )
  )
  
))