# Compare Exodus and Genesis
INPUT=${INPUT:-$PATH_TOP/evaluation/scripts/input/genesis}
INPUT2=${INPUT2:-$PATH_TOP/evaluation/scripts/input/exodus}
tr -sc '[A-Z][a-z]' '[\012*]' < ${INPUT} | sort -u >  ${INPUT}.types
tr -sc '[A-Z][a-z]' '[\012*]' < ${INPUT2} | sort -u > ${INPUT2}.types
# do we really need the same thing twice
sort ${INPUT}.types ${INPUT2}.types ${INPUT2}.types | uniq -c | head