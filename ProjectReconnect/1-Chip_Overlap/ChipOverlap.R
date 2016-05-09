#1.SNP overlap from various Chips
#23andme, ancestry, and deCODEme samples download from https://opensnp.org/genotypes?page=5
#wegene snp list downloaded from https://www.wegene.com/question/374

#23andme
t23andme <- read.csv("/Users/jianyiren/Desktop/ProjectReconnect/1-Chip_Overlap/23andme.txt", header = TRUE, sep="", skip = 19)#610544
names(t23andme)[1]='rs.'

#Ancestry
Ancestry <- read.csv("/Users/jianyiren/Desktop/ProjectReconnect/1-Chip_Overlap/ancestry.txt", header = TRUE, sep="", skip = 16)#701478
names(Ancestry)[1]='rs.'

#deCODEme
deCODEme <- read.csv("/Users/jianyiren/Desktop/ProjectReconnect/1-Chip_Overlap/deCODEme.txt", header = TRUE, sep=",")#1106002
names(deCODEme)[1]='rs.'

#wegene(Illumina)
wegene <- read.csv("/Users/jianyiren/Desktop/ProjectReconnect/1-Chip_Overlap/Wegene.txt",header = TRUE, sep="",skip = 23)#596766
names(wegene)[1]='rs.'

#familyTree
familyTree <- read.csv("/Users/jianyiren/Desktop/ProjectReconnect/1-Chip_Overlap/familyTree.txt", header = TRUE, sep=",")#680544
names(familyTree)[1]='rs.'

#Do a overlap
CandidateSNP <- data.frame(merge(t23andme,Ancestry,by = "rs."))#len = 307481
CandidateSNP <- data.frame(merge(CandidateSNP,deCODEme,by = "rs."))#len = 295684
CandidateSNP <- data.frame(merge(CandidateSNP,wegene,by = "rs."))#len = 249404
CandidateSNP <- data.frame(merge(CandidateSNP,familyTree,by = "rs."))#len = 240857

#saveResults
write.csv(CandidateSNP$rs., "/Users/jianyiren/Desktop/ProjectReconnect/SNP_Chip_Overlap.txt",quote = FALSE, row.names = FALSE)


