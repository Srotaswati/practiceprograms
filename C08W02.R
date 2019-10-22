library(AppliedPredictiveModeling) #for dataset
library(caret) 
library(Hmisc) #for cut2
library(GGally) #for ggpairs

## Read the dataset and create training and testing sets
data(concrete); set.seed(1000)
inTrain = createDataPartition(mixtures$CompressiveStrength, p = 3/4)[[1]]
training = mixtures[ inTrain,]
testing = mixtures[-inTrain,]
head(training)

training2<-training
training2$CompressiveStrength<-cut2(training$CompressiveStrength,g=4)
ggpairs(data = training2,columns=c("FlyAsh","Age","CompressiveStrength"),aes(colour=CompressiveStrength))

par(mfrow=c(2,1))
hist(training$Superplasticizer);
hist(log(training$Superplasticizer+1))

set.seed(3433);data(AlzheimerDisease)
adData = data.frame(diagnosis,predictors)
inTrain = createDataPartition(adData$diagnosis, p = 3/4)[[1]]
training = adData[ inTrain,]
testing = adData[-inTrain,]
trainingIL<-training[grepl("^IL",names(training))]
procTrain<-preProcess(trainingIL,method="pca",thresh = 0.9)
procTrain

training2<-training[grepl("^IL|diagnosis",names(training))]
testing2<-testing[grepl("^IL|diagnosis",names(testing))]
## Had to install package e1071 here
model1<-train(diagnosis~.,data=training2,method="glm")
model2<-train(diagnosis~.,data=training2,method="glm",preProcess = "pca", trControl=trainControl(preProcOptions = list(thresh=0.8)))
c(confusionMatrix(predict(model1,testing2),testing2$diagnosis)$overall[1],confusionMatrix(predict(model2,testing2),testing2$diagnosis)$overall[1])
