sanity.data <- read.csv("./sanity_checks_test_v1.csv", header = TRUE, sep = ",", quote = "\"",
         dec = ".", fill = TRUE, comment.char = "")

sanity.data$pass <- 0
sanity.data$pass <- (sanity.data$left.first=="False" & sanity.data$response=="option1")
sanity.data$pass <- (sanity.data$left.first=="True" & sanity.data$response=="option2")
