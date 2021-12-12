#' RStudio Exercise 5
#' Schahzad Saqib
#' 12th December 2021


library(tidyverse)

#' load the data frames

BPRS_raw <- utils::read.table("https://raw.githubusercontent.com/KimmoVehkalahti/MABS/master/Examples/data/BPRS.txt", sep  =" ", header = T)
RATS_raw <- utils::read.table("https://raw.githubusercontent.com/KimmoVehkalahti/MABS/master/Examples/data/rats.txt", sep  ="\t", header = T)

#' glimpse
dplyr::glimpse(BPRS_raw) # 40 rows, 11 columns
dplyr::glimpse(RATS_raw) # 16 rows, 12 columns

#' data transformation
#' BPRS
BPRS <- BPRS_raw %>%
  
  #' convert categorical variables to factors
  dplyr::mutate(treatment = factor(treatment), 
                subject = factor(subject)) %>%
  dplyr::glimpse() %>%
  
  #' pivot longer
  tidyr::pivot_longer(cols = c(-treatment, -subject), 
                      names_to = "Vars",
                      values_to = "BPRS") %>%
  
  #' extract new variable for week number 
  dplyr::mutate(Week = stringr::str_extract(Vars, "\\d")) %>%
  dplyr::glimpse() # 5 columns, 360 rows


#' RATS
RATS <- RATS_raw %>%
  
  #' convert categorical variables to factors
  dplyr::mutate(ID = factor(ID), 
                Group = factor(Group)) %>%
  dplyr::glimpse() %>%
  
  #' pivot longer
  tidyr::pivot_longer(cols = c(-ID, -Group), 
                      names_to = "WD",
                      values_to = "Weight") %>%
  
  #' extract new variable for week day (Time)
  dplyr::mutate(Time = stringr::str_extract(WD, "\\d.*")) %>%
  dplyr::glimpse() # 5 columns, 176 rows


#' The longer form of data allows for much more efficient cleaning, comparing, 
#' subsetting, and grouping variables in a particular dataset. This especially 
#' useful for data where there are repeated values (groups, IDs etc.). 
#' The transformed data frames in this exercise now contain unique values for
#' each entry (row wise)  opposed to the wider format where each row contained
#' all entries for each ID. 


#' write transformed data frames
write.csv(BPRS, 
          file = here::here("data", 
                            "BPRS.csv"), 
          row.names = TRUE)
write.csv(RATS, 
          file = here::here("data", 
                            "RATS.csv"), 
          row.names = TRUE)