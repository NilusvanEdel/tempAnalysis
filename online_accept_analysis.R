library(lme4)
library(ggplot2)
library(plyr)

data <- read.csv("online_accept_data.csv")

data$scenario <- as.character(data$scenario)
data$scenario.1 <- as.character(data$scenario.1)
data$scenario.2 <- as.character(data$scenario.2)
data$scenario.3 <- as.character(data$scenario.3)
data$scenario.4 <- as.character(data$scenario.4)
data$scenario.5 <- as.character(data$scenario.5)
data$scenario.6 <- as.character(data$scenario.6)
data$scenario.7 <- as.character(data$scenario.7)


data$ratio <- as.character(data$ratio)
data$ratio.1 <- as.character(data$ratio.1)
data$ratio.2 <- as.character(data$ratio.2)
data$ratio.3 <- as.character(data$ratio.3)
data$ratio.4 <- as.character(data$ratio.4)
data$ratio.5 <- as.character(data$ratio.5)
data$ratio.6 <- as.character(data$ratio.6)
data$ratio.7 <- as.character(data$ratio.7)


data$first_vid <- as.character(data$first_vid)
data$first_vid.1 <- as.character(data$first_vid.1)
data$first_vid.2 <- as.character(data$first_vid.2)
data$first_vid.3 <- as.character(data$first_vid.3)
data$first_vid.4 <- as.character(data$first_vid.4)
data$first_vid.5 <- as.character(data$first_vid.5)
data$first_vid.6 <- as.character(data$first_vid.6)
data$first_vid.7 <- as.character(data$first_vid.7)
data$first_vid.8 <- as.character(data$first_vid.8)
data$first_vid.9 <- as.character(data$first_vid.9)
data$first_vid.10 <- as.character(data$first_vid.10)
data$first_vid.11 <- as.character(data$first_vid.11)
data$first_vid.12 <- as.character(data$first_vid.12)
data$first_vid.13 <- as.character(data$first_vid.13)


data$SCENARIO <- ifelse(data$scenario != "", as.character(data$scenario),
                 ifelse(data$scenario.1 != "", as.character(data$scenario.1),
                 ifelse(data$scenario.2 != "", as.character(data$scenario.2),
                 ifelse(data$scenario.3 != "", as.character(data$scenario.3),
                 ifelse(data$scenario.4 != "", as.character(data$scenario.4),
                 ifelse(data$scenario.5 != "", as.character(data$scenario.5),
                 ifelse(data$scenario.6 != "", as.character(data$scenario.6),
                 ifelse(data$scenario.7 != "", as.character(data$scenario.7),
                        NA))))))))

data$RATIO <- ifelse(data$ratio != "", as.character(data$ratio),
                 ifelse(data$ratio.1 != "", as.character(data$ratio.1),
                 ifelse(data$ratio.2 != "", as.character(data$ratio.2),
                 ifelse(data$ratio.3 != "", as.character(data$ratio.3),
                 ifelse(data$ratio.4 != "", as.character(data$ratio.4),
                 ifelse(data$ratio.5 != "", as.character(data$ratio.5),
                 ifelse(data$ratio.6 != "", as.character(data$ratio.6),
                 ifelse(data$ratio.7 != "", as.character(data$ratio.7),
                        NA))))))))

data$SCENARIO <- ifelse((data$Task_Name == "ped_main_av_sanity" |
                         data$Task_Name == "ped_main_h_sanity" |
                         data$Task_Name == "car_av_sanity" |
                         data$Task_Name == "car_h_sanity" |
                         data$Task_Name == "obs_av_sanity" |
                         data$Task_Name == "obs_h_sanity"), "sanity", data$SCENARIO)






data$FIRST_VID<- ifelse(data$first_vid != "", as.character(data$first_vid),
                 ifelse(data$first_vid.1 != "", as.character(data$first_vid.1),
                 ifelse(data$first_vid.2 != "", as.character(data$first_vid.2),
                 ifelse(data$first_vid.3 != "", as.character(data$first_vid.3),
                 ifelse(data$first_vid.4 != "", as.character(data$first_vid.4),
                 ifelse(data$first_vid.5 != "", as.character(data$first_vid.5),
                 ifelse(data$first_vid.6 != "", as.character(data$first_vid.6),
                 ifelse(data$first_vid.7 != "", as.character(data$first_vid.7),
                 ifelse(data$first_vid.8 != "", as.character(data$first_vid.8),
                 ifelse(data$first_vid.9 != "", as.character(data$first_vid.9),
                 ifelse(data$first_vid.10 != "", as.character(data$first_vid.10),
                 ifelse(data$first_vid.11 != "", as.character(data$first_vid.11),
                 ifelse(data$first_vid.12 != "", as.character(data$first_vid.12),
                 ifelse(data$first_vid.13 != "", as.character(data$first_vid.13),
                        NA))))))))))))))



data$FIRST_VID <- factor(data$FIRST_VID)
data$SCENARIO <- factor(data$SCENARIO)
data$SUBJECT <- factor(data$SUBJECT)
data$RATIO <- factor(data$RATIO)
data$response <- factor(data$response)


sanity.sub <- subset(data, SCENARIO == "sanity")

# fix NaN for swerve in AV_Car sanity:

sanity.sub$response <- as.character(sanity.sub$response)
sanity.sub$response[sanity.sub$response == "NaN"] <- "swerve"

sanity.sub$response <- factor(sanity.sub$response)



sanity.sub$FIRST_VID <- factor(sanity.sub$FIRST_VID)
sanity.sub$SCENARIO <- factor(sanity.sub$SCENARIO)
sanity.sub$SUBJECT <- factor(sanity.sub$SUBJECT)
sanity.sub$RATIO <- as.numeric(sanity.sub$RATIO)
sanity.sub$response <- factor(sanity.sub$response)
sanity.sub$PERSP <- factor(sanity.sub$PERSP)
sanity.sub$DRIVER_TYPE <- factor(sanity.sub$DRIVER_TYPE)


carped.sub <- subset(data, SCENARIO == "carsac")

carped.sub$FIRST_VID <- factor(carped.sub$FIRST_VID)
carped.sub$SCENARIO <- factor(carped.sub$SCENARIO)
carped.sub$SUBJECT <- factor(carped.sub$SUBJECT)
carped.sub$RATIO <- as.numeric(carped.sub$RATIO)
carped.sub$response <- factor(carped.sub$response)
carped.sub$PERSP <- factor(carped.sub$PERSP)
carped.sub$DRIVER_TYPE <- factor(carped.sub$DRIVER_TYPE)


carped.glm <- glmer(response ~ RATIO * PERSP * DRIVER_TYPE + FIRST_VID
                    + (1 | SUBJECT),
                     data=carped.sub, family=binomial)

carped.plot <- ggplot(carped.glm,
                      aes(as.numeric(RATIO), as.numeric(response) - 1, color=DRIVER_TYPE)) +
    stat_smooth(method="glm", se=F, method.args=list(family="binomial")) +
    geom_point(position=position_jitter(height=0.03, width=0)) +
    xlab("Lives-risked ratio") + ylab("acceptability of swerving") +
    facet_grid(. ~ PERSP)


pedped.sub <- subset(data, (SCENARIO == "sidewalk") | (SCENARIO == "road"))

pedped.sub$FIRST_VID <- factor(pedped.sub$FIRST_VID)
pedped.sub$SCENARIO <- factor(pedped.sub$SCENARIO)
pedped.sub$SUBJECT <- factor(pedped.sub$SUBJECT)
pedped.sub$RATIO <- as.numeric(pedped.sub$RATIO)
pedped.sub$response <- factor(pedped.sub$response)
pedped.sub$PERSP <- factor(pedped.sub$PERSP)
pedped.sub$DRIVER_TYPE <- factor(pedped.sub$DRIVER_TYPE)


pedped.glm <- glmer(response ~ RATIO * PERSP * DRIVER_TYPE +
                      RATIO * DRIVER_TYPE * SCENARIO + (1 + RATIO + SCENARIO | SUBJECT),
                     data=pedped.sub, family=binomial)

pedped.plot <- ggplot(pedped.glm,
                      aes(as.numeric(RATIO), as.numeric(response) - 1, color=DRIVER_TYPE, linetype=SCENARIO)) +
    stat_smooth(method="glm", se=F, method.args=list(family="binomial")) +
    geom_point(position=position_jitter(height=0.03, width=0)) +
    xlab("Lives-risked ratio") + ylab("acceptability of swerving") +
    facet_grid(. ~ PERSP)
