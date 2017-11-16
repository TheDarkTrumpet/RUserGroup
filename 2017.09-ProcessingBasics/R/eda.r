library(tidyverse)
library(lubridate)

sensor <- read_csv("2017.09-ProcessingBasics/Data/CCWS-IQ_sensor_data_6-26-17_10-16-17-all.csv",
                   col_names = c('timestamp', 'node', 'atmos_temperature', 'atmos_pressure', 
                                 'atmos_humidity', 'soil_temperature', 'raw_soil_moisture_20cm',
                                 'raw_soil_moisture_5cm', 'voltage', 'soil_moisture_percent_20cm',
                                 'soil_moisture_percent_5cm', 'signal'),
                   skip = 1)

# renames columns
sensor <- sensor %>%
  mutate(time = parse_datetime(timestamp, format = "%m/%d/%Y %H:%M:%S"),
         month = month(time),
         day = day(time),
         week = week(time),
         hour = hour(time),
         minute = minute(time))

#-------------------------
# descriptive stats

# Monthly ----
month_descriptive <- sensor %>%
  filter(node %in% c(1:8)) %>%
  group_by(month, node) %>%
  summarise_at(vars(atmos_temperature:soil_moisture_percent_5cm),
               c('mean', 'sd'), na.rm = TRUE)

# Weekly ----
weekly_descriptive <- sensor %>%
  filter(node %in% c(1:8)) %>%
  group_by(week, node) %>%
  summarise_at(vars(atmos_temperature:soil_moisture_percent_5cm),
               c('mean', 'sd'), na.rm = TRUE)

# day ----
day_descriptive <- sensor %>%
  filter(node %in% c(1:8)) %>%
  group_by(day, node) %>%
  summarise_at(vars(atmos_temperature:soil_moisture_percent_5cm),
               c('mean', 'sd'), na.rm = TRUE)

# hour ----
hour_deriptive <- sensor %>%
  filter(node %in% c(1:8)) %>%
  group_by(hour, node) %>%
  summarise_at(vars(atmos_temperature:soil_moisture_percent_5cm),
               c('mean', 'sd'), na.rm = TRUE)

# minute ----
minute_descriptive <- sensor %>%
  filter(node %in% c(1:8)) %>%
  group_by(minute, node) %>%
  summarise_at(vars(atmos_temperature:soil_moisture_percent_5cm),
               c('mean', 'sd'), na.rm = TRUE)

# overall descriptive
month_day_descriptive <- sensor %>%
  filter(node %in% c(1:8)) %>%
  group_by(month, day, node) %>%
  summarise_at(vars(atmos_temperature:soil_moisture_percent_5cm),
               c('mean', 'sd'), na.rm = TRUE)

# Create ggplot2 function to view results
plot_trend <- function(data, x, y, group_var = NULL, facet_var = NULL) {
  
  p <- ggplot(data, aes_string(x = x, y = y, group = group_var)) + 
    theme_bw(base_size = 14) + 
    geom_point(size = 2, aes_string(color = group_var)) + 
    geom_line(aes_string(linetype = group_var, color = group_var))
  if(is.null(facet_var)) {
    p
  } else {
    if(length(facet_var) == 1) {
      p + facet_wrap(facet_var)
    } else {
      p + facet_grid(facet_var[1] ~ facet_var[2])
    }
  }
  
}

plot_trend(minute_descriptive, x = 'minute', y = 'atmos_humidity_mean')
plot_trend(minute_descriptive, x = 'minute', y = 'atmos_humidity_mean', 
           group_var = 'as.character(node)')

# day ignoring month
plot_trend(day_descriptive, x = 'day', y = 'atmos_humidity_mean',
           group_var = 'as.character(node)')

# Month and day
plot_trend(month_day_descriptive, x = 'day', y = 'atmos_humidity_mean',
           group_var = 'as.character(node)', facet_var = 'month')
plot_trend(month_day_descriptive, x = 'day', y = 'atmos_pressure_mean',
           group_var = 'as.character(node)', facet_var = 'month')
plot_trend(month_day_descriptive, x = 'day', y = 'raw_soil_moisture_5cm_mean',
           group_var = 'as.character(node)', facet_var = 'month')
plot_trend(month_day_descriptive, x = 'day', y = 'raw_soil_moisture_20cm_mean',
           group_var = 'as.character(node)', facet_var = 'month')
