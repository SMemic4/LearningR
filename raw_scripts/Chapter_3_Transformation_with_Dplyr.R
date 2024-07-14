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
###############################################################################################################################################################
# Chapter 3: Data transformation with dplyr
###############################################################################################################################################################

# When loading the dplyr package it will overwrite some basic functions in R. To utilize these basic functions you'll need to use their full names (Ex.stats::lag())

# To view a dataset in it's entirety use view(dataset_name). This will print out the data set as a tibble
# To just print out the data set into the console just type its name(Ex flights)
# When printing a data frame there are various letter abbreviations that appear underneath the columns
# int stands for integers
# dbl stands for doubles or real numbers
# chr stands for character vectors, or strings
# dttm stands for date-times (a data + time)
# lgl stands for logical vectors that only contain TRUE or FALSE
# fctr stands for factors, which r uses to represent categorical variables with possible fixed values
# date stands for date

#  There are a couple major dplyr functions
# filter() which allows for observations to be picked by the values
# Arrange() which reorders the rows
# Select() which picks variables by their name
# Mutate() creates new variables with functions of existing variables
# summarize() which collapses many values down to a single summary
# group_by() which changes the functioning of the dataset to work on designated groups 

# All of these functions work the same. The first argument is a data frame, the subsequent argument describes what to do with the data using the variable name (without quotes), and the result is a new data frame
###############################################################################################################################################################
# Filter Rows with filter()
###############################################################################################################################################################
# Filter() allows for a subset of observations to be chosen from a data frame

filter(flights, month == 1, day == 1) # This code selects all observations from the first month and first day. Note that this is a new data frame

# The results of the new data frame can be saved using the assignment operator "<-"

jan1 <- flights %>% filter(month == 1, day == 1)

# A data frame can be saved and printed at the same time if it is bound within parentheses

(dec25 <- flights %>% filter(month == 12, day == 25)) # Saves and prints the subset of observations from December 25th 

# Filtering can be enhanced by using comparison operators to filter more effectively. They are the following: >, >=, <, <=, != (not equal), == (equal)

# One common issue encountered when doing comparisons is a floating-point numbers:

sqrt(2) ^ 2 == 2 # Returns a FALSE
1/49 * 49 == 1 # Returns a FALSE

# This is due to computers using a finite precision arithmetic. To overcome this error utilize the function near()

near(sqrt(2) ^ 2, 2) # Returns TRUE
near(1 / 49 * 49, 1) # Returns TRUE

# Multiple arguments can be applied to filter() and are combined with default operator of "and". For filter to correctly work every expression must be true for a row to be included
# There are several other operators that can be used to filter
# & for "and"
# | for "or"
# ! for "not"

flights %>% filter(month == 11 | month == 12) # Finds all observations of flights from the month of November or December 

# An alternative to the code above is the expression "x %in% y". Which will select every row where x is one of the values in y

flights %>% filter(month %in% c(11, 12)) # Selects every month (x) which has an month (observation also "y") of 11 or 12

# De Morgan's law can simplify complicated operations
# !(x & y) = !x | !y
# !(x | y) = !x & !y

flights %>% filter(dep_delay <= 120, arr_delay <= 120) # This selects only flights that did not have departure or arrival delay of greater than two hours
flights %>% filter(!(dep_delay > 120 | arr_delay > 120)) # Another way to get the same code as above

# "NA" are missing values. NA represents an unknown value. They are "contagious. Almost any operation invovling an unknown value will be unknown

NA > 5 # Returns NA
10/NA # Returns NA
NA + 10 # Returns NA

# Even NA = NA returns NA. To determine if a variable is missing use is.na()

missing_value <- NA
is.na(missing_value) # Returns TRUE

# Filter() only includes rows where the condition is TRUE, it excludes false and NA values. To preserve missing values, they must be asked for explicitly 

rf <- tibble(x = c(1, NA, 3))
filter(rf, x > 1) # Only returns 3
filter(rf, x > 1 | is.na(x)) # Returns NA and 3

###############################################################################################################################################################
# Exercises
###############################################################################################################################################################
# 1. Find all Flights

# a. Had an arrival delay of two or more hours

flights %>% filter((arr_delay >= 120)) # Finds any flights that have an arrival delay equal or greater than 120 minutes (2 hours)
flights %>% filter(!(arr_delay < 120)) # Same code as above but it finds all arrival delays that are NOT less than 120 minutes

# b. Flew to Houston (IAH or HOU)

flights %>% filter(dest == "IAH" | dest == "HOU") # Finds any observations for the destinations variable that have the observations "IAH" or "HOU:

# c. Were operated by United, American, or Delta

# The carrier names for United, American and Delta are "UA", "AA", and "DL" respectively

flights %>% filter(carrier == "UA" | carrier == "AA" | carrier == "DL") # Finds specific airlines carriers

# d. Departed in summer 

# Summer is considered the following months: July, August, and September. This corresponds to the months 7,8,9

flights %>% filter(month == 7 | month == 8 | month == 9) # Code only selects for the months of July, August, and September

# e. Arrived more than two hours late, but didn't leave late

flights %>% filter(arr_delay > 120 & dep_delay <= 0) # Code selects flights that arrived two hours late but left on time

# f. Were delayed by at least an hour, but made up over 30 minutes in flight

flights %>% filter(dep_delay >= 60, dep_delay-arr_delay > 30)

# g. Departed between midnight and 6 a.m. (inclusive)

filter(flights, dep_time <= 600 | dep_time == 2400)

# 2. Another useful filtering helper is between(). What does it do? Use it to simplify the previous code

# Between() is a shortcut method of finding observations between two variables without using conditional operators 

# a. Had an arrival delay of two or more hours

# Cant use between for this since the right argument would be left blank



# b. Flew to Houston (IAH or HOU)

# Cant use between() for this since it uses unordered strings

# c. Were operated by United, American, or Delta

# The carrier names for United, American and Delta are "UA", "AA", and "DL" respectively

# Cant use between() for this since it uses unordered strings

# d. Departed in summer 

# Summer is considered the following months: July, August, and September. This corresponds to the months 7,8,9

# Can use this for between() for this function
flights %>% filter(between(month, 7,9))

# e. Arrived more than two hours late, but didn't leave late

# Can't use between for this function

# f. Were delayed by at least an hour, but made up over 30 minutes in flight

# Can't use between for this function

# g. Departed between midnight and 6 a.m. (inclusive)

filter(flights, dep_time <= 600 | dep_time == 2400)
flights %>% filter(between(dep_time,0 , 600)) # Close but it adds a few additional observations

# 3, How many flights have a missing dep_time ? What other variables are missing? What might these rows represent?

# These rows represent canceled flights because most if not all of them are missing arrival times indicating the flight never left

flights %>% filter(is.na(dep_time))

# 4. Why is NA ^ 0 not missing? Why is NA | TRUE not missing? Why is FALSE & NA not missing?

NA^0 # The out put is 1. This is because anything to the power of 0 is one

# Na | TRUE is true because TRUE is always TRUE so if something is missing it will default to TRUE

# Same reasoning as above the default expression will default to FALSE no matter what

###############################################################################################################################################################
# Arrange Rows with arrange()
###############################################################################################################################################################
# Arrange() works similarly to filter() except that instead of selecting rows, it changes their order. It takes a data frame and a set of column names to order by. It arranges in ascedning order

flights %>% arrange(month)

# If more than one column name is provided, each additional column will be used to break ties in the values of preceding columns

flights %>% arrange(year, month, day)

# Use desc() to reorder a column in descending order

flights %>% arrange(desc(arr_delay))

# Missing values are always sorted at the end

df <- tibble(x = c(5, 2, NA))
df %>% arrange(x) # Order is 5,2 , NA
df %>% arrange(desc(x)) # Order is 2, 5, NA

###############################################################################################################################################################
# Exercises
###############################################################################################################################################################
# 1. How could you use arrange() to sort all missing values to the start?

df <- tibble(x = c(5, 2, NA))
df %>% arrange(desc(is.na(x))) # Use is.na to find all missing values, and since NA are sorted at the end of the list use desc() to bring them to the top

# 2. Sort flights to find the most delayed flights. Find the flights that left the earliest

flights %>% arrange(desc(dep_delay)) # Use the variable dep_delay to find the longest delay and place them in descending order to find the most delayed flight

flights %>% arrange(arr_delay) # A negative arrival time indicates that the plane left the earliest therefore there is no need to use desc() 

# 3. Sort flights to find the fastest flights

flights %>% arrange(air_time)

# 4. Which flights traveled the longest? Which traveled the shortest?

flights %>% arrange(distance) # Shortest distance
flights %>% arrange(desc(distance)) # Longest distance

###############################################################################################################################################################
# Select Columns with select()
###############################################################################################################################################################











