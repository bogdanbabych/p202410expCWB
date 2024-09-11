#!/bin/bash
echo aligning $1 $2
echo >>/opt/homebrew/share/cwb/registry/$1 ALIGNED $2
cwb-align -V seg -o $1-$2.align $1 $2 seg 1>$1-$2.log
cwb-align-encode -D $1-$2.align 1>>$1-$2.log
echo >>/opt/homebrew/share/cwb/registry/$2 ALIGNED $1
cwb-align -V seg -o $2-$1.align $2 $1 seg 1>$2-$1.log
cwb-align-encode -D $2-$1.align 1>>$2-$1.log
