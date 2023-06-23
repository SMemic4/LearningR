####################################################################################################################################################################
# Chapter 6: Vectorized Operations
####################################################################################################################################################################
# Introduction
####################################################################################################################################################################
# Many operations in R are vectorized, meaning that operations occur in parallel in certain R objects
# This allows for code to be written that is efficient, concise, and easier to read than in non-vectorized languages
# The simplest example is when adding two vectors together

x <- 1:4
y <- 6:9
z <- x + y
z #  7  9 11 13

# Without vectorization iteration would have to be used

z <- numeric(length(x))
for(i in seq_along(x)) {
    z <- x[i] + y[i]
}
z # 13

# Another operation that can be done in a vectorized manner is logical comparisons
# Suppose one wanted to know which elements of a vector were greater than 2

x <- 1:4
x
x > 2 # FALSE FALSE  TRUE  TRUE

# Other vectorized operations:

x >= 2 # FALSE  TRUE  TRUE  TRUE
x < 3 # TRUE  TRUE FALSE FALSE
y == 8 # FALSE FALSE  TRUE FALSE

# Notice that these logical operations return a logical vector of TRUE and FALSE
# Additionally, subtraction, multiplication, and division are also vectorized

x - y # -5 -5 -5 -5
x * y # 6 14 24 36
x / y # 0.1666667 0.2857143 0.3750000 0.4444444

####################################################################################################################################################################
# Vectorized Matrix Operations
####################################################################################################################################################################
# Matrix operations are also vectorized, making for nicely compact notation, allowing for element by element operations without having to loop over every element

x <- matrix(1:4, 2, 2)
y <- matrix(rep(10, 4), 2, 2)
x
y

# Element-wise Multiplication:

x * y

# Element-wise Division:

x / y

####################################################################################################################################################################
# End of Chapter 6
####################################################################################################################################################################


