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
# Chapter 16: Vectors
#################################################################################################################################################################################
# There are two types of vectors
# Atomic vectors of which there are six types (logical, integar, double, character, complex, and raw). Integer and double vectors are known as numeric vectors
# Lists, which are sometimes called recursive vector because lists can 

# The key difference between atomic vectors and lists is that atomic vectors are homogeneous while lists can be hetrogeneous
# The other difference is NULL. NULL is often used to represent the absence of a vector. NULL typically behaves like a vector of length 0

#  Every vector has two key properties:
# 1. Its type which is determined with typeof()

typeof(letters) # character
typeof(1:10) # integer

# 2, Its length, which can be determined by length()

x <- list("a", "b", 1:10)
length(x) # 3

# Vectors can also contain arbitrary additional metadata in the form of attributes. THese attributes are used to create augmented vectors, which build on additional behavior

# There are several important types of augmented vectors:
# 1. Factors are  built on top of integer vectors
# 2, Date and dates times are built on top of numeric vectors
# 3, Data frames and tibbles are built on top of lists
#################################################################################################################################################################################
# Important Types of Atomic Vectors
#################################################################################################################################################################################

# The four most important types of atomic vectors are logical, integer, double, and character. Raw and complex are rarely used during data analysis

# Logical vectors are the simplest type of atomic vector because they can only take three posssible values : FALSE, TRUE, and NA
# Logical vectors are usually constricuted with comparison operators

1:10 %% 3 == 0 # FALSE FALSE  TRUE FALSE FALSE  TRUE FALSE FALSE  TRUE FALSE

# They can also be created with c()

c(TRUE, TRUE, FALSE, NA)

# Integer and double vectors are known as numeric vectors. In R numbers are dooubles by default. To make an ineger place a L after the number

typeof(1) # double
typeof(1L) # Integer

# The distinction between integers and doubles is usually not important but there are two key differences to consider
# 1. DOubles are approximations. Doubles represent floating-point numbers that cannot always be precisely represented with a fixed amount of memory. 

x <- sqrt(2) ^ 2
x # 2
x - 2 # 4.440892e-16

# Most calculations include some approximation error. Use near() for some numerical tolerance instead of ==
# 2, Integers have one special value NA, while doubles have four, NA, NANA, Inf, and -InF . All three special values can arise during division
c(-1, 0, 1) / 0 # -Inf  NaN  Inf
# Avoid using == to check for these special values instead use the helper functions is.finite(), is.infinite(), and is.nan()

# Character vectors are the most complex type of atomic vector, because each element of a character vector is a string, and a string can contain an arbitrary amount of data

# Note that each type of atomic vector has its own missing value

NA # logical
NA_integer_ # integer
NA_real_ # double
NA_character_ # character

# Normally you don't need to know about these different ypes because you can always use NA and it will be converted to the correct type through implicit coercion rules
#################################################################################################################################################################################
# Exercises
#################################################################################################################################################################################
# 1. Describe the difference between is.finite(x) and !is.infinite(x).

# The `is.finite()` function will consider any non-missing values, missing, NaN, and Inf and - Inf to not be finite. is.infinite only considers Inf and -Inf to be inifinite

# 2. How does near() work?

# Near() uses a tolerance to if the values are close enough to one another. This value can be modified

#################################################################################################################################################################################
# Using atomic vectors

# There are two ways to convert, or coerce, one type of vector to another:
# 1. Explicit coercion when calling a function as.logical(), as.integer(), as.double(), or as.character()
# 2. Implicit coercion happens when using a vector in a specific context that expects a certain type of vector

# Example of implicit coercion
x <- sample(20, 100, replace = TRUE)
y <- x > 10
sum(y)
mean(y)

#  When creating a vector with multiple types with c(), the most complex type always wins

typeof(c(TRUE, 1L)) # Integer
typeof(c(1L, 1.5)) # Double
typeof(c(1.5, "a")) # Character

# An atomic vector cannot have a mix of different types because the type is a property of hte complete vector, not the individual elements. If you need to mix multiple types in the same vector a list should be used instead


# As well as implicitly coercing the types of vectors to be compatible R will also implicity coerce the length of vectors which is called vector recycling because the shorter vector is repeated, or recycled to the same lenght as the longer vector

# Most built-in functions are vectorized, meaning that they will operate on a vector of numbers. 
# Basic mathmatical operations work with vectors. That means that you should never need to perform explicit iteration when performing simple math computations

1:10 + 1:2 # 2  4  4  6  6  8  8 10 10 12

# In the example above, R will expand the shortest vector to the same length as the longest (vector recycling). This is silent expect when the length of the longer is not an integer multiple of the length of the shorter

1:10 + 1:3 # longer object length is not a multiple of shorter object length

# Vector recycling can be useful but can also cause problems. Vectorized functions in tidyverse will throw errors when you recycle anything other than a scaler. If you do want to recycle you'll need to do it with rep()

tibble(x = 1:4, y = rep(1:2, 2))

# All types of vectors can be named. They can name them during creation with c()

c(x = 1, y = 2, z = 4)

# Of after the fact with purrr set_names()

set_names(1:3, c("a", "b", "c"))

# Named vectors are most useful for subsetting

# Filter() is used to filter rows in a tibble. Filter() only works with tibble, so a new tool for vectors is used []. It is called like x[a]

# There are four types of things that you can subset a vector with:
# 1. A number vector containing only integers. The integers either be all positive, all negative, or zero. SUbsetting with positive integers keeps the elements at those positions
x <- c("one", "two", "three", "four", "five")
x[c(3, 2, 5)]

# By repeating a position, i's possible to make a longer output than unput

x[c(1, 1, 5, 5, 5, 2)]

# Negative values drop the elements at the specified positions

x[c(-1, -3, -5)]

# An error occurs when mixing positive and negative vlaues

x[c(1, -1)]

# An error message also occurs when subsetting with zero which returns no values

x[0]

# 2. Subsetting with a logical vector keeps all values corresponding to a TRUE value/ This is most often useful in conjunction with the comparsion functions

x <- c(10, 3, NA, 5, 8, 1, NA)

# All non-missing values of x

x[!is.na(x)] # 10  3  5  8  1

# All even (or missing!) values of x

x[x %% 2 == 0] # 10 NA  8 NA

# 3. IA named vector can be subset with a character vector

x <- c(abc = 1, def = 2, xyz = 5)
x[c("xyz", "def")] # xyz def  5   2 

# Such as positive integers, its possible to use a character vector to duplicate individual entries

# 4. The simplest type of subsetting is nothing x[], which returns the complete x. This is not useful for subsetting vectors but useful when subsetting matrices

# There is an important variation of [ called [[ only ever extracts a single element and always drops names. It makes it clear only a single element is being extracted. It is important for lists

#################################################################################################################################################################################
# Exercises
#################################################################################################################################################################################
# 1. What does mean(is.na(x)) tell you about a vector x? What about sum(!is.finite(x))?
  
# mean(is.na(x)) calculates the proprtio of NA values in a vector. sum(!is.finite(x)) gives the total number of infinite objects in x

# 2. Create functions that take a vector as input and return:
x <- c(NA, NA, 1,2,3,4,5,6,7,8,9,10)
# a. The last value

lastv <- function(x){
    x[length(x)]
}
lastv(x)

# b. . The elements at even numbered positions

evenv <- function(x){
    
    x[seq_along(x) %% 2 == 0]
}
evenv(x)

# c. Every element except the last value

anybut1 <- function(x){
    x[1:(length(x)-1)]
}
anybut1(x)

# d. Only even numbers (and no missing values)

eve <- function(x){
    x[((1:length(x) %% 2 == 0)) & !is.na(x)]
}
eve(x)

# Why is x[-which(x > 0)] not the same as x[x <= 0]?

# The difference is how they would treat non integer values
#################################################################################################################################################################################
# Recursive Vectors (Lists)
#################################################################################################################################################################################
# Lists are more complex than atomic vectors because lists can contain other lists, making them suitable for representing hierarchical or tree-like structures
# A list can be created with list()

x <- list(1,2,3)
x

# A useful tool for working with lists is str() because it focuses on the structure, not the contents

str(x)

x_named <- list(a = 1, b = 2, c = 3)
str(x_named)

# Unlike atomic vectors, lists() can contain a mix of objects

y <- list("a", 1L, 1.5, TRUE)
str(y)

# Lists can even contain other lists

z <- list(list(1,2), list(3,4))
str(z)

x1 <- list(c(1, 2), c(3, 4))
x2 <- list(list(1, 2), list(3, 4))
x3 <- list(1, list(2, list(3)))

# Lists have three principles
# 1. Lists have rounded corners. Atomic vectors have square corners
# 2. Children lists are paired with their parent lists
# 3. The orientation of the children lists isn't important

# There are three ways to subset a list

a <- list(a = 1:3, b = "a string", c = pi, d = list(-1, -5))

# 1. [] extracts a sublist. The result will always be a list

str(a[1:2])

str(a[4])

# Vectors can be subset with a logical, integer, or character vector

# 2. [[]] extracts a single component from a list. It removes a level of hierarchy from the list

str(y[[1]])
str(y[[4]])

# 3. $ is a shorthand for extracting named elements of a list. It works similarly to [[]] except that quotes aren't needed

a$a
a[["a"]]

# The distinction between [] and [[]] is important for lists. Because [[]] drills down into the list while [] returns a new smaller list

#################################################################################################################################################################################
# Attributes
#################################################################################################################################################################################
# Any vector can contain arbitrary additional metadata through its attributes. Attributes can be thought of as a named list of vectors that can be attached to any object
# Individual attribute values can be set and gotten with attr() or seen all at once with attributes()

x <- 1:10
attr(x, "greeting")
attr(x, "greeting") <- "Marsey"
attr(x, "farewell") <- "Carp"
attributes(x)

# There are three very important attributes that used to implement fundamental parts of R
# 1. Names are used to name the elements of a vector
# 2. Dimension make a vector behave like a matrix or array
# 3. Class is used to implement the S3 object-oriented system

#################################################################################################################################################################################
# Augmented Vectors
#################################################################################################################################################################################
# Atomic vectors and lists are the building blocks for other important vector types like factors and dates. Augmented vectors have a class, they behave differently to the atomic vector
# The important augmented vectors are factors, date-times, times, and tibbles

# Factors are designed to represent categorical data that can take a fixed set of possible values. Factors are built on top of integers and have a levels attribute

x <- factor(c("ab", "cd", "ab"), levels = c("ab", "cd", "ef"))
typeof(x)
attributes(x)

# Dates in R are numeric vectors that represent the number of days since 1 January 1970

x <- as.Date("1971-01-01")
unclass(x)
typeof(x) # double
attributes(x) # "Date"

# Tibbles are augmented lists. They have three classes: tbl_df, tbl, and data.frame. They have two attributes: (column) names and row.names

tb <- tibble::tibble(x = 1:5, y = 5:1)
typeof(tb) # List
attributes(tb)

# Traditional data frames have a very similar structure
#################################################################################################################################################################################











