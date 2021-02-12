##-----------------------------------------------##
##    Author: Adela Sobotkova                    ##
##    Institute of Culture and Society           ##
##    Aarhus University, Aarhus, Denmark         ##
##    adela@cas.au.dk                             ##
##-----------------------------------------------##

#### Goals ####

# - Understand the provided datasets
# - Learn how to reproject spatial data
# - Limit your data into an area of interest
# - Create a new map

# We highlighted all parts of the R script in which you are supposed to add your
# own code with: 

# /Start Code/ #

print("Hello World") # This would be your code contribution

# /End Code/ #

#### Required R libraries ####

# We will use the sf, raster, and tmap packages.
# Additionally, we will use the spData and spDataLarge packages that provide new datasets. 
# These packages have been preloaded to the worker2 workspace.

setwd("~/cds-spatial/Week02/HW") # change working directory if needed

library(sf)
library(raster)
library(tmap)
library(spData)
library(spDataLarge)

#### Data sets #### 

# We will use two data sets: `srtm` and `zion`.
# The first one is an elevation raster object for the Zion National Park area, and the second one is an sf object with polygons representing borders of the Zion National Park.

srtm <- raster(system.file("raster/srtm.tif", package = "spDataLarge"))
zion <- read_sf(system.file("vector/zion.gpkg", package = "spDataLarge"))

# Additionally, the last exercise (IV) will used the masked version of the `lc_data` dataset.

study_area <- read_sf("data/study_area.gpkg")
lc_data <- raster("data/example_landscape.tif")
lc_data_masked <- mask(crop(lc_data, study_area), study_area)

#### Exercise I ####

# 1. Display the `zion` object and view its structure.
# What can you say about the content of this file?
# What type of data does it store? 
# What is the coordinate system used?
# How many attributes does it contain?
# What is its geometry?
# 2. Display the `srtm` object and view its structure.
# What can you say about the content of this file? 
# What type of data does it store?
# What is the coordinate system used? 
# How many attributes does it contain?
# How many dimensions does it have? 
# What is the data resolution?

# Your solution (type answer to the questions as code comments and the code used)

# /Start Code/ #

# 1. 
#Display the `zion` object and view its structure.
## For this I use the plot() and head() function
plot(zion)
head(zion)

# What can you say about the content of this file?
## I can see that it's a vector map

# What type of data does it store? 
## The columns contain a Unit code, GIS notes with a link, the date it was edited, state, region, gnis ID, 
## unit type, who it was created by, a link to meta data, parkname, and lastly the geom information

# What is the coordinate system used?
crs(zion)
?crs()
## the crs() function tells me that it uses the UTM (Universal Transverse Mercator) coordinate system

# How many attributes does it contain?
## When I use the plot() function I see 9 maps, so I assume this means that the map has 9 attributes 

# What is its geometry?
## When using the head() function, it tells us that the geom column is a polygon



# Display the `srtm` object and view its structure.
plot(srtm)
head(srtm)

# What can you say about the content of this file?
## It's a raster file, i.e. it's a matrix of values

# What type of data does it store?
## It shows elevation data is my guess

# What is the coordinate system used? 
crs(srtm)
## the crs() function tells be that it uses longitude and lattitude

# How many attributes does it contain?
## As it's a raster with only one layer, I would say 1

# How many dimensions does it have? 
## Using the dim() function shows me that it has three dimensions; 457 rows, 465 columns and one colour channel
## it has only 1 channel, because it only shows elevation (if it was RGB colours, it could need three channels)
dim(srtm)

# What is the data resolution?
res(srtm) 
## the res() function tells me that the resolution is 0.0008333333 0.0008333333 - I'm not quite sure what that means though

# /End Code/ #


#### Exercise II ####

# 1. Reproject the `srtm` dataset into the coordinate reference system used in the `zion` object. 
# Create a new object `srtm2`
# Vizualize the results using the `plot()` function.
# 2. Reproject the `zion` dataset into the coordinate reference system used in the `srtm` object.
# Create a new object `zion2`
# Vizualize the results using the `plot()` function.


# Your solution

# /Start Code/ #

# 1.

# Get the CRS from the zion object
zion_crs <- crs(zion, asText = TRUE)

# Project srtm to match the CRS of zion
srtm2 <- projectRaster(srtm, crs = zion_crs, method = "ngb")

# plot the srtm2 object to see how it is slightly rotated compared to the original
plot(srtm2)


# 2. 

# Get the CRS from the srtm object
srtm_crs <- crs(srtm, asText = TRUE)

# Project zion to match the CRS of srtm
zion2 <- st_transform(zion, crs = srtm_crs)

# plot the zion2 object to see how it is slightly rotated compared to the original
plot(zion2)
plot(zion) # switch between zion2 and this zion plot to see the difference

# /End Code/ #
