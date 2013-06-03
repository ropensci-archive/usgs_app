library(shiny)

shinyUI(pageWithSidebar(
  #   bootstrapPage(
  headerPanel(title=HTML("TaxaViewer - <i>Species exploration</i> "), windowTitle="TaxaViewer"),
  
  sidebarPanel(
    
    HTML('<style type="text/css">
            .row-fluid .span4{width: 26%;}
          </style>'),
    
    wellPanel(
      h4(strong("Input your taxon names:")),
      HTML('<textarea id="spec" rows="3" cols="50">Carpobrotus edulis,Rosmarinus officinalis,Ageratina riparia</textarea>'),
      HTML("<br>"),
      HTML("<a href=\"https://gist.github.com/SChamberlain/5286615\">Click here for more examples</a>")
    ),
    
    wellPanel(
      h4(strong("ITIS options:")),
      
      selectInput(inputId = "locally",
                  label = HTML("Search ITIS locally with sqlite or using the web API<br> - Running locally should be faster"),
                  choices = c("ITIS web API","local sqlite3"),
                  selected = "ITIS web API")
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
    
    helpText(HTML("Bugs? File them <a href=\"https://github.com/ropensci/usgs_app/issues\">here</a>"))
    ),
  
  mainPanel(    
    tabsetPanel(
      tabPanel("Name Resolution", 
#                HTML('<div class="alert alert-info alert-block">
#                       <button type="button" class="close" data-dismiss="alert">&times;</button>
#                       <a href="http://taxosaurus.org/">Data from the Taxosaurus API</a><br>
#                       <strong>acceptedName:</strong> the new name, <strong>matchedName:</strong> name matched against<br>
#                       <strong>sourceID:</strong> the original source, <strong>score:</strong> higher score = better match
#                     </div>'), 
               tableOutput("tnrs"),
               HTML('<style type="text/css">
                    footer{position : absolute; bottom : 5%; left : 33%; padding : 5px;}
                    .row-fluid .span6{width: 80%;}
                    </style>
                    <footer>
                      <div class="span8">
                        <div class="span2">
                          <img src="phylotastic.png", height="120", width="120"</img>
                        </div>
                        <div class="span6">
                          <div class="alert alert-info">
                            <button type="button" class="close" data-dismiss="alert">&times;</button>
                            <a href="http://taxosaurus.org/">Data from the Taxosaurus API</a><br>
                            <strong>acceptedName:</strong> the new name, <strong>matchedName:</strong> name matched against<br>
                            <strong>sourceID:</strong> the original source, <strong>score:</strong> higher score = better match
                          </div>
                        </div>
                      </div>
                    </footer>')
               ),
      tabPanel("ITIS Parents", 
#                HTML('<div class="alert alert-info alert-block">
#                     <button type="button" class="close" data-dismiss="alert">&times;</button>
#                       <a href="http://taxosaurus.org/">Data from the Integrated Taxonomic Information Database (ITIS) API</a><br>
#                       <strong>parentName:</strong> parent of the taxon you searched for, <strong>parentTsn:</strong> ITIS taxonomic searial number of the parent taxon<br>
#                       <strong>rankName:</strong> rank of the taxon you searched for, <strong>taxonName:</strong> the taxon you searched for, <strong>tsn</strong> and its TSN
#                     </div>'), 
               tableOutput("itis_parent"),
               HTML('<style type="text/css">
                    footer{position : absolute; bottom : 5%; left : 33%; padding : 5px;}
                    .row-fluid .span6{width: 85%;}
                    </style>
                    <footer>
                      <div class="span8">
                        <div class="span2">
                          <img src="itis.png", height="100", width="100"</img>
                        </div>
                        <div class="span6">
                          <div class="alert alert-info">
                            <button type="button" class="close" data-dismiss="alert">&times;</button>
                            <a href="http://taxosaurus.org/">Data from the Integrated Taxonomic Information Database (ITIS) API</a><br>
                            <strong>parentName:</strong> parent of the taxon you searched for, <strong>parentTsn:</strong> ITIS taxonomic searial number of the parent taxon<br>
                            <strong>rankName:</strong> rank of the taxon you searched for, <strong>taxonName:</strong> the taxon you searched for, <strong>tsn</strong> and its TSN
                          </div>
                        </div>
                      </div>
                    </footer>')
               ),
      tabPanel("ITIS Classification", 
#                HTML('<div class="alert alert-info alert-block">
#                     <button type="button" class="close" data-dismiss="alert">&times;</button>
#                       <a href="http://taxosaurus.org/">Data from the Taxosaurus API</a><br>
#                       <strong>acceptedName:</strong> the new name, <strong>matchedName:</strong> name matched against<br>
#                       <strong>sourceID:</strong> the original source, <strong>score:</strong> higher score = better match
#                     </div>'), 
               tableOutput("rank_names"),
               HTML('<style type="text/css">
                    footer{position : absolute; bottom : 5%; left : 33%; padding : 5px;}
                    .row-fluid .span6{width: 80%;}
                    </style>
                    <footer>
                      <div class="span8">
                        <div class="span2">
                          <img src="itis.png", height="120", width="120"</img>
                        </div>
                        <div class="span6">
                          <div class="alert alert-info">
                            <button type="button" class="close" data-dismiss="alert">&times;</button>
                            <a href="http://taxosaurus.org/">Data from the Taxosaurus API</a><br>
                            <strong>acceptedName:</strong> the new name, <strong>matchedName:</strong> name matched against<br>
                            <strong>sourceID:</strong> the original source, <strong>score:</strong> higher score = better match
                          </div>
                        </div>
                      </div>
                    </footer>')
               ),
#       tabPanel("ITIS Synonyms", tableOutput("itis_syns")),
      tabPanel("Invasive?", 
#                HTML('<div class="alert alert-info alert-block">
#                       <button type="button" class="close" data-dismiss="alert">&times;</button>
#                       <a href="http://www.issg.org/database/welcome/">Data from the Global Invasive Species Database</a><br>
#                       <strong>species:</strong> the taxon searched for, <strong>status:</strong> invasive or not<br>
#                     </div>'), 
               tableOutput("invasiveness"),
               HTML('<style type="text/css">
                    footer{position : absolute; bottom : 5%; left : 33%; padding : 5px;}
                    .row-fluid .span5{width: 80%;}
                    </style>
                    <footer>
                      <div class="span8">
                        <div class="span5">
                          <div class="alert alert-info">
                            <button type="button" class="close" data-dismiss="alert">&times;</button>
                            <a href="http://www.issg.org/database/welcome/">Data from the Global Invasive Species Database</a><br>
                            <strong>species:</strong> the taxon searched for, <strong>status:</strong> invasive or not<br>
                          </div>
                        </div>
                      </div>
                    </footer>')
               ),
      tabPanel("Phylogeny", 
#                HTML('<div class="alert alert-info alert-block">
#                       <button type="button" class="close" data-dismiss="alert">&times;</button>
#                       <a href="http://phylodiversity.net/phylomatic/">Data from the Phylomatic API</a><br>
#                       The phylogeny is based on Phylomatic data, and plots invasiveness status on the phylogeny.
#                     </div>'), 
               plotOutput("phylogeny"),
               HTML('<style type="text/css">
                      footer{position : absolute; bottom : 2%; left : 33%; right: -50px; padding : 5px; width: 100%}
                      .row-fluid .span6{width: 80%;}
                    </style>
                    <footer>
                      <div class="span8">
                        <div class="span2">
                          <img src="phylomatic.png", height="150", width="150"</img>
                        </div>
                        <div class="span6">
                          <div class="alert alert-info">
                            <button type="button" class="close" data-dismiss="alert">&times;</button>
                            <a href="http://phylodiversity.net/phylomatic/">Data from the Phylomatic API</a><br>
                            The phylogeny is based on Phylomatic data. <strong>Note</strong> Phylogenies are only available for plants at this time.
                          </div>
                      </div>
                    </footer>')
               ),
      tabPanel("Map", 
#                HTML('<div class="alert alert-info alert-block">
#                       <button type="button" class="close" data-dismiss="alert">&times;</button>
#                       <a href="http://www.gbif.org/">Data from the Global Biodiversity Information Facility API</a><br>
#                       Interactive map by Ramnath Vaidyanathan - made with <a href="http://ramnathv.github.io/rCharts/">rCharts</a> and <a href="http://leafletjs.com/">Leaflet.js</a>
#                     </div>'), 
               plotOutput("map", height="100%", width="100%"),
               HTML('<style type="text/css">
                      footer{position : absolute; bottom : 2%; left : 28%; width: 100%}
                      .row-fluid .span6{width: 80%;}
                    </style>
                    <footer>
                      <div class="span8">
                        <div class="span2">
                          <img src="gbif.png", height="50", width="50"</img>
                        </div>
                        <div class="span6">
                          <div class="alert alert-info">
                            <button type="button" class="close" data-dismiss="alert">&times;</button>
                            <a href="http://www.gbif.org/">Data from the Global Biodiversity Information Facility API</a><br>
                        </div>
                      </div>
                    </footer>')
    ))
)))
