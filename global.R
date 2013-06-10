rcharts_prep1 <- function(sppchar, occurrs, datasource){
  
  require(plyr); require(RColorBrewer);  require(taxize)
  # prepare occurrence data
  species2 <- strsplit(sppchar, ",")[[1]]
  
  if(datasource=="GBIF"){
    require(rgbif)  
    out <- occurrencelist_many(species2, coordinatestatus = TRUE, maxresults = occurrs, 
                               format="darwin", fixnames="change", removeZeros=TRUE)
    out$taxonName <- capwords(out$taxonName, onlyfirst=TRUE)
    out <- out[,c("taxonName","county","decimalLatitude","decimalLongitude",
                  "institutionCode","collectionCode","catalogNumber","basisOfRecordString","collector")]
    out
  } else
  {
    require(rbison); require(doMC)
    registerDoMC(cores=4)
    hh <- llply(species2, function(x){
      temp <- bison_data(bison(x, count = occurrs), "data_list")
      llply(temp, function(x){ 
        names(x)[2:4] <- c("taxonName","decimalLongitude","decimalLatitude")
        x$taxonName <- capwords(x$taxonName, onlyfirst=TRUE)
        x 
      })
    }, .parallel=TRUE)
    do.call(c,hh)
  }
}
 
get_colors <- function(vec, palette_name){
  num_colours <- length(unique(vec))
  brewer.pal(max(num_colours, 3), palette_name)
}

rcharts_prep2 <- function(out, palette_name, popup = FALSE){ 
  
  if(is.gbiflist(out))
    out <- apply(out, 1, as.list)
  
  # colors
  mycolors <- get_colors(out$taxonName, palette_name)
  mycolors_df <- data.frame(taxon=unique(sapply(out, function(x) x[["taxonName"]])), color=mycolors)
  
  out_list2 <- llply(out, function(x){ 
    x$fillColor = mycolors_df[mycolors_df$taxon %in% x$taxonName, "color"]
    x
  })
  
  # popup
  if(popup)
    out_list2 <- lapply(out_list2, function(l){
      l$popup = paste(paste("<b>", names(l), ": </b>", l, "<br/>"), collapse = '\n')
      return(l)
    })
  out_list2 <- Filter(function(x) !is.na(x$decimalLatitude), out_list2)
  toGeoJSON(out_list2, lat = 'decimalLatitude', lon = 'decimalLongitude')
}

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

gbifmap2 <- function(input_data, map_provider = 'MapQuestOpen.OSM', map_zoom = 2, height = 600, width = 870){
  require(rCharts)
  L1 <- Leaflet$new()
  L1$tileLayer(provider = map_provider, urlTemplate = NULL)
  L1$set(height = height, width = width)
  L1$setView(c(30, -73.90), map_zoom)
  L1$geoJson(input_data, 
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

get_palette <- function(userselect){
  colours_ <- data.frame(
    actual=c("Blues","BuGn","BuPu","GnBu","Greens","Greys","Oranges","OrRd","PuBu",
            "PuBuGn","PuRd","Purples","RdPu","Reds","YlGn","YlGnBu","YlOrBr","YlOrRd",
            "BrBG","PiYG","PRGn","PuOr","RdBu","RdGy","RdYlBu","RdYlGn","Spectral"),
    choices=c("Blues","BlueGreen","BluePurple","GreenBlue","Greens","Greys","Oranges","OrangeRed",
              "PurpleBlue","PurpleBlueGreen","PurpleRed","Purples",
              "RedPurple","Reds","YellowGreen","YellowGreenBlue","YellowOrangeBrown","YellowOrangeRed",
              "BrownToGreen","PinkToGreen","PurpleToGreen","PurpleToOrange","RedToBlue","RedToGrey",
              "RedYellowBlue","RedYellowGreen","Spectral"))
  as.character(colours_[colours_$choices %in% userselect, "actual"])
}