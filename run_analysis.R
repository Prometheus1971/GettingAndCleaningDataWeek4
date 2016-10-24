# Ched Lane 
# Getting and Cleaning Data Week 4 Project
library(plyr)
library(reshape2)


activityLabels <- read.table("UCI HAR Dataset/activity_labels.txt",colClasses = c("numeric","character"))
features <- read.table("UCI HAR Dataset/features.txt",colClasses = c("numeric","character"))

#select/create required features/columns and tidy their names.
targetFeatures<- grep(".*std.*|.*mean.*",features[,2]) #returns integer vector of rows that match
targetFeatureNames<- features[targetFeatures,2] 

targetFeatureNames<- gsub('-mean','Mean',targetFeatureNames)
targetFeatureNames<- gsub('-std','Std',targetFeatureNames)
targetFeatureNames<- gsub('[-()]','',targetFeatureNames)

#load the data files into data frames
xtrain<- read.table("UCI HAR Dataset/train/X_train.txt")[targetFeatures]
trainAct<- read.table("UCI HAR Dataset/train/y_train.txt")
trainSub<- read.table("UCI HAR Dataset/train/subject_train.txt")
trainCombined<- cbind(trainSub,trainAct,xtrain)

xtest<- read.table("UCI HAR Dataset/test/x_test.txt")[targetFeatures]
testAct<- read.table("UCI HAR Dataset/test/y_test.txt")
testSub<- read.table("UCI HAR Dataset/test/subject_test.txt")
testCombined<- cbind(testSub,testAct,xtest)

#Merge the train data and the test data
allData<- rbind(trainCombined,testCombined)
colnames(allData)<- c("Subject","Activity",targetFeatureNames)

allData$Subject<- as.factor(allData$Subject)
allData$Activity<- as.factor(allData$Activity)

allData$Activity<- factor(allData$Activity,levels=c(1,2,3,4,5,6),labels=c(activityLabels[,2]))

AllDataGrouped<- melt(allData,c("Subject","Activity"))
AllDataMean<- dcast(AllDataGrouped,Subject + Activity ~ variable, mean)

write.table(AllDataMean, "tidy.txt", row.names = FALSE, quote = FALSE)
