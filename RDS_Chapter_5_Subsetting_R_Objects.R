####################################################################################################################################################################
# Chapter 5: Subsetting R Objects
####################################################################################################################################################################
# Introduction
####################################################################################################################################################################
# There are three operators that can be used to extract subsets of R objects:
# The [] operator always returns an object of the same class as the original. It can be used to select multiple elements of an object
# The [[]] operator is used to extract elements of a list or a data frame. It can only be used to extract a single element and the class of the return object will not necessarily be a list or data frame
# The $ operator is used to extract elements of a list or data frame by literal name. It's semantics are similar to that of [[]]

####################################################################################################################################################################
# Subsetting a Vector
####################################################################################################################################################################
# Vectors are basic R objects in R and can be subsetted using the [] operator

x <- c("a", "b", "c", "c", "d", "a")

# Extracting the first element:

x[1] # "a"

# Extracting the second element:

x[2] # "b"

# The [] operator can be used to extract multiple elements of a vector by passing the operator an integer sequence
# Extracting the first four elements of the vector

x[1:4] # "a" "b" "c" "c"

# The sequence does not have to be in order, any arbitrary integer vector values can be specified

x[c(1, 4, 2)] # "a" "c" "b"

# A logical sequence can be passed to the [] operator to extract elements of a vector that satisfy a given condition
# For example, extracting the elements of x that come lexicographically after the letter "a"

u <- x > "a"
u # FALSE  TRUE  TRUE  TRUE  TRUE FALSE
x[x > "a"] # "b" "c" "c" "d"
x[u] # "b" "c" "c" "d"

####################################################################################################################################################################
# Subsetting a Matrix
####################################################################################################################################################################
# Matrices can be subsetted in the usual way with (i,j) type indices

x <- matrix(1:6, 2, 3)
x

# The [1,2] and [2,1] elements of the matrix can be accessed using the appropriate indices (Remember matrices are created rows than columns)

x[1,2] # 3
x[2,1] # 1

# Indices can also be missing. This behavior can be used to access entire rows or columns 

x[1, ] # 1, 3, 5
x[ , 2] # 3 4

####################################################################################################################################################################
# Dropping Matrix Dimensions
####################################################################################################################################################################
# By default, when a single element of a matrix is retrieved, it is returned as a vector of length 1 rather than a 1 by 1 matrix
# Often times this is what is wanted, but this behavior can be changed by setting drop = FALSE

x <- matrix(1:6, 2, 3)
x
x[1, 2] # 3
x[1, 2, drop = FALSE] # Returns a 1 by 1 matrix containing 3

# Similarly, when extract a single row or column of a matrix, R by default drops the dimension of length 1, so instead of returning a matrix it returns a vector of the length of the values
# This behavior can be circumvented by using the drop = FALSE option

x <- matrix(1:6, 2, 3)
x
x[1,] # 1, 3 , 5 
x[1, , drop = FALSE] # Returns a matrix of the first row and three columns containing the values of 1,3,5

# Be careful of R automatic dropping of dimensions, it is useful during interactive work but can cause problems when writing programs or functions

####################################################################################################################################################################
# Subsetting Lists
####################################################################################################################################################################
# Lists in R can be subsetted using all three of the operators mentioned above, and all three are used for different purposes

x <- list(kiki = 1:4, type = "cat")
x

# The [[]] operator can be used to extract single elements from a list
# Here it is used to extract the first element of the list

x[[1]] # 1,2,3,4 

# The [[]] operator can also used named indices so the extract ordering of the list does not need to be remembered 

x[["type"]] # "1 2 3 4 "cat

# The $ operator can also be used to extract elements by name (Notice how quotes are not needed)

x$type # "cat

# One thing that differentiates the [[]] operator from the $ is that the [[]] operator can be used with computed indices
# The $ operator can only be used with literal names

x <- list(num = 1:4, bar = 0.5, cat = "kiki")
x
name <- "num"

# Computed index for "num"

x[[name]] # 1 2 3 4 

# However the element "name" doesn't exist (but no error occurs)

x$name # NULL

# But the element num does exist

x$num # 1 2 3 4 
 
####################################################################################################################################################################
# Subsetting Nested Elements of a List
####################################################################################################################################################################
# The [[]] operator can take an integer sequence to extract a nested element of a list 

x <- list(a = list(10, 12, 14), b = c(3.14, 2.81))
x

# Getting the 3rd element of the 1st element in the list:

x[[c(1, 3)]] # 14

# Same as the above

x[[1]][[3]] # 14

# The 1st element of the 2nd element

x[[c(2, 1)]] # 3.14
x[[2]][[1]] # 3.14

####################################################################################################################################################################
# Extracting Multiple Elements of a List
####################################################################################################################################################################
# The [] operator can be used o tract multiple elements from a list
# For example, to extract the first and third elements of a list, the following would be done

x <- list(keks = 1:4, bar = 0.6, baz = "hello")
x

x[c(1,3)] # $keks $baz

# Note that x[c(1,3)] is not the same as x[[c(1,3)]]

x[[c(1,3)]] # 3

# Remember that the [] operator always returns an object of the same class as the original
# Since the original object was a list, the [] operator returns a list. In the code above, a list is returned with the two elements (the first and third)

####################################################################################################################################################################
# Partial Matching
####################################################################################################################################################################
# partial matching of names is allowed with [[]] and $
# This is useful during interactive work, if the object that's being worked with has long element names
# Those names will be abbreviated and R will determine which elements are being referred to

x <- list(aardvark = 1:5)
x

x[["a"]] # NULL
x[["a", exact = FALSE]] # 1 2 3 4 5

# In general, this is fine for interactive work, but don't resort to partial matching when writing scripts, functions or programs

####################################################################################################################################################################
# Removing NA Values
####################################################################################################################################################################
# A common task in data analysis is removing missing values (NAs)

x <- c(1, 2, NA, 4, NA, 5)
bad <- is.na(x)
bad # FALSE FALSE  TRUE FALSE  TRUE FALSE
x[!bad] # 1 2 4 5 

# What if there are multiple R objects and one wants to take the subset with no missing value in any of those objects?

x <- c(1, 2, NA, 4, NA, 5)
y <- c("a", "b", NA, "d", NA, "f")
good <- complete.cases(x, y)
good # TRUE TRUE FALSE TRUE FALSE TRUE
x[good] # 1 2 4 5 
y[good] # "a" "b" "d" "f"

# complete.cases returns a logical vector indicating which cases are complete (have no missing values)
# complete.cases() also works on data frames

head(airquality)
good <- complete.cases(airquality) 
head(airquality[good, ])

####################################################################################################################################################################
# End of Chapter 5
####################################################################################################################################################################
