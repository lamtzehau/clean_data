All the clean-up steps can be performed using the course_project_analysis.r

1)The script first combined all the measurements for 561 variables(features) for all across and subjects from both test and train sets to create a single dataframe
2)Variables names (column names) follow the naming convention found in the features_info.txt
3)Only extract variables representing the mean (mean) and standard deviation (std) meansurement into a single dataframe
4)Input another additional column (activity_name)  describing the activity (instead of code number) for the measurments
5)Edit column names by removing special characters
6)Summrize the data with the average of each variable for each activity and each subject 