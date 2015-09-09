install.packages("tidyr")
install.packages("dplyr")
install.packages("chron")
library(tidyr)
library(dplyr)
library(chron)

rawdata <-read.table("./energy/household_power_consumption.txt", stringsAsFactors = FALSE)
tablenames <- strsplit(rawdata[1,1], ";")
tablenames <- unlist(tablenames)

fulltable <- separate(data = rawdata, col = V1, into = tablenames, sep = "\\;")

length <- nrow(rawdata)
fulltable <- fulltable[2:length,]

fulltable$Date <- as.Date(fulltable$Date, format="%d/%m/%Y")
fulltable$Time <- chron(times=fulltable$Time)

pick_dates <- filter(fulltable, Date =="2007-02-01" | Date=="2007-02-02")
pick_dates$Global_active_power <- as.numeric(pick_dates$Global_active_power)

pick_dates <- mutate(pick_dates, datetime = paste(pick_dates[,1], pick_dates[,2], sep="-"))

pick_dates$datetime <- strptime(pick_dates$datetime, format = "%Y-%m-%d-%H:%M:%S")

#plot two
plot(pick_dates$datetime, pick_dates$Global_active_power, pch=".", type ="o", ylab="Global Active Power (kilowatts)", xlab="")
dev.copy(png, file = "plot2.png")
dev.off()