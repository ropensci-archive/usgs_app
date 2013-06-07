require(shiny)
require(rCharts)

shinyUI(pageWithSidebar(
  
  headerPanel(title=HTML("TaxaViewer - <i>Species exploration</i> "), windowTitle="TaxaViewer"),
  
  sidebarPanel(
    
    HTML('<style type="text/css">
         .row-fluid .span4{width: 26%;}
         .leaflet {height: 600px; width: 1200px;}
         </style>'),
    
    wellPanel(
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
    
    # downstream options for ITIS Children tab
#     wellPanel(
#       h5(strong("Downstream options:")),
#       selectInput(inputId="downto", label="Select taxonomic level to retrieve", choices=c("Class","Order","Family","Genus","Species"), selected="Species")
#     ),
#     
    # Map options 
    wellPanel(
      h5(strong("Map options:")),
      # number of occurrences for map
      sliderInput(inputId="numocc", label="Select max. number of occurrences to search for per species", min=0, max=500, value=50),
      # color palette for map
      selectInput(inputId="palette", label="Select color palette", 
                  choices=c("Blues","BuGn","BuPu","GnBu","Greens","Greys","Oranges","OrRd","PuBu","PuBuGn","PuRd","Purples","RdPu","Reds","YlGn","YlGnBu","YlOrBr","YlOrRd
                            BrBG","PiYG","PRGn","PuOr","RdBu","RdGy","RdYlBu","RdYlGn","Spectral"), selected="Blues"),
      selectInput('provider', 'Select map provider for interactive map', 
                  choices = c("OpenStreetMap.Mapnik","OpenStreetMap.BlackAndWhite","OpenStreetMap.DE","OpenCycleMap","Thunderforest.OpenCycleMap","Thunderforest.Transport","Thunderforest.Landscape","MapQuestOpen.OSM","MapQuestOpen.Aerial","Stamen.Toner","Stamen.TonerBackground","Stamen.TonerHybrid","Stamen.TonerLines","Stamen.TonerLabels","Stamen.TonerLite","Stamen.Terrain","Stamen.Watercolor","Esri.WorldStreetMap","Esri.DeLorme","Esri.WorldTopoMap","Esri.WorldImagery","Esri.WorldTerrain","Esri.WorldShadedRelief","Esri.WorldPhysical","Esri.OceanBasemap","Esri.NatGeoWorldMap","Esri.WorldGrayCanvas","Acetate.all","Acetate.basemap","Acetate.terrain","Acetate.foreground","Acetate.roads","Acetate.labels","Acetate.hillshading"),
                  selected = 'MapQuestOpen.OSM'
      ),
      HTML('
            <a href="#providersModal" role="badge" class="badge" data-toggle="modal" style="float:right;"><i class="icon-question-sign icon-white"></i></a>

          <!-- Modal -->
           <div id="providersModal" class="modal hide fade" tabindex="-1" role="dialog" aria-labelledby="providersModal" aria-hidden="true">
           <div class="modal-header">
           <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
           <h3 id="providersModal">Map options</h3>
           </div>
           <div class="modal-body">
           <h3>See here <a href="http://leaflet-extras.github.io/leaflet-providers/" target="_blank">http://leaflet-extras.github.io/leaflet-providers/</a> for your options</h3>
           </ul>
           </div>
           </div>
           ')
    ),
    
    sliderInput(inputId="paperlim", label="Number of papers to return", min=1, max=50, value=10, step=1, ticks=TRUE),
    
    wellPanel(
      HTML('
           <h4>About this site <a href="#infoModal" role="button" class="btn btn-info" data-toggle="modal" style="float:right"><i class="icon-info-sign icon-white"></i></a></h4>
           
           <!-- Modal -->
           <div id="infoModal" class="modal hide fade" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
           <div class="modal-header">
           <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
           <h3 id="myModalLabel">About this app</h3>
           </div>
           <div class="modal-body">
           This is a submission for the <a href=\"http://applifyingusgsdata.challenge.gov/\" target="_blank">USGS App Challenge</a><br>
           <br>
           Data sources include: <a href=\"http://www.itis.gov/\" target="_blank">ITIS</a>, <a href=\"http://api.phylotastic.org/tnrs\" target="_blank">Phylotastic</a>, <a href=\"http://www.issg.org/database/welcome/\" target="_blank">Global Invasive Species Database</a>, <a href=\"http://phylodiversity.net/phylomatic/\">Phylomatic</a>, and <a href=\"http://www.gbif.org/\">GBIF</a>"
           <br><br>
           Source code for this app available on <a href=\"https://github.com/ropensci/usgs_app\" target="_blank">Github</a>. Created by rOpenSci. Vist <a href=\"http://ropensci.org/\" target="_blank">our website</a> to explore our R packages and tutorials. Get the R packages: <a href=\"https://github.com/ropensci/taxize_\">taxize</a>, <a href=\"https://github.com/ropensci/rgbif\">rgbif</a>.  This app was built using <a href=\"http://www.rstudio.com/shiny/\">Shiny</a>.  We use <a href=\"http://phylodiversity.net/phylomatic/\">Phylomatic</a> to generate the phylogeny, so phylogenies are restricted to plants.
           <br><br>
           Bugs? File them <a href=\"https://github.com/ropensci/usgs_app/issues\" target="_blank">here</a>
           </div>
           </div>
           ')
      )
    
      ),
  #   
  mainPanel(
    tabsetPanel(
      tabPanel("Name Resolution", 
               HTML('<style>
                    .btn { float: right; }
                    a.tooltip{ z-index:1030; background-color: #000000}
                    </style>
                    <!-- Downoad Button -->
                    <button id="tnrs" class="btn btn-success"><i rel="tooltip" title="Download as csv" class="icon-download icon-white"></i></button>
                    <!-- Button to trigger modal -->
                    <link href="//netdna.bootstrapcdn.com/font-awesome/3.1.1/css/font-awesome.css" rel="stylesheet">
                    <script src="https://google-code-prettify.googlecode.com/svn/loader/run_prettify.js"></script>
                    
                    <a href="#myModal" role="btn" class="btn btn-inverse" data-toggle="modal"><i class="icon-code icon-white"></i></a>
                    
                    <!-- Get Code Modal -->
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
                    tnrs(species, getpost="POST", source_ = "NCBI")[,1:5]
                    </pre>
                    </div>
                    </div>
                    
                    <a href="#tnrsModal" role="btn" class="btn btn-info" data-toggle="modal" style="float:right;"><i class="icon-question-sign icon-white"></i></a>
                    
                    <!-- Modal -->
                    <div id="tnrsModal" class="modal hide fade" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
                    <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
                    <h3 id="tnrsModal">Info</h3>
                    </div>
                    <div class="modal-body">
                    <a href="http://taxosaurus.org/">Data from the Taxosaurus API</a><br><br>
                    <h5>Data Fields</h5>
                    <ul>
                    <small>
                    <li><strong>acceptedName:</strong> the new name</li>
                    <li><strong>matchedName:</strong> name matched against</li>
                    <li><strong>sourceID:</strong> the original source</li>
                    <li><strong>score:</strong> higher score = better match</li>
                    </small>
                    </ul>
                    </div>
                    </div>
                    '),
               tableOutput("tnrs")
               ),
      tabPanel("ITIS Classification", 
               HTML('
                    <a href="#classModal" role="btn" class="btn btn-inverse" data-toggle="modal" style="float:right;"><i class="icon-code icon-white"></i></a>
                    
                    <!-- Get Code Modal -->
                    <div id="classModal" class="modal hide fade" tabindex="-1" role="dialog" aria-labelledby="classModal" aria-hidden="true">
                    <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
                    <h3 id="classModal">Run the code locally</h3>
                    </div>
                    <div class="modal-body">
                    <!-- <pre class="pre-scrollable"> -->
                    <pre class="prettyprint">
                    install.packages("taxize")
                    library(taxize)
                    species <- c("species1","species2","species3")
                    tax_name(query=species, get=c("genus", "family", "order", "kingdom"), db="ncbi", locally=FALSE)
                    </pre>
                    </div>
                    </div>
                    
                    <a href="#classModal" role="btn" class="btn btn-info" data-toggle="modal" style="float:right;"><i class="icon-question-sign icon-white"></i></a>
                    
                    <!-- Modal -->
                    <div id="classModal" class="modal hide fade" tabindex="-1" role="dialog" aria-labelledby="classModal" aria-hidden="true">
                    <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
                    <h3 id="classModal">Info</h3>
                    </div>
                    <div class="modal-body">
                    <a href="http://taxosaurus.org/">Data from the Taxosaurus API</a><br><br>
                    <h5>Data Fields</h5>
                    <ul>
                    <small>
                    <li><strong>acceptedName:</strong> the new name</li>
                    <li><strong>matchedName:</strong> name matched against</li>
                    <li><strong>sourceID:</strong> the original source</li>
                    <li><strong>score:</strong> higher score = better match</li>
                    </small>
                    </ul>
                    </div>
                    </div>
                    '), 
               tableOutput("rank_names")
               ),
#       tabPanel("ITIS Chlidren", 
#                HTML('
#                     <a href="#childModal" role="btn" class="btn btn-inverse" data-toggle="modal" style="float:right;"><i class="icon-code icon-white"></i></a>
#                     
#                     <!-- Get Code Modal -->
#                     <div id="childModal" class="modal hide fade" tabindex="-1" role="dialog" aria-labelledby="childModal" aria-hidden="true">
#                     <div class="modal-header">
#                     <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
#                     <h3 id="childModal">Run the code locally</h3>
#                     </div>
#                     <div class="modal-body">
#                     <!-- <pre class="pre-scrollable"> -->
#                     <pre class="prettyprint">
#                     install.packages("taxize")
#                     library(taxize)
#                     species <- c("species1","species2","species3")
#                     out <- llply(species, function(x) col_downstream(name = x, downto = <level here, Species, Genus, etc.>)[[1]])
#                     ldply(out)
#                     </pre>
#                     </div>
#                     </div>
#                     
#                     
#                     <a href="#childrenModal" role="btn" class="btn btn-info" data-toggle="modal" style="float:right;"><i class="icon-question-sign icon-white"></i></a>
#                     
#                     <!-- Modal -->
#                     <div id="childrenModal" class="modal hide fade" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
#                     <div class="modal-header">
#                     <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
#                     <h3 id="childrenModal">Info</h3>
#                     </div>
#                     <div class="modal-body">
#                     <a href="http://taxosaurus.org/">Data from the Integrated Taxonomic Information Database (ITIS) API</a><br><br>
#                     <h5>Data Fields</h5>
#                     <ul>
#                     <li><strong>parentName:</strong> parent of the taxon you searched for</li>
#                     <li><strong>parentTsn:</strong> ITIS taxonomic searial number of the parent taxon</li>
#                     <li><strong>rankName:</strong> rank of the taxon you searched for</li> 
#                     <li><strong>taxonName:</strong> the taxon you searched for </li>
#                     <li><strong>tsn</strong> its TSN</li>
#                     </ul>
#                     </div>
#                     </div>
#                     '),
#                tableOutput("itis_children")
#                ),
#       tabPanel("Invasive?", 
#                HTML('
#                     <a href="#invadeModal" role="btn" class="btn btn-inverse" data-toggle="modal" style="float:right;"><i class="icon-code icon-white"></i></a>
#                     
#                     <!-- Get Code Modal -->
#                     <div id="invadeModal" class="modal hide fade" tabindex="-1" role="dialog" aria-labelledby="invadeModal" aria-hidden="true">
#                     <div class="modal-header">
#                     <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
#                     <h3 id="invadeModal">Run the code locally</h3>
#                     </div>
#                     <div class="modal-body">
#                     <!-- <pre class="pre-scrollable"> -->
#                     <pre class="prettyprint">
#                     install.packages("taxize")
#                     library(taxize)
#                     species <- c("species1","species2","species3")
#                     df <- gisd_isinvasive(x=species, simplify=TRUE)
#                     df$status <- gsub("Not in GISD", "Not Invasive", df$status)
#                     df
#                     </pre>
#                     </div>
#                     </div>
#                     
#                     
#                     <a href="#invasiveModal" role="btn" class="btn btn-info" data-toggle="modal" style="float:right;"><i class="icon-question-sign icon-white"></i></a>
#                     
#                     <!-- Modal -->
#                     <div id="invasiveModal" class="modal hide fade" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
#                     <div class="modal-header">
#                     <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
#                     <h3 id="invasiveModal">Info</h3>
#                     </div>
#                     <div class="modal-body">
#                     <a href="http://www.issg.org/database/welcome/">Data from the Global Invasive Species Database</a><br><br>
#                     <h5>Data Fields</h5>
#                     <ul>
#                     <small>
#                     <li><strong>species:</strong> the taxon searched for</li>
#                     <li><strong>status:</strong> invasive or not</li>
#                     </small>
#                     </ul>
#                     </div>
#                     </div>
#                     '),
#                tableOutput("invasiveness")
#                ),
      tabPanel("Phylogeny", 
               HTML('
                    <style>
                    #phycodeModal {
                    width: 900px; /* SET THE WIDTH OF THE MODAL */
                    margin: -250px 0 0 -450px; /* CHANGE MARGINS TO ACCOMODATE THE NEW WIDTH (original = margin: -250px 0 0 -280px;) */
                    }
                    
                    #phycodeModal .modal-body {
                    max-height: 800px;
                    }
                    </style>
                    
                    <a href="#phycodeModal" role="btn" class="btn btn-inverse" data-toggle="modal" style="float:right;"><i class="icon-code icon-white"></i></a>
                    
                    <!-- Get Code Modal -->
                    <div id="phycodeModal" class="modal hide fade" tabindex="-1" role="dialog" aria-labelledby="phycodeModal" aria-hidden="true">
                    <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
                    <h3 id="phycodeModal">Run the code locally</h3>
                    </div>
                    <div class="modal-body">
                    <!-- <pre class="pre-scrollable"> -->
                    <pre class="prettyprint" style="font-size: 11px">
install.packages("taxize")
library(taxize)
species <- c("species1","species2","species3")
                    
df <- gisd_isinvasive(x=species, simplify=TRUE)
df$status <- gsub("Not in GISD", "Not Invasive", df$status)

phylog <- phylomatic_tree(taxa=species, get = "POST", informat="newick", method = "phylomatic", storedtree = "R20120829", taxaformat = "slashpath", outformat = "newick", clean = "true")
phylog$tip.label <- capwords(phylog$tip.label)
for(i in seq_along(phylog$tip.label)){
  phylog <- tree.set.tag(phylog, tree.find(phylog, phylog$tip.label[i]), "circle", df[df$species %in% gsub("_"," ",phylog$tip.label[i]),"status"])
}
ggphylo(phylog, label.size=5, label.color.by="circle", label.color.scale=scale_colour_discrete(name="", h=c(90, 10))) +
  theme_bw(base_size=18) +
  theme(panel.grid.major = element_blank(), 
        panel.grid.minor = element_blank(),
        panel.background = element_blank(),
        axis.title.x = element_text(colour=NA),
        axis.title.y = element_blank(),
        axis.text.x = element_blank(),
        axis.text.y = element_blank(),
        axis.line = element_blank(),
        axis.ticks = element_blank(),
        panel.border = element_blank())
                    </pre>
                    </div>
                    </div>
                    
                    
                    <a href="#phyModal" role="btn" class="btn btn-info" data-toggle="modal" style="float:right;"><i class="icon-question-sign icon-white"></i></a>
                    
                    <!-- Modal -->
                    <div id="phyModal" class="modal hide fade" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
                    <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
                    <h3 id="phyModal">Info</h3>
                    </div>
                    <div class="modal-body">
                    The phylogeny is based on data from the <a href="http://phylodiversity.net/phylomatic/"> Phylomatic API</a>, and 
                    <a href="http://www.issg.org/database/welcome/">inasiveness data from the Global Invasive Species Database</a>.
                    The status of invasive is rather vague, meaning the species is invasive somewhere. See <a href="http://www.issg.org/database/welcome/" target="_blank">here</a> for more info<br><br>
                    <strong>Note</strong> Phylogenies are only available for plants at this time.
                    </div>
                    </div>
                    '),
               plotOutput("phylogeny")
               ),
#       tabPanel("Static Map", 
#                HTML('
#                     <style>
#                     #mapcodeModal {
#                     width: 900px; /* SET THE WIDTH OF THE MODAL */
#                     margin: -250px 0 0 -450px; /* CHANGE MARGINS TO ACCOMODATE THE NEW WIDTH (original = margin: -250px 0 0 -280px;) */
#                     }
#                     </style>
#                     <a href="#mapcodeModal" role="btn" class="btn btn-inverse" data-toggle="modal" style="float:right;"><i class="icon-code icon-white"></i></a>
#                     
#                     <!-- Get Code Modal -->
#                     <div id="mapcodeModal" class="modal hide fade" tabindex="-1" role="dialog" aria-labelledby="mapcodeModal" aria-hidden="true">
#                     <div class="modal-header">
#                     <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
#                     <h3 id="mapcodeModal">Run the code locally</h3>
#                     </div>
#                     <div class="modal-body">
#                     <!-- <pre class="pre-scrollable"> -->
#                     <pre class="prettyprint">
#                     install.packages(c("taxize","rgbif"))
#                     library(taxize)
#                     library(rgbif)
#                     species <- c("species1","species2","species3")
#                     out <- occurrencelist_many(species, coordinatestatus = TRUE, maxresults = num_occurrs, format="darwin", fixnames="change", removeZeros=TRUE)
#                     out$taxonName <- capwords(out$taxonName, onlyfirst=TRUE)
#                     gbifmap(out, customize = list(
#                     scale_colour_brewer("", palette=<choose palette, see RColorBrewer help>),
#                     theme(legend.key = element_blank(), 
#                     legend.position = "bottom", 
#                     plot.background = element_rect(colour="grey"),
#                     panel.border = element_blank()),
#                     scale_x_continuous(expand=c(0,0)),
#                     scale_y_continuous(expand=c(0,0)),
#                     guides(colour=guide_legend(override.aes = list(size = 5), nrow=2))
#                     )) 
#                     </pre>
#                     </div>
#                     </div>
#                     
#                     
#                     <a href="#mapModal" role="btn" class="btn btn-info" data-toggle="modal" style="float:right;"><i class="icon-question-sign icon-white"></i></a>
#                     
#                     <!-- Modal -->
#                     <div id="mapModal" class="modal hide fade" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
#                     <div class="modal-header">
#                     <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
#                     <h3 id="mapModal">Info</h3>
#                     </div>
#                     <div class="modal-body">
#                     <a href="http://www.gbif.org/">Data from the Global Biodiversity Information Facility API</a><br><br>
#                     </div>
#                     </div>'),
#                plotOutput("map")),
      tabPanel("Interactive map", 
           HTML('
        <a href="#mapModal" role="btn" class="btn btn-info" data-toggle="modal" style="float:right;"><i class="icon-question-sign icon-white"></i></a>

        <!-- Modal -->
        <div id="mapModal" class="modal hide fade" tabindex="-1" role="dialog" aria-labelledby="mapModal" aria-hidden="true">
        <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
        <h3 id="mapModal">Info</h3>
        </div>
        <div class="modal-body">
        Map made by searching <a href="http://www.gbif.org/" target="_blank">the GBIF API</a>, then passing 
        the data to <a href="https://github.com/ramnathv/rCharts" target="_blank">rCharts</a>, an R package to create, customize 
        and publish interactive javascript visualizations from R. <br><br>
        You can choose the map layer on the sidebar to the left. <br><br>
        Thanks to Ramnath Vaidyanathan for a lot of help with these maps.
        </div>
        </div>'),
        mapOutput('map_rcharts')),
     
      tabPanel("Papers",  
               HTML('
                    <a href="#paperscodeModal" role="btn" class="btn btn-inverse" data-toggle="modal" style="float:right;"><i class="icon-code icon-white"></i></a>
                    
                    <!-- Get Code Modal -->
                    <div id="paperscodeModal" class="modal hide fade" tabindex="-1" role="dialog" aria-labelledby="paperscodeModal" aria-hidden="true">
                    <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
                    <h3 id="paperscodeModal">Run the code locally</h3>
                    </div>
                    <div class="modal-body">
                    <!-- <pre class="pre-scrollable"> -->
                    <pre class="prettyprint">
install.packages("rplos")
require(rplos)
species <- c("species1","species2","species3")
dat <- llply(species, function(x) searchplos(x, fields="id,journal,title", limit = input$paperlim)[,-4])
names(dat) <- species
dat <- ldply(dat)
names(dat) <- c("Species","Journal","Title")
dat
                    </pre>
                    </div>
                    </div>

                    <a href="#papersModal" role="btn" class="btn btn-info" data-toggle="modal" style="float:right;"><i class="icon-question-sign icon-white"></i></a>

                    <!-- Modal -->
                    <div id="papersModal" class="modal hide fade" tabindex="-1" role="dialog" aria-labelledby="papersModal" aria-hidden="true">
                    <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
                    <h3 id="papersModal">Info</h3>
                    </div>
                    <div class="modal-body">
                    Taxon names searched against the <a href="http://api.plos.org/" target="_blank">PLoS search API</a><br><br>
                    Links to papers via their DOIs can be viewed in <a href="http://macrodocs.org/" target="_blank">Macrodocs</a>
                    </div>
                    </div>'), htmlOutput('papers'))
    ),
  
    HTML('
  <script type="text/javascript">
  var _gauges = _gauges || [];
  (function() {
    var t   = document.createElement("script");
    t.type  = "text/javascript";
    t.async = true;
    t.id    = "gauges-tracker";
    t.setAttribute("data-site-id", "51b18b55f5a1f55547000004");
    t.src = "//secure.gaug.es/track.js";
    var s = document.getElementsByTagName("script")[0];
    s.parentNode.insertBefore(t, s);
  })();
  </script>
  ')
    
    )
))