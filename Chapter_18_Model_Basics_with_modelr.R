library(tidyverse)
library(tidyr)
library(dplyr)
library(ggplot2)
library(tidyverse)
library(nycflights13)
library(Lahman)
library(ggstance)
library(lvplot)
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

library(tidyverse)
library(modelr)
options(na.action = na.warn)
###############################################################################################################################################################################################
# Chapter 18: Model Basics with modelr
###############################################################################################################################################################################################
# 18.1 Introduction
###############################################################################################################################################################################################
# The goal of a model is to provide a simple low-dimensional summary of a dataset
# There are two parts to a model
# 1. A family of models is defined that express a precise but generic pattern, one wants to capture. The pattern may be a quadratic or a straight line. These are expressed as equations with variables and parameters
# 2. A fitted model is found by finding a model from the family that is the closest to the data. This takes a generic model family and makes it specific like y = 3x + 7
# Note that a fitted model is just the closest model from a family of models

###############################################################################################################################################################################################
# 18.2 A Simple Model
###############################################################################################################################################################################################
# In the simulated dataset sim1, It contains two continuous variables, x and y

ggplot(sim1, aes(x, y)) + geom_point()

# There appears to be a strong pattern in the data. A model can be used to capture the pattern and make it explicit
# The model needs to be supplied the basic form of the model. In the case of sim1, the relationship looks linear: y = a0 + a_1 * x

# Begin with generating a few random intercepts and slopes and overlaying them over the graph. Geom_abline() can take a slope and intercept as it's parameters 

models <- tibble(
  a1 = runif(250, -20, 40),
  a2 = runif(250, -5, 5)
)

ggplot(sim1, aes(x, y)) + geom_point() + geom_abline(aes(intercept = a1, slope = a2), data = models, alpha = 0.25)

# There are 250 good models on the plot but most of them are pretty bad. Need a method to quantify the distance between the model and data. The selecting the model with the smallest distances will provide the best model
# One way of doing this is by finding the vertical distance between each point and the model in the following diagram
# The distance is just the difference between the y value given by the model (the prediction) and the actual y value in the data (the response)

# To compute this distance, first turn the model family into an R function. This takes the model parameters and the data as input and gives values predicted by the model as output

model1 <- function(a, data) # This function takes parameters and 
{
  a[1] + data$x * a[2]
}

model1(c(7, 1.5), sim1)

# Next, the overall distance between the predicted and actual values must be computed , however the plot shows 30 distances. This needs to be collapsed into a single number
# A common way to do this in statistics is to use the "root mean squared deviation". This computes the difference between actual and predicted vales, squares them, averages them, and then takes the square root

measure_distance <- function(mod, data)
{
  diff <- data$y - model1(mod, data)
  sqrt(mean(diff ^ 2))
}
measure_distance(c(7, 1.5), sim1)

# Purrr can then be used to compute the distance for all the models previously defined/ A helper function is needed because the distance function expects the model as a numeric vector of length 2

sim1_dist <- function(a1, a2) {
  measure_distance(c(a1, a2), sim1)
}

models <- models %>%
  mutate(dist = purrr::map2_dbl(a1, a2, sim1_dist))
models

# The 10 best models can be overlayed on the data

ggplot(sim1, aes(x, y)) + geom_point(size = 2, color = "grey30") +
  geom_abline(aes(intercept = a1, slope = a2, color = -dist), data = filter(models, rank(dist) <= 10))

# These models can be thought of as observations, and can be visualized with a scatterplot of a1 vs a2

ggplot(models, aes(a1, a2)) +
  geom_point(
    data = filter(models, rank(dist) <= 10),
    size = 4, color = "red"
  ) +
  geom_point(aes(colour = -dist))

# Instead of trying lots of random models, a more systematic approach could be taken that generates an evenly spaced grind of points (called a grid search)
# The parameters of the grid are picked roughly by looking at wherre the best models were in the preceding plot

grid <- expand.grid(
  a1 = seq(-5, 20, length = 25),
  a2 = seq(1, 3, length = 25)
) %>%
  mutate(dist = purrr::map2_dbl(a1, a2, sim1_dist))

grid %>%
  ggplot(aes(a1, a2)) +
  geom_point(
    data = filter(grid, rank(dist) <= 10),
    size = 4, colour = "red"
  ) +
  geom_point(aes(color = -dist))

# Overlaying the 10 best models back on the original data shows a good fit

ggplot(sim1, aes(x, y)) +
  geom_point(size = 2, color = "grey30") +
  geom_abline(
    aes(intercept = a1, slope = a2, color = -dist),
    data = filter(grid, rank(dist) <= 10)
  )

# The graph could be continued to be refined itertively until it's narrowed down to the best model, but there's a better way. A numerical minimization tool called Newton-Ralph search
# The Newton-Ralph search picks a starting point and looks around for the steepest slope. It repeats this process until the steepest slop is found
# This search can be done in R with optim() 

best <- optim(c(0, 0), measure_distance, data = sim1)
best$par # 4.222248 2.051204

ggplot(sim1, aes(x, y)) +
  geom_point(size = 2, color = "grey30") +
  geom_abline(intercept = best$par[1], slope = best$par[2])

# optim() needs a function that defines the distance between a model and a dataset, an an algorithm that can minimize the distance by modifying the parameters of the model 
# Additionally the last approach that can be used is using a broader family: linear models
# R has a special tool specifically designed for fitting linear models called lm()
# lm() has a special way to specify the model family: formulas
# Formulas look like Y ~ x, which lm() will translate to a function like y = a1 +a2 * x

sim1_mod <- lm(y ~ x, data = sim1)
coef(sim1_mod) # 4.220822    2.051533 

# These results are exactly the same as using optim(), however lm() finds the closest model using a sophisticated model

###############################################################################################################################################################################################
# 18.3 Visualizing Models
###############################################################################################################################################################################################
# For simple models, the pattern captured by the model can be determined by carefully studying the model family and the coefficients 
# Models can also be understood by looking at it's predictions. This has the advantage that every type of predictive model makes predictions so they use the same set of techniques to understand the models
# It can be useful to see what the model doesn't capture. 
# Residuals are left after subtracting the predictions from the data
# Residuals are powerful because they allow for the use of models to remove striking patterns to allow the study of more subtler trends that remain

###############################################################################################################################################################################################
# 18.3.1 Predictions
###############################################################################################################################################################################################
# To visualize the predictions from a model, start by generating an evenly spaced grid of values that covers the region where the data lies
# The easiest way to do this is using modelr::data_grid()
# It's first argument is a data frame and for each subsequent argument it finds the unique variables and then generates all combinations

grid <- sim1 %>% data_grid(x)
grid

# Next add predictions. modelr::add_predictions() takes a data frame and a model. It adds the predictions from the model to a new column in the data frame

grid <- grid %>% add_predictions(sim1_mod)
grid 

# A function can also be used to ad predictions to the original dataset
# The advantage to using this approach over geom_abline() is that this approach will work with any model in R from simple to complex

ggplot(sim1, aes(x)) + geom_point(aes (y = y)) + geom_line(aes(y = pred), data = grid, color = "red", size = 1)


###############################################################################################################################################################################################
# 18.3.2 Residuals
###############################################################################################################################################################################################
# The opposite of predictions are residuals. The predictions reveal what the pattern that the model has captured, and the residuals reveal what the model has missed
# The residuals are just the distances between the observed and predicted values 

# Residuals are added to the data with add_residuals(), which works much like add_predictions()
# However, use the original dataset not the manufactured grid. This is because the plot needs the y values to compute the residuals

sim1 <- sim1 %>% add_residuals(sim1_mod)
sim1

# There a few different way to understand what the residuals reveal about the model
# One simple way is to draw a frequency polygon to help understand the spread

ggplot(sim1, aes(resid)) + geom_freqpoly(binwidth = 0.5)

# This allows for evaluation of the model; How far away are the predictions from the observed values?
# Note that the average of the residuals will always be 0

# It's useful to re-create plot using the residuals instead of the original predictor

ggplot(sim1, aes(x, resid)) +
  geom_ref_line(h = 0) +
  geom_point()

###############################################################################################################################################################################################
# 18.3.3 Exercises
###############################################################################################################################################################################################
# 1. Instead of using lm() to fit a straight line, you can use loess() to fit a smooth curve. Repeat the process of model fitting, grid generation, predictions, and visualization on sim1 using loess() instead of lm(). How does the result compare to geom_smooth()?

sim1

sim2_mod <-loess(y ~ x, data = sim1)
grid2 <- sim1 %>% data_grid(x)
grid2 
grid2 <- sim1 %>% add_predictions(sim2_mod)
sim1 <- sim1 %>% add_residuals(sim2_mod)

ggplot(sim1, aes(x, resid)) +
  geom_ref_line(h = 0) +
  geom_point()

# 2. add_predictions() is paired with gather_predictions() and spread_predictions(). How do these three functions differ?
# add_predictions() adds a single column with the default name pred to the input data
# spread_predictions() adds one column for each model
# gather_predictions adds two columns .model and .pred and repeats the input rows for each model

# Why might you want to look at a frequency polygon of absolute residuals? What are the pros and cons compared to looking at the raw residuals?
# Looking at the absolute values of the residuals shows the absolute magnitude of difference while the raw values will tell you whether the predictions was lower or higher than expected

###############################################################################################################################################################################################
# 18.4 Formula and Model Families
###############################################################################################################################################################################################
# In R, formulas provide a general way of getting special behavior, rather than evaluating the values of the variables right away, they capture them so they can be interpreted by the function
# The majority of modeling functions in R use a standard conversion from formulas to functions
# One example of the simple conversation is y ~ x is translated to y = a1 + a2 * x 
# To actually see what R does use the model_matrix() function
# model_matrix() takes a data frame and a formula and returns a tibble that defines the model equation. Each column in the output is associated with a coefficient in the model

df <- tribble(
  ~y, ~x1, ~x2,
  4, 2, 5,
  5, 1, 6)

model_matrix(df, y ~ x1)

# The way R adds the intercept to the model is just by having a column that is full of ones. R will always add this column by default. To get rid of this column explicit drop it with -1 

model_matrix(df, y ~ x1 - 1)

# The model matrix grows in an unsurprising way when adding more variables to the model

model_matrix(df, y ~ x1 + x2)

# The formula notation is called "Wilkinson-Rogers notation"

###############################################################################################################################################################################################
# 18.4.1  Categorical Variables
###############################################################################################################################################################################################
# Generating a function from a formula is straightforward when the predictor is continuous, but things become more complicated when the predictor is categorical
# Imagine a formula like y ~ sex, where sex could be male or female. It doesn't make sense to convert to a formula like y = x0 + x_1 * sex because sex isn't a number
# Instead R converts it to y = x_0 + x_1 * sex_male where sex_male is one if sex is male and zero otherwise

df <- tribble(
  ~ sex, ~ response,
  "male", 1,
  "female", 2,
  "male", 1)

model_matrix(df, response ~ sex)

# R doesn't create a model with sexfemale because that would create a column that is perfectly predictable based on the other columns (sexfemale = 1 - sexmale)

ggplot(sim2) +
  geom_point(aes(x, y))

# A model can be fit to this dataset to generate predictions 

mod2 <- lm(y ~x, data = sim2)

grid <- sim2 %>%
  data_grid(x) %>%
  add_predictions(mod2)
grid

# Effectively, a model with categorical x will predict the mean value for each category because the mean minimizes the mean-squared distance


ggplot(sim2, aes(x)) +
  geom_point(aes(y = y)) +
  geom_point(
    data = grid,
    aes(y = pred),
    color = "red",
    size = 4
  )

# Predictions can't be made about levels that aren't observed. It will display an error message

tibble(x = "e") %>%
  add_predictions(mod2)

##############################################################################################################################################################################################
# 18.4.2 Interactions (Continuous and Categorical)
###############################################################################################################################################################################################
# sim3 contains a categorical and continuous predictor

ggplot(sim3, aes(x1, y)) +
  geom_point(aes(color = x2))

# There are two possible ways to model the fit to this data

mod1 <- lm(y ~ x1 + x2, data = sim3)
mod2 <- lm(y ~ x1 * x2, data = sim3)

# When adding variables with "+", the model will estimate each effect independent of all others. It's possible to fit the so called interaction by using *
# Note whenever using *, both the interaction and the individual components are included in the model 

# Visualizing the model require new techniques
# With two predictors, data_grid() needs to be given both variables. It finds all unique values of x1 and x2 and then generates all combinations 
# To generate predictions from both models simultaneously, use gather_predictions() which adds each prediction as a row

grid <- sim3 %>% data_grid(x1, x2) %>% gather_predictions(mod1, mod2)
grid

# Both of these results can be visualized for both models by using facet wrapping

ggplot(sim3, aes(x1, y, color = x2)) +
  geom_point() +
  geom_line(data = grid, aes(y = pred)) +
  facet_wrap(~ model)

# Note that the model that uses + has the same slope for each line, but different intercepts. The model that uses * has different slopes and intercepts for each line 
# To understand which model is better for the data graph the residuals

sim3 <- sim3 %>%
  gather_residuals(mod1, mod2)

ggplot(sim3, aes(x1, resid, color = x2)) +
  geom_point() +
  facet_grid(model ~ x2)

# The plot shows the model has captured the patterns for mod1 but mod1 shows the model has missed some patterns 

##############################################################################################################################################################################################
# 18.4.3 Interactions (Two Continuous)
###############################################################################################################################################################################################
# Here's a look at the equivalent model for two continuous variables: 

mod1 <- lm(y ~ x1 + x2, data = sim4)
mod2 <- lm(y ~ x1 * x2, data = sim4)

grid <- sim4 %>%
  data_grid(
    x1 = seq_range(x1, 5),
    x2 = seq_range(x2, 5)) %>% gather_predictions(mod1, mod2)
grid

# Notice the use of seq_range() inside data_grid(). Instead of using every unique value of x, it creates a regularly spaced grid of five values between the minimum and maximum numbers

# There are three other useful arguments to seq_range():
# 1. pretty = TRUE will generate a "pretty" sequence. This is useful for producing tables of outputs:

seq_range(c(0.0123, 0.923423), n = 5) # 0.0123000 0.2400808 0.4678615 0.6956423 0.9234230
seq_range(c(0.0123, 0.923423), n = 5, pretty = TRUE) # 0.0 0.2 0.4 0.6 0.8 1.0

# 2. trim = 0.1 will trim off 10% of the tail values. This is useful if the variable has a long tailed distribution and to focus on generating values near the center

x1 <- rcauchy(100)
seq_range(x1, n = 5) # -85.743910 -40.825936   4.092038  49.010012  93.927985
seq_range(x1, n = 5, trim = 0.10) # -2.9669762 -1.1108462  0.7452837  2.6014137  4.4575437
seq_range(x1, n = 5, trim = 0.25) # -1.574792616 -0.786881684  0.001029247  0.788940179  1.576851110
seq_range(x1, n = 5, trim = 0.50) # -0.80474799 -0.36928617  0.06617565  0.50163747  0.93709929

# 3. expand = 0.1 is in some sense the opposite of trim(); it expands the range by 10% 

x2 <- c(0, 1)
seq_range(x2, n = 5) # 0.00 0.25 0.50 0.75 1.00
seq_range(x2, n = 5, expand = 0.10) #  -0.050  0.225  0.500  0.775  1.050
seq_range(x2, n = 5, expand = 0.25) # -0.1250  0.1875  0.5000  0.8125  1.1250
seq_range(x2, n = 5, expand = 0.50) # -0.250  0.125  0.500  0.875  1.250

 # When visualizing a model with two continuous models, that model can be imagine like a 3D surface

ggplot(grid, aes(x1, x2)) +
  geom_tile(aes(fill = pred)) +
  facet_wrap(~ model)

# The plot may suggest that the models aren't very different but it's partly an illusion. Instead of looking at the surface from the top, look at it from either side showing multiple slices

ggplot(grid, aes(x1, pred, color = x2, group = x2)) +
  geom_line() +
  facet_wrap(~ model)
ggplot(grid, aes(x2, pred, color = x1, group = x1)) +
  geom_line() +
  facet_wrap(~ model)

# These plots show that the interaction between two continuous variables works basically the same way for a categorical and continuous variables

##############################################################################################################################################################################################
# 18.4.4 Transformations
###############################################################################################################################################################################################
# Transformations can performed inside the model formula 
# For example log(y) ~ sqrt(x1) + x2 is transformed to y = a_1 + a_2 * x1 * sqrt(x) + a_3 * x2.
# If the transformation involves +,*,^, or - it must be wrapped in I()
# For example, y ~ x + I(x ^ 2) is translated to y = a_1 + a_2 * x + a_3 * x^2

df <- tribble(
  ~y, ~x,
  1, 1,
  2, 2,
  3, 3
)
model_matrix(df, y ~ x^2 + x)

model_matrix(df, y ~ I(x^2) + x)

# Transformations are useful because they can be used to approximate nonlinear functions
# Taylors theorem, says a smooth function can be approximated with an infinite sum of polynomials 
# R provides a helper function, poly() 

model_matrix(df, y ~ poly(x, 2))

# However, there's one major problem with using ploy(); outside the range of the data, polynomials rapidly shoot off to positive or negative infinity
# One safer alternative is to use the natural spline splines::ns()

library(splines)
model_matrix(df, y ~ ns(x, 2))

sim5 <- tibble(
  x = seq(0, 3.5 * pi, length = 50),
  y = 4 * sin(x) + rnorm(length(x))
)

ggplot(sim5, aes(x, y)) +
  geom_point()

# Five models can be fit to this data:

mod1 <- lm(y ~ ns(x, 1), data = sim5)
mod2 <- lm(y ~ ns(x, 2), data = sim5)
mod3 <- lm(y ~ ns(x, 3), data = sim5)
mod4 <- lm(y ~ ns(x, 4), data = sim5)
mod5 <- lm(y ~ ns(x, 5), data = sim5)

grid <- sim5 %>%
  data_grid(x = seq_range(x, n = 50, expand = 0.1)) %>%
  gather_predictions(mod1, mod2, mod3, mod4, mod5, .pred = "y")

ggplot(sim5, aes(x, y)) +
  geom_point() +
  geom_line(data = grid, color = "red") +
  facet_wrap(~ model)

##############################################################################################################################################################################################
# 18.5 Missing Values
##############################################################################################################################################################################################
# Missing values cannot convey any information about the relationship between variables. so modeling functions will drop any rows that contain missing values
# R default behavior is to drop them but options(na.action = na.warn) makes sure to provide a warning 

options(na.action = na.warn)

df <- tribble(
  ~x, ~y,
  1, 2.2,
  2, NA,
  3, 3.5,
  4, 8.3,
  NA, 10
)

mod <- lm(y ~ x, data = df) # Dropping 2 rows with missing values

# To suppress the warning, set na.action = na.exclude 

mod <- lm(y ~ x, data = df, na.action = na.exclude)

# The number of observations used can be seen with nobs() 

nobs(mod) # 3

##############################################################################################################################################################################################
# 18.6 Other Model Families
##############################################################################################################################################################################################
# Linear models assume that the residuals have a normal distribution
# There is a large set of model classes that extend the linear model in various interesting ways:

# Generalized linear models, e.g., stats::glm(). Linear models assume that the response is continuous and the error has a normal distribution. 
# Generalized linear models extend linear models to include noncontinuous responses (e.g., binary data or counts). They work by defining a distance metric based on the statistical idea of likelihood.

# Generalized additive models, e.g., mgcv::gam(), extend generalized linear models to incorporate arbitrary smooth functions.
# That means you can write a formula like y ~ s(x), which becomes an equation like y = f(x), and let gam() estimate what that function is (subject to some smoothness constraints to make the problem tractable).

# Penalized linear models, e.g., glmnet::glmnet(), add a penalty term to the distance that penalizes complex models (as defined by the distance between the parameter vector and the origin).
# This tends to make models that generalize better to new datasets from the same population.

# Robust linear models, e.g., MASS:rlm(), tweak the distance to down weight points that are very far away. 
# This makes them less sensitive to the presence of outliers, at the cost of being not quite as good when there are no outliers.

# Trees, e.g., rpart::rpart(), attack the problem in a completely different way than linear models. 
# They fit a piece-wise constant model, splitting the data into progressively smaller and smaller pieces. 
# Trees aren’t terribly effective by themselves, but they are very powerful when used in aggregate by models like random forests (e.g., randomForest::randomForest()) or gradient boosting machines (e.g., xgboost::xgboost.)

##############################################################################################################################################################################################
# End of Chapter 18
##############################################################################################################################################################################################

