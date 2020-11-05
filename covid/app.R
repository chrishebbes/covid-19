#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#
library(devtools);
library(rsconnect);
#devtools::install_github("publichealthengland/coronavirus-dashboard-api-R-sdk");
library(shiny)
library(shinydashboard)
library(ukcovid19);
library(ggplot2)
library(tidyverse);
library(lubridate);

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

frow1<-fluidRow(valueBoxOutput("value1"),valueBoxOutput("value2"),valueBoxOutput("value3"));
frow2<-fluidRow(box(plotOutput("plot1", height = 250)));
frow3<-fluidRow(box(title = "Date",sliderInput("slider", "Date", 1, 100, 50)));
body<-dashboardBody(frow1,frow2,frow3);

ui <- dashboardPage(
    dashboardHeader(title="COVID-19 Dashboard"),
    dashboardSidebar(),
    body
        )

server <- function(input, output) {
    data<-data %>% mutate(ymddate=parse_date(date,"%Y-%m-%d"));
output$plot1<-renderPlot({ggplot(data,aes(x=ymddate,y=newCasesByPublishDate))+geom_point()+xlab("Date")+ylab("Cases");})
dailyval<-reactive({data$newDeaths28DaysByPublishDate[input$slider]});
newcase<-reactive({data$newCasesByPublishDate[input$slider]});
datesel<-reactive({data$date[input$slider]});

output$value1<-renderValueBox({
    valueBox(
        dailyval(), "Daily Deaths", icon = icon("skull-crossbones"),
        color = "red"
        )
    })
output$value2<-renderValueBox({
    valueBox(
        newcase(), "New Cases", icon = icon("stethoscope"),
        color = "blue"
    )
})
output$value3<-renderValueBox({
    valueBox(
        datesel(), "New Cases", icon = icon("calendar"),
        color = "green"
    )
})
}

shinyApp(ui, server)
