# Project Proposal: Chess Opening Performance Visualizer

## 1. High-Level Goal

Develop an interactive web application to visualize and compare chess opening win rates based on player Elo ratings.

## 2. Goals and Motivation

Motivated by our interest in chess and the difficulty of analyzing opening statistics from tables, our goal is to create an interactive web application visualizing win rates by Elo (Bar charts, histograms, etc). This project addresses the lack of accessible tools for easy, visual comparison of opening performance, especially filtered by skill level.

This tool aims to help players make informed opening choices by presenting complex data intuitively. It provides a clear view of opening effectiveness across different Elo ranges, moving beyond static tables. For our team, it's an opportunity to develop practical skills in data crawling, processing, web development, and visualization, while creating a potentially useful resource for the chess community and future analysis.

## 3. Project Focus and Data Handling

**Focus:** Build a frontend-centric web app visualizing pre-processed chess statistics.

**Data:**
* **Source:** Primarily `chesstempo.com/game-database/` (subject to Terms of Service check; alternatives like Lichess Open DB if needed).
* **Collection:** Web crawling using Python (`requests`/`BeautifulSoup`/`Scrapy`).
* **Processing:** Extract opening, Elos, results from games; aggregate win/draw/loss rates per opening pair and Elo bracket.
* **Storage:** Store aggregated statistics efficiently for frontend use (e.g., JSON files or SQLite).

## 4. Weekly Plan (4 Weeks, 3 Members)

* **Team:** Vu Ai Thanh (Lead Dev), Tran Khanh Bang (Developer), Ha Minh Dung (Developer).

| Week  | Focus                                   | Key Tasks & Lead Responsibility (Thanh/Bang/Dung)                                                                          |
| :---- | :-------------------------------------- | :------------------------------------------------------------------------------------------------------------------------- |
| **1** | **Planning & Data Setup** | Finalize scope; Setup GitHub (Dung); Investigate source/T&Cs; Start crawler dev (Bang); Plan data structure (Thanh).        |
| **2** | **Data Collection & Processing** | Run/monitor crawler (Bang); Clean data; Develop aggregation logic (Thanh); Store aggregated data; Document format (Dung). |
| **3** | **Frontend Development & Integration** | Build UI (HTML/CSS - Dung/Bang); Implement charting (Thanh); Connect frontend to data (Bang); Add interactivity.             |
| **4** | **Testing, Refinement & Finalization** | Full testing (All); Bug fixing (Bang/Thanh); UI/UX polish; Finalize README (Dung); Prepare submission (All).                |


