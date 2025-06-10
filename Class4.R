# For detailed elevation data:
#   - Use Bbox finder: www.bboxfinder.com
#   - Example: Hawaii:
#     - -160.745638,18.479609,-154.272718,22.593726
#   - All elevation data is in meters (m)

library(rayshader)
# Elevatr allows downloading elevation data from the internet
library(elevatr)
# sf allows for simple features
library(sf)
library(rgl)

# Open a 3D window
open3d()

# st_bbox returns a simple bounding box defined by coordinates
# the CRS (coordinates reference system) is EPSG:4326 (origin at equator + prime meridian)
bbox <- st_bbox(c(xmin = -160.536285,  # West
                  xmax = -159.025204,  # East
                  ymin = 21.585935,    # South
                  ymax = 22.466878),   # North
                  crs = st_crs(4326) 
                  ) %>% 
        st_as_sfc() %>% 
        st_sf()# Change the bounding box into a simple feature geometry

# Load the raster data through elevatr
raster <- get_elev_raster(bbox, z=10, clip="bbox")
# Convert the raster data into a matrix
matrix <- raster_to_matrix(raster)

# Plot with water and create an object
shade <- (
  matrix %>% 
    sphere_shade(texture = "desert", zscale = 50)
)

plot_map(shade)

# Define the water
water_level <- 0
water_mask <- matrix < water_level
water_mask <- apply(water_mask, 2, rev)

shade_water <- (
  matrix %>% 
    sphere_shade(texture = "desert", zscale = 25) %>% 
    add_water(water_mask, color = "lightblue")
)

# Plot with water
plot_map(shade_water)

# Plot in 3D
plot_3d(
  heightmap = matrix,
  hillshade = shade,
  zscale = 15,
  water = TRUE,
  watercolor = "lightblue",
  solid = TRUE,
  waterlinecolor = "black",
  wateralpha = 1,
  phi = 5,
  theta = 100,
  zoom = 0.35
)

args(render_highquality)

render_highquality(
  lightaltitude = 25,
  samples = 256,
  lightintensity = 1100,
  water_attenuation = 0.05,
  height = 1080,
  width = 1920
)
