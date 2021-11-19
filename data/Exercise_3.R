#' RStudio Exercise 3
#' Schahzad Saqib
#' 16th November 2021

library(tidyverse)


#' Read in data files
stu_mat <- read.csv(here::here("data", 
                               "student", 
                               "student-mat.csv"), 
                    sep = ";", 
                    header = T)
stu_por <- read.csv(here::here("data", 
                               "student", 
                               "student-por.csv"), 
                    sep = ";", 
                    header = T)


#' explore datasets
dplyr::glimpse(stu_mat)
dplyr::glimpse(stu_por)

#' define variables for joining
vars <- colnames(stu_mat) %>%
  .[!. %in% c("failures", "paid", "absences", "G1", "G2", "G3")]

#' Joining datasets
stu_aggr <- stu_mat %>%
  
  #' alternative to provided solution to the joining problem. By using all 27
  #' common variables between the two dataframes as the joining variables, it 
  #' is possible to immediately get 370 students in the output. 
  dplyr::inner_join(stu_por, 
                   by = vars,
                   suffix = c(".mat", ".por")) %>%
  
  #' apply rowise function to summarise non-joined variables. 
  dplyr::rowwise() %>%
  dplyr::mutate(G1 = round(mean(c_across(starts_with("G1")))), 
                G2 = round(mean(c_across(starts_with("G2")))), 
                G3 = round(mean(c_across(starts_with("G3")))), 
                absences = round(mean(c_across(starts_with("absences")))), 
                failures = round(mean(c_across(starts_with("failures")))), 
                paid = as.character(list(first(c_across(starts_with("paid")))))) %>%
  dplyr::ungroup() %>%
  
  #' create new varaibles for alcohol use
  dplyr::mutate(alc_use = (Dalc + Walc)/2, 
                high_use = alc_use > 2) 


#' take a look at the joined data
dplyr::glimpse(stu_aggr) #' 370 students, 47 variables. 

#' save file
write.csv(stu_aggr,
          file = here::here("data", 
                            "stu_aggr.csv"), 
          row.names = F)

#' confirm save and data structure
dplyr::glimpse(read.csv(here::here("data", 
                                   "stu_aggr.csv")))                   
#' 370 student, 47 variables