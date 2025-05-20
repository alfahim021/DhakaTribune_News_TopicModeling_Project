library(rvest)
library(tidyverse)

scrape_category <- function(base_url, category_name, max_articles = 100) {
  articles <- tibble(title = character(),
                     description = character(),
                     date = character(),
                     category = character())
  
  page_num <- 1
  while(nrow(articles) < max_articles) {
    # Construct URL for page 'page_num' — adjust according to site URL pattern
    page_url <- paste0(base_url, "?page=", page_num)
    cat("Scraping:", category_name, "Page:", page_num, "\n")
    
    page <- tryCatch(read_html(page_url), error = function(e) NULL)
    if(is.null(page)) break
    
    # Adjust these CSS selectors based on actual website structure
    titles <- page %>% html_nodes(".news-title a") %>% html_text(trim = TRUE)
    descriptions <- page %>% html_nodes(".news-summary") %>% html_text(trim = TRUE)
    dates <- page %>% html_nodes(".news-date") %>% html_text(trim = TRUE)
    
    if(length(titles) == 0) break  # No more articles
    
    new_articles <- tibble(
      title = titles,
      description = descriptions,
      date = dates,
      category = category_name
    )
    
    articles <- bind_rows(articles, new_articles)
    
    if(nrow(articles) >= max_articles) break
    
    page_num <- page_num + 1
  }
  
  # Return only first max_articles articles
  articles[1:min(nrow(articles), max_articles), ]
}

categories <- list(
  Politics = "https://www.dhakatribune.com/category/politics",
  Business = "https://www.dhakatribune.com/category/business",
  Sports = "https://www.dhakatribune.com/category/sports",
  Tech = "https://www.dhakatribune.com/category/technology",
  Lifestyle = "https://www.dhakatribune.com/category/lifestyle"
)

all_news <- map2_df(names(categories), categories, ~ scrape_category(.y, .x, max_articles = 100))

dir.create("data/raw_news", recursive = TRUE, showWarnings = FALSE)
write_csv(all_news, "data/raw_news/dhakatribune_news_raw.csv")
