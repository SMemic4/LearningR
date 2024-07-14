####################################################################################################################################################################
# Chapter 9: Control Structures
####################################################################################################################################################################
# Control Structures
####################################################################################################################################################################
# Control structures in R allow for the flow of execution of a series of R expressions to be controlled 
# Control structure allows logic to be put in the code, rather than executing the same R code every time
# Control structures allow for one to respond to inputs or to features of the data and execute different R expressions accordingly

# Commonly used control structures are:
# • if and else: testing a condition and acting on it
# • for: execute a loop a fixed number of times
# • while: execute a loop while a condition is true
# • repeat: execute an infinite loop (must break out of it to stop)
# • break: break the execution of a loop
# • next: skip an iteration of a loop

# Most control structures are not used in interactive sessions, but rather when writing functions or longer expressions
# However, these constructs do not have to be used in functions and it's a good idea to become familiar with them before delving into functions

####################################################################################################################################################################
# if-else
####################################################################################################################################################################
# The if-else combination is probably the most commonly used control structure in R
# This structure allows for a condition to be tested and acted upon on whether it's true of false

x = 2
if(x == 2){
  print("True")
} 

# The code above does nothing if the condition is false but executes the body if the condition is true
# Additional action can be executed when the condition is false, thus an else clause is needed

x = 3 
if(x == 2)
{
  print("If clause")
}else{
  print("Execute else statmenet")
}

# A series of tests can be followed by the initial if with any number of else ifs

if(condition1) {
  ## do something
} else if(condition2) {
  ## do something different
} else {
  ## do something different
}

# Here is an example of a valid if/else structure

x <- runif(1, 0, 10)
x # 4.267266
if(x > 3) {
  y <- 10
} else {
  y <- 0
}
y # 10

# The value of y is set depending on whether x > 3 or not. This expression can also be written a different, but equivalent in R

y <- if(x > 3)
{
  10
}else{
  0
}

# Neither way of wiring the expression is more correct than the other
# Of course, the else clause is not necessary. A series of if clauses can be created if their respective conditions are true

if(condition1) {
  # Code 1
}
if(condition2) {
  # Code 2
}

####################################################################################################################################################################
# for Loops
####################################################################################################################################################################
# For loops are pretty much the only looping construct that will be needed in R 
# In R, for loops take an iterator variable and assign it successive values from a sequence or vectors
# For loops are most commonly used for iterating over the elements of an object (list, vector, etc.)

for(i in 1:10)
{
  print(i)
}

# This loop takes the i variable and in each iteration of the loop gives it values 1,2,3,...,10, executes the code within the curly braces, and then the loop exits
# The following three loops all have the same behavior: 

x <- c("a", "b", "c", "d")

for(i in 1:4){
  print(x[i])
}

# The seq_along() function is commonly used in conjunction with for loops in order to generate an integer sequence based on the length of an object

for(i in seq_along(x)) # Generates a sequence based on length of 'x'
{
  print(x[i])
}

# However, it is not necessary to use an index-type variable

for(letter in x)
{
  print(letter)
}

# For one line loops, the curly braces are not strictly necessary

for(i in 1:4) print(x[i])

####################################################################################################################################################################
# Nested for Loops
####################################################################################################################################################################
# For loops can be nested inside of each other

x <- matrix(1:6, 2, 3)

for(i in seq_len(nrow(x))) {
  for(j in seq_len(ncol(x))) {
    print(x[i, j])
  }
}

# Nested loops are commonly needed for multidimensional or hierarchical data structures (matrices and lists)
# Nesting beyond 2 to 3 levels often makes it difficult to read or understand the code
# If a large number of nest loops are needed, it may be a better option to break up the loops by using functions

####################################################################################################################################################################
# while Loops
####################################################################################################################################################################
# while loops begin by testing a condition. If it is true, then they execute the loop body. Once the loop body is executed, the condition is tested again until the condition is false after which the loop exits

count <- 0
while(count < 10){
  print(count)
  count <- count + 1
}

# While loops can potentially result in infinite loops if not written properly
# Sometimes there will be more than one condition in the test

z <- 5 
set.seed(1)

while(z >= 3 && z <= 10) {
  coin <- rbinom(1, 1, 0.5)
     if(coin == 1) { ## random walk
       z <- z + 1
       } else {
         z <- z - 1
       }
 }
 print(z)

 # Conditions are always evaluated from left to right
 # For example, in the above code, if z were less than 3, the second test would not have been evaluated

 ####################################################################################################################################################################
 # repeat Loops
 ####################################################################################################################################################################
 # repeat initiates an infinite loop right from the start 
 # These are not commonly used in statistical or data analysis applications but they do have their uses 
 # The only way to exit a repeat loop is to call break
 # One possible paradigm might be in an iterative algorithm where one is searching for a solution and one doesn't want to stop until you;re close enough to the solution
 # In this kind of situation, often the number of iterations isn't known until it comes to a solution
 
 x0 <- 1
 tol <- 1e-8
 repeat {
   x1 <- computeEstimate()
   if(abs(x1 - x0) < tol) { ## Close enough?
     break
   } else {
     x0 <- x1
   }
 }
 
# The above code is a bit dangerous because there's no guarantee it will stop
# A situation where the values of x0 and x1 oscillate back and forth and never converge
# It's better to set a hard limit on the number of iterations by using a for loop and then report whether convergence was achieved or not
 
 ####################################################################################################################################################################
 # next, break
 #################################################################################################################################################################### 
 # next is used to skip an iteration of a loop
 
 for(i in 1:100) {
   if(i <= 20) {
     ## Skip the first 20 iterations
     next
   }
   ## Do something here
 }
 
 # break is used to exit a loop immediately, regardless of what iteration the loop may be on
 
 for(i in 1:100) {
   print(i)
   if(i > 20) {
     ## Stop loop after 20 iterations
     break
   }
 }
 
 ####################################################################################################################################################################
 # Summary
 #################################################################################################################################################################### 
 # Control structures like if, while, and for allow for the control of flow of an R program
 # Infinite loops should generally be avoided even if they are theoretically correct
 # Control structures mentioned here are primarily useful for writing programs. for command line interactive work, the "apply" functions are more useful
 
 ####################################################################################################################################################################
 # End of Chapter 9
 #################################################################################################################################################################### 
 
 












