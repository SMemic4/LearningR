####################################################################################################################################################################
# Chapter 11: Scoping Rules of R
####################################################################################################################################################################
# A Diversion on Binding Values to Symbol
####################################################################################################################################################################
# How does R know which value to assign to which symbol?

lm <- function(x){x * x}
lm # function(x){x * x}

# When R tries to bind a value to a symbol, it searches through a series of environments to find the appropriate value 
# When working on the command line and the value of an R object needs to be retrieved, the order is roughly:
# 1. Search the global environment (workspace) for a symbol name matching the one requested
# 2. Search the namespaces of each of the packages on the search list 
# The search list can be found by using the search() function:

search() # ".GlobalEnv"        "package:readxl"    "package:ggthemes"  "package:knitr"     "package:forcats"   "package:stringr"   "package:dplyr"     "package:purrr"     "package:readr"

# The global environment or the user's workspace is always the first element of the search list and the base packages are always last
# For better or for worse, the order of the packages on the search list matters, particularly if there are multiple objects with the same name in different packages
# Users can configure which packages get loaded on start up so if a function (or package) is written, it cannot be assumed that there will be a set list of packages available in a given order
# When a user loads a package with library() the namespace of that package gets put in position 2 of the search list (by default) and everything else gets shifted down the list 
# Note that R has separate namespaces for functions and non-functions so it's possible to have an object named c and a function named c()

####################################################################################################################################################################
# Scoping Rules
####################################################################################################################################################################
# The scoping rules for R are the main feature that make it different from the original S language. It may seem like an esoteric aspect of R but its one of the more interesting and useful feature
# The scoping rules of a language determine how a value is associated with a free variable in a function
# R uses lexical scoping or static scoping
# An alternative to lexical scoping is dynamic scoping which is implemented by some languages. Lexical scoping turns out to be particularly useful for simplifying statistical computations

# Related to the scoping rules is how R uses the search list to bind a value to a symbol. Consider the following function

f <- function(x, y){
  x^2 + y / z
}

# This function has 2 formal arguments x and y. In the body of the function there is another symbol z. In this case z is called a free variable 
# The scoping rules of a language determine how values are assigned to free variables. Free variables are not formal arguments and are not local variables (assigned inside the function body)
# Lexical scoping in R means that the values of free variables are searched for in the environment in which the function was defined 
# An environment is a collection of (symbol, value) pairs, in example, x is a symbol and 3.14 might be it's value
# Every environment has a parent environment and it is possible for an environment to have multiple "children". The only environment without a parent is the empty environment
# A function, together with an environment, makes up what is called a closure or function closure. 
# The function closure model can be used to create functions that "carry around" data with them
# How do is a value associated to a free variable? There is a search process that occurs that goes as follows:
# If the value of a symbol is not found in the environment in which a function was defined, then the search is continued in the parent environment
# The search continues down the sequence of parent environments until it hits a top-level environment; this is usually the global environment (workspace) or the namespace of a package
# After the top-level environment, the search continues down the search list until it hits an empty environment 
# If a value for a given symbol cannot be found once the empty environment is arrived at, then an error is thrown
# One implication of this search process is that it can be affected by the number of packages attached to the search list
# The more packages attached to the list, the more symbols R has to sort through in order to assign a value
# That said, a large number of packages would have to be attached in the search list to notice a real difference in performance

####################################################################################################################################################################
# Lexical Scoping: Why Does it Matter?
####################################################################################################################################################################
# typically, a function is defined in the global environment, so that the values of free variables are just found in the user's workspace.
# This is the most common and logical behavior for most people
# However, in R functions can be defined inside other functions. IN this case the environment in which a function is defined in the body of another function
# The following example, is a function that returns another function as its return value. Remember, in R functions are treated like any other object so this is valid

make.power <- function(n){
  pow <- function(x){
    x^n
  }
  pow
}

# The make.power(0 function is a kind of "constructor function" that can be used to construct other functions 

cube <- make.power(3)
square <- make.power(2)
cube(3) # 27
square(2) # 4

# Taking a look at the cube() function's code

cube # function(x){x^n} <bytecode: 0x00000147a5fd2738> <environment: 0x00000147a5e55c88>

# Notice that cube() has a free variable n. What is the value of n here? Well its value is taken from the environment where the function was defined 
# When cube() was defined, make.power() was called with a value of 3, so the value of n at that time was 3
# The environment of a function of objects can be explored to find their values

ls(environment(cube)) # [1] "n"   "pow"
get("n", environment(cube)) # 3 

# Looking at the square() function

ls(environment(square)) # [1] "n"   "pow"
get("n", environment(square)) # 2

####################################################################################################################################################################
# Lexical vs. Dynamic Scoping
####################################################################################################################################################################
# The following example demonstrates the difference between lexical and dynamic scoping rules 

y <- 10

f <- function(x){
  y <- 2
  y^2 + g(x)
}

g <- function(x){
  x * y
}
f(3) # 34

# With lexical scoping the value of y in the function g is looked up in the environment in which the function was defined, in this case the global environment, so the value of y is 10
# With dynamic scoping, the value of y is looked up in the environment from which the function was called (sometimes referred to as the calling environment)
# In R the calling environment is known as the parent frame. In this case, the value of y would be 2 

# When a function is defined in the global environment and is subsequently called from the global environment, then the defining environment and the calling environment are the same
# This can sometimes can give the appearance of dynamic scoping

g <- function(x){
  a <- 3
  x + a + y # y is a free variable
}
rm(y)
g(2) # Error in g(2) : object 'y' not found
y <- 3
g(2) # 8

# Here, y is defined in the global environment, which also happens to be where the function g() is defined
# There are numerous other languages that support lexical scoping including Scheme, Perl, Python, Lisp

# Lexical scoping in R has consequences beyond how free variables are looked up. In particular, it's the reason that all objects must be stored in memory in R
# This is because all functions must carry a pointer to their respective defining environments, which could go anywhere

####################################################################################################################################################################
# Summary
####################################################################################################################################################################
# Objective functions can be "built which contain all of the necessary data for evaluating the function"
# Code can be simplified and cleaned up
