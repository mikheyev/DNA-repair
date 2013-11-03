import pysam, collections
import sys,glob,pdb

reads = collections.defaultdict(list)
for i in glob.glob("data/*.bam"):
	name = i.split("/")[1].split(".")[0]
	samfile = pysam.Samfile(i,"rb")
	out = pysam.Samfile("data/" + name + "_nodup.bam", "wb", template=samfile)
	duplicates = 0 
	total = 0
	for read in samfile:
		if not read.is_unmapped:		
			total += 1
			if read.is_reverse: 
				start = read.positions[0]*-1
			else:
				start = read.positions[0]
			if start not in reads and read.qlen not in reads[start]:
				duplicates += 1
				continue
			else:
				reads[start].append(read.qlen) 
				out.write(read)
	out.close()
	samfile.close()
	print "%s: %i total and %i duplicate reads: %s duplication" % (name, total,duplicates, "{0:.0f}%".format(100.0*duplicates/total))

