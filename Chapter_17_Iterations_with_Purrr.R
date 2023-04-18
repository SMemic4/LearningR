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
# Reducing duplication can be done with either functions or iterations which allows for doing the same operations to multiple inputs
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
#################################################################################################################################################################################
# For Loop Variations
#################################################################################################################################################################################
# For Loop Variations
# There are four basic variations on the basic theme of a for loops
# 1. Modifying an existing object, instead of creating a new object
# 2. Looping over names or values, instead of indices
# 3. Handling outputs of unknown length
# Handling sequences of unknown length


df <-tibble(a = rnorm(10),
            b = rnorm(10),
            c = rnorm(10),
            d = rnorm(10))


rescale01 <- function(x) {
  rng <- range(x, na.rm = TRUE)
  (x - rng[1]) / (rng[2] - rng[1])
}

# To resale every column in a data frame using a for loop three components must be considered
# 1. Output - Which in this case is the input is the same as the output
# 2. Sequence - A data frame can be thought of as a list of columns, so each column can be iterated over with seq_along()
# 3. Body - In this case rescale01() will be applied 

for(x in seq_along(df)){
  df[[x]] <- rescale01(df[[x]])
}
df

# When modifying a list or data frame with this sort of for loop, it is important to use [[]] instead of []. It may be useful to use [[]] even when working with atomic vectors 

# There ar three basic ways to loop over a vector
# 1. Looping over the number indices with for(i in seq_along(xs))
# 2. Loop over the elements: for(x in xs), this is most useful for side effects like plotting or saving a file, due to it being difficult to save the output efficiently
# 3. Loop over the names: for(nm in names(xs)). This gives a name which which can be accessed with x[[nm]]. Useful if the name needs to be used in a plot title or a file name

# Sometimes the length of the output will be unknown. Imagine a case where random vectors with random values are simulated. A typical solution to solve this problem would be progressively growing the vector

means <- c(0,1,2)
output <- double()

for(i in seq_along(means)){
  n <- sample(100,1)
  output <- c(output, rnorm(n, means[[i]]))
}
str(output)

# This is an efficient method, due to R having to copy all the data from the previous iteration. This behavior is "quadratic" (O(n^2)) behavior, which means that loop with three times as many elements would take nine (3^2) times as long to run

# A better solution to save the results in a list and then combine into a single vector after the loop is done

out <- vector("list", length(means))
for (i in seq_along(means)){
  n <- sample(100, 1)
  out[[i]] <- rnorm(n, means[[i]])
}
str(out)  
str(unlist(out)) # Unlist() is used to flatten a list of vectors into a single vector. 

# This pattern can occur in other places as well
# 1. When generating a long string, instead of pasting together each iteration with the previous, save the output in a character vector and then combine that vector into a single string with paste(output, collapse = "")
# 2. When generating a big data frame, instead of sequentially rbind()ing in each iterations save the output in a list, then use bind_rows(output) to combine the output into a single data frame

# Sometimes the input length will be unknown. This is common when doing simulations. Sometimes when attempting to fulfill a certain condition these tasks can't be completed when using a for loop. Instead use a while loop
# A while loop is simpler than a for loop because it only has two components, a condition and a body

# A while loop is also more general than a for loop, because any for loop can be rewritten as a while loop, but not every while loop can be rewritten as a for loop

# This while loop shows how many tries it takes to get three heads in a row

flip <- function(){
  sample(c("H", "T"), 1)
}

nheads <- 0
flips  <- 0 

while(nheads < 3){
  if(flip() == "H")
  {
    nheads <- nheads + 1
  }
  else
  {
    nheads <- 0
  }
  flips <- flips + 1
}
flips

#################################################################################################################################################################################
# Exercises
#################################################################################################################################################################################
# 1. What happens if you use for (nm in names(x)) and x has no names? What if only some of the elements are named? What if the names are not unique?
  
noname <- 1:10

for(nm in names(noname))
{
  print(identity(nm))
}
# Does not work

somenames <- c("col1" = 1, 2, "col3" = 3)

for(nm in names(somenames)){
  print(identity(nm))
}
# The names are printed and any missing names are replaced with ""

dupnames <- c("col1" = 1, "col3" =  2, "col3" = 3)
for(nm in names(dupnames)){
  print(identity(nm))
}
# All the names are printed 

# 2. Write a function that prints the mean of each numeric column in a data frame, along with its name.

mean(iris[[]])

show_mean <- function(x){
  vv <- vector("character", length(x))
  for(i in seq_along(x))
  {
      if(is.numeric(x[[i]]))
      {
        avg <- mean(x[[i]])
        nn <- names(x[i])
        vv[[i]] <- paste(nn, avg, sep = ": ")
      }
      else
      {
          next
      }
  }
  (unlist(vv))
}

show_mean(iris)
show_mean(mtcars)

#################################################################################################################################################################################
# For Loops Versus Functionals
#################################################################################################################################################################################
# For loops are not as important in R as they are in other languages because R is a functional programming language, This is due to it being possible to wrap up for loops in a function and call that function directly instead of using the for loops directly

df <- tibble(
  a = rnorm(10),
  b = rnorm(10),
  c = rnorm(10),
  d = rnorm(10)
)
df

# Imagine needing to compute the mean of this data frame. This could be done with a for loop:

output <- vector("double", length(df))
for(i in seq_along(df)){
  output[[i]] <- mean(df[[i]])
}
output

# However this process can be simplified by creating a function that will compute the mean of every function

col_mean <- function(df){
    output <- vector("double", length(df))
    for(i in seq_along(df))
    {
      output[i] <- mean(df[[i]])
    }
  output
}

# A similar function can be created to the one above that will find the mean, median, and standard deviation  
col_summary <- function(df, fun){
  output <- vector("double", length(df))
  for(i in seq_along(df))
  {
    output[i] <- fun(df[[i]])
  }
  output
}
col_summary(df, mean)
col_summary(df, median)
col_summary(df, sd)

# The idea of passing a function within another function is a very useful tool in R. It's one of the behaviors that make it a functional programming language 

#################################################################################################################################################################################
# Exercises
#################################################################################################################################################################################
# 1. Read the documentation for apply(). In the second case, what two for loops does it generalize?

# It applies for loops to all of the rows and columns a vector

# 2 Adapt col_summary() so that it only applies to numeric columns. You might want to start with an is_numeric() function that returns a logical vector that has a TRUE corresponding to each numeric column

col_summary2() <- function(df, fun){
  numeric_cols <- vector("logical", length(df))
  for (i in seq_along(df)) 
  {
    numeric_cols[[i]] <- is.numeric(df[[i]]) # This creates a logical vector to test which columns are numeric
  }
  index <- which(numeric_cols) # Creates an index of numeric columns to refer to later
  n <- sum(numeric_cols) # Finds the total number of numeric columns and allows to create the right sized vector
  output <- vector("double", n) # Vector that will hold the numeric values
  
  for(i in seq_along(index))
  {
    output[[i]] <- fun(df[[index[[i]]]]) # Uses the stored index value to find the correct value in the original data frame
  }
  output
}

#################################################################################################################################################################################
# Map Functions
#################################################################################################################################################################################
# The purrr package provides a family of functions for looping over vectors and doing something to each element. There are several functions for each type of output
# map() makes a list 
# map_lgl() makes a logical vector
# map_int() makes an integer vector
# map_dbl() makes a double vector
# map_chr() makes a character vector
# Each of these functions takes a vector as an input and applies a function to each piece and then returns a new vector with the same length (and names) as the input
# The type of vector is determined by the suffix to the map function
# The main advantage of using a map function is not speed but clrity 


df <-tibble(a = rnorm(10),
            b = rnorm(10),
            c = rnorm(10),
            d = rnorm(10))

map_dbl(df, mean) # These functions performs the same computation as the previous for loop
map_dbl(df, median)
map_dbl(df, sd)

# Compared to for loops the purpose of the map functions is focused on the operation being performed and not the iteration of looping over each element

df %>% map_dbl(mean)
df %>% map_dbl(median)
df %>% map_dbl(sd)

# There are few key differences between map functions and col_summary()
# 1. All purrr functions are implemented in C making them faster at the expense of readability
# 2. The second argument in map functions (.f), the function to apply, can be a formula, a character vector, or an integer vector
# 3. Map functions used (...) to pass along additional arguments to .f each time it's called

map_dbl(df, mean, trim = 0.5)

# 4. Map functions also preserve names

# Imagine creating a linear fut model for each group within a dataset. The following example splits up mtcars dataset into three pieces (one for each type of cylinder) amd fits the same linear model to each piece

models <- mtcars %>% split(.$cyl) %>% map(function(df) lm(mpg ~ wt, data = df))
models

# Purrr provides a convenient short-cut - a one-sided formula:

models <- mtcars %>% split(.$cyl) %>% map(~lm(mpg ~ wt, data = .))
models

# The . here is used as a pronoun. It refers to the current list element (in the same way that i referred to the current index in the for loop)

# When observing many models, to extract a summary statistics such as R^2 it is necessary to run a summary() function and hen extract the r^2 component 

models %>% map(summary) %>% map_dbl(~.$r.squared)

# Purr has an additional shortcut which allows for common operations to be called for using a string

models %>% map(summary) %>% map_dbl("r.squared")

# An integer can be used to select elements by position:

x <- list(list(1, 2, 3), list(4, 5, 6), list(7, 8, 9))
x %>% map_dbl(2) # 2, 5, 8

# the apply() family of functions share similarities with the purrr functions

# lapply() is basically identical to map(), expect that map() is consistent with all the other functions in purrr, and shortcuts can be used for .f (functions)
# Base sapply() is a wrapper around lappy() that automatically simplifies the output. 
# vapply() is a safer alternative to sapply() due to it only requiring the additional argument that defines the type. 

#################################################################################################################################################################################
# Exercises
#################################################################################################################################################################################
# 1. Write code that uses one of the map functions to:

# a. Compute the mean of every column in mtcars

mtcars %>% map_dbl(mean)

# b. Determines the type of each column in nycflights13::flights

flights %>% map_chr(typeof)

# c. Compute the number of unique values in each column of iris.

iris %>% map_int(n_distinct)

# d. To generate 10 random normals for each of μ = -10, 0, 10, and 100. The result is a list of numeric vectors. 

map(c(-10, 0, 10, 100), ~rnorm(n = 10, mean = .))

# 2. How can you create a single vector that for each column in a data frame indicates whether or not it’s a factor?

diamonds %>% map_lgl(is.factor)

# 3. What happens when you use the map functions on vectors that aren’t lists? What does map(1:5, runif) do? Why?

# Map functions can be used on any vector or list however it will always return a list no matter the output. Secondly, when running map(1:5, runif) it will run through that list 5 times selecting and drawing from additional numbers as it progresses up the list.

# 4. What does map(-2:2, rnorm, n = 5) do? Why? What does map_dbl(-2:2, rnorm, n = 5) do? Why?

map(-2:2, rnorm, n = 5) 
map_dbl(-2:2, rnorm, n = 5) 

# The first expression takes samples from a group of five with normal distributions with means of -2, -1, 0, 1, and 2 and returns a list of numeric vectors with a length of 5
# The second expression falls because the map function requires each element it applies to you to return a vector a 1. 

#################################################################################################################################################################################
# Dealing with Failure
#################################################################################################################################################################################
# The more map functions that used for operations the higher the chance of failure occurring 
# When this occurs, an error message will appear and no output will be received 
# safely() is a function that takes a function and returns a modified version of it. 
# Safely() will never throw an error, instead it always returns a list with two elements:
# 1. Result - The original result. If there was an error, this will be NULL
# 2. Error - An error object, If the operation was successful this will be NULL
# These are similar to the try() function in base R

safe_log <- safely(log)
str(safe_log(10)) # $ result: num 2.3,  $ error : NULL

str(safe_log("a")) # $ result: NULL , $ message: chr "non-numeric argument to mathematical ..."

# When the function succeeds the result element contains the result and the error element is NULL
# When the function fails, the result element is NULL and the error element contains an error object

# safely() is designed to work with map:

x <- list(1, 10, "a")
y <- x %>% map(safely(log))
str(y)

# transpose() can be used to create two lists, one with all of the outputs and one with all of the errors. It is a purrr function

y <- y %>% transpose()
str(y)

# purr provides two other useful functions:
# 1. possibly() always succeeds. It's simpler than safely() because it returns a default value when there is an error

x <- list(1, 10, "a")
x %>% map_dbl(possibly(log, NA_real_)) # 0.000000 2.302585  NA

# 2. quietly() performs a similar role to safely(), but instead of capturing errors, it captures printed output, messages, and warnings: 

x <- list(1, -1)
x %>% map(quietly(log)) %>% str()

#################################################################################################################################################################################
# Mapping over Multiple Arguments
#################################################################################################################################################################################


