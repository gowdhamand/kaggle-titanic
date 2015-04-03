#Gowdhaman D - 2 APR 2014

setwd("C:/2Piworking/Kaggle/titanic/data")

train <- read.csv("train.csv")
test <- read.csv("test.csv")
library("rpart", lib.loc="C:/Program Files/R/R-3.1.0/library")
str(train)

install.packages("rattle")
install.packages("rpart.plot")
install.packages("RColorBrewer")

library(rattle)
library(rpart.plot)
library(RColorBrewer)

fit <- rpart(Survived ~ Sex, data=train,method="class")
fancyRpartPlot(fit)

##Decision tree
fit <- rpart(Survived ~ Pclass + Sex + Age + SibSp + Parch + Fare + Embarked, data=train, method="class")
plot(fit)
text(fit)
fancyRpartPlot(fit)

Prediction <- predict(fit,test,type="class")

submit <- data.frame(PassengerId = test$PassengerId, Survived= Prediction)
write.csv(submit, file="DecisionTreePrediction.csv",row.names=FALSE)
