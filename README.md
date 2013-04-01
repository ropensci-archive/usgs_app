usgs_app
========

## Shiny app to interact with USGS data

## Package dependencies:
### Install normally, with install.packages("packagename")
+ shiny
+ plyr
+ ggplot2
+ doMC
+ ape
+ ggphylo
+ RSQLite
+ DBI

### Install from Github using the devtools package
+ taxize
+ rgbif

```R
install.packages("devtools")
library(devtools)
install_github("taxize_", "ropensci", "local_sql")
library(taxize)
install_github("rgbif", "ropensci")
library(rgbif)
```

To sync code to a Shiny server:

+ Make any changes to code
+ Commit them 
+ Push to github
+ Then `cd ..` out to parent directory above `usgs_app` repo, and rsync to the Shiny server

`rsync -avz --delete usgs_app ropensci@glimmer.rstudio.com:~/ShinyApps/`

...then enter the password for the server