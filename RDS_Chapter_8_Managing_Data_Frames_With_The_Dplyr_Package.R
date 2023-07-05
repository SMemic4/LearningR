####################################################################################################################################################################
# Chapter 7: Managing Data Frames with the dplyr package
####################################################################################################################################################################
# Data Frames
####################################################################################################################################################################
# The data frame is a key structure in statistics and in R
# The basic structure of a data frame is that there is one observation per row and each column represents a variable, a measurement, feature, or characteristic of the observation
# The dplyr package is desgined to mitigate a lot of problems when it comes to filtering, ordering, and extracting from data frames

####################################################################################################################################################################
# The dplyr Package
####################################################################################################################################################################
# One important contribution of the dplyr package is that it provides a "grammar" for data manipulation and for operating on data frames

####################################################################################################################################################################
# dplyr Grammar 
####################################################################################################################################################################
# Some of the key verbs provided by the dplyr package
# select: return a subset of the columns of a data frame, using a flesxible notation
# filter: extract a subset of rows from a data frame based on logical conditions
# arrange: reorder rows of a data frame
# rename: rename variables in a data frame
# mutate: add new variable/columns or transform existing variables 
# summarize: generate summary statistics of different variables in the data frame, possibly within strata
# %>%: the "pipe" operator is used to connect multiple verb actions together into a pipeline

####################################################################################################################################################################
# Common dplyr Function Properties
####################################################################################################################################################################
# All of the functions discussed in this chapter share a few common characteristics:
# The first argument is a data frame
# The subsequent arguments describe what to do with the data frame specified in the first argument, and columns in the data frame can be referred to directly without using the $ operator
# The return result of a function is a new data frame
# Data frames must be properly formatted and annotated for this to be useful. In particular, the data must be tidy. In short, there should be one observation per row, and each column should represent a feature of characteristic of that observation 

####################################################################################################################################################################
# Installing the dplyr Package
####################################################################################################################################################################
# The dplyr package can be installed from CRAN or from Github using the devtools package and install_github() function

####################################################################################################################################################################
# Select()
####################################################################################################################################################################
# This chapter will be using the dataset containing air pollution and temperature data for the city of Chicago

chicago <- readRDS("chicago.rds")

dim(chicago) # There are 6940 rows and 8 columns or observations
str(chicago) # It is a data frame with 8 variables

# The select function can be used to select columns of a data frame to be specifically focused on
# Often times a large data frame will contain all the data but any given analysis might only use a subset of variables or observations
# The select() function allows to get the few columns needed

# Suppose an individual wanted to select the first 3 columns only. There are a few ways to do this, like using numerical indices or the names directly

chicago %>% select(1:3)
chicago %>% select(city, tmpd, dptp)
subset <- chicago %>% select(city:dptp) # Note that the : normally cannot be used with names or strings but inside the select() function it can be used to specify a range of variable names
head(subset)

# Variables can also be omitted using the select() function using the negative sign

select(chicago, -(city:dptp)) # This indicates to include every variable except the variables city through dptp

# The select() function allows a special syntax that allows for columns to be selected on specific variable names. 
# For example selecting every variable that ends with a "2"

subset <- chicago %>% select(ends_with("2"))
head(subset)

# Or selecting eery variable that starts with "d":

subset <- chicago %>% select(starts_with("d"))
head(subset)

# More general regular expressions can be used if necessary. Use ?select for more details 

####################################################################################################################################################################
# Filter()
####################################################################################################################################################################






