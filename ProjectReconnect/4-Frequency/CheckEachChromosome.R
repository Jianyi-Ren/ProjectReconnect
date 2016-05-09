#Use hapmap data to check Frequency for CHB,eliminate disease and CNV related snps 
#then use SPSmart to check Frequency for CHS, all rest enthic groups, LD

######Variable list

#cnv(data frame) list of CNV with >1% frequency
#chromesome(int) the choromsome number that is currently processed
#SNP_exclude_Disease(data frame)  SNPs list of overlap of all chips, disease related ones excluded 

#chromo(int)the choromsome number that is currently processed
#chr_name(string) fragment of the choromsome name used to load raw data

#Fre_raw(data frame) raw data for allele frequency
#Fre(data frame) concise version of Fre_raw
#Genotype_raw(data frame) raw data for genotype
#Genotype(data frame) concise version of Genotype_raw

#chr_merge,chr,df,newdf,intermediate dataset

#chr_cnv(data frame) CNV info subset to this chromosome
#badrow(list) row# of snps who are found to be in the common cnv areas and thus will be eliminated later

#########

rm(list=setdiff(ls(), c("cnv", "chromesome","SNP_exclude_Disease")))
chromo = as.integer(chromesome[1])
chr_name = paste0("chr",toString(chromo))
# 1. Chip Overlap. Done. Obtained SNP_exclude_Disease.txt

# 2. Frequency Check
#load frequency data
Fre_raw <- read.csv(paste0("/Users/jianyiren/Desktop/ProjectReconnect/4-Frequency/Hapmap/allele_freqs_",chr_name,"_CHB_r28_nr.b36_fwd.txt"), sep="")
Fre <- select(Fre_raw,rs.,pos,refallele_freq,refallele,otherallele)

#load genotype data
Genotype_raw <- read.csv(paste0("/Users/jianyiren/Desktop/ProjectReconnect/4-Frequency/Hapmap/genotypes_",chr_name,"_CHB_r28_nr.b36_fwd.txt"), sep="")
Genotype <- select(Genotype_raw,1,2,4,12:150)

#merge data
chr_merge <- merge(Fre,Genotype,by = "rs.")

#filter by frequency
chr <- filter(chr_merge, (refallele_freq > 0.35 & refallele_freq < 0.45) | (refallele_freq > 0.55 & refallele_freq < 0.65))#14182

# 3 eliminate disease-related SNPs 
chr <- subset(chr, !(chr$rs. %in% SNP_exclude_Disease$rs.))#

# 4 HWE Check

#add 3 columns for count of each of the 3 possible genotypes
#homoRef is the genotype for homozygous reference allele
#homoOther is genotype for homozygous other allele
#heter is heterozygous allele

rm(list=setdiff(ls(), c("cnv", "chromesome","SNP_exclude_Disease", "chr","chr_name")))
f <- function(data, heter) {
  ref = data[4]
  other = data[5]
  if (ref < other){
    heter = paste0(ref,other)}
  else{
    heter = paste0(other,ref)}
}

chr = mutate(chr, homoRef = paste0(refallele,refallele), homoOther=paste0(otherallele,otherallele), 
             heter = paste0(refallele,otherallele))
chr$heter <- apply(chr,1,f,heter = "heter")#alphabet order issue


df <- chr
a <- melt(df, c("rs.", "homoRef", "homoOther","heter"))
b <- group_by(a,rs.)
c <- summarise(b,
               RefCount=sum(homoRef==value),
               OtherCount=sum(homoOther==value),
               hetercount=sum(heter==value))
newdf <- merge(c,x=df)

# chi square test for HWE
#newdf <- select(newdf, rs.,refallele_freq, refallele, otherallele,RefCount, OtherCount, hetercount)
newdf <- mutate(newdf, refFre = 0.5*(RefCount*2 + hetercount) / (RefCount + hetercount + OtherCount), 
                otherFre = 1-refFre, 
                n = RefCount + hetercount + OtherCount, 
                E1 = refFre^2 * n, 
                E2 = 2*refFre*otherFre*n, 
                E3 = otherFre^2*n )

newdf <- mutate(newdf, chi2 = (RefCount - E1)^2/E1 +  (hetercount - E2)^2/E2 +  (OtherCount - E3)^2/E3)
newdf <- filter(newdf, chi2 < 3.84)
chr <- newdf 


# 5.CNV check
rm(list=setdiff(ls(), c("cnv", "chromesome","SNP_exclude_Disease", "chr","chr_name")))
chr_cnv <- cnv[cnv$chr == as.integer(chromesome[1]),]

start <- chr_cnv$start#start position of each strand of CNV
end <- chr_cnv$end #end position of each strand of CNV
badrow <- vector()#initate an index list for snps in common cnv areas

for (i in 1:length(chr$rs.)) {
  for (j in 1:length(start)) {
    if ((chr$pos.x[i] > start[j]) & (chr$pos.x[i] < end[j])){
      #print(i)
      badrow = c(badrow,i)
      break
    }
  } 
}
badrow <- c(badrow)

#if there are SNPs, elimiate them
if (length(badrow) != 0) {
  chr <- chr[-badrow,] 
} else {
  print("0")
}

#Save results
chr <- select(chr, rs., pos.x, refallele, otherallele, refallele_freq)
chr <- arrange(chr,pos.x)
chromosomeID <- as.integer(chromesome[1])
chr <- mutate(chr, chromosomeID = chromosomeID)


write.csv(chr, paste0("/Users/jianyiren/Desktop/ProjectReconnect/Preliminary_result/",chr_name,"_full.txt"),row.names = FALSE)



