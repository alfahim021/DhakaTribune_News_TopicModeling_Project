library(tidyverse)
library(textclean)
library(tokenizers)
library(tm)
library(textstem)
library(hunspell)
library(SnowballC)

preprocess_text <- function(text) {
  if(is.na(text) || text == "") return("")
  
  text <- replace_contraction(text)
  text <- replace_emoji(text)
  text <- tolower(text)
  text <- gsub("<.*?>", " ", text)
  text <- gsub("http\\S+|www\\.\\S+", " ", text)
  text <- gsub("[^a-z\\s]", " ", text)
  text <- gsub("\\s+", " ", text)
  text <- trimws(text)
  
  tokens <- tokenize_words(text)[[1]]
  tokens <- tokens[!tokens %in% stopwords("en")]
  if(length(tokens) == 0) return("")
  
  spell_check <- hunspell_check(tokens)
  for(i in seq_along(tokens)) {
    if(!spell_check[i]) {
      suggestions <- tryCatch(
        hunspell_suggest(tokens[i])[[1]],
        error = function(e) character(0)
      )
      if(length(suggestions) > 0) tokens[i] <- suggestions[1]
    }
  }
  
  tokens <- wordStem(tokens, language = "en")
  tokens <- lemmatize_words(tokens)
  
  paste(tokens, collapse = " ")
}

input_path <- "data/raw_news/ids_final_project_group_03_news_raw.csv"
output_path <- "data/clean_news/ids_final_project_group_03_news_clean.csv"

df <- read_csv(input_path)

df <- df %>% mutate(clean_content = map_chr(description, preprocess_text))

df <- df %>% select(-description)

df <- df %>% relocate(clean_content, .after = last_col())

dir.create("data/clean_news", recursive = TRUE, showWarnings = FALSE)

write_csv(df, output_path)
