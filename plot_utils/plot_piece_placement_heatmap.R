library(ggplot2)
library(gridExtra)

plot_piece_placement_heatmap <- function(data1, data2, opening1, opening2) {
  # Function to create a single heatmap
  create_heatmap <- function(data, title) {
    ggplot(data, aes(x = file, y = rank, fill = count)) +
      geom_tile(color = "black") +
      scale_fill_gradient(low = "white", high = "red", name = "Placement Count") +
      scale_x_discrete(limits = letters[1:8]) +
      scale_y_continuous(breaks = 1:8) +
      labs(title = title, x = "File", y = "Rank") +
      theme_minimal() +
      theme(
        plot.title = element_text(hjust = 0.5, size = 12),
        axis.text = element_text(size = 10),
        panel.grid = element_blank()
      )
  }
  
  # Create heatmaps for each opening
  p1 <- create_heatmap(data1, paste("Piece Placement for", opening1))
  p2 <- create_heatmap(data2, paste("Piece Placement for", opening2))
  
  # Arrange plots side by side
  grid.arrange(p1, p2, ncol = 2)
}