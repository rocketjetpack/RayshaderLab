# Rayshader Intro
# Load required libraries
library(usethis)
library(devtools)
library(rayshader)
library(tidyverse)
library(rgl)
library(terra)

# Patch the options so that hopefully rgl viewer works
options(rgl.printRglwidget = TRUE)
# Pop the rgl widget into the Viewer tab
rglwidget()

# Access the raster elevation data using the terra package
# https://apps.nationalmap.gov/downloader/
# https://earthexplorer.usgs.gov/
elev_raster <- terra::rast("./tiff/dem_01.tiff")

# Draw a basic R plot using this data
plot(elev_raster)

# Create a matrix from the raster image using a Rayshader functions
elev_matrix <- rayshader::raster_to_matrix(elev_raster)

# Shift + Command + M adds the pipe from tidyverse
# Take the elevation matrix and plot it
# this is the same as rayshader::plot_map(elev_matrix)
elev_matrix %>% 
  rayshader::plot_map()

# Visualize using sphere shading
elev_matrix %>% 
  rayshader::sphere_shade(texture = "desert") %>% 
  plot_map()

# textures
# Builtin textures to rayshader are:
# imhof[1-4], bw, desert, unicorn
# imhof is named after Eduard Imhoff, a geographer who invented relief shading

# Shift the direction of the light source
elev_matrix %>% 
  rayshader::sphere_shade(texture = "desert", sunangle = 45) %>% 
  plot_map()

# Add water using a basic function "detect_water"
# This function looks for adjacent values that are the same, implying
# a flat surface.
elev_matrix %>% 
  rayshader::sphere_shade(texture = "desert", sunangle = 90) %>%
  rayshader::add_water(detect_water(elev_matrix), color="unicorn") %>% 
  plot_map()

# Raytraced layer from the same direction as the sun
# raytracing simulates reflection,m refraction, and soft shadows
elev_matrix %>% 
  rayshader::sphere_shade(texture = "desert", sunangle = 90) %>%
  rayshader::add_water(detect_water(elev_matrix), color="desert") %>% 
  add_shadow(ray_shade(elev_matrix), 0.7) %>% 
  plot_map()

# Add ambient occlusion layer - atmospheric scattering
elev_matrix %>% 
  rayshader::sphere_shade(texture = "desert", sunangle = 90) %>%
  rayshader::add_water(detect_water(elev_matrix), color="desert") %>% 
  add_shadow(ray_shade(elev_matrix), 0.4) %>% 
  add_shadow(ambient_shade(elev_matrix), 0.4) %>% 
  plot_map()

# Open an rgl window
open3d()

# Plot 3d
elev_matrix %>% 
  rayshader::sphere_shade(texture = "desert", sunangle = 120) %>%
  rayshader::add_water(detect_water(elev_matrix), color="darkblue") %>% 
  add_shadow(ray_shade(elev_matrix), 0.4) %>% 
  add_shadow(ambient_shade(elev_matrix), 0.4) %>% 
  plot_3d(elev_matrix, zscale = 10, fov = 0, theta = 1, phi = 30,
          zoom = 1, windowsize = c(1600,1000), baseshape="hex")

# Turn it into a GIF or MP4
library(gifski)
library(av)
render_movie("Lab2-Gif.gif")
render_movie("Lab2-movie.mp4")

# Save as a 3d stl file
save_3dprint("Lab2.stl", maxwidth=150, unit="mm")

library(rayvista)
Yosemite <- plot_3d_vista(lat=37.742501, long=-119.558298, zscale=5, zoom=0.5,
                          overlay_detail=14, theta=-65, windowsize =2000, 
                          phi=25)

render_highquality(lightdirection = 220, clear=TRUE)
