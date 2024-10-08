# Web Scraping with R (October2023)
A 2-day workshop on how to scrape web forums with R

This intermediate course will teach you how to scrape user-generated content from the internet using R. On the first day, the course will start with a theoretical introduction to web scraping and specific approaches to scraping forums. We will then select two web forums and go through the process of scraping them. On the second day, we will discuss different kinds of websites that present problems for web scraping. One example of these is websites with dynamically generated content. We will select one such website and walk through the process of collecting data from it. 

This is an intermediate-level course. Students must have a basic background in R.
# Getting Set-up

## Installing R and R Studio
### For R On Noteable

1. Go to https://noteable.edina.ac.uk/login
2. Login with your EASE credentials
3. Select RStudio as a personal notebook server and press start
4. Go to File > New Project> Version Control > Git
5. Copy and Paste this repository URL [https://github.com/DCS-training/WebScrapingROctober2023/](https://github.com/DCS-training/WebScrapingROctober2023/) as the Repository URL (The Project directory name will filled in automatically but you can change it if you want your folder in Notable to have a different name).
6. Decide where to locate the folder. By default, it will locate it in your home directory
7. Press Create Project
Congratulations you have now pulled the content of the repository on your Notable server space.

### Install it locally
1. Go to (https://www.r-project.org/)[https://www.r-project.org/]
2. Go to the download link
3. Choose your CRAN mirror nearer to your location (either Bristol or Imperial College London)
4. Download the correspondent version depending if you are using Windows Mac or Linux
- For Windows click on install R for the first time. Then download R for Windows and follow the installation widget. If you get stuck follow this (video tutorial)[https://www.youtube.com/watch?v=GAGUDL-4aVw]
- For Mac Download the most recent pkg file and follow the installation widget. If you get stuck follow this (video tutorial)[https://www.youtube.com/watch?v=EmZqlcKkJMM]
5. Once R is installed you can install R studio (R interface)
6. Go to (www.rstudio.com)[www.rstudio.com]
7. Go in download
8. Download the correspondent version depending on your Operating system and install it. If you get stuck check the videos linked above. 

## Install the libraries 
```
install.packages("tidyverse")
install.packages("lme4")
install.packages("effects") 
install.packages("sjPlot") 
install.packages("interactions")

library("tidyverse") #for cleaning and sorting out data
library("lme4") #for fitting linear mixed-effects models (LMMs)
library("effects") #for creating tables and graphics that illustrate effects in linear models
library("sjPlot") #for plotting models
library("interactions") #for plotting interaction effects
``` 

# What you are going to find in this repo
Once ready, you are going to find 

-  .ppt presentations used during the course
-  example code 


# Author
James Besse

# Copyright

This repository has a [![License: CC BY-NC 4.0](https://licensebuttons.net/l/by-nc/4.0/80x15.png)](https://creativecommons.org/licenses/by-nc/4.0/) license
