# Project Proposal: Chess Opening Head-to-Head Performance Visualizer


## Project Proposal

The Chess Opening Comparator is a Shiny web application designed to assist chess players and enthusiasts in analyzing and comparing chess openings. The app allows users to select two openings from a database of chess games and provides a detailed comparison through various statistical visualizations. The primary goals are:

- To provide insights into the performance of chess openings, including win/loss rates, game length distributions, ELO distributions, time control preferences, castling tendencies, and piece placement patterns.
- To help users understand strategic differences between openings, enabling better preparation and decision-making for chess games.
- To offer an interactive and user-friendly interface for exploring chess data.

The application leverages a database of chess games, processes the data using python script, and visualizes the results using Shiny and ggplot2. It is intended for chess players of all levels who want to deepen their understanding of opening strategies.

## Features

- Opening Selection: Users can select two chess openings to compare from a dropdown menu populated with available openings in the database.
- Opening Moves Display: Displays the typical moves for each selected opening, fetched using a Python script (Gemini.py).
- Statistical Visualizations: Includes multiple plots to compare the openings across different metrics (see below).
- Interactive Interface: Built with Shiny for a responsive and user-friendly experience.

## Plots
The application includes the following visualizations to compare the two selected openings:

1. **Win/Loss Rate Comparison**  

- Type: Stacked bar chart  
- Description: Shows the percentage of wins, draws, and losses for each opening. This helps users evaluate the overall effectiveness of each opening in achieving favorable outcomes.


2. **Game Length Distribution**  

- Type: Violin plot  
- Description: Compares the distribution of game lengths (measured in moves) for the two openings. This plot reveals whether an opening tends to lead to shorter or longer games.


3. **ELO Distribution Comparison**  

- Type: Histogram  
- Description: Displays the distribution of ELO ratings for players using each opening. This highlights the typical skill levels of players who prefer each opening.


4. **Time Control Distribution Comparison**  

- Type: Bar chart  
- Description: Shows the distribution of time controls (e.g., blitz, rapid, classical) used in games for each opening. This indicates the contexts in which each opening is commonly played.


5. **Castling Comparison**  

- Type: Donut charts (2x2 grid)  
- Description: Displays castling statistics for each opening, with separate charts for White Castling and Black Castling. Each chart shows the proportion of games with Kingside, Queenside, and No Castling, labeled with counts and percentages. The layout places the charts in a 2x2 grid, with the top row for the first opening and the bottom row for the second.


6. **Piece Placement Heatmaps Comparison**  

- Type: Heatmap  
- Description: Compares the average piece placement or activity across the chessboard for each opening. This visualization highlights the typical positions of pieces (e.g., pawns, knights, bishops) in the early game, providing insights into spatial control and strategic focus for each opening.



## Project Structure

- app.R: The main Shiny application script that defines the UI and server logic.
- db_utils/: Directory containing R scripts for database connections and data retrieval.
- plot_utils/: Directory containing R scripts for generating plots.
- Gemini.py: Python script used to fetch opening moves.
- install_packages.R: Script to install required R packages.



## Set Up Instructions

### Step 1: Set Up the Database

Before running the app, you must set up the MySQL database using Docker.

➡️ Please follow the instructions in `data/README.md` to start the containerized database and populate the required tables.

+ Add your API Key to .env: 
```bash
...
API_KEY=yourapikey
```

### Step 2: Install Requirements

**Python Requirements**
- Ensure Python is installed on your system.
- Install the required Python packages by running
```bash
pip install -r requirements.txt
```

**R Requirements**
- Install the required R packages by running the following in your R console:
```r
source("install_packages.R")
```

### Step 3: Run the App

Launch the Shiny app by running the following in your R console:
```r
shiny::runApp("app.R")
```

