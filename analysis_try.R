load_data <- function(path) { 
  files <- dir(path, pattern = '\\.csv', full.names = TRUE)
  tables <- lapply(files, read.csv)
  #tables <- lapply(files, read.csv("(A-Z)*(0-9)*.csv.csv", header = TRUE, sep = ","))
  #tables <- lapply(files, read.csv("[:alpha:]*[:digit:]*.csv", header = TRUE, sep = ","))
  do.call(rbind, tables)
}

test <- load_data("Data")

# dann ist test eine list -> also rein in einen dataframe
test_dataframe <- do.call(rbind, lapply(test, data.frame, stringsAsFactors=FALSE))

#rename the column
names(test_dataframe) <- "col1"

#jetzt noch die column splitten immer wenn ein " " ist
test_dataframe2 <- transform(test_dataframe, test_dataframe1=do.call(rbind, strsplit(as.character(test_dataframe$col1), ' ', fixed=TRUE)), stringsAsFactors=F)

#ditch col1
test_dataframe2$col1 <- NULL

#rename columns
names(test_dataframe2)[names(test_dataframe2)=="test_dataframe1.1"] <- "Participant ID"
names(test_dataframe2)[names(test_dataframe2)=="test_dataframe1.2"] <- "Gender"
names(test_dataframe2)[names(test_dataframe2)=="test_dataframe1.3"] <- "AV/Car"
names(test_dataframe2)[names(test_dataframe2)=="test_dataframe1.4"] <- "Perspective"
names(test_dataframe2)[names(test_dataframe2)=="test_dataframe1.5"] <- "Scenario"
names(test_dataframe2)[names(test_dataframe2)=="test_dataframe1.6"] <- "Number of Children"
names(test_dataframe2)[names(test_dataframe2)=="test_dataframe1.7"] <- "Number of Adults 1"
names(test_dataframe2)[names(test_dataframe2)=="test_dataframe1.8"] <- "Number of Adults 2"
names(test_dataframe2)[names(test_dataframe2)=="test_dataframe1.9"] <- "Left First?"
names(test_dataframe2)[names(test_dataframe2)=="test_dataframe1.10"] <- "Selected Option"
names(test_dataframe2)[names(test_dataframe2)=="test_dataframe1.11"] <- "Difficulty of decision"
names(test_dataframe2)[names(test_dataframe2)=="test_dataframe1.12"] <- "Response time 1"
names(test_dataframe2)[names(test_dataframe2)=="test_dataframe1.13"] <- "Response time 2"

#how should they be ordered?

print(typeof(test))
print(typeof(test_dataframe))
print(class(test_dataframe))
print(class(test_dataframe$col1))

#print(test_dataframe[[1]])
#print(colnames(test_dataframe[[1]]))

