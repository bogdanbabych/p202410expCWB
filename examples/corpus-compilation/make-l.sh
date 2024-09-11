#!/bin/bash
REG=/corpora/c1/registry
./addsegid.pl < $1-en.txt | tree-tagger-english > $1-en.out
./addsegid.pl < $1-es.txt | recode -f u8..latin1 | tree-tagger-spanish | recode -f latin1..u8 > $1-es.out
./addsegid.pl < $1-it.txt | recode -f u8..latin1 | tree-tagger-italian | recode -f latin1..u8  > $1-it.out
make-para-corpus.sh $1-en <$1-en.out
make-para-corpus.sh $1-es <$1-es.out
make-para-corpus.sh $1-it <$1-it.out

echo >>/corpora/c1/registry/$1-en ALIGNED $1-es
echo >>/corpora/c1/registry/$1-en ALIGNED $1-it
echo >>/corpora/c1/registry/$1-es ALIGNED $1-en
echo >>/corpora/c1/registry/$1-es ALIGNED $1-it
echo >>/corpora/c1/registry/$1-it ALIGNED $1-en
echo >>/corpora/c1/registry/$1-it ALIGNED $1-es

align.sh $1-en $1-es
align.sh $1-en $1-it
align.sh $1-es $1-en
align.sh $1-es $1-it
align.sh $1-it $1-en
align.sh $1-it $1-es
