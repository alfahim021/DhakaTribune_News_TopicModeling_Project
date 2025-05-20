library(tidyverse)
library(tm)
library(topicmodels)

input_path <- "data/clean_news/dhakatribune_news_clean.csv"

df <- read_csv(input_path)

corpus <- VCorpus(VectorSource(df$clean_content))

dtm <- DocumentTermMatrix(corpus,
                         control = list(
                           wordLengths = c(3, Inf),
                           removeNumbers = TRUE,
                           stopwords = TRUE,
                           removePunctuation = TRUE,
                           stemming = FALSE
                         ))

dtm <- removeSparseTerms(dtm, 0.99)

k <- 5  # Number of topics

lda_model <- LDA(dtm, k = k, control = list(seed = 1234))

top_terms <- terms(lda_model, 10)
print(top_terms)

topic_prob <- posterior(lda_model)$topics
df$dominant_topic <- apply(topic_prob, 1, which.max)

write_csv(df, "data/clean_news/ids_final_project_group_03_news_with_topics.csv")
