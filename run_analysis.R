library(dplyr)
library(tidyr)

# Check to see if the test and train dirs are present
if(!(dir.exists("./test") & dir.exists("./train"))) {stop("test and train dirs not found")}

# Reading the activities list from the file
# This creates the mapping of Activity ID to Activity
activity <- read.table("./activity_labels.txt")
names(activity) <- c("activity_id", "activity")

# Reading the list of features/measurements
features <- read.table("./features.txt")
features <- features$V2

# Filtering out only the variables that measure mean or std values
# But not MeanFreq - only ones that match mean() and std() in the title
meanstdfeatures<-features[grepl(".*(mean|std)..(-.)?$", features)]

# Reading the TEST values: subjects, X (features) and y (activities by id) values
subtest <- read.table("./test/subject_test.txt")
Xtest <- read.table("./test/X_test.txt")
ytest <- read.table("./test/y_test.txt")

# Renaming the variables based on their data
names(subtest) <- c("subject")
names(ytest) <- "activity_id"
names(Xtest) <- features

# Matching only the columns that contain "mean" or "std" 
# (but not MeanFreq)
reducedXtest <- Xtest[,match(meanstdfeatures, names(Xtest))]

# Putting together all the variables in TEST
masterTest <- cbind(subtest, reducedXtest, ytest)

# Reading the TRAIN values: subjects, X (features) and y (activities by id) values
subtrain <- read.table("./train/subject_train.txt")
Xtrain <- read.table("./train/X_train.txt")
ytrain <- read.table("./train/y_train.txt")

# Renaming the variables based on their data
names(subtrain) <- c("subject")
names(ytrain) <- "activity_id"
names(Xtrain) <- features

# Matching only the columns that contain "mean" or "std" 
# (but not MeanFreq)
reducedXtrain <- Xtrain[,match(meanstdfeatures, names(Xtrain))]

# Putting together all the variables in TRAIN
masterTrain <- cbind(subtrain, reducedXtrain, ytrain)

# Putting together TEST and TRAIN into the MASTER table
master <- rbind(masterTest, masterTrain)

# Merging the activity table and the MASTER table
master <- master  %>% merge(activity, by = "activity_id")

#Refactoring the activities based on the mapping in the Activities table
master$activity <- factor(master$activity, levels = c("WALKING", "WALKING_UPSTAIRS", "WALKING_DOWNSTAIRS", "SITTING", "STANDING", "LAYING"))

# Grouping the table by activity and subject
master <- group_by(master, activity, subject)

# Reordering the table to bring Activity, Subject as the first two columns
# Then adding the remaining columns (3 - 68)
# This removes the redundant column 1 of activity IDs
master <- master %>% select(c(69, 2), 3:68)

# Renaming some variables to make them more explicit
newnames <- gsub("^t", "timeOf", names(master))
newnames <- gsub("^f", "frequencyOf", newnames)
newnames <- gsub("Acc", "Acceleration", newnames)

# Setting the new names in the MASTER table
names(master) <- newnames

# Summarizing the MASTER table with Average of all variables
sumMaster <- summarize_each(master, "mean")

# 1. Gathering the columns based on the measurement
# 2. Then separating them into measurement, aggregateType (mean/std) and axis (X/Y/ZNone)
# 3. Finally, spreading out based on aggregate type (mean/std)
sumMaster <- sumMaster %>% 
            gather(variable, value, -(1:2)) %>%
              separate(col = variable, into = c("feature", "aggType", "axis")) %>%
                spread(aggType, value)

# Replacing all missing axes with None string
sumMaster$axis <- ifelse(sumMaster$axis == "", "None", sumMaster$axis)

# Renaming mean and std columns to reflect the fact that they are average values
names(sumMaster)[names(sumMaster) == "mean"] <- "averageOfMean"
names(sumMaster)[names(sumMaster) == "std"] <- "averageOfStd"

write.table(sumMaster, "./sumMaster.txt", row.names = FALSE)