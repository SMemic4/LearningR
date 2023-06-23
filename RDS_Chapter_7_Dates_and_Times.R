####################################################################################################################################################################
# Chapter 7: Dates and Times
####################################################################################################################################################################
# Introduction
####################################################################################################################################################################
# R has developed a special representation for dates and times
# Dates are represented by the Date class and times are represented by the POSIXct or the POSIXit class
# Dates are stored internally as the number of days since 1980-01-01 while times are stored internally as the number of seconds since 1970-01-01 

####################################################################################################################################################################
# Dates in R 
####################################################################################################################################################################
# Dates are represented by the Date class and can be coerced from a character string using the as.Date() function. This is a common way to end up with a Date object in R
# Coercing a "Date" object from a character

x <- as.Date("2023-06-23")
x # "2023-06-23"

# The internal representation of a Date object can be determined by using the unclass() function

unclass(x) # 19531
unclass(as.Date("2023-06-22")) # 19530

####################################################################################################################################################################
# Times in R 
####################################################################################################################################################################
# Times are represented by the POSIXct class. POSIXct is a very large integer used to represent time
# It is useful class when wanting to store times in a data frame
# POSIXIt is a list underneath and it stores a bunch of other useful information like day of the week, day of the year, month, and day of the month
# There are a number of generic functions that work on dates and times to help extract pieces of dates and or times
# weekdays() gives the day of the week
# months() gives the month name
# quarters() gives the quarter number (Q1, Q2, Q3, or Q4)
# Time can be coerced from a character string using the as.POSIXit or as.POSIXct function

x <- Sys.time()
x # "2023-06-23 13:14:28 EDT"
class(x) # "POSIXct" "POSIXt" 

# The POSIXit objects contains some useful metadata

p <- as.POSIXlt(x)
names(unclass(p)) # "sec"    "min"    "hour"   "mday"   "mon"    "year"   "wday"   "yday"   "isdst"  "zone"   "gmtoff"
p$wday # 5

# PSIXct format can also be used

x <- Sys.time()
x # "2023-06-23 13:19:49 EDT"
unclass(x) # 1687540790

# However the POSIXct doesn't have the additional meta data as POSIXit

x$sec # Error in x$sec : $ operator is invalid for atomic vectors

# But it can be coerced 

p <- as.POSIXlt(x)
p$sec # 49.99462

# Finally, there is the strptime() function in case dates are written in a different format
# strptime() takes a character vector that has dates and times and converts them into POSIXit object

datestring <- c("January 10, 2012 10:40", "December 9, 2011 9:10")
x
x <- strptime(datestring, "%B %d, %Y %H:%M" )
x # "2012-01-10 10:40:00 EST" "2011-12-09 09:10:00 EST"
class(x) # "POSIXlt" "POSIXt" 

# The weird-looking symbols that start with the % symbol are the formatting strings for dates and times, for more details examine ?strptime for details

####################################################################################################################################################################
# Operations on Dates and Times
####################################################################################################################################################################
# Mathematical operations can be used on dates and times (Specifically + and -), and comparisons as well (==, <=)

x <- as.Date("2012-01-01")
y <- strptime("9 Jan 2011 11:34:21", "%d %b %Y %H:%M:%S")
x - y # Error Incompatible methods ("-.Date", "-.POSIXt") for "-" 
x <- as.POSIXlt(x)
x- y # Time difference of 356.3095 days
 
# Date and Time classes keep track of all the finer facets about dates and times, like leap years. leap seconds, daylight savings, and time zones
# Here's, an example where a leap year gets involved

x <- as.Date("2012-03-01")
y <- as.Date("2012-02-28")
x-y # Time difference of 2 days

####################################################################################################################################################################
# End of Chapter 7
####################################################################################################################################################################
