####################################################################################################################################################################
# Chapter 3: Using Textual and Binary Formats For Storing Data
####################################################################################################################################################################
# Introduction
####################################################################################################################################################################
# There are a variety of ways that data can be stored including structured text files like CSV or tab delimited, or more complex binary formats
# However, there is an intermediate format that is textual, but not as simple as something like CSV. The format is native to R and is somewhat readable due to its textual nature

# One can create a descriptive representation of an R object by using dput() or dump() functions
# The dump() and dput() functions are useful because the resulting textual format is editable, and in the case of corruption potentially recoverable
# Unlike writing out a table of CSV file, dump() and dput() preserve he metadata (sacrificing some readability), so that another user doesn't have to specify it all over again
# For example, preserving the class of each column of ta table and the levels of a factor variable

# Textual formats work better with version control programs like subversion or git which only track changes meaningfully in text files
# Additionally, textual formats can be longer-lived; since if there is corruption in the file it can be easily fixed by opening the file and looking for the problem in an editor

# Downsides to intermediate textual formats include inefficient space formatting and partial readability 

####################################################################################################################################################################
# Using dput() and dump()
####################################################################################################################################################################
# One way to pass data around is by deparsing the R object with dput() and reading it back in (parsing it) using dget()

y <- data.frame(a = 1, b = "a")
y
dput(y) # structure(list(a = 1, b = "a"), class = "data.frame", row.names = c(NA, -1L))

# Notice that the dput() output is the form of R code and it preserves metadata like the class of the object, the row names, and the column names 
# The output of dput() can also be saved directly to a file

# Sending "dput" output to a file:

dput(y, file = "y.R")

# Reading in dput output from a file

new.y <- dget("y.R")
new.y # Original Table

# Multiple objects can be deparsed at once using the dump function and read back in using source

x <- "kiki"
y <- data.frame(a = 1L, b = "a")

# R objects can be dump() to a file by passing a character vector of their names 

dump(c("x", "y"), file = "Ex2.R")
rm(x, y)

# The inverse of dump() is source()

source("Ex2.R")
str(y) # 'data.frame':	1 obs. of  2 variables: $ a: int 1  $ b: chr " a"
x # "kiki"

####################################################################################################################################################################
# Binary Formats
####################################################################################################################################################################
# The complement to the textual format is the binary format, which is sometimes necessary to use for efficiency purposes, or because there's no useful way to represent data in a textual manner
# Also, with numeric data, one can often lose precision when converting to and from a textual format, so it's better to stick with a binary format

# The key functions for converting R objects into a binary format are save(), save.image(), and serialize(). 
# Individual R objects can be saved to a file using the save() function

a <- data.frame(x = rnorm(100), y = runif(100))
b <- c(3, 4.4, 1 /3)

# Saving "a" and "b" to a file

save(a, b, file = "d11.rda")

# Loading "a" and "b" into a work space

load("d11.rda")

# When there's a lot of objects that need to be saved to a file, all objects can be saved using the save.image() function 

save.image(file = "mydata.RData")

# Loading all objects in this file

load("mydata.RData")

# Notice the .rda extension used when using save() and the .RData extension when using save.image(), however either file extension can be used

# The serialize() function is used to convert individual R objects into a binary format that can be communicated across an arbitrary connection, which may get sent to a file, but could be sent over a network or other connection
# When calling out serialize() on all R objects, the output will be a raw vector coded in hexadecimal format

x <- list(1, 2, 3)
serialize(x, NULL) # [1] 58 0a 00 00 00 03 00 04 02 02 00 03 05 00 00 00 00 05 55 54 46 2d 38 00 00

# The benefit of the serialize() function is that it is the only way to perfectly represent an R object in an exportable format, without losing precision or any metadata

####################################################################################################################################################################
# End Of Chapter 3
####################################################################################################################################################################
