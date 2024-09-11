# cp /opt/homebrew/share/cwb/registry/demo-emea-de demo-emea-de
# cat demo-emea-de demo-emea-de-ALIGNED.txt >/opt/homebrew/share/cwb/registry/demo-emea-de
# echo >>/opt/homebrew/share/cwb/registry/$1 ALIGNED $2

./align-cwb-cp2reg.sh demo-emea-de demo-emea-en

# cp /opt/homebrew/share/cwb/registry/demo-emea-en demo-emea-en
# cat demo-emea-en demo-emea-en-ALIGNED.txt >/opt/homebrew/share/cwb/registry/demo-emea-en