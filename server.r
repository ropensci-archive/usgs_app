require(shiny)
require(rCharts)
library(taxize)

shinyServer(function(input, output){
  
  output$tnrs <- renderTable({
    species <- input$spec
    species2 <- strsplit(species, ",")[[1]]
    tnrs(species2, getpost="POST", source_ = "NCBI")[,1:5]
  })
  
#   output$itis_children <- renderTable({
#     require(doMC)
#     
#     species <- input$spec
#     species2 <- strsplit(species, ",")[[1]]
#     downto <- input$downto
#     registerDoMC(cores=4)
#     out <- llply(species2, function(x) col_downstream(name = x, downto = downto)[[1]], .parallel=TRUE)
#     print(ldply(out))
#   })
  
  output$rank_names <- renderTable({
    species <- input$spec
    species2 <- strsplit(species, ",")[[1]]
    tax_name(query=species2, get=c("genus", "family", "order", "kingdom"), db="ncbi")
  })
  
  bar <- reactive({
    species <- input$spec
    species2 <- strsplit(species, ",")[[1]]
    df <- gisd_isinvasive(x=species2, simplify=TRUE)
    df$status <- gsub("Not in GISD", "Not Invasive", df$status)
    df
  })
  
  output$invasiveness <- renderTable({
    bar()
  })
  
  output$phylogeny <- renderPlot({
    require(ape)
    require(ggphylo)
    require(doMC)
    
    species <- input$spec
    species2 <- strsplit(species, ",")[[1]]
    
    # Make phylogeny
    registerDoMC(cores=4)
    phylog <- phylomatic_tree(taxa=species2, get = 'POST', informat='newick', method = "phylomatic",
                              storedtree = "R20120829", taxaformat = "slashpath", outformat = "newick", clean = "true", parallel=TRUE)
    phylog$tip.label <- capwords(phylog$tip.label)
    
    for(i in seq_along(phylog$tip.label)){
      phylog <- tree.set.tag(phylog, tree.find(phylog, phylog$tip.label[i]), 'circle', bar()[bar()$species %in% gsub("_"," ",phylog$tip.label[i]),"status"])
    }
    
    p <- ggphylo(phylog, label.size=5, label.color.by='circle', label.color.scale=scale_colour_discrete(name="", h=c(90, 10))) +
      theme_bw(base_size=18) +
      theme(panel.grid.major = element_blank(),panel.grid.minor = element_blank(),panel.background = element_blank(),
            axis.title.x = element_text(colour=NA),
            axis.title.y = element_blank(),
            axis.text.x = element_blank(),
            axis.text.y = element_blank(),
            axis.line = element_blank(),
            axis.ticks = element_blank(),
            panel.border = element_blank())
    print(p)
  })
  
  # Regular ggplot2 map
#   output$map <- renderPlot({
#     require(rgbif)
#     require(ggplot2)
#     
#     num_occurrs <- input$numocc
#     species <- input$spec
#     species2 <- strsplit(species, ",")[[1]]
#     out <- occurrencelist_many(species2, coordinatestatus = TRUE, maxresults = num_occurrs, format="darwin", fixnames="change", removeZeros=TRUE)
#     out$taxonName <- capwords(out$taxonName, onlyfirst=TRUE)
#     print(
#       gbifmap(out, customize = list(
#         scale_colour_brewer('', palette=input$palette),
#         theme(legend.key = element_blank(), 
#               legend.position = 'bottom', 
#               plot.background = element_rect(colour="grey"),
#               panel.border = element_blank()),
#         scale_x_continuous(expand=c(0,0)),
#         scale_y_continuous(expand=c(0,0)),
#         guides(colour=guide_legend(override.aes = list(size = 5), nrow=2))
#       )) 
#     )
#   })
  
  # Interactive rCharts map (thanks Ramnath)
	output$map_rcharts <- renderMap({
	  require(rCharts)
    require(taxize)
    require(rgbif)
    require(RColorBrewer)
	  
    rcharts_prep <- function(sppchar, occurrs, palette_name, popup=FALSE){
      
      # prepare occurrence data
	    species2 <- strsplit(sppchar, ",")[[1]]
	    out <- occurrencelist_many(species2, coordinatestatus = TRUE, maxresults = occurrs, 
                                 format="darwin", fixnames="change", removeZeros=TRUE)
	    out$taxonName <- capwords(out$taxonName, onlyfirst=TRUE)
	    out <- out[,c("taxonName","county","decimalLatitude","decimalLongitude","institutionCode","collectionCode","catalogNumber","basisOfRecordString","collector")]
      
      # colors
	    num_colours <- length(unique(out$taxonName))
      mycolors <- brewer.pal(num_colours, palette_name)
        
	    out2 <- mutate(out, 
	                   taxonName = as.factor(taxonName),
	                   fillColor = mycolors[as.numeric(taxonName)]
	    )
	    out_list2 <- apply(out2, 1, as.list)
      
      # popup
      if(popup)
        out_list2 <- lapply(out_list2, function(l){
          l$popup = paste(paste("<b>", names(l), ": </b>", l, "<br/>"), collapse = '\n')
          return(l)
        })
      
      return( out_list2 )
	  }
	  
    rcharts_data <- rcharts_prep(sppchar = input$spec, occurrs = input$numocc, palette_name = input$palette, popup = TRUE)
    
    toGeoJSON <- function(list_, lat = 'latitude', lon = 'longitude'){
      x = lapply(list_, function(l){
        if (is.null(l[[lat]]) || is.null(l[[lon]])){
          return(NULL)
        }
        list(
          type = 'Feature',
          geometry = list(
            type = 'Point',
            coordinates = as.numeric(c(l[[lon]], l[[lat]]))
          ),
          properties = l[!(names(l) %in% c(lat, lon))]
        )
      })
      setNames(Filter(function(x) !is.null(x), x), NULL)
    }
    
    gbifmap2 <- function(input = NULL, map_provider = 'MapQuestOpen.OSM', map_zoom = 2){
      input <- Filter(function(x) !is.na(x$decimalLatitude), input)
      L1 <- Leaflet$new()
      L1$tileLayer(provider = map_provider, urlTemplate = NULL)

      L1$set(height = 800, width = 1600)
      L1$setView(c(30, -73.90), map_zoom)
      L1$geoJson(toGeoJSON(input, lat = 'decimalLatitude', lon = 'decimalLongitude'), 
                 onEachFeature = '#! function(feature, layer){
      layer.bindPopup(feature.properties.popup || feature.properties.taxonName)
    } !#',
    pointToLayer =  "#! function(feature, latlng){
       return L.circleMarker(latlng, {
        radius: 4,
        fillColor: feature.properties.fillColor || 'red',    
        color: '#000',
        weight: 1,
        fillOpacity: 0.8
      })
    } !#"
      )
      return(L1)
    }    
    
    gbifmap2(input = rcharts_data, input$provider)
	})
  
	output$chart2 <- renderMap({
	  require(rCharts)
	  map3 <- Leaflet$new()
	  map3$setView(c(51.505, -0.09), zoom = 13)
	  map3$tileLayer(provider = input$provider, urlTemplate = NULL)
	  map3$marker(c(51.5, -0.09), bindPopup = "<p> Hi. I am a popup </p>")
	  map3$marker(c(51.495, -0.083), bindPopup = "<p> Hi. I am another popup </p>")
	  map3
	})
  
  output$papers <- renderText({
    require(rplos)
    require(xtable)
    species2 <- strsplit(input$spec, ",")[[1]]
    dat <- llply(species2, function(x) searchplos(x, fields='id,journal,title', limit = input$paperlim)[,-4])
    names(dat) <- species2
    dat <- ldply(dat)
    dat$id <- paste0("<a href='http://macrodocs.org/?doi=", dat$id, "' target='_blank'> <i class='icon-book'></i> </a>")
    names(dat) <- c("Species","Read","Journal","Title")
    g <- print(xtable(dat), include.rownames = FALSE, type = "html")
    gsub("\n", "", gsub("&gt ", ">", gsub("&lt ", "<", g)))
  })
  
	output$downloadData <- downloadHandler(
	  filename = 'data.csv',
	  #     content = function(file) { write.csv(mtcars, file) }
	  content = function(file) { write.csv(mtcars, file) }
	)
	
	output$cbt <- renderText(function(){})
  
	outputOptions(output, 'downloadData', suspendWhenHidden=FALSE)
	
})