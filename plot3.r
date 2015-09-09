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

#plot three
par(ps = 12, cex = 1, cex.main = 1)
with(pick_dates, plot(datetime, Sub_metering_1, pch=".", type="o", ylab="Energy Sub Metering", xlab = ""))
with(pick_dates, points(datetime, Sub_metering_2, pch=".", type="o", col="red"))
with(pick_dates, points(datetime, Sub_metering_3, pch=".", type="o", col="blue"))
legend("topright", pch="-", col = c("black", "blue", "red"), legend = c("Sub_Metering_1", "Sub_Metering_2", "Sub_Metering_3"))
dev.copy(png, file = "plot3.png")
dev.off()