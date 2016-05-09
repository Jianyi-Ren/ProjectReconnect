This Document is created by Jianyi Ren at 4/29/2016 as part of the explanation for Project Reconnect for course 4761 at Columbia University.

*CheckEachChromosome.R is the script to check HWE, exclude disease and CNV related snps, filter frequency for CHB for each chromosome

*main.R is the script to collect the preliminary result from the previous script, then check the Frequency for CHS and all other ethnic populations on SPSmart(mostly manually), then combine the results for LD check in next step.

Data for CHB: Hapmap Phase III raw data for CHB were downloaded from Hapmap project website

Genotypes:https://hapmap.ncbi.nlm.nih.gov/downloads/genotypes/2010-08_phaseII+III/forward/

Frequency:https://hapmap.ncbi.nlm.nih.gov/downloads/frequencies/2010-08_phaseII+III/

#All snps passed these criteria are saved in Preliminary_results

#Then Spsmart was used to check the frequency for CHS and all other ethnic population. Results saved as

*CHS_1~22.txt snps who pass Frequency test for CHS
*HGDP_1~22.txt snps who pass Frequency test for all ethnic groups
*The overlap of the three(CHB, CHS, all ethnic groups) were saved into ~ProjectReconnect/5-LD/chr1~22_beforeLD.txt