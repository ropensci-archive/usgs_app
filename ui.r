library(shiny)

# includeHTML(path="www/js/usgs_app_data.js")

shinyUI(pageWithSidebar(

  headerPanel(title=HTML("TaxaViewer - <i>Species exploration</i> "), windowTitle="TaxaViewer"),
  
  sidebarPanel(
    
    HTML('<style type="text/css">
            .row-fluid .span4{width: 26%;}
          </style>'),
    
    wellPanel(
#       h4(strong("Input taxon names:")),      
#       HTML("<br>"),
#       HTML("<a href=\"https://gist.github.com/SChamberlain/5286615\">Click here for more examples</a>")
      HTML('
            <h5><strong>Input taxon names:</strong><a href="#egsModal" role="badge" class="badge" data-toggle="modal" style="float:right;"><i class="icon-question-sign icon-white"></i></a></h5>

            <!-- Modal -->
            <div id="egsModal" class="modal hide fade" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
              <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
                <h3 id="myModalLabel">Examples</h3>
              </div>
              <div class="modal-body">
The main interface is always inputting scientific names. Paste the below strings in exactly as they are. Here are a few examples:
<br><br>
<ul>
<li><strong>Example 1, correctly spelled names</strong></li>
Carpobrotus edulis,Rosmarinus officinalis,Ageratina riparia
<br><br>
<li><strong>Example 2, incorrectly spelled names</strong></li>
Carpobrotus eduliss,Rosmarinas officinalis,Ageratina riparia
<br><br>
<li><strong>Example 3, longer string of names</strong></li>
Bidens pilosa,Ageratina riparia,Poa annua,Ageratina adenophora,Aegilops triuncialis,Agrostis capillaris,Cinchona pubescens,Pinus contorta
</ul>
              </div>
            </div>
           '),
#       HTML("<br>"),
      HTML('<textarea id="spec" rows="3" cols="50">Carpobrotus edulis,Rosmarinus officinalis,Ageratina riparia</textarea>')
    ),
    
    wellPanel(
      h5(strong("Downstream options:")),
      selectInput(inputId="downto", label="Select taxonomic level to retrieve", choices=c("Class","Order","Family","Genus","Species"), selected="Species")
    ),
    
    wellPanel(
      h5(strong("Map options:")),
      sliderInput(inputId="numocc", label="Select max. number of occurrences to search for per species", min=0, max=1000, value=100)
    ),
#     wellPanel(
#       HTML('<textarea id="thing" class="sciname" type="text" placeholder="sciname"></textarea>')
#     ),

    
#     wellPanel(
#       selectInput(inputId="sciname", label="thign butt", choices = )
#       HTML('
#             <div class="typeahead-wrapper" width="200">
#                 <textarea class="sciname" type="text" placeholder="sciname"></textarea>
#             </div>')
#       textInput(inputId = "tool", label = "Tool:", value = "sciname")
#       HTML('
#           <select id="tool" style="width:100px"></select>
#            ')
#     ),
    
#     wellPanel(
#       h4(strong("ITIS options:")),
#       
#       selectInput(inputId = "locally",
#                   label = HTML("Search ITIS locally with sqlite or using the web API<br> - Running locally should be faster"),
#                   choices = c("ITIS web API","local sqlite3"),
#                   selected = "ITIS web API")
#     ),
#     
    wellPanel(
    HTML('
      <a href="#infoModal" role="button" class="btn btn-info" data-toggle="modal" style="float:left"><i class="icon-info-sign icon-white"></i></a>

      <!-- Modal -->
      <div id="infoModal" class="modal hide fade" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
        <div class="modal-header">
          <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
          <h3 id="myModalLabel">About this app</h3>
        </div>
        <div class="modal-body">
This is a submission for the <a href=\"http://applifyingusgsdata.challenge.gov/\">USGS App Challenge</a><br>
<br>
Data sources include: <a href=\"http://www.itis.gov/\">ITIS</a>, <a href=\"http://api.phylotastic.org/tnrs\">Phylotastic</a>, <a href=\"http://www.issg.org/database/welcome/\">Global Invasive Species Database</a>, <a href=\"http://phylodiversity.net/phylomatic/\">Phylomatic</a>, and <a href=\"http://www.gbif.org/\">GBIF</a>"
<br><br>
Source code for this app available on <a href=\"https://github.com/ropensci/usgs_app\">Github</a>. Created by rOpenSci. Vist <a href=\"http://ropensci.org/\">our website</a> to explore our R packages and tutorials. Get the R packages: <a href=\"https://github.com/ropensci/taxize_\">taxize</a>, <a href=\"https://github.com/ropensci/rgbif\">rgbif</a>.  This app was built using <a href=\"http://www.rstudio.com/shiny/\">Shiny</a>.  We use <a href=\"http://phylodiversity.net/phylomatic/\">Phylomatic</a> to generate the phylogeny, so phylogenies are restricted to plants.
<br><br>
Bugs? File them <a href=\"https://github.com/ropensci/usgs_app/issues\">here</a>
        </div>
      </div>
         ')
    )
    
#     helpText(HTML("This is a submission for the <a href=\"http://applifyingusgsdata.challenge.gov/\">USGS App Challenge</a>")),
#     
#     helpText(HTML("Data sources: <a href=\"http://www.itis.gov/\">ITIS</a>,
#                   <a href=\"http://api.phylotastic.org/tnrs\">Phylotastic</a>,
#                   <a href=\"http://www.issg.org/database/welcome/\">Global Invasive Species Database</a>,
#                   <a href=\"http://phylodiversity.net/phylomatic/\">Phylomatic</a>, and
#                   <a href=\"http://www.gbif.org/\">GBIF</a>")),
#     
#     helpText(HTML("Source code for this app available on <a href=\"https://github.com/ropensci/usgs_app\">Github</a>. Created by rOpenSci. Vist <a href=\"http://ropensci.org/\">our website</a> to explore our R packages and tutorials. Get the R packages: <a href=\"https://github.com/ropensci/taxize_\">taxize</a>,
#                   <a href=\"https://github.com/ropensci/rgbif\">rgbif</a>.  This app was built using <a href=\"http://www.rstudio.com/shiny/\">Shiny</a>.  We use <a href=\"http://phylodiversity.net/phylomatic/\">Phylomatic</a> to
#                   generate the phylogeny, so phylogenies are restricted to plants.")),
#     
#     helpText(HTML("Bugs? File them <a href=\"https://github.com/ropensci/usgs_app/issues\">here</a>"))
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
               HTML('<style>
                      .btn { float: right; }
                      a.tooltip{ z-index:1030; background-color: #000000}
                    </style>
                    <!-- Downoad Button -->
                    <button id="tnrs" class="btn btn-success"><i rel="tooltip" title="Download as csv" class="icon-download icon-white"></i></button>
                    <!-- Button to trigger modal -->
                    <link href="//netdna.bootstrapcdn.com/font-awesome/3.1.1/css/font-awesome.css" rel="stylesheet">
                    <script src="https://google-code-prettify.googlecode.com/svn/loader/run_prettify.js"></script>
                    
                    <a href="#myModal" role="button" class="btn btn-inverse" data-toggle="modal"><i class="icon-code icon-white"></i></a>

                    <!-- Modal -->
                    <div id="myModal" class="modal hide fade" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
                      <div class="modal-header">
                        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
                          <h3 id="myModalLabel">Run the code locally</h3>
                      </div>
                      <div class="modal-body">
                        <!-- <pre class="pre-scrollable"> -->
                        <pre class="prettyprint">
install.packages("taxize")
library(taxize)
species <- c("species1","species2","species3")
species2 <- strsplit(species, ",")[[1]]
tnrs(species2, getpost="POST", source_ = "NCBI")[,1:5]
                        </pre>
                      </div>
                    </div>
                    '),
#                downloadButton('downloadData', '', class='btn-success'),
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
      tabPanel("ITIS Classification", 
#                HTML('<div class="alert alert-info alert-block">
#                     <button type="button" class="close" data-dismiss="alert">&times;</button>
#                       <a href="http://taxosaurus.org/">Data from the Taxosaurus API</a><br>
#                       <strong>acceptedName:</strong> the new name, <strong>matchedName:</strong> name matched against<br>
#                       <strong>sourceID:</strong> the original source, <strong>score:</strong> higher score = better match
#                     </div>'), 
               HTML('<style>
                      .btn { float: right; }
                    </style>
                    <button id="rank_names" class="btn btn-success"><i class="icon-download icon-white"></i></button>
                    '),
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
      tabPanel("ITIS Chlidren", 
               HTML('<style>
                      .btn { float: right; }
                    </style>
                    <button id="itis_children" class="btn btn-success"><i class="icon-download icon-white"></i></button>
                    '),
               tableOutput("itis_children"),
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
#       tabPanel("ITIS Synonyms", tableOutput("itis_syns")),
      tabPanel("Invasive?", 
#                HTML('<div class="alert alert-info alert-block">
#                       <button type="button" class="close" data-dismiss="alert">&times;</button>
#                       <a href="http://www.issg.org/database/welcome/">Data from the Global Invasive Species Database</a><br>
#                       <strong>species:</strong> the taxon searched for, <strong>status:</strong> invasive or not<br>
#                     </div>'), 
               HTML('<style>
                      .btn { float: right; }
                    </style>
                    <button id="invasiveness" class="btn btn-success"><i class="icon-download icon-white"></i></button>
                    '),
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
               HTML('<style>
                      .btn { float: right; }
                    </style>
                    <button id="phylogeny" class="btn btn-success"><i class="icon-download icon-white"></i></button>
                    '),
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
               HTML('<style>
                      .btn { float: right; }
                    </style>
                    <button id="map" class="btn btn-success"><i class="icon-download icon-white"></i></button>
                    '),
               plotOutput("map"),
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