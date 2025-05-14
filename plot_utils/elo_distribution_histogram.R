library(ggplot2)

plot_elo_distribution <- function(data1, data2, opening1, opening2) {
  combined_data <- rbind(
    data.frame(avg_elo = data1$avg_elo, opening = opening1),
    data.frame(avg_elo = data2$avg_elo, opening = opening2)
  )
  
  ggplot(combined_data, aes(x = avg_elo, fill = opening)) +
    geom_histogram(alpha = 0.6, position = "identity", bins = 30) +
    labs(
      title = "ELO Distribution Comparison",
      x = "ELO",
      y = "Frequency"
    ) +
    scale_fill_manual(values = c("#1f77b4", "#ff7f0e")) +
    theme_minimal() +
    theme(plot.title = element_text(hjust = 0.5))
}