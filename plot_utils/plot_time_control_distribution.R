# plot_utils/plot_time_control_distribution.R
library(ggplot2)

plot_time_control_distribution <- function(data1, data2, opening1, opening2) {
  combined_data <- rbind(
    data.frame(time_control = data1$time_control, game_count = data1$game_count, opening = opening1),
    data.frame(time_control = data2$time_control, game_count = data2$game_count, opening = opening2)
  )
  
  # Calculate total game count per time control
  total_counts <- aggregate(game_count ~ time_control, data = combined_data, sum)
  
  # Select top 10 time controls
  top_time_controls <- head(total_counts[order(-total_counts$game_count), "time_control"], 10)
  
  # Filter combined data to only include top 10
  combined_data <- combined_data[combined_data$time_control %in% top_time_controls, ]
  
  # Split time_control into base and increment for sorting
  time_parts <- do.call(rbind, lapply(combined_data$time_control, function(tc) {
    if (tc == "Unknown") {
      return(c(base = Inf, increment = 0))
    }
    parts <- as.numeric(unlist(strsplit(tc, "\\+")))
    return(c(base = parts[1], increment = parts[2]))
  }))
  
  # Add parsed base and increment
  combined_data$base <- time_parts[, "base"]
  combined_data$increment <- time_parts[, "increment"]
  
  # Sort by base and increment
  combined_data <- combined_data[order(combined_data$base, combined_data$increment), ]
  
  # Reorder factor levels
  combined_data$time_control <- factor(
    combined_data$time_control,
    levels = unique(combined_data$time_control)
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
