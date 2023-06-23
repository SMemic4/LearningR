####################################################################################################################################################################
# Chapter 4: Interfaces to the Outside World
####################################################################################################################################################################
# Introduction
####################################################################################################################################################################
# Data is read in using connection interfaces. Connections can be made to files (most common) or to other things
# file, opens a connection to a file
# gzfile, opens a connection to a file compressed with gzip
# bzfile, opens a connection to a file compressed with bzip2
# url, opens a connection to a webpage

# Connections are powerful tools that allow for the navigation of files and other eternal objects
# Connections can be thought of as a translator that allows for one to talk to objects that are outside of R
# These outside objects could be anything from a data base, a simple text file, or a web service API
# Connections allow R functions to talk to all these different external objects without writing a custom code for each object 

####################################################################################################################################################################
# File Connections
####################################################################################################################################################################
# Connections to text files can be created with the file() function

str(file) # function (description = "", open = "", blocking = TRUE, encoding = getOption("encoding"), raw = FALSE, method = getOption("url.method", "default"))  

# The file() function has a number of arguments that are common to many other connection functions 
# description is the name of the file
# open is a code indicating what mode the file should be opened in 

# The open argument allows for the following options:
# "r" - open file in read only mode
# "w" = open a file for writing (and initializing a new file)
# "a" - open a file for appending
# "rb", "wb", "ab" - reading, writing, or appending in binary mode

# In practice, the connection interface isn't need directly as many function for reading and writing data just deal with it in the background 
# For example, to explicitly use connections o read a CSV file in R:

# Create a connection "kiki.txt"

con <- file("kiki.txt")

# Open connection to "kiki.txt" in read-only mode:

open(con, "r")

# Read from the connection:

data <- read.csv(con)

# Close the connection:

close(con)

# All of the above is the same as:

data <- read.csv("kiki.txt")

# In the background, read.csv() opens a connection to the file kiki.txt, reads from it, and closes the connection when its done
# The example above shows the basic approach to using connections. Connections must be opened, then they are read from or written to, and then closed

####################################################################################################################################################################
# Reading Lines of a Text File
####################################################################################################################################################################
# Text files can be read line by line using the readLines() function
# This function is useful for reading text files that may be unstructured or contain non-standard data

con <- gzfile("words.gz")
x <- readLines(con, 10) # [1] "1080" "10-point" "10th" "11-point" "12-point" "16-point" [7] "18-point" "1st" "2" "20-point"

# For more structured text data like CSV files or tab-delimited files, there are other functions like read.csv() or read.table()
# The above example used gzfile() function which is used to create a connection to files compressed using the gzip algorithm
# This approach is useful because it allows for a file to be read without having to uncompress the file first
# There is a complementary function writeLines() that takes a character vector and writes each element of the vector one line at a time to a text file

####################################################################################################################################################################
# Reading From a URL Connection
####################################################################################################################################################################
# The readLines() function can be useful for reading in lines of webpages, since webpages are basically text files stored on a remote server
# However, R needs to negotiate the communication between the computer and web server.
# This can be done with the url() function

# Opening a URL connection for reading

con <- url("http://www.jhsph.edu", "r")

# Reading the web page

x <- readLines(con)

# Printing out the first few lines

head(x)

####################################################################################################################################################################
# End of Cahpter 4
####################################################################################################################################################################
