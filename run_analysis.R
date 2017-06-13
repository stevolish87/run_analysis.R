# Load appropriate R package 
library(reshape2)

# Loads the various datasets into R
subtest <- read.table("C:/Users/S0303025/Documents/R/test/subject_test.txt")
xtest<- read.table("C:/Users/S0303025/Documents/R/test/X_test.txt")
ytest <- read.table("C:/Users/S0303025/Documents/R/test/y_test.txt")

subtrain <- read.table("C:/Users/S0303025/Documents/R/train/subject_train.txt")
xtrain <- read.table("C:/Users/S0303025/Documents/R/train/X_train.txt")
ytrain <- read.table("C:/Users/S0303025/Documents/R/train/y_train.txt")

features <- read.table("C:/Users/S0303025/Documents/R/features.txt")
activities <- read.table("C:/Users/S0303025/Documents/R/activity_labels.txt")

# Merge the test and train subject datasets into one dataset called subjectbind
subjectbind <- rbind(subtest, subtrain)
colnames(subjectbind) <- "subject"

# Merge the test and train labels and saved to dataset called label
label <- rbind(ytest, ytrain)
# Apply appropriate headings
label <- merge(label, activities, by=1)[,2]

# Merge the test and train main dataset
movedata <- rbind(xtest, xtrain)
# Apply appropriate headings
colnames(movedata) <- features[, 2]

# Merge all three datasets into one set called alldata
alldata <- cbind(subjectbind, label, movedata)

#Provide more descriptive column names to make the data more tidy.
names(alldata)<-gsub("^t","Time ",names(alldata)) 
names(alldata)<-gsub("^f","Frequency ",names(alldata)) 
names(alldata)<-gsub("Acc","Accelerometer ",names(alldata)) 
names(alldata)<-gsub("Gyro","Gyroscope ",names(alldata)) 
names(alldata)<-gsub("BodyBody","Body",names(alldata)) 
names(alldata)<-gsub("Body","Body ",names(alldata)) 
names(alldata)<-gsub("Gravity","Gravity ",names(alldata)) 
names(alldata)<-gsub("Mag","Magnitude ",names(alldata)) 
names(alldata)<-gsub("Jerk","Jerk ",names(alldata)) 
names(alldata)<-gsub("-mean()","Mean ",names(alldata)) 
names(alldata)<-gsub("-std()","Standard Deviation ",names(alldata))

# Create a subset of the large data set that only includes the mean and std variables
# Search for mean and std dev columns
searchresults <- grep("Mean|Standard Deviation", colnames(alldata))
# Return the subset containing the appropriate columns that contained mean and std dev
data_mean_std <- alldata[,c(1,2,searchresults)]



# Compute the means, grouped by subject/label
computations = melt(data_mean_std, id.var = c("subject", "label"))
meanstable = dcast(computations , subject + label ~ variable, mean)


# Save the resulting dataset to a file path
write.table(meanstable, file="C:/Users/S0303025/Documents/R/data/tidy_data.txt")

# Output final dataset
meanstable
