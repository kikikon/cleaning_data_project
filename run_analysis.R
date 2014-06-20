#in case the dataset is not yet available:
#url  <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
#download.file(url, destfile="dataset.zip", method="curl")
#unzip("dataset.zip")

features <- scan("UCI HAR Dataset/features.txt", what="", sep="\n")
activity_labels  <- read.delim("UCI HAR Dataset/activity_labels.txt", header=FALSE, sep = "")

#reading in and cleaning the training dataset
train_set  <- read.delim("UCI HAR Dataset/train/X_train.txt", header=FALSE, sep = "\t")
train_labels  <- read.delim("UCI HAR Dataset/train/y_train.txt", header=FALSE)
train_subjects  <- read.delim("UCI HAR Dataset/train/subject_train.txt", header=FALSE)

colnames(train_set)  <- "train_set"
colnames(train_labels)  <- "activity"
colnames(train_subjects)  <- "subject"
colnames(activity_labels)  <- c("code", "activity")

train_subjects$data_type  <- "train"

#splitting the train set into columns with one value a column
columns  <- train_set$train_set
columns  <- as.character(columns)
#to solve the problem that in fornt of negative numbers there is minus, while sopositive ones me have just a space at the beginning
columns  <- gsub("  ", " +", columns)
columns  <- strsplit(columns, " ")
df_train <- data.frame(matrix(unlist(columns), nrow=7352, byrow=T))
#to get rid of the first empty column
df_train <- subset(df_train, select = -1 )
#change the columns names to correspond to the features
colnames(df_train)  <- features

#select only the columns with means/stds:
means  <- grep("mean", colnames(df_train), perl=TRUE, value=FALSE)
stds  <- grep("std", colnames(df_train), perl=TRUE, value=FALSE)
selected = sort(c(means,stds))
df_train  <- subset(df_train, select = selected)
#convert the columns back to a float
df_train  <-  data.frame(lapply(df_train, as.character), stringsAsFactors=FALSE)
df_train  <-  data.frame(lapply(df_train, as.numeric))

#merging the three dataframes
train_complete  <- cbind(train_subjects, train_labels,df_train)

#reading in and cleaning the testing dataset
test_set  <- read.delim("UCI HAR Dataset/test/X_test.txt", header=FALSE, sep = "\t")
test_labels  <- read.delim("UCI HAR Dataset/test/y_test.txt", header=FALSE)
test_subjects  <- read.delim("UCI HAR Dataset/test/subject_test.txt", header=FALSE)

colnames(test_set)  <- "test_set"
colnames(test_labels)  <- "activity"
colnames(test_subjects)  <- "subject"
colnames(activity_labels)  <- c("code", "activity")

test_subjects$data_type  <- "test"

#splitting the test set into columns with one value a column
columns  <- test_set$test_set
columns  <- as.character(columns)
#to solve the problem that in fornt of negative numbers there is minus, while sopositive ones me have just a space at the beginning
columns  <- gsub("  ", " +", columns)
columns  <- strsplit(columns, " ")
df_test <- data.frame(matrix(unlist(columns), nrow=2947, byrow=T))
#to get rid of the first empty column
df_test <- subset(df_test, select = -1 )
#change the columns names to correspond to the features
colnames(df_test)  <- features

#select only the columns with means/stds:
means  <- grep("mean", colnames(df_test), perl=TRUE, value=FALSE)
stds  <- grep("std", colnames(df_test), perl=TRUE, value=FALSE)
selected = sort(c(means,stds))
df_test  <- subset(df_test, select = selected)
#convert the columns back to a float
df_test  <-  data.frame(lapply(df_test, as.character), stringsAsFactors=FALSE)
df_test  <-  data.frame(lapply(df_test, as.numeric))

#merging the three test dataframes
test_complete  <- cbind(test_subjects, test_labels,df_test)

#merging test and training dataframes
complete  <- rbind(train_complete, test_complete)
#changing the activity codes to their names
complete$activity  <- ifelse(complete$activity==1,"WALKING", 
                              ifelse(complete$activity==2, "WALKING_UPSTAIRS",
                                ifelse(complete$activity==3, "WALKING_DOWNSTAIRS", 
                                  ifelse(complete$activity==4, "SITTING",
                                    ifelse(complete$activity == 5, "STANDING", "LAYING")))))
complete$activity  <- as.factor(complete$activity)
complete$subject  <- as.factor(complete$subject)


complete_tidy  <- data.frame()
for (subject in levels(complete$subject)) {
  for (activity in levels(complete$activity)) {
    subsetted  <- subset(complete, complete$subject == subject & complete$activity == activity)
    subsetted  <- data.frame(lapply(subset(subsetted, select = -c(1,2,3)), mean))
    subsetted  <- cbind(subject, activity, subsetted)
    complete_tidy  <- rbind(complete_tidy, subsetted)
  }
}

#saving the tidy data set into a csv file
write.table(complete, "samsung-tidy.txt", row.names=FALSE, sep = ",")



