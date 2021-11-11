#' RStudio Exercise 2
#' Schahzad Saqib
#' 11th November 2021


#### load libraries ####

library(tidyverse)
library(here)


#### read dat into the RStudio environment ####

#' read data
lrn14 <- read.table(
  "https://www.mv.helsinki.fi/home/kvehkala/JYTmooc/JYTOPKYS3-data.txt", 
  sep = "\t",
  header = T)

#' glimpse data
dplyr::glimpse(lrn14) #' 183 rows, 60 columns

#' define vars
vars <- c("Age", 
          "gender", 
          "Attitude", 
          "Points")


#### data transformation ####

#' reshape, summarise, and clean
lrn14_summ <- lrn14 %>%
  
  #' Filter out points that were 0
  dplyr::filter(Points > 0) %>%
  
  #' rescale the attitude variable
  dplyr::mutate(Attitude = Attitude/10) %>%
  
  #' reshape dataframe to longer format for easier transformations
  tidyr::pivot_longer(cols = -vars, 
                      names_to = "Q_id", 
                      values_to = "score") %>%
  
  #' define new column based on question groups
  dplyr::mutate(Q_comb = case_when(
    (stringr::str_starts(Q_id, "D\\d")) ~ "deep", #' deep questions
    (stringr::str_starts(Q_id, "SU")) ~ "surf",   #' surface questions
    (stringr::str_starts(Q_id, "ST")) ~ "stra",   #' strategic questions
    TRUE ~ "omit")) %>%
  
  #' remove other columns
  dplyr::filter(!Q_comb == "omit") %>%
  
  #' group by id vars and combined question variables (deep, surf, and stra)
  dplyr::group_by(!!!syms(vars), 
                  Q_comb) %>%
  
  #' summarise to mean scores
  dplyr::summarise(score = mean(score)) %>%
  
  #' reshape to longer format
  tidyr::pivot_wider(id_cols = vars, 
                     names_from = Q_comb, 
                     values_from = score)


#' glimpse transformed data
dplyr::glimpse(lrn14_summ) #' 166 rows, 7 columns


#### save to directory and verify ####

#' write csv
write.csv(lrn14_summ,
          here::here("data", 
                     "lrn14_summ.csv"), 
          row.names = F)

#' read data back into RStudio
lrn14_summ <- read.csv(here::here("data", 
                                  "lrn14_summ.csv"))

#' glimpse data
dplyr::glimpse(lrn14_summ) #' 166 rows, 7 columns
