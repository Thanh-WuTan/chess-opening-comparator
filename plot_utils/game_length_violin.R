library(ggplot2)

plot_game_length_violin <- function(data1, data2, opening1, opening2) {
  combined_data <- rbind(
    data.frame(game_length = data1$game_length, opening = opening1),
    data.frame(game_length = data2$game_length, opening = opening2)
  )
  
  ggplot(combined_data, aes(x = opening, y = game_length, fill = opening)) +
    geom_violin(trim = FALSE) +
    labs(
      title = "Game Length Distribution",
      x = "Opening",
      y = "Game Length (moves)"
    ) +
    theme_minimal() +
    theme(plot.title = element_text(hjust = 0.5))
}