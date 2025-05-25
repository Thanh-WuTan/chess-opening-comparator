# Loading required libraries
library(shiny)
library(ggplot2)
library(reticulate)

# Import hàm chat() từ Gemini.py
source_python("Gemini.py")

# Sourcing helper functions
source("db_utils/con_helpers.R")
source("db_utils/games_helpers.R")
source("db_utils/openings_helpers.R")
source("db_utils/popular_openings_helpers.R")   # NEW
source("plot_utils/win_loss_rate.R")
source("plot_utils/popular_openings_pie.R")     # NEW
source("plot_utils/elo_distribution_histogram.R")



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
      
      hr(),
      h4("Popular Openings by ELO Range"),
      sliderInput(
        "elo_range",
        "Select ELO Range:",
        min   = 1000,
        max   = 2800,
        value = c(1400, 1600),
        step  = 100
      ),
      actionButton("show_pie", "Show Popular Openings")
    ),
    
    mainPanel(
      # Đẩy phần Opening Moves lên đầu với tiêu đề riêng cho mỗi opening
      h4(textOutput("opening1_title")),
      verbatimTextOutput("opening1_moves"),
      hr(),
      h4(textOutput("opening2_title")),
      verbatimTextOutput("opening2_moves"),
      hr(),
      
      h3(textOutput("comparison_title")),
      plotOutput("win_plot", height = "400px"),
      hr(),
      plotOutput("popular_openings_plot", height = "450px"),
      hr(),
      plotOutput("game_length_violin_plot", height = "450px"),
      hr(),
      plotOutput("elo_distribution_plot", height = "450px")
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
  
  # 5. Pie chart – Popular openings by ELO range
  output$popular_openings_plot <- renderPlot({
    input$show_pie  # trigger
    
    isolate({
      elo_min <- input$elo_range[1]
      elo_max <- input$elo_range[2]
      
      top_data <- get_top_openings_by_elo_range(con, elo_min, elo_max, top_n = 15)
      
      if (nrow(top_data) == 0) {
        ggplot() +
          annotate("text", x = 1, y = 1,
                   label = "No data available for selected ELO range") +
          theme_minimal()
      } else {
        plot_opening_pie(top_data, elo_min, elo_max)
      }
    })
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
  
  # Hàm làm sạch kết quả trả về từ Gemini (loại bỏ markdown, kí tự thừa,...)
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
  
  # 8. Lấy và hiển thị danh sách các bước mở cờ từ hàm chat()
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
      
      # Cập nhật tiêu đề cho từng opening
      output$opening1_title <- renderText({
        paste("Opening Moves for", input$opening1)
      })
      output$opening2_title <- renderText({
        paste("Opening Moves for", input$opening2)
      })
    }
  })
  
  # 9. Clean-up
  onStop(function() { dbDisconnect(con) })
}

# ---------------------------- RUN --------------------------------
shinyApp(ui = ui, server = server)
