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

#c
uof <- uof |> mutate(day = wday(date_of_occurrence))
most_frequent_day <- uof |> count(day) |> arrange(desc(n)) |> slice(1)
most_frequent_day <- most_frequent_day$day

#d
day_distribution <- uof |> mutate(mday = day(date_of_occurrence)) |> count(mday) |>
  mutate(fraction = n/sum(n)) |> adorn_totals()

#3
#a
force_used_1 <- uof |> distinct(force_used_1) |> t() |> c()

#b
force_used_2 <- uof |> distinct(force_used_2) |> t() |> c()

#c
all_force <- uof |> distinct(force_used_1, force_used_2, force_used_3, force_used_4,
                            force_used_5, force_used_6, force_used_7, force_used_8) |>
  t() |> c() |> unique()

#d
violent_force <- c("take down", "hobble", "ecw cartridge deployed", "knee strike(s)",
                   "12 ga. sock round", "take-down", "impact weapon",
                   "kick", "deadly force used")
#e
uof <- uof |> mutate(violent_uof_1 = as.numeric((force_used_1 %in% violent_force))) 

#f
violent_force_service_table <- uof |> filter(violent_uof_1 == 1) |> count(service_rendered) |>
  mutate(fraction = n/sum(n)) |> adorn_totals()

#4
#a
uof_filtered <- uof |> drop_na(citizen_race, citizen_gender) |> 
  mutate(force_used_1_effective_binary = as.integer(force_used_1_effective == "yes"), rm.na = TRUE)

#b
uof_filtered_table <- uof_filtered |> group_by(citizen_gender, citizen_race) |> 
  summarize(effective_1 = sum(force_used_1_effective_binary, na.rm = TRUE), counts = length(force_used_1_effective_binary)) |> 
  adorn_totals() |> mutate(fraction_effective = effective_1/counts)
