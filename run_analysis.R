# R script run_analysis.R that does the following: 
# Merges the training and the test sets to create one data set.
# Extracts only the measurements on the mean and standard deviation for each measurement. 
# Uses descriptive activity names to name the activities in the data set
# Appropriately labels the data set with descriptive variable names. 
# From the data set in step 4, creates a second, independent tidy data set with the 
#      average of each variable for each activity and each subject.

library(data.table)


# Appropriately labels the data set using 'features.txt': List of all features.
features <- read.table("./UCI HAR Dataset/features.txt",header=FALSE,colClasses="character")
# names of subset columns required
subset_cols <- grep(".*mean\\(\\)|.*std\\(\\)", features$V2)


#         Read data

# 'test/X_test.txt': Test set.
XtestData <- read.table("./UCI HAR Dataset/test/X_test.txt",header=FALSE)
colnames(XtestData)<-features$V2
#subset of columns with mean , std
XtestData <- XtestData[,subset_cols]

# 'test/y_test.txt': Test labels.
YtestData <- read.table("./UCI HAR Dataset/test/y_test.txt",header=FALSE)

# 'train/X_train.txt': Training set.
XtrainData <- read.table("./UCI HAR Dataset/train/X_train.txt",header=FALSE)
colnames(XtrainData)<-features$V2
#subset of columns with mean , std
XtrainData <- XtrainData[,subset_cols]

# 'train/y_train.txt': Training labels.
YtrainData <- read.table("./UCI HAR Dataset/train/y_train.txt",header=FALSE)

# 'activity_labels.txt': Links the class labels with their activity name.
activities <- read.table("./UCI HAR Dataset/activity_labels.txt",header=FALSE,colClasses="character")
# Use the descriptive activity names in the test & train labels (Y datasets) data
YtestData$V1 <- factor(YtestData$V1,levels=activities$V1,labels=activities$V2)
YtrainData$V1 <- factor(YtrainData$V1,levels=activities$V1,labels=activities$V2)

# 'train|test/subject_train.txt': Each row identifies the subject who performed the activity
#  for each window sample. Its range is from 1 to 30. 
test_subject <- read.table("./UCI HAR Dataset/test/subject_test.txt",header=FALSE)
train_subject <- read.table("./UCI HAR Dataset/train/subject_train.txt",header=FALSE)

colnames(YtestData)<-c("Activity")
colnames(YtrainData)<-c("Activity")
colnames(test_subject)<-c("Subject")
colnames(train_subject)<-c("Subject")

# Merge test and train sets with activities
XtestData<-cbind(XtestData,YtestData)
XtestData<-cbind(XtestData,test_subject)
XtrainData<-cbind(XtrainData,YtrainData)
XtrainData<-cbind(XtrainData,train_subject)
pData<-rbind(XtestData,XtrainData)

# Creates an independent tidy data set with the average of each variable 
# for each activity and subject.
mydt <- data.table(pData)
tidyData<-mydt[,lapply(.SD,mean),by="Activity,Subject"]
write.table(tidyData,file="tidy.txt",sep="\t",row.names = FALSE)