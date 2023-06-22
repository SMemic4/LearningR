####################################################################################################################################################################
# Chapter 1: R Nuts and Bolts
####################################################################################################################################################################
# Entering Input
####################################################################################################################################################################
# The <- symbol is the assignment operator

x <- 1
x # 1
print(x) # 1
 
####################################################################################################################################################################
# Evaluation
####################################################################################################################################################################
# When a complete expression is entered at the prompt, it is evaluated and the result of the evaluated expression is returned

x <- 6
x # [1] 6
print(x) # [1] 6

# The [1] shown in the output indicates that X is a vector and 5 is its first element

x <- 10:30
x # [1] 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30

# The square numbers in the square brackets are not part of the vector itself, they are merely part of the printed output
# It's important to consider that the actual R object and the manner which R object is printed to the console
# THe console may provide additional details
# Note that the : operator is used to create integer sequences

####################################################################################################################################################################
# R Objects
####################################################################################################################################################################
# R has five basic or "atomic" classes of objects
# 1. Character
# 2. Numeric (real numbers)
# 3. Integer
# 4. Complex
# 5. Logical (True/False)

# The most basic type of R object is a vector. Empty vectors can be created with the vector() function
# There is only one rule about vectors, which is that a vector can only contain objects of the same class
# However there is an exception which is a list
# A list is represented as vector but can contain objects of different classes

####################################################################################################################################################################
# Numbers
####################################################################################################################################################################
# Numbers in R are generally treated as numeric objects (double precision real numbers)
# For example 1 can be represented as 1.00 behind the scenes
# To coerce an number in an integer, it must be specified with the L suffix

x <- 1L
y <- 1
typeof(x) # "integer"
typeof(y) # "double"

# There is also a special number Inf which represents infinity

x <- Inf
x # Inf

# This allows for the representation of entities like 1/0. This way Inf can be used in ordinary calculations
# The value NaN represents an undefined value (Not a number) it can be thought of as a missing value

####################################################################################################################################################################
# Attributes 
####################################################################################################################################################################
# R objects can have attributes, which are metadata for the object
# This metadata can be used to describe additional details about the object
# Column names on a data frame can contain metadata providing more info about what the column shows

# Examples of R object attributes:
# names, dimnames
# dimensions (matrices, arrays)
# class
# length
# user-defined attributes/metadata

# Attributes of an object can be accessed using the attributes() function
# Not all R objects contain attributes, in which case attributes() function returns NULL

####################################################################################################################################################################
# Creating Vectors
####################################################################################################################################################################
# The c(0 function can be used to create vectors objects by concatenating them together

x <- c(0.5, 0.6) # numeric
x <- c(TRUE, FALSE) # logical
x <- c(T, F) # logical
x <- c("a", "b", "c") # character
x <- 9:29 # integer
x <- c(1+0i, 2+4i) # complex

# Note that in the example above T and F are short hand ways to specify TRUE and FALSE
# Vector() can also be used to initialize vectors

x <- vector("integer", length = 10)
x #  0 0 0 0 0 0 0 0 0 0

####################################################################################################################################################################
# Mixing Objects
####################################################################################################################################################################
# There are occasion when different classes of R objects get mixed together, however when this happens coercion occurs

y <- c(1.7, "a") # character
y <- c(TRUE, 2) # numeric
y <- c("a", TRUE) # character

# When elements are different kinds are mixed within a vector, coercion occurs so that every element in the vector is of the same class
# This is an example of implicit coercion
# When mixing characters and integers all of the objects will be converted to characters since they are the less complex type of object

####################################################################################################################################################################
# Explicit Coercion
####################################################################################################################################################################
# Objects can be explicitly coerced from one class to another using the as.* functions

x <- 0:6L
typeof(x) # Integer
as.logical(x) # FALSE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE
as.double(x) # 0 1 2 3 4 5 6
as.character(x) # "0" "1" "2" "3" "4" "5" "6"

# If R doesn't know how to coerce an object this results in NAs being produced

x <- c("a", "b", "c")
x <- as.numeric(x)
x # NA NA NA

####################################################################################################################################################################
# Matrices
####################################################################################################################################################################
# Matrices are vectors with a dimensions attribute. The dimension attribute itself is an integer vector of length 2 (numbers of rows, number of columns)

m <- matrix(nrow = 4, ncol = 3)
m

# The dim function returns a vector of the dimensions of the matrix. The vector is is rows by columns

dim(m) # 4 3
attributes(m) # $dim [1] 4 3

# Matrices are constructed column-wise, so entries can be thought of starting in the "upper left" corner and running down the columns

m <- matrix(1:12, nrow = 4, ncol = 3)
m

# Matrices can also be created directly by adding a dimension attribute to a vector

m <- 1:10
m
dim(m) <- c(2,5)
m

####################################################################################################################################################################
# Lists
####################################################################################################################################################################
# Lists are a special type of vector that can contain elements of different classes 
# Lists in combination with varioous apply functions make for a powerful combination
# Lists can be explicitly created using the list() function which takes an arbitrary number of arguments

x <- list(1, TRUE, "a", 1 + 4i)
x

# An empty list of a specified length can be created with the vector function()

x <- vector("list", length = 4)
x

####################################################################################################################################################################
# Factors
####################################################################################################################################################################
# Factors are used to represent categorical data and can be unordered or ordered
# A factor can be thought of as an integer vector where each integer has a label 
# Factors are important in statistical modeling and are treated specially by modelling functions like lm() and glm()
# Using factors with labels is better than using integers because factors are self-describing
# Factors are created with the factor() function

x <- factor(c("Male", "Male", "Female", "Female", "Female"))
x # [1] Male   Male   Female Female Female Levels: Female Male

table(x) # Table of a vector contain a factor variable will provide the counts

# To see the underlying representation of a factor

unclass(x) # 2 2 1 1 1 attr(,"levels") [1] "Female" "Male" 

# Often times factors will be automatically created for when reading a dataset in using a function like read.table()
# The order of the levels a factor can be set using the levels argument to factor()
# This is important because the first level is used as the baseline in linear modeling 

x <- factor(c("male", "female", "male", "female", "female"), levels = c("male", "female"))
x # male   female male   female female 

####################################################################################################################################################################
# Missing Values
####################################################################################################################################################################
# Missing values are denoted by NA or NaN for q undefined mathematical operations
# is.na() is a function that test objects if they are NA. It returns a vector of TRUE and FALSE
# is.nan() is used to test for NaN, it returns a vector of TRUE and FALSES
# NA values have a class also, so there are integer NAs, character NA, etc
# A NaN value is also NA but the converse is not true

x <- c(1, 2, NA, 10, 4)
is.na(x) # FALSE FALSE  TRUE FALSE FALSE
is.nan(x) # FALSE FALSE FALSE FALSE FALSE

x <- c(1, 2, NA, NaN, 10, 4)
is.na(x) # FALSE FALSE  TRUE  TRUE FALSE FALSE
is.nan(x) # FALSE FALSE FALSE  TRUE FALSE FALSE

####################################################################################################################################################################
# Data Frames
####################################################################################################################################################################











