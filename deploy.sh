git push git@github.com:ropensci/usgs_app
rsync -avz --delete usgs_app ropensci@glimmer.rstudio.com:~/ShinyApps/ 