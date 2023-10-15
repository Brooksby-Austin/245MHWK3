rm(list=ls()) # clear the environment
setwd(dirname(rstudioapi::getSourceEditorContext()$path))
#-------Import necessary packages here-------------------#
# Note: Using other packages than the ones listed below can break the autograder
library(tidyverse)
library(lubridate)
library(dplyr)
library(janitor)
#------ Uploading PERMID --------------------------------#
PERMID <- "7216567" #Type your PERMID within the quotation marks
PERMID <- as.numeric(gsub("\\D", "", PERMID)) #Don't touch
set.seed(PERMID) #Don't touch
#------ Answer ------------------------------------------#

#1
uof <- read.csv("uof_louisville.csv")

#2
#a
uof <- uof |> mutate(hour = hour(hms(time_of_occurrence)))
frequent_hour <- uof |> count(hour) |> arrange(desc(n)) |> slice(1)
frequent_hour <- frequent_hour$hour

#b
uof <- uof |> mutate(month = month(date_of_occurrence))
least_frequent_month <- uof |> count(month) |> arrange(n) |> slice(1)
least_frequent_month <- least_frequent_month$month
