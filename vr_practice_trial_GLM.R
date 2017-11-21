library(ggplot2)

# This script performs and plots a GLM on the practice trial (5 vs 2)

data <- read.csv("dataframe_data_so_far.csv")

data$Hit_Large <- 0
data$Number.of.Children <- as.numeric(data$Number.of.Children)
data$Number.of.Adults.1 <- as.numeric(data$Number.of.Adults.1)
data$Number.of.Adults.2 <- as.numeric(data$Number.of.Adults.2)
data$Participant.ID <- as.factor(data$Participant.ID)
data$AV.Car <- as.factor(data$AV.Car)
data$Perspective <- as.factor(data$Perspective)

# figures out which scenario is which
data$Scenario <- ifelse(data$Number.of.Adults.2 == 0,"car-sac",
                                   (ifelse(data$Number.of.Children > 0, "child",
                                   (ifelse(data$Number.of.Adults.2 == 2*data$Number.of.Adults.1, "sidewalk",
                                   (ifelse(data$Number.of.Adults.1 == 0, "sanity",
                                   (ifelse(data$Number.of.Adults.2 == 5, "practice","0")))))))))

data$Hit_Large <- (data$Selected.Option == "Rechts" & data$
                   Left.First. == "True") | (data$Selected.Option == "Links" & data$Left.First. == "False")

practice.sub <- subset(data, Scenario == "practice")


practice.glm <- glm(Hit_Large ~ Perspective * AV.Car,
                    data=practice.sub, family="binomial")

practice.plot <- ggplot(practice.sub,aes(x = AV.Car,fill = Hit_Large)) +
    geom_bar(position = "fill") +
    facet_grid (.~Perspective) +
    xlab("Driver, Perspective") + ylab("Proportion of responses")


summary(practice.glm)
practice.plot
