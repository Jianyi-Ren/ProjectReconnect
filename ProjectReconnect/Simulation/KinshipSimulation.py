#load ref_allele_frequency_table
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

def SimulateChild(father,mother):
    '''
    Give genotype of father and mother generate a child's genotype
    '''
    child = []
    for i in range(0,len(father)):
        if father[i] == mother[i] and father[i] == '0':
            child.append('0')
        elif father[i] == mother[i] and father[i] == '1':
            child.append('2')
        else:
            father_Give = np.random.binomial(1, 0.5, 1)
            mother_Give = np.random.binomial(1, 0.5, 1)
            if father_Give == mother_Give and mother_Give== 0:
                child.append('0')
            elif father_Give == mother_Give and mother_Give == 1:
                child.append('2')
            else:
                child.append('1')
    return "".join(child)
 
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
    
#test the match percentage between 100,000 siblings
match_percentage = []
for i in range(0,100000):
    if i == 5000:
        print('half')
    father = getGenotype(ref, 1)[0]
    mother = getGenotype(ref, 1)[0]
    #print(father,mother)
    child1 = SimulateChild(father,mother)
    child2 = SimulateChild(father,mother)
    match_result = testKinship(child1,child2)
    match_percentage.append(float(match_result[0])/match_result[1])
#print('child1',child1)
#print('child2',child2)
#print(match_percentage)
match_percentage = [str(i) for i in match_percentage]
s = open("/Users/jianyiren/Desktop/ProjectReconnect/Simulation/siblings_100000.txt",'wb')
s.write("\n".join(match_percentage))
s.close()


match_percentage = []
for i in range(0,100000):
    if i == 5000:
        print('half')
    grandfather = getGenotype(ref, 1)[0]
    grandmother = getGenotype(ref, 1)[0]
    #print(father,mother)
    father = SimulateChild(grandfather,grandmother)
    mother = getGenotype(ref, 1)[0]
    son = SimulateChild(father,mother)
    match_result = testKinship(grandfather,son)
    match_percentage.append(float(match_result[0])/match_result[1])

#print(match_percentage)

match_percentage = [str(i) for i in match_percentage]
s = open("/Users/jianyiren/Desktop/ProjectReconnect/Simulation/grandfather_100000.txt",'wb')
s.write("\n".join(match_percentage))
s.close()