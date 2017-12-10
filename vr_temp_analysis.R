library(lme4)
library(vcdExtra)
library(lsmeans)
library(afex)
library(multcomp)

# read the dataframes
child.data <- read.csv("vr_data/childrenCSV.csv")

carsac.data <- read.csv("vr_data/selfSacCSV.csv")

sidewalk.data <- read.csv("vr_data/sidewalkCSV.csv")

combined.data <- read.csv("vr_data/combinedCSV.csv")

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

carsac.data$driver <- factor(carsac.data$driver,
                             levels = c("False", "True"),
                             labels = c("Human", "AV"))

sidewalk.data$driver <- factor(sidewalk.data$driver,
                               levels = c("False", "True"),
                               labels = c("Human", "AV"))


# rename levels for gender
child.data$gender <- factor(child.data$gender,
                            levels = c("False", "True"),
                            labels = c("Female", "Male"))

carsac.data$gender <- factor(carsac.data$gender,
                             levels = c("False", "True"),
                             labels = c("Female", "Male"))

sidewalk.data$gender <- factor(sidewalk.data$gender,
                               levels = c("False", "True"),
                               labels = c("Female", "Male"))


# create subsets that only include those that passed sanity
child.sub <- subset(child.data, child.data$passedSanCheck == "True")
child.sub$participant.ID <- factor(child.sub$participant.ID)

carsac.sub <- subset(carsac.data, carsac.data$passedSanCheck == "True")
carsac.sub$participant.ID <- factor(carsac.sub$participant.ID)

sidewalk.sub <- subset(sidewalk.data, passedSanCheck == "True")
sidewalk.sub$participant.ID <- factor(sidewalk.sub$participant.ID)


# run the GLMMs
carsac_glmm_pb <- mixed(decision ~ perspective + driver + perspective:
                            driver + (1 | participant.ID) + gender, method = "PB",
                        family = "binomial", data = carsac.sub,
                        control = glmerControl(optimizer = "bobyqa",  optCtrl = list(maxfun = 2e5)))

carsac_glmm_lrt <- mixed(decision ~ perspective + driver + perspective:
                         driver + trial + gender + (1 | participant.ID), method = "LRT",
                     family = "binomial", data = carsac.sub,
                     control = glmerControl(optimizer = "bobyqa",  optCtrl = list(maxfun = 2e5)))




child_glmm_pb <- mixed(decision ~ perspective + driver + perspective:driver +
                           gender + trial + (1 | participant.ID),
                       method = "PB", family = binomial, data = child.sub,
                       args_test = list(nsim = 10),
                       control = glmerControl(optimizer = "bobyqa",  optCtrl = list(maxfun = 2e5)))

child_glmm_lrt <- mixed(decision ~ perspective + driver + perspective:driver +
                            gender + trial + (1 | participant.ID),
                        method = "LRT", family = binomial, data = child.sub,
                        control = glmerControl(optimizer = "bobyqa",  optCtrl = list(maxfun = 2e5)))




sidewalk_glmm_pb <- mixed(decision ~ perspective + driver +
                           perspective:driver +
                           gender + trial + (1 | participant.ID),
                          method = "PB", family = binomial, data = sidewalk.sub,
                          args_test = list(nsim = 10),
                          control = glmerControl(optimizer = "bobyqa",  optCtrl = list(maxfun = 2e5)))

sidewalk_glmm_lrt <- mixed(decision ~ perspective + driver +
                               perspective:driver +
                               gender + trial + (1 | participant.ID),
                           method = "LRT", family = binomial, data = sidewalk.sub,
                           control = glmerControl(optimizer = "bobyqa",  optCtrl = list(maxfun = 2e5)))



# create proportion tables

child.xtabs <- xtabs(~ driver + perspective + decision, data = child.data)

carsac.xtabs <- xtabs(~ driver + perspective + decision + trial, data = carsac.data)

sidewalk.xtabs <- xtabs(~ driver + perspective + decision, data = sidewalk.data)



# plot mosaic plots to files
png(filename = "child_mosaic.png")
child.mosaic <- mosaic(child.xtabs,
                       gp = gpar(fill = c("light gray", "dark gray")))
dev.off()

png(filename = "carsac_mosaic.png")

carsac.mosaic <- mosaic(carsac.xtabs,
                        gp = gpar(fill = c("light gray", "dark gray")))

dev.off()

png(filename = "sidewalk_mosaic.png")
sidewalk.mosaic <- mosaic(sidewalk.xtabs,
                          gp = gpar(fill = c("light gray", "dark gray")))
dev.off()


# follow-up of interations
# see https://cran.r-project.org/web/packages/afex/vignettes/afex_mixed_example.html

# if there is a significant interation for carsac:
carsac_int <- lsmeans(carsac_glmm_lrt, "driver", by = c("perspective"))
carsac.comp <- summary(as.glht(contrast(pairs(child_i1), by = NULL)),
                       test = adjusted("free"))

# if there is a significant interaction for child:
child_int <- lsmeans(child_glmm_lrt, "driver", by = c("perspective"))
child.comp <- summary(as.glht(contrast(pairs(child_i1), by = NULL)),
                      test = adjusted("free"))

# if there is a significant interaction for sidewalk:
sidewalk_i1 <- lsmeans(sidewalk_glmm_lrt, "driver", by = c("perspective"))
sidewalk.comp <- summary(as.glht(contrast(pairs(sidewalk_i1), by = NULL)),
                      test = adjusted("free"))
