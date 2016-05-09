#exclude SNPs that related to disease
SNP_Chip_Overlap <- read.csv("/Users/jianyiren/Desktop/ProjectReconnect/SNP_Chip_Overlap.txt", sep="\t")#240857
Disease <-  read.csv("/Users/jianyiren/Desktop/ProjectReconnect/2-disease/diseaseSNPs", header = FALSE, sep="\t")
names(Disease) <- 'rs.'
names(SNP_Chip_Overlap) <- 'rs.'
SNP_exclude_Disease  <- subset(SNP_Chip_Overlap, !(SNP_Chip_Overlap$rs. %in% Disease$rs.))#236365

#saveResults
write.csv(SNP_exclude_Disease, "/Users/jianyiren/Desktop/ProjectReconnect/SNP_exclude_Disease.txt",quote = FALSE, row.names = FALSE)

