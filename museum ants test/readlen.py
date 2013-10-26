from Bio import SeqIO
import sys
for rec in SeqIO.parse(sys.argv[1],"fastq"):
    print "%i\t%s" % (len(rec.seq), sys.argv[1].rstrip(".fq"))
