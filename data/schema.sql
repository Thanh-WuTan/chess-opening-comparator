CREATE DATABASE IF NOT EXISTS chess_openings;
USE chess_openings;

-- Create openings table
CREATE TABLE openings (
    opening_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    eco VARCHAR(10),
    UNIQUE (name),
    INDEX idx_opening_id (opening_id)
) ENGINE=InnoDB;

-- Create games table
CREATE TABLE games (
    game_id INT AUTO_INCREMENT PRIMARY KEY,
    event TEXT,
    result ENUM('w', 'b', 'd') NOT NULL,
    white_elo INT,
    black_elo INT,
    open_name VARCHAR(255) NOT NULL,
    opening_id INT,
    nb_of_moves INT,
    avg_elo FLOAT,
    FOREIGN KEY (opening_id) REFERENCES openings(opening_id) ON DELETE CASCADE,
    INDEX idx_opening_id (opening_id)
) ENGINE=InnoDB;
