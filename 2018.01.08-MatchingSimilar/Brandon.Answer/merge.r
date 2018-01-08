# load packages
library(tidyverse)
library(lubridate)

# read in new data
iowa_city <- read_csv("2018.01.08-MatchingSimilar/Data/IowaCity-TempPrecpt.csv")
north_english <- read_csv("2018.01.08-MatchingSimilar/Data/NorthEnglish-Precpt.csv")

# changing column names to lower case
iowa_city <- rename_all(iowa_city, tolower)
north_english <- rename_all(north_english, tolower)

# Append _ic/_ne to names of variables to prep for merge later.
names(iowa_city) <- paste(names(iowa_city), "ic", sep = "_")
names(north_english) <- paste(names(north_english), "ne", sep = "_")

# read in old data source
sensor <- read_csv("2017.09-ProcessingBasics/Data/CCWS-IQ_sensor_data_6-26-17_10-16-17-all.csv",
                   col_names = c('timestamp', 'node', 'atmos_temperature', 'atmos_pressure',
                                 'atmos_humidity', 'soil_temperature', 'raw_soil_moisture_20cm',
                                 'raw_soil_moisture_5cm', 'voltage', 'soil_moisture_percent_20cm',
                                 'soil_moisture_percent_5cm', 'signal'),
                   skip = 1)

# renames columns
sensor <- sensor %>%
  mutate(time = parse_datetime(timestamp, format = "%m/%d/%Y %H:%M:%S"),
         date = gsub("\\s+\\d+:\\d+:\\d+", "", time),
         month = month(time),
         day = day(time),
         week = week(time),
         hour = hour(time),
         minute = minute(time),
         date = parse_date(date))

# merge data
sensor_merge <- sensor %>%
  left_join(iowa_city, by = c('date' = 'date_ic')) %>%
  left_join(north_english, by = c('date' = 'date_ne'))
