# Rayshader With Custom Maps
# Low to Medium Resolution Terrain
# or large lanmasses

# Data Source: NOAA - https://www.ncei.noaa.gov/maps/grid-extract/
# Generally the elevation data is in meters

# Load required libraries
library(rayshader)
library(tidyverse)
library(rgl)

# Open an rgl window
open3d()

# Load the Lake Mead elevation tiff
mead <- raster_to_matrix("tiff/LakeMead.tiff")

# Plot a top-down view of the elevation data
mead %>% 
  sphere_shade(texture = "desert") %>% 
  plot_map()

# Add water using the detect_water() method
mead %>% 
  sphere_shade(texture = "desert") %>% 
  add_water(detect_water(mead), color = "desert") %>% 
  plot_map()

# This is a poor approach because some of the elevation data contains
# bathymetric (sub-surface) data under the water level, so
# detect_water() cannot identify the correct area for water.

# Add water using flood-fill method
# Water level provided by https://mead.uslakes.info/level.asp
water_level <- 1156.49 / 39 * 12
# Generate a mask of elevations below the water level
water_mask <- mead < water_level
# Invert the water level because rayshader plots from bottom up, not
# top down.
# water_level <- apply(water_mask, 2, rev)
mead %>% 
  sphere_shade(texture = "desert") %>% 
  add_water(watermap = water_level, color = "darkblue") %>% 
  plot_map()

# Plot as a 3D object
final_shade <- (
  mead %>% 
    sphere_shade(texture = "desert") %>% 
    add_shadow(ray_shade(mead, zscale = 10), max_darken = 0.4) %>% 
    add_water(watermap = water_level, color = "unicorn") 
)

final_shade %>% 
  plot_3d(heightmap = mead, zscale = 75, fov = 90)

# Change the water to be translucent
mead %>% 
  sphere_shade(texture = "desert") %>% 
  plot_3d(
    heightmap = mead,
    zscal = 70,
    fov = 90,
    water = TRUE,
    waterdepth = water_level,
    watercolor = "darkblue",
    windowsize = 1500
  )

# Render a static image
render_snapshot()

# render a high quality image
render_highquality(
  lightaltitude = 5
)
