library(shiny)

# Define UI for application that plots random distributions 
shinyUI(pageWithSidebar(
  
  headerPanel(title=HTML("usgs demo"), windowTitle="ropensci-USGS"),
  
  sidebarPanel(
    wellPanel(
      textInput(inputId="spec", label="We're using Phylomatic on the backend, so plants only for now. Enter species names, spelled correctly, separated by commas", 
                value="Carpobrotus edulis,Rosmarinus officinalis,Ageratina riparia"),
      HTML("<br>"),
      HTML("An example query w/ more species: Bidens pilosa,Ambrosia artemisifolia,Ageratina riparia,Acroptilon repens,Ageratina adenophora,Aegilops triuncialis,Agrostis capillaris,Cinchona pubescens,Salix babylonica,Pinus caribaea")
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
#     h5("A phylogeny of your selected species") ,
#     HTML("<br><br>"),
#     tableOutput("invasiveness")
  )
  
))