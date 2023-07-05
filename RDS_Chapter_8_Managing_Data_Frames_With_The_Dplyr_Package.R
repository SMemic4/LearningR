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
# The filter() function is used to extract subsets of rows from a data frame
# The function is similar to the existing subset() function in R but is faster

# Suppose one wanted to extract the rows of the Chicago data frame where the levels of PM2.5 are greater than 30:

chic.f <- chicago %>% filter(pm25tmean2 > 30)
str(chic.f) # Data frame with 194 observations and 8 variables
dim(chic.f) # 194 rows and 8 columns 

summary(chic.f$pm25tmean2) # Summary of the particle data 

# Arbitrarily complex logical sequences can be placed inside of filter(). For example selecting rows where PM2.5 is greater than 30 and temperature is greater than 80 degrees

chic.f <- chicago %>% filter(pm25tmean2 > 30 & tmpd > 80)
dim(chic.f) # 17 rows and 8 columns
str(chic.f) # Data frame with 17 observations and 8 variables 

# There are only 17 observations where both of those conditions are met

####################################################################################################################################################################
# Arrange()
####################################################################################################################################################################
# The arrange() function is used to reorder rows of a data frame according to one of the variables or columns
# Reordering rows of a data frame while preserving corresponding order of other columns is normally a pain in R but the arrange() function simplifies the process
# The data frame can be ordered by date, so the first row is the earliest(oldest) observation and the last row is the latest (most recent) observation

chicago %>% arrange(date) %>% head()
chicago %>% arrange(date) %>% tail()

# Columns can be arranged in descending order too by using the special desc() operator

chicago %>% arrange(desc(date)) %>% head() 

####################################################################################################################################################################
# Rename()
####################################################################################################################################################################
# Renaming a variable in a data frame in base R is surprisingly hard
# The rename() function is designed to make this process easier

head(chicago[,1:5], 3)

# The dptp column is supposed to represent the dew point temperature and the pm25tmean2 column provides PM2.5 data. However these names can be changed to something more sensible 

chicago <- rename(chicago, dewpoint = dptp, pm25 = pm25tmean2)
head(chicago[,1:5], 3)

# The syntax inside the rename() function is to have the new name on the left hand side of the = sign and the old name on the right-hand side

####################################################################################################################################################################
# Mutate()
####################################################################################################################################################################
# The mutate() function exists to compute transformations of variables in a data frame
# Often times, new variables new to be created that are derived from existing variables and mutate() provides a clean interface for that
# For example, with the air population data, data is often detrended by subtracting the mean from the data
# That way a given day's air population can be observed as being higher or lower than the average 

chicago <- mutate(chicago, pm25detrend = pm25 - mean(pm25, na.rm = TRUE))
chicago %>% arrange(desc(date)) %>% head()

# There is also the related transmute() function which does the same thing as mutate() but then drops all non-transformed variables

####################################################################################################################################################################
# Group_by()
####################################################################################################################################################################
# The group_by() function is used to generate summary statistics from the data frame within strata defined by a variable
# For example, finding the average annual level of Pm2.5. In this case, the stratum is the years and is something that can be derived from the data variable
# The general operation here is a combination of splitting a data frame into separate pieces defined by a variable or group of variables (group_by()), and applying a summary function across those subsets 

# First create a year variable using as.POSIXit()

chicago <- mutate(chicago, year = as.POSIXlt(date)$year + 1900)

# A separate data frame that splits the original data by frame by year is created

years <- group_by(chicago, year)

# Finally, summary statistics for each year can be computed using summarize()

summarize(years, pm25 = mean(pm25, na.rm = TRUE), o3 = max(o3tmean2, na.rm = TRUE), no2 = median(no2tmean2, na.rm = TRUE))

# summarize() returns a data frame with year as the first column, and then the annual averages of pm25, o3, and no2 
# In a more complicated example, one might want to find what the average levels of ozone (o3) and nitrogen dioxide (no2) within quintiles of pm25
# One method of completing this is through a regression model, but this can be done quickly with group_by() and summarize()

# First, a categorical variable of pm25 is created and divided into qunitiles

qq <- quantile(chicago$pm25, seq(0, 1, 0.2), na.rm = TRUE)
chicago <- mutate(chicago, pm25.quint = cut(pm25, qq))

# The data frame is than grouped by the pm25.quint variable

quint <- group_by(chicago, pm25.quint)

# Finally, the mean of the o3 and no2 are computed within the quintiles of pm25

summarize(quint, o3 = mean(o3tmean2, na.rm = TRUE),  no2 = mean(no2tmean2, na.rm = TRUE))

# The table, it doesn't appear to be a strong relationship between pm25 and o3, but there appears to be a positive correlation between pm25 and no2 
# Sophisticated statistical modeling can help provide more precise answers to these questions, but simple applications of dplyr can provide a step in that direction

####################################################################################################################################################################
# %>% 
####################################################################################################################################################################
# The pipeline operator %>% is very handy for string together multiple dplyr functions in a sequence of operations
# Notice that every time a function is applied more than once, the sequence gets buried in a sequence of nest functions calls that are difficult to read

third(second(first(x)))

# This nesting is not a natural way to think about the sequence of operations. The %>% operator allows for functions to be stringed left to right 

first(x) %>% second %>% third

# For the previous example, it can be done in the following sequence in a single R expression 

mutate(chicago, pm25.quint = cut(pm25, qq)) %>% group_by(pm25.quint) %>% summarize(o3 = mean(o3tmean2, na.rm = TRUE), no2 = mean(no2tmean2, na.rm = TRUE))

# This avoids that issue of having to create a set of temporary variables along the way or creating a massive nested sequence of function calls
# Once traveling down the pipeline with %>%, the first argument is taken to be the output of the previous element in the pipeline
# Another example might be computing the average pollutant level by month. This is useful to see if there are any seasonal trends in the data

mutate(chicago, month = as.POSIXlt(date)$mon + 1) %>% group_by(month) %>% summarize(pm25 = mean(pm25, na.rm = TRUE), o3 = max(o3tmean2, na.rm = TRUE), no2 = median(no2tmean2, na.rm = TRUE))

# The table shows the o3 tends to be low in the winter months and high in the summer while no2 is higher in the winter and lower in the summer 

####################################################################################################################################################################
# Summary
####################################################################################################################################################################
# The dplyr package provides a concise set of operations for managing data frames. With these function a number of complex operations can be done in just a few lines of code
# Learning dplyr grammar provides a few additional benefits
# dplyr can work with other data frame "backends" such as SQL databases. There is an SQL interface for relational databases via the DBI package
# dplyr can be integrated with the data.table package for large fast tables

####################################################################################################################################################################
# End of Chapter 8
####################################################################################################################################################################





