#ccleaning of statista data of countries and visitors

#install.packages("readxl")
#install.packages("tidyverse")
#installed packages for reading excel files and manipulating them
library(readxl)
library(tidyverse)
# read_excel reads both xls and xlsx files
test=read_excel("C:\\Users\\MOLAP\\Documents\\Project\\statistic_id261729_european-countries-with-the-largest-number-of-international-tourist-arrivals-in-2017.xlsx",sheet = 2,skip=4)
#choosing the second page only and remving top 4 not required rows
#Adding column names and year column with 2017 and choosing the top 10 countries 
names(test)[1]="Visitor_Country"
names(test)[2]="Visitors"
test$Year<- 2017
test<-test[1:11,]
#removing row 8 i.e russia as we do not have any restaurant data
test<- test[-c(8),]
#Adding column Id to the data of 10 countries
test$CID = paste("C",c(1:10))
#changing the attributes to numeric
test$Visitor_Country<-as.character(test$Visitor_Country)
test$Visitors<-as.numeric(test$Visitors)
test$Year<-as.numeric(test$Year)

write.csv(test,"Visitors.csv",row.names = FALSE)

########################################################################################

#install.packages("htmltab")
#scraping the wiki page and getting the table 2 data
library(htmltab) 
library(sqldf)
url="https://en.wikipedia.org/wiki/Area_and_population_of_European_countries" 
Population_Data=htmltab(doc=url, which=2)    

#Removing all "," from the numbers so that calculations can be done on them

Population_Data$`Area(km)`  <- gsub(",","" , Population_Data$`Area(km)` ,ignore.case = TRUE)
Population_Data$Population  <- gsub(",","" , Population_Data$Population ,ignore.case = TRUE)
Population_Data$`Population Density(/km)`  <- gsub(",","" , Population_Data$`Population Density(/km)` ,ignore.case = TRUE)

Population_Data[27, 1] <- "France"

#To extract the data for particular countries - 
Population_Data<-sqldf('SELECT *
                 FROM Population_Data 
                 WHERE 
                 Name in ("France","Spain","Italy","United Kingdom","Germany","Austria",
                 "Greece","Poland","Netherlands","Hungary") Order by Name')
#editing the column
names(Population_Data)[1] = "Population_Country"
names(Population_Data)[0] = NULL
#changing the attributes to numeric and character
Population_Data$`Area(km)` <- as.numeric(Population_Data$`Area(km)`)
Population_Data$Population_Country <- as.character(Population_Data$Population_Country)
Population_Data$`Population Density(/km)`<- as.numeric(Population_Data$`Population Density(/km)`)
Population_Data$Population<- as.numeric(Population_Data$Population)

write.csv(Population_Data,"Population_Data.csv",row.names = FALSE)  

######################################################

#install.packages("readxl")
#install.packages("tidyverse")
library(readxl)
library(tidyverse)
library(sqldf)
# read_excel reads both xls and xlsx files
Turnover=read_excel("C:\\Users\\MOLAP\\Documents\\Project\\Turnover.xls",skip=3)
#choosing only required rows

names(Turnover)[1] = "Country_Turnover"
Turnover<-sqldf('SELECT *
                 FROM Turnover 
                 WHERE 
                 Country_Turnover in ("France","Spain","Italy","United Kingdom","Germany","Austria",
                 "Greece","Poland","Netherlands","Hungary") Order by Country_Turnover')
#removing all the not required columns
Turnover<- Turnover[,-c(2:9)]
Turnover<- Turnover[,-c(10:17)]
Turnover<- Turnover[,-c(3,5,7,9)]
#Changing to numeric 
Turnover$`2017Q1` <- as.numeric(Turnover$`2017Q1`)
Turnover$`2017Q2` <- as.numeric(Turnover$`2017Q2`)
Turnover$`2017Q3` <- as.numeric(Turnover$`2017Q3`)
Turnover$`2017Q4` <- as.numeric(Turnover$`2017Q4`)

Turnover$Turnover <- Turnover$`2017Q1` + Turnover$`2017Q2` + Turnover$`2017Q3` + Turnover$`2017Q4`

Turnover <- Turnover[,-c(2:5)]
write.csv(Turnover,"Turnover.csv",row.names = FALSE)

#########################################################

#install.packages("rvest")
#install.packages("xml2")
#install.packages("dplyr")

library(rvest)
library(xml2)
library(dplyr)
library(sqldf)

website_url <- "https://www.numbeo.com/cost-of-living/prices_by_country.jsp?itemId=1&displayCurrency=EUR"


tables <- website_url %>%
  read_html() %>%
  html_nodes('table');

exp_table<-html_table(as.matrix(tables[3]))[[1]] 
exp_table$Rank <- NULL
names(exp_table)[2] = "Meal Expense" 
#To extract the data for particular countries - 
exp_table<-sqldf('SELECT * FROM exp_table 
                 WHERE 
                 Country in ("France","Spain","Italy","United Kingdom","Germany","Austria",
                 "Greece","Poland","Netherlands","Hungary") Order by Country')
#editing column
names(exp_table)[1] = "Meal_Country"
exp_table$Meal_Country<- as.character(exp_table$Meal_Country)
exp_table$`Meal Expense`<-as.numeric(exp_table$`Meal Expense`)

write.csv(exp_table,"Meal_Expense.csv",row.names = FALSE)

######################################

library(readxl)
library(tidyverse)
library(sqldf)
# read_excel reads both xls and xlsx files
Restaurant <- read.csv(file="C:\\Users\\MOLAP\\Documents\\Project\\TA_restaurants_curated.csv", header=TRUE, sep=",")
#removing the not required columns
Restaurant$X <- NULL
Restaurant$URL_TA <- NULL
Restaurant$Reviews <- NULL
Restaurant$Ranking<- NULL
#Adding the country column 
Restaurant["Restaurant_Country"] <- "Ireland"

#selecting the reuqired restaurants as per our top countries
Restaurant<-sqldf('SELECT * FROM Restaurant 
                  WHERE 
                  City in ("Amsterdam","Athens","Barcelona","Berlin","Budapest","Edinburgh",
                  "Hamburg","Krakow","London","Lyon","Madrid","Milan","Munich","Paris","Rome","Vienna") Order by City')
#Adding the respective countries in the country column

Restaurant$Restaurant_Country[Restaurant$City=='Amsterdam'] <- 'Netherlands'
Restaurant$Restaurant_Country[Restaurant$City=='Athens'] <- 'Greece'
Restaurant$Restaurant_Country[Restaurant$City=='Barcelona'] <- 'Spain'
Restaurant$Restaurant_Country[Restaurant$City=='Berlin'] <- 'Germany'
Restaurant$Restaurant_Country[Restaurant$City=='Budapest'] <- 'Hungary'
Restaurant$Restaurant_Country[Restaurant$City=='Edinburgh'] <- 'United Kingdom'
Restaurant$Restaurant_Country[Restaurant$City=='Hamburg'] <- 'Germany'
Restaurant$Restaurant_Country[Restaurant$City=='Krakow'] <- 'Poland'
Restaurant$Restaurant_Country[Restaurant$City=='London'] <- 'United Kingdom'
Restaurant$Restaurant_Country[Restaurant$City=='Lyon'] <- 'France'
Restaurant$Restaurant_Country[Restaurant$City=='Madrid'] <- 'Spain'
Restaurant$Restaurant_Country[Restaurant$City=='Milan'] <- 'Italy'
Restaurant$Restaurant_Country[Restaurant$City=='Munich'] <- 'Germany'
Restaurant$Restaurant_Country[Restaurant$City=='Paris'] <- 'France'
Restaurant$Restaurant_Country[Restaurant$City=='Rome'] <- 'Italy'
Restaurant$Restaurant_Country[Restaurant$City=='Vienna'] <- 'Austria'
#converting price range column $=Cheap $$-$$$ = Average $$$$ = Expensive NA = Not Given
Restaurant$Price.Range<- as.character(Restaurant$Price.Range)
Restaurant[which(Restaurant$Price.Range=="$"),"Price.Range"]="Cheap"
Restaurant[which(Restaurant$Price.Range=="$$ - $$$"),"Price.Range"]="Average"
Restaurant[which(Restaurant$Price.Range=="$$$$"),"Price.Range"]="Expensive"

#Converting Name
Restaurant$Name <- as.character(Restaurant$Name)
str(Restaurant)
#subsetting cuisine as it has redundancy i.e only one value should remain
Restaurant$Cuisine.Style <- gsub(",.*","",Restaurant$Cuisine.Style)
str(Restaurant)
Restaurant$Cuisine.Style <- gsub("\\[","",Restaurant$Cuisine.Style)
Restaurant$Cuisine.Style <- gsub("\\]","",Restaurant$Cuisine.Style)
Restaurant$Cuisine.Style <- gsub("\\'","",Restaurant$Cuisine.Style)
#Converting Cuisine into factor
Restaurant$Cuisine.Style <- as.factor(Restaurant$Cuisine.Style)
str(Restaurant)
#replacing all blank cells with NA or Unknown etc
nrow(Restaurant[!complete.cases(Restaurant),])  #Checking the rows with blank value
str(Restaurant)
Restaurant$Cuisine.Style <- as.character(Restaurant$Cuisine.Style)
str(Restaurant)
#replacing the blank cells with 0 char length with NA
Restaurant$Cuisine.Style[nchar(Restaurant$Cuisine.Style)==0] <- NA
Restaurant$Cuisine.Style[is.na(Restaurant$Cuisine.Style)] <- "Unavailable"

Restaurant$Rating[nchar(Restaurant$Rating)==0] <- NA
Restaurant$Rating[is.na(Restaurant$Rating)] <- 0

Restaurant$Price.Range[nchar(Restaurant$Price.Range)==0] <- NA
Restaurant$Price.Range[is.na(Restaurant$Price.Range)] <- "Unknown"

Restaurant$Number.of.Reviews[is.na(Restaurant$Number.of.Reviews)] <- 0

#changing the type
Restaurant$Cuisine.Style <- as.factor(Restaurant$Cuisine.Style)
Restaurant$Rating <- as.factor(Restaurant$Rating)
Restaurant$Price.Range <- as.factor(Restaurant$Price.Range)
Restaurant$Number.of.Reviews <- as.factor(Restaurant$Number.of.Reviews)
Restaurant$City <- as.character(Restaurant$City)
Restaurant$Restaurant_Country <- as.factor(Restaurant$Restaurant_Country)
Restaurant$ID_TA <- as.character(Restaurant$ID_TA)


Restaurant <- Restaurant[!duplicated(Restaurant[c("ID_TA")]),]

write.csv(Restaurant,"Restaurant.csv",row.names = FALSE)



###############################

