DEST=/data2/c1
mkdir $DEST/$1
rm $DEST/$1/*
cwb-encode -q -s -d $DEST/$1 -R /corpora/c1/registry/$1 -P pos -P lemma -V text -V seg -S s
cwb-make -M 800 $1
cwb-describe-corpus $1
