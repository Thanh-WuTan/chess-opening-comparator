# db_utils/popular_openings_helpers.R

library(DBI)

get_top_openings_by_elo_range <- function(con, elo_min, elo_max, top_n =15) {
  query <- sprintf("
    SELECT o.name AS opening_name, COUNT(*) AS game_count
    FROM games g
    JOIN openings o ON g.opening_id = o.opening_id
    WHERE g.avg_elo BETWEEN %d AND %d
    GROUP BY o.name
    ORDER BY game_count DESC", elo_min, elo_max)
  
  data <- dbGetQuery(con, query)
  
  if (nrow(data) > top_n) {
    top_data <- data[1:top_n, ]
    others_count <- sum(data[(top_n + 1):nrow(data), "game_count"])
    top_data <- rbind(top_data, data.frame(opening_name = "Other", game_count = others_count))
    return(top_data)
  } else {
    return(data)
  }
}
