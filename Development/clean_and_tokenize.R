options(java.parameters = "-Xmx16g")
library(dplyr)
library(NLP)
#library(qdap)
#library(qdapDictionaries)
#library(qdapRegex)
#library(qdapTools)
#library(RColorBrewer)
#library(rJava)
library(RWeka)
#library(RWekajars)
#library(slam)
#library(SnowballC)
library(tidyr)
library(tm)

# Build a clean corpus

the_sample_con <- file("./text_sample.txt")
the_sample <- readLines(the_sample_con)
close(the_sample_con)

profanity_words <- read.table("./profanityfilter.txt", header = FALSE)

# Build the corpus, and specify the source to be character vectors 
clean_sample <- Corpus(VectorSource(the_sample))

rm(the_sample)

# Make it work with the new tm package
#clean_sample <- tm_map(clean_sample,
#                      content_transformer(function(x) 
#                              iconv(x, to="UTF-8", sub="byte")))

# Convert to lower case
clean_sample <- tm_map(clean_sample, content_transformer(tolower), lazy = TRUE)

# Remove punction; numbers; URLs; stop, profanity, and stem words
clean_sample <- tm_map(clean_sample, content_transformer(removePunctuation))
clean_sample <- tm_map(clean_sample, content_transformer(removeNumbers))
removeURL <- function(x) gsub("http[[:alnum:]]*", "", x) 
clean_sample <- tm_map(clean_sample, content_transformer(removeURL))
clean_sample <- tm_map(clean_sample, stripWhitespace)
clean_sample <- tm_map(clean_sample, removeWords, profanity_words[,1])
clean_sample <- tm_map(clean_sample, stemDocument)
clean_sample <- tm_map(clean_sample, stripWhitespace)

# Save the final corpus
saveRDS(clean_sample, file = "./final_corpus.RData")
rm(clean_sample)

# Build the n-grams
final_corpus <- readRDS("./final_corpus.RData")
final_corpus_DF <-data.frame(text=unlist(sapply(final_corpus,`[`, "content")), 
                           stringsAsFactors = FALSE)

# Build the tokenization function for the n-grams
ngramTokenizer <- function(the_corpus, ngramCount) {
    ngramFunction <- NGramTokenizer(the_corpus, 
                                    Weka_control(min = ngramCount, max = ngramCount, 
                                                 delimiters = " \\r\\n\\t.,;:\"()?!"))
    ngramFunction <- data.frame(table(ngramFunction))
    ngramFunction <- ngramFunction[order(ngramFunction$Freq, 
                                         decreasing = TRUE),]
    colnames(ngramFunction) <- c("String","Count")
    ngramFunction
}


# gc(verbose = getOption("verbose"), reset=FALSE)  ????

unigram <- ngramTokenizer(final_corpus_DF, 1)
saveRDS(unigram, file = "./unigram.RData")
bigram <- ngramTokenizer(final_corpus_DF, 2)
bigram <- bigram[bigram$Count>1,]
bigram <- bigram %>% separate(String, c("unigram","bigram"), " ", remove=TRUE)
names(bigram)[3] <- "frequency"
saveRDS(bigram, file = "./bigram.RData")
trigram <- ngramTokenizer(final_corpus_DF, 3)
trigram <- trigram[trigram$Count>1,]
trigram <- trigram %>% separate(String, c("unigram","bigram","trigram"), " ", remove=TRUE)
names(trigram)[4] <- "frequency"
saveRDS(trigram, file = "./trigram.RData")
quadgram <- ngramTokenizer(final_corpus_DF, 4)
quadgram <- quadgram[quadgram$Count>1,]
quadgram <- quadgram %>% separate(String, c("unigram","bigram","trigram","quadgram"), " ", remove=TRUE)
names(quadgram)[5] <- "frequency"
saveRDS(quadgram, file = "./quadgram.RData")
