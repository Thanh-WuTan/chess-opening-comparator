# db_utils/get_castling_stats.R
library(DBI)

get_castling_stats <- function(con, opening_name) {
  # Query all games for the given opening
  query <- paste0(
    "SELECT an
     FROM games g
     JOIN openings o ON g.opening_id = o.opening_id
     WHERE o.name = '", dbEscapeStrings(con, opening_name), "'"
  )
  
  games <- dbGetQuery(con, query)
  
  # Initialize counters
  white_kingside <- 0
  white_queenside <- 0
  black_kingside <- 0
  black_queenside <- 0
  total_games <- nrow(games)
  
  # Analyze each game's moves
  for (an in games$an) {
    moves <- unlist(strsplit(an, " "))
    
    # Detect White castling
    if (any(moves == "O-O") && !any(moves == "O-O-O")) {
      white_kingside <- white_kingside + 1
    } else if (any(moves == "O-O-O")) {
      white_queenside <- white_queenside + 1
    }
    
    # Detect Black castling (check moves after White's move)
    # Since moves alternate, Black's castling will be in odd positions after the number
    black_moves <- moves[seq(3, length(moves), by=3)]
    if (any(black_moves == "O-O") && !any(black_moves == "O-O-O")) {
      black_kingside <- black_kingside + 1
    } else if (any(black_moves == "O-O-O")) {
      black_queenside <- black_queenside + 1
    }
  }
  
  # Calculate White castling stats
  white_no_castling <- total_games - (white_kingside + white_queenside)
  
  # Calculate Black castling stats
  black_no_castling <- total_games - (black_kingside + black_queenside)
  
  # Calculate castling side stats (same, opposite, no castling)
  same_side <- 0
  opposite_side <- 0
  for (an in games$an) {
    moves <- unlist(strsplit(an, " "))
    white_moves <- moves[seq(2, length(moves), by=3)]
    black_moves <- moves[seq(3, length(moves), by=3)]
    
    white_castle <- "none"
    black_castle <- "none"
    
    if (any(white_moves == "O-O")) white_castle <- "kingside"
    else if (any(white_moves == "O-O-O")) white_castle <- "queenside"
    
    if (any(black_moves == "O-O")) black_castle <- "kingside"
    else if (any(black_moves == "O-O-O")) black_castle <- "queenside"
    
    if (white_castle == "none" || black_castle == "none") {
      # Counted in no_castling later
    } else if (white_castle == black_castle) {
      same_side <- same_side + 1
    } else {
      opposite_side <- opposite_side + 1
    }
  }
  
  no_castling_side <- total_games - (same_side + opposite_side)
  
  # Return data as a list of data frames for each category
  list(
    white_castling = data.frame(
      category = c("Kingside", "Queenside", "No Castling"),
      count = c(white_kingside, white_queenside, white_no_castling),
      stringsAsFactors = FALSE
    ),
    black_castling = data.frame(
      category = c("Kingside", "Queenside", "No Castling"),
      count = c(black_kingside, black_queenside, black_no_castling),
      stringsAsFactors = FALSE
    ),
    castling_side = data.frame(
      category = c("Same", "Opposite", "No Castling"),
      count = c(same_side, opposite_side, no_castling_side),
      stringsAsFactors = FALSE
    )
  )
}