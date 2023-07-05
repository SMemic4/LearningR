####################################################################################################################################################################
# Chapter 12: Loop Functions
####################################################################################################################################################################
# Looping on the Command Line
####################################################################################################################################################################
# Writing for and while loops is useful when programming but not particularly easy when working interactively on the command line 
# R has some function which implement looping in a compact form to make life easier: 
# • lapply(): Loop over a list and evaluate a function on each element
# • sapply(): Same as lapply but try to simplify the result
# • apply(): Apply a function over the margins of an array
# • tapply(): Apply a function over subsets of a vector
# • mapply(): Multivariate version of lapply

# An auxiliary function split() is also useful, particularly in conjunction with lapply 

####################################################################################################################################################################
# lapply()
####################################################################################################################################################################
# The lapply() function does the following simple series of operations:
# 1. It loops over a list, iterating over each element in that list
# 2. It applies a function to each element of the list (a function that is specified)
# 3. And returns a list (the l is for "list")
# The function takes three arguments: 1. A list X, 2. A function or name of a function, 3. Other arguments via its ... argument
# If X is not a list it will be coerced to a list using as.list()
# The body of the lapply() function can be seen here:

lapply # function (X, FUN, ...)

# Note that the actual looping is done internally in C code for efficiency reasons
# It is important to remember that lapply() always returns a list, regardless of the class of the input
# Here's an example of applying the mean() function to all elements of a list. If the original list has names, the names will be preserved in the output

x <- list(a = 1:5, b = rnorm(10))
x
lapply(x, mean) # $a 3 $b 0.4135898

# Notice that the mean(0 function is being passed as an argument to the lapply() function
# Function in R can be used this way and can be passed back and forth as arguments just like any other object
# When passing a function to another function, the open and closed parentheses do not be included 
# Another example of using lapply(): 

x <- list(a = 1:4, b = rnorm(10), c = rnorm(20, 1), d = rnorm(100, 5))
x
lapply(x, mean) # $a 2.5 $b 0.05241364 $c 0.9036651 $d 5.069851

# lapply() can be used to evaluate a function multiple times each with a different argument
# Below, is an example where runif() function (generates uniformly distributed random variables) four times each time generating a different number of random numbers
x <- 1:4
x
lapply(x, runif)

# When passing a function to lapply(), lapply() takes elements of the list and passes them as the first argument of the function that is being applied
# In the first argument of runif() is n, so the elements of the sequence 1:4 all got passed to the n argument of runif()
# Functions that are passed to lapply() may have other arguments. 
# For example, the runif() function has a min and max argument too. In the example above, the default values for min and max were used. But different values can be applied in the lapply()
# This is due to the ... argument in lapply() becomes important
# Any arguments placed in the ... argument will get passed down to the function being applied to the elements of the list
# In this example, the min = 0 and max = 10 arguments are passed down to runif() every time it is called

x <- 1:4
x
lapply(x, runif, min = 0, max = 10) # Instead of the random numbers being between 0 and 1 (the default), the are all between 0 and 10

# The lapply() function and its friends make heavy use of anonymous functions
# Anonymous functions are members of project mayhem and they have no name
# These are functions that are generated "on the fly" as they are being used lapply(). Once the call to lapply() is finished, the function disappears and does not appear in the workspace
# Creating a list that contains two matrices

x <- list(a = matrix(1:4, 2, 2), b = matrix(1:6, 3, 2))
x

# Suppose that someone wanted to extract the first column of each matrix in the list. An anonymous function for extracting the first column of each matrix could be written

lapply(x, function(elt) { elt[,1] }) # $a 1 2 $b 1 2 3

# Notice, that the function() definition is put right in the call to apply(). This is perfectly legal and acceptable
# An arbitrarily complicated function can be defined inside lapply(), however if it is sufficiently complicated it's probably better to define the function outside of lapply()
# Another way to write the above code:

f <- function(elt){
  elt[, 1]
}
lapply(x, f) # $a 1 2 $b 1 2 3

# Now that the function is no longer anonymous, it's name is f
# Whether an anonymous or defined function is used depends on context. If the function is going to be used in other parts of code, it may be beneficial to define it separately 

####################################################################################################################################################################
# sapply()
####################################################################################################################################################################
# The sapply() function behaves similarly to lapply(); the only real difference is in the return value
# sapply() will try to simplify the result of lapply() if possible
# Essentially, sapply() calls lapply() on its input and then applies the following algorithm
# If the result is a list where every element is length 1, then a vector is returned
# If the result is a list where every element is a vector of the same length (> 1), a matrix is returned
# If it can't figure things out, a list is returned
# Here are the results of calling sapply()

x <- list(a = 1:4, b = rnorm(10), c = rnorm(20, 1), d = rnorm(100, 5))
x
lapply(x, mean) # $a 2.5 $b -0.5624536 $c 1.181478 $d 5.002955 

# Notice that lapply() returns a list(as usual), but that each element of the list has length 1. 
# Here the result of calling sapply() on the same list 

sapply(x, mean) # a 2.5000000 b -0.5624536 c 1.1814784 d 5.0029547 

# because the result of lapply() was a list where each element had length 1, sapply() collapsed the output into a numeric vector, which is often more useful than a list

####################################################################################################################################################################
# split()
####################################################################################################################################################################
# The split() function takes a vector or other objects and splits it into groups determined by a factor or list of factors
# The arguments to split() are:

str(split) # function (x, f, drop = FALSE, ...) 

# x is a vector (or list) or data frame
# f is a factor (or coerced to one) or a list of factors
# drop indicates whether empty factor levels should be dropped 
# The combination of split() and a function like lapply() or sapply() is a common paradigm in R
# The basic idea, is that a data structure and split into subsets defined by another variable, and a function is applied over those subsets
# The results of applying the function over the subsets are then collated and returned as an object
# This sequence of operations is sometimes referred to as "map-reduce" in other contexts
# Here some data is simulated and split according to a factor variable

x <- c(rnorm(10), runif(10), rnorm(10, 1))
f <- gl(3, 10)
x
f
split(x, f)

# A common idiom is split followed by an lapply

lapply(split(x, f), mean) # $`1` 0.370833 $`2` 0.2804497 $`3` 0.1928643

####################################################################################################################################################################
# Splitting a Data Frame
####################################################################################################################################################################
library(datasets)
head(airquality)

# The air quality data frame can be split by the Month variable to separate sub-data frames for each month 

s <- split(airquality, airquality$Month)
s
str(s) # List of 5

# Then each of the column means for Ozone, Solar.R and Wind can be taken for each sub-data frame

lapply(s, function(x) {colMeans(x[, c("Ozone", "Solar.R", "Wind")])})

# Using sapply() might be better for a more readable output: 

sapply(s, function(x) {colMeans(x[, c("Ozone", "Solar.R", "Wind")])})

# However, there are NAs in the data so the mean of these variables cannot simply just be taken
# However, the colMeans function can be provided the na.rm = TRUE function to remove the NAs before computing the mean

sapply(s, function(x) {colMeans(x[, c("Ozone", "Solar.R", "Wind")], na.rm = TRUE)})

# Occasionally, an R object may be split up according to levels defined in more than one variable
# This can be done by creating an interaction of the variables with the interaction() function

x <- rnorm(10)
f1 <- gl(2, 5)
f2 <- gl(5, 2)
f1
f2
interaction(f1, f2) # Creates an interaction of two factors

# With multiple factors and many levels, creating an interaction can result in many levels that are empty.

str(split(x, list(f1, f2))) # List of 10

# Notice that there are 4 categories with no data. Empty levels can be dropped when calling the split() function:

str(split(x, list(f1, f2), drop = TRUE)) # List of 6

####################################################################################################################################################################
# tapply()
####################################################################################################################################################################
# The apply() function is used to evaluate a function (often an anonymous one) over the margins of an array
# It is most often used to apply a function to the rows or columns of a matrix (which is a 2 dimensional array)
# However, it can be used with general arrays, for example, to take the average of an array of matrices 
# Using apply() is not really faster than writing a loop but it works in one line and is highly compact

str(apply) # function (X, MARGIN, FUN, ..., simplify = TRUE) 

# The arguments to apply() are:
#  X is an array
#  MARGIN is an integer vector indicating which margins should be “retained”.
#  FUN is a function to be applied
#  ... is for other arguments to be passed to FUN

# Here a 20 by 10 matrix of Normal random numbers are created. Afterwards the mean of each column is computed 

x <- matrix(rnorm(200), 20, 10)
x
apply(x, 2, mean) #  0.22676838  0.02042738 -0.40917072  0.03813363 -0.51618257  0.07410771 -0.10560975  0.29675266 -0.13286302 -0.13705602

# The sum of each row can be computed 

apply(x, 1, sum) # -2.04710929 -2.75999340 -4.38225122  1.90656787  3.52420613 -3.44093586  0.10979091  0.37471904 -1.28442083  1.81000239 -1.71848956  0.02521046  0.92440352  3.29409663  0.41002677 [16]  1.14737055 -8.17710844 -1.46341931 -0.73121912 -0.41529346

# Note that in both calls to apply(), the return value was a vector of numbers
# Additionally, the second argument is either a 1 or a 2, depending on whether statistics are wanted on rows or columns. What does the second argument apply to apply()
# The MARGIN argument essentially indicates to apply() which dimension of the array to preserve or retain. So when taking the mean of each column, it is specified as:

apply(x, 2, mean)

# Because the first dimension (the rows) are collapsed by taking the mean, and the number of columns is to be preserved
# Similarly when wanting the sum of rows:

apply(x, 1, sum)

# This collapses the columns (The second dimension) and preserves the number of rows (the first dimension)

####################################################################################################################################################################
# Col/Row Sums and Means
####################################################################################################################################################################
# For the special case of column/row sums and column/row means of matrices, there are useful shortcuts
# rowSums = apply(x, 1, sum)
# rowMeans = apply(x, 1, mean)
# colSums = apply(x, 2, sum)
# colMeans = apply(x, 2, mean)
# The shortcut functions are heavily optimized and are much faster, but this won't be noticed unless working with a large matrix
# Another nice aspect of these functions is that they are a bit more descriptive
# It's arguably more clear to write colMeans(x) in code than apply(x,2, mean)

####################################################################################################################################################################
# Other Ways to Apply
####################################################################################################################################################################
# It's possible to take more than sum and means with the apply() function
# For example, the quantiles of the rows of a matrix can be computed using the quantile() function

x <- matrix(rnorm(200), 20, 10)
apply(x, 1, quantile, probs = c(0.25, 0.75))

# For a higher dimensional example, create an array of 2 by 2 by 10 and compute the average of the matrices in the array 

a <- array(rnorm(2 * 2 * 10), c(2, 2, 10))
apply(a, c(1, 2), mean)

# In the call to apply(), the MARGIN argument indicates to preserve the first and second dimensions and to collapse the thrid dimension by taking the mean
# There is a faster way to do this specific operation via the colMeans() function

rowMeans(a, dims = 2)

# rowMeans() is faster for larger arrays

####################################################################################################################################################################
# mapply()
####################################################################################################################################################################
# The mapply() function is a multivariate apply of sort which applies a function in parallel over a set of arguments
# Recall that lapply() and friends only iterate over a single R object
# To iterate over multiple R objects in parallel use mapply()

str(mapply) # function (FUN, ..., MoreArgs = NULL, SIMPLIFY = TRUE, USE.NAMES = TRUE)  

# The arguments to mapply() are:
# FUN is a function to apply
# ... contains R objects to apply over
# MoreArgs is a list of other arguments to FUN.
# SIMPLIFY indicates whether the result should be simplified

# The mapply() function has a different argument order from lapply() because the function to apply comes first rather than the object to iterate over
# The R objects over the function is applied to are given in the ... argument because it can apply over an arbitrary number of R objects 
# For example it is tedious to type the following:

list(rep(1, 4), rep(2, 3), rep(3, 2), rep(4, 1))

# With mapply(), the following code can be written:

mapply(rep, 1:4, 4:1)

# This passes the sequence 1:4 to the first argument of rep() and the sequence 4:1 to the second argument.
# An example for simulating random Normal variables

noise <- function(n, mean, sd) {
   rnorm(n, mean, sd)
}

# Simulate 5 random numbers:

noise(5, 1, 2)

# This only simulates 1 set of numbers, not 5:

noise(1:5, 1:5, 2)
