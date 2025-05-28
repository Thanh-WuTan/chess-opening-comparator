library(ggplot2)
library(gridExtra)
library(grid)
library(cowplot)  # for get_legend()

plot_castling_stats <- function(stats1, stats2, opening1, opening2) {
  # Function to create a single donut chart without title and without legend
  create_donut <- function(data, show_legend = FALSE) {
    data$percent <- data$count / sum(data$count) * 100
    data$label <- paste0(round(data$count / 1000, 1), "K (", round(data$percent, 1), "%)")
    
    p <- ggplot(data, aes(x = 1.5, y = count, fill = category)) +
      geom_bar(stat = "identity", width = 0.7) +  
      coord_polar(theta = "y") +
      xlim(0, 2) +
      scale_fill_manual(
        values = c("Kingside" = "#1f77b4", "Queenside" = "#ff7f0e", "No Castling" = "#d3d3d3"),
        guide = if (show_legend) guide_legend(title = "Castling Type") else "none"
      ) +
      theme_void() +
      theme(
        legend.title = element_text(size = 9),
        legend.text = element_text(size = 8),
        legend.background = element_blank()
      ) +
      geom_text(aes(label = label), position = position_stack(vjust = 0.5), size = 3.5)
    
    return(p)
  }
  
  # Helper to create a titled plot stack
  titled_donut <- function(title_text, data, show_legend = FALSE) {
    title_grob <- textGrob(title_text, gp = gpar(fontsize = 12, fontface = "bold"), just = "center")
    donut_plot <- create_donut(data, show_legend)
    arranged <- arrangeGrob(title_grob, donut_plot, ncol = 1, heights = c(0, 1))
    return(arranged)
  }
  
  # Create one dummy plot with legend to extract the shared legend
  dummy_plot <- create_donut(stats1$white_castling, show_legend = TRUE)
  shared_legend <- get_legend(dummy_plot)
  
  # Create titled plots without individual legends
  p1_white <- titled_donut(paste("White Castling\n", opening1), stats1$white_castling)
  p1_black <- titled_donut(paste("Black Castling\n", opening1), stats1$black_castling)
  p2_white <- titled_donut(paste("White Castling\n", opening2), stats2$white_castling)
  p2_black <- titled_donut(paste("Black Castling\n", opening2), stats2$black_castling)
  
  # Arrange 2x2 grid of plots
  donut_grid <- arrangeGrob(
    p1_white, p1_black,
    p2_white, p2_black,
    nrow = 2, ncol = 2
  )
  
  # Final layout: grid + legend to the right
  final_plot <- arrangeGrob(
    donut_grid,
    shared_legend,
    ncol = 2,
    widths = c(4, 1),
    top = textGrob("", gp = gpar(fontsize = 16, fontface = "bold"))
  )
  
  # Draw the full layout
  grid.newpage()
  grid.draw(final_plot)
}
