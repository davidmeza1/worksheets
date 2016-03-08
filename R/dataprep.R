library(dplyr)
library(tidyr)
library(readr)

if (!file.exists("data/methodists-uncleaned.csv"))
  download.file("https://docs.google.com/spreadsheets/d/1Ql2-sHAY3BuBmmW3LsX54e3oBUYmqMfLfLsAIsgZoGc/pub?gid=0&single=true&output=csv", "data/methodists-uncleaned.csv")

methodists_raw <- read_csv("data/methodists-uncleaned.csv")

methodists_cleaned <- methodists_raw %>%
  select(-minutes_location, -minutes_date, -notes) %>%
  filter(minutes_year <= 1830,
         minutes_year != 1785,
         minutes_year != 1778) %>%
  mutate(members_white   = ifelse(minutes_year >= 1786 & is.na(members_white),
                                  0, members_white)) %>%
  mutate(members_colored = ifelse(minutes_year >= 1786 & is.na(members_colored),
                                  0, members_colored)) %>%
  mutate(members_indian  = ifelse(minutes_year >= 1824 & is.na(members_indian),
                                  0, members_indian)) %>%
  mutate(members_white   = ifelse(members_white == 0 & members_colored == 0,
                                  NA, members_white)) %>%
  mutate(members_colored = ifelse(members_white == 0 & members_colored == 0,
                                  NA, members_colored))

write_csv(methodists_cleaned, "data/methodists.csv")

va_methodists_wide <- methodists_cleaned %>%
  filter(minutes_year >= 1812,
         minutes_year <= 1830,
         conference == "Virginia") %>%
  mutate(members_general = members_white + members_colored) %>%
  group_by(minutes_year, conference, district) %>%
  summarize(membership = sum(members_general)) %>%
  spread(minutes_year, membership)

write_csv(va_methodists_wide, "data/va-methodists-wide.csv")
