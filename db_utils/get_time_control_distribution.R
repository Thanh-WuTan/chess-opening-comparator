library(DBI)

get_time_control_distribution <- function(con, opening_name) {
  query <- paste0(
    "SELECT COALESCE(TimeControl, 'Unknown') AS time_control, COUNT(*) AS game_count
     FROM games g
     JOIN openings o ON g.opening_id = o.opening_id
     WHERE o.name = '", dbEscapeStrings(con, opening_name), "'
     GROUP BY TimeControl"
  )
  
  data <- dbGetQuery(con, query)
  return(data)
}