#!/bin/awk 



BEGIN {
    dna["AG"]="R"
    dna["CT"]="Y"
    dna["CA"]="M"
    dna["TG"]="K"
    dna["TA"]="W"
    dna["CG"]="S"
    dna["GA"]="R"
    dna["TC"]="Y"
    dna["AC"]="M"
    dna["GT"]="K"
    dna["AT"]="W"
    dna["GC"]="S"
}



$0~"^#" {
    if ($1=="#CHROM") 
	for (i =10;i<=NF;i++)
	     names[i-9]=$i
	}

$0!~"^#" && (length($5)+length($4))==2 {for(i = 10; i<=NF; i++){
	if (substr($i,1,3)=="1/1") 
	    seqs[i-9] = seqs[i-9] $5
	else if (substr($i,1,3)=="0/0") 
	    seqs[i-9]=seqs[i-9] $4
	else if  (substr($i,1,3)=="0/1") 
	    seqs[i-9]=seqs[i-9] dna[$4$5]
	else
	    seqs[i-9]=seqs[i-9] "N"
    }
}

END {
    for (i in seqs) {
	    print ">"names[i]
	    print seqs[i]
	    }
}