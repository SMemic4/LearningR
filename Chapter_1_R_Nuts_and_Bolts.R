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








