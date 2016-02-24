library(dplyr)
library(readr)

if (!file.exists("data/methodists-uncleaned.csv"))
  download.file("https://docs.google.com/spreadsheets/d/1Ql2-sHAY3BuBmmW3LsX54e3oBUYmqMfLfLsAIsgZoGc/pub?gid=0&single=true&output=csv", "data/methodists-uncleaned.csv")

methodists <- read_csv("data/methodists-uncleaned.csv")

methodists %>%
  select(-minutes_location, -minutes_date, -notes) %>%
  filter(minutes_year < 1831,
         minutes_year != 1785) %>%
  mutate(members_white   = ifelse(minutes_year >= 1786 & is.na(members_white),
                                  0, members_white)) %>%
  mutate(members_colored = ifelse(minutes_year >= 1786 & is.na(members_colored),
                                  0, members_colored)) %>%
  mutate(members_indian  = ifelse(minutes_year >= 1824 & is.na(members_indian),
                                  0, members_indian)) %>%
  write_csv("data/methodists.csv")

