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

x1 <- c("Dec", "Apr", "Jan", "Mar") # This is a variable that records months. Using a string uses a possible problem such as having typos and it isn't able to be sorted in a useful way
x2 <- c("Dec", "Apr", "Jam", "Mar")

# This can be fixed by creating a factor instead

month_levels <- c("Jan", "Feb", "Mar", "Apr", "May", "Jun","Jul", "Aug", "Sep", "Oct", "Nov", "Dec") # To create a factor, you musst start by creating a list of the valid levels
y1 <- factor(x1, levels = month_levels)
y1
sort(y1)

# Any values not in the set will be automatically converted to NA

y2 <- factor(x2, level = month_levels)
y2

# If you want an error you can use parse_factor()
y2 <- parse_factor(x2, levels = month_levels)

# If you omit the levels, they'll be taken in alphabetical order
factor(x1)

# Sometimes you'd prefer that the order of the levels math the order of the first appearance in the data. You can do that when creating the factor by setting levels to unique(x), or after the fact, with fct_inorder()
f1 <- factor(x1, levels = unique(x1))
f1

f2 <- x1 %>% factor() %>% fct_inorder()
f2

# If you need to access the set of valid levels directly, you can do that with levels()
levels(f2)

### Rest of the script is going to work with gss_cat dataset ###

# When factors are stored in a tibble, its hard to see their levels. One way to circumvent this issues is to use them with count()

gss_cat %>% count(year) # 8 years are included in the survey starting with 2000 and going up to 2014 by skipping every other year (2000, 2002, 2004, etc)
gss_cat %>% count(race) # Three different races. White, black, and other
gss_cat %>% count(age) # Ages presumably go from 18 to some other number
gss_cat %>% count(marital) # Levels include no answer, never married, separated, divorced, widowed, and married

# Or with a bar chart

ggplot(gss_cat, aes(race)) + geom_bar()

# By default ggplot will drop any levels that don't have any values. You can force them to display with the following code

ggplot(gss_cat, aes(x = race)) + geom_bar() + scale_x_discrete(drop = FALSE) # These levels represent valid values that simply did not occur in this dataset

# When working with factors, the two most common operations are changing the order of the levels, and changing the values of the levels

######################### Exercises #########################################################################################################
# 1. Explore the distribution of rincome (reported income). What makes the default bar chart hard to understand? How could you improve the plot?

ggplot(gss_cat, aes(x = rincome)) + geom_bar() # 16 different values that are overlapped on one another making it impossible to read the data
ggplot(gss_cat, aes(x = rincome)) + geom_bar() + scale_x_discrete(drop = FALSE) # No unused levels that have no values within them

ggplot(gss_cat, aes(x = rincome)) + geom_bar() + coord_flip() # Flipping coordinate plane gives a better look at the different levels and is actually readable 

# What is the most common relig in this survey? What’s the most common partyid?

gss_cat %>% count(relig) # Most common religion is Protestant with 10846 values
gss_cat %>% count(partyid) # Most common party affiliation are the Independents with a total count of 4119 

# Which relig does denom (denomination) apply to? How can you find out with a table? How can you find out with a visualization?

gss_cat %>% count(denom) # There are over 20 different denominations
ggplot(gss_cat) + geom_bar(aes(x = relig, fill = denom)) + coord_flip() + theme(legend.position = "none") # A clean graph that shows that the denomination belong mostly to protestant. But also include other groups such as Catholics and Christians

##############################################################################################################################################

# It is often useful to change the order of the factor levels in a visualization. Here we will explore the average number of hours spent watching TV per day across religions

relig <- gss_cat %>% group_by(relig) %>% summarize(age = mean(age, na.rm = TRUE), tvhours = mean(tvhours, na.rm = TRUE), n = n())
ggplot(relig, aes(tvhours, relig)) + geom_point() # Chart is hard to interpret because there is no pattern that emerges. It can be improved by reordering the levels

# This is done with fct_reorder(), which has three arguments. f which is the factor whose levels will be modified. x, a numeric vector that is used to reorder the levels. Optionally, fun, a function that used if there are multiple values of x for each of value of f. The default value is the median

ggplot(relig, aes(tvhours, fct_reorder(relig, tvhours))) + geom_point() # The group that watches the most TV is those in the "I don't know" category. Hinduism and other eastern religions much the least amount of TV

# As more complicated transformations are made, its recommended to move them out of the aes() calls and into a separate mutate() function 

relig %>% mutate(relig = fct_reorder(relig, tvhours)) %>% ggplot(aes(x = tvhours, y = relig)) + geom_point()

# Creating a similar plot looking at how average age varies across reported income levels

rincome <- gss_cat %>% group_by(rincome) %>% summarise(age = mean(age, na.rm = TRUE), tvhours = mean(tvhours, na.rm = TRUE), n = n()) 
ggplot(rincome, aes(age, fct_reorder(rincome, age))) + geom_point() # Reordering the levels isn't useful here because rincome is already is sorted. However we can pull "Not applicable" to the front using fct_relevel()

# fct_relevel() takes a factor, f, and any number of levels to move to the front of the data set

ggplot(rincome, aes(age, fct_relevel(rincome, "Not applicable"))) + geom_point() # Not applicable probably has the highest age due to the fact the many people are retired and don't have any additional income 

# Additionally factors can be reordered by the y values associated with the largest x values

by_age <- gss_cat %>% filter(!is.na(age)) %>% group_by(age, marital) %>% count() %>% mutate(prop = n / sum(n))
ggplot(by_age, aes(age, prop, color = marital)) + geom_line(na.rm = TRUE)
ggplot(by_age, aes(age, prop, color = fct_reorder2(marital, age, prop))) + geom_line() + labs(color = "marital")

# For bar plots, fct_infreq() can be used to order levels in increasing frequency; this is the simplest type of reordering because it doesn't need any extra variables. Can be combined with fct_rev(), which reverse the order of factor levels

gss_cat %>% mutate(marital = marital %>% fct_infreq() %>% fct_rev()) %>% ggplot(aes(marital)) + geom_bar()

######################### Exercises #########################################################################################################
# 1. There are some suspiciously high numbers in tvhours. Is the mean a good summary?

gss_cat %>% count(tvhours) %>% arrange(desc(tvhours)) # By counting the data we see that there are individuals who report watching more than 16 hours of TV a day with some even claiming to watch TV 24 hours a day. Median may be a better indicator for actual hours watched
ggplot(gss_cat, aes(x = tvhours)) + geom_bar() # Bar chart supporting the conclusion above

# 2. For each factor in gss_cat identify whether the order of the levels is arbitrary or principled.

# Year. The levels are principled
# Marital. The levels are arbitrary
# Race. The levels are arbitrary
# rincome. The levels are principled
# partyid, The levels arbitrary with parties but can be principled with the intensity of how strongly they feel
# relig. The levels are arbitrary
# denom. The levels are arbitrary
# tvhours. The levels are principled

# 3. Why did moving “Not applicable” to the front of the levels move it to the bottom of the plot?

# The position of the levels are determined by the factor levels. 

##############################################################################################################################################

# Changing order is useful but being able to change or recede, change, the value of each level provides immense value. fct_recode() is useful for this

gss_cat %>% count(partyid) # The levels here are terse and not well written. They can be tweaked to be better written

gss_cat %>% mutate(partyid = fct_recode(partyid, "Republican, strong" = "Strong republican", "Republican, weak" = "Not str republican", "Independent, near rep" = "Ind,near rep", "Independent, near dem" = "Ind,near dem", "Democrat, weak" = "Not str democrat", "Democrat, strong" = "Strong democrat")) %>% count(partyid)

# fct_recode() will leave any levels that aren't explicitly mentioned as is, and it will warn you if you accidentally refer to a level that doesn't exist. To combine groups, you can assign multiple old levels to the same new level.

gss_cat %>% mutate(partyid = fct_recode(partyid, "Republican, strong" = "Strong republican", "Republican, weak" = "Not str republican", "Independent, near rep" = "Ind,near rep", "Independent, near dem" = "Ind,near dem", "Democrat, weak" = "Not str democrat", "Democrat, strong" = "Strong democrat", "Other" = "No answer", "Other" = "Don't know", "Other" = "Other party")) %>% count(partyid)

# Fct_collapse() is a variant of fct_recode() that used to collapse levels. For each new variable you provide a vector of old levels

gss_cat %>% mutate(partyid = fct_collapse(partyid, other = c("No answer", "Don't know", "Other party"), rep = c("Strong republican", "Not str republican"), ind = c("Ind,near rep", "Independent", "Ind,near dem"),dem = c("Not str democrat", "Strong democrat"))) %>% count(partyid)

# fct_lump() can be used to lump together all the small groups together. Used to simplify data

gss_cat %>% mutate(relig = fct_lump(relig)) %>% count(relig) # The default state of this code will lump the smallest groups together ensuring the aggregate is smaller than the largest group. It can use the n parameter to specify how many groups to keep

gss_cat %>% mutate(relig = fct_lump(relig, n = 10)) %>% count(relig, sort = TRUE) %>% print(n = Inf) # This excludes all groups expect the 10 largest ones

######################### Exercises ##########################################################################################################
# 1. How have the proportions of people identifying as Democrat, Republican, and Independent changed over time?

gss_cat %>% count(partyid) # We have 10 different levels. 3 of them are unrelated to what we're trying to find. We'll start by grouping them together

party <- gss_cat %>% mutate(partyid = fct_collapse(partyid, rep = c("Strong republican", "Not str republican"), dem = c("Not str democrat", "Strong democrat"), ind = c("Ind,near rep", "Independent", "Ind,near dem")))

party %>% filter(partyid %in% c("dem","ind","rep")) %>% group_by(year) %>% ggplot(aes(x = year, fill = partyid)) + geom_bar() # Stacked bar graph of partyid counts over the years
party %>% filter(partyid %in% c("dem","ind","rep")) %>% group_by(year) %>% ggplot(aes(x = year, fill = partyid)) + geom_bar(position = "dodge") # Grouped bar graph of partyid over the years
party %>% filter(partyid %in% c("dem","ind","rep")) %>% group_by(year, partyid) %>% summarise(total = n()) %>% mutate(props = total/ sum(total)) %>% ggplot(aes(x = year, fill = partyid)) + geom_col(aes(y = props))
# The The first two graphs above show the proportions of of party members by total number, however its hard to say how much the proportion actually changed throughout the years. With the third graph above we can that the proportions of party members remained relatively similar over the years with only slight fluctuations throughout the years 

# 2. How could you collapse rincome into a small set of categories

gss_cat %>% mutate(rincome = fct_lump(rincome, n = 5)) %>% count(rincome, sort = TRUE) # A quick way to make the groups smaller. However most likely not viable since important infomation may be lost

gss_cat %>% mutate(rincome = fct_collapse(rincome, Unknown = c("No answer", "Don't know", "Refused", "Not applicable"), `Less than 5000` = c("Lt $1000", "$1000 to 2999", "$3000 to 3999", "$4000 to 4999"), `Less than 10000` = c("$5000 to 5999", "$6000 to 6999", "$7000 to 7999", "$8000 to 9999"), `Less than 25000` = c("$10000 - 14999", "$15000 - 19999", "$20000 - 24999"), `$25000 or more` = "$25000 or more")) %>% count(rincome)
# The code above brings down the total number of levels from 16 to 5. While still providing a decent amount of information 
###############################################################################################################################################

# Chapter 12 is complete


