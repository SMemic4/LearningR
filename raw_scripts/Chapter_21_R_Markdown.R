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
library(gt)
library(ggthemes)
library(rmarkdown)

#################################################################################################################################################################################
# Chapter 21: R Markdown
#################################################################################################################################################################################
# Introduction 
#################################################################################################################################################################################
# R markdown provides a unified authroing framework for data science, combining code, it's results, and your prose commentary
# R markfown documents are fully reproducible and support dozens of output formats, like PDFs word files, slideshows, and more

# R markdown files are designed to be used in three ways:
# 1. Focusing and communicating on the conclusions and not the code behind the analysis
# 2. For collaboration with others who are interested in the conclusions and how they were reached (code)
# 3. Provides an enviroment that captures the results and thoughts behind the analysis 

# R markdown integrates a number of R packages and external tool
#################################################################################################################################################################################
# R Markdown Basics
#################################################################################################################################################################################
# An R markdown file, is a plain text file that has the extension .Rmd

# Rmd files contain three important types of content:
# 1. An (optional) YAML header surrounded by ---s
# 2. Chunks of R code surrounded by ```
# Text mixed with simple text formatting like # heading and _italics_

# When opening an .Rmd a notebook interface appears where code and output are interleaved. Code chunks can be ran by clicking the Run icon or pressing Cmd/Crt-Shift-Enter
# To produce a complete report containing all text, code, and results, click "knit" or press ctrl-shift-k. This can be done programmatically with rmarkdown::render("1-example.Rmd")
# This displays the report in the viewer pane, and creates a self-contained HTML file that can e shared with others

# When a document is knit, the R markdown file sends the .Rmd file to knitr, which executes all of the code chunks and creates a new Markdown (.md) document that includes the code and its output
# The Markdown file generated by knitr is then processed by pandoc, which is responsible for creating the finished file. The two step workflow allows the the creation of a very wide range of output formats
# Workflow: RMD -> knitr -> md -> pandoc -> finished file

# A .Rmd file can be created by going to File -> New File -> R Markdown in the menu bar

#################################################################################################################################################################################
# Text Formatting with Markdown
#################################################################################################################################################################################
# Prose in .RMD files is written in Markdown, a lightweight set of conventions for matting plain-text files
# markdown is designed to be easy to read and easy to write.

#################################################################################################################################################################################
# Code Chunks
#################################################################################################################################################################################
# To run code inside an R markdown document, there needs to be a chunk
# There are three ways to insert a chunk
# 1. The keyboard shortcut Cmd/Ctrl-Alt-I
# 2. The "insert" button icon in the editor toolbar
# 3. By manually typing the chunk delimiters ```{r}```
# Running the code is done the same way as always (Ctrl/Shift_Enter). This will run all of the code in a chunk
# Chunks should be relatively self-contained, and focused around a single task
#################################################################################################################################################################################
# Chunk Name
#################################################################################################################################################################################
# Chunks can be given an optional name ```{r by-name}```. This provides three advantages:
# 1. It is much easier to navigate to specific chunks using the drop-down code navigator in the bottom-left of the script editor
# 2. Graphics produced by the chunks will have useful names that make them easier to use elsewhere
# 3. A network of cached chunks can be set up to avoid re-performing expensive computations on every run

# There is one chunk name that imbues special behavior: setup
# When in notebook mode, the chunk named setup will be run automatically once, before any other code is run

#################################################################################################################################################################################
# Chunk Options
#################################################################################################################################################################################
# Chunk output can be customized with options, arguments supplied to the chunk header
# knitr provides almost 60 options that you can be used to customize code chunks
# The following set of options are the most important and control is a code block is executed and what results are inserted in the finished report

# eval = FALSE prevents code from being evaluated. This is useful for displaying example code, or for disabling a large block of code without commenting each line 
# include = FALSE runs the code, but doesn't show the code or results in the final document. Use this for setup code that shouldn't clutter the final report
# echo = FALSE prevents code, but not the resulting from appearing in the finished file. Use this when writing reports aimed at people who don't understand underlying R code
# message = FALSE FALSE or warning = FALSE prevents messages or warning from appearing in the finished file 
# results = 'hide' hides printed output; fig.show = 'hide' hides plots
# error = TRUE causes the render to continue even if code returns an error. This is rarely used but can be useful in debugging the .Rmd file. The default error = TRUE causes knitting to fail if there is a single error in the decoument 

#################################################################################################################################################################################
# Table
#################################################################################################################################################################################
# By default, R markdown prints data frames and matrices as seen in the console

mtcars[1:5, 1:10]

# To display data with additional formatting there is the knitr::kable function()

knitr::kable(mtcars[1:5, 1:10], caption = "A knitr kable")

# Read the documentation for ?knitr::kable to understand more of the customization options
# For deeper customization consider the "xtable", "stargazer", "pander", "tables", and "ascii" packages. Each provides a set of tool for returning formatted tables from R code
# install.packages("xtable")
# install.packages("stargazer")
# install.packages("pander")
# install.packages("tables")
# install.packages("ascii")

#################################################################################################################################################################################
# Caching
#################################################################################################################################################################################
# Normally, each knit of a document starts from a completely clean slate. This is great for reproducibility, because it ensures every computation in the code was captured
# However, it can slow down the processing of the program if the computations are complex and take a long time to solve
# The solution is using cache = TRUE. 
# When set, this will save the output of the chunk to a specially named file on disk. On subsequent runs, knitr will check to see if the code has changed, and if it hasn't it will reuse the cached results
# The caching system must be used with care, because by default it is based on the code only, not its dependencies.
# This problem can be avoid be using the dependson = "raw_data" option
# dependson should contain a character vector of every chunk that the cached chunk depends on. knitr will update the results for the cached chunk whenever it detects that one its dependencies has changed
# Chunks won't update if a file changes, because knitr caching only tracks changes within the .RMd file. 
# To track changes to a file use the cache.extra option. This is an arbitrary R expression that will invalidate the cache whenever it changes
# A good function to use is file.info(): it returns a bunch of information about the file including the last time it was modified 
# As caching strategies become progressively more complicated it's a good idea to regular clear out caches with knitr::clean_cache()
#################################################################################################################################################################################
# Global Options
#################################################################################################################################################################################
# As more work is done with knitr, one will realize that the default  chunk options don't fit ones needs and should be changed this is done by calling knitr::opts_chunk$set() in a code chunk

#################################################################################################################################################################################
# Inline Code
#################################################################################################################################################################################
# There is another way to embed R code into an R Markdown document: directly into the text, with `r`
# This is useful if the properties of the data are mentioned the text

# For example: 
# We have data about `r nrow(diamonds)` diamonds. Only `r
# nrow(diamonds) - nrow(smaller)` are larger than 2.5 carats. The
# distribution of the remainder is shown below:

# Becomes:
# We have data about 53940 diamonds. Only 126 are larger than 2.5
# carats. The distribution of the remainder is shown below:

# When inserting number into text, format() is a useful tool.
# format() allows the specification of the number of digits to be printed, and the argument big.mark is used to make numbers easier to read

#################################################################################################################################################################################
# YAML Header
#################################################################################################################################################################################
# The settings of the "whole document" can by changed by setting the parameters of the YAML header
# There are two settings that can be changed; document parameters and bibliographies

#################################################################################################################################################################################
# Parameters
#################################################################################################################################################################################
# R markdown documents can include one or more parameters whose values can be set when rendering the report
# parameters are useful when re-render the same report with distinct values for various key inputs
# To declare one or more parameters use the params field
# Parameters are available within the code chunks as a read_only list named params
# Atomic vectors can be written directly into the YAML header. This is a good way to specify date/time parameters
# Within R studio, clicking the "Knit with Parameters" option in the Knit drop-down menu to set parameters, render, and preview the report in a single user friendly step
# Alternatively to produce many such parameterized reports use, rmarkdown::render() with a list of params:
#################################################################################################################################################################################
# Bibliographies and Citations
#################################################################################################################################################################################
# Pandoc can automatically generate citations and a bibliography in a a number of styles. 
# To use this feature, specify a bibliography file using the bibliography field in the file's header. The field should contain a path from the directory that contains both the .RMD file and the bibliography file
# Many common bibliography formats including Biblatex, bibtex, endnote, and medline can be used
# To create a citation with the .RMD file, use a key composed of "@" and the citation identifier from the bibliography file. Then place the citation in square brackets
# When R markdown renders your file, it will build and append a bibliography to the end of your document
# The bibliography will contain each of the cited references from the bibliography file, but will not contain a section heading
# As a s result it is common practice to end the file with a section header for hte bibliography


