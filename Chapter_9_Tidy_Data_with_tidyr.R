library(tidyverse)
library(ggplot2)
library(dplyr)

table1 %>% mutate(rate = cases / population * 10000) # Computes the rate per 10,000

table1 %>% count(year, wt = cases) # wt stands for "weight" use argument wt to perform a weighted count

ggplot(table1, aes(year, cases)) + geom_line(aes(group = country), color = "grey21") + geom_point(aes(color = country))

# Exercises 
# Extract the number of TB cases per country per year
# Extract the mathcing population per country per year
# Dive cases by population and multiply by 10,000

table2 %>% group_by(country, year) %>% mutate(rate = cases / population * 10000)

table2 %>% transmute(country, year, TB = select(type = "1999"), population = select(type = ""))
table2 %>% group_by(country) %>% summarise()

t2_cases <- filter(table2, type == "cases") %>% rename(cases = count) %>% arrange(country, year)
t2_population <- filter(table2, type == "population") %>% rename(population = count) %>% arrange(country, year)
t2_cases_per_cap <- tibble(year = t2_cases$year, country = t2_cases$country, cases = t2_cases$cases, population = t2_population$population) %>% mutate(cases_per_cap = (cases/population) * 10000) %>% select(country,year, cases_per_cap) # The $ operator is used to extract or subset a specific part of a data object in R

year_case <- tibble(country = table4a$country, year = "1999", cases = table4a$`1999`, population = table4b$`1999`)
year_pop <- tibble(country = table4a$country, year = "2000", cases = table4a$`2000`, population = table4b$`2000`)
year_casepop <- bind_rows(year_case, year_pop)
year_casepop <- year_casepop %>% arrange(country, year) %>% mutate(rate = cases / population * 10000) 

table4a
tidy4a <- table4a %>% gather(`1999`, `2000`, key = "year", value = "cases")
tidy4b <- table4b %>% gather(`1999`, `2000`, key = "year", value = "population")
left_join(tidy4a, tidy4b)

spread(table2, key = "type", value = "count")

stocks <- tibble(year = c(2015, 2015, 2016, 2016), half = c( 1, 2, 1, 2), return = c(1.88, 0.59, 0.92, 0.17)) 
stocks %>% spread(year, return) %>% gather("year", "return", `2015`, `2016`)

table3 %>% separate(rate, into = c("cases", "population"))
table3 %>% separate(rate, into = c("cases", "population"), sep = "/")

table3 %>% separate(rate, into = c("cases", "population"), convert = TRUE)

table3 %>% separate(year, into = c("century", "year"), sep = 2)

table5 %>% unite(new, century, year)

table5 %>% unite(new, century, year, sep = "")


