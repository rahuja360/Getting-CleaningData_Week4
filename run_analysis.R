library("dplyr", lib.loc="/usr/lib64/R/library")

file <- "getdata_dataset.zip"

## Download and unzip the dataset:

if (!file.exists(file)){
  fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip "
  download.file(fileURL, file, method="curl")
}  
if (!file.exists("UCI HAR Dataset")) { 
  unzip(file) 
}

## Load data

# Read train data

xtrain <- read.table("./UCI HAR Dataset/train/X_train.txt")
head(xtrain, 20)
ytrain <- read.table("./UCI HAR Dataset/train/y_train.txt")
head(ytrain, 20)
subjectrain <- read.table("./UCI HAR Dataset/train/subject_train.txt")
head(subjectrain, 20)

# Read test data

xtest <- read.table("./UCI HAR Dataset/test/X_test.txt")
head (xtest, 20)
ytest <- read.table("./UCI HAR Dataset/test/y_test.txt")
head (ytest, 20)
subjectest <- read.table("./UCI HAR Dataset/test/subject_test.txt")
head(subjectest, 20)

# Read data description

variablenames <- read.table("./UCI HAR Dataset/features.txt")
head(variablenames, 20)

# Read activity labels

activitylabels <- read.table("./UCI HAR Dataset/activity_labels.txt")
head(activitylabels, 20)

## Merge the training and the test sets to create dataset

xtotal <- rbind(xtrain, xtest)
head(xtotal, 20)
ytotal <- rbind(ytrain, ytest)
head (ytotal, 20)
subjectotal <- rbind(subjectrain, subjectest)
head(subjectotal, 20)

#  Extract the mean and standard deviation for each measurement.
select_vars <- variablenames[grep("mean\\(\\)|std\\(\\)",variablenames[, 2]),]
head(select_vars,20)
xtotal <- xtotal[,select_vars[,1]]
head(xtotal, 20)

# Use descriptive activity and name activities
colnames(ytotal) <- "activity"
ytotal$activitylabels <- factor(ytotal$activity, labels = as.character(activitylabels[, 2]))
activitylabels <- ytotal[, -1]
head(activitylabels, 20)

# Add data variable labels
colnames(xtotal) <- variablenames[select_vars[,1],2]

# Create independent tidy data set with the average of each variable/activity/subject
colnames(subjectotal) <- "subject"
total <- cbind(xtotal, activitylabels, subjectotal)
totalmean <- total %>% group_by(activitylabels, subject) %>% summarize_each(funs(mean))
write.table(totalmean, file = "~/Desktop/UCI HAR Dataset/tidydata.txt", row.names = FALSE, col.names = TRUE)

#Check data table created
read.table("~/Desktop/UCI HAR Dataset/tidydata.txt")
