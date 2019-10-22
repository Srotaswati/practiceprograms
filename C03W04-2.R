if (!file.exists("./data/getdata.zip")){
fileurl<-"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileurl,"./data/getdata.zip",method="curl")
}
if (!file.exists("./data/UCI HAR Dataset")) { 
  unzip("./data/getdata.zip",exdir="./data") 
}
activity <- read.table("./data/UCI HAR Dataset/activity_labels.txt",stringsAsFactors = FALSE)
features <- read.table("./data/UCI HAR Dataset/features.txt",stringsAsFactors = FALSE)

meanstd <- grep(".*mean.*|.*std.*", features[,2])
meanstd.names <- features[meanstd,2]
meanstd.names = gsub('-mean', 'Mean', meanstd.names)
meanstd.names = gsub('-std', 'Std', meanstd.names)
meanstd.names <- gsub('[-()]', '', meanstd.names)

train <- read.table("./data/UCI HAR Dataset/train/X_train.txt")[meanstd]
train_activities <- read.table("./data/UCI HAR Dataset/train/Y_train.txt")
train_subjects <- read.table("./data/UCI HAR Dataset/train/subject_train.txt")
train <- cbind(train_subjects, train_activities, train)

test <- read.table("./data/UCI HAR Dataset/test/X_test.txt")[meanstd]
test_activities <- read.table("./data/UCI HAR Dataset/test/Y_test.txt")
test_subjects <- read.table("./data/UCI HAR Dataset/test/subject_test.txt")
test <- cbind(test_subjects, test_activities, test)

data <- rbind(train, test)
colnames(data) <- c("subject", "activity", meanstd.names)

data$activity <- factor(data$activity, levels = activity[,1], labels = activity[,2])
data$subject <- as.factor(data$subject)

library(reshape2)
data.melted <- melt(data, id = c("subject", "activity"))
data.mean <- dcast(data.melted, subject + activity ~ variable, mean)

write.table(data.mean, "./data/tidy.txt", row.names = FALSE, quote = FALSE)