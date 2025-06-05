# Set the working directory
setwd("data")

# install packages
install.packages("ggplot2")
library(ggplot2)

install.packages("rayshader")

install.packages("tidyverse")

install.packages("terra")

# read a csv file
read.csv("./data/lx.csv")

# read it into a object
full_dataset <- read.csv("./data/lx.csv")

# print the first few rows
head(full_dataset)

# print the last few rows
tail(full_dataset)

# print the entire dataset
print(full_dataset)

# setup a ggplot2 plot
ggplot(full_dataset, aes(x=Year))

# Add data points to the plot
# put a "+" on the original line
ggplot(full_dataset, aes(x=Year)) + 
  geom_point(aes(y=Female, colour = "Female"), size = 1) +
  geom_point(aes(y=Male, colour = "Male"), size = 1)

# correct the y axis and add labels using labs
ggplot(full_dataset, aes(x=Year)) + 
  geom_point(aes(y=Female, colour = "Female"), size = 1) +
  geom_point(aes(y=Male, colour = "Male"), size = 1) +
  labs(title="Male and Female Life Expectancy, in the US, 1933-2023", 
       y="Life Expectancy",
       x="Year (1933-2023") 


# adjust the color and add lines
color_map <- c("Female"="darkgreen", "Male" = "navy")
ggplot(full_dataset, aes(x=Year)) + 
  geom_point(aes(y=Female, colour = "Female"), size = 1) +
  geom_point(aes(y=Male, colour = "Male"), size = 1) +
  labs(title="Male and Female Life Expectancy, in the US, 1933-2023)", 
       y="Life Expectancy",
       x="Year (1933-2023") +
  scale_color_manual(values = color_map) +
  geom_line(aes(y=Female, color="Female"), linewidth = 0.5, alpha = 0.5) + 
  geom_line(aes(y=Male, color="female"), linewidth = 0.5, alpha = 0.5)

# add finer breaks on the axes
color_map <- c("Female"="darkgreen", "Male" = "navy")
ggplot(full_dataset, aes(x=Year)) + 
  geom_point(aes(y=Female, colour = "Female"), size = 1) +
  geom_point(aes(y=Male, colour = "Male"), size = 1) +
  labs(title="Male and Female Life Expectancy, in the US, 1933-2023)", 
       y="Life Expectancy",
       x="Year (1933-2023") +
  scale_color_manual(values = color_map) +
  geom_line(aes(y=Female, color="Female"), linewidth = 0.5, alpha = 0.5) + 
  geom_line(aes(y=Male, color="female"), linewidth = 0.5, alpha = 0.5) +
  scale_x_continuous(breaks = seq(1930,2023, 10)) +
  scale_y_continuous(breaks = seq(50,100,2))

# add a subtitle and shaded area with a caption
ggplot(full_dataset, aes(x=Year)) + 
  annotate("rect", xmin = 2019, xmax = 2023, ymin = -Inf, ymax = Inf, alpha = 0.2, fill = "gray50") +
  geom_point(aes(y=Female, colour = "Female"), size = 1) +
  geom_point(aes(y=Male, colour = "Male"), size = 1) +
  labs(title="Male and Female Life Expectancy, in the US, 1933-2023)", 
       y="Life Expectancy",
       x="Year (1933-2023",
       subtitle="Data retrived from the Human Mortality Database",
       caption="Shaded area shows the COVID-19 pandemic period.") +
  scale_color_manual(values = color_map) +
  geom_line(aes(y=Female, color="Female"), linewidth = 0.5, alpha = 0.5) + 
  geom_line(aes(y=Male, color="Male"), linewidth = 0.5, alpha = 0.5) +
  scale_x_continuous(breaks = seq(1930,2023, 10)) +
  scale_y_continuous(breaks = seq(50,100,2)) +  theme_minimal()
