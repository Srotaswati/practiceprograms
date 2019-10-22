library(AppliedPredictiveModeling)
data(segmentationOriginal)
library(caret)
inTrain<-createDataPartition(y=segmentationOriginal$Case,p=0.6,list=FALSE)
training<-segmentationOriginal[inTrain,]
testing<-segmentationOriginal[-inTrain,]
set.seed(125)
modFit<-train(Class~.,data=training,method="rpart")
modFit$finalModel
library(rattle)
fancyRpartPlot(modFit$finalModel)

library(pgmm)
data(olive)
olive = olive[,-1]
mdl<-train(Area~.,method="rpart",data=olive)
newdata = as.data.frame(t(colMeans(olive)))
predict(mdl,newdata = newdata)

library(ElemStatLearn)
data(SAheart)
set.seed(8484)
train = sample(1:dim(SAheart)[1],size=dim(SAheart)[1]/2,replace=F)
trainSA = SAheart[train,]
testSA = SAheart[-train,]
missClass = function(values,prediction){sum(((prediction > 0.5)*1) != values)/length(values)}
set.seed(13234)
modelSA <- train(chd ~ age + alcohol + obesity + tobacco + typea + ldl, data = trainSA, method = "glm", family = "binomial")
missClass(trainSA$chd, predict(modelSA, newdata = trainSA))
missClass(testSA$chd, predict(modelSA, newdata = testSA))

library(ElemStatLearn)
data(vowel.train)
data(vowel.test)
vowel.train$y <- as.factor(vowel.train$y)
vowel.test$y <- as.factor(vowel.test$y)
set.seed(33833)
library(randomForest)
mdl<-randomForest(y~.,data=vowel.train)
order(varImp(mdl),decreasing = T)


