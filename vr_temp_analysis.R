library(lme4)
library(cowplot)
library(vcdExtra)

# read the dataframes
child.data <- read.csv("vr_data/childrenCSV.csv")

carsac.data <- read.csv("vr_data/selfSacCSV.csv")

sidewalk.data <- read.csv("vr_data/sidewalkCSV.csv")

# clean the factor labels

# rename gender variable
colnames(child.data)[2] <- "gender"
colnames(carsac.data)[2] <- "gender"
colnames(sidewalk.data)[2] <- "gender"

# rename driver variable
colnames(child.data)[3] <- "driver"
colnames(carsac.data)[3] <- "driver"
colnames(sidewalk.data)[3] <- "driver"

# rename levels for driver
child.data$driver <- factor(child.data$driver,
                            levels = c("False", "True"),
                            labels = c("Human", "AV"))


# rename levels for gender
child.data$gender <- factor(child.data$gender,
                            levels = c("False", "True"),
                            labels = c("Female", "Male"))


# rename levels for driver
carsac.data$driver <- factor(carsac.data$driver,
                             levels = c("False", "True"),
                             labels = c("Human", "AV"))

# rename levels for gender
carsac.data$gender <- factor(carsac.data$gender,
                             levels = c("False", "True"),
                             labels = c("Female", "Male"))


# rename levels for driver
sidewalk.data$driver <- factor(sidewalk.data$driver,
                               levels = c("False", "True"),
                               labels = c("Human", "AV"))


# rename levels for gender
sidewalk.data$gender <- factor(sidewalk.data$gender,
                               levels = c("False", "True"),
                               labels = c("Female", "Male"))

# create subsets that only include those that passed sanity
child.data <- subset(child.data, passedSanCheck == "True")

carsac.data <- subset(carsac.data, passedSanCheck == "True")

sidewalk.data <- subset(sidewalk.data, passedSanCheck == "True")


# run the GLMMs
child.glmm <- glmer(decision == "hitChildren" ~ perspective * driver +
                        (1 | participant.ID) + gender, family = "binomial",
                    data = child.data, control = glmerControl(optimizer = "bobyqa",  optCtrl=list(maxfun=2e5)))

carsac.glmm <- glmer(decision == "selfSacrifice" ~ perspective *
                         driver + (1 | participant.ID) + gender,
                     family = "binomial", data = carsac.data, control = glmerControl(optimizer = "bobyqa",  optCtrl=list(maxfun=2e5)))


sidewalk.glmm <- glmer(decision == "hitSidewalk" ~ perspective * driver +
                           (1 | participant.ID) + gender, family = "binomial",
                       data = sidewalk.data, control = glmerControl(optimizer = "bobyqa",  optCtrl=list(maxfun=2e5)))

# plot the proportions as mosaic plots

child.xtabs <- xtabs(~ driver + perspective + decision, data=child.data)

carsac.xtabs <- xtabs(~ driver + perspective + decision, data=carsac.data)

sidewalk.xtabs <- xtabs(~ driver + perspective + decision, data=sidewalk.data)


child.mosaic <- mosaic(child.xtabs, gp = gpar(fill = c("blue","red")))

carsac.mosaic <- mosaic(carsac.xtabs, gp = gpar(fill=c("blue","red")))

sidewalk.mosaic <- mosaic(sidewalk.xtabs, gp = gpar(fill=c("blue","red")))
