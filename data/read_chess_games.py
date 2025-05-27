import csv
import mysql.connector
import os
import re
from dotenv import load_dotenv
from tqdm import tqdm

# Load .env file
load_dotenv()

# Environment variables
DB_CONFIG = {
    'host': os.getenv("MYSQL_HOST"),
    'port': int(os.getenv("MYSQL_PORT")),
    'user': 'root',
    'password': os.getenv("MYSQL_ROOT_PASSWORD"),
    'database': os.getenv("MYSQL_DATABASE")
}

def count_moves(an):
    """
    Count the number of moves in algebraic notation by finding the highest move number.
    Handles cases like: 1. e4 e5 2. Nf3 Nc6 ... or 1. e4 { [%eval 0.25] } 1... c6 { ... }
    """
    matches = re.findall(r'\b(\d+)\.', an)
    if not matches:
        return 0
    return int(matches[-1])

def result_converter(result):
    return {
        '1-0': 'w',
        '0-1': 'b',
        '1/2-1/2': 'd'
    }.get(result.strip(), 'd')

def get_or_create_opening(cursor, name, eco):
    name, eco = name.strip(), eco.strip()
    cursor.execute("SELECT opening_id FROM openings WHERE name = %s", (name,))
    result = cursor.fetchone()
    if result:
        return result[0]
    cursor.execute("INSERT INTO openings (name, eco) VALUES (%s, %s)", (name, eco))
    return cursor.lastrowid

def insert_game(cursor, row):
    event = row[0].strip()
    white_elo = int(row[6])
    black_elo = int(row[7])
    result = result_converter(row[3])
    eco = row[10].strip()
    opening_name = row[11].strip()
    an = row[14]
    time_control = row[12].strip()  # Assuming TimeControl is in column 9
    nb_moves = count_moves(an)
    avg_elo = (white_elo + black_elo) / 2

    # Check for missing or empty TimeControl
    if not time_control or time_control == '-':
        return False  # Skip this game
    
    if '+' in time_control:
        time_control = time_control.split('+')[0]
    
    opening_id = get_or_create_opening(cursor, opening_name, eco)
    cursor.execute("""
        INSERT INTO games (
            event, result, white_elo, black_elo, open_name, opening_id, nb_of_moves, avg_elo, TimeControl
        ) VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s)
    """, (event, result, white_elo, black_elo, opening_name, opening_id, nb_moves, avg_elo, time_control))
    return True

def main():
    conn = mysql.connector.connect(**DB_CONFIG)
    cursor = conn.cursor()

    with open('data/chess_games.csv', newline='', encoding='utf-8') as csvfile:
        cnt = 0
        reader = csv.reader(csvfile)
        next(reader)  # Skip header row
        for row in tqdm(reader, desc="Processing games"):
            try:
                if insert_game(cursor, row):
                    conn.commit()
                else:
                    pass
            except Exception as e:
                print(f"Error inserting row {cnt}:", row)
                print(e)
            cnt += 1

    cursor.close()
    conn.close()

if __name__ == "__main__":
    main()