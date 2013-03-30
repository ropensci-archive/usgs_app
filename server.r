library(shiny)
library(plyr)
library(taxize)
library(ggplot2)
library(doMC)
library(ape)
library(ggphylo)
library(rgbif)

## Set up server output
shinyServer(function(input, output) {
  #   load("speciesdata.rda")
  
  datasetInput <- reactive({
    species <- input$spec
    species2 <- strsplit(species, ",")[[1]]
    
    # Get ITIS data
    tsns <- get_tsn(searchterm=species2, searchtype="sciname")
    
    ## Get hierarchy up from species
    if (input$getup) {
    	registerDoMC(cores=4)
    	itisdata <- ldply(tsns, gethierarchyupfromtsn, .parallel=TRUE)
    }
    
    ## Get downstream from taxon
    if (input$getup) {
    	registerDoMC(cores=4)
    	itisdata <- ldply(tsns, itis_downstream, downto = "", .parallel=TRUE)
    }
    getdown
    
    ## xxxxx
#     ldply(tsns, function(x) as.character(itis_taxrank(x)))
    
    ## Get downstream hierarchy
#     temp <- ldply(tsns, itis_downstream, downto=)
#     itisdata <- XXXX
    
    # Invasivesnes status
    dat <- gisd_isinvasive(x=species2, simplify=TRUE)
    
    # make phylogeny
    registerDoMC(cores=4)
    phylog <- phylomatic_tree(taxa=species2, get = 'POST', informat='newick', method = "phylomatic",
                    storedtree = "R20120829", taxaformat = "slashpath", outformat = "newick", clean = "true", parallel=TRUE)
    phylog$tip.label <- capwords(phylog$tip.label)
#     dat <- dat[match(dat$species,gsub("_", " ", phylog$tip.label)), ]
#     convertocolor <- function(x){ ifelse(x == "Invasive", "black", "white") }
#     cols <- sapply(dat[gsub("_", " ", phylog$tip.label) %in% dat$species, "status"], convertocolor, USE.NAMES=FALSE)
    
    for(i in seq_along(phylog$tip.label)){
      phylog <- tree.set.tag(phylog, tree.find(phylog, phylog$tip.label[i]), 'circle', dat[dat$species %in% gsub("_"," ",phylog$tip.label[i]),"status"])
    }
    phylog2 <- ggphylo(phylog, label.size=5, label.color.by='circle', label.color.scale=scale_colour_discrete(h=c(90, 10))) + theme_phylo_blank()
    
    # Make map
    registerDoMC(cores=4)
    out <- llply(species2, function(x) occurrencelist(x, coordinatestatus = TRUE, maxresults = 100), .parallel=TRUE)
    map <- gbifmap(out)
    
    list(itisdata, dat, phylog2, map)
  })
  
  output$itis_data <- renderTable({
  	datasetInput()[[1]]
  })
  
  output$invasiveness <- renderTable({
  	datasetInput()[[2]]
  })
  
  output$phylogeny <- renderPlot({
    print(datasetInput()[[3]])
  })
  
  output$map <- renderPlot({
    print(datasetInput()[[4]])
  })
})