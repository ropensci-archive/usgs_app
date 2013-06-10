usgs_app
========

## Shiny app to interact with USGS data

See [this gist](https://gist.github.com/SChamberlain/5286615) for many examples of what to enter in the search box.

## Package dependencies:
### Install normally, with install.packages("packagename")
+ shiny
+ plyr
+ ggplot2
+ doMC
+ ape
+ ggphylo

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
install_github("rbison", "ropensci")
library(rbison)
install_github("rCharts", "ramnathv")
library(rCharts)
```

To sync code to a Shiny server:

+ Make any changes to code
+ Commit them 
+ Push to github
+ Then `cd ..` out to parent directory above `usgs_app` repo, and rsync to the Shiny server

`rsync -avz --delete usgs_app ropensci@glimmer.rstudio.com:~/ShinyApps/`

...then enter the password for the server