####################################################################################################################################################################
# Chapter 13: Profiling R Code
####################################################################################################################################################################
# Profiling R Code
####################################################################################################################################################################
# R comes with a profiler to help optimize code and improve its performance
# In general, it's usually a bad idea to focus on optimizing code at the very beginning of development 
# The problem with optimized code is that it tends to be obscure and difficult o read, making it hard to debug and revise
# When it comes to optimizing code, the question is what should be optimized?
# Any code that is running slow should be optimized, but how are this parts determined?
# This is what the profiler is for. Profiling is a systematic way to examine how much time is spent in different parts of a program
# Sometimes profiling becomes necessary as a project grows layers of code and are placed on top of each other
# Code that is written the first time may run fine, but later when running it on new code the process might be exponentially longer
# The biggest impact on speeding up code depends on knowing where the code spends most of its time. This cannot be done without some sort of rigorous performance analysis or profiling

# The basic principles of optimizing code are:
# Design first, then optimize
# Remember: Premature optimization is the root of all evil
# Measure (collect data), don't guess

####################################################################################################################################################################
# Using system.time()
####################################################################################################################################################################
# The system.time() function takes an arbitrary R expression as input (can be wrapped in curly braces) and returns the amount of time taken to evaluate the expression
# The system.time() function computes the number of seconds it took to execute an expression and if there's an error returns the time until an error occurred

# The function returns an object of class proc_time which contains two pieces of useful information
# 1. user time: time charged to the CPU(s) for this expression
# 2. elapsed time: "wall clock" time, the amount of time that passes for an individual
# Usually, the user time and elapsed time are relatively close for straight computing tasks, but there are a few situations where they can diverge dramatically
# The elapsed time may be greater than the user time if the CPU spends time waiting around
# This commonly occur if an R expression involves some input or output, which depends on the activity of the file system and the disk (or internet)
# The elapsed time may be smaller than the user time if a machine has multiple cores/processors
# For example, multi-threaded BLAS libraries (vecLib/Accelerate, ATLAS, ACML, MKL) can greatly speed up linear algebra calculations and are commonly installed on even desktop systems these days
# parallel processing done via something like the parallel package can make the elapsed time smaller than the user time
# With multiple processors/cores working in parallel, the amount of time that collection of CPUs spend working on a problem is the same with a single CPU, but because they are operating parallel there is a saving in time elapsed
# An example of where elapsed time is greater than user time:

system.time(readLines("http://www.jhsph.edu"))

# Most of the time in this expression is spent waiting for the connection to the web server and waiting for the data to travel back to the computer
# THis doesn't involve the CPU and do the CPU simply waits around for things to get done
# In this example, the elapsed time is smaller than the user time:


marsey <- function(n) {
   i <- 1:n
   1 / outer(i - 1, i, "+")
}

x <- marsey(1000)
system.time(svd(x)) # 4.25    0.05    4.28 (user  system elapsed)

####################################################################################################################################################################
# Timing Longer Expressions
####################################################################################################################################################################
# Longer expressions can be timed by wrapping them in curly braces within the call to system.time()

system.time({
   n <- 1000
   r <- numeric(n)
   for(i in 1:n) {
     x <- rnorm(n)
     r[i] <- mean(x)
     }
 }) # 0.13    0.00    0.13 (user  system elapsed)

# If the expression is pretty long (greater than 2 to 3 lines), it might be better to break it up into smaller expressions or to use the profiler
# The problem with long expressions is that it becomes difficult to identity which part of the code is causing the bottleneck

####################################################################################################################################################################
# The R Profiler
####################################################################################################################################################################
# Using system.time() allows you to test certain functions or code blocks to see if they are taking excessive amounts of time
# However, this approach assumes an individual already knows where the problem is, and can call system.time() on the code
# This is where the profiler is useful. The Rprof() function starts the profiler in R
# In conjunction with Rprof(), summaryRprof() function will be used to summarize the output from Rprof()
# Do not use Rprof() and system.time() together 
# Rprof() keeps track of the function call stack at regularly sampled intervals and tabulates how much time is spent inside each function 
# By default the profiler samples the function call stack every 0,02 seconds
# This means if code runs very fast (under 0.02 seconds), the profiler is not useful. However, if the code is that fast than the profiler isn't needed anyway
# The profiler is started by calling the Rprof() function

Rprof()

# No arguments are needed. By default it will write it output to a file called Rprof.out
# The name of the output file can be specified to avoid using the default
# Once Rprof() function is called, everything called afterwards will be measured by the profiler
# Therefore, one should usually only want to run a single R function of expression once turning on the profiler and then immediately turn it off
# The problem with mixing too many function calls together when running the profiler, is all of the results will be mixed together and it won't be possible to sort out the bottlenecks are
# The profiler can be turned of by passing NULL to Rprof()

Rprof(NULL) # Turn off the profiler

# At each line of the output, the profiler writes out the function call stack
# SummaryRprof() function is used to help interpret the data of the profiler

####################################################################################################################################################################
# Using summaryRprof()
####################################################################################################################################################################
# The summaryRprof() function tabulates the R profiler output and calculates how much time is spent in which function. There are two methods for normalizing data
# “by.total” divides the time spend in each function by the total run time
# “by.self” does the same as “by.total” but first subtracts out time spent in functions above the current function in the call stack. This output tends to be much more useful.
# Here is what summaryRprof() reports in the “by.total” output.

$by.total

# Because lm() function is called from the command line, of course 100% of the time is spent somewhere in that function
# However, what this doesn't show is that if lm() immediately calls another function (like lm.fit()) where most of the time is spent in that function

by.self

# The minority of run time is spent in the actual lm() function whereas a majority of time is spent in the lm.fit() 
# A reasonable amount of time is spent in function that are not necessarily associated with linear modeling
# This is because the lm() function does a bit of pre-processing and checking before it actually fits the model
# The final bit of out that summaryRprof() provides is the sampling interval and the total run time

sample.interval # [1] 0.02
sampling.time # [1] 7.41

####################################################################################################################################################################
# Summary
####################################################################################################################################################################
# Rprof() runs the profiler for performance of analysis of R code
# summaryRprof() summarizes the output of Rprof() and gives percent of time spent in each function (with two types of normalization)
# It's code to break the code into function so that the profiler can give useful information about where time is being spent
# C code is not profiled

####################################################################################################################################################################
# End Of Chapter 13
####################################################################################################################################################################
