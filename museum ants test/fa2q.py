from Bio import SeqIO
from Bio.SeqIO.QualityIO import PairedFastaQualIterator
import sys
#records = 
for rec in PairedFastaQualIterator(open(sys.argv[1]+".fa"), open(sys.argv[1]+ ".qual")):
    print rec.format("fastq"),
