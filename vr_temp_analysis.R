library(lme4)
library(ggplot2)
# read the dataframes
child.data <- read.csv("data/childrenCSV.csv")

carsac.data <- read.csv("data/selfSacCSV.csv")

sidewalk.data <- read.csv("data/sidewalkCSV.csv")

# clean the factor labels

colnames(child.data)[2] <- "gender"
colnames(carsac.data)[2] <- "gender"
colnames(sidewalk.data)[2] <- "gender"

colnames(child.data)[3] <- "driver"
colnames(carsac.data)[3] <- "driver"
colnames(sidewalk.data)[3] <- "driver"

child.data$driver <- factor(child.data$driver, levels = c("False","True"),
                            labels = c("Human", "AV"))

child.data$gender <- factor(child.data$gender, levels = c("False","True"),
                            labels = c("Female", "Male"))

carsac.data$driver <- factor(carsac.data$driver, levels = c("False","True"),
                            labels = c("Human", "AV"))

carsac.data$gender <- factor(carsac.data$gender, levels = c("False","True"),
                            labels = c("Female", "Male"))


sidewalk.data$driver <- factor(sidewalk.data$driver, levels = c("False","True"),
                            labels = c("Human", "AV"))

sidewalk.data$gender <- factor(sidewalk.data$gender, levels = c("False","True"),
                            labels = c("Female", "Male"))

# only include those that passed sanity
child.data <- subset(child.data, passedSanCheck == "True")
carsac.data <- subset(carsac.data, passedSanCheck == "True")
sidewalk.data <- subset(sidewalk.data, passedSanCheck == "True")


# run the GLMMs
child.glmm <- glmer(decision == "hitChildren" ~ perspective * driver +
                        (1|participant.ID) + gender, family = "binomial", data=child.data)

carsac.glmm <- glmer(decision == "selfSacrifice" ~ perspective *
                         driver + (1|participant.ID) + gender, family = "binomial", data=carsac.data)

sidewalk.glmm <- glmer(decision == "hitSidewalk" ~ perspective * driver +
                           (1|participant.ID) + gender, family = "binomial",
                       data=sidewalk.data)

# plot the proportions
child.plot <- ggplot(child.data,aes(x = driver,fill = Decision)) +
    geom_bar(position = "fill") + facet_grid (.~perspective) +
    xlab("Driver, Perspective") + ylab("Proportion of responses")

carsac.plot <- ggplot(carsac.data,aes(x = driver,fill = Decision)) +
    geom_bar(position = "fill") + facet_grid (.~perspective) +
    xlab("Driver, Perspective") + ylab("Proportion of responses")

sidewalk.plot <-
    ggplot(sidewalk.data,aes(x = driver,fill = Decision)) +
    geom_bar(position = "fill") + facet_grid (.~perspective) +
    xlab("Driver, Perspective") + ylab("Proportion of responses")
