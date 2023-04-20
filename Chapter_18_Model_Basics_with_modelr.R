library(tidyverse)
library(tidyr)
library(dplyr)
library(ggplot2)
library(tidyverse)
library(nycflights13)
library(Lahman)
library(ggstance)
library(lvplot)
library(ggbeeswarm)
library(heatmaply) 
library(hexbin)
library(modelr)
library(forcats)
library(stringr)
library(lubridate)
library(purrr)
library(readxl)
library(modelr)
options(na.action = na.warn) # Take this out when not using models


#################################################################################################################################################################################
# Chapter 18: Model Basics with Modelr
#################################################################################################################################################################################

# Models are used to provide simple low-dimensional summary of a dataset

# There are two parts to a model:
# 1. Begin a model by defining a family of models that express a precise, but generic, pattern to capture within the model. For example a linear relationship can be represented with the equation y = a0*x + a1 (y = mx+b) or a quadratic
# 2. Next, generate a fitted model by finding the model from the family that is closest to the data. This takes the gernic model and makes it specific

# It's important to understand that fitted model is just the closest model from a family of models. That implies it is the "best" representation of the data
# However, this doesn't mean the fitted model is a good model and that it is "true"

#################################################################################################################################################################################
# A simple model
#################################################################################################################################################################################

ggplot(sim1, aes(x,y)) + geom_point()

# There is a strong pattern within this dataset
# The relationship looks linear thus the model will be supplied with y = a_0 + a_1 * x

models <- tibble(
  a1 = runif(250, -20, 40), # runif(n, min = 0, max = 1) First number is the number of random samples taken from the interval. The following numbers are the min and max of the interval 
  a2 = runif(250, -5, 5)
)

# geom_abline() acts differently from other geom. It can take parameters in either the arguments in the layer function or via aesthetics
# If supplied arguments the geom creates a data frame containing the data it was supplied
#  To some them across various facets, construct the data frame and use aesthetics
# Unlike most geoms, this geom does not inherit aesthetics from the default plot. It additionally does not alter the x and y scales
# The geoms are drawn using geom_line() and thus are supported with the same aesthetics: alpha, color, linetype, and linewidth

ggplot(sim1, aes(x, y)) + geom_abline(aes( intercept = a1, slope = a2), data = models, alpha = 1/4) + geom_point()

# In the example above, geom_abline() created 250 models on the plot using the data it was supplied. A majority of these models don't really accurately model the trend in the plot
# To find a model that is "close" to the data, it can be useful to quantify the distance between the data and model. Afterwards, using those values they can be used to generate a model with the smallest distance from the data
# To compute this distance, turn the model family into an R function. This takes the model parameters and the data as inputs and fives values predicted by the model as output:

model1 <- function(x, data){ # This function turns the model family (The generic equation of the data set) into a data set when given parameters
  x[1] + data$x * x[2]       # Specifically a fitted model is given specific parameters and then is provided a data set from the original data to create a predicted model
}

model1(c(7, 1.5), sim1)  # In this line a0 and a1 are given the parameters of 7 and 1.5 and then it creates a dataset using those parameters by feeding it the x values of the original data

# The plot provides 30 different distances collapse that into a single number using "root-mean-squared deviation" (RMSD)
# RMSD measures the difference between values predicted by a model and the observed values
# RMSD serves to aggregate the magnitude of the errors in predictions for various data points into a single measure of predictive power
# RMSD is a measure of accuracy, to compare forecasting errors of different models for a particular dataset (not between data sets as it is scale-dependent)
# RMSD is always a non-negative number and a value of 0 indicates a perfect fit for data
# In general, a lower RMSD is better than a higher one, however comparisons across different types of data would be invalid because the measure is dependent on the scale of the numbers used
# Compute the difference between actual and predicted, square the difference, average them, and then take the square root

measure_distance <- function(mod, data){ # This function serves to find RMSD of the points in the predicted model (determined using the model1 function) and the actual data set provided.
  diff <- data$y - model1(mod, data)  # This subtracts the y values of sim1 from the values of the predicted model
  sqrt(mean(diff ^ 2)) # Finds RMSD using its formula
}
measure_distance(c(7, 1.5), sim1)

# purrr is used to compute the distance for all the models previously defined

sim1_dist <- function(a1, a2){
  measure_distance(c(a1, a2), sim1)
}


models <- models %>% mutate(dist = purrr::map2_dbl(a1, a2, sim1_dist))
models

ggplot(sim1, aes(x, y)) + geom_point(size = 2, color = "grey30") + geom_abline(aes(intercept = a1, slope = a2, color = -dist), data = filter(models, rank(dist) <= 10)) # This line overlays the 10 best models onto the data by selecting those with the smallest distance

# Models can be thought of as observations and can be visualized on a scatterplot of 

# Instead of trying random models, a systematic approach would include generating an evenly spaced grid of points (called a grid search) and picking the parameters of the grid roughly by looking at where the best models were in the preceding plot

grid <- expand.grid(a1 = seq(-5, 20, length = 25), a2 = seq(1, 3, length = 25)) %>% mutate(dist = purrr::map2_dbl(a1, a2, sim1_dist))

grid %>% ggplot(aes(a1, a2)) + geom_point(data = filter(grid, rank(dist) <= 10), size = 4, colour = "red") + geom_point(aes(color = -dist))

ggplot(sim1, aes(x, y)) + geom_point(size = 2, color = "grey30") + geom_abline(aes(intercept = a1, slope = a2, color = -dist), data = filter(grid, rank(dist) <= 10))

# overall the 10 best models on the data show that the models look fairly accurate

# The gird could iteratively refined until there's a single 


