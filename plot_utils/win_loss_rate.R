# Loading required libraries
library(ggplot2)

# Function to plot win/draw/loss percentages for two openings
plot_win_loss_rate <- function(stats1, stats2, opening1_name, opening2_name) {
  # Preparing data for plotting
  plot_data <- data.frame(
    Opening = rep(c(opening1_name, opening2_name), each = 3),
    Outcome = rep(c("White Win", "Black Win", "Draw"), 2),
    Percentage = c(
      stats1$white_win_pct, stats1$black_win_pct, stats1$draw_pct,
      stats2$white_win_pct, stats2$black_win_pct, stats2$draw_pct
    )
  )
  
  # Creating stacked bar plot
  ggplot(plot_data, aes(x = Opening, y = Percentage, fill = Outcome)) +
    geom_bar(stat = "identity", position = "stack") +
    labs(
      title = "Win/Draw/Loss Comparison",
      x = "Opening",
      y = "Percentage (%)"
    ) +
    theme_minimal() +
    theme(
      panel.background = element_rect(fill = "#E6ECF0"),
      plot.background = element_rect(fill = "#E6ECF0"),
      axis.text.x = element_text(angle = 45, hjust = 1)
    ) +
    scale_fill_manual(values = c("White Win" = "#FFFFFF", "Black Win" = "#000000", "Draw" = "#808080"))
}