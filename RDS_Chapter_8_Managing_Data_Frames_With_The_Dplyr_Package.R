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







