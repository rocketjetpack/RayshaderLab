pop_size <- read.csv("data/jp_pop.csv")
# data is already in "long" format, so no need to convert as TMW did in his tutorial

# clean the data 
library(dplyr)
pop_size <- pop_size %>%
  mutate(
    Year = as.integer(gsub("[^0-9]", "", Year)), # ensures columns only contain numeric
    Age = ifelse(Age == "110+", 110, Age), # replaces the 110+ rows with "110" so all are numeric "top censoring"
    Age = as.integer(Age) # converts all "Age" values to numeric
  ) %>%
  filter(!is.na(Year), !is.na(Age)) # removes any rows where year or age is missing

# scrap the 110+ lines
pop_size <- pop_size %>%
  filter(Age < 110)

library(ggplot2)
library(scales)
pop_size_final <- ggplot(pop_size, aes(x = Year, y = Age, fill = Total)) +
  geom_tile() +
  scale_fill_viridis_c(
    option = "magma",
    labels = label_comma()  # replaces scientific notation
  ) +
  scale_x_continuous(
    breaks = unique(c(seq(1947, 2025, by = 10))),
    expand = c(0, 0)
  )+ 
  scale_y_continuous(
    breaks = unique(c(seq(0, 110, by = 10),max(pop_size$Age))),
    expand = c(0, 0)
  )+ 
  labs(
    title = "Population of Japan, 1947 to present",
    x = "Year",
    y = "Age",
    fill = "Population"
  )

#plot 2d
plot(pop_size_final)

# plot 3d
library(rayshader)
open3d()
plot_gg(
  pop_size_final,
  multicore = TRUE,
  width = 6,
  height = 6,
  scale = 300,           # adjust to exaggerate or flatten verticals
  sunangle = 90,         # lighting angle
  solid = TRUE,
  shadowcolor = "black",
  windowsize = c(1000, 800)
)

# make the scale more dramatic! 
plot_gg(pop_size_final, scale = 200)  # higher number = more dramatic

#render as movie! 
render_movie("jp_pop_no_log.gif")
