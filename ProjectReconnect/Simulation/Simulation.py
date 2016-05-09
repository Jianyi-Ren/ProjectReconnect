import time
import numpy as np
import random

data = open('/Users/jianyiren/Desktop/ProjectReconnect/Simulation/Frequency.csv')
ref = []
for eachLine in data.readlines():
    eachLine=eachLine.rstrip('\n')
    ref.append(float(eachLine))


def getGenotype(Frequency, n):
    '''   
    simulate genotypes for n individual
    
            individual 1 2 .. 1e6     
    Neucleosides: SNP1[ [[1,0.....]
                        [1,1.....]],
                SNP2 [[1,0.....]
                        [0,0.....]],
                ......
                SNP384 [[0,1.....]
                        [0,1.....]]]
    
    p: frequency for ref allele for ith SNP in th frequency list
    firstLetters: first element in Neucleosides, 1 = ref allele, 0 = other allele
    secondLetters:second element in Neucleosides, 1 = ref allele, 0 = other allele
    
    genotypes:genotypes of all individuals, each individual's genotype is a string with length 384. 0-homozygous ref 1-heterzygous 2-homozygous other
    this_genotype: genotype 
    '''
    Neucleosides = []
    for i in range(0,len(Frequency)):
        p = Frequency[i]
        firstLetters = np.random.binomial(1, p, n)
        secondLetters = np.random.binomial(1, p, n)
        Neucleosides.append([firstLetters,secondLetters])
     
    genotypes = []
    for i in range(0,n):
        this_genotype = []
        for j in range(0,len(Frequency)):
       	    firstLetter = Neucleosides[j][0][i]
            secondLetter = Neucleosides[j][1][i]
            if firstLetter == secondLetter and firstLetter == 1:
                this_genotype.append(str(0))
            elif firstLetter == secondLetter and firstLetter == 0:
                this_genotype.append(str(2))
            else:
                this_genotype.append(str(1))
        genotypes.append("".join(this_genotype))
    return genotypes


def testFrequency(entryList):
    #verify whether the generated genotypes follows the frequency table
    fre = []
    for i in  range(0,384):
        count0 = 0
        count1 = 0
        for j in range(0,len(entryList)):
            if entryList[j][i] == '0':
                count0 += 1
            elif entryList[j][i] == '1':
                count1 += 1
        fre.append(0.5*(count0*2+count1)/len(entryList))
    return fre

def generateSon(father,Frequency):
    '''
    Give father genotype and frequency List, generate a son genotype
    fatherLetter: whether father is ref allele at a position,1 is ref allele, 0 is other
    motherLetter: whether mother is ref allele at a position, 1 is ref allel, 0 is other
    p: allele frequency for ith SNP
    '''
    son = []
    for i in range(0,len(father)):
        p = ref[i]       
        motherLetter = int(np.random.binomial(1, p, 1))
        if int(father[i]) == 0:#homozygous ref
            fatherLetter = 1 
        elif int(father[i]) == 1:
            fatherLetter = int(np.random.binomial(1, 0.5, 1))
        else: #homozygous other
            fatherLetter = 0 
            
        if fatherLetter == motherLetter and fatherLetter == 1:
            son.append(str(0))
        elif fatherLetter == motherLetter and fatherLetter == 0:
            son.append(str(2))
        else:
            son.append(str(1))  
    son = "".join(son)   
    return son

def testKinship(father,son):
    '''
    Give genotype of father and son
    return the total matches between them
    '''
    Pass = 0;
    effectiveSNP = 384
    for i in range(0,len(father)):
        #print(father[i],son[i])
        if father[i] == '9' or son[i] == '9':
            effectiveSNP -= 1
        elif father[i] == '0' and son[i] == '2':
            continue
        elif father[i] == '2' and son[i] == '0':
            continue
        else: 
            Pass += 1
    return [Pass, effectiveSNP]  
                         
#Simulate genotypes of 'SonSize' random sons, and 'FatherSize' fathers
SonSize = 10
FatherSize = 100
Genotyps_of_fathers = getGenotype(ref, FatherSize)  

f = open("/Users/jianyiren/Desktop/ProjectReconnect/Simulation/Simulated_Samples_100000.txt",'wb')
f.write("\n".join(Genotyps_of_fathers))
f.close()

s = open("/Users/jianyiren/Desktop/ProjectReconnect/Simulation/Random.txt",'wb')
randomChild = "".join(getGenotype(ref,1))
s.write(randomChild)
s.close()


#Simulate genotypes of 1 son, whose father is the first one from the Genotyps_of_fathers
son =  list(generateSon(Genotyps_of_fathers[0],ref))  
for i in range(0,100):
    son[i] = '9'   
son = "".join(son)

s = open("/Users/jianyiren/Desktop/ProjectReconnect/Simulation/son.txt",'wb')
s.write(son)
s.close()

# 1.test genotype generation function
print('test genotyping generation function')
print("ref:",ref[0:10])
print("simu:",testFrequency(Genotyps_of_fathers)[0:10])

# 2.test on the random sons
#(this test code is to verify my simulation code, pruely for self-entertainment; the core code we use in the website is written by Calvin)

for i in range(0,SonSize):
    randomSon = getGenotype(ref, 1) [0]
    for j in range(0,FatherSize):
        testResult = testKinship(randomSon,Genotyps_of_fathers[j])
        if float(testResult[0])/testResult[1] > 0.95:
            print(float(testResult[0])/testResult[1])
            
#3.test on the true sons
print('son:',son)
for j in range(0,FatherSize):
    testResult = testKinship(son,Genotyps_of_fathers[j])
    if j == 0:
        print(testResult)
    if float(testResult[0])/testResult[1] > 0.95:
            print(float(testResult[0])/testResult[1])  
                
