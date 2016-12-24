suppressPackageStartupMessages(c(
    library(markdown),
    library(shinythemes),
    library(shiny),
    library(stringr),
    library(stylo),
    library(tm)))

source("./inputCleaner.R")
bigrams <- readRDS(file="./data/bigrams.RData")
trigrams <- readRDS(file="./data/trigrams.RData")
quadgrams <- readRDS(file="./data/quadgrams.RData")

shinyServer(function(input, output) {
    wordPrediction <- reactive({
        text <- input$text
        textInput <- cleanInput(text)
        wordCount <- length(textInput)
        wordPrediction <- nextWordPrediction(wordCount,textInput)
    })
        
    output$predicted_word <- renderPrint(wordPrediction())
    output$entered_words <- renderText({ input$text }, quoted = FALSE)
})