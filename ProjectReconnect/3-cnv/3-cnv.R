#install.packages("dplyr")
library(dplyr)

#select common CNV areas with occurance > 1%
cnv <- read.csv("/Users/jianyiren/Desktop/ProjectReconnect/3-cnv/population_cnv.txt", sep="\t") #58146
cnv <- filter(cnv, deletion_frequency > 0.01) #21691
cnv <- filter(cnv, duplication_frequency > 0.01) #1613

#saveResults
write.csv(cnv, "/Users/jianyiren/Desktop/ProjectReconnect/cnv.txt",quote = FALSE, row.names = FALSE)

