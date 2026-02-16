library(readr)
library(dplyr)
library(tidyr)
library(janitor)

#read the dataset
Iris <- read_csv("Iris_data.csv")
read.csv("Iris_data.csv")


#first 6 rows of dataset
head(Iris)

#last 6 rows of dataset
tail(Iris)


#shape of the dataset
dim(Iris)

#to show column nanmes
colnames(Iris)

#Datatypes of Ech column
sapply(Iris, class)

#Null values per Column
colSums(is.na(Iris))

#calculating duplicates
sum(duplicated(Iris))

#remove duplictaes
Iris <- unique(Iris)


#calculating duplicates
sum(duplicated(Iris))

#shape of the dataset
dim(Iris)


#handling null values :
#for column sepal length: 
Iris$sepal_length[is.na(Iris$sepal_length)] <-
  median(Iris$sepal_length, na.rm = TRUE)

#for column sepal width: 
Iris$sepal_width[is.na(Iris$sepal_width)] <-
  median(Iris$sepal_width, na.rm = TRUE)

#for column petal length: 
Iris$petal_length[is.na(Iris$petal_length)] <-
  median(Iris$petal_length, na.rm = TRUE)

#for column petal width: 
Iris$petal_width[is.na(Iris$petal_width)] <-
  median(Iris$petal_width, na.rm = TRUE)

#for column species: 
Iris$species[is.na(Iris$species)] <-
  ifelse(Iris$petal_length[is.na(Iris$species)] > 5, "Iris-virginica",
         ifelse(Iris$petal_length[is.na(Iris$species)] < 2, "Iris-setosa",
                "Iris-versicolor"))



#null values per column
colSums(is.na(Iris))

#saving clean csv
write_csv(Iris, "cleaned_Iris.csv")









