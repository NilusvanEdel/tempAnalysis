## how we want the main data to look: three separate data frames, one
## for each dilemma-type (car_ped, child_adult, sidewalk_road) each
## with the following variables:

## Independent Variables:

## "subj" as factor (the participant ID)

## "sanity" as factor:
## ("pass", "fail")

## "driver" as factor (the type of car):
## ("human", "AV")

## "persp" as factor (the perspective):
## ("car", "obs", "ped") for car_ped
## ("car", "obs", "ped_wchild", "ped_adult") for child_adult
## ("car", "obs", "ped_side", "ped_road") for sidewalk_road


## Dependent Variables:

## "accept" as factor (which is more acceptable to hit):
##("ped", "car"), ("adult", "child"), ("road", "sidewalk")

## "conf" as numeric (how confident was the person): (0...100)



## we then fit three GLMMs (aka logit mixed models) with random
## intercept for each subject (see Moen2016)
## TODO: check which optimizer to use



library(lme4)

car_ped.glmm <- glmer(accept == "car" ~ persp +  driver + persp:driver  # fixed effects
                      + (1 | subj),  # random effect
                      data = car_ped.data, family = binomial)

child_adult.glmm <- glmer(accept == "child" ~ persp + driver + persp:driver  # fixed effects
                          + (1 | subj), # random effect
                          data = child_adult.data, family = binomial)

road_sidewalk.glmm <- glmer(accept == "sidewalk" ~ persp + driver + persp:driver  #fixed effects
                            + (1 | subj),  # random effect
                            data = road_sidewalk.data, family = binomial)


data <- read.csv("dataframe_data_so_far.csv")

data$Scenario <- 0


# figures out which scenario is which
data <- transform(data, Scenario =
                            ifelse(Number.of.Adults.2 == 0,"car-sac",
                                   (ifelse(Number.of.Children > 0, "child",
                                   (ifelse(Number.of.Adults.2 == 2*Number.of.Adults.1, "sidewalk",
                                   (ifelse(Number.of.Adults.1 == 0, "sanity",
                                   (ifelse(Number.of.Adults.2 == 5, "practice",""))))))))))



data$Participant.ID <- as.factor(data$Participant.ID)
data$Scenario <- as.factor(data$Scenario)
data$AV.Car <- as.factor(data$AV.Car)
data$Perspective <- as.factor(data$Perspective)

carsac.sub <- subset(data, Scenario == "car-sac")


conf.lm <- glmer(Selected.Option == "Rechts" ~ Perspective * AV.Car + (1|Participant.ID), data=carsac.sub, family="binomial")
