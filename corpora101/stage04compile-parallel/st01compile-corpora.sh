# cp ../020tmx2out/result/en-fr1/* ./

## stage 1: creating individual corpora from .out files (files generated by a tokeniser or a TreeTagger)
# /corpora/tools/compilecorpus/make-corpus.sh <lang-en1k.out ep-enfr1-en
# /corpora/tools/compilecorpus/make-corpus.sh <lang-fr1k.out ep-enfr1-fr

cwb-encode -d /Users/bogdan/corpora/demo-emea-de -xsBC9 -c utf8 -R /opt/homebrew/share/cwb/registry/demo-emea-de -P pos -P lemma -V s <../de-en-EMEA-lang-de.vert
cwb-make -M 800 demo-emea-de
cwb-describe-corpus demo-emea-de

cwb-encode -d /Users/bogdan/corpora/demo-emea-en -xsBC9 -c utf8 -R /opt/homebrew/share/cwb/registry/demo-emea-en -P pos -P lemma -V s <../de-en-EMEA-lang-en.vert
cwb-make -M 800 demo-emea-en
cwb-describe-corpus demo-emea-en



## stage2: manually adding the "alignment" attribute to the registry files
## (change the path to registry if necessary in this file and other .sh files)
##
# cp /corpora/c1/registry/ep-enfr1-en ep-enfr1-en
# cat ep-enfr1-en ep-enfr1-fr-ALIGNED.txt >/corpora/c1/registry/ep-enfr1-en

# cp /corpora/c1/registry/ep-enfr1-fr ep-enfr1-fr
# cat ep-enfr1-fr ep-enfr1-en-ALIGNED.txt >/corpora/c1/registry/ep-enfr1-fr



## stage3: aligning both corpora (creating alignment index files .alx in the data directory)
# /corpora/tools/compilecorpus/align-cwb.sh ep-enfr1-en ep-enfr1-fr

# rm *.out



## cwb-align-encode -d /corpora/c1/c-test-en/ -r /corpora/c1/registry/ c-test-en-c-test-fr.align


## as a result, the corpus data will be created in /corpora/c1/c-test-en and /corpora/c1/c-test-fr
## registry files will be in the directory /corpora/c1/registry/


