library(tidyr)
library(dplyr)
library(ggplot2)
library(tidyverse)

ggplot(data = mpg)
nrow(mpg)
ncol(mpg)
summary(mpg)
mpg

ggplot(data = mpg) + geom_point(mapping = aes(x = displ, y = hwy))

ggplot(data = mpg) + geom_point(aes(x = displ, y = hwy))

ggplot(data = mpg) + geom_point(aes(x = hwy, y = cyl))

ggplot(data = mpg) + geom_point(aes(x = displ, y = hwy, color = class)) # Argument changes the color of the point depending on the "class value"

ggplot(data = mpg) + geom_point(aes(x = displ, y = hwy, size = class)) # Creates a scatter plot and adds a sorts class of mileage based on the class of the vehicle. Warning is achieved here because mapping an unordered variable to an unordered aesthetic is ill advised

ggplot(data = mpg) + geom_point(aes(x = displ, y = hwy, alpha = class)) # Creates a scatter plot. The points are given a transcperany value depending on the class of car they belong to 

ggplot(data = mpg) + geom_point(aes(x = displ, y = hwy, shape = class)) # Creates a scatter plot. The points are assigned a shape based on the given class they fall under. However gggplot2 will only use 6 shapes at a time. In this case the SUV class goes unplotted

ggplot(data = mpg) + geom_point(aes(x = displ, y = hwy), color = "red") # Creates a scatter plot, where the points are manually selected to be red

ggplot(data = mpg) + geom_point(aes(x= displ, y = hwy)) + facet_wrap(~ class) # Creates multiple scatter plots which are subdivided into different facets based on class

ggplot(data = mpg) + geom_point(aes(x= displ, y = hwy)) + facet_grid(drv ~ cyl) # Creates multiple scatter plots which are further subdivided into facets based on "drv" and "cyl" 

ggplot(data = mpg) + geom_point(aes(x= displ, y = hwy)) + facet_grid(.~ class) # Creates the scatter plot facets wraps without the row and column dimensions

ggplot(data = mpg) + geom_point(aes(x = displ, y = hwy)) + facet_wrap(.~ cty)

ggplot(data = mpg) + geom_point(aes(x = displ, y = hwy)) + facet_grid(. ~ cyl)

ggplot(data = mpg) + geom_smooth(aes(x = displ, y = hwy)) # Creates a line graph geom with the data

ggplot(data = mpg) + geom_smooth(aes(x = displ, y = hwy, linetype = drv)) # Creates a line graph geom with each line graph subdivided by "drv" class

ggplot(data = mpg) + geom_smooth(aes(x = displ, y = hwy, linetype = drv, color = drv), show.legend = FALSE) 

ggplot(data = mpg) + geom_smooth(aes(x = displ, y = hwy, linetype = drv, color = drv)) + geom_point(aes(x = displ, y = hwy, color = drv))

ggplot(data = mpg, aes(x = displ, y = hwy, color = drv)) + geom_smooth() + geom_point() # Creates a graph with both line and scatter plot geometric objects by inheriting the the specified characteristic assigned in the ggplot 

ggplot(data = mpg, aes(x = displ, y = hwy)) + geom_point(aes(color = class)) + geom_smooth() # Creates a graph with both line and scatter geoms but specifically assigns certain aesthetics to the scatter geom

ggplot(data = mpg, aes(x = displ, y = hwy)) + geom_point(mapping = aes(color = class)) + geom_smooth(data = filter(mpg, class == "subcompact"),se = FALSE)

ggplot(data = mpg) + geom_bar(aes(x = class)) # Bar geom

ggplot(data = mpg) + geom_boxplot(aes(x = hwy)) # Boxplot geom

ggplot(data = mpg) + geom_area(aes(x = displ, y = hwy, color = "orange"))

ggplot(data = mpg, aes(x = displ, y = hwy)) + geom_smooth(color = "blue", se = FALSE) + geom_point()

ggplot(data = mpg, aes(x = displ, y = hwy)) + geom_smooth(se = FALSE, show.legend = FALSE) + geom_point() # 6a graph

ggplot(data = mpg, aes(x = displ, y = hwy)) + geom_smooth(aes(group = drv), se = FALSE, show.legend = FALSE) + geom_point() # 6b graph

ggplot(data = mpg, aes(x = displ, y = hwy, group = drv, color = drv)) + geom_smooth(se = FALSE) + geom_point() # 6c graph

ggplot(data = mpg, aes(x = displ, y = hwy)) + geom_smooth(se = FALSE) + geom_point(aes(group = drv, color = drv)) # 6d graph

ggplot(data = mpg, aes(x = displ, y = hwy, group = drv)) + geom_smooth(aes(linetype = drv), se = FALSE) + geom_point(aes(color = drv)) # 6e graph

ggplot(data = mpg, aes(x = displ, y = hwy)) + geom_point(aes(group = drv, color = drv)) # 6f graph

# Statistical transformation

ggplot(data = diamonds) + geom_bar(aes(x = cut))

ggplot(data = diamonds) + stat_count(aes(x = cut)) # Makes the previous graph using stats instead of geoms. Possible because geom_bar uses the same stat; stat_count()

ggplot(data = diamonds) + geom_bar(aes(x = cut, y = ..prop.., group = 1)) # Creates a bar graph that overrides the stat function and graphs the variables based on proportion rather than count 

ggplot(data = diamonds) + stat_summary(aes(x = cut, y = depth), fun.ymin = min, fun.ymax = max, fun.y = median) # Creates a weird graph

ggplot(data = diamonds, aes(x = cut, y = depth)) + geom_col() # Creates a bar graph based on the actual heights of the data supplied instead of the count

ggplot(data = diamonds) + geom_bar(aes(x = cut, y = ..prop..)) # Forgetting the group = 1 when doing proportions will set the graphs to be all equal to 1

ggplot(data = diamonds) + geom_bar(aes(x = cut, fill = color, y = ..prop..)) # Forgetting the group = 1 when doing proportions will set the graphs to be all equal to 1

ggplot(data = diamonds) + geom_bar(aes(x = cut, color = cut)) # Creates a bar graph with different color outlines around each bar for each cut

ggplot(data = diamonds) + geom_bar(aes(x = cut, fill = cut)) # Creates a bar graph with a different colored bars for each of the different x variables

ggplot(data = diamonds) + geom_bar(aes(x = cut, fill = clarity)) # Creates a colored bar graph where each chart is further subdivided in color by the clarity variable

ggplot(data = diamonds, aes(x = cut, fill = clarity)) + geom_bar(alpha = 3/5, position = "identity") # Creates a colored bar graph that sorts clarity by color

ggplot(data = diamonds, aes(x = cut, color = clarity)) + geom_bar(fill = NA, position = "identity") # Creates a transparent bar graph that sorts clarity by color

ggplot(data = diamonds) + geom_bar(aes(x = cut, fill = clarity), position = "fill") # Creates a proportion bar graph of the different cuts and sorts them by color

ggplot(data = diamonds) + geom_bar(aes(x = cut, fill = clarity), position = "dodge") # Creates a bar chart where the overlapping objects are placed next to one another

ggplot(data = mpg) + geom_point(aes(x = displ, y =hwy), position = "jitter") # Creates a scatter plot that adds random noise to the each plot point preventing overlap in the data showing more of the mass of data at the cost of accuracy (a small amount)

ggplot(data = diamonds) + geom_bar(aes(x = cut, fill = clarity), position = "dodge2") # Creates a colored bar graph that subdivides each of the x variables by the clarity and places the overlapping objects next to one another with more space compared to regular dodge

ggplot(data = mpg, aes(x = cty, y = hwy)) + geom_jitter() # Exercise 1, Improves an overlapping scatterplot by adding the jitter position to make the points more visable 

ggplot(data = mpg, aes(x = cty, y = hwy)) + geom_jitter(width = 0.5, height = 0.5) # Width and height are parameters that can be added to the jitter function to control how much noise each point receives

ggplot(data = mpg, aes(x = displ, y = hwy)) + geom_boxplot()

ggplot(data = mpg, aes(x = class, y = hwy)) + geom_boxplot() # Creates a horizontal box plot

ggplot(data = mpg, aes(x = class, y = hwy)) + geom_boxplot() + coord_flip() # Creates a vertical box plot with y and x axis flipped 

nz <- map_data("nz")
ggplot(nz, aes(long, lat, group = group)) + geom_polygon(fill = "white", color = "black")
view(nz)

nz <- map_data("nz")
ggplot(nz, aes(long, lat, group = group)) + geom_polygon(fill = "white", color = "black") + coord_quickmap()
view(nz)

bar <- ggplot(data = diamonds) + geom_bar(aes(x = cut, fill = cut), show.legend = FALSE, width = 1) + theme(aspect.ratio = 1) + labs(x = NULL, y = NULL)
bar + coord_flip()
bar + coord_polar()

barx <- ggplot(data = diamonds) + geom_bar(aes(x = cut, fill = clarity), show.legend = FALSE) +  labs(x = NULL, y = NULL)
barx + coord_polar()

ggplot(data = mpg, aes(x = cty, y = hwy)) + geom_point() + geom_abline() + coord_fixed() 


 

