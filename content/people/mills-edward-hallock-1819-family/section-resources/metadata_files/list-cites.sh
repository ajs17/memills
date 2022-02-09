#!/bin/bash

OUTFILE="cites.txt"
rg 'citation:' -g '*.md' > ${OUTFILE} 

# report feedback
head ${OUTFILE}  
echo -n "found: " 
cat ${OUTFILE} | wc -l


