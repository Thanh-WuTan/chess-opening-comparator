# Install required packages
source("install_packages.R")

# Loading required libraries
library(shiny)
library(ggplot2)
library(reticulate)

source_python("Gemini.py")

# Sourcing helper functions
source("db_utils/con_helpers.R")
source("db_utils/games_helpers.R")
source("db_utils/openings_helpers.R")
source("db_utils/get_time_control_distribution.R")
source("plot_utils/game_length_violin.R")
source("plot_utils/win_loss_rate.R")
source("plot_utils/elo_distribution_histogram.R")
source("plot_utils/plot_time_control_distribution.R")

# ----------------------------- UI ---------------------------------
ui <- fluidPage(
  tags$style(HTML("body { background-color: #E6ECF0; }")),
  titlePanel("Chess Opening Comparator"),
  
  sidebarLayout(
    sidebarPanel(
      h4("Select Openings"),
      selectInput("opening1", "First Opening:", choices = c("Loading...")),
      selectInput("opening2", "Second Opening:", choices = c("Loading...")),
      actionButton("compare", "Compare Openings"),
    ),
    
    mainPanel(
      # Opening Moves section
      h2(textOutput("comparison_title")),
      h4(textOutput("opening1_title")),
      verbatimTextOutput("opening1_moves"),
      hr(),
      h4(textOutput("opening2_title")),
      verbatimTextOutput("opening2_moves"),
      hr(),
      
      # Win/Loss Rate Plot
      h3("Win/Loss Rate Comparison"),
      plotOutput("win_plot", height = "400px"),
      hr(),
      
      # Game Length Violin Plot
      h3("Game Length Distribution"),
      plotOutput("game_length_violin_plot", height = "450px"),
      hr(),
      
      # ELO Distribution Plot
      h3("ELO Distribution Comparison"),
      plotOutput("elo_distribution_plot", height = "450px"),
      hr(),
      
      # Time Control Distribution Plot
      h3("Time Control Distribution Comparison"),
      plotOutput("time_control_plot", height = "450px"),
      hr(),
    )
  )
)

# --------------------------- SERVER -------------------------------
server <- function(input, output, session) {
  # 1. Establish DB connection
  con <- get_db_connection()
  
  # 2. Populate opening choices
  openings <- reactive({ get_opening_names(con) })
  
  observe({
    updateSelectInput(session, "opening1", choices = openings())
    updateSelectInput(session, "opening2", choices = openings())
  })
  
  # 3. Comparison title
  output$comparison_title <- renderText({
    if (input$compare == 0 ||
        input$opening1 == "Select an opening" ||
        input$opening2 == "Select an opening") {
      "Select two openings and click Compare"
    } else {
      paste(input$opening1, "vs", input$opening2)
    }
  })
  
  # 4. Win / Draw / Loss stacked bar
  output$win_plot <- renderPlot({
    if (input$compare == 0 ||
        input$opening1 == "Select an opening" ||
        input$opening2 == "Select an opening") {
      return(NULL)
    }
    
    stats1 <- get_opening_stats(con, input$opening1)
    stats2 <- get_opening_stats(con, input$opening2)
    
    if (nrow(stats1) == 0 || stats1$total_games == 0 ||
        nrow(stats2) == 0 || stats2$total_games == 0) {
      ggplot() +
        annotate("text", x = 1, y = 1,
                 label = "No data available for one or both openings") +
        theme_minimal()
    } else {
      plot_win_loss_rate(stats1, stats2, input$opening1, input$opening2)
    }
  })

  
  # 6. Game length violin plot
  output$game_length_violin_plot <- renderPlot({
    if (input$compare == 0 ||
        input$opening1 == "Select an opening" ||
        input$opening2 == "Select an opening") {
      return(NULL)
    }
    
    data1 <- get_game_lengths(con, input$opening1)
    data2 <- get_game_lengths(con, input$opening2)
    
    if (nrow(data1) == 0 || nrow(data2) == 0) {
      ggplot() +
        annotate("text", x = 1, y = 1,
                 label = "No data available for one or both openings") +
        theme_minimal()
    } else {
      plot_game_length_violin(data1, data2, input$opening1, input$opening2)
    }
  })
  
  # 7. ELO distribution plot
  output$elo_distribution_plot <- renderPlot({
    if (input$compare == 0 ||
        input$opening1 == "Select an opening" ||
        input$opening2 == "Select an opening") {
      return(NULL)
    }
    
    data1 <- get_elo_distribution(con, input$opening1)
    data2 <- get_elo_distribution(con, input$opening2)
    
    if (nrow(data1) == 0 || nrow(data2) == 0) {
      ggplot() +
        annotate("text", x = 1, y = 1,
                 label = "No data available for one or both openings") +
        theme_minimal()
    } else {
      plot_elo_distribution(data1, data2, input$opening1, input$opening2)
    }
  })
  
  # 8. Time control distribution plot
  output$time_control_plot <- renderPlot({
    if (input$compare == 0 ||
        input$opening1 == "Select an opening" ||
        input$opening2 == "Select an opening") {
      return(NULL)
    }
    
    data1 <- get_time_control_distribution(con, input$opening1)
    data2 <- get_time_control_distribution(con, input$opening2)
    
    if (nrow(data1) == 0 || nrow(data2) == 0) {
      ggplot() +
        annotate("text", x = 1, y = 1,
                 label = "No data available for one or both openings") +
        theme_minimal()
    } else {
      plot_time_control_distribution(data1, data2, input$opening1, input$opening2)
    }
  })
  
  # 9. Clean Gemini output
  clean_moves <- function(text) {
    text <- gsub("```python", "", text)
    text <- gsub("```", "", text)
    text <- gsub("\n", "", text)
    text <- gsub("\\[|\\]", "", text)
    text <- gsub("'", "", text)
    text <- gsub(",", "", text)
    text <- trimws(text)
    return(text)
  }
  
  # 10. Fetch and display opening moves from chat()
  observeEvent(input$compare, {
    if (input$opening1 != "Select an opening" && input$opening2 != "Select an opening") {
      moves1_raw <- chat(input$opening1)
      moves2_raw <- chat(input$opening2)
      
      moves1 <- clean_moves(moves1_raw)
      moves2 <- clean_moves(moves2_raw)
      
      output$opening1_moves <- renderText({
        moves1
      })
      output$opening2_moves <- renderText({
        moves2
      })
      
      # Update titles for each opening
      output$opening1_title <- renderText({
        paste("Opening Moves for", input$opening1)
      })
      output$opening2_title <- renderText({
        paste("Opening Moves for", input$opening2)
      })
    }
  })
  
  # 11. Clean-up
  onStop(function() { dbDisconnect(con) })
}

# ---------------------------- RUN --------------------------------
shinyApp(ui = ui, server = server)