library(shiny)
library(plyr)
library(taxize)
library(ggplot2)
library(doMC)
library(ape)
library(ggphylo)
library(rgbif)
library(RSQLite)
library(DBI)

## Set up server output
shinyServer(function(input, output) {
  
	foo <- reactive({
    species <- input$spec
		species2 <- strsplit(species, ",")[[1]]
		
#     if(input$locally=="local sqlite3") {
#       locally_choice <- TRUE
# #     conn <- taxize:::sqlite_init(path="/home/ropensci/ShinyApps/usgs/itis2.sqlite")
#       conn <- taxize:::sqlite_init(path="~/github/ropensci/sql/itis2.sqlite")
#     } else {locally_choice <- FALSE}
#    
    
    # Get ITIS data
#     tsns <- na.omit(get_tsn(searchterm=species2, searchtype="sciname", locally=locally_choice))
    tsns <- na.omit(get_tsn(searchterm=species2, searchtype="sciname"))
    tsns_sp <- data.frame(sp=species2, tsn=as.vector(tsns))
    
    list(tsns, tsns_sp)
  })
	
	output$tnrs <- renderTable({
		species <- input$spec
		species2 <- strsplit(species, ",")[[1]]
		tnrs(species2, getpost="POST", source_ = "NCBI")[,1:5]
	})
  
	output$itis_children <- renderTable({
	  species <- input$spec
	  species2 <- strsplit(species, ",")[[1]]
	  downto <- input$downto
    registerDoMC(cores=4)
	  out <- llply(species2, function(x) col_downstream(name = x, downto = downto)[[1]], .parallel=TRUE)
    ldply(out)
	})
	
# 	output$itis_parent <- renderTable(function(){		
# 		# get locally choice
# # 		if(input$locally=="local sqlite3") {
# #       locally_choice <- TRUE
# # 		#     conn <- taxize:::sqlite_init(path="/home/ropensci/ShinyApps/usgs/itis2.sqlite")
# #       conn <- taxize:::sqlite_init(path="~/github/ropensci/sql/itis2.sqlite")
# # 		} else {locally_choice <- FALSE}
# 		
# 		## Get hierarchy up from species
# #     if(!locally_choice){
#     	registerDoMC(cores=4)
#     	ldply(foo()[[1]], gethierarchyupfromtsn, .parallel=TRUE)
# #     } else
# #     {
# #     	ldply(foo()[[1]], gethierarchyupfromtsn, locally=locally_choice)
# #     }
#   })
	
# 	output$itis_syns <- renderTable({
# 
# 		#     conn <- taxize:::sqlite_init(path="/home/ropensci/ShinyApps/usgs/itis2.sqlite")
#     conn <- taxize:::sqlite_init(path="~/github/ropensci/sql/itis2.sqlite")
# 		
# 		if(input$locally=="local sqlite3") {locally_choice <- TRUE} else {locally_choice <- FALSE}
# 		
#     ## Get synonyms
#     if(!locally_choice){
#     	registerDoMC(cores=4)
#     	itisdata_syns <- ldply(foo()[[1]], getsynonymnamesfromtsn, .parallel=TRUE)[,-1]
#     } else
#     {
#     	getsyns <- function(x){
#     		temp <- getsynonymnamesfromtsn(x, locally=locally_choice)
#     		names(temp)[1] <- "synonym"
#     		data.frame(submittedName = rep(foo()[[2]][foo()[[2]]$tsn%in%x,"sp"],nrow(temp)), temp)
#     	}
#     	ldply(foo()[[1]], getsyns)
#     }
# 	})
# 	
	output$rank_names <- renderTable({
		species <- input$spec
		species2 <- strsplit(species, ",")[[1]]
		tax_name(query=species2, get=c("genus", "family", "order", "kingdom"), db="ncbi", locally=FALSE)
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
		species <- input$spec
		species2 <- strsplit(species, ",")[[1]]
		
		# Make phylogeny
    locally=FALSE
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
	
	output$map <- renderPlot({
	  num_occurrs <- input$numocc
		species <- input$spec
		species2 <- strsplit(species, ",")[[1]]
		out <- occurrencelist_many(species2, coordinatestatus = TRUE, maxresults = num_occurrs, format="darwin", fixnames="change", removeZeros=TRUE)
		out$taxonName <- capwords(out$taxonName, onlyfirst=TRUE)
		print(
		  gbifmap(out, customize = list(
		    scale_colour_brewer('', palette="Set1"),
		    theme(legend.key = element_blank(), 
		          legend.position = 'bottom', 
		          plot.background = element_rect(colour="grey"),
		          panel.border = element_blank()),
		    scale_x_continuous(expand=c(0,0)),
		    scale_y_continuous(expand=c(0,0)),
		    guides(colour=guide_legend(override.aes = list(size = 5), nrow=2))
		  )) 
		)
		# Make map
# 		out2 <- out2[,c("taxonName","county","decimalLatitude","decimalLongitude","institutionCode","collectionCode","catalogNumber","basisOfRecordString","collector")]
# 		out <- getdata(out, FALSE)
# 		registerDoMC(cores=4)
# 		out <- llply(species2, function(x) occurrencelist(x, coordinatestatus = TRUE, maxresults = 100, fixnames="changealltoorig", removeZeros=TRUE), .parallel=TRUE)
# 		fixdfs <- function(x){
# 			temp <- x[!is.na(x$decimalLatitude) == TRUE,]
# 			temp$decimalLatitude <- as.numeric(temp$decimalLatitude)
# 			temp$decimalLongitude <- as.numeric(temp$decimalLongitude)
# 			temp[!temp$decimalLatitude == 0,]
# 		}
# 		out <- llply(out, fixdfs)
	}, height="auto")
  
	output$downloadData <- downloadHandler(
	  filename = 'data.csv',
	  #     content = function(file) { write.csv(mtcars, file) }
	  content = function(file) { write.csv(mtcars, file) }
	)
	
	output$cbt <- reactiveText(function(){})
  
	outputOptions(output, 'downloadData', suspendWhenHidden=FALSE)
	
})