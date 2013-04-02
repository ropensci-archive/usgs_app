library(shiny)

shinyUI(pageWithSidebar(
  
  headerPanel(title=HTML("TaxaViewer - <i>Explore data on your species list</i> "), windowTitle="TaxaViewer"),
  
  sidebarPanel(
    wellPanel(
    	h4(strong("Input your taxon names:")),
      textInput(inputId="spec", label="Type or paste in a comma separated string of scientific names", 
                value="Carpobrotus edulis,Rosmarinus officinalis,Ageratina riparia"),
    	HTML("<br>"),
    	HTML("<a href=\"https://gist.github.com/SChamberlain/5286615\">Click here for more examples</a>")
    ),
    
    wellPanel(
    	h4(strong("ITIS options:")),
    	
      selectInput(inputId = "locally",
      						label = HTML("Search ITIS locally with sqlite or using the web API<br> - Running locally should be faster"),
      						choices = c("ITIS web API","local sqlite3"),
      						selected = "local sqlite3")
    ),
    
    helpText(HTML("This is a submission for the <a href=\"http://applifyingusgsdata.challenge.gov/\">USGS App Challenge</a>")),
    
    helpText(HTML("Data sources: <a href=\"http://www.itis.gov/\">ITIS</a>, 
    							<a href=\"http://api.phylotastic.org/tnrs\">Phylotastic</a>,
    							<a href=\"http://www.issg.org/database/welcome/\">Global Invasive Species Database</a>,
    							<a href=\"http://phylodiversity.net/phylomatic/\">Phylomatic</a>, and
    							<a href=\"http://www.gbif.org/\">GBIF</a>")),
    
    helpText(HTML("Source code for this app available on <a href=\"https://github.com/ropensci/usgs_app\">Github</a>. Created by rOpenSci. Vist <a href=\"http://ropensci.org/\">our website</a> to explore our R packages and tutorials. Get the R packages: <a href=\"https://github.com/ropensci/taxize_\">taxize</a>, 
    							<a href=\"https://github.com/ropensci/rgbif\">rgbif</a>.  This app was built using <a href=\"http://www.rstudio.com/shiny/\">Shiny</a>.  We use <a href=\"http://phylodiversity.net/phylomatic/\">Phylomatic</a> to 
    							generate the phylogeny, so phylogenies are restricted to plants.")),
    
    helpText(HTML("Bugs? Email us <a href=\"mailto:info@ropensci.org\">here</a>"))
  ),
  
  mainPanel(
    tabsetPanel(
    	tabPanel("Name Resolution", tableOutput("tnrs")),
    	tabPanel("ITIS Parents", tableOutput("itis_parent")),
    	tabPanel("ITIS Classification", tableOutput("rank_names")),
#     	tabPanel("ITIS Synonyms", tableOutput("itis_syns")),
      tabPanel("Invasive?", tableOutput("invasiveness")),
      tabPanel("Phylogeny", plotOutput("phylogeny")),
      tabPanel("Map", plotOutput("map"))
    ))
))