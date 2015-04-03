#Gowdhaman D - 2 APR 2014

setwd("C:/2Piworking/Kaggle/titanic/data")

train <- read.csv("train.csv")
test <- read.csv("test.csv")
library("rpart", lib.loc="C:/Program Files/R/R-3.1.0/library")

test$Survived <- NA
combi <- rbind(train,test)

train$Name[1]

combi$Name <- as.character(combi$Name)
combi$Name[1]

strsplit(combi$Name[1],split = '[,.]')[[1]][2]

combi$Title <- sapply(combi$Name, FUN=function(x) {strsplit(x,split = '[,.]')[[1]][2]})

combi$Title <- sub(' ','',combi$Title)
combi$Title[combi$Title %in% c('Mlle','Mme')] <- 'Mlle'
combi$Title[combi$Title %in% c('Capt','Don','Major','Sir')] <- 'Sir'
combi$Title[combi$Title %in% c('Dona','Lady','the Countess','Jonkheer')] <- 'Lady'

table(combi$Title)

combi$Title <- factor(combi$Title)
combi$Familysize <- combi$SibSp + combi$Parch + 1

combi$SurName <- sapply(combi$Name, FUN=function(x) {strsplit(x,split = '[,.]')[[1]][1]})

combi$FamilyId <- paste(as.character(combi$Familysize),combi$SurName,sep = "")

combi$FamilyId[combi$Familysize <= 2] <- 'small'

famiIds <-data.frame(table(combi$FamilyId))
famiIds <- famiIds[famiIds$Freq <= 2,] 

combi$FamilyId[combi$FamilyId %in% famiIds$Var1] <- 'small'
combi$FamilyId <- factor(combi$FamilyId)

# install.packages("rattle")
# install.packages("rpart.plot")
# install.packages("RColorBrewer")

library(rattle)
library(rpart.plot)
library(RColorBrewer)

train <- combi[1:891,]
test <- combi[892:1309,]

set.seed(415)
fit <- rpart(Survived ~ Pclass + Sex + Age + SibSp + Parch + Fare + Embarked + Title + Familysize + FamilyId, data=combi, method="class")
fancyRpartPlot(fit)


Prediction <- predict(fit,test,type="class")

submit <- data.frame(PassengerId = test$PassengerId, Survived= Prediction)
write.csv(submit, file="FeatureEngg.csv",row.names=FALSE)
