library(lme4)
library(cowplot)
library(lsmeans)
library(plyr)
library(afex)



# read the online_acceptibility data file
data <- read.csv("online_accept_data/shortenedOnlineCSV.csv")

# create subset for car-ped dilemmas
carped.sub <- subset(data, scenario == "carsac")

# ensure data is of correct type
carped.sub$first_vid <- factor(carped.sub$first_vid)
carped.sub$scenario <- factor(carped.sub$scenario)
carped.sub$Subject_Id <- factor(carped.sub$Subject_Id)
carped.sub$ratio <- as.numeric(carped.sub$ratio) - 1
carped.sub$response <- factor(carped.sub$response)
carped.sub$PERSP <- factor(carped.sub$PERSP)
carped.sub$DRIVER_TYPE <- factor(carped.sub$DRIVER_TYPE)


# perform GLMM for car-ped dilemmas

# center ratio variable

carped.sub$ratio_c <- scale(carped.sub$ratio)

carped.glmm <- mixed(response ~ ratio_c * PERSP * DRIVER_TYPE +
                         (1 | Subject_Id),
                     method = "LRT", family = binomial,
                     data = carped.sub, args_test = list(nsim = 10),
                     control = glmerControl(optimizer = "bobyqa",
                                            optCtrl = list(maxfun = 2e5)))



# plot GLMM


label_names <- c("AV" = "Self-driving",
                 "HUMAN" = "Human",
                 "sidewalk" = "Sidewalk",
                 "road" = "Road")


carped.plot <- ggplot(carped.glmm$full_model,
                      aes(ratio,
                          as.numeric(response) - 1,
                          color = PERSP)) +
    stat_smooth(method = "glm", se = F,
                method.args = list(family = "binomial")) +
    facet_grid(. ~ DRIVER_TYPE, labeller = as_labeller(label_names)) +
    theme_cowplot(font_size = 10) +
    scale_x_continuous(name = "Lives-risked ratio", limits = c(1, 4)) +
    scale_y_continuous(name = "P(Choosing swerve as more acceptable)",
                       limits = c(0, 1)) + coord_equal(ratio = 3) +
    scale_color_manual(name = "Perspective",
                       labels = c("Car occupant",
                                  "Bird's-eye view",
                                  "Pedestrian"),
                       values = c("red3", "skyblue", "orange1" ))

# save file
png(file = "carped_plot.png")
carped.plot
dev.off()


# plot each subjects responses

carped_subj.plot <- ggplot(carped.glmm, aes(x = as.numeric(ratio),
                                            y = as.numeric(response) - 1,
                                            color = PERSP,
                                            linetype = DRIVER_TYPE)) +
    stat_smooth(method = "glm", se = F,
                method.args = list(family = "binomial")) +
    geom_line() +
    xlab("Lives-risked ratio") + ylab("Response") +
    facet_wrap(PERSP ~ Subject_Id) +
    theme_cowplot(font_size = 8) + coord_equal(ratio = 1)


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


pedped.sub$ratio_c <- scale(pedped.sub$ratio)

pedped.glmm <- mixed(response ~ ratio_c * PERSP * DRIVER_TYPE +
                         ratio_c * DRIVER_TYPE * scenario  +
                         (1 + ratio_c + scenario | Subject_Id),
                     method = "LRT", family = binomial,  # possibly change method to PB
                     data = pedped.sub, args_test = list(nsim = 10),
                     control = glmerControl(optimizer = "bobyqa",
                                            optCtrl = list(maxfun = 2e5)))

# plot GLMM


pedped.plot <- ggplot(pedped.glmm$full_model,
                      aes(ratio, as.numeric(response) - 1, color = PERSP)) +
    stat_smooth(method = "glm", se = F,
                method.args = list(family = "binomial")) +
    scale_x_continuous(name = "Lives-risked ratio", limits = c(1, 4)) +
    scale_y_continuous(name = "P(Choosing swerve as more acceptable)",
                       limits = c(0, 1)) + coord_equal(ratio = 3) +
    scale_color_manual(name = "Perspective",
                       labels = c("Car occupant",
                                  "Bird's-eye view",
                                  "Pedestrian straight ahead",
                                  "Pedestrian to side"),
                       values = c("red",
                                  "skyblue",
                                  "orange",
                                  "darkorange3" ) ) +
    facet_grid( scenario ~ DRIVER_TYPE,
               labeller = as_labeller(label_names)) +
    theme_cowplot(font_size = 10)

# save to file
png(file = "pedped_plot.png")
pedped.plot
dev.off()

# plot individual responses

pedped_subj.plot <- ggplot(pedped.glmm,
                           aes(ratio, as.numeric(response) - 1,
                               color = PERSP:DRIVER_TYPE,
                               linetype = scenario)) +
    stat_smooth(method = "glm", se = F,
                method.args = list(family = "binomial")) +
    geom_point(position = position_jitter(height = 0.03, width = 0)) +
    facet_wrap(PERSP ~ Subject_Id) + theme_cowplot(font_size = 8) +
    scale_x_continuous(name = "Lives-risked ratio", limits = c(1, 4)) +
    scale_y_continuous(name = "P(Choosing swerve as more acceptable)")


# followup tests: see https://cran.r-project.org/web/packages/lsmeans/vignettes/using-lsmeans.pdf section 12


# this determines the differential effect of ratio depending on perspective and driver

carped_int <- lstrends(carped.glmm, ~ PERSP:DRIVER_TYPE, var = "ratio_c")


carped_int.comp <- summary(as.glht(contrast(pairs(carped_int), by = NULL)),
                      test = adjusted("free"))


pedped_int1 <- lstrends(pedped.glmm, ~ PERSP:DRIVER_TYPE, var = "ratio_c")

pedped_int1.comp <-  summary(as.glht(contrast(pairs(pedped_int1), by = NULL)),
                      test = adjusted("free"))
