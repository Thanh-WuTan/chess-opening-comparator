# Chess Games Dataset Processing

This guide explains how to prepare and process a large chess games dataset using MySQL and Python inside a Dockerized environment.


## 📦 Dataset

1. **Download** the chess games dataset:
   - Link: [https://www.kaggle.com/datasets/arevel/chess-games?resource=download](https://www.kaggle.com/datasets/arevel/chess-games?resource=download)

2. **Save** the downloaded file as: `data/chess_games.csv`

## ⚙️ Environment Configuration

Create a `.env` file **in the root directory** (not inside `data/`):
```bash
MYSQL_HOST=localhost
MYSQL_PORT=3307
MYSQL_ROOT_PASSWORD=abc123
MYSQL_DATABASE=chess_openings
```


## 📁 Directory Structure

Your project directory should look like this:
```
.
├── .gitignore
├── .env
├── Readme.md
└── data
    ├── Dockerfile
    ├── README.md
    ├── chess_games.csv
    ├── read_chess_games.py
    ├── requirements.txt
    └── schema.sql
```

---

## 🐳 Build and Run Docker Container

### Step 1: Build Docker Image
From the `data/` directory:

```bash
cd ./data
docker build -t chess-mysql .
```

### Step 2: Run the Container
```bash
docker run -d \
  --name chess-mysql-container \
  --env-file ../.env \
  -p 3307:3306 \
  -v mysql_data:/var/lib/mysql \
  chess-mysql
```
## Importing the Data
After starting the MySQL container and ensuring the schema is created (e.g., via schema.sql), run: (in data/ directory)
```bash
python3 read_chess_games.py
```
This will:

- Parse the chess_games.csv

- Insert rows into games and openings tables using multiprocessing

## Notes
You must install required Python packages before running the script:
```bash
pip install -r requirements.txt
```

## Resetting the Database
To delete all entries from games and reset AUTO_INCREMENT:  
```sql
DELETE FROM games;
ALTER TABLE games AUTO_INCREMENT = 1;
```
