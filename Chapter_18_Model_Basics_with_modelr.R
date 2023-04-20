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
# 1. Begin a model by defining a family of models that express a precise, but generic, pattern to capture within the model. 
# 2. Next, generate a fitted model by finding the model from the family that is closest to the data. This takes the geric model and makes it specific

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
# The geoms are drwan using geom_line() and thus are supported with the same aesthetics: alpha, colour, linetype, and linewidth

ggplot(sim1, aes(x, y)) + geom_abline(aes( intercept = a1, slope = a2), data = models, alpha = 1/4) + geom_point()

# In the example above, geom_abline() created 250 models (From the data) on the plot using the data it was supplied. A majority of these models don't really accurately model the trend in the plot
# To find a model that is "close" to the data, it can be useful to quantify the distance between the data and model. Afterwards, using those values they can be used to generate a model with the smallest distance from the data




