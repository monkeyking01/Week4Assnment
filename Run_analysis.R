

## Name: linwei


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


## Read Data
subj_test <- read.table("UCI HAR Dataset/test/subject_test.txt")
subj_train <- read.table("UCI HAR Dataset/train/subject_train.txt")
X_test <- read.table("UCI HAR Dataset/test/X_test.txt")
X_train <- read.table("UCI HAR Dataset/train/X_train.txt")
y_test <- read.table("UCI HAR Dataset/test/y_test.txt")
y_train <- read.table("UCI HAR Dataset/train/y_train.txt")

act_labels <- read.table("UCI HAR Dataset/activity_labels.txt")
features <- read.table("UCI HAR Dataset/features.txt")  


head(features,2)
# 1. Merges the training and the test sets to create one data set.
x <- rbind(X_train,X_test)
y <- rbind(y_train,y_test)
subject <- rbind(subj_train,subj_test)

colnames(x) <- t(features[2])
colnames(subject) <- 'subject'
colnames(y) <- 'activity'

mergedata <- cbind(y,subject,x)

dim(mergedata)


# 2. Extracts only the measurements on the mean and standard deviation for each measurement. 
# Create a vector of only mean and std, use the vector to subset.
meanstd <- grep("mean()|std()", features[, 2]) 

vect <- mergedata[,meanstd]

# 3. Uses descriptive activity names to name the activities in the data set
#change activity type from numeric to character, so that it can accept activity names. 
# The activity names are taken from metadata activityLabels.

vect$activity <- as.character(vect$activity)
for (i in 1:6){
  vect$activity[vect$activity == i] <- as.character(act_labels[i,2])
}


# 4. Appropriately labels the data set with descriptive activity names.
names(vect)

names(vect)<-gsub("^t", "Time", names(vect))
names(vect)<-gsub("^f", "Frequency", names(vect))
names(vect)<-gsub("Acc", "Accelerometer", names(vect))
names(vect)<-gsub("Gyro", "Gyroscope", names(vect))
names(vect)<-gsub("BodyBody", "Body", names(vect))
names(vect)<-gsub("Mag", "Magnitude", names(vect))

names(vect)

# 5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 

vect$subject <- as.factor(vect$subject)
vect <- data.table(vect)

sub <- aggregate(. ~subject + activity, vect, mean)
sub <- sub[order(sub$subject,sub$activity),]
write.table(sub, file = "subdata.txt", row.names = FALSE)
