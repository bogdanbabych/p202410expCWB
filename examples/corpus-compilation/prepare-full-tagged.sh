mkdir /data2/c1/$1
rm  /data2/c1/$1/*
cwb-encode cwb-encode -q -s -d /data2/c1/$1 -R /corpora/c1/registry/$1 $1 -P pos -P lemma -P Animate -P Aspect -P CATEGORY -P Case -P Case2 -P Coord_Type -P Definiteness -P Degree -P Form -P Formation -P Gender -P Number -P Person -P Sub_Type -P Syntactic_Type -P Tense -P Type -P VForm -P Voice -V text -S s -V seg
cwb-make $1

