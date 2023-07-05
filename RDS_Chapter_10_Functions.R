####################################################################################################################################################################
# Chapter 10: Functions
####################################################################################################################################################################
# Functions
####################################################################################################################################################################
# Writing functions is a core activity of R
# Functions are often used to encapsulate a sequence of expressions that need to be executed numerous times, perhaps under slightly different conditions
# Writing a function allows a developer to create an interface to the code, that is explicitly specified with a set of parameters 
# This interface provides an abstraction of the code to potential users

####################################################################################################################################################################
# Functions in R 
####################################################################################################################################################################
# Functions in R are "first class objects", which means they can be treated much like any other R object. Importantly
# Functions can be passed as arguments to other functions. This is useful for the various apply functions, like lapply() and sapply()
# Functions can be nested, so that a function can be defined inside of another function

####################################################################################################################################################################
# First Function
####################################################################################################################################################################
# Functions are defined using the function() directive and are stored as R objects just like anything else. In particular, they are R objects of class "function"
# A simple function that takes no arguments and does nothing

f <- function(){
  # This is an empty function
}

# Functions have their own class

class(f) # "Function"

# Executing this function

f() # NULL

# Functions can be created with a non-trivial function body

f <- function(){
  print("Function was called")
}
f() # "Function was called"

# The last aspect of a basic function is the function arguments 
# Function arguments are options that can be specified to the user that the user may explicitly set
# For this basic function, an argument can be added that determines how many times the function is executed and printed to the console

f <- function(num){
  for(i in seq_len(num)){
    cat("Function was called\n")
  }
}
f(5)

# It there is a lot of cutting and pasting, that's usually a good sign that a function should be written
# Finally, the function above doesn't return anything, It just prints the statement, however it is useful if a function returns something that perhaps that can be fed into another section of code
# This next function returns the total number of characters printed to the console

f <- function(num){
  state <- "Function was called\n"
  for(i in seq_len(num)){
    cat(state)
  }
  chars <- nchar(state) * num
  chars
}
f(3)

# In the above function, nothing needs to be indicated for the function to return the number of characters
# In R, the return value of a function is always the very last expression that is evaluated 
# Because the chars variable is the last expression that is evaluated in this function, that becomes the return value of the function
# Note that there is a return() function that can be used to return an explicitly value from a function, but it is rarely used in R 
# Finally, the above function, the user must specify the value off the argument num. If it is not specified by the user, R will throw an error

f() # Error in f() : argument "num" is missing, with no default

# We can modify this behavior by setting a default value for the argument num
# Any function argument can have a default value, if wish to be specified 
# Sometimes, argument values are rarely modified (except in special cases) and it makes sense to set a default value for that argument
# This relieves the user from having to specify the value of that argument every single time the function is called
# For example, the default value for num can be set to 1, so that if the function is called without the num argument being explicitly specified

f <- function(num = 1){
  state <- "Function was called\n"
  for(i in seq_len(num)){
    cat(state)
  }
  chars <- nchar(state) * num
  chars
}
f() # uses the default value for "num"
f(2) # Uses the user-specified value 

# This function has one formal argument named num with a default value of 1. The formal arguments are the arguments included in the function definition
# The formals() function returns a list of all the formal arguments of a function

formals(f) # $num 1

# Functions have named arguments, which can optionally have default values. All function arguments have names, they can be specified using their name

f(num = 2)

# Specifying an argument by its name is sometimes useful if a function has many arguments and it may not always be clear which argument is being specified
# However the function above only has one argument then there's no confusion

####################################################################################################################################################################
# Argument Matching
####################################################################################################################################################################
# Calling an R function with arguments can be done in a variety of ways
# R function arguments can be matched positionally or by name
# Positional matching just means that R assigns the first value to the first argument, the second value to second argument

str(rnorm) # function (n, mean = 0, sd = 1) 
mydata <- rnorm(100, 2, 1) # Generating some data
mydata

# 100 is assigned to the n argument, 2 is assigned to the mean argument, and 1 is assigned to the sd argument, all by positional matching
# The following calls to the sd() function (which computes the empirical standard deviation of a vector of numbers) are all equivalent
# Note that sd() has two arguments: x indicates the vector of numbers and na.rm is a logical indicating whether missing values should be removed or not

str(sd) # function (x, na.rm = FALSE)  

# Positional match first argument, default for na.rm

sd(mydata) # 0.873495

# Specifying the 'x' argument by name, default for 'na.rm'

sd(x = mydata) # 0.873495

# Specifying both arguments by name

sd(x = mydata, na.rm = FALSE) # 0.873495
 
# When specifying the function arguments by name, it doesn't matter what order they are specified in

sd(na.rm = FALSE, x = mydata) # 0.873495

# Positional matching can be mixed with matching by name
# When an argument is matched by name, it is "taken out" of the argument list and the remaining unnamed arguments are matched in the order that they are listed in the function definition

sd(na.rm = FALSE, mydata) # 0.873495

# In the case above, the mydata object is assigned to the x argument, because it's the only argument not yet specified
# Below is the argument list for the lm() function, which fits linear models to a dataset

args(lm) # function (formula, data, subset, weights, na.action, method = "qr", model = TRUE, x = FALSE, y = FALSE, qr = TRUE, singular.ok = TRUE, contrasts = NULL, offset, ...

# The following two calls are equivalent

lm(data = mydata, y ~ x, model = FALSE, 1:100)
lm(y ~ x, mydata, 1:100, model = FALSE)

# It's is generally best to avoid messing around with the order of the arguments too much, since it can lead to confusion
# Named arguments are useful on the command line when the argument list is long and one wants to use the default for everything except for an argument near the end of the list
# Named arguments are useful if one can remember the name but not the position of the argument 
# Function arguments can also be partially matched. The order of operations when given an argument is:
# 1. Check for exact match
# 2. Check for a partial match
# 3. Check for a positional match

# Partial matching should be avoided when writing longer code or programs, because it can lead to confusion when reading the code
# However partial matching is useful when calling functions interactively that have very long argument names
# In addition to not specifying a default value, an argument value can be set to NULL

f <- function(a, b = 1, c = 2, d = NULL) {
}

####################################################################################################################################################################
# Lazy Evaluation
####################################################################################################################################################################
# Arguments to functions are evaluated lazily, so they are evaluated only as needed in the body of the function
# In this example, the function() has two arguments: a and b

f <- function(a, b){
  a^2
}
f(2) # 4

# The function never actually uses the argument b, so calling f(2) will not produce an error because the 2 gets positionally matched to a
# This behavior can be good or bad. It's common to write a function that doesn't use an argument and not notice it simply because R never throws an error 
# This example also shows lazy evaluation at work, but does eventually result in an error

f <- function(a, b){
  print(a)
  print(b)
}
f(45) # Error in print(b) : argument "b" is missing, with no default

# Notice that "45" got printed first before the error was triggered. This is because b did not have to be evaluated until after print(a)
# Once the function tried to evaluate print(b) the function had to throw an error

####################################################################################################################################################################
# The ... Argument
####################################################################################################################################################################
# There is a special argument in R known as the ... argument, which indicates a variable number of arguments that are usually passed on to other functions
# The ... argument is often used when extending another function and one does not want to copy the entire argument list of the original function
# For example, a custom plotting function may want to make use of the default plot() function along with its entire argument list. 
# The function below changes the default for the type argument to the value type = "1"" (the original default was type = "p")

myplot <- function(x, y, type = "1", ...){
  plot(x, y, type = type, ...) # Pass "..." to plot function
}

# Generic functions use ... so that extra arguments can be passed to methods

mean # function (x, ...) UseMethod("mean") <bytecode: 0x0000014781c73a20> <environment: namespace:base>

# The ... argument is necessary when the number of arguments passed to the function cannot be known in advance. This is clear in functions like paste() and cat()

args(paste) # function (..., sep = " ", collapse = NULL, recycle0 = FALSE) 
args(cat) # function (..., file = "", sep = " ", fill = FALSE, labels = NULL, append = FALSE) 

# Because both paste() and cat() print out text to the console by combining multiple character vectors together, it is impossible for the function to know in advance how many character vectors will be passed

####################################################################################################################################################################
# Arguments Coming After the ... Argument 
####################################################################################################################################################################
# One catch with ... is that any arguments that appear after ... on the argument list must be named explicitly and cannot be partially matched or matched positionally
# For example, look at the paste() function

args(paste) # function (..., sep = " ", collapse = NULL, recycle0 = FALSE) 

# With the paste() function, the arguments sep and collapse must be named explicitly and in full if the the default values are not going to be used 
# Here it is specified "a" and "b" should be pasted together and separated by a colon

paste("a", "b", sep = ":") # "a:b"

# Not specifying the sep argument in full results in partial matching and provides an unexpected result

paste("a", "b", se = ":") # "a b :"

####################################################################################################################################################################
# Summary
####################################################################################################################################################################
# Functions can be defined using the function() directive and are assigned to R objects just like any other R object
# Functions can be defined with named arguments; these function arguments can have default values
# Functions arguments can be specified by name or by position in the argument list
# Functions always return the last expression evaluated in the function body
# A variable number of arguments can be specified using the special ... argument in a function definition 
