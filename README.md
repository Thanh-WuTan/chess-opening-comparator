# Project Proposal: Chess Opening Head-to-Head Performance Visualizer

## 1. High-Level Goal

Develop an interactive web application using R (potentially with the Shiny framework) to visualize and compare the performance and popularity of specific chess openings when played against each other, segmented by player Elo rating brackets.

## 2. Goals and Motivation

Our core motivation stems from a shared interest in chess and the observation that analyzing opening performance, especially direct comparisons between openings at different skill levels, is often cumbersome using static tables or raw databases. Our goal is to create an interactive web application that allows users to:

* Select specific chess openings.
* Compare their win/draw/loss rates when played *against other selected openings*.
* Filter these comparisons based on player Elo rating ranges.
* Visualize the relative popularity (frequency of play) of these openings within the chosen Elo brackets.
* Present this information clearly using interactive charts (e.g., grouped bar charts, potentially heatmaps or scatter plots) generated with R.

This project aims to provide a more intuitive tool for chess players to make informed decisions about their opening repertoire, understanding how openings perform and how popular they are against specific counterparts at their own playing strength. For our team, this project offers a valuable opportunity to deepen our skills in data acquisition, data manipulation and statistical analysis using R (e.g., `dplyr`, `data.table`), interactive web application development with R/Shiny, and data visualization (e.g., `ggplot2`, `plotly`).

## 3. Project Focus and Data Handling

**Focus:** Build an R/Shiny web application to visualize processed chess game statistics, specifically focusing on the head-to-head performance and popularity of openings across different Elo levels.

**Data:**
* **Source:** Primarily large, publicly available chess game databases. Potential sources include the Lichess Open Database (`lichess.org/database`) or other PGN collections. Using pre-aggregated statistics from sites like `chesstempo.com` might be difficult for direct opening-vs-opening comparison, requiring processing of raw game data. We will need to verify Terms of Service for any source used.
* **Collection:** Download large PGN datasets. Potentially use web scraping (R packages like `rvest` or Python scripts) if suitable aggregated data is found, but PGN processing is more likely.
* **Processing:** Utilize R for the entire processing pipeline:
    * Parse PGN files (e.g., using R packages like `bigchess` or `rchess`) to extract game moves, results, and player Elos.
    * Identify the specific opening played in each game (e.g., based on the first N moves or matching ECO codes).
    * Filter games where one target opening is played against another target opening.
    * Categorize games into defined Elo brackets (e.g., <1200, 1200-1400, 1400-1600, ..., 2200+). Average Elo of the two players could be used.
    * Aggregate statistics: For each Elo bracket and each opening pair (Opening A vs. Opening B), calculate the win rates (White Win %, Draw %, Black Win %) and the total number of games (as a measure of matchup frequency/popularity). Also calculate the overall frequency of each individual opening within the Elo bracket.
* **Storage:** Store the final aggregated statistics in an efficient format readily usable by the R/Shiny application (e.g., RDS files, Feather files, or potentially a simple SQLite database).

## 4. Project Timeline and Milestones (Starting April 27th, 2025)

* **Team:** Vu Ai Thanh (Lead Dev - R/Shiny Focus), Tran Khanh Bang (Developer - Data Processing/R Focus), Ha Minh Dung (Developer - UI/Documentation Focus).

| Phase                                   | Deadline    | Focus                            | Key Tasks & Lead Responsibility (Thanh/Bang/Dung)                                                                                                                                                              |
| :-------------------------------------- | :---------- | :------------------------------- | :------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Phase 1: Data Preparation & Setup** | **May 4th** | **Data Acquisition & Processing** | Finalize scope (openings, Elo brackets); Set up GitHub (Dung); Identify/acquire PGN data source (Bang); Implement R scripts for PGN parsing, cleaning, filtering (Dung); Develop R logic for aggregation (Head-to-head stats, popularity) (Thanh); Define & create storage format for processed data (Bang). |
| **Phase 2: Prototype Development** | **May 15th**| **Core App Functionality** | Build initial Shiny UI structure (inputs, output areas) (Dung); Implement core Shiny server logic to load data and react to inputs (Thanh); Create basic interactive visualizations (ggplot2/plotly) (Bang); Connect UI inputs to server logic for dynamic updates (Bang); Integrate processed data for a working end-to-end prototype (All). |
| **Phase 3: App Completion & Refinement**| **Post-May 15th** | **Testing, Polishing, Finalization** | Conduct comprehensive testing (different browsers, edge cases) (All); Debug R code and Shiny app issues (Bang/Thanh); Enhance visualizations and improve UI/UX based on prototype feedback (Dung/Thanh); Write detailed README and any necessary documentation (Dung); Prepare final project submission/deployment (All). |

## 5. Set Up Instructions

### Step 1: Set Up the Database

Before running the app, you must set up the MySQL database using Docker.

➡️ Please follow the instructions in `data/README.md` to start the containerized database and populate the required tables.

+ Add your API Key to .env: 
```bash
...
API_KEY=yourapikey
```

### Step 2: Install Requirements

\textbf{Python Requirements}
- Ensure Python is installed on your system.
- Install the required Python packages by running
```bash
pip install -r requirements.txt
```

\textbf{R Requirements}
- Install the required R packages by running the following in your R console:
```r
source("install_packages.R")
```

### Step 3: Run the App

Launch the Shiny app by running the following in your R console:
```r
shiny::runApp("app.R")
```
