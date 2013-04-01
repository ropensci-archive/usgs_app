library(shiny)

shinyUI(pageWithSidebar(
  
  headerPanel(title=HTML("TaxaViewer - <i>Discover taxonomic names, and their data</i> "), windowTitle="TaxaViewer"),
  
  sidebarPanel(
    wellPanel(
    	h4(strong("Input your taxon names:")),
      textInput(inputId="spec", label="Enter species names, spelled correctly, separated by commas", 
                value="Carpobrotus edulis,Rosmarinus officinalis,Ageratina riparia"),
      HTML("<br>")
#       HTML("An example query w/ more species: Bidens pilosa,Ageratina riparia,Acroptilon repens,Ageratina adenophora,Aegilops triuncialis,Agrostis capillaris,Cinchona pubescens,Salix babylonica,Pinus caribaea"),
    	
#     	selectInput(inputId = "scicomm",
#     							label = strong("Search by scientific or common names"),
#     							choices = c("Scientific names","Common names"),
#     							selected = "Scientific names")
    ),
    
    wellPanel(
    	h4(strong("ITIS options:")),
    	
#       checkboxInput(inputId = "getup",
#                     label = strong("Parent taxon"),
#                     value = TRUE),
#     	selectInput(inputId = "getdown",
#     							label = "Downstream hierarchy:",
#     							choices = c("Family","Genus","Species"),
#     							selected = "Family"),
# #     	checkboxGroupInput(inputId="getdown", label = strong("Downstream hierarchy"), choices=c("Family","Genus","Species"), selected="Genus"),
# #     	checkboxInput(inputId = "getdown",
# #                     label = strong("Downstream hierarchy"),
# #                     value = FALSE),
#     	checkboxInput(inputId = "getsyns",
#                     label = strong("Get synonyms"),
#                     value = TRUE),
# #     ),
#     
#     wellPanel(
      selectInput(inputId = "locally",
      						label = strong("Do local SQL search"),
      						choices = c("ITIS web API","local sqlite3"),
      						selected = "local sqlite3")
    ),
    
#     submitButton(text="Update View"),
    
#     HTML("<br><br>")
    
    helpText(HTML("This is a submission for the <a href=\"http://applifyingusgsdata.challenge.gov/\">USGS App Challenge</a>")),
    
    helpText(HTML("We use the plant phylogeny builder <a href=\"http://phylodiversity.net/phylomatic/\">Phylomatic</a> to generate the phylogeny, so for now queries are restricted to plants")),
    
#     HTML("<br>"),
    helpText(HTML("Source code for this app available on <a href=\"https://github.com/ropensci/usgs_app\">Github</a>")),
    
    helpText(HTML("Created by <a href=\"http://ropensci.org/\">rOpenSci</a>, with our R packages and tutorials.")),
    
    helpText(HTML("Get the R packages: <a href=\"https://github.com/ropensci/taxize_\">taxize</a>, <a href=\"https://github.com/ropensci/rgbif\">rgbif</a>"))
  ),
  
  mainPanel(
    tabsetPanel(
    	tabPanel("Name Resolution", tableOutput("tnrs")),
    	tabPanel("ITIS Parents", tableOutput("itis_parent")),
    	tabPanel("ITIS Synonyms", tableOutput("itis_syns")),
      tabPanel("Invasive?", tableOutput("invasiveness")),
      tabPanel("Phylogeny", plotOutput("phylogeny")),
      tabPanel("Map", plotOutput("map"))
    ))
))