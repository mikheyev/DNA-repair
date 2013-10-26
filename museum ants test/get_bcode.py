#!/usr/bin/env python
import sys
"""Reads barcodes.txt, which contains first column barcode, and second column species. 
Given a barcode, returns species, and vice versa"""

species = {}
barcodes = {}
for line in open("barcodes.txt"):
	line = line.rstrip().split()
	species[line[1]]=line[0]
	barcodes[line[0]]=line[1]

if sys.argv[1] in species:
	print species[sys.argv[1]]
elif sys.argv[1] in barcodes:
	print barcodes[sys.argv[1]]
else:
	raise RuntimeError("can't find input argument in file")
