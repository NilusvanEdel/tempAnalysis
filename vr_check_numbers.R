# this script simply prints out a contingency table showing the number
# of useable separated by group


# child
child.data <- read.csv("vr_data/childrenCSV.csv")
# rename gender variable
colnames(child.data)[2] <- "gender"
# rename driver variable
colnames(child.data)[3] <- "motorist"
# rename levels for driver
child.data$motorist <- factor(child.data$motorist,
                            levels = c("False", "True"),
                            labels = c("human", "self-driving"))
# rename levels for gender
child.data$gender <- factor(child.data$gender,
                            levels = c("False", "True"),
                            labels = c("female", "male"))
# create subsets that only include those that passed sanity
child.sub <- subset(child.data, child.data$passedSanCheck == "True")
child.sub$participant.ID <- factor(child.sub$participant.ID)
# create contingency table
contingency.xtab <- xtabs(~perspective + motorist + gender, data = child.sub)/2
print(contingency.xtab)
