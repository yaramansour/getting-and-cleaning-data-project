# download the dataset
if(!file.exists("./data")){dir.create("./data")}
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile="./data/Dataset.zip")

# Unzip dataSet 
unzip(zipfile="./data/Dataset.zip",exdir="./data")

# reading training files
x_train <- read.table("./data/UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./data/UCI HAR Dataset/train/y_train.txt")
train <- read.table("./data/UCI HAR Dataset/train/subject_train.txt")

# Reading testing files:
x_test <- read.table("./data/UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./data/UCI HAR Dataset/test/y_test.txt")
test <- read.table("./data/UCI HAR Dataset/test/subject_test.txt")

# Reading features file :
features <- read.table('./data/UCI HAR Dataset/features.txt')

# Reading activity labels:
activityLabels = read.table('./data/UCI HAR Dataset/activity_labels.txt')
# assign names to the columns 

colnames(x_train) <- features[,2] 
colnames(y_train) <-"activityID"
colnames(train) <- "subjectID"

colnames(x_test) <- features[,2] 
colnames(y_test) <- "activityID"
colnames(test) <- "subjectID"

colnames(activityLabels) <- c('activityID','activityType')

# merging all sets 
merge_train <- cbind(y_train, train, x_train)
merge_test <- cbind(y_test, test, x_test)
AllInOne <- rbind(merge_train, merge_test)

colNames <- colnames(AllInOne)

#mean and standard deviation
mean_and_std <- (grepl("activityID" , colNames) | 
                   grepl("subjectID" , colNames) | 
                   grepl("mean.." , colNames) | 
                   grepl("std.." , colNames) )

setForMeanAndStd <- AllInOne[ , mean_and_std == TRUE]

setWithActivityNames <- merge(setForMeanAndStd, activityLabels,
                                               by='activityID',
                                               all.x=TRUE)

# second dataset
secTidySet <- aggregate(. ~subjectID + activityID, setWithActivityNames, mean)
secTidySet <- secTidySet[order(secTidySet$subjectID, secTidySet$activityID),]

write.table(secTidySet, "secTidySet.txt", row.name=FALSE)