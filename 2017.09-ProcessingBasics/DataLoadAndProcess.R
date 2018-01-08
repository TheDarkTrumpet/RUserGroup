install.packages("plyr")
install.packages("ggplot2")
install.packages("gridExtra")
install.packages("dtplyr")
install.packages("dplyr")

library("plyr")
library("ggplot2")
library("gridExtra")
library("dtplyr")
library("dplyr")

csvData <- read.table("https://raw.githubusercontent.com/TheDarkTrumpet/RUserGroup/master/2017.09-ProcessingBasics/Data/CCWS-IQ_sensor_data_6-26-17_10-16-17-all.csv", header=TRUE, sep=",")

summary(csvData)

# Average Moisture - per day

# Average Humidity - per day

# Average Atmospheric Pressure - per day

# Rainy Day - average moisture per hour

# Detect days right before it rains (atmospheric pressure drop)