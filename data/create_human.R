#' RStudio Exercise 5
#' Schahzad Saqib
#' 27th November 2021


library(tidyverse)

#' Read in the datasets
hd <- read.csv("http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/human_development.csv", stringsAsFactors = F)
gii <- read.csv("http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/gender_inequality.csv", stringsAsFactors = F, na.strings = "..")


#' glimpse
dplyr::glimpse(hd)
dplyr::glimpse(gii)


#' clean dn reformat the datasets

hd <- hd %>%
  
  #' renames the variables
  purrr::set_names(c("HDI.Rank",
                     "Country",
                     "HDI",
                     "Life.ExpAB",
                     "Edu.Y",
                     "Edu.Mean",
                     "GNI.pc",
                     "GNI-HDIrank"))

gii <- gii %>%
  
  #' renames the variables
  purrr::set_names(c("GII.Rank", 
                     "Country", 
                     "GII",
                     "MMR",
                     "Adl_brthR",
                     "Prl_prc",
                     "Edu.sec.F",
                     "Edu.sec.M",
                     "Lbr.F",
                     "Lbr.M")) %>%
  
  #' create new variables measuring proportions
  dplyr::mutate(Edu.sec.prop = Edu.sec.F / Edu.sec.M, 
                Lbr_prop = Lbr.F / Lbr.M)


#' join the datasets
human <- hd %>%
  dplyr::inner_join(gii, by = c("Country"), 
                    suffix = c(".hd", 
                               ".gii"))

#' glimpse
dplyr::glimpse(human) #' correct dimensions, 19 columns and 195 rows

write.csv(human, 
          file = here::here("data", "human.csv"), 
          row.names= FALSE)



##### chapter 5 continuation ##-----

human_mod <- human %>%
  
  #' convert GNI to numeric
  dplyr::mutate(GNI.pc = as.numeric(
    stringr::str_replace(GNI.pc, ",", ""))) %>%
  
  #' subset most important columns
  dplyr::select(Country, 
                Edu.sec.prop, 
                Lbr_prop, 
                Edu.Y, 
                Life.ExpAB, 
                GNI.pc, 
                MMR, 
                Adl_brthR,
                Prl_prc) %>%
  
  #' omit NAs
  tidyr::drop_na() %>%
  
  #' remove entreis that are a region, not a country
  dplyr::slice(1:(n() - 7)) %>%
  
  #' convert the country column to rownames
  tibble::column_to_rownames(var = "Country")
  

#' write modified data frame, with rownames 
write.csv(human_mod, 
          here::here("data", 
                     "human.csv"), 
          row.names = T)

#' validation
dplyr::glimpse(
  human_mod <- read.csv(here::here("data", 
                                   "human.csv"), 
                        row.names = 1))
#' 155 rows and 8 columns

