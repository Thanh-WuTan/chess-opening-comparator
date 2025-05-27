library(ggplot2)

plot_time_control_distribution <- function(data1, data2, opening1, opening2) {
  combined_data <- rbind(
    data.frame(time_control = data1$time_control, game_count = data1$game_count, opening = opening1),
    data.frame(time_control = data2$time_control, game_count = data2$game_count, opening = opening2)
  )
  
  ggplot(combined_data, aes(x = time_control, y = game_count, fill = opening)) +
    geom_bar(stat = "identity", position = "dodge") +
    labs(
      title = "Time Control Distribution Comparison",
      x = "Time Control",
      y = "Number of Games"
    ) +
    scale_fill_manual(values = c("#1f77b4", "#ff7f0e")) +
    theme_minimal() +
    theme(
      plot.title = element_text(hjust = 0.5),
      axis.text.x = element_text(angle = 45, hjust = 1)
    )
}