usgs_app
========

Shiny app to interact with USGS data

Sync to our ropensci Shiny server:

+ Make changes
+ Commit them
+ Push to github
+ Then `cd ..` out to parent directory above `usgs_app` repo, and rsync to the Shiny server

`rsync -avz --delete usgs_app ropensci@glimmer.rstudio.com:~/ShinyApps/`

...then enter the password for our server. 