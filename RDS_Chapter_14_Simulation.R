####################################################################################################################################################################
# Chapter 14: Simulation
####################################################################################################################################################################
# Generating Random Numbers
####################################################################################################################################################################
# Simulation is an important topic for both statistics and other areas where there is a need to introduce randomness
# Sometimes an individual needs to implement a statistical procedure that requires random number generation or sample and wants to simulate a system and random number generators to model random inputs
# R comes with a set of pseudo-random number generators that allow for simulation of probability distributions like Normal, Poisson, and binomial
# Some example functions for probability distributions in R: 
# rnorm: generate random Normal variation with a given mean and standard deviation
# dnorm: evaluate the Normal probability density (with a given mean/SD) at a point (or vector of points)
# pnorm: evaluate the cumulative distribution function for a Normal distribution
# rpois: generate random Poisson variation with a given rate
# For each probability distribution there are typically four functions available that start with a "r", "d", "p", and "q"
# The "r" function is the one that actually simulates random numbers from that distribution
# The other functions are prefixed with a:
# d for density
# r for random number generation
# p for cumulative distribution
# q for quantile function (inverse cumulative distribution)
# For simulating random number, the "r" functions are likely the only ones that will be needed
# However, simulate from arbitrary probability distributions like something like rejection sampling, will require other functions 
# Probably the most common probability distribution to work with the is the Normal distribution (also known as the Gaussian).
# Working with the Normal distributions requires using these four functions:

dnorm(x, mean = 0, sd = 1, log = FALSE)
pnorm(x, mean = 0, sd = 1, lower.tail = TRUE, log.p = FALSE)
qnorm(x, mean = 0, sd = 1, lower.tail = TRUE, log.p = FALSE)
rnorm(x, mean = 0, sd = 1)

# Example of simulating standard Normal random numbers with mean 0 and standard deviation 1:

x <- rnorm(10)
x # [1] -0.4378195 -0.3949741  0.4012696  1.3117220  0.5263459  0.6222707  0.2012987  0.3550321 -0.1399955  1.3611394

# The default parameters can be modified to simulate numbers with mean 20 and standard deviation 2

x <- rnorm(10, 20, 2)
x # [1] 19.64336 17.94996 22.97142 20.49847 20.61061 21.58472 20.17093 17.98522 23.71141 19.97737
summary(x)

# To know what the probability of a random Normal variable being less than, say 2, the function pnorm() can be used for that calculation:

pnorm(2) # [1] 0.9772499

####################################################################################################################################################################
# Setting the Random Number Seed
####################################################################################################################################################################
# When simulating any random numbers it is essential to set the random number seed
# Setting the random number seed with set.seed() ensures reproducibility of the sequence of random numbers
# For example, generating 5 normal random numbers with rnorm()

set.seed(1)
rnorm(5) # -0.6264538  0.1836433 -0.8356286  1.5952808  0.3295078

# Note that calling rnorm() again will get a different set of 5 random numbers

rnorm(5) # -0.8204684  0.4874291  0.7383247  0.5757814 -0.3053884

# To reproduce the original set of random numbers, just reset the seed with set.seed()

set.seed(1)
rnorm(5) # -0.6264538  0.1836433 -0.8356286  1.5952808  0.3295078

# In general, a random number seed should always be set when conducting a simulation, otherwise the exact numbers wont be produced in an analysis
# it is possible to generate random numbers from other probability distributions like the Poisson
# The Poisson distribution is commonly used to model data that come in the form of counts 
# 10 counts with a mean of 1
rpois(10,1) # [1] 0 0 1 1 2 1 1 4 1 2

# 10 counts with a mean of 2

rpois(10,2) # [1] 0 1 1 0 1 4 1 2 2 2

# 10 counts with a mean of 2

rpois(10,20) # [1] 16 23 22 24 23 20 11 22 24 16

####################################################################################################################################################################
# Simulating a Linear Model
####################################################################################################################################################################
# Simulating random number is useful, but sometimes one needs to simulate values that come from a specific model
# For that a model needs to specified and then simulated from using the functions described above
# Suppose, a model is simulated from the following linear model y = B0 + B1x + errorterm
# The variable x might represent an important predictor of the outcome. Here are the steps in R:
# Always set a seed

set.seed(20)

# Simulate predictor variable

x <- rnorm(100)

# Simulate error term

e <- rnorm(100, 0, 2)

# Compute the outcome via the model

y <- 0.5 + 2 * x + e
summary(y) # -6.4084 -1.5402  0.6789  0.6893  2.9303  6.5052 (Min. 1st Qu.  Median    Mean 3rd Qu.    Max. ) 

# Plot the results of the model simulation

plot(x,y)

# rbinom() function can be used to simulate binary random variables instead of using a normal distribution

set.seed(10)
x <- rbinom(100, 1, 0.5)
x # 1 0 0 1 0 0 0 0 1 0 ...
str(x) # nt [1:100] 1 0 0 1 0 0 0 0 1 0 ...

# The rest of the model can be preceded

e <- rnorm(100, 0, 2)
y <- 0.5 + 2 * x + e
plot(x, y)

# Simulation can also occur using generalized linear model where the error are no longer from a normal distribution but come from some other distribution
# For example, simulating form a Poisson log-linear model where Y ~ Poisson(u):

set.seed(1)

# Simulate the predictor variable as before

x <- rnorm(100)

# Compute the log mean of the model and then exponentiation it to get the mean to pass to rpois()

log.mu <- 0.5 + 0.3 * x
y <- rpois(100, exp(log.mu))
summary(y)
plot(x,y)

# Arbitrarily complex models can be built by simulating more predictors or making transformations of those predictors (squaring, log transformations)

####################################################################################################################################################################
# Random Sampling
####################################################################################################################################################################
# The sample() function draws randomly from a specified set of (scalar) objects allowing for sampling from a arbitrary distributions of numbers.

set.seed(1)
sample(1:10, 4) # [1] 9 4 7 1
sample(1:10, 4) # [1] 2 7 3 6

# The sampling doesn't have to be just numbers 

sample(letters, 5) # [1] "r" "s" "a" "u" "w"

# A random permutation

sample(1:10) # [1] 10  6  9  2  1  5  8  4  3  7
sample(1:10) # [1]  5 10  2  8  6  1  4  3  9  7

# Sampling with replacement

sample(1:10, replace = TRUE) # [1]  3  6 10 10  6  4  4 10  9  7

# To sample more complicated things, such as rows from a data frame or a list, sample the indices into an object rather than the elements of the object itself
# Exampling of how rows can be sampled from a data frame

data(airquality)
head(airquality)

# Create an index vector indexing the rows of the data frame and sample directly from the index vector 

set.seed(20)

# Create an index vector 

idx <- seq_len(nrow(airquality))

# Sample from the index vector:

samp <- sample(idx, 6)
samp # [1] 107 120 130  98  29  45

# Subset those indices

airquality[samp, ]

# Other more complex objects can be sampled in this way, as long as there's a way to index the sub-elements of the object

####################################################################################################################################################################
# Summary
####################################################################################################################################################################
# Drawing samples from specific probability distributions can be done with "r" functions
# Standard distributions are built in: Normal, Poisson, Binomial, Exponential, Gamma, etc.
# The sample() function can be used to draw random samples from arbitrary vectors
# Setting the random number generator seed via set.seed() is critical for reproducibility

####################################################################################################################################################################
# End of Chapter 14
####################################################################################################################################################################
