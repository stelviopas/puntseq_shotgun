#!/bin/bash 

#download directly to lustre storage because the file is huge
cd /lustre/groups/haicu/workspace/anastasiia.grekova/ncbi_nt
 
wget ftp://ftp.ncbi.nih.gov/blast/db/FASTA/nt.gz
gunzip nt.gz && mv -v nt nt.fa

# Get mapping file
wget ftp://ftp.ncbi.nih.gov/pub/taxonomy/gi_taxid_nucl.dmp.gz
gunzip -c gi_taxid_nucl.dmp.gz | sed 's/^/gi|/' > gi_taxid_nucl.map

# build index using 16 cores and a small bucket size, which will require less memory
centrifuge-build -p 16 --bmax 1342177280 --conversion-table gi_taxid_nucl.map \
                 --taxonomy-tree taxonomy/nodes.dmp --name-table taxonomy/names.dmp \ 
                 nt.fa nt
ln -s /lustre/groups/haicu/workspace/anastasiia.grekova/ncbi_nt/ /home/haicu/anastasiia.grekova/workspace/puntseqWGS/resources/databases/ncbi_nt

