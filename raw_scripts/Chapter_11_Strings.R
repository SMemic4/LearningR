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


# Strings can be created with single " or '. Recommended to use "" always unless you're including a quote inside a string 

string1 <- "Example of string"
string2 <- 'Example of a "string" with a qoute inside'

# To include a literal single or double quote in a string use \ to "escape it"

double_quote <- "\""
single_quote <- '\''

# To include a backslash, it requires an additional backslash

back_slash <- "\\"

# The printed representation of the string is not the same as the string itself, because the printed representation shows the escapes. Raw contents of the string can be seen with writelines()

x <- c("\"", "\\") 
x
writeLines(x)

# There are a handful of special characters for strings. Most common include \n which creates a new line and \t which adds a tab. A complete list can be accessed by requesting ?"'" or ?'"'
# Multiple strings are often stored in a character vector which is created using c()
c("one", "two", "three")

# Base R functions can work with strings but they're inconsistent. Functions from stringr are a better alternative. They all start with str_.
# str_length() tells you the number of characters in a string

str_length(c("apples", "apples and oranges", NA)) # Output is 6, 18, and NA

# To combine two or more strings use str_c()

str_c("x", "y") # Output is "xy"
str_c("x", "y", "z") # Output is "xyz"

# The sep argument is used to control how they're separated

str_c("x", "y", "z", sep = "-") # Output is "x-y-z"

# Use str_replace_na() to print missing values as "NA"

x <- c("xyz", NA)
str_c("|--", x, "--|") # Output is |--xyz--|" NA
str_c("|--", str_replace_na(x), "--|") # Output is "|--xyz--|" "|--NA--|" 

# str_c() is vecotrized and automatically recycles shorter vectors to the same length as the longest

str_c("prefix-", c("a","b","c"), "-suffix") # Output is "prefix-a-suffix" "prefix-b-suffix" "prefix-c-suffix"

# Objects of length 0 are dropped automatically. This is particularly useful in conjunction with if:

name <- "Marsey"
time_of_day <- "morning"
birthday <- TRUE

str_c("Good ", time_of_day, " ",  name, if(birthday) " and Happy birthday!", ".") # output if false: "Good morning Marsey.". Outout if true: "Good morning Marsey and Happy birthday!." 

# A vector of strings can be collapsed into a single string using the argument collapse

str_c(c("x", "y", "z"), collapse = ",") # Output is "x,y,z"

# Parts of a string can be extracted by using str_sub(). str_sub() takes start and end arguments that give the inclusive position of the sub string

x <- c("Apples", "Oranges", "Banana")
str_sub(x, start = 2, end = 4) # Output is "ppl" "ran" "ana". Remember r starts counting at 1 and not zero
str_sub(x, 2, 4) # Same code as above but the arguments are excluded

# Negative numbers can be used to count backwards from the end

str_sub(x, -4, -1) # Output is "ples" "nges" "nana"

# str_sub() won't fail if the string is too short; it will just return as many values as possible

str_sub("Apples", 1, 10) # Output is "Apples"

# str_sub() in the assignment form can be used to modify strings

str_sub(x, 1, 1 ) <- str_to_lower(str_sub(x, 1, 1)) # Output is "apples"  "oranges" "banana". 

# str_to_lower() converts uppercase string letters to lowercase

str_to_lower(c("APPLES")) # output is "apples"

# str_to_upper() converts characters to uppercase

str_to_upper(c("apples")) # Output is "APPLES"

# str_to_title converts everything to lowercase except that first character of each word

str_to_title("apPlEs aRE a gOOD fRUIT tO eAT") # "Apples Are A Good Fruit To Eat"

# Changing cases is more complicated than it might appear because different languages have different rules for changing cases. You set the rules by specifying a locale:

str_to_upper(c("i", "ı")) # Out put is "I" "I"
str_to_upper(c("i", "ı"), locale = "tr") # Turkish settings. Output is "İ" "I"

# If locale is left blank, it will use the current locale as provided by the operating system

######################### Exercises #########################################################################################################

# 1.  In code that doesn’t use stringr, you’ll often see paste() and paste0(). What’s the difference between the two functions? What stringr function are they equivalent to? How do the functions differ in their handling of NA?
str_c("x", "y", "z", sep = "A")
paste("x", "y", "z", sep = "A")
paste0("x", "y", "z", sep = "A")

# paste0 does not take a sep argument and instead will attach all strings together

str_c("x", "y", "z", NA, sep = "A")
paste("x", "y", "z", NA, sep = "A")
paste0("x", "y", "z", NA)

# paste and paste0 differ from from str_c because they can handle NA values unlike str_c but they work similar in function

# 2. In your own words, describe the difference between the sep and collapse arguments to str_c()
str_c("Apples", "Fruits", "Oranges")
str_c("Apples", "Fruits", "Oranges", sep = "|")
str_c(c("Apples", "Fruits", "Oranges"), collapse = "|")

# Separate will put a string between the arguments given to str_c, while collapse will insert a string within a vector

# 3. Use str_length() and str_sub() to extract the middle character from a string. What will you do if the string has an even number of characters?

# The following code work with any length string and doesn't care if the string is even or odd

str_sub(x, start = str_length(x)%/%2 + str_length(x)%%2, end = str_length(x)%/%2 + str_length(x)%%2)

# 4. What does str_wrap() do? When might you want to use it?

paragraph <- "AAb bbbadqwdbAAA A Ass//ssssA AAAA//gdthew\\\\qAA AArr////rrrAAAAAAt yyyyyAA AAAAhh hAAA AAA///AAAh AAAAAAAasdasda///sdAAAAA ttttttt//tttt  bbbadqda///sdAAAAA ttt"
str_wrap(paragraph, width = 80, whitespace_only = FALSE) %>% writeLines()

# str_wrap writes a paragraph with all the strings.Could possibly use it to examine the strings of a text

# 5. What does str_trim() do? What's the opposite of str_trim()

str_trim("   Apples")
str_trim("Apples   ")
str_trim("       Apples", side = "right")
str_trim("       Apples", side = "left")

# str_trim will remove the excess white space from a string. It's arguments include side is both by default but can be limited to only right or left side

str_pad("Apples", width = 15) # The opposite of str_trim is str_pad, which will add white space (the default but can be changed to another character) to a string
str_pad("Marsey", width = 15, pad = "C", side = "both") # Example code with running a different character

# 6. Write a function that turns (e.g.) a vector c("a", "b", "c") into the string a, b, and c. Think carefully about what it should do if given a vector of length 0, 1, or 2.?

v1 <- c("Marsey", "Orange", "cat", "carp")
ifelse(length(v1) == 0, " ", ifelse(length(v1) == 1, v1, ifelse(length(v1) == 2, str_c(v1[1], " and ", v1[2]), ifelse(length(v1) >= 3, str_c(str_c(v1[1:length(v1)-1], collapse = ", "), ", and ", v1[length(v1)]), NA ) )))   

# The code above deals with any length vector and will print out the results based on the length of the vector. 


#############################################################################################################################################

# To match regular expressions use the functions str_view() and str_view_all()

x <- c("apple", "banana", "pear", "oranges")
str_view(x, "an") # Output highlights all patterns that match in the strings. It shows multiple patterns in one string
str_view(x, ".a.") # This output matches any character before and after a character (Expect newlines)

# Using "." matches any character. But to match "." in a string the regular expression "\\." needs to be used


dot <- "\\."
writeLines(dot)
str_view(dot, "\\.")
str_view(c("abc", "a.c", "bef"), "a\\.c")

# To match a backslash "\" the regular expression "\\\\ is needed to match one backslash

x <- "a\\b"

writeLines(x)
str_view(x, "\\\\")

######################### Exercises #########################################################################################################

# 1. Explain why each of these strings don't match a \: "\", "\\", "\\\"

# "\" wont match due to it being an escape for regular strings

# "\\" wont match due to being an escape for regular expressions

# "\\\" won't match due to needing the additional two backslashes to escape the regular string and regular expression requirements


# 2. How would you match the sequence "'\?

x <- "\'\\"
str_view(x)
str_view(x, "\'\\\\") # To match the expression it requires a single backslash before the apostrophe and three additional backslashes before the backslash to correctly match the expression

# 3. What patterns will the regular expression \..\..\.. match? How would you present it as a string?   

str_view(".x.y.z", "\\..\\..\\..")  # The \. will match any dots within a string, and dots can be used to find any character as long as it isn't a new line

#############################################################################################################################################

# As a default, regular expressions will match any part of a string. It's useful to anchor the regular expression so it matches from the start or end of the string. "^" is to match the start of the string. "$" is used to match the end of the string

x <- c("apple", "banana", "pear", "apirocts")
str_view(x, "^a") # Returns only apple. The "^" must be placed at the beginning of the expression for it to work properly
str_view(x, "a$") # Returns only bananas. The "$" must be placed at the end of the expression for it to work properly

# To force a regular expression to only match a complete string anchor it with both ^ and $

x <- c("Fruit", "Fruit cake", "Fruit snacks")
str_view(x, "Fruit")  # Returns all the strings in the vector
str_view(x, "^Fruit$") # Only returns "Fruit"

######################### Exercises #########################################################################################################

# 1. How would you match the literal string "$^$"?

x <- "$^$"
str_view(x, "\\$\\^\\$")

# 2. Given the corpus of common words in stringr::words, create regular expressions that find all words that:

x <- stringr::words

# a. Start with "y"

str_view(x, "^y")

# b. End with "x"

str_view(x, "x$")

# c. Are exactly three letters long (without using str_length)

str_view(x, "^...$") # This code will find any matches that are exactly three characters in length

# d. Have seven letters or more

str_view(x, "^.......")

############################################################################################################################################

# There are four useful tools for finding special patterns

# \d matches any digit. \s matches any white space such as spaces, tabs, or newlines. [abc] matches a,b, or c. [^abc] matches anything except a, b, or c. 
# For the regular expressions containing \d or \s, it's required to escape the "\" for the string so the expressions will be "\\d" or "\\s"

# Alternation can be used to match multiple patterns using "|"

str_view(c("gray", "grey"), "gr(e|a)y")

######################### Exercises #########################################################################################################

# 1. Create a regular expression to find all words that:

x <- stringr::words

# a. Start with a vowel

str_view(x, "^[aeiou]")

# b. Only contain consonants

str_view(x, "^[^aeiou]*[^aeiou]$") # The meta character "*" will check a string 0 or more times

# c. End with ed, but not with eed

str_view(x, "[^e]ed$" )

# d. End with ing or ize

str_view(x, "(ize|ing)$")

# 2. Empirically verify the rule “i before e except after c.”

str_view(x, "cei|cie|^ei|[^c]ei")

# 3. Is "q" always followed by a "u"

str_view(x, "q[^u]")

# 4,  Create a regular expression that will match telephone numbers as commonly written in your country

str_view("111-111-1111", "\\d\\d\\d-\\d\\d\\d-\\d\\d\\d\\d")

############################################################################################################################################

# There are special characters to find pattern matches: 
# "?" for 0 or 1. 
# "+" for 1 or more
# "*" for 0 or more

x <- "MDCCCLXXXVIII"
str_view(x, "CC?")
str_view(x, "CC+")
str_view(x, "CC*")
str_view(x, "C[LX]+")

#  The number of matches can also be precisely specified: 
# {n} will match exactly n times 
# {n,} will match n or more times 
# {,m} will match at most m times 
# {n,m} will match between n and m times

str_view(x, "C{2}")
str_view(x, "C{2,}")
str_view(x, "C{2,3}")
str_view(x, "C{2}")

# By default matches are "greedy". They will match the longest string possible. They can be made "lazy" by matching the shortest string possible by putting a ? after them

str_view(x, "C{2,3}?")
str_view(x, "C[LX]+?")

######################### Exercises #########################################################################################################

# 1. Describe the equivalents of ?, +, and * in {m,n} form
# "?" for 0 or 1. 
# "+" for 1 or more
# "*" for 0 or more

str_view(x, "CC?")
str_view(x, "CC{0,1}")

str_view(x, "CC+")
str_view(x, "CC{1,}")

str_view(x, "CC*")
str_view(x, "CC{0,}")

# 2. Describe in words what these regular expressions match

# a.^.*$

str_view(x, "^.*$") # Matches any character times effectively matching the whole expression

# b. "\\{.+\\}"

str_view("Marsey the {cat}", "\\{.+\\}") # Matches text in brackets

# c. \d{4}-\d{2}-\d{2}

str_view("1111-11-11", "\\d{4}-\\d{2}-\\d{2}") # Matches 4 numbers, than 2 numbers, and finally 2 numbers

# d. "\\\\{4}"

str_view("\\\\\\\\\\", "\\\\{4}") # Matches 4 brackets

# 3. Create regular expressions to find all words under these conditions

x <- stringr::words

# a. Start with three consonants

str_view(x, "^[^aeiou]{3}")

# b.Have three or more vowels in a row

str_view(x, "[aeiou]{3}")

# c. Have two or more vowel-consonant pairs in a row

str_view(x, "([aeiou][^aeiou]){2,}")

############################################################################################################################################

# Parentheses can also be used to define "groups" with back references, like \1,\2, etc

str_view(fruit, "(..)\\1")

######################### Exercises #########################################################################################################

# 1. Describe, in words, what these expressions will match:

x <- stringr::words

# a. (.)\\1\\1

str_view("aaabaaaba", "(.)\\1\\1") # Finds the same character three times in a row

# b. "(.)(.)\\2\\1"

str_view("abbacabba","(.)(.)\\2\\1" ) # Two characters followed by the same pair of characters in the reverse order

# c. (..)\1

str_view("ababaaabaabab", "(..)\\1") # Any two repeating characters

# d. "(.).\\1.\\1"

str_view("abacaxyzabaca", "(.).\\1.\\1")

# e. "(.)(.)(.).*\\3\\2\\1"

str_view("abcxcbaasdabcxcba", "(.)(.)(.).*\\3\\2\\1") # Three characters followed by zero or more characters of any kind folllowed by the same charachter in the reverse order

# 2. Construct regular expressions to match words that: 

# a. Start and end with the same letter

str_view(x, "^(.).*\\1$")

# b. Contain a repeated pair of letters

str_view(x, "(..).*\\1")

# c. Contain one letter repeated in at least three places

str_view(x, "([a-z]).*\\1.*\\1")

############################################################################################################################################

# To determine if a character vector matches a pattern, use str_detect(). It returns a logical vector the same length as the input

str_detect(c("Marsey", "cat", "orange", "carp"), "e") # Returns "TRUE FALSE  TRUE FALSE"

# In a logical vector, FALSE becomes a 0 and TRUE becomes 1 that means it can be used in a numerical context

sum(str_detect(words, "^t")) # The amount of common words that start with T

mean(str_detect(words, "[aeiou]$")) # The amount of common words that end with a vowel

# When dealing with complex logical conditions it's easier to combine multiple str_detect() calls with logical operators rather than trying to create a singular expression

no_vowels_1 <- !str_detect(words, "[aeiou]") # Finding all words containing at least one vowel and negating them
no_vowels_2 <- str_detect(words, "^[^aeiou]+$") # Finding all words containing only consonants
identical(no_vowels_1, no_vowels_2)

# A common use of str_detect() is select elements that match a pattern. This can be done with logical sub-setting or str_subset() wrapper

words[str_detect(words, "x$")]
str_subset(words, "x$")

# A variation of str_detect() is str_count() which tells you how many matches there are in a string

str_count(c("Marsey", "cat", "orange", "carp"), "e") 

mean(str_count(words, "[aeiou]")) # Returns the average number of vowels per word

# Matches never overlap when using  str_count

str_count("abababa", "aba")

######################### Exercises #########################################################################################################

x <- stringr::words

# 1. Try solving the following problems by using single regular expressions and multiple str_detect() calls

# a. Find all words that start or end with x.

str_view(x, "^[x]|[x]$")

start_x <- str_detect(x, "^x")
end_x <- str_detect(x, "x$")
x[start_x | end_x]

# b. Find all words that start with a vowel and end with a consonant

str_view(x, "^[aeiou].*[^aeiou]$")

start_x <- str_detect(x, "^[aeiou].")
end_x <- str_detect(x, "[^aeiou]$")
x[start_x & end_x]

# c. Are there any words that contain at least one of each different vowel?

# No simple regular expression exists for this thus a combination of multiple calls must be used

Xa <- str_detect(x, "a")
Xe <- str_detect(x, "e")
Xi <- str_detect(x, "i")
Xo <- str_detect(x, "o")
Xu <- str_detect(x, "u")
words[Xa & Xe & Xi & Xo & Xu] # There are no words with every vowel

# d. What word has the highest number of vowels? What word has the highest proportion of vowels?

words_df <- tibble(word = words) 
words_df %>% mutate(Vowel_number = str_count(words, "[aeiou]")) %>% arrange(desc(Vowel_number)) # Appropriate, associate, available, college, encourage, experience, individual, and television have the most vowels

words_df %>% mutate(total = str_length(words_df$word), vowels = str_count(words_df$word, "[aeiou]"), prop = vowels/total) %>% arrange(desc(prop)) # "a" has the highest proportion of vowels compared to length

############################################################################################################################################

# To extract the actual text of a match, use str_extract(). This will be using the "sentences" to practice regexes (These are provided in stringr::sentences)

length(sentences)
head(sentences)

# To find all sentences that contain a color, a vector with all of the color names needs to be created and then turned into a regular expression

colors <- c("red", "orange", "yellow", "green", "blue", "purple")
color_match <- str_c(colors, collapse = "|")

# The sentences that contain a color can then be selected and then extracted to determine which color it is

has_color <- str_subset(sentences, color_match)
matches <- str_extract(has_color, color_match)
head(matches)

# str_extract() only extracts the first match. Sentences with more than one match can be selected

more <- sentences[str_count(sentences, color_match) > 1]
str_view_all(more, color_match) # Views all the different matches
str_extract(more, color_match) # Shows only the first matches

# Working with a single match allows for much simpler data structures

str_extract_all(more, color_match)

# Using simplify = TRUE with str_extract_all() will return a matrix with short matches expanded to the same length as the longest

str_extract_all(more, color_match, simplify = TRUE)

######################### Exercises #########################################################################################################

# 1. From the Harvard sentences data extract the following: 

# a. The first word from each sentence.

str_extract_all(sentences, "^[A-Za-z]+", simplify = TRUE)

# b. All words ending in ing

str_extract_all(sentences, "\\b[A-Za-z]+ing\\b", simplify = TRUE)

# c. All plurals

str_extract_all(sentences, "\\b[A-Za-z]{3,}s\\b") # The brackets are to exclude short 3 letter words such as was, as, is from appearing in the list

############################################################################################################################################

# Parentheses can be used to extract parts of a complex match.

noun <- "(a|the) ([^ ]+)"
has_noun <- sentences %>% str_subset(noun) %>% head(20)
has_noun %>% str_extract(noun)
has_noun %>% str_match(noun)

# str_extract() gives the complete match while str_match() gives each individual component. Instead of a character vector it returns a matrix with one column for the complete match followed by one column for each group

# If the data is in a tibble it's easier to use tidyr::extract(). It works similarly to str_match() but requires a name for the matches which are placed in the columns

tibble(sentence = sentences) %>% tidyr::extract(sentence, c("article", "noun"), "(a|the) ([^ ]+)")

######################### Exercises #########################################################################################################

# 1. Find all the words that come after a "number" like "one", "two", "three', etc. Pull out both the number and the word

num_find <- "(one|two|three|four|five|six|seven|eight|nine|ten) ([^ ]+)"
has_num <- sentences %>% str_subset(num_find) %>% head(20)
has_num %>% str_extract(num_find)

# 2. Find all contractions. Separate out the pieces before and after the apostrophe

contractions <- "([a-zA-Z]+)'([a-zA-Z]+)"
contract <- sentences[str_detect(sentences, contractions)]
str_match(contract, contractions)

############################################################################################################################################

# str_replace() allow to replace matches with new strings

str_replace(c("marsey", "cat", "carp", "apples"), "[aeiou]", "x")

# str_replace_all() can perform multiple replacements when supplied with a vector

x <- c("1 cat", "2 carps", "3 capys")
str_replace_all(x, c("1" = "one", "2" = "two", "3" = "three"))

sentences %>% str_replace("([^ ]+) ([^ ]+) ([^ ]+)", "\\1 \\3 \\2") %>% head(10) # This code flips the order of the second and third world

######################### Exercises #########################################################################################################

# 1. Replace all forward slashes in a string with backslashes.

fslash <- "/a/b/c/d/e/f/g/h/i/j/k/l/m/n/o/p/q/r/s/t/u/v/w/x/y/z /a/b/c/d/e/f/g/h/i/j/k/l/m/n/o/p/q/r/s/t/u/v/w/x/y/z"

str_replace_all(fslash, "/", "\\\\")

# 2. Implement a simple version of str_to_lower() using replace_all()

Uppercase <- "MARSEY THE CAT EATS TUNA"
str_replace_all(Uppercase, c("A" = "a", "B" = "b", "C" = "c", "D" = "d", "E" = "e", "F" = "f", "G" = "g", "H" = "h", "I" = "i", "J" = "j", "K" = "k", "L" = "l", "M" = "m", "N" = "n", "O" = "o", "P" = "p", "Q" = "q", "R" = "r", "S" = "s", "T" = "t", "U" = "u", "V" = "v", "W" = "w", "X" = "x", "Y" = "y", "Z" = "z"))

# 3. Switch the first and last letters in words. Which of those strings are still words?

str_replace_all(words, "^([a-z])(.*)([a-z])$", c("\\3\\2\\1"))

############################################################################################################################################

# str_split() is used to split a string up into pieces

sentences %>% head(5) %>% str_split(" ")

# Rach component might contain a different number of pieces it returns a list. If working with a length-1 vector it's recommended to extract the first element of the list

"cat|dog|fish|horse" %>% str_split("\\|") %>% .[[1]]

# Otherwise like most stringr functions it returns a list. simplify = TRUE can return a matrix

sentences %>% head(5) %>% str_split(" ", simplify = TRUE)

# Strings can also be split up by character, line sentence, and word boundary()'s 

x <- "This is a sentence. This is another sentence."
str_view_all(x, boundary("word"))

######################### Exercises #########################################################################################################

# 1. . Split up a string like "apples, pears, and bananas" into individual components.

x <- "apples, pears, and bananas"

str_split(x, " ")
str_split(x, boundary("word"))

# 2. Why is it better to split up by boundary("word") than " "?

# Boundary will return words without any commas or periods unlike " " 

# 3. What does splitting with an empty string ("") do? Experiment, and then read the documentation.

# It splits up words by every individual characters effectively returning every letter and space

############################################################################################################################################

# str_locate() gives the starting and ending positions of each match

# When using a pattern that's a string it's automatically wrapped into a call to regex()

str_view(fruit, "nana")
str_view(fruit, regex("nana"))

# There are other arguments of regex() that control the details of the match

# ignore_case = TRUE allows characters to match either their uppercase or lowercase forms

bananas <- c("banana", "Banana", "BANANA")
str_view(bananas, "banana") # Only returns the first banana string
str_view(bananas, regex("banana", ignore_case = TRUE)) # Returns all of the banana strings

# multiline = TRUE allows ^ and $ to match the start and end of each line rather than the start and end of the complete string:

x <- "Line 1\nLine 2\nLine 3"
str_extract_all(x, "^Line")[[1]]
str_extract_all(x, regex("^Line", multiline = TRUE))[[1]]

# comments = TRUE allows you to use comments and white space to make complex regular expressions more understandable. Spaces are ignored, as is everything after #. To match a literal space, you’ll need to escape it: "\\ "

phone <- regex("\\(? # optional opening parens (\\d{3}) # area code [)- ]? # optional closing parens, dash, or space (\\d{3}) # another three numbers [ -]? # optional space or dash (\\d{3}) # three more numbers", comments = TRUE)
str_match("514-791-8141", phone)

# dotall = TRUE allows . to match everything including \n

# There are three other functions that can be used instead of regex()

# Fixed() matches exactly the specified sequence of bytes

# coll() compares strings using standard collation rules. It's useful for doing case-sensitive matching

# Boundrary() can be used to match boundaries

x <- "This is a sentence."
str_view_all(x, boundary("word"))
str_extract_all(x, boundary("word"))

################################################################################################################################################


# End of Chapter 11