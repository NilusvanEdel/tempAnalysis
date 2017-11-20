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
