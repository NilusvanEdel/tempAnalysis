library(lme4)
library(ggplot2)
# read the dataframes
child.data <- read.csv("data/childrenCSV.csv")

carsac.data <- read.csv("data/selfSacCSV.csv")

sidewalk.data <- read.csv("data/sidewalkCSV.csv")

# only include those that passed sanity
child.data <- subset(child.data, passedSanCheck == "True")
carsac.data <- subset(carsac.data, passedSanCheck == "True")
sidewalk.data <- subset(sidewalk.data, passedSanCheck == "True")


# run the GLMMs
child.glmm <- glmer(Decision == "hitChildren" ~ perspective * av.Car +
                        (1|participant.ID) + male, family = "binomial", data=child.data)

carsac.glmm <- glmer(Decision == "selfSacrifice" ~ perspective *
                         av.Car + (1|participant.ID) + male, family = "binomial", data=carsac.data)

sidewalk.glmm <- glmer(Decision == "hitSidewalk" ~ perspective * av.Car +
                           (1|participant.ID) + male, family = "binomial",
                       data=sidewalk.data)

# plot the proportions
child.plot <- ggplot(child.data,aes(x = av.Car,fill = Decision)) +
    geom_bar(position = "fill") + facet_grid (.~perspective) +
    xlab("Driver, Perspective") + ylab("Proportion of responses")

carsac.plot <- ggplot(carsac.data,aes(x = av.Car,fill = Decision)) +
    geom_bar(position = "fill") + facet_grid (.~perspective) +
    xlab("Driver, Perspective") + ylab("Proportion of responses")

sidewalk.plot <-
    ggplot(sidewalk.data,aes(x = av.Car,fill = Decision)) +
    geom_bar(position = "fill") + facet_grid (.~perspective) +
    xlab("Driver, Perspective") + ylab("Proportion of responses")
