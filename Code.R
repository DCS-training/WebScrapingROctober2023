# WEB SCRAPING WITH R (RVest) 
# Day 1 
#### Let's Get Started ============
# Install packages (this loads them from the internet onto your computer)
install.packages("tidyverse")
install.packages("rvest")

# Load requested packages (this loads them into your environment)
library(tidyverse)
library(rvest)

## The Basics of Rvest ===================
# The first part of web scraping with Rvest is usually to dowload the HTML from your desired webpage. This can be done using the read_html function, with using the website's URL as the first parameter.

### Simple example ===================

# Let's use the simple example of the RBloggers webpage, which contains information and tutorials for R.

# Create an object with the HTML code from the homepage.
wpage <- read_html('https://www.r-bloggers.com/')

# We can now look at this object
wpage

# The next step is to extract information from this html object. 

# RVest involves using tidyverse-style programming (functions chained together using pipes) to identify
#    1. the CSS selector of the element you want
#    2. their attributes
# and then feed this into a variable. 
# If you want to discover more about pipes in R have a look here https://cfss.uchicago.edu/notes/pipes/

#### Simple example ===================
# We identify the css selector of the logo for our html page, identify it as text, and create a variable
LogoDesc <- wpage %>% 
  html_node('.logo-desc') %>% 
  html_text()

# Now quick print the result
LogoDesc

# Changing "node" to "nodes" will grab all of the elements with this attribute and create a list object with them
titles <- wpage %>% 
  html_nodes('.loop-title a') %>% 
  html_text()
titles

# We can also grab the images from a website by choosing their html selectors and using the 'src' attribute. 
images <- wpage %>% 
  html_nodes('img') %>% 
  html_attr('src')

# Let's look at the first two elements 
images[1:2]
images

# And now download the first two of these images as jpg files
download.file(images[2], c('z.jpg'), mode = 'wb') # this will download it in the same folder where you have this code. If you want to download to a specific folder of your machine you need to add the location before "z.jpg".

# We can also do this for all the image links we have selected 
# R doesn't have a good built-in way to do this, but we can write a function for it
download.images <- function(urls){ 
  for (urlNr in 1:length(urls)){ # Simple for loop to iterate over our list
    download.file(urls[urlNr], destfile = paste0('Downloads', # Or whatever your WD is
                                                 urlNr,'.jpg'), # Download each of these using our function from earlier, pasting the number in the list to .jpg. You can also specify the dir as the first argument of paste0
                  mode="wb")
  }
}

# And now run the function
download.images(images)

# The other vital thing to know is how to select links from a website. This allows us to navigate through a webpage by moving through its URLS

# The attribute for links is going to be 'href'

# Here we can select the first link to an article on our webpage, and then grab the html for this sub-page

article <- wpage %>% 
  html_node('.loop-title a') %>% 
  html_attr('href') 
article

article_html <- read_html(article)
article_html %>%
  html_text()

## Scraping web forums ===================

# Load the index page into an object
wpage <- read_html('https://www.immigrationboards.com/') 
# And have a look
wpage

# We will notice this web page has a variety of sub forums.How do we get the posts from all of these? The easiest way of doing this is to navigate down the tree

# Look at the first page of a subforum for student visas
# https://www.immigrationboards.com/uk-tier-4-student-visas/

# Let's look there now 
#... open the link ...

# The first page
page1 <- 'https://www.immigrationboards.com/uk-tier-4-student-visas/'
# The first part of the urls
start_format <- 'https://www.immigrationboards.com/uk-tier-4-student-visas/page'
# the numbers for the rest of the pages (here we are using a sample so it's more managable later on)
n <- c(1:500)
n <- which(n%%75==0)
#nums <- 2:632 #uncomment this later
end_format <- '.html'

# Paste the three objects together to create a list of URLS complete. Use paste0 so there is no space between the two strings
pages <- paste0(start_format, n, end_format)
pages <- c(page1, pages)

# Have a look at the beginning of the list
head(pages)
length(pages)

# Unlike Python, the preferred approach to web scraping in R will be functional, not iterative. This means instead of for loops, we will write and map functions over our HTML.

# In RVest, the typical approach is to figure out the task we want to perform, write a function to perform this task, and then map the function over a list of objects
# Our first task is to get the links to each article on each of our pages. We can write a function for this, then then map it over the pages


# Read the pages ===================
get.article.links <- function(x){
  links <- read_html(x) %>%
    html_nodes('.topic_read_locked .topictitle') %>%
    html_attr('href')
}

ArticleLinks <- map(pages, get.article.links)

head(ArticleLinks)
length(ArticleLinks)

# What is wrong with this object?
# We get a list of lists, not a list. This will make it difficult to map over our variable, since each item has multiple items within it.

# So we need to use the flatten function to deal with this
ArticleLinksFlat <- ArticleLinks %>% 
  flatten()

head(ArticleLinksFlat)
length(ArticleLinksFlat)

# That looks better!

# Start scraping posts ===================
# Now we move one branch down on the tree, and we can map a new function on to our list of URLs to extract the content. First the title, then the date, then the body text.

# To make it more manageable, we will test each function on a subset of our pages before running it on the full thing. This lets us modify the function if we don't get the output we want.

# Create test set of links 
test <- head(ArticleLinksFlat)
test

# Write a function to get titles
get.title <- function(x){
  title <- read_html(x) %>% 
    html_node('.first a') %>%
    html_text()
}

# Test the function
ArticlesTest_Title <- map(test, get.title)
ArticlesTest_Title

# Write a function to get the author
get.author <- function(x){
  date <- read_html(x) %>%
    html_node('.bg2 .author') %>%
    html_text()
}

# Test the function
ArticlesTest_Author <- map(test, get.author)
ArticlesTest_Author

# Write a function to get the text
get.text <- function(x){
  body <- read_html(x) %>%
    html_node('.bg2 .content') %>%
    html_text()
}

# Test the function
ArticlesTest_Text <- map(test, get.text)
ArticlesTest_Text

# Now that we know they work, time to apply them to the full data set
# Note that a big issue with web scraping is that we can get blocked if we scrape too quickly, since websites take measures against people who access them too frequently. 
Articles_Text <- map(test, get.title)
ArticlesTest_Text <- map(test, get.author)
ArticlesTest_Text <- map(test, get.text)


# Turn this into a df
df <- do.call(rbind, Map(data.frame, Title=ArticlesTest_Title, Text=ArticlesTest_Text))


### Exercise ===================

# 1. Find a web forum (especially a non-English one)
# 2. Using the methods we just learned, scrape any elements from at least two pages on this website.
# 3. Share it with the group.



### Space for your work ---


##### THE END ################


# Day 2: Advanced Rvest Operations
library(rvest)
my_session <- session("https://www.r-bloggers.com/")

# Check your session
my_session$response$request$options$useragent

# The result is not very human-like, so we can change this
# First we need the httr package
library(httr)
user_a <- user_agent("Mozilla/5.0 (Macintosh; Intel Mac OS X 12_0_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/95.0.4638.69 Safari/537.36")
session_with_ua <- session("https://www.r-bloggers.com/", user_a)
session_with_ua$response$request$options$useragent

# Check the response code
my_session$response$status_code

# Now save the url
page <- read_html(session_with_ua)

# And we can also switch to a new URL
session_with_ua <- session_with_ua %>% 
  session_jump_to("https://www.r-bloggers.com/blogs-list/")
session_with_ua

# We can also click on buttons using CSS selectors
session_with_ua <- session_with_ua %>%
  session_jump_to("https://www.r-bloggers.com/blogs-list/") %>% 
  session_follow_link(css = ".menu-item-48313 a")

# We can also go back
session_with_ua <- session_with_ua %>% 
  session_back()
session_with_ua

# Or go forward
session_with_ua <- session_with_ua %>% 
  session_forward()
session_with_ua

# We can also look at the history
session_with_ua %>% session_history()

# We can also try using a search form
search <- html_form(session_with_ua)[[1]]
  #pluck(1) #another way to do [[1]]

SearchResult <- search %>%
  html_form_set(q = "rvest") %>%
  html_form_submit() 

# Look at the result
read_html(SearchResult) %>% html_text()

# Now print out what we see
SearchResult %>% read_html() %>%
  html_nodes("body") %>%
  html_text()
# So the results are not viewable using our current browser, and we would need another one

# Wait times ===================

# A final trick is wait times to deal with rate limits 
# First, let's go back to the example from last week
# This time, we can create URLs for all of the pages
page1 <- 'https://www.immigrationboards.com/uk-tier-4-student-visas/'
start_format <- 'https://www.immigrationboards.com/uk-tier-4-student-visas/page'
# 7125 instead of 500
n <- c(1:7125)
n <- which(n%%75==0)
end_format <- '.html'
pages <- paste0(start_format, n, end_format)
pages <- c(page1, pages)

# Print the length
length(pages)
# In a case where there's 96 pages, we might want to include wait times

# When we make our function to get article links, let's include a function to tell R to wait a bit each time
get.article.links <- function(x){
  links <- read_html(x) %>%
    html_nodes('.topic_read_locked .topictitle') %>%
    html_attr('href')
  #Sys.sleep(time = 5) # At the end of our function, we tell R to wait 5 seconds before doing anything else
  
}

# Here, we can use a for loop instead of a map function to include sys.sleep when using the function from yesterday
# First create a sample
pages_sample <- head(pages)
# Now a for loop
article_links  <- vector("character", length = length(pages_sample))
for(i in seq_along(pages_sample)){
  Sys.sleep(5) # Here, we tell R to wait for 5 seconds
  article_link <- read_html(pages_sample[i])
  article_links[i] <- article_link %>%
    html_nodes(".topic_read_locked .topictitle") %>% 
    html_attr('href')
}

# Print the beginning of the result
head(article_links)

# We can also wait for a random amount of time
article_links  <- vector("character", length = length(pages_sample))
for(i in seq_along(pages_sample)){
  Sys.sleep(sample(1:10, 1)) # Here, we tell R to wait for a random time between 1 and 10 seconds
  article_link <- read_html(pages_sample[i])
  article_links[i] <- article_link %>%
    html_nodes(".topic_read_locked .topictitle") %>% 
    html_attr('href')
}
head(article_links)


## Independent projects
# 1. Continue scraping from the website from last week, expirimenting with some of what we learned today
# 2. Try to get new data, and present it to the group
# 3. to find data that you can't seem to scrape, and discuss with the group difficulties you had


### Space for your work ---
