####################################################################################################################################################################
# Chapter 2: Getting Data in and Out of R
####################################################################################################################################################################
# Reading and Writing Data
####################################################################################################################################################################
# There are a few principal functions for reading data into R
# read.table, read.csv for reading tabular data
# readLines, for reading lines of a text file
# source for reading in R code files (inverse of dump)
# dget, for reading in R code files (inverse of dput)
# load, for reading in saved work spaces
# unserialize, for reading single R objects in binary form 

# There are many R packages that have been developed to read in all kinds of other datasets

# There are analogous functions for writing data to files
# write.tables(), for writing tabular data to text files (CSV) or connections
# writeLines for writing character data line by line to a file or connection
# dump, for dump a textual representation of multiple R objects
# dput, for outputting a textual representation of an R object
# save, for saving an arbitrary number off R objects in binary format (possibly compressed) to a file
# serialize, for converting an R object into a binary format for outputting to a connection (or file)

####################################################################################################################################################################
# Reading Data Files with read.table()
####################################################################################################################################################################
# The read.table() function is one of the most commonly used functions for reading data
# read.table() has a few important functions
# file, the name of a file or a connection
# header, a logical indicating if the file has a head line
# sep, a string indicating how the columns are separated
# colClasses, a character vector indicating the class of each column in the dataset
# nrows, the number of rows in the dataset. By default read.table() reads an entire file
# comment.char, a character string indicating the comment character. This defaults to # If there are no commented lines in the file, it's worth setting this to be an empty string
# skip, the number of lines to skip from the beginning 
# stringsAsFactors, should character variables be coded as factors. The default is TRUE

data <- read.table("Ex1.txt")

# In this case, R will automatically,
# Skip lines that begin with a #
# Figure out how many rows there are
# Figure out the type of variable in each column of the table
# Providing additional details to R makes it run faster and more efficiently
# The read.csv() function is identical to read.table except some of the defaults are set differently (like the sep argument)

####################################################################################################################################################################
# Reading in Larger Datasets with read.table
####################################################################################################################################################################
# With much larger datasets, there are a few things that can be done to make importing easier and prevent R from failing
# Make a rough calculation of the memory required to store the dataset. If the dataset is larger than the amount of RAM on the computer, it probably won't work
# Set comment.char = "" if there are no commented lines in the file
# Use the colClasses argument, Specifying this option instead of using default can make read.table() run much faster (often twice as fast). If order to use this option the class of each column in the data frame must be known. 
# If all the columns are "numeric" for example setting colClasses = "numeric" is a quick way to do this
# Additionally the following can be done:

initial <- read.table("datatable.txt", nrows)
classes <- sapply(initial, class)
tabAll <- read.table(datatable.txt, colClasses = classes)

# Setnrows, this doesn't make R run faster but helps with memory usage

####################################################################################################################################################################
# Calculating Memory Requirements for R Objects
####################################################################################################################################################################
# Because R stores all of its objects physical memory, it is important to be cognizant of how much memory is being used by all of the data objects residing in the work space
# One situation where it's particularly important to understand memory requirements is when reading in a new data set into R
# For example, suppose there's a data frame with 1,500,000 rows and 120 columns all of which are numeric data, how much memory is required to store all of this data?
# Given that most modern computers double precision floating point numbers are stored using 64 bits of memory, or 8 bytes the following calculation can be done:
# 1,500,000 rows * 120 cols * 8 bytes/numeric = 1,440,000,000 bytes = 1,4440,000,000 bytes / 2*20 bytes/MB = 1,373.29 MB = 1.34 GB
# So the dataset would require about 1.34 GB of RAM. Most computers have this much but other things must be considered:
# What other programs might be running on the computer using up RAM
# What other R objects might already be taking up RAM in the work space

# Reading in large dataset for which there is not enough RAM on the computer will freeze up the computer or the R session

####################################################################################################################################################################
# Using the readr Package
####################################################################################################################################################################
# The readr package is a package that deals with reading in large flat files quickly
# The package provides replacements for functions like read.table() and read.csv()
# The analogous functions in readr are read_table() and read_csv()
# These functions are often much faster than their base R analogues and provides a few base features such as progress meters

# read_table() and read_csv() can be used pretty much anywhere read.table() and read.csv() are used
# Additionally, if non-fatal problems occur while reading the data, a warning will appear indicating which rows/observations trigged the warning




