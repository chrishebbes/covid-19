#Install packages
install.packages("devtools");
devtools::install_github("publichealthengland/coronavirus-dashboard-api-R-sdk");
library(ukcovid19);
library(ggplot2)
library(tidyverse);

query_filters <- c(
  'areaType=nation',
  'areaName=England'
)

cases_and_deaths = list(
  date = "date",
  areaName = "areaName",
  areaCode = "areaCode",
  newCasesByPublishDate = "newCasesByPublishDate",
  cumCasesByPublishDate = "cumCasesByPublishDate",
  newDeaths28DaysByPublishDate = "newDeaths28DaysByPublishDate",
  cumDeaths28DaysByPublishDate = "cumDeaths28DaysByPublishDate"
)

data <- get_data(
  filters = query_filters, 
  structure = cases_and_deaths
)

# Showing the head:
print(head(data))
data %>% filter(areaName=="England");

ggplot(data,aes(x=date,y=newCasesByPublishDate))+geom_point()

                    