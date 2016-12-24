library(shiny)

shinyUI(fluidPage(
  
    # Application title
    titlePanel("Next Word Prediction"),
    h4("Final Project for the Coursera Data Science Capstone Course by David Waterman", style="color:gray"),
    hr(),
  
    # Sidebar for text entry field
    sidebarLayout(
        sidebarPanel(
            textInput("text", label = h3("Enter Text:"), value = "What"),
            helpText("Type in a sentence above, hit enter (or press the Predict button), and the results will display to the right."),
            hr()
        ),
    
        # Main Panel for text output
        mainPanel(
            br(),
            h2(textOutput("entered_words"), align="center"),
            h1(textOutput("predicted_word"), align="center", style="color:blue")
        )
    )
))