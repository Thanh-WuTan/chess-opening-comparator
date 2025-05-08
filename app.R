# Loading required libraries
library(shiny)
library(ggplot2)

# Sourcing helper functions
source("db_utils/con_helpers.R")
source("db_utils/games_helpers.R")
source("db_utils/openings_helpers.R")
source("plot_utils/win_loss_rate.R")

# Defining the UI
ui <- fluidPage(
  # Setting background color
  tags$style(HTML("body { background-color: #E6ECF0; }")),
  titlePanel("Chess Opening Comparator"),
  sidebarLayout(
    sidebarPanel(
      h4("Select Openings"),
      selectInput("opening1", "First Opening:", choices = c("Loading...")),
      selectInput("opening2", "Second Opening:", choices = c("Loading...")),
      actionButton("compare", "Compare Openings")
    ),
    mainPanel(
      h3(textOutput("comparison_title")),
      plotOutput("win_plot")
    )
  )
)

# Defining the server logic
server <- function(input, output, session) {
  # Establishing database connection
  con <- get_db_connection()
  
  # Fetching openings from the database
  openings <- reactive({
    get_opening_names(con)
  })
  
  # Updating selectInputs with openings from database
  observe({
    updateSelectInput(session, "opening1", choices = openings())
    updateSelectInput(session, "opening2", choices = openings())
  })
  
  # Rendering comparison title
  output$comparison_title <- renderText({
    if (input$compare == 0 || input$opening1 == "Select an opening" || input$opening2 == "Select an opening") {
      "Select two openings and click Compare"
    } else {
      paste(input$opening1, "vs", input$opening2)
    }
  })
  
  # Rendering win/draw/loss plot
  output$win_plot <- renderPlot({
    if (input$compare == 0 || input$opening1 == "Select an opening" || input$opening2 == "Select an opening") {
      return(NULL)
    }
    
    stats1 <- get_opening_stats(con, input$opening1)
    stats2 <- get_opening_stats(con, input$opening2)
    
    if (nrow(stats1) == 0 || stats1$total_games == 0 || nrow(stats2) == 0 || stats2$total_games == 0) {
      return(ggplot() + annotate("text", x = 1, y = 1, label = "No data available for one or both openings") + theme_minimal())
    }
    
    plot_win_loss_rate(stats1, stats2, input$opening1, input$opening2)
  })
  
  # Closing database connection when app stops
  onStop(function() {
    dbDisconnect(con)
  })
}

# Running the Shiny app
shinyApp(ui = ui, server = server)