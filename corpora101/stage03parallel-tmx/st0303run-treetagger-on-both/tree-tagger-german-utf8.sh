#!/bin/sh
# copy this file to the bin/ TreeTagger directory

# Set these paths appropriately

BIN="."
CMD="../cmd"
LIB="../lib"
MOD="../models"

OPTIONS="-token -lemma -sgml -no-unknown"

TOKENIZER=${CMD}/utf8-tokenize.perl
TAGGER=${BIN}/tree-tagger
ABBR_LIST=${LIB}/german-abbreviations
PARFILE=${MOD}/german-utf8.par

$TOKENIZER -e -a $ABBR_LIST $* |
# remove empty lines
grep -v '^$' |
# tagging
$TAGGER $OPTIONS $PARFILE | 
perl -pe 's/\tV[BDHV]/\tVB/;s/\tIN\/that/\tIN/;'
