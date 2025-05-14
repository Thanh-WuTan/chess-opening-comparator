# plot_utils/popular_openings_pie.R

library(ggplot2)

plot_opening_pie <- function(data, elo_min, elo_max) {
  ggplot(data, aes(x = "", y = game_count, fill = opening_name)) +
    geom_bar(width = 1, stat = "identity") +
    coord_polar("y") +
    labs(
      title = paste0("Top Openings for ELO ", elo_min, "-", elo_max),
      fill = "Opening"
    ) +
    theme_minimal() +
    theme(
      axis.text = element_blank(),
      axis.ticks = element_blank(),
      panel.grid = element_blank(),
      plot.title = element_text(hjust = 0.5)
    )
}
