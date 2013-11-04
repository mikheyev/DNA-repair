import sys
import pdb

for line in open(sys.argv[1]):
	if line[0] == "#":
		if line[0:6] == "#CHROM":
			sequences = {}
			sp_names = []
			for sp in line.rstrip().split()[9:]:
				sequences[sp] = ""
				sp_names.append(sp)
		continue
	line = line.rstrip().split()
	if line[4].find(",") > -1 :  #ignore sites with missing data, or more than one variant
		continue
	missing = 0
	one = 0
	zero = 0
	for species in line[9:]:
		if species.split(":")[0] == "./.":
			missing += 1
		elif species.split(":")[0] == "1/1":
			one += 1
		elif species.split(":")[0] == "0/0" :
			zero += 1
		else:
			break
	else:
		if zero > 1 and one > 1 :   #make sure there are parsimony informative characters
#		if missing <= 2 :   
			for idx,snp in enumerate(line[9:]):
				if snp.split(":")[0] == "./.":
					sequences[sp_names[idx]] += "?"
				elif snp.split(":")[0] == "1/1":
					sequences[sp_names[idx]] += "1"
				elif snp.split(":")[0] == "0/0":
					sequences[sp_names[idx]] += "0"

print  """#NEXUS
begin taxa;"""
print "dimensions ntax=%i;" % len(sequences)
print "taxlabels"
for i in sp_names:
	print i
print """;
End;
Begin characters;"""
print "Dimensions nchar=%i;" % len(sequences[sp_names[0]])
print """Format datatype=standard missing=? interleave=no;
Matrix"""
for sp in sp_names:
	print sp + "\t" + sequences[sp]
print """;
End;
Begin MrBayes;
outgroup anomalipes;
lset rates=gamma ngammacat=4;
mcmc nruns=2 ngen=1000000 samplefreq=1000 printfreq=1000 nchains=4 temp=0.2 savebrlens=yes  filename=fly_mb;
sumt relburnin=yes burninfrac=0.25;
End;
"""