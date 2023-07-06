library(tidyverse)
library(modelr)
options(na.action = na.warn)
library(nycflights13)
library(lubridate)
###############################################################################################################################################################################################
# Chapter 19: Model Building
###############################################################################################################################################################################################
# 19.1 Introduction
###############################################################################################################################################################################################
# Model partitioning involves finding patterns with visualization and make them concrete and precise with a model
# Large and complex datasets require alternatives methods like a machine learning approach to simply focus on the predictive ability of the model
# These approaches tend to produce black boxes: the model does a really good job at generating prediction, but the reason is unknown 

###############################################################################################################################################################################################
# 19.2 Why Are Low-Quality Diamonds More Expensive?
###############################################################################################################################################################################################
# There is a suprising relationship between the quality of diamonds and their price: low-quality diamonds (poor cuts, bad colors, and inferior clarity) have higher prices:

ggplot(diamonds, aes(cut, price)) + geom_boxplot() # Fair cut diamonds (the worst cut diamonds) have the highest average price
ggplot(diamonds, aes(color, price)) + geom_boxplot() # D and E diamonds (The best color diamonds) have the lowest average price while the worst color diamonds increase in price
ggplot(diamonds, aes(clarity, price)) + geom_boxplot() # The worst clarity diamonds have a higher average price compared to better clarity diamonds

###############################################################################################################################################################################################
# 19.2.1  Price and Carat
###############################################################################################################################################################################################
# it appears that lower-quality diamonds have higher prices because there is an important confounding variable: the weight (carat) the diamond
# The weight of the diamond is the single most important factor for determining the price of the diamond, and lower quality diamonds tend to be larger

ggplot(diamonds, aes(carat,price)) + geom_hex(bins = 50) # Strong relationship between carat (weight) and price of the diamond

# A model can be constructed to observe how of attributes of a diamond affect its relative price by fitting a model to separate out the effect of carat
# But two changes must be made to the diamond dataset before this can be done:
# 1. Focus on diamonds smaller than 2.5 carats (99.7% of the dataset)
# 2. Log-transform the carat and price variables:

diamonds2 <- diamonds %>% filter(carat <= 2.5) %>% mutate(lprice = log2(price), lcarat = log2(carat))

# These changes will make it easier to see the relationship between carat and price:

ggplot(diamonds2, aes(lcarat, lprice)) + geom_point() # There appears to be a strong positive relationship between carat and price
ggplot(diamonds2, aes(lcarat, lprice)) + geom_hex(bins = 50) # Once again a strong positive relationship between carat and price with more diamonds appearing at the higher ends of price and carat

# The log transformation is useful because it makes the pattern linear, and linear patterns are easy to work with
# The next part is removing that strong linear pattern by making the pattern explicitly by fitting a model

mod_diamonds <- lm(lprice ~ lcarat, data = diamonds2)
mod_diamonds

# The model is looked at to understand what it says about the data

grid <- diamonds2 %>%
  data_grid(carat = seq_range(carat, 20)) %>%
  mutate(lcarat = log2(carat)) %>%
  add_predictions(mod_diamonds, "lprice") %>%
  mutate(price = 2 ^ lprice)

ggplot(diamonds2, aes(carat, price)) + geom_hex(bins = 50) + geom_line(data = grid, color = "red", size = 1)

# If the model is true, then large diamonds are much cheaper than expected. Probably due to there being no diamond that costs more than $19,000
# A look at the residuals:

diamonds2 <- diamonds2 %>% add_residuals(mod_diamonds, "lresid")
ggplot(diamonds2, aes(lcarat, lresid)) + geom_hex(bins = 50)

# The residuals verify that the strong linear pattern between price and carat was removed
# Now the previous plots can be redone using residuals instead of price

ggplot(diamonds2, aes(cut, lresid)) + geom_boxplot() # Better cut quality diamonds have an average higher price
ggplot(diamonds2, aes(color, lresid)) + geom_boxplot() # The better the color of the diamond the higher the average price it will have
ggplot(diamonds2, aes(clarity, lresid)) + geom_boxplot() # The better clarity a diamond has the higher the average price

# A relationship appears, as the quality of the diamond increases, so does its relative price
# To interpret what the residuals are revealing their scale must be understood
# A residual of -1 indicates that log2(price) was 1 unit lower than a prediction based solely on its weight 
# 2^(-1) is 1/2, so points with a log2(price) value of -1 are half the expected price, and residuals with a value 1 are twice the predicted price

###############################################################################################################################################################################################
# 19.2.2 A More Complicated Model
###############################################################################################################################################################################################
# The current model could be expanded, by moving the observed effects and moving them into the model to make them explicit
# For example, including color, cut, and clarity into the model so that the effects of these three categorical variables are model explicit

mod_diamonds2 <- lm(lprice ~ lcarat + color + cut + clarity, data = diamonds2)
mod_diamonds2

# The model now includes four predictors, making the model harder to visualize
# Fortunately, they're currently all independent which means they can be plotted individually in four plots
# This process is going to be made easier using the .model argument to data_grid

grid <- diamonds2 %>% data_grid(cut, .model = mod_diamonds2) %>% add_predictions(mod_diamonds2)
grid
ggplot(grid, aes(cut, pred)) + geom_point()

# If the model needs variables that haven't explicitly supplied, data_grid() will automatically fill them in with the "typical value"
# For continuous variables, it uses the median, and for categorical variables, it uses the most common value (or values if there is a tie)

diamonds2 <- diamonds2 %>% add_residuals(mod_diamonds2, "lresid2")
ggplot(diamonds2, aes(lcarat, lresid2)) + geom_hex(bins = 50)

# The plot indicates that there are some diamonds with with large residuals. A residual of 2 indicates that the diamond is 4x the expected price
# It is often useful to look at the unusual values individually

diamonds2 %>% filter(abs(lresid2) > 1) %>% 
  add_predictions(mod_diamonds2) %>% 
  mutate(pred = round(2 ^ pred)) %>% 
  select(price, pred, carat:table, x:z) %>% 
  arrange(price)

# No apparent cause for the value, but it could be an indication that there is a problem with the model or errors in the data 

###############################################################################################################################################################################################
# 19.3 What Affects the Number of Daily Flights?
###############################################################################################################################################################################################
