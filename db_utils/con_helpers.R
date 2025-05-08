# Loading required libraries
library(DBI)
library(RMySQL)
library(dotenv)

# Loading environment variables
load_dot_env(file = ".env")

# Function to establish database connection
get_db_connection <- function() {
  con <- dbConnect(
    MySQL(),
    host = Sys.getenv("MYSQL_HOST"),
    port = as.integer(Sys.getenv("MYSQL_PORT")),
    user = "root",
    password = Sys.getenv("MYSQL_ROOT_PASSWORD"),
    dbname = Sys.getenv("MYSQL_DATABASE")
  )
  return(con)
}