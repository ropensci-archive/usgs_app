library(shiny)

shinyUI(pageWithSidebar(
  
  headerPanel(title=HTML("usgs demo"), windowTitle="ropensci-USGS"),
  
  sidebarPanel(
    wellPanel(
    	h4(strong("Input your taxon names:")),
      textInput(inputId="spec", label="We're using Phylomatic on the backend, so plants only for now. Enter species names, spelled correctly, separated by commas", 
                value="Carpobrotus edulis,Rosmarinus officinalis,Ageratina riparia"),
      HTML("<br>"),
      HTML("An example query w/ more species: Bidens pilosa,Ageratina riparia,Acroptilon repens,Ageratina adenophora,Aegilops triuncialis,Agrostis capillaris,Cinchona pubescens,Salix babylonica,Pinus caribaea")
    ),
    
    wellPanel(
    	h4(strong("ITIS options:")),
      checkboxInput(inputId = "getup",
                    label = strong("Parent taxon"),
                    value = TRUE),
#     	selectInput(inputId = "getdown",
#     							label = "Downstream hierarchy:",
#     							choices = c("Family","Genus","Species"),
#     							selected = "Family"),
# #     	checkboxGroupInput(inputId="getdown", label = strong("Downstream hierarchy"), choices=c("Family","Genus","Species"), selected="Genus"),
# #     	checkboxInput(inputId = "getdown",
# #                     label = strong("Downstream hierarchy"),
# #                     value = FALSE),
    	checkboxInput(inputId = "getsyns",
                    label = strong("Get synonyms"),
                    value = TRUE)
    ),
    
    wellPanel(
      selectInput(inputId = "locally",
      						label = strong("Do local SQL search"),
      						choices = c("ITIS web API","local sqlite3"),
      						selected = "local sqlite3")
    ),	
    
    submitButton("Update View"),
    
    HTML("<br><br>")
    
  ),
  
  mainPanel(
    tabsetPanel(
    	tabPanel("ITIS Parent", tableOutput("itis_parent")),
    	tabPanel("ITIS Synonyms", tableOutput("itis_syns")),
      tabPanel("Invasive?", tableOutput("invasiveness")),
#       tabPanel("Phylogeny", plotOutput("phylogeny")),
      tabPanel("Map", plotOutput("map"))
    )
  )
  
))