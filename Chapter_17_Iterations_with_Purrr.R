library(tidyverse)
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
library(lubridate)
library(purrr)

#################################################################################################################################################################################
# Chapter 17: Iteration with purrr
#################################################################################################################################################################################
# Reducing duplications can be done with either functions or iterations which allows for doing the same operations to multiple inputs
# There are two important types of iterations: imperative programming and functional programming

#################################################################################################################################################################################
# For Loops
#################################################################################################################################################################################
# Take the following tibble

df <- tibble(
  a = rnorm(10),
  b = rnorm(10),
  c = rnorm(10),
  d = rnorm(10)
)
df

# To compute the media would take several lines of code

median(df$a)
median(df$b)
median(df$c)
median(df$d)

# But this can be circumvented by utlizing a for loop

output <- vector("double", ncol(df)) # Output

for(i in seq_along(df)){     # sequence
  output[[i]] <- median(df[[i]]) # body
}
output

# Every for loop has three components
# 1. Output. Before starting the loop, it is important to allocate sufficient space for the output. This is very important for effciency. 
# A general way of creating an empty vector of given length is the vector() function. it has two arguments. The type of vector ("logical", "integer", "double", and "character") and the length of the vector
# 2. DequenceL This determines what to loop over. Each run of the for loop will assign i to a different value from seq_along*df. 
# seq_along() is similar to 1:length(l) with one important difference. It handles zero-length vectors correctly. 
# 3. Body: This is the code that does the work. It runs repeatedly each time with a different value for i. 

#################################################################################################################################################################################
# Exercises
#################################################################################################################################################################################
# 1. . Write for loops to:
# a. . Compute the mean of every column in mtcars.

car_mean <- vector("double", ncol(mtcars)) 

for(x in seq_along(mtcars)) {
  car_mean[[x]] <- mean(mtcars[[x]])
}
car_mean

# b. Determine the type of each column in nycflights13::flights

col_val <- vector("character", ncol(nycflights13::flights))

for(x in seq_along(nycflights13::flights)){
  col_val[[x]] <- typeof(nycflights13::flights[[x]])
}

col_val

# c. Compute the number of unique values in each column of iris

dist_row <- vector("double", ncol(iris))

for(x in seq_along(iris)){
    dist_row[[x]] <- n_distinct(iris[[x]]) 
}

dist_row

# d. 

ran_num <- vector("double", 4)
vals <- c(-10,0,10, 100)
vals

for(x in seq_along(4)){
  ran_num[[x]] <- mean(rnorm(vals[[x]]))
}
ran_num
