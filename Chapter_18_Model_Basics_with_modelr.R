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
library(writexl)
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

# The gird could iteratively refined until there's a single best model, however this is another approach that can be taken. 
# The Newton-Raphson search picks a starting point and looks around for the steepest slope, This is done with the optim() function

best <- optim(c(0,0), measure_distance, data = sim1)
best$par

ggplot(sim1, aes(x,y)) + geom_point(size = 2, color = "grey40") + geom_abline(intercept = best$par[1], slope = best$par[2])

# The approach above will work for any family of models that can be written as an equation

# Linear models have the general form of y= a1 + a2 * x1 + a3 * x2 (an * x(n-1))
# R has a specific tool designed for fitting linear models specifically lm() 
# lm() has a special way to specify the mode family: formulas. Formulas look like y ~x, which lm() will translate to a function like y = a1 + a2 * x. 

sim1_mod <- lm(y ~ x, data = sim1)
coef(sim1_mod) # 4.22 and 2.05 

# The values obtained in the above lines of code are exactly the same as the ones returned by optim()

#################################################################################################################################################################################
# Exercises
#################################################################################################################################################################################
# 1. One downside of the linear model is that it is sensitive to unusual values because the distance incorporates a squared term. Fit a linear model to the following simulated data, and visualize the results. Rerun a few times to generate different simulated datasets. What do you notice about the model?
  
sim1a <- tibble(
  x = rep(1:10, each = 3),
  y = x * 1.5 + 6 + rt(length(x), df = 2)
)

best <- lm(y ~ x, data = sim1a)
best2 <- coef(best)
ggplot(sim1a, aes(x,y)) + geom_point() + geom_abline(intercept = best2[1] , slope =  best2[2])

# The model remains relatively linear even with repeated repetitions 

# 2. One way to make linear models more robust is to use a different distance measure. For example, instead of root-mean-squared distance, you could use mean-absolute distance. Use optim() to fit this model to the previous simulated data and compare it to the linear model.

measure_distance <- function(mod, data) {
  diff <- data$y - make_prediction(mod, data)
  mean(abs(diff))
}

make_prediction <- function(mod, data) {
  mod[1] + mod[2] * data$x
}

best <- optim(c(0, 0), measure_distance, data = sim1a)
best$par

# There is larger degree of variance when using optim

#################################################################################################################################################################################
# Visualizing Models
#################################################################################################################################################################################
# For simple models, the pattern of the model can be determined by carefully studying the model family and the fitted coefficients
# This section focuses on predictive models making predictions. A model can be understood based on it's predictions
# Additionally its useful to understand what a model doesn't capture. The residuals that are left can be used to understand subtler treads that remain

# To visualize the predictions from a model, start by generating an evenly spaced grid of values that cover's the region where our data lies
# The easiest way to accomplish this is using modelr::data_grind(). It's first argument is a data frame and for each subsequent argument it finds the unique variables and then generates all combinations 

grid <- sim1 %>% data_grid(x)
grid

# Next add predictions to the  model. Use modelr::add_predictions() which takes a data frame and a model. It adds the predictions from the model to a new column in the data frame

grid <- grid %>% add_predictions(sim1_mod)
grid

# The function can also be used to add predictions to the original data set 

# Next plot the predictions. This method has an advantage over geom_abline(), due to the fact this approach will work with any model in R, from simple to complex

ggplot(sim1, aes(x)) + geom_point(aes(y = y)) + geom_line(aes(y = pred), data = grid, color = "lightblue", linewidth = 2)

# The opposite side of predictions is residuals. The predictions tell the pattern that the model has captured, while the residuals reveal what the model has missed
# The residuals are just the distance between the observed and predicted values that were computed earlier
# Residuals can be added to the data with add_residuals(), which works much like add_predictions(). 
# However, residuals will be used with the original dataset and not the manufactured grid. This is due to the computation of residuals requiring actual y values

sim1 <- sim1 %>% add_residuals(sim1_mod)
sim1

# There are a few different ways to understand what the residuals say about the model. One simple way is to draw a frequency polygon to help understand the spread of the residuals

ggplot(sim1, aes(resid)) + geom_freqpoly(binwidth = 0.5)

# This plot helps calibrate the quality of the model. How far away are the predictions from the observed values. Note that the average of the residual will always be 0 
# It's often useful to re-create plots using the residuals instead of the original predictor

ggplot(sim1, aes(x, resid)) + geom_ref_line(h = 0) + geom_point()

# The plot above appears to only capture random noise, suggesting the model has done a good job at capturing the pattern of the dataset
#################################################################################################################################################################################
# Exercises
#################################################################################################################################################################################
# 1. . add_predictions() is paired with gather_predictions() and spread_predictions(). How do these three functions differ?
# Add_predictions() adds single new column with the name pred to the data
# Spread_predictions adds one column for each model
# Gather_predictions adds two columns .model and .pred and repeats the input rows for each model

# 2. What does geom_ref_line() do? What package does it come from? Why is displaying a reference line in plots showing residuals useful and important?
# geom_ref_line() adds a reference line to a plot.This is important for when displaying residuals because it shows the distance of the points from the line 
  
# 3. Why might you want to look at a frequency polygon of absolute residuals? What are the pros and cons compared to looking at the raw residuals?
# Looking at a frequency polygon is useful for determining the absolute value of the residuals and how far they are from the original values
# Looking at raw residuals can be harder to visualize but can help tell you if you model is above or below the original values
#################################################################################################################################################################################
# Formulas and Model Families
#################################################################################################################################################################################
# The majority of modeling functions in R use a standard conversion from formulas to functions 
# One simple conversion is y ~ x is translated to y = a1 + a2 * x 
# To determine what R actually does, use the function model_matrix()
# Model_matrix() takes a data frame and a formula and returns a tibble that defines he model equation: each column in the output is associated with one coefficient in the model and the function is always y = a1 * out1 + a2 * out2
# The simplest case of y ~ x1 shows an interesting case: 
df <- tribble(
  ~y, ~x1, ~x2,
  4, 2, 5,
  5, 1, 6
)

model_matrix(df, y ~ x1)

# The way R adds the intercept to the model is just by having a column full of ones, By default, R will always add this column. To drop this column, it must be explicitly dropped with -1

model_matrix(df, y ~ x1 - 1)

