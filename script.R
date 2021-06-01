# 1. Install and load required packages

install.packages('RPostgreSQL')
install.packages('devtools')

library(DBI)
library(RPostgreSQL)
library(devtools)

# 2. Connect to the Postgres database

# NOTE - change the ip address

con <- dbConnect(RPostgres::Postgres(), dbname = 'eurovisiondb', host="<ip address here>", port="5432", user='postgres', password='password')

# 3. List and check to see if the table exists

dbListTables(con)

dbExistsTable(con, c("eurovision"))

# 4. read/import the eurovision table from the database into a data frame

data <- dbReadTable(con, c("eurovision"))

View(data)

head(data)
tail(data)

# 1. How many winners have won the eurovision song contest? Answer: 68 

length(data$winner)

# 2. When did Eurovision begin? Answer: 1956

min(data$year)

head(data)

# 3. How many years has the song contest been running? Answer: 65 years

range(data$year)

running_length <- 2021 - 1956
running_length

# 4. Who has won the contest the most times? Answer: Ireland: 7. 

won_most <- table(data$winner)

won_most[which.max(won_most)]

# 5. What country has finished runner-up the most times? Answer. United Kingdom = 15

runner_up_most <- table(data$runner_up)

runner_up_most[which.max(runner_up_most)]

# 6. What is the most popular language of the winning song? English = 33. 

language_won <- table(data$language)

language_won[which.max(language_won)]

# 7 Compare by plotting the winning languages prior to the 1999 rule change. 
# The first plot from 1956 to 1998 and the second plot from 1999 to 2021. 

# 7.1 split the data.frame in two based on 1956 - 1998 and 1999 to 2021

first  <-  subset(data, data$year <=1998)
second <-  subset(data, data$year >=1999)

View(first)
View(second)

# 7.2 compare winning languages prior to the rule change

first_language_won <- data.frame(table(first$language))

View(first_language_won)

second_language_won <- data.frame(table(second$language))

View(second_language_won)

# 7.3 plot 

library(ggplot2)
library(scales)

# basic bar graphs

# Languages between 1956 - 1998

ggplot(first_language_won, aes(x=Var1, y=Freq, fill=Var1)) +
  geom_bar(stat="identity",width=0.7, color="black") +
  scale_fill_brewer(palette="Set3") +
  labs(x="Language", y = "Number of times won") +
  ylim(0, 20) +
  ggtitle("The language of winning songs (1956 - 1998)") +
  theme_classic()+
  theme(plot.title = element_text(hjust = 0.5)) +
  theme(axis.text.x = element_text(angle=60, vjust = 0.6, hjust = 0.6),
        axis.text.y = element_text(angle=0)) +
  labs(fill='Language') +
  theme(legend.position = "none")

# Languages between 1999 - 2021


ggplot(second_language_won, aes(x=Var1, y=Freq, fill=Var1)) +
  geom_bar(stat="identity",width=0.7, color="black") +
  scale_fill_brewer(palette="Set3") +
  labs(x="Language", y = "Number of times won") +
  ylim(0, 20) +
  ggtitle("The language of winning songs (1999 - 2021)") +
  theme_classic()+
  theme(plot.title = element_text(hjust = 0.5)) +
  theme(axis.text.x = element_text(angle=60, vjust = 0.6, hjust = 0.6),
        axis.text.y = element_text(angle=0)) +
  labs(fill='Language') +
  theme(legend.position = "none")

# 8. Plot the number of participants against the year.

ggplot(data=data, aes(x=year, y=participant_number, group=1)) +
  geom_line() +
  geom_point() +
  geom_vline(xintercept = 2004, linetype="dotted",color = "red", size=1) +
  ggtitle("The number of countries participating in the Eurovision") +
  labs(y = "Participating countries") +
  scale_x_continuous(name="Year", limits=c(1950, 2021), 
                     breaks=c(1950, 1960, 1970, 1980, 1990, 2000, 2010, 2020)) +
  ylim(0, 50) +
  theme_classic() +
  theme(plot.title = element_text(hjust = 0.5)) +
  theme(legend.position = "none")

# Countries that have won 1956 - 1998

View(first)

first_winner <- data.frame(table(first$winner))

ggplot(first_winner, aes(x=Var1, y=Freq, fill=Var1)) +
  geom_bar(stat="identity",width=0.7, color="black") +
  labs(x="Country", y = "Number of times won") +
  scale_y_continuous(name="Times won", limits=c(0, 10), 
                     breaks=c(0, 2, 4, 6, 8, 10)) +
  ggtitle("Winning Eurovision countries (1956 - 1998)") +
  theme_classic()+
  theme(plot.title = element_text(hjust = 0.5)) +
  theme(axis.text.x = element_text(angle=40, vjust = 0.9, hjust = 1),
        axis.text.y = element_text(angle=0)) +
  theme(legend.position = "none") +
  labs(fill='Country')


second_winner <- data.frame(table(second$winner))

ggplot(second_winner, aes(x=Var1, y=Freq, fill=Var1)) +
  geom_bar(stat="identity",width=0.7, color="black") +
  labs(x="Country", y = "Number of times won") +
  scale_y_continuous(name="Times won", limits=c(0, 10), 
                     breaks=c(0, 2, 4, 6, 8, 10)) +
  ggtitle("Winning Eurovision countries (1999 - 2021)") +
  theme_classic()+
  theme(plot.title = element_text(hjust = 0.5)) +
  theme(axis.text.x = element_text(angle=40, vjust = 0.9, hjust = 1),
        axis.text.y = element_text(angle=0)) +
  theme(legend.position = "none") +
  labs(fill='Country')

# Create winners table joining ebu data and the eurovision winners.

eurovision_winners <- data.frame(table(data$winner))

eurovision_winners$country <- eurovision_winners$Var1
eurovision_winners$win_frequency <- eurovision_winners$Freq

# remove previous columns

eurovision_winners$Var1 <- NULL
eurovision_winners$Freq <- NULL

# Import ebu table into the R environment

dbListTables(con)

data1 <- dbReadTable(con, c("ebu"))

View(data1)
View(eurovision_winners)

# Join winners table with EBU table by country

df = merge(x=data1, y=eurovision_winners, by="country", all=TRUE)
View(df)

# replace na to 0 wins 

df$win_frequency[is.na(df$win_frequency)] <- 0
View(df)

# Yugoslavia has won but has not exsisted since 1992! Change status to past.

# data.frame[row_number, column_number] = new_value

df[77, 2] <- "past"

# write the data frame to the database using the table name as eurovision_winners

dbWriteTable(con, "eurovision_winners", df)

# close the connection

dbDisconnect(con)

# You can now log out of Rstudio, pgadmin4 and close down the Docker network. 


