This Document is created by Jianyi Ren at 4/29/2016 as part of the explanation for Project Reconnect for course 4761 at Columbia University.

Disease information was downloaded from 
http://rdf.disgenet.org/download/v3.0.0/snp.ttl.gz

Extracted by terminal 
grep -o '\[dbsnp\:rs[0-9]*\]' snp.ttl | sort -u | grep -o 'rs[0-9]*' > diseaseSNPs && less diseaseSNPs

The list of SNPs related to diseases are saved in “diseaseSNPs”

Then processed by disease.R