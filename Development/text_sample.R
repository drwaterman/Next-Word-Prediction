#library(RWekajars)
#library(qdapDictionaries)
#library(qdapRegex)
#library(qdapTools)
#library(qdap)
#library(NLP)
#library(tm)
#library(SnowballC)
#library(slam)
#library(RWeka)
#library(rJava)
library(dplyr)
library(readr)
library(stringr)
#library(markdown)
#library(stylo)

# Load the original data set
blogs <- read_lines("../data/final/en_US/en_US.blogs.txt")
news <- read_lines("../data/final/en_US/en_US.news.txt")
twitter <- read_lines("../data/final/en_US/en_US.twitter.txt")

# Generate a random sample of all sources
sample_twitter <- sample(twitter, 150000)
sample_news <- sample(news, 150000)
sample_blogs <- sample(blogs, 150000)
text_sample <- c(sample_twitter,sample_news,sample_blogs)

# Save sample
writeLines(text_sample, "text_sample.txt")
