getwd()

filename<-"getdata.zip"
if(!file.exists(filename)){
  url<-'https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip'
  download.file(url, filename)
}
if(!file.exists('UCI HAR Dataset')){unzip(filename)}
setwd('./UCI HAR Dataset')

activitylabels<-read.table("activity_labels.txt")
str(activitylabels)
activitylabels[,2]<-as.character(activitylabels[,2])
features<-read.table('features.txt')
str(features)
features[,2]<-as.character(features[,2])

featuresWanted<-grep('mean|std', features[,2])
featuresWanted.names<-features[featuresWanted, 2]
featuresWanted.names<-gsub('[-()]', '', featuresWanted.names)

featuresWanted.names

train <- read.table("./train/X_train.txt")[featuresWanted]
trainactivities<-read.table('./train/y_train.txt')
trainsubjects<-read.table('./train/subject_train.txt')
train_combinded<-cbind(trainsubjects, trainactivities, train)

test<-read.table('./test/X_test.txt')[featuresWanted]
testactivities<-read.table('./test/y_test.txt')
testsubjects<-read.table('./test/subject_test.txt')
test_combined<-cbind(testsubjects, testactivities, test)
data_combined<-rbind(train_combinded, test_combined)
names(data_combined)<-c('subject', 'activities', featuresWanted.names)

data_combined$subject<-as.factor(data_combined$subject)
data_combined$activities<-as.factor(data_combined$activities)

library(reshape2)
data_melt<-melt(data_combined, id=c('subject', 'activities'))
head(data_melt)
data_dcast<-dcast(data_melt, subject+activities~variable, mean)
head(data_dcast)

write.table(data_dcast, 'tidy.txt', row.names = FALSE, quote=FALSE)
getwd()
