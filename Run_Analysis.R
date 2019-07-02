

## Assignment Week 4
## Data download and unzip 

# string variables for file download
f <- "UCIdata.zip"
url <- "http://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
dir <- "UCI HAR Dataset"

# File download verification. If file does not exist, download to working directory.
if(!file.exists(f)){
  download.file(url,f, mode = "wb") 
}

# File unzip verification. If the directory does not exist, unzip the downloaded file.
if(!file.exists(dir)){
  unzip("UCIdata.zip", files = NULL, exdir=".")
}

featuresWanted <- grep(".*mean.*|.*std.*", features[,2])
featuresWanted.names <- features[featuresWanted,2]
featuresWanted.names = gsub('-mean', 'Mean', featuresWanted.names)
featuresWanted.names = gsub('-std', 'Std', featuresWanted.names)
featuresWanted.names <- gsub('[-()]', '', featuresWanted.names)

## Read Data
subj_test <- read.table("UCI HAR Dataset/test/subject_test.txt")
subj_train <- read.table("UCI HAR Dataset/train/subject_train.txt")
x_test <- read.table("UCI HAR Dataset/test/X_test.txt")[featuresWanted]
x_train <- read.table("UCI HAR Dataset/train/x_train.txt")
y_test <- read.table("UCI HAR Dataset/test/y_test.txt")
y_train <- read.table("UCI HAR Dataset/train/y_train.txt")

features <- read.table("UCI HAR Dataset/features.txt", col.names = c("v1","features"))
act_labels <- read.table("UCI HAR Dataset/activity_labels.txt", col.names = c("code", "activity"))

# Extract only the data on mean and standard deviation

# 1. Merges the training and the test sets to create one data set.
x <- rbind(X_train,X_test)[featuresWanted]

y <- rbind(y_train,y_test)
subject <- rbind(subj_train,subj_test)


names(mergedata)
mergedata <- cbind(y,subject,x)

names(mergedata)
colnames(mergedata) <- c("subject", "activity", featuresWanted.names)


dim(mergedata)

names(mergedata)

# 3. Uses descriptive activity names to name the activities in the data set
#change activity type from numeric to character, so that it can accept activity names. 
# The activity names are taken from metadata activityLabels.

mergedata$activity <- act_labels[mergedata$activity, 2]

mergedata$activity
mergedata$subject <- subject[,mergedata$subject, 2]
mergedata$subject


# 4. Appropriately labels the data set with descriptive activity names.

names(mergedata)<-gsub("^t", "Time", names(mergedata))
names(mergedata)<-gsub("^f", "Frequency", names(mergedata))
names(mergedata)<-gsub("Acc", "Accelerometer", names(mergedata))
names(mergedata)<-gsub("Gyro", "Gyroscope", names(mergedata))
names(mergedata)<-gsub("BodyBody", "Body", names(mergedata))
names(mergedata)<-gsub("Mag", "Magnitude", names(mergedata))

# 5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 

sub <- aggregate(. ~subject + activity, mergedata, mean)
sub <- sub[order(sub$subject,sub$activity),]
write.table(sub, file = "tidydata.txt", row.names = FALSE)

