library(lme4)
library(cowplot)
library(plyr)

# read the online_acceptibility data file
data <- read.csv("online_accept_data/shortenedOnlineCSV.csv")

# create subset for car-ped dilemmas
carped.sub <- subset(data, scenario == "carsac")

# ensure data is of correct type
carped.sub$first_vid <- factor(carped.sub$first_vid)
carped.sub$scenario <- factor(carped.sub$scenario)
carped.sub$Subject_Id<- factor(carped.sub$Subject_Id)
carped.sub$ratio <- as.numeric(carped.sub$ratio) - 1
carped.sub$response <- factor(carped.sub$response)
carped.sub$PERSP <- factor(carped.sub$PERSP)
carped.sub$DRIVER_TYPE <- factor(carped.sub$DRIVER_TYPE)


# perform GLMM for car-ped dilemmas

carped.glmm <- glmer(response ~ ratio * PERSP * DRIVER_TYPE + (1 | Subject_Id),
                     data=carped.sub, family=binomial, control = glmerControl(optimizer = "bobyqa", optCtrl=list(maxfun=2e5)))

# plot GLMM

carped.plot <- ggplot(carped.glmm,
                      aes(as.numeric(ratio), as.numeric(response) - 1, color=PERSP, fill=PERSP)) +
    stat_smooth(method="glm", se=F, method.args=list(family="binomial")) +
    #geom_point(position=position_jitter(height=0.03, width=0)) +
    xlab("Lives-risked ratio") + ylab("P(Choosing swerve as more acceptable)") +
    facet_grid(. ~ DRIVER_TYPE) + theme_cowplot(font_size = 11)


# plot each subjects responses

carped_subj.plot <- ggplot(carped.glmm,
                      aes(as.numeric(ratio), as.numeric(response) - 1, color=PERSP, linetype=DRIVER_TYPE)) +
  #  stat_smooth(method="glm", se=F, method.args=list(family="binomial")) +
    geom_point(position = position_jitter(height=0.03, width=0)) +
    geom_line() +
    xlab("Lives-risked ratio") + ylab("Response") +
    facet_wrap(PERSP ~ Subject_Id) + theme_cowplot(font_size = 8)

# create subset for ped-ped dilemmas

pedped.sub <- subset(data, (scenario == "sidewalk") | (scenario == "road"))
# ensure data type is correct

pedped.sub$first_vid <- factor(pedped.sub$first_vid)
pedped.sub$scenario <- factor(pedped.sub$scenario)
pedped.sub$Subject_Id <- factor(pedped.sub$Subject_Id)
pedped.sub$ratio <- as.numeric(pedped.sub$ratio) - 1
pedped.sub$response <- factor(pedped.sub$response)
pedped.sub$PERSP <- factor(pedped.sub$PERSP)
pedped.sub$DRIVER_TYPE <- factor(pedped.sub$DRIVER_TYPE)


# perform GLMM for ped-ped dilemmas

pedped.glmm <- glmer(response ~ ratio * PERSP * DRIVER_TYPE +
                      ratio * DRIVER_TYPE * scenario + (1 + ratio + scenario | Subject_Id),
                     data=pedped.sub, family=binomial, control = glmerControl(optimizer = "nloptwrap",  optCtrl=list(maxfun=2e5)))

# plot GLMM

pedped.plot <- ggplot(pedped.glmm,
                      aes(ratio, as.numeric(response) - 1, color=PERSP, fill=PERSP)) +
    stat_smooth(method="glm", se=F, method.args=list(family="binomial")) +
   # geom_point(position=position_jitter(height=0.03, width=0)) +
    xlab("Lives-risked ratio") + ylab("P(Choosing swerve as more acceptable)") +
    facet_grid(scenario ~ DRIVER_TYPE) + theme_cowplot(font_size = 12)

# plot individual responses

pedped_subj.plot <- ggplot(pedped.glmm,
                      aes(ratio, as.numeric(response) - 1, color=PERSP:DRIVER_TYPE, linetype=scenario)) +
    stat_smooth(method="glm", se=F, method.args=list(family="binomial")) +
   # geom_point(position=position_jitter(height=0.03, width=0)) +
    xlab("Lives-risked ratio") + ylab("Response")  +
    facet_wrap(PERSP ~ Subject_Id) + theme_cowplot(font_size = 8)
