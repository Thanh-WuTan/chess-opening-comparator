# Function to fetch stats for a given opening
get_opening_stats <- function(con, opening_name) {
  query <- paste0(
    "SELECT 
       COUNT(*) as total_games,
       SUM(CASE WHEN result = 'w' THEN 1 ELSE 0 END) as white_wins,
       SUM(CASE WHEN result = 'b' THEN 1 ELSE 0 END) as black_wins,
       SUM(CASE WHEN result = 'd' THEN 1 ELSE 0 END) as draws
     FROM games g
     JOIN openings o ON g.opening_id = o.opening_id
     WHERE o.name = '", dbEscapeStrings(con, opening_name), "'"
  )
  
  stats <- dbGetQuery(con, query)
  
  if (nrow(stats) > 0 && stats$total_games > 0) {
    stats$white_win_pct <- round((stats$white_wins / stats$total_games) * 100, 2)
    stats$black_win_pct <- round((stats$black_wins / stats$total_games) * 100, 2)
    stats$draw_pct <- round((stats$draws / stats$total_games) * 100, 2)
  } else {
    stats$white_win_pct <- 0
    stats$black_win_pct <- 0
    stats$draw_pct <- 0
  }
  
  return(stats)
}

# Function to fetch game length data for a given opening
get_game_lengths <- function(con, opening_name) {
  query <- paste0(
    "SELECT g.nb_of_moves AS game_length
     FROM games g
     JOIN openings o ON g.opening_id = o.opening_id
     WHERE o.name = '", dbEscapeStrings(con, opening_name), "'"
  )
  
  data <- dbGetQuery(con, query)
  return(data)
}

# Function to fetch ELO data for a given opening
get_elo_distribution <- function(con, opening_name) {
  query <- paste0(
    "SELECT g.avg_elo
     FROM games g
     JOIN openings o ON g.opening_id = o.opening_id
     WHERE o.name = '", dbEscapeStrings(con, opening_name), "'"
  )
  
  data <- dbGetQuery(con, query)
  return(data)
}