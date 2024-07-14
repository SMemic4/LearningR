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
# A similar process can be done with the flight dataset, a smaller dataset with only 365 rows and 2 columns
# A full model wont be able to be built of this, but can allow for a better understanding of the data

daily <- flights %>% mutate(date = make_date(year, month, day)) %>% group_by(date) %>% summarize(n = n())
daily
ggplot(daily, aes(date, n)) + geom_line()

###############################################################################################################################################################################################
# 19.3.1 Day of Week
###############################################################################################################################################################################################
# Understanding the long-term trend is challenging because there's a very strong day-of-week effect that dominates the subtler patterns
# Start by looking at the distribution of flight numbers by day of week

daily <- daily %>% mutate(wday = wday(date, label = TRUE)) # Creating a weekday column
ggplot(daily, aes(wday, n)) + geom_boxplot() # Weekdays appear to a constantly high amount of flights while Saturday has a much smaller average

# There are fewer flights on weekends because most travel is for business
# The effect is particularly pronounced on Saturday. One way to remove this strong pattern is to use a model
# First, fit the model and display its predictions overlaid on the original data

mod <- lm(n ~ wday, data = daily) # Creating a linear model 
grid <- daily %>% data_grid(wday) %>% add_predictions(mod, "n") # Visualizing a model 
ggplot(daily, aes(wday, n)) + geom_boxplot() + geom_point(data = grid, color = "red", size = 3)

# Compute and visualize the residuals

daily <- daily %>% add_residuals(mod)
daily %>% ggplot(aes(date, resid)) + geom_ref_line(h = 0) + geom_line(size = 1.2)

# Note the change in the y axis: It shows a deviation from the expected number of flights given the day of week
# This plot is useful since much of the large-day-of-week effect was removed, allowing for subtler patterns to be revealed:
# The model seems to fail starting in June. There is a strong regular pattern that the model hasn't captured 
# Drawing a plot with one line for each day of the week makes the cause easier to see: 

ggplot(daily, aes(date, resid, color = wday)) + geom_ref_line(h = 0) + geom_line() # A large amounts of flight on Saturday around June

# The model fails to accurately predict the number of flights on Saturday
# During summer there are more flights than expected and during fall there are fewer
# Additionally there are some days with far fewer flights than expected 

daily %>% filter(resid < -100) # 11 flights

# A lot of these dates correspond to American public holidays
# There seems to be some smoother long-term trend over the course of a year. This trend can be highlighted with geom_smooth() 

daily %>% ggplot(aes(date, resid)) + 
  geom_ref_line(h = 0) + 
  geom_line(color = "grey50") + 
  geom_smooth(se = FALSE, span = 0.20)

# There are fewer flights in January (and December) and more in the summer 

###############################################################################################################################################################################################
# 19.3.2 Seasonal Saturday Effect 
###############################################################################################################################################################################################
# The model failed to predict the number of flights that take place on Saturday
# A good way to improve the model is by focusing specifically on the Saturdays

daily %>% filter(wday == "Sat") %>% 
  ggplot(aes(date, n)) + 
  geom_point() + 
  geom_line() + 
  scale_x_date(NULL, date_breaks = "1 month", date_labels = "%b")

# The pattern displayed in the graph could possibly be due the summer holidays. Most people go on vacation in the summer, and individuals wouldn't mind traveling on Saturday for vacation
# The drop off in August could be explained by the the state school terms occurring in this period 
# A term variable can be created that roughly captures the three school terms

term <- function(date) {
  cut(date,
      breaks = ymd(20130101, 20130605, 20130825, 20140101),
      labels = c("spring", "summer", "fall")
  )
}

daily <- daily %>%
  mutate(term = term(date))

daily %>%
  filter(wday == "Sat") %>%
  ggplot(aes(date, n, color = term)) +
  geom_point(alpha = 1/3) +
  geom_line() +
  scale_x_date(
    NULL,
    date_breaks = "1 month",
    date_labels = "%b"
  )

# It is useful to see how this new variable affect the other days of the week

daily %>%
  ggplot(aes(wday, n, color = term)) +
  geom_boxplot()

# There appears to be significant variation across the terms, so fitting a separate day-of-week effect for each term is reasonable

mod1 <- lm(n ~ wday, data = daily)
mod2 <- lm(n ~ wday * term, data = daily)

daily %>%
  gather_residuals(without_term = mod1, with_term = mod2) %>%
  ggplot(aes(date, resid, color = model)) +
  geom_line(alpha = 0.75)

# This improves the model but only ever so slightly 
# Problems arise when overlaying the predictions from the model onto the raw data:

grid <- daily %>%
  data_grid(wday, term) %>%
  add_predictions(mod2, "n")

ggplot(daily, aes(wday, n)) +
  geom_boxplot() +
  geom_point(data = grid, color = "red") +
  facet_wrap(~ term)

# The model is finding the mean effect, but due to a large amount of outliers the mean tends to be far away from the typical value
# This problem can be alleviated by using a model that is robust to the effect of outliers: MASS::rlm()
# This greatly reduces the impact of the outliers on the estimates, and gives a model that removes the day-of-week pattern

mod3 <- MASS::rlm(n ~ wday * term, data = daily)

daily %>%
  add_residuals(mod3, "resid") %>%
  ggplot(aes(date, resid)) +
  geom_hline(yintercept = 0, size = 2, color = "white") +
  geom_line()

# The long-term trend is easier to see and the various positive and negative outliers

###############################################################################################################################################################################################
# 19.3.3 Computed Variables
###############################################################################################################################################################################################
# When experimenting with many models and many visualizations, it's a good idea to bundle the creation of variables up into a function, 
# This reduces the chances of accidentally applying transformations in different places
# For example:

compute_vars <- function(data) {
  data %>%
    mutate(
      term = term(date),
      wday = wday(date, label = TRUE)
    )
}

# Another option is to put the transformations directly in the model formula 

wday2 <- function(x) wday(x, label = TRUE)
mod3 <- lm(n ~ wday2(date) * term(date), data = daily)

# Either approach is reasonable. Making the transformed variable explicit is useful to check for errors
# Including the transformations in the model function makes life easier, when working with many different datasets because the model is self-contained 

###############################################################################################################################################################################################
# 19.3.4 Time of Year: An Alternative Approach 
###############################################################################################################################################################################################
# An alternative to the model is making ones knowledge explicit in the model to give the data more room to speak
# A flexible model can be used to capture the pattern of the data
# A simple linear trend is adequate, so a natural spline can be used to fit a smooth curve across the year

library(splines)
mod <- MASS::rlm(n ~ wday * ns(date, 5), data = daily)

daily %>%
  data_grid(wday, date = seq_range(date, n = 13)) %>%
  add_predictions(mod) %>%
  ggplot(aes(date, pred, color = wday)) +
  geom_line() +
  geom_point()

# There is a strong pattern in the number of Saturday flights
# This is reassuring, because it mirrors the pattern seen in the raw data. It is a good sign to see the same patterns when using different methods

###############################################################################################################################################################################################
# End of Chapter 19
###############################################################################################################################################################################################
