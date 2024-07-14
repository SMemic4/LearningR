library(tidyr)
library(dplyr)
library(ggplot2)
library(tidyverse)
library(nycflights13)
library(Lahman)
library(ggstance)
library(lvplot)
library(ggbeeswarm)
library(heatmaply) 
library(hexbin)
library(modelr)
library(forcats)
library(stringr)
library(nasaweather)
library(fueleconomy)

# Multiple tables of data are called relational data
# Relations are always defined between a pair of tables 
# There are 3 different verbs needed to work with pairs of relational data
# Mutating joins, which add new variables to one data frame from matching observations in another
# Filtering joins, which filter observations from one data frame based on whether or not they match an observation in the other table
# Set operations, which treat observations as if they were set elements

# Keys are variables used to connect each pair of tables. A key is a variable (or set of variables) that uniquely identifies an observation. In simple cases a single variable is needed to identify an observation while other times it requires more

# There are two type of keys
# Primary keys uniquely identify an observation in its own table
# Foreign keys uniquely identifies an observation in another table
# Variables can be both primary and foreign keys

# One way to identify primary keys in tables is to count() the primary keys and look for entries where n is greater than one

planes %>% count(tailnum) %>% filter(n > 1) # This returns zero tail numbers with a count greater than 1 indicating that this variable is a primary key in the planes table
weather %>% count(year, month, day, hour, origin) %>% filter(n > 1) # No primary keys in this set
flights %>% count(year, month, day, flight) %>% filter(n > 1) # No primary keys in this set
flights %>% count(year, month, day, tailnum) %>% filter(n > 1) # No primary keys in this set. 

# If a table lacks a primary key it's useful to add one with mutate() and row_number() to make it easier to match observations after filtering. This is called a surrogate key

flights %>% mutate(key = row_number())

# A primary key and a corresponding foreign key within another table form a relation. Relationships are usually one to many(Ex. One plane will have multiple flights)

######################### Exercises #########################################################################################################
# 1. Add a surrogate key to flights

flights %>% mutate(key = row_number())

# 2. Identify the keys in the following data sets 

# a. Lahman::Batting

Batting %>% count(playerID) %>% filter(n > 1) # "PlayerID is the primary key

# b. nasaweather::atmos

atmos %>% count(lat, long, year, month) %>% filter(n > 1) %>% nrow() # The primary keys are lat, long, year, and month

# c. fueleconomy::vehicles

vehicles %>% count(id) %>% filter(n > 1) %>% nrow() # The primary keys are id

# e. ggplot2::diamonds

diamonds %>% distinct() %>% nrow() # There are now distinct rows such the number of rows is less than total number of rows indicating there may be duplicate rows 

#############################################################################################################################################

# A mutating join allows for the combination of variables from two tables. It first matches observations by key and then copies across variables from one table to another

flights2 <- flights %>% select(year:day, hour, origin, dest, tailnum, carrier)
flights2 %>% select(-origin, -dest) %>% left_join(airlines, by = "carrier") # The result of joining the tables is a new column called name

# This can also be accomplished by using the mutate() function as well

flights2 %>% mutate(name = airlines$name[match(carrier, airlines$carrier)]) # Same out put as the line of code above

x <- tribble(~key, ~val_x, 1, "x1", 2, "x2", 3, "x3")
y <- tribble(~key, ~val_y, 1, "y1", 2, "y2", 4, "y3")

# The "key variable column is used to match the rows between the tables
# A join is a way of connecting each row in x to zero, one, or more rows in y

# The simplest join is the inner join. An inner join matches pairs of observations whenever their keys are equal. An inner join keeps observations that appear in both tables

x %>% inner_join(y, by = "key")

# The most important property of an inner join is that unmatched rows are not included in the result. Due to this inner joins are not appropriate for use in analysis because its easy to lose observations

# An outer join keeps observations that appear in at least one of the tables. There are three types of outer joins
# A left join keeps all observations in x
# A right join keeps all observations in y
# A full join keeps all observations in x and y
# These joins work by adding an additional "virtual" observation to each table. This observation has a key that always matches (if no other keys match), and a value filled with NA

# The most commonly used join is the left join, this is due to it preserving original observations even when there isn't a match. A strong reason is needed to use any other type of join

# There are two possibilities when joining when they are duplicates in tables 

# In the first scenario one of the table has duplicate keys. This is useful when you want to add in additional information as there is typically a one to many relationships


x <- tribble(~key, ~val_x, 1, "x1", 2, "x2", 2, "x3", 1, "x4")
y <- tribble(~key, ~val_y, 1, "y1", 2, "y2")
left_join(x, y, by = "key")

# In the second scenario both tables have duplicate keys. This is usually an error because in neither table do the keys uniquely identify an observation. When joining duplicated keys, all possible combinations are created, the Cartesian product

X <- tribble(~key, ~val_x, 1, "x1", 2, "x2", 2, "x3", 3, "x4")
y <- tribble(~key, ~val_y, 1, "y1", 2, "y2", 2, "y3", 3, "y4")
left_join(x, y, by = "key")

# So far, the pairs of tables have always been joined by a single variable and that variable has the same name in both tables. That constraint was encoded by by = "key". You can use other values for by to connect the tables in other ways
# The default, by = NULL uses all variables that appear in both tables (called a natural join). 
# For example, both flights and weather tables match on the common variables: year, month, day, hour, and origin

flights2 %>% left_join(weather)

# A character vector, by = "x". This is like a natural join, but uses only some of the common variables. 
# For example, flights and planes have year variables but they mean different things so we only want to join by tailnum

flights2 %>% left_join(planes, by = "tailnum") # In this data frame both have the year variables are disambiguated in the output with a suffix

# A named character vector: by = c("a" = "b"). This will match variable a in table x to variable b in table y. The variables from x will be used in the output
# For example, to draw a map by combining flight data with airports data (which contains location lat and long) of each airport. Each flight has an origin and destination airport, so it needs to specify which one to join to

flights2 %>% left_join(airports, c("dest" = "faa"))
flights2 %>% left_join(airports, c("origin" = "faa")) # This works because flight "origins" and airports "faa" are synonymous with one another and that is how it allows the table to be matched

######################### Exercises #########################################################################################################

# 1. Compute the average delay by destination, then join on the airports data frame, so you can show the spatial distribution of delays. Here’s an easy way to draw a map of the United States:

flights %>% group_by(dest) %>% mutate(avg_delay = mean(arr_delay, na.rm = TRUE)) %>% left_join(airports, c("dest" = "faa")) %>% ggplot(aes(lon, lat)) + borders("state") + geom_point() + coord_quickmap()

# 2. Add the location of the origin and destination (i.e., the lat and lon) to flights.

airports_loc <- airports %>% select(faa, lat, lon)
flights %>% select(year:day, hour, origin, dest) %>% left_join(airports_loc, by = c("origin" = "faa")) %>% left_join(airports_loc, by = c("dest" = "faa"))

# 3. Is there a relationship between the age of a plane and it's delay?

plane_age <- planes %>% select(tailnum, year)
plane_age %>% count(year) %>% print(n = Inf) # There are 47 distinct levels ( or years of planes) Looking from the data we see a relatively small number of planes in early years compared to post 1980
plane_age %>% count(year) %>% arrange(desc(n)) %>% ggplot(aes(x = year, y = n)) + geom_col() # A bar graph showing that the skew of the distribution of planes lies heavily toward the later years rather than the earlier

# When we take a look how the average delay time compares, there is still an unclear picture of what the actual difference is between the two groups

flights %>% left_join(plane_age, by = "tailnum") %>% group_by(year.y) %>% summarize(average_delay = mean(dep_delay, na.rm = TRUE)) %>% ggplot(aes(x = year.y, y = average_delay)) + geom_col() + coord_flip()
flights %>% left_join(plane_age, by = "tailnum") %>% group_by(year.y) %>% summarize(average_delay = mean(dep_delay, na.rm = TRUE)) %>% ggplot(aes(x = year.y, y = average_delay)) + geom_point()
age_delay <- flights %>% left_join(plane_age, by = "tailnum")

# Comparing the average delay time before and after 1980 
age_delay %>% filter(`year.y` <= 1980) %>% summarize(avg_delay2 = mean(dep_delay, na.rm = TRUE))  # Average delay for planes in the 1980 was 8.3 minutes
age_delay %>% filter(`year.y` > 1980) %>% summarize(avg_delay2 = mean(dep_delay, na.rm = TRUE)) # Average delay for planes in the post 1980 was 13.2 minutes

flights %>% left_join(plane_age, by = "tailnum") %>% group_by(year.y) %>% filter(`year.y` > 1980) %>% summarize(average_delay = mean(dep_delay, na.rm = TRUE)) %>% ggplot(aes(x = year.y, y = average_delay)) + geom_col() + coord_flip()
flights %>% left_join(plane_age, by = "tailnum") %>% group_by(year.y) %>% filter(`year.y` > 1980) %>% summarize(average_delay = mean(dep_delay, na.rm = TRUE)) %>% ggplot(aes(x = year.y, y = average_delay)) + geom_point()
flights %>% left_join(plane_age, by = "tailnum") %>% group_by(year.y) %>% filter(`year.y` > 1980) %>% summarize(average_delay = mean(dep_delay, na.rm = TRUE)) %>% ggplot(aes(x = year.y, y = average_delay)) + geom_smooth() 

# An interesting trend that is noticeable in the data is that the average delay time had increasing almost every year since the 1980 but begins to decrease every year after 2005 and is sub ten minutes after 2010
# Based on the information above, it is inconclusive to say if average delay time is correlated with the age of the plane. It is possible that the planes are truly faster than their pre 1980 counterparts but since they are more planes at the air port and more congestion this can attribute to greater delays in departure

# 4. What weather conditions make it more likely to see a delay?

flight_weather <- flights %>% left_join(weather) # A left join without any additional vectors will bind all matching columns together in each table

# Possible types of weather that could affect delay times include visibility and precipitation 

flight_weather %>% group_by(precip) %>% summarize(avg_delay = mean(dep_delay, na.rm = TRUE)) %>% ggplot(aes(x = precip, y = avg_delay)) + geom_point()
flight_weather %>% group_by(precip) %>% summarize(avg_delay = mean(dep_delay, na.rm = TRUE)) %>% ggplot(aes(x = precip, y = avg_delay)) + geom_col() + coord_flip()
flight_weather %>% group_by(precip) %>% summarize(avg_delay = mean(dep_delay, na.rm = TRUE)) %>% ggplot(aes(x = precip, y = avg_delay)) + geom_smooth()
flight_weather %>% group_by(precip) %>% summarize(avg_delay = mean(dep_delay, na.rm = TRUE)) %>% ggplot(aes(x = precip, y = avg_delay)) + geom_line()

# It appears that if any precipitation then the average delay time will increase no matter what

flight_weather %>% count(visib) # 21 different values with numerous counts for each
flight_weather %>% group_by(visib) %>% summarize(avg_delay = mean(dep_delay, na.rm = TRUE)) %>% ggplot(aes(x = visib, y = avg_delay)) + geom_point()
# It appears lower the visibility the greater the delay time
flight_weather %>% group_by(visib) %>% summarize(avg_delay = mean(dep_delay, na.rm = TRUE)) %>% ggplot(aes(x = visib, y = avg_delay)) + geom_col() + coord_flip()
# Also supported by this graph
flight_weather %>% group_by(visib) %>% summarize(avg_delay = mean(dep_delay, na.rm = TRUE)) %>% ggplot(aes(x = visib, y = avg_delay)) + geom_smooth()
# Graph shows a relatively modest decrease in average delay as visibility increases. Notably average delay time seems to stagnate between 2.5 and 7.5 miles of visibility
flight_weather %>% group_by(visib) %>% summarize(avg_delay = mean(dep_delay, na.rm = TRUE)) %>% ggplot(aes(x = visib, y = avg_delay)) + geom_line()
# Supports theory above

# Overall it seems that precipitation always provides a modest increase to delay times, as does visibility but not to the same extent

#############################################################################################################################################

# Filtering joins can match observations in the same way as mutating joins, but affects the observations, not the variable. There are two types:
# semi_join(x, y) keeps all observations in x that have a mach in y
# anti_join(x, y) drops all observations in x that have a match in y
# Semi joins are useful for matching filtered summary tables back to original rows 

# For example imagine you've found the top ten most popular destinations

top_dest <- flights %>% count(dest, sort = TRUE) %>% head(10)
flights %>% filter(dest %in% top_dest$dest) # This code finds each flight that went to each one of those destinations. This line of code is useful
 
# To accomplish this approach with multiple variables use semi_join(). This will connect two tables like a mutating join but instead of adding new columns, only keeps the rows in x that have a match in y

flights %>% semi_join(top_dest)

# Only the existence of a match is important. It doesn't matter which observation is matched. This means filtering joins never duplicates rows like mutating joins
# The inverse of a semi-join is an anti-join. An anti-join keeps the rows that don't have a match. Anti-joins are useful for diagnosing join mismatches

flights %>% anti_join(planes, by = "tailnum") %>% count(tailnum, sort = TRUE)

######################### Exercises #########################################################################################################
# 1. What does it mean for a flight to have a missing tailnum? What do the tail numbers that don’t have a matching record in planes have in common?

flights %>% filter((is.na(tailnum) & !is.na(arr_time))) %>% nrow() # A flight with a missing tailnum indicates that the plane had never arrived to it's origin point and thus the flight was canceled

# 2. Filter flights to only show flights with planes that have flown at least 100 flights

top_planes <- flights %>% filter(!is.na(tailnum)) %>% count(tailnum, sort = TRUE) %>% filter(n >= 100) # This code removes any invalid flights since those are canceled flights, then it counts the total number of times a plane has flown and sort its, it than finally only selects planes that have had 100 or more flights with a given plane and stores it in a new object
flights %>% filter(tailnum %in% top_planes$tailnum) # This compares the tailnum in the flights data set and compares it to the filtered tailnums in the top_planes object that was created just above. It compares those sequences to only include matching tailnums
flights %>% semi_join(top_planes, by = "tailnum") # This does what the code does above but in an easier way. A semi join only includes observations if they can find a match 

top_planes2 <- flights %>% count(tailnum, sort = TRUE) %>% filter(n < 100 | is.na(tailnum)) 
flights %>% anti_join(top_planes2, by = "tailnum") # These two lines of code do the same thing but by creating an object (top_planes2) of the observations we don't want and then filters out the tailnums with an anti_join to filter all of those flights

# 3. Combine fueleconomy::vehicles and fueleconomy::common to find only the records for the most common models

common_car <- fueleconomy::common %>% arrange(desc(n))

fueleconomy::vehicles %>% semi_join(fueleconomy::common, by = c("make", "model")) # Make and model is used to group the cars due to the fact that two car brands can make a car with the same mode name

#############################################################################################################################################

# When working with joining data together there are several steps that should be done before working with data
# Start by identifying variables that form the primary key in each table. This should be done through understanding of the data and not empirically looking for combination of variables
# Check that none of the variables in the primary key are missing. If a value is missing then it can't be identify an observation
# Check that primary keys match foreign keys. Best way to do this is with an anti_join()

# There are a final two-table verbs that are set operations. All of the operations work with a complete row, comparing the values of every variable. These expect the x and y inputs to have the same variables and treat the observations like sets:
# intersect(x, y) returns only observations in both x and y
# union(x, y) return unique observations in x and y
# setdiff(x, y) return observations in x, but not in y

df1 <- tribble(~x, ~y, 1, 1, 
                       2, 1)
df2 <- tribble(~x, ~y, 1, 1, 
                       1, 2)
intersect(df1, df2) 
union(df1, df2)
setdiff(df1, df2)
setdiff(df2, df1)

#############################################################################################################################################

# Chapter 10 is complete
 