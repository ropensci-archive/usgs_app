rcharts_prep1 <- function(sppchar, occurrs){
  require(rgbif); require(plyr); require(RColorBrewer);  require(taxize)
  # prepare occurrence data
  species2 <- strsplit(sppchar, ",")[[1]]
  out <- occurrencelist_many(species2, coordinatestatus = TRUE, maxresults = occurrs, 
    format="darwin", fixnames="change", removeZeros=TRUE)
  out$taxonName <- capwords(out$taxonName, onlyfirst=TRUE)
  out <- out[,c("taxonName","county","decimalLatitude","decimalLongitude",
    "institutionCode","collectionCode","catalogNumber","basisOfRecordString","collector")]
  out
}
 
rcharts_prep2 <- function(out, palette_name, popup = FALSE){ 
  # colors
  num_colours <- length(unique(out$taxonName))
  mycolors <- brewer.pal(max(num_colours, 3), palette_name)
  
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


gbifmap2 <- function(input_data, map_provider = 'MapQuestOpen.OSM', map_zoom = 2){
  require(rCharts)
  L1 <- Leaflet$new()
  L1$tileLayer(provider = map_provider, urlTemplate = NULL)
  
  L1$set(height = 400, width = 800)
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
