library(DBI)

get_piece_placement <- function(con, opening_name) {
  # Query to fetch algebraic notation for the given opening
  query <- paste0(
    "SELECT an
     FROM games g
     JOIN openings o ON g.opening_id = o.opening_id
     WHERE o.name = '", dbEscapeStrings(con, opening_name), "'"
  )
  
  games <- dbGetQuery(con, query)
  
  # Initialize a data frame to store counts for each square (a1-h8)
  squares <- paste0(rep(letters[1:8], each=8), 1:8)
  placement_counts <- data.frame(
    square = squares,
    count = rep(0, 64),
    stringsAsFactors = FALSE
  )
  
  # Process each game's moves
  for (an in games$an) {
    moves <- unlist(strsplit(an, " "))
    
    # Skip the result (last element: 1-0, 0-1, or 1/2-1/2)
    moves <- moves[-length(moves)]
    
    # Process moves, extracting destination squares
    for (i in seq(2, length(moves), by=3)) { # White moves
      move <- moves[i]
      # Extract destination square (e.g., e4, d5, Nf3 -> f3)
      square <- extract_destination_square(move)
      if (!is.na(square) && square %in% placement_counts$square) {
        placement_counts$count[placement_counts$square == square] <- 
          placement_counts$count[placement_counts$square == square] + 1
      }
    }
    for (i in seq(3, length(moves), by=3)) { # Black moves
      move <- moves[i]
      square <- extract_destination_square(move)
      if (!is.na(square) && square %in% placement_counts$square) {
        placement_counts$count[placement_counts$square == square] <- 
          placement_counts$count[placement_counts$square == square] + 1
      }
    }
  }
  
  # Add file and rank for plotting
  placement_counts$file <- substr(placement_counts$square, 1, 1)
  placement_counts$rank <- as.integer(substr(placement_counts$square, 2, 2))
  
  return(placement_counts)
}

# Helper function to extract destination square from a move
extract_destination_square <- function(move) {
  # Handle castling moves
  if (move %in% c("O-O", "O-O-O")) {
    return(NA) # Castling doesn't target a specific square for piece placement
  }
  
  # Regular expression to match destination square
  # Matches moves like e4, Nf3, Bxe5, exd5, e8=Q
  pattern <- "[a-h][1-8](?:=[QRBN])?$"
  match <- regmatches(move, regexpr(pattern, move))
  
  if (length(match) == 0) {
    return(NA)
  }
  
  # If promotion (e.g., e8=Q), keep only the square (e8)
  square <- sub("=[QRBN]", "", match)
  return(square)
}