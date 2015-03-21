
#http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones 

#Here are the data for the project: 

#https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 

#You should create one R script called run_analysis.R that does the following. 
#1 Merges the training and the test sets to create one data set.
#2 Extracts only the measurements on the mean and standard deviation for each measurement. 
#3 Uses descriptive activity names to name the activities in the data set
#4 Appropriately labels the data set with descriptive variable names. 
#5 From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.


#setwd("C:\\Users\\Vu\\Downloads\\Programs")
if(!file.exists("data")){
	dir.create("data")
}

# Download file
setInternet2(use = TRUE)
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl, destfile = ".\\data\\activityRecognition.zip", method = "auto")

# List all files names inside of a .zip file;
fileList <- as.character(unzip(".\\data\\activityRecognition.zip", list = TRUE)$Name)
fileList

#1 Subjects
testSubjects <- read.table(unz(".\\data\\activityRecognition.zip", fileList[16]))
trainSubjects <- read.table(unz(".\\data\\activityRecognition.zip", fileList[30]))

Subjects<- rbind(testSubjects,trainSubjects)
write.table(Subjects, file = ".\\data\\subject.txt",row.names = FALSE,col.names = FALSE)

#1 Labels
testLabels <- read.table(unz(".\\data\\activityRecognition.zip", fileList[18]))
trainLabels <- read.table(unz(".\\data\\activityRecognition.zip", fileList[32]))
dim(trainLabels)
Labels <- rbind(testLabels,trainLabels)
dim(Labels)
write.table(Labels, file = ".\\data\\y.txt",row.names = FALSE,col.names = FALSE)
#1 SET
testSets <- read.table(unz(".\\data\\activityRecognition.zip", fileList[17])) 
trainSets <- read.table(unz(".\\data\\activityRecognition.zip", fileList[31]))
dim(trainSets)
#Labels <- merge(testLables ,trainLables);
Sets <- rbind(testSets,trainSets)
dim(Sets)
write.table(Sets, file = ".\\data\\X.txt",row.names = FALSE,col.names = FALSE)

#2 Feature, Mean and std
Features <- read.table(unz(".\\data\\activityRecognition.zip", fileList[2]))
Features
Mean_STD <- c(1:6, 41:46, 81:86,121:126,161:166,201:202,214:215,227:228,240:241,253:254,266:271,345:350,424:429,503:504,516:517,529:530,542:543)
Features["V2"][t(Mean_STD)]
Mean_STD_Sets <- Sets[,Mean_STD]
dim(Mean_STD_Sets)
write.table(Mean_STD_Sets, file = ".\\data\\Mean_Std.txt",row.names = FALSE,col.names = FALSE)

#4 Variable name
Variables <- t(Features$V2)
head(Variables)
names(Sets) <- Variables

#3 Activity name
Activity <- read.table(unz(".\\data\\activityRecognition.zip", fileList[1]))
Activity 
#Sets$Activity <- cut(Labels$V1, breaks = Activity$V1, labels = FALSE)
Sets$Activity <- factor(Labels$V1, levels = Activity$V1, labels = Activity$V2)
head(Sets)
write.table(Sets, file = ".\\data\\Activity_named_data_sets.txt",row.names = FALSE)

#5 second tidy Data set
Sets$Subject <- factor(Subjects$V1)
library(reshape2)
meltSets <- melt(Sets,id=c("Activity","Subject"),measure.vars=Variables)
head(meltSets)
newSets <-dcast(meltSets,Activity+Subject~variable,mean)
write.table(newSets, file = ".\\data\\second_data_set.txt",row.names = FALSE)

