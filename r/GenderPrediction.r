#Gowdhaman D - 2 APR 2014

setwd("C:/2Piworking/Kaggle/titanic/data")

train <- read.csv("train.csv")
test <- read.csv("test.csv")

str(train)
table(train$Survived)
prop.table(table(train$Survived))

test$Survived <- rep(0,418)

summary(train$Sex)

prop.table(table(train$Sex,train$Survived))

prop.table(table(train$Sex,train$Survived),1)

test$Survived <- 0
##based on training set. Female as more chance to survie. So lets make all women survied.
test$Survived[test$Sex == 'female'] <- 1


submit <- data.frame(PassengerId = test$PassengerId, Survived= test$Survived)
write.csv(submit, file="allWeredied.csv",row.names=FALSE)


##To find out the age pattern
summary(train$Age)
train$Child <- 0
train$Child[train$Age < 18 ] <- 1
#Number of people survived
aggregate(Survived ~ Child + Sex, data=train,FUN=sum)
#Number of people there
aggregate(Survived ~ Child + Sex, data=train,FUN=length)
#Chance of survival
aggregate(Survived ~ Child + Sex, data=train,FUN=function(x) {sum(x)/length(x)})

str(train)
summary(train$Fare)

train$Fare2 <- '30+'
train$Fare2[train$Fare < 30 & train$Fare >= 20 ] <- '20-30'
train$Fare2[train$Fare < 20 & train$Fare >= 10 ] <- '10-20'
train$Fare2[train$Fare < 10] <- '<10'
#Chance based on ticket they buy
aggregate(Survived ~ Fare2 + Pclass + Sex, data=train,FUN=function(x) {sum(x)/length(x)})

test$Survived <- 0
test$Survived[test$Sex == 'female'] <- 1
test$Survived[test$Sex == 'female' & test$Pclass == 3 & test$Fare >= 20 ] <- 0

submit <- data.frame(PassengerId = test$PassengerId, Survived= test$Survived)
write.csv(submit, file="GenederandClassPrediction.csv",row.names=FALSE)
