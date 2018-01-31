our_seed <- 123
set.seed(our_seed)

require(knitr)
require(lme4)
require(afex)
library(memisc)
require(cowplot)
require(DHARMa)
require(xtable)
require(rockchalk)
require(tikzDevice)
require(parallel)
require(fifer)
require(multcomp)
require(vcdExtra)
require(catspec)

carsac.data <- read.csv("vr_data/selfSacCSV.csv")


# rename gender variable
colnames(carsac.data)[2] <- "gender"
# rename driver variable
colnames(carsac.data)[3] <- "motorist"
# rename levels for driver
carsac.data$motorist <- factor(carsac.data$motorist,
                            levels = c("False", "True"),
                            labels = c("human", "self-driving"))
carsac.data$participant.ID <- factor(carsac.data$participant.ID)
# rename levels for gender
carsac.data$gender <- factor(carsac.data$gender,
                            levels = c("False", "True"),
                            labels = c("female", "male"))

# set confidence to numeric
carsac.data$confidence <- as.numeric(carsac.data$confidence)

carsac.sub <- subset(carsac.data, carsac.data$passedSanCheck == "True" &
                                  carsac.data$SecondSanCheck == "True")

carsac.sub$participant.ID <- droplevels(carsac.sub$participant.ID)

carsac.sub$age_c <- scale(carsac.sub$age)

carsac.sub$perceivedIden <- factor(carsac.sub$perceivedIden,
                                   levels = c("Beobachter",
                                              "Mitfahrer",
                                              "Fußgänger"),
                                   labels = c("Bystander",
                                              "Passenger",
                                              "Pedestrian"))

carsac.sub$perspective <- factor(carsac.sub$perspective,
                                 levels = c("Observer",
                                            "Passenger",
                                            "PedSmall",
                                            "PedLarge"),
                                 labels = c("Bystander",
                                            "Passenger",
                                            "PedSmall",
                                            "PedLarge"))

carsac.sub$perspective <- combineLevels(
    carsac.sub$perspective,
    levs=c("PedLarge", "PedSmall"),
    newLabel = "Pedestrian")

(nc <- detectCores())
cl <- makeCluster(rep("localhost", nc))

carsac.sub$age_c <- scale(carsac.sub$age)

carsac_glmm <- mixed(decision ~ perspective + motorist +
                        perspective:motorist +
                        trial + gender + age_c + opinAV +
                        education +  drivExperience + visImpairment +
                        perceivedIden +
                        (1 | participant.ID),
                    method = "PB", # change to PB for final
                    family = "binomial", data = carsac.sub,
                    args_test = list(nsim = 1000, cl = cl), cl = cl,
                    control = glmerControl(optimizer = "bobyqa",
                                           optCtrl = list(maxfun = 2e5)))

stopCluster(cl)

carsac_glmm.resid <- simulateResiduals(
    fittedModel = carsac_glmm$full_model, n = 2000)
carsac_glmm_resid.plot <- plotSimulatedResiduals(
    simulationOutput = carsac_glmm.resid)


emm_carsac_i <- emmeans(carsac_glmm, pairwise ~ perspective | motorist,
                        type = 'response')

emm_carsac_persp <- emmeans(carsac_glmm, pairwise ~ perspective,
                            type = 'response')

emm_carsac_motorist <- emmeans(carsac_glmm, pairwise ~ motorist,
                               type = 'response')


save.image(file = "vr_carsac_glmm.RData")