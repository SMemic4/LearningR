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
###############################################################################################################################################################
# Chapter 13: Dates and Times with lubridate
###############################################################################################################################################################
# Creating Date/Times

# There are three types of date.time data that refer to an instant in time:
# A date. Tibbles print this as <date>
# A time within a day. Tibbles print this as <time>
# A date-time is a date plus a time. It uniquely identifies an instant in time (typically to the nearest second). Tibbles print this as <dttm>. 

# R doesn't have a native class for storing times. If one is required use the HMS package

# Whenever working with any data, one should use the simplest one possible. This means using date instead of date-time if possible, due to date-times being substantially more complicated

# Use today() to get the current data

today()

# Use now() to get the current date AND time 

now()

# However, it is much more likely to form a date/time from either a string, date/time component, or from an existing date/time object

# Date.time data often comes as strings. One way of approaching them is is parsing strings. Another approach is to use lubridate
# Lubridate functions automatically work out the format once the order of the components is specified. To use them, arrange the order in which year, mont, and day appear in the dates, then arrange "y", "m", and "d" in the same order

ymd("2023-02-28")
mdy("February 28th 2023")
dmy("28-Feb-2023")

# All of these return the same output of "2023-02-28" which follows as year, month, day

# All of the functions above also take unquoted numbers. This is the most concise way to create a single date/time object

ymd(20230228)
mdy(02282023)
dmy(28022023)

# The previous functions can also be used to create dates. To create a date-time, add an under--score and one or more of "h", "m", and "s" to hte name of the parsing function

ymd_hms("2023-02-28 11:59:59") # Output is "2023-02-28 11:59:56 UTC" seems like the time zone default is UTC
mdy_hms("02/28/2023 11:59:59")
mdy_hm("02/28/2023 11:59")

# The creation of a date-time with a time zone can be forced by supplying a time zone:
ymd(20230106, tz = "EST")

# Sometimes when dealing with date times there will be individual components of the date-time spread across multiple columns 
# To create a date/time from this input use make_date() for dates or make_datetime() for date times

flights %>% select(year, month, day, hour, minute) %>% mutate(departure = make_datetime(year, month, day, hour, minute))

make_datetime_100 <- function(year, month, day, time){make_datetime(year, month, day, time%/%100, time%%100)}

flights_dt <- flights %>% filter(!is.na(dep_time), !is.na(arr_time)) %>% mutate(dep_time = make_datetime_100(year, month, day, dep_time), 
                                                                                arr_time = make_datetime_100(year, month, day, arr_time), 
                                                                                sched_dep_time = make_datetime_100(year, month, day, sched_dep_time), 
                                                                                sched_arr_time = make_datetime_100(year, month, day, sched_arr_time)) %>% select(origin, dest, ends_with("delay"), ends_with("time"))

# The datetime data can be used to visualize the distribution of departure times across the year:

flights_dt %>% ggplot(aes(dep_time)) + geom_freqpoly(binwidth = 86400) # 86400 seconds is equal to the equivalent of 1 day

# The data could also be used to look at the data for a single day

flights_dt %>% filter(dep_time <ymd(20130102)) %>% ggplot(aes(dep_time)) + geom_freqpoly(binwidth = 600) # 600 seconds is the equivalent of 10 minutes

# When using date-times in a numeric context, 1 means 1 seconds when using binwidths. So 86400 binwidths is equal to 86400 seconds or one day

# It is also possible to switch between a date-time and a date by using as_datetime() and as_date()

as_datetime(today())
as_date(today())

###############################################################################################################################################################
# Exercises
###############################################################################################################################################################
# 1. What happens if you parse a string that contains invalid dates

ymd(c("2010-10-10", "bananas")) # The string will fail to parse and will be unable to create a date time

# 2. What does the tzone argument to today() do? Why is it important?

today(tzone = "GMT") # The tzoone arguments specifies which time zone to put the current time in. Tzone automatically converts to the computers system timezone

# 3. Use the appropriate lubridate function to parse each of the following dates:

d1 <- "January 1, 2010"
d2 <- "2015-Mar-07"
d3 <- "06-Jun-2017"
d4 <- c("August 19 (2015)", "July 1 (2015)")
d5 <- "12/30/14" # Dec 30, 2014"

mdy(d1)
ymd(d2)
dmy(d3)
mdy(d4)
mdy(d5)

###############################################################################################################################################################
# Date-Time Components
###############################################################################################################################################################

# Accessor functions can be used to pull individual parts of the date. These include year(), month(), mday() (day of the month), yday() (day of the year), wday() (day of the week), hour(), minute(), and second()

datetime <- ymd_hms("2023-03-08 12:34:56")

year(datetime) # Returns 2023
month(datetime) # Returns 3
mday(datetime) # Returns 8
yday(datetime) # Returns 67 (Meaning this is the 67 day of the year)
wday(datetime) # Returns 4 (Meaning this is the fourth day of the week, meaning Sunday is the starting day)
hour(datetime) # Returns 12 
minute(datetime) # Returns 34
second(datetime) # Returns 56

# month() and wday() also have the label arguments that returns the abbreviated name for the month or day of the week. It also has the abbr function, which when set to false will return the full name
month(datetime, label = TRUE) # Returns "Mar"
month(datetime, label = TRUE, abbr = FALSE) # Returns "March

wday(datetime, label = TRUE) # Returns "Wed"
wday(datetime, label = TRUE, abbr = FALSE) # Returns "Wednesday"

flights_dt %>% mutate(wday = wday(dep_time, label = TRUE)) %>% ggplot(aes(x = wday)) + geom_bar() # A bar graph showing the count of the number of flights that left on each particular day of the week. A majority of flights left during the weekdays rather than the weekends

flights_dt %>% mutate(minute = minute(dep_time)) %>% group_by(minute) %>% summarize(avg_delay = mean(arr_delay, na.rm = TRUE), n = n()) %>% ggplot(aes(minute, avg_delay)) + geom_line() # Code shows that there is less of delay whenever a flight leaves between 20 through 40 minutes of an hour and also after 55

flights_dt %>% mutate(minute = minute(sched_dep_time)) %>% group_by(minute) %>% summarize(avg_delay = mean(arr_delay, na.rm = TRUE), n = n()) %>% ggplot(aes(minute, avg_delay)) + geom_line() # Code shows that there is less of delay whenever a flight leaves between 20 through 40 minutes of an hour and also after 55

# Such a pattern does not exist for schedule departure time

# An alternative approach to plotting individual components is to round the date to a nearby unit of time using the functions floor_date(), round_date(), and ceiling_date()
# Each of these functions takes a vector of dates to adjust and then the name of the unit to round down(floor), round up(ceiling), or round to

flights_dt %>% count(week = floor_date(dep_time, "week")) %>% ggplot(aes(week, n)) + geom_line()

# Accessor functions can also be used to set he components of a date/time

datetime <- ymd_hms("2023-03-10 12:34:56")
year(datetime) <- 2025
month(datetime) <- 10
hour(datetime) <- hour(datetime) + 3

# An alternative method that doesn't require multiple functions is update(). This allows for multiple values to be changed at once

update(datetime, year = 2020, month = 2, mday = 2, hour = 2) # Returns "2020-02-02 02:34:56 UTC"

# If the selected values are too large they will roll over into the next day

ymd("2023-02-01") %>% update(mday = 30) # Returns "2023-03-02"

ymd("2023-03-01") %>% update(hour = 3000) # Returns "2023-07-04 UTC"

# update() can be used to show the distribution of flights across the course of the day for every day of the year

flights_dt %>% mutate(dep_hour = update(dep_time, yday = 1)) %>% ggplot(aes(dep_hour)) + geom_freqpoly(binwidth = 300) # Setting large components of a date to a constant is a powerful technique that allows for exploration of patterns in smaller components 

###############################################################################################################################################################
# Exercises
###############################################################################################################################################################
# 1. How does the distribution of flight times within a day change over the course of the year? 

flights_dt %>% mutate(dep_hour = update(dep_time, yday = 1), month_num = as.factor(month(dep_time))) %>% ggplot(aes(dep_hour, color = month_num)) + geom_freqpoly(binwidth = 3600)

# Flight patterns seem relatively consistent, however it appears there are fewer flights during February 

# 2. Compare dep_time, sched_dep_time, and dep_delay. Are they consistent? Explain your findings.

flights_dt %>% select(dep_time, sched_dep_time, dep_delay) %>% mutate(real_dep_delay =(unclass(hour(dep_time))* 60 + unclass(minute(dep_time))) - (unclass(hour(sched_dep_time)*60 + unclass(minute(sched_dep_time))))) %>% filter(dep_delay != real_dep_delay) 

# Departure time and scheduled departure time and departure delay all seem relatively consistent with one another. Some of the data is inconsistent when the clocks switch over to the next day 

# 3. Compare air_time with the duration between the departure and arrival. Explain your findings. (Hint: consider the location of the airport.)

flights_dt %>% mutate(real_air_time = unclass(arr_time - dep_time), diiference = air_time - real_air_time)

# The difference between air time and actual time spent in air differs from one another in a majority of cases. Reasons is unknown so far

# 4. How does the average delay time change over the course of a day? Should you use dep_time or sched_dep_time? Why?

flights_dt %>% mutate(minute = minute(dep_time)) %>% group_by(minute) %>% summarise(depp_delay = mean(minute)) %>%  ungroup() %>% ggplot(aes(x = depp_delay, y = sched_dep_time)) + geom_point()

# 5. On what day of the week should you leave if you want to minimize the chance of a delay

flights_dt %>% mutate(day = wday(dep_time, label = TRUE)) %>% group_by(day) %>% summarize(average_delay = mean(dep_delay)) %>% ggplot(aes(x = day, y = average_delay)) + geom_col()

# Saturdays are the best day of the week for flights without a delay because they have the average lowest delay times. This makes sense due most individuals aren't travelling on saturdays

##############################################################################################################################################################
# Time Spans
###############################################################################################################################################################

# There are three important classes for representing time spans
# Durations, which represent an exact number of seconds
# Periods, which represent human units like weeks and months
# Intervals, which represent a starting and ending point

# In R, when subtracting two dates, a difftime object will be turned

x_age <- today() - ymd(19950101)
x_age # Returns "the difference of 10301 days"

# Difftime class objects record a time span of seconds, minutes, hours, days, or weeks. This ambiguity can make difftime objects difficult to work with. Lubridate provides an alternative that always uses seconds - the durations

as.duration(x_age) # Returns "890006400s (~28.2 years)" 

# Durations come with useful constructors

dseconds(15) # Returns "15s"
dminutes(600) # Returns "600s (~10 minutes)"
dhours(c(12,24)) # Returns "43200s (~12 hours)" "86400s (~1 days)" 
ddays(0:5) # Returns "86400s (~1 days)"  "172800s (~2 days)" "259200s (~3 days)" "345600s (~4 days)" "432000s (~5 days)"
dweeks(3) # Returns "1814400s (~3 weeks)"
dyears(1) # Returns "31557600s (~1 years)"

# Durations always record the time span in seconds. Larger units are created by converting minutes, hours, days, weeks, and years to seconds 

# Durations can be added and multiplied

2 * dyears(2) # "126230400s (~4 years)"
dyears(1) + dweeks(32) + ddays(24) # Returns "52984800s (~1.68 years)"

# Durations can be add and subtracted to and from days

tomorrow <- today() + ddays(1)
last_year <- today() - dyears(1)

# One issue with durations is adding a days worth of seconds to it may result in the wrong amount of seconds being added due to time zones

one_pm <- ymd_hms("2022-03-12 13:00:00", tz = "America/New_York")
one_pm # Returns "2022-03-12 13:00:00 EST"
one_pm + ddays(1) # Returns "2022-03-13 14:00:00 EDT" 

# To address this issue, lubridate provides periods. Periods are time spans but don't have a fixed length in seconds; instead it works with "human" time such as days and months. Allowing for a more intuitive approach

one_pm # Returns "2022-03-12 13:00:00 EST"
one_pm + days(1) # Returns "2022-03-13 13:00:00 EDT"

# Like durations, periods can be created with a number of constructor functions

seconds(20) # Returns "20S"
minutes(10) # Returns "10M 0S"
hours(c(12, 24)) # Returns "12H 0M 0S" "24H 0M 0S"
days(7) # Returns "7d 0H 0M 0S"
months(1:6) # Returns "1m 0d 0H 0M 0S" "2m 0d 0H 0M 0S" "3m 0d 0H 0M 0S" "4m 0d 0H 0M 0S" "5m 0d 0H 0M 0S" "6m 0d 0H 0M 0S"
weeks(4) # Returns "28d 0H 0M 0S"
years(2) # Returns "2y 0m 0d 0H 0M 0S"

# Periods can be added and multiplied 

10 * (months(7) + days(1)) # Returns "70m 10d 0H 0M 0S"
days(50) + hours(25) + minutes(2) # Returns "50d 25H 2M 0S"

# Periods can be added to dates. Compared to durations, periods are more likely to act in an expected way (such as with leap years and daylight savings time)
# Leap year
ymd("2016-01-01") + dyears(1) # Returns "2016-12-31 06:00:00 UTC"
ymd("2016-01-01") + years(1) # Returns "2017-01-01"

flights_dt %>% filter(arr_time < dep_time) # Within this date there are planes that arrive at their destinations before they depart from their origin. This is due to these flights be overnight flights 

# These overnight flights can be corrected by adding a day to the arrival time of each overnight flight

flights_dt <- flights_dt %>% mutate(overnight = arr_time < dep_time, arr_time = arr_time + days(overnight * 1), sched_arr_time = sched_arr_time + days(overnight * 1)) # This code works due to how R handles FALSE values as numeric values. A FALSE carries a numeric value of zero while true carries a value of 1
flights_dt %>% filter(arr_time < dep_time) # The error has been corrected

dyears(1) / ddays(365) # Returns 1.000685
years(1) / days(1) # Returns 365.25

# Depending on the year the number could change between 365 to 366 depending on if it's a leap year or not. To obtain an accurate measurement, use an interval. An interval is a duration with a starting point; that makes it precise measurement

next_year <- today() + years(1)
(today() %--% next_year) / ddays(1) # Returns 366 because 2024 is a leapyear

# To find out how many periods fall into an interval, integer division must be used

(today() %--% next_year) %/% days(1) # Returns 366

###############################################################################################################################################################
# Exercises
###############################################################################################################################################################
# 1.  Why is there months() but no dmonths()?

# There is no dmonths() because all months vary in the amount of days they have and thus would differ in the total amount of seconds, unlike  

# 2. Explain days(overnight * 1) to someone who has just started learning R. How does it work?

# It works due to how R assigns numeric values to TRUE/FALSE values. TRUE is assigned a value of one while false is assigned a value of 0

# 3. Create a vector of dates giving the first day of every month in 2015. Create a vector of dates giving the first day of every month in the current year

ymd("2015-01-01") + months(0:11) # Vector for first day on every month in 2015

floor_date(today(), unit = "year") + months(0:11) # A vector that returns the first day of every month in current year

# 4. Write a function that when given a birthday (as a date), returns how old an individual is in years

age <- function(birthday){(birthday %--% today()) %/% years(1)}
age(ymd("1990-01-01"))

###############################################################################################################################################################



