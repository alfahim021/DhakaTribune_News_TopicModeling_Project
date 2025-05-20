# Dhaka Tribune News Topic Modeling Project

## Project Overview
This project scrapes news articles from the **Dhaka Tribune** news portal, collecting news from at least 5 categories with 100 articles per category. The collected raw news data undergoes text processing to clean and prepare it for analysis. Using topic modeling (LDA), the project identifies the main topics discussed across the news articles.

## Project Structure

- `data/raw_news/`  
  Contains raw scraped news data CSV (`dhakatribune_news_raw.csv`).

- `data/clean_news/`  
  Contains cleaned news data CSV after text processing (`dhakatribune_news_clean.csv`).

- `scripts/`  
  R scripts for each project stage:  
  - `scrape_dhakatribune_news.r` — Scrapes news and saves raw data.  
  - `text_processing_dhakatribune.r` — Cleans and preprocesses text data.  
  - `topic_modeling_dhakatribune.r` — Creates Document-Term Matrix, applies LDA, and analyzes topics.

- `report/dhakatribune_news_topic_modeling_report.pdf`  
  Detailed project report including explanation of methodology, code snippets, outputs, and topic interpretation.

## How to Run

1. Run the scraping script to extract raw news data:

   ```r
   source("scripts/scrape_dhakatribune_news.r")
   ```

2. Run the text processing script to clean the raw news text:

   ```r
   source("scripts/text_processing_dhakatribune.r")
   ```

3. Run the topic modeling script to perform topic extraction and analysis:

   ```r
   source("scripts/topic_modeling_dhakatribune.r")
   ```

## Notes

- All scripts are without comments as per project requirements.
- Make sure required R packages are installed (`rvest`, `tm`, `topicmodels`, `tidytext`, etc.).
- The report contains detailed descriptions of the process and findings.

---

## Contact

For questions or help, email: alfahim021@gmail.com
