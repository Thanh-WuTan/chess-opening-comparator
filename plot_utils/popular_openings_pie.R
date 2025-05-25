# plot_utils/popular_openings_pie.R

library(ggplot2)

plot_opening_pie <- function(data, elo_min, elo_max) {
  # Tính tổng số game của toàn bộ elo (dữ liệu chưa bị giới hạn 6 khai cuộc)
  global_total <- sum(data$game_count)
  
  # Sắp xếp theo game_count giảm dần
  data <- data[order(-data$game_count), ]
  
  # Loại bỏ nhóm "other" hoặc "others" (không hiển thị)
  data <- data[!tolower(data$opening_name) %in% c("other", "others"), ]
  
  # Nếu còn nhiều hơn 6 khai cuộc, chỉ lấy 6 khai cuộc phổ biến nhất
  if(nrow(data) > 6) {
    data <- data[1:6, ]
  }
  
  # Tính phần trăm của từng khai cuộc so với tổng số game của elo
  data$percentage <- round((data$game_count / global_total) * 100, 1)
  
  # Sắp xếp khai cuộc theo thứ tự phần trăm giảm dần
  data$opening_name <- factor(data$opening_name, levels = data$opening_name[order(data$percentage, decreasing = TRUE)])
  
  # Vẽ bar chart ngang:
  ggplot(data, aes(x = percentage, y = opening_name, fill = opening_name)) +
    geom_col(width = 0.6) +
    # Hiển thị nhãn % ngay đầu cột (ở bên ngoài cột)
    geom_text(aes(label = paste0(percentage, "%")), hjust = -0.1, size = 3) +
    # Hiển thị tên khai cuộc bên phải của cột (vị trí cố định dựa vào giá trị max)
    geom_text(aes(x = max(percentage) * 1.05, label = opening_name), size = 3, hjust = 0) +
    labs(
      title = paste0("Top Popular Openings for ELO ", elo_min, "-", elo_max),
      x = "Percentage (%)",
      y = NULL
    ) +
    scale_fill_brewer(palette = "Set3") +
    theme_minimal() +
    theme(
      plot.title = element_text(hjust = 0.5),
      # Ẩn trục y vì tên khai cuộc được in bên phải
      axis.text.y = element_blank(),
      legend.position = "none"
    ) +
    xlim(0, max(data$percentage) * 1.2)
}
