setwd("~/Documents")

## Download data
if (!file.exists("UCI HAR Dataset.zip")){
    fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
    download.file(fileUrl, "UCI HAR Dataset.zip", method = "curl")
    unzip("UCI HAR Dataset.zip")
}

## Merges the training and the test sets to create one data set
## Read data
xTest<- read.table("./UCI HAR Dataset/test/X_test.txt")
yTest<- read.table("./UCI HAR Dataset/test/Y_test.txt")
subjectTest <- read.table("./UCI HAR Dataset/test/subject_test.txt")

xTrain <- read.table("./UCI HAR Dataset/train/X_train.txt")
yTrain <- read.table("./UCI HAR Dataset/train/Y_train.txt")
subjectTrain <- read.table("./UCI HAR Dataset/train/subject_train.txt")

features <- read.table("./UCI HAR Dataset/features.txt")
activityLabels <- read.table("./UCI HAR Dataset/activity_labels.txt")

## Merge data
mergeTest <- data.frame(subjectTest, yTest, xTest)
mergeTrain <- data.frame(subjectTrain, yTrain, xTrain)
data <- rbind(mergeTest, mergeTrain)


## Extracts only the measurements on the mean and standard deviation for each measurement
mean_sd_index <- grep("mean\\(\\)|std\\(\\)", features[, 2]) + 2
index <- c(c(1,2), mean_sd_index)
dataExtracts <- data[, index]


## Uses descriptive activity names to name the activities in the data set
dataExtracts[ ,2] <- activityLabels[dataExtracts[ ,2] ,2]


## Appropriately labels the data set with descriptive variable names
variableNames <- as.character(features[mean_sd_index, 2])
names(dataExtracts) <- c(c("Subject", "Activity"), variableNames)


## From the previous step, creates a second, independent tidy data set 
## with the average of each variable for each activity and each subject
tidyData2 <- aggregate(dataExtracts[,3:length(dataExtracts)], by=list(activity=dataExtracts$Activity, subject=dataExtracts$Subject), mean)
write.table(tidyData2, file = "tidydata.txt", row.name = FALSE)

