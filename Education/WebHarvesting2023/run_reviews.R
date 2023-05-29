library(dplyr)
library(purrr)
library(stringr)
library(clipr)
library(rvest)

ROOT_DIR <- "."
FILE_BEGIN <- "test"

# --- Function ---
collect_reviews <- function(pages) {
  pages %>% map(function(page) {
    user_names <- page %>% 
      html_elements('#tab-data-qa-reviews-0 > 
                div > 
                div.LbPSX > 
                div > 
                div > 
                div > 
                div > 
                div.mwPje.f.M.k > 
                div.XExLl.f.u.o > 
                div.zpDvc > 
                span > 
                a') %>%
      html_text()
    
    user_like <- page %>% 
      html_elements("#tab-data-qa-reviews-0 > 
                div > 
                div.LbPSX > 
                div > 
                div > 
                div > 
                div > 
                div.mwPje.f.M.k > 
                div:nth-child(2) > 
                button > 
                span > 
                span") %>% 
      html_text()
    
    review_text <- page %>% 
      html_elements("#tab-data-qa-reviews-0 > 
                div > 
                div.LbPSX > 
                div > 
                div > 
                div > 
                div > 
                div._T.FKffI > 
                div.fIrGe._T.bgMZj > 
                div") %>% 
      html_text()
    tibble(
      id="seoul_n_hotel",
      user_names,
      user_like,
      review_text
    )
  })
}

# RUN ------
setwd(ROOT_DIR)
list.files(pattern = FILE_BEGIN) %>% 
  map(function(file) {
    read_html(file)
  }) %>% 
  collect_reviews() %>% 
  bind_rows() %>% 
  write_clip()

cat("Data exported to clipboard.")

