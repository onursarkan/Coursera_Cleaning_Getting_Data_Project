# Getting and cleaning data: Course Project

# Step 1: Training and the test sets are merged to create one data set.
x_train <- read.table("train/X_train.txt")
x_test <- read.table("test/X_test.txt")
x_merged <- rbind(x_train, x_test)

y_train <- read.table("train/y_train.txt")
y_test <- read.table("test/y_test.txt")
y_merged <- rbind(y_train, y_test)

subject_train <- read.table("train/subject_train.txt")
subject_test <- read.table("test/subject_test.txt")
subject_merged <- rbind(subject_train, subject_test)


# Step 2: Extracts only the measurements on the mean and standard deviation for each measurement. 
features <- read.table("features.txt")
mean_and_std_features <- grep("-(mean|std)\\(\\)", features[, 2])
x_merged <- x_merged[, mean_and_std_features]
names(x_merged) <- features[mean_and_std_features, 2]

# Step 3: Uses descriptive activity names to name the activities in the data set
activities <- read.table("activity_labels.txt")
y_merged[, 1] <- activities[y_merged[, 1], 2]
names(y_merged) <- "activity"

# Step 4: Appropriately labels the data set with descriptive variable names. 
names(subject_merged) <- "subject"
final_dataset <- cbind(x_merged, y_merged, subject_merged)

# Step 5: From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
library(plyr)
avg_final <- ddply(final_dataset, .(subject, activity), function(x) colMeans(x[, 1:66]))
write.table(avg_final, "avg_final.txt", row.name=FALSE)

