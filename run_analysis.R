library(dplyr)

#1. Merges the training and the test sets to create one data set.
subject_train <- read.table("train/subject_train.txt")
X_train <- read.table("train/X_train.txt")
y_train <- read.table("train/y_train.txt")

subject_test <- read.table("test/subject_test.txt")
X_test <- read.table("test/X_test.txt")
y_test <- read.table("test/y_test.txt")

# merge datasets

subject_dataset <- rbind(subject_train, subject_test)

x_dataset <- rbind(X_train, X_test)

y_dataset <- rbind(y_train, y_test)

#2. Extracts only the measurements on the mean and standard deviation for each measurement.

# features

features <- read.table("features.txt")

# get mean & std dev
wantedFeatures <- grep("-(mean|std)\\(\\)", features[, 2])

# column & names
x_dataset <- x_dataset[, wantedFeatures]
names(x_dataset) <- features[wantedFeatures, 2]

#3. Uses descriptive activity names to name the activities in the data set

# activity names

activityNames <- read.table("activity_labels.txt")

# update activity names & column

y_dataset[, 1] <- activityNames[y_data[, 1], 2]
names(y_dataset) <- "Activity"

#4. Appropriately labels the data set with descriptive variable names.

#merge and title for naming

names(subject_dataset) <- "Subject"

masterData <- cbind(x_dataset, y_dataset, subject_dataset)

# update names- descriptions in README
# Triaxial acceleration from the accelerometer (total acceleration) 
# the estimated body acceleration.
# Triaxial Angular velocity from the gyroscope. 
# time and frequency domain variables. 

names(masterData) <- make.names(names(masterData))
names(masterData) <- gsub('^t',"timeDomain.",names(masterData))
names(masterData) <- gsub('^f',"frequencyDomain.",names(masterData))
names(masterData) <- gsub('Acc',"Acceleration",names(masterData))
names(masterData) <- gsub('Gyro',"Velocity",names(masterData))
names(masterData) <- gsub('Mag',"Magnitude",names(masterData))
names(masterData) <- gsub('\\.std',".standardDev",names(masterData))

#5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

tidyData<-aggregate(. ~Subject + Activity, masterData, mean)
tidyData<-tidyData[order(tidyData$Subject,tidyData$Activity),]
write.table(tidyData, file = "tidydata.txt",row.name=FALSE)


