
setwd("/Users/harish/work/coursera/datascience/UCI HAR Dataset")
  
# Check to see if the test and train dirs are present
if(!(dir.exists("./test") & dir.exists("./train"))) {stop("test and train dirs not found")}

activity <- read.table("./activity_labels.txt")
names(activity) <- c("activity_id", "activity")
features <- read.table("./features.txt")
features <- features$V2
meanstdfeatures<-features[grepl(".*(mean|std)..(-.)?$", features)]

subtest <- read.table("./test/subject_test.txt")
Xtest <- read.table("./test/X_test.txt")
ytest <- read.table("./test/y_test.txt")

names(subtest) <- c("subject")
names(ytest) <- "activity_id"
names(Xtest) <- features

redXtest <- Xtest[,match(meanstdfeatures, names(Xtest))]

tubtest <- cbind(subtest, redXtest, ytest)

## Train data
subtrain <- read.table("./train/subject_train.txt")
Xtrain <- read.table("./train/X_train.txt")
ytrain <- read.table("./train/y_train.txt")

names(subtrain) <- c("subject")
names(ytrain) <- "activity_id"
names(Xtrain) <- features

redXtrain <- Xtrain[,match(meanstdfeatures, names(Xtrain))]

tubtrain <- cbind(subtrain, redXtrain, ytrain)

tub <- rbind(tubtest, tubtrain)

tub <- tub  %>% merge(activity, by = "activity_id")
tub$activity <- factor(tub$activity, levels = c("WALKING", "WALKING_UPSTAIRS", "WALKING_DOWNSTAIRS", "SITTING", "STANDING", "LAYING"))
tub <- group_by(tub, activity, subject) 

#summarize(function(x) {mean(x)})

