##-----------------------------------------------##
##    Author: Adela Sobotkova                    ##
##    Institute of Culture and Society           ##
##    Aarhus University, Aarhus, Denmark         ##
##    adela@cas.au.dk                             ##
##-----------------------------------------------##

#### Goals ####

# - Modify the provided code to improve the resulting map

# We highlighted all parts of the R script in which you are supposed to add your
# own code with: 

# /Start Code/ #

print("Hello World") # This would be your code contribution

# /End Code/ #

#### Required R libraries ####

# We will use the sf, raster, and tmap packages.
# Additionally, we will use the spData and spDataLarge packages that provide new datasets.
# These packages have been preloaded to the worker2 workspace.


library(sf)
library(raster)
library(tmap)
library(spData)
library(spDataLarge)

#### Data sets #### 

# We will use two data sets: `nz_elev` and `nz`. They are contained by the libraries
# The first one is an elevation raster object for the New Zealand area, and the second one is an sf object with polygons representing the 16 regions of New Zealand.

#### Existing code ####

# We wrote the code to create a new map of New Zealand.
# Your role is to improve this map based on the suggestions below.

tm_shape(nz_elev)  +
  tm_raster(title = "elev", 
            style = "cont",
            palette = "BuGn") +
  tm_shape(nz) +
  tm_borders(col = "red", 
             lwd = 3) +
  tm_scale_bar(breaks = c(0, 100, 200),
               text.size = 1) +
  tm_compass(position = c("LEFT", "center"),
             type = "rose", 
             size = 2) +
  tm_credits(text = "A. Sobotkova, 2020") +
  tm_layout(main.title = "My map",
            bg.color = "orange",
            inner.margins = c(0, 0, 0, 0))

#### Exercise I ####

# 1. Change the map title from "My map" to "New Zealand".
# 2. Update the map credits with your own name and today's date.
# 3. Change the color palette to "-RdYlGn". 
#    (You can also try other palettes from http://colorbrewer2.org/)
# 4. Put the north arrow in the top right corner of the map.
# 5. Improve the legend title by adding the used units (m asl).
# 6. Increase the number of breaks in the scale bar.
# 7. Change the borders' color of the New Zealand's regions to black. 
#    Decrease the line width.
# 8. Change the background color to any color of your choice.

# Your solution

# /Start Code/ #

# set working directory
setwd("~/cds-spatial/Week02") # change working directory if needed

# load packages
pacman::p_load(sf, raster, tmap, spData, spDataLarge) 


tm_shape(nz_elev)  +
  tm_raster(title = "elev (m asl)", # added units
            style = "cont",
            palette = "-RdYlGn") + # changed colour palette
  tm_shape(nz) +
  tm_borders(col = "black", # changes borders to black 
             lwd = 1) + # decreased the line width
  tm_scale_bar(breaks = c(0, 100, 200, 300, 400), # added number of breaks
               text.size = 1) +
  tm_compass(position = c("RIGHT", "top"), # changed location of compass
             type = "rose", 
             size = 2) +
  tm_credits(text = "S. Karlson, 02/09/21") + # changed name and date
  tm_layout(main.title = "New Zealand", # changed title from "My map" to "New Zealand"
            bg.color = "white", # changed background to white (blue was too salient)
            inner.margins = c(0, 0, 0, 0))

# /End Code/ #

#### Exercise II ####

# 9. Read two new datasets, `srtm` and `zion`, using the code below.
#    To create a new map representing these datasets.

srtm = raster(system.file("raster/srtm.tif", package = "spDataLarge"))
zion = read_sf(system.file("vector/zion.gpkg", package = "spDataLarge"))

# Your solution

# /Start Code/ #

# inspect the maps 
plot(srtm)
plot(zion)
plot(st_geometry(zion))

# get the crs from the two maps
st_crs(zion) # zion is vector, so we use st_crs()
crs(srtm) # srtm is raster, so we use crs()

# Get the CRS from the srtm object
the_crs <- crs(srtm, asText = TRUE)

# Project zion to match the CRS of srtm
zion_crs <- st_transform(zion, crs = the_crs)

# plot maps together
tm_shape(srtm) + 
  tm_raster(title = "elev (m asl)", # added units
            style = "cont",
            palette = "YlGn") + # I choose the Y1Gn palette
  tm_layout(legend.position = c("right","top")) + # moved the legend
  tm_scale_bar(breaks = c(0, 2, 4, 6), # changed number of breaks
               text.size = 1, 
               position = c("LEFT", "bottom")) + # moved scale_bar
  tm_shape(zion_crs) + 
  tm_polygons(alpha = 0.5) +
  tm_compass(position = c("left", "center"), # changed location of compass
             type = "rose", 
             size = 2) +
  tm_credits(text = "S. Karlson, 02/09/21") # changed name and date

# /End Code/ #
