# read activity labels

activityLabels <- read.table("UCI HAR Dataset/activity_labels.txt")
activityLabels[,2] <- as.character(activityLabels[,2])

#read features

features <- read.table("UCI HAR Dataset/features.txt")
features[,2] <- as.character(features[,2])

# Extract mean and standard deviation then appropriatly rename 

requiredData <- grep(".*mean.*|.*std.*", features[,2])
requiredData.names <- features[requiredData,2]
requiredData.names = gsub('-mean', 'Mean', requiredData.names)
requiredData.names = gsub('-std', 'Std', requiredData.names)
requiredData.names <- gsub('[-()]', '', requiredData.names)

# Load and read the train datasets then combine training data

train <- read.table("UCI HAR Dataset/train/X_train.txt")[requiredData]
trainActivities <- read.table("UCI HAR Dataset/train/Y_train.txt")
trainSubjects <- read.table("UCI HAR Dataset/train/subject_train.txt")
train <- cbind(trainSubjects, trainActivities, train)

# Load and read the test datasets then combine training data

test <- read.table("UCI HAR Dataset/test/X_test.txt")[requiredData]
testActivities <- read.table("UCI HAR Dataset/test/Y_test.txt")
testSubjects <- read.table("UCI HAR Dataset/test/subject_test.txt")
test <- cbind(testSubjects, testActivities, test)

# Merge the train and test datasets 

mergedData <- rbind(train, test)

#add labels

colnames(mergedData) <- c("subject", "activity", requiredData.names)

# Change activities  and subjects into factors

mergedData$activity <- factor(mergedData$activity, levels = activityLabels[,1], labels = activityLabels[,2])
mergedData$subject <- as.factor(mergedData$subject)
mergedData.melted <- melt(mergedData, id = c("subject", "activity"))
mergedData.mean <- dcast(mergedData.melted, subject + activity ~ variable, mean)

# write a tidy data set called tidy.txt

write.csv(mergedData.mean, "tidy.csv", row.names = FALSE, quote = FALSE)
