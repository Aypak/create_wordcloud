library(shiny)
library(shinyWidgets)
library(colourpicker)
library(tm)
library(NLP)
library(wordcloud2)

# Source helper function
source("create_wordcloud.R")

# Read rds file containing sample movie reviews
movie_reviews <- readRDS("data/movie_reviews.rds")