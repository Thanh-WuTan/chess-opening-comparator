# Loading required libraries
library(ggplot2)

# Function to plot win/draw/loss percentages for two openings
plot_win_loss_rate <- function(stats1, stats2, opening1, opening2) {
  # Chỉ lấy White Wins và Black Wins
  outcomes <- c("White Wins", "Black Wins")
  
  # Lấy tỷ lệ cho mỗi opening
  values1 <- c(stats1$white_win_pct, stats1$black_win_pct)
  values2 <- c(stats2$white_win_pct, stats2$black_win_pct)
  
  # Tạo data frame gồm thông tin cho cả 2 opening
  data <- data.frame(
    Opening = factor(rep(c(opening1, opening2), each = 2), levels = c(opening1, opening2)),
    Outcome = rep(outcomes, times = 2),
    Percentage = c(values1, values2)
  )
  
  # Tính toán vị trí x (theo trục hoành) cho nhãn:
  # Đối với White Wins: đặt nhãn tại điểm = 1/2 * white_win_pct (là cạnh bên trái của cột)
  # Đối với Black Wins: đặt nhãn tại điểm = white_win_pct + 1/2 * black_win_pct (là cạnh bên phải)
  data$xpos <- NA
  for(o in levels(data$Opening)) {
    idx <- which(data$Opening == o)
    white_pct <- data$Percentage[idx][data$Outcome[idx] == "White Wins"]
    black_pct <- data$Percentage[idx][data$Outcome[idx] == "Black Wins"]
    data$xpos[which(data$Opening == o & data$Outcome == "White Wins")] <- white_pct / 2
    data$xpos[which(data$Opening == o & data$Outcome == "Black Wins")] <- white_pct + black_pct / 2
  }
  
  # Thiết lập màu cho nhãn: với White Wins thì text màu đen, với Black Wins thì text màu trắng
  data$text_color <- ifelse(data$Outcome == "White Wins", "black", "white")
  
  ggplot(data, aes(x = Percentage, y = Opening, fill = Outcome)) +
    geom_bar(stat = "identity", position = "stack", width = 0.6) +
    scale_fill_manual(values = c("White Wins" = "#e0d1d1",
                                 "Black Wins" = "#000000")) +
    geom_text(aes(x = xpos, label = Percentage, color = text_color),
              size = 3, show.legend = FALSE) +
    scale_color_identity() +
    labs(
      title = "Win Comparison (White & Black Wins)",
      x = "Percentage (%)",
      y = "Opening"
    ) +
    theme_minimal() +
    theme(
      plot.title = element_text(hjust = 0.5),
      axis.text.x = element_text(size = 10),
      axis.text.y = element_text(size = 10),
      legend.title = element_blank()
    )
}