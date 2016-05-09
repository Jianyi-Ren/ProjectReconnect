######

#cnv:common cnv information
#SNP_exclude_Disease: SNPs survived disease correlation check

#new_snp: SNPs who passed CHB frequency check of each chromosome, rs. only
#snp:SNPs who passed CHB frequency check of all chromosome, rs. only

#CHS_genotype: SNPs passed CHS Frequency check with full SNP details
#CHS: rs only version of CHS_genotype
#HGDP_genotype: SNPs CHS Frequency check for all minor ethnic groups with full details
#HGDP: rs only version of HGDP_genotype

######

library(dplyr)
library(reshape2)
#1.load in cnv and diseases related informationn from previous steps. Check CHB frequency for each chromosome
cnv <- read.csv("/Users/jianyiren/Desktop/ProjectReconnect/cnv.txt", sep=",")
cnv <- select(cnv,2,3,4)
SNP_exclude_Disease <- read.csv("/Users/jianyiren/Desktop/ProjectReconnect/SNP_exclude_Disease.txt", sep=",")

for (index in 1:22) {
  chromesome = data.frame(index)
  print(chromesome)
  source("/Users/jianyiren/Desktop/ProjectReconnect/4-frequency/CheckEachChromosome.r")
  
}

#2.Check CHS and minor ethnic groups Frequency 
#2.1 deprive the Rs# names from lists for SPSmart 
snp <- data.frame(matrix(ncol = 6, nrow = 0))
for (i in 1:22){
  read_name<- paste0("chr",toString(i),"_full")
  new_snp <-read.csv(paste0("/Users/jianyiren/Desktop/ProjectReconnect/Preliminary_result/",read_name,".txt"), sep=",")
  write_name <- paste0("afterCHB_chr",toString(i))
  write.csv(new_snp$rs.,paste0("/Users/jianyiren/Desktop/ProjectReconnect/Preliminary_result/",write_name,".txt"),row.names = FALSE,quote = FALSE)
  print(write_name)
  snp <- rbind(snp,new_snp)
  }


#2.2 load 2.1 result into SPSmart, the allele that passed Frequency check for all population was saved in ~4-Frequency/
#as CHS_1~22 and HGDP_1~22

#Do a trial and error to select a subset form each chromosome and leave those who have good LDs with each other

snp <- data.frame(matrix(ncol = 1, nrow = 0))
for (i in 1:22){
  CHS_genotype <- read.csv(paste0("/Users/jianyiren/Desktop/ProjectReconnect/4-Frequency/CHS_",i,".txt"), sep="")
  CHS <- rownames(CHS_genotype)
  
  HGDP_genotype <- read.csv(paste0("/Users/jianyiren/Desktop/ProjectReconnect/4-Frequency/HGDP_",i,".txt"), sep="")
  HGDP <- rownames(HGDP_genotype)

  SNP_Pass_All_Fre_Check <- data.frame(CHS[CHS %in% HGDP])
  names(SNP_Pass_All_Fre_Check)[1] <- "rs."
  print(i)
  write.csv(SNP_Pass_All_Fre_Check, paste0("/Users/jianyiren/Desktop/ProjectReconnect/5-LD/",paste0("chr",toString(i)),"_beforeLD.txt"),row.names = FALSE,quote = FALSE)
  
  snp <- rbind(snp,SNP_Pass_All_Fre_Check)
}
