library(tidyr)
library(dplyr)
library(ggplot2)
library(tidyverse)
library(nycflights13)
library(Lahman)
library(ggstance)
library(lvplot)
library(ggbeeswarm)
library(heatmaply) # There's also d3heatmap but I can install it on this version of R
library(hexbin)
library(modelr)

as_tibble(iris)

tibble(x = 1:5, y = 1, z = x ^ 2 + y)

tb <- tibble(':)' = "smile", ' ' = "space", '2000' = 'number')
tb

tribble(
  ~x, ~y, ~z,
  #--/--/----
  "a", 2, 3.6,
  "b", 1, 8.5
)

tibble(a = lubridate::now() + runif(1e3) * 86400, b = lubridate::today() + runif(1e3) * 30, c = 1:1e3, d = runif(1e3), e = sample(letters, 1e3, replace = TRUE))

nycflights13::flights %>% print(n = 10, width = Inf)

df <- tibble(x = runif(5), y = rnorm(5))

df$x # Extracts the column by name using "s"
df[[1]] # Extracts the column by position

df %>% .$y # Extracts by name using pipe. When using pipe with a tibble you must use the special placeholder "."
df %>% .[["y"]]

df <- tibble(abc = 1, xyz = "a")

df$x
df[["xyz"]]
df[["abc"]]


var <- "mpg"

as_tibble(mtcars)[var]


annoying <- tibble(`1` = 1:10,`2` = `1` * 2 + rnorm(length(`1`)))
annoying$`1`
ggplot(annoying, aes(`1`, `2`)) + geom_point()
ggplot(annoying, aes(x = annoying$'1', y = annoying$'2')) + geom_point()
annoying <- annoying %>% mutate(`3` = `2`/`1`)
annoying %>% rename(one = `1`, two = `2`, three = `3`)
tibble::enframe(annoying)


