# Function to fetch opening names
get_opening_names <- function(con) {
  query <- "SELECT name FROM openings ORDER BY name"
  result <- dbGetQuery(con, query)
  return(c("Select an opening", result$name))
}
