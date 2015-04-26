
# 1 Merges the training and the test sets to create one data set

# load training dataset activity label
activity_train<-read.table("/getdata-projectfiles-UCI HAR Dataset/train/y_train.txt")
colnames(activity_train)<-"activity_label"

# load training dataset subject label
subject_train<-read.table("/getdata-projectfiles-UCI HAR Dataset/train//subject_train.txt")
colnames(subject_train)<-"subject_no"

# load training dataset feature measurement
feature_train<-read.table("/getdata-projectfiles-UCI HAR Dataset/train/X_train.txt", stringsAsFactors = F, head=F, sep="")
# load training dataset feature names
feature_names<-read.table("/getdata-projectfiles-UCI HAR Dataset/features.txt", sep="", head=F)
# assign col to feature names
colnames(feature_train)<-feature_names[,2]

# combine above dataframe into a single dataframe
trainset<-cbind(activity_train, subject_train, feature_train)

dataset<-rep("trainset", 7352)
trainset<-cbind(trainset, dataset)

# testset data
activity_test<-read.table("/getdata-projectfiles-UCI HAR Dataset/test/y_test.txt")
colnames(activity_test)<-"activity_label"
subject_test<-read.table("/getdata-projectfiles-UCI HAR Dataset/test/subject_test.txt")
colnames(subject_test)<-"subject_no"
feature_test<-read.table("/getdata-projectfiles-UCI HAR Dataset/test/X_test.txt", stringsAsFactors = F, head=F, sep="")
colnames(feature_test)<-feature_test[,2]
colnames(feature_test)<-feature_names[,2]
dataset<-rep("testset", 2947)
testset<-cbind(activity_test, subject_test, feature_test)
testset<-cbind(testset, dataset)

#merge both trainset and testset into a single dataframe
dataset<-rbind(trainset, testset)

##########################################################################################################################################################

# 2 Extracts only the measurements on the mean and standard deviation for each measurement.

filtered_features<-feature_names[grep("mean|std",feature_names[,2]),2]
filtered_dataset<-dataset[,as.character(filtered_features)]
filtered_dataset<-cbind(dataset[,1:2], filtered_dataset)

##########################################################################################################################################################

# 3 Uses descriptive activity names to name the activities in the data set

activity<-c("WALKING", "WALKING_UPSTAIRS", "WALKING_DOWNSTAIRS", "SITTING", "STANDING", "LAYING")
names(activity)<-c("1","2","3","4","5","6")
activity_name<-sapply(filtered_dataset$activity_label, function(x) activity_labels[x])
filtered_dataset<-cbind(activity_name, filtered_dataset)

##########################################################################################################################################################

# 4 Appropriately labels the data set with descriptive variable names

filtered_dataset$subject_no<-as.factor(filtered_dataset$subject_no)

# removing "()_" -  special characters in column names
tmp<-sapply(colnames(filtered_dataset)[4:82], function(x) gsub("[[:punct:]]","",x))
colnames(filtered_data)[4:82]<-tmp

##########################################################################################################################################################

# 5 From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

feature_names<-colnames(filtered_dataset)[c(1,3:82)]

tidy_dataset<-aggregate(filtered_dataset[,4] ~ filtered_dataset$activity_name + filtered_dataset$subject_no, filtered_dataset, FUN = mean)

for(i in 5:82)
{
	x<-aggregate(filtered_dataset[,i] ~ filtered_dataset$activity_name + filtered_dataset$subject_no, filtered_dataset, FUN = mean)
	tidy_dataset<-cbind(tidy_dataset, x[,3])
}

colnames(tidy_dataset)<-feature_names

write.table(tidy_dataset, "/getdata-projectfiles-UCI HAR Dataset/cleaned_data.txt", row.names=F, quote=F, sep="\t")