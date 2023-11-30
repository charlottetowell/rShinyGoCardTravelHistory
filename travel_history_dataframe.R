travel_history_dataframe <- function(file) {
  ### IMPORT DATA
  data <- read.csv(file, header = TRUE)
  print(sprintf("Imported data with %i rows", nrow(data)))
  
  ### DATA CLEANING
  
  # - rename columns
  names(data)[names(data)=="Time"] <- "Departure_Time"
  names(data)[names(data)=="Time.1"] <- "Arrival_Time"
  
  # - remove unnecessary rows
  data <- data[!grepl("top up", data$From, ignore.case=T),]
  data <- data[data$Departure_Time != "",]
  data <- data[!grepl("Failed to touch Off", data$To, ignore.case=T),]
  print(sprintf("Data Clean resulted in %i rows", nrow(data)))
  
  # - replace touch on transfer
  data$From <- gsub("(Touch on Transfer)", "", data$From, fixed=TRUE)
  
  # - trim
  data$From <- str_trim(data$From)
  data$Date <- str_trim(data$Date)
  
  # - merge with train stations
  trainStations = read.csv("TrainStations.txt", header = FALSE)
  names(trainStations) <- 'From'
  trainStations$isTrainStation <- trainStations$From
  data <- merge(x = data, y = trainStations, by = "From", all.x = TRUE)
  
  # - add mode of transport
  data$ModeOfTransport = ifelse(grepl("Ferry", data$From, ignore.case=T), "Ferry", ifelse(!is.na(data$isTrainStation), "Train", "Bus"))
  
  # - dealing with datetime columns
  data$Departure_Time <- substr(data$Departure_Time, 1, 5)
  data$Departure_DateTime = paste(data$Date, data$Departure_Time)
  data$Departure_DateTime <- as.POSIXct(data$Departure_DateTime, format="%d/%b/%Y %H:%M")
  
  data$Arrival_Time <- substr(data$Arrival_Time, 1, 5)
  data$Arrival_DateTime = paste(data$Date, data$Arrival_Time)
  data$Arrival_DateTime <- as.POSIXct(data$Arrival_DateTime, format="%d/%b/%Y %H:%M")
  
  # - add trip duration
  data$TripDuration = difftime(data$Arrival_DateTime, data$Departure_DateTime, NA, "mins")
  
  # - Fare $ column
  data$Fare <- gsub("$", "", data$Fare, fixed=TRUE)
  data$Fare <- as.numeric(data$Fare)
  
  # - add day of week
  data$Date = as.Date(data$Date, "%d/%b/%Y")
  data$DayOfWeek = weekdays(data$Date)
  data <- data %>%
    mutate(DayOfWeekNum = case_when(
      DayOfWeek == "Monday" ~ 1,
      DayOfWeek == "Tuesday" ~ 2,
      DayOfWeek == "Wednesday" ~ 3,
      DayOfWeek == "Thursday" ~ 4,
      DayOfWeek == "Friday" ~ 5,
      DayOfWeek == "Saturday" ~ 6,
      DayOfWeek == "Sunday" ~ 0
    ))
  data$WeekEnd = ifelse(data$DayOfWeekNum == 0 | data$DayOfWeekNum == 6, "Weekend", "Weekday")
  
  # - add week ending (Sunday)
  data$WeekEnding = ceiling_date(data$Date, "week")
  
  # - add rounded time (nearest half hour)
  data$RoundedDepartureTime = round_date(data$Departure_DateTime, "30 minutes")
  data$RoundedDepartureTime = format(as.POSIXct(data$RoundedDepartureTime), format = "%H:%M")
  
  # - remove column
  data <- subset( data, select = -isTrainStation )
  
  # - add index column
  data$index <- 1:nrow(data)
  
  return(data)
}