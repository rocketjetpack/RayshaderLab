# Rayshader With Custom Maps
# Low to Medium Resolution Terrain
# or large lanmasses

# Data Source: NOAA - https://www.ncei.noaa.gov/maps/grid-extract/
# Generally the elevation data is in meters

# Load required libraries
library(rayshader)
library(tidyverse)
library(rgl)

open3d()


fuji <- raster_to_matrix("tiff/FujuClose.tiff")
plot(fuji)

fuji %>% 
  sphere_shade(texture = "imhof3") %>% 
  plot_map()

fuji %>% 
  sphere_shade(texture = "desert") %>% 
  add_water(detect_water(fuji)) %>% 
  plot_map()

# Calculate a water mask
water_level <- 0
water_mask_fuji <- fuji < water_level
# Invert the rows of the mask array
water_mask_fuji <- apply(water_mask_fuji, 2, rev)

fuji %>% 
  sphere_shade(texture = "desert") %>% 
  add_water(water_mask_fuji, color = "lightblue") %>% 
  plot_map()

# Plot 3d
fuji %>% 
  sphere_shade(texture = "desert") %>% 
  plot_3d(heightmap = fuji,
          zscale = 300,
          fov = 75,
          windowsize = 2000)

# Add water
fuji %>% 
  sphere_shade(texture = "desert") %>% 
  plot_3d(heightmap = fuji,
          zscale = 150,
          fov = 75,
          windowsize = 2000,
          water = TRUE,
          waterdepth = water_level,
          watercolor = "lightblue"
          )

# Add lines to show extent of water
fuji %>% 
  sphere_shade(texture = "desert") %>% 
  plot_3d(heightmap = fuji,
          zscale = 150,
          fov = 75,
          windowsize = 2000,
          water = TRUE,
          waterdepth = water_level,
          watercolor = "lightblue",
          waterlinecolor = "black",
          wateralpha = 0.7,
          linewidth = 2
        )

# Change color of base or remove it entirely
fuji %>% 
  sphere_shade(texture = "desert") %>% 
  plot_3d(heightmap = fuji,
          zscale = 350,
          fov = 120,
          windowsize = 4096,
          water = TRUE,
          waterdepth = water_level,
          watercolor = "#0E87CC",
          waterlinecolor = "black",
          wateralpha = 0.15,
          linewidth = 2,
          solid = FALSE,
          theta = -30,
          phi = 20,
          zoom = 0.25,
          )

render_highquality(filename = "MtFuji.jpg", 
                   samples=32,
                   lightdirection = 330,
                   lightaltitude = 60,
                   lightintensity = 850,
                   lightcolor = "lightyellow")
