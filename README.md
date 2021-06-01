# Eurovision data science project

The purpose of this project has been to perform a brief analysis of Eurovision songs and winners since the start of the contest in 1956 until the most recent winner in 2021. This project is in two parts. 

1) Data analysis using RStudio, Postgres and pgadmin run in Docker containers with persistent data. The eurovision winners, EBU country member information and countries were imported into Postgres and connected into RStudio for data analysis. The docker-compose.yml file can be run to set up the network of containers and the script.R file can be run inside of RStudio to reproduce the data held in the plots file. 

The .csv files are of my own creation and are found in /data

A database schema is given in schema.sql

2) GIS analysis using geopandas and Jupyter notebook. Data produced from the first step presented a list of countries and the times they have won eurovision. This information was used to merge with a general world shapefile to display spatially using Geopandas and Python the winning Eurovision countries. I then correctly transformed the data into a projected format and used the geopandas clip feature present the Eurovision winners focusing on the European Region. 

The shapefile is found in /World_Countries

eurovision_python_map.ipynb shows the python and resulting maps. 

