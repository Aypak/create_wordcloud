source("global.R")
ui <- fluidPage(
    h1("Create Word Cloud"),
    sidebarLayout(
        sidebarPanel(
            radioButtons(
                inputId = "source",
                label = "Word source",
                choices = c(
                    "Movie Reviews" = "movie_reviews",
                    "Use your own words" = "own",
                    "Upload a file" = "file"
                )
            ),
            conditionalPanel(
                condition = "input.source == 'own'",
                textAreaInput("text", "Enter text", rows = 7)
            ),
            conditionalPanel(
                condition = "input.source == 'file'",
                fileInput("file", "Select a file")
            ),
            numericInput("num", "Maximum number of words",
                         value = 100, min = 5),
            colourInput("col", "Background color", value = "white"),
            # Add a "draw" button to the app
            actionButton(inputId = "draw", label = "Draw!")
        ),
        mainPanel(
            wordcloud2Output("cloud")
        )
    )
)

server <- function(input, output) {
    data_source <- reactive({
        if (input$source == "movie_reviews") {
            data <- movie_reviews
        } else if (input$source == "own") {
            data <- input$text
        } else if (input$source == "file") {
            data <- input_file()
        }
        return(data)
    })
    
    input_file <- reactive({
        if (is.null(input$file)) {
            return("")
        }
        readLines(input$file$datapath)
    })
    
    output$cloud <- renderWordcloud2({
        # Add the draw button as a dependency to
        # cause the word cloud to re-render on click
        input$draw
        isolate({
            create_wordcloud(data_source(), num_words = input$num,
                             background = input$col)
        })
    })
}

shinyApp(ui = ui, server = server)