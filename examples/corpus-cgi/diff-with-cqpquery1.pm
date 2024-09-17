6,7c6,8
< use CWB::CQP;
< use CWB::CL;
---
> use CQP;
> use CL;
> use utf8;
9a11
> binmode( STDOUT, ":utf8" );
45,46c47
<     # return qq{<td><input type="checkbox" name="cpos" value="$cpos"></td><td><a href="$cgipath/showcontext-cqp.pl?cpos=$cpos" target="_blank">$titleid</td>}
< 	return qq{<td><input type="checkbox" name="cpos" value="$cpos"></td><td><a href="$cgipath/showcontext.pl?cpos=$cpos" target="_blank">$titleid</td>}
---
>     return qq{<td><input type="checkbox" name="cpos" value="$cpos"></td><td><a href="$cgipath/showcontext.pl?cpos=$cpos" target="_blank">$titleid</td>}
68c69
<     my ($cposref,$broadview,$restictfn)=@_;
---
>     my ($cposref,$broadview,$restictfn,$hash4highlightingtransref)=@_;
91c92
< 	    # my $second=($sort2option eq "left") ? getword($cpos,-1) : ## next line modified from this line by Bogdan Babych,24/05/2007 
---
> 	    # my $second=($sort2option eq "left") ? getword($cpos,-1) : ## next line modified by Bogdan Babych
94,95c95,96
< 		# ($sort2option eq "leftlemma") ? getlemma($cpos,-1) : ## next line modified from this line by Bogdan Babych,24/05/2007
< 		($sort2option eq "leftlemma") ? getlemma($cpos-1) :
---
> 		# ($sort2option eq "leftlemma") ? getlemma($cpos,-1) :
> 		($sort2option eq "leftlemma") ? getlemma($cpos-1) : ## next line modified by Bogdan Babych
103a105,114
>     
>     ## MultAl
>     ## undef:: create a new dictionary for referencing multiple alignment corpora
>     ##
>     undef my %alignedMultCorpusWordAttr;
>     undef my %alignedMultCorpusLemmaAttr;
>     ## end section: MultAl
>     
>     
>     ## creating attribute parameters
105,106c116,118
< 	foreach $alignedcorpus (split ',', $parallel) {
< 	    if ($clparacorpus = new CWB::CL::Corpus $alignedcorpus) {
---
>     				## $parallel is now in UPPER CASE (see cgi.pl)
> 	foreach $alignedcorpus (split ',', $parallel) { ## foreach -- outer...
> 	    if ($clparacorpus = new CL::Corpus $alignedcorpus) {
109,111c121,141
< 	    };
< 	};
<     };
---
> 	    }; ## end: if..
> 
> 		###
> 		### addition 1 goes here: establishing all alignment attributes creating a different dictionary
> 		### 
> 		if ($alignedcorpus =~ /;/){ $alignedMult = "show"}
> 		foreach $alignedMultCorpus (split ';', $alignedcorpus){ ## ';' character is used to separate attributes of aligned parallel corpus
> 			if ($clParaMultCorpus = new CL::Corpus $alignedMultCorpus){
> 				$alignedMultCorpusWordAttr{$alignedMultCorpus} = $clParaMultCorpus->attribute('word', 'p');
> 				$alignedMultCorpusLemmaAttr{$alignedMultCorpus} = $clParaMultCorpus->attribute('lemma', 'p') || $alignedMultCorpusWordAttr{$alignedMultCorpus}				
> 			} ## end if.. -- dictionary for aligned 
> 			
> 		} ## end foreach --inner
> 		###
> 		### addition 1 end... -- Bogdan Babych, Mon 17 Nov 2008
> 	    ###
> 	    
> 	};  ## end: foreach... -- outer
> 	
> 	
>     }; ## end: if ($parallel){}
115,118c145
<     print $messages{'back'};
< 
<     # print STDOUT qq{<form name="showcontext" action="$cgipath/showcontext-cqp.pl" method="post">\n};
< 	print STDOUT qq{<form name="showcontext" action="$cgipath/showcontext.pl" method="post">\n};
---
>     print STDOUT qq{<form name="showcontext" action="$cgipath/showcontext.pl" method="post">\n};
122a150,158
> 	
> 	if($alignedMult){ ## control flag: if multiple aligned corpora ?
> 		## implement handling of multiple aligned corpora here ...
> 	my $width=45;
> 	print "<th></th><th>id</th><th width=$width\%>Source</th>\n";
> 	print "<th></th><th>id</th><th width=$width\%>$alignedcorpus</th>";
> 	
> 	}else{ ## $alignedMult else: control flag: if multiple aligned corpora ?
> 
127a164,166
> 		
> 	} ## end: $alignedMult :: control flag: aligned multiple corpora ... 
> 	
130c169
< 
---
> 	## main processing of attributes
142,144c181,210
< 	    if ($curlang eq 'ar') {
< 		($left,$right)=($right,$left);
< 	    };
---
> 
> 	    ## getting the structural attribute "segment" ########## 2009-03-17 ###########
> 	    ## 
> 	    if ($segmentattr){
> 	    	$segmentXstruc = $segmentattr->cpos2struc($cpos);
> 	    	($startX, $endX) = $segmentattr->struc2cpos($segmentXstruc);
> 	    	$segmX = getannotatedwordsStructAttrib($startX, $endX);
> 	    	if($segmX =~ m/$match/){
> 	    		$matchXStart = $-[0];
> 	    		$matchXEnd = $+[0];
> 	    		$leftX = substr($segmX, 0, $matchXStart);
> 	    		$rightX = substr($segmX, $matchXEnd);
> 	    		
> 	    	}else{
> 	    		$leftX = $left;
> 	    		$rightX = $right;
> 	    		
> 	    	}
> 	    	
> 	    	
> 	    	# $segment = "<td>$left <strong>$match</strong> $right</td><td>cpos=$cpos;start=$startX;end=$endX; $segmX</td>";
> 	    	# $segment = "<td>$leftX <strong>$match</strong> $rightX</td><td>cpos=$cpos;start=$startX;end=$endX; $segmX</td>";
> 	    	$segment = "<td>$leftX <strong>$match</strong> $rightX</td>";
> 	    }else{
> 	    	$segment = "<td>$left <strong>$match</strong> $right</td>";    	
> 	    }
> 	    ##
> 	    ## end: getting structural attribute "segment"
> 	    
> 	    
148c214
< 	    } else {
---
> 	    } else { ## if not $broadview
157c223
< 		if ($parallel) {
---
> 		if ($parallel) {  ## main logical chain for parallel concordance
159c225,286
< 		    foreach $alignedcorpus (sort keys %alignedcorpuswordattr) {
---
> 		    ### insert here the bypass: possibly different dictionary, not %alignedcorpuswordattr: create on the previous stage ::
> 		    ## to put things one after the other, not horizontally...
> 		    ## we have now $alignedMultCorpusWordAttr
> 		    
> 		    ###
> 		    ### addition 2: finding an attribute for parallel corpus
> 		    ###
> 		    ### step 1: find $alignedcorpus by $corpus: using mapping .conf file
> 		    $alignedMultCorp = $map_parallel{$corpusname};
> 		    # print STDOUT "NAME: $corpusname; $alignedMultCorp<br>\n";
> 		    
> 		    # $alignedcorpuswordattr{$alignedMultCorp} = $alignedMultCorpusWordAttr{$alignedMultCorp};
> 		    # $alignedcorpuslemmaattr{$alignedMultCorp} = $alignedMultCorpusLemmaAttr{$alignedMultCorp};
> 		    ###
> 		    ### end: addition 2 ## (not ""foreach", but exact match using dictionary...)
> 		    ###
> 		    if($alignedMult){ ### if($alignedMult){ ## to do: in future to join with the next logical chain, removing legacy functionality...
> 		    	# print STDOUT "NAME: $corpusname; $alignedMultCorp<br>\n";
> 		    
> 		    $alignedcorpusM = $alignedMultCorp;
> 		    $transstring='';  ## generating new translation string
> 		    my $alignattrM = $clcorpus->attribute(lc($alignedcorpusM), 'a');
> 			if (($alignattrM) and ($algM = $alignattrM->cpos2alg($cpos))) {
> 			    ($src_start, $src_end, $target_start, $target_end) 
> 				= $alignattrM->alg2cpos($algM) ;
> 			    foreach $parapos ($target_start..$target_end) { # collect lemmas in translation
> 				my $paraword=cleantags(getattrpos($parapos,$alignedMultCorpusWordAttr{$alignedcorpusM})); ## getting position of translated word...
> 				$transstring.=" " unless $paraword=~/^$punctuationmarks$/; ## inserting separators unless we have PUNCTUATION MARKS :: TO CORRECT BUG HERE!
> 				
> 				## BB: highlighting translations: 
> 				# test:
> 				if(exists $$hash4highlightingtransref{$paraword}){
> 					$paraword = "<strong>$paraword</strong>";
> 					
> 				}
> 				## end BB: highlighting translations: 
> 				
> 				$transstring.=$paraword;
> 				my $paralemma=$alignedMultCorpusLemmaAttr{$alignedcorpusM}->cpos2str($parapos);
> 				utf8::decode($paralemma);
> 				++$pairs{"$match\t$paralemma"} unless ($paralemma=~/^$punctuationmarks$/) or 
> 								    ($paralemma eq 'the');
> 				unless ($freq{$paralemma}) {
> 				    if (my $id=$alignedMultCorpusLemmaAttr{$alignedcorpusM}->str2id($paralemma)) {
> 					$freq{$paralemma}=$alignedMultCorpusLemmaAttr{$alignedcorpusM}->id2freq($id);
> 				    }
> 				};
> 			    }
> 			};
> 			$newtransline= prefixline("$alignedcorpusM.$target_start.$target_start",$alignedcorpusM)."<td>$transstring</td>";
> 
> 			if ($showhorizontal) { #it will be a separate row
> 			    $newtransline="<tr>$newtransline</tr>"
> 			};
> 			$fulltransline.=$newtransline;
> 		    		
> 		    	
> 		    }else{ ## if not $alignedMult :: ### if($alignedMult){:: else
> 		    	
> 		    	
> 		    	# print STDOUT "NAME: $corpusname; $alignedMultCorp<br>\n";
> 		    foreach $alignedcorpus (sort keys %alignedcorpuswordattr) { ## begin: foreach $alignedcorpus
168a296,305
> 				
> 				## BB: highlighting translations: 
> 				# test:
> 				if(exists $$hash4highlightingtransref{$paraword}){
> 					$paraword = "<strong>$paraword</strong>";					
> 					
> 				}
> 				### BB: end: highlighting translations
> 				
> 				
189a327
> 
190a329
> 				
195c334,339
< 		    }
---
> 		    } ## end: foreach $alignedcorpus ...
> 		    
> 		    	
> 		    } ### if($alignedMult){ :: end
> 		    
> 		    
199c343,346
< 			print STDOUT "<tr>",prefixline($_,$titleid),"<td>$left <strong>$match</strong> $right</td>", $fulltransline,"</tr>\n";
---
> 			# print STDOUT "<tr>",prefixline($_,$titleid),"<td>$left <strong>$match</strong> $right</td>", $fulltransline,"</tr>\n";
> 			print STDOUT "<tr>",prefixline($_,$titleid),$segment, $fulltransline,"</tr>\n";
> 			
> 			
209,211c356,360
< 	if ($latin1query) {
< 	    $searchstring=Encode::decode('utf8',$searchstring);
< 	};
---
> 
>     ## encoding problem: solution
> 	$decodedquery = $originalquery;
>     utf8::decode($decodedquery);
> 
213c362,364
< 	    printf STDOUT $messages{'exactfq'}, $outcount, $numoccur*1000000/$corpussize, $searchstring, $corpuslist;
---
> 	    printf STDOUT $messages{'exactfq'}, $outcount, $numoccur*1000000/$corpussize, $decodedquery, $corpuslist;
> 	    # printf STDOUT $messages{'exactfq'}, $outcount, $numoccur*1000000/$corpussize, $originalquery, $corpuslist;
> 	    ## encoding problem: solution
215,216c366,368
< 	    printf STDOUT $messages{'someexamples'}, $outcount, $searchstring, $corpuslist;
< 	    
---
> 	    printf STDOUT $messages{'someexamples'}, $outcount, $decodedquery, $corpuslist;
> 	    # printf STDOUT $messages{'someexamples'}, $outcount, $originalquery, $corpuslist;
> 	    ## encoding problem: solution
275,278c427
< #	$titlestr=$titleattr->struc2str($titlestruc) if $titlestruc=$titleattr->cpos2struc($cpos);
<       $titlestruc=$titleattr->cpos2struc($cpos);
<       $titlestr=$titleattr->struc2str($titlestruc) if ($titlestruc >= 0) ;
< 
---
> 	$titlestr=$titleattr->struc2str($titlestruc) if $titlestruc=$titleattr->cpos2struc($cpos);
310c459
<     if ($clcorpus = new CWB::CL::Corpus $sourcecorpus) { # open the CL interface
---
>     if ($clcorpus = new CL::Corpus $sourcecorpus) { # open the CL interface
319a469,471
> 	## added segment attribute...
> 	$segmentattr = $clcorpus->attribute("seg",'s');
> 	
333c485
<     $cqpquery = new CWB::CQP;
---
>     $cqpquery = new CQP;
351,352c503
< 
< 	$cqpquery->exec_query($searchstring);
---
> 	$cqpquery->query($searchstring);
437c588
< #    $m=~s/\&(?:quot|bquo|equo);/\"/g;
---
>     $m=~s/\&(?:quot|bquo|equo);/\"/g;
505a657,682
> sub getannotatedwordsStructAttrib{
>     my ($start,$end)=@_;
>     my $out='';
>     my $outlength=0;
>     # my $wordsize=abs($end-$start);
>     for my $offset ($start..$end) { 
> 	# my $i=$cpos+signint($end)*$offset+$start;
> 	# my $m.=cleantags(getattrpos($i,$wordattr));
> 	my $m.=cleantags(getattrpos($offset,$wordattr));
> 	$m=' '.$m unless $m=~/^$punctuationmarks$/;
> 	$outlength+=length($m);
> 	
> 	my $lemma=getattrpos($offset,$lemmaattr);
> 	my $pos=getattrpos($offset,$posattr);
> 	$m=qq{<span title="$lemma/$pos">$m</span>};
> 	if ($end<0) {
> 	    $out=$m.$out;
> 	} else {
> 	    $out.=$m;
> 	}
>     };
>     return $out;
> 
> 	
> }
> 
524d700
< 
536c712
<     } elsif (($newword,$pos)=$word=~/(.*?)\/(\S+)$/) { # this is the /N shortcut to &pos=N
---
>     } elsif (($newword,$pos)=$word=~/(.*?)\/(\S+)$/) { # this is /N shortcut to &pos=
544c720
< #	$word=lc($word) unless $curlang eq 'de'; # lemmas are all in the lower case, except for German
---
> 	$word=lc($word) unless $curlang eq 'de'; # lemmas are all in the lower case, except for German
602c778
< 	if ($onefrqc and $twofrqc and ($oedifference>0)) { #otherwise there's no need to bother with calculations
---
> 	if ($oedifference>0) { #otherwise there's no need to bother with calculations
608,610d783
< 	    $dicescore{$key} = (100 * 2 * $onetwofrqc) / ($onefrqc +$twofrqc) 
< 		if $dstat; 
< 	    
632d804
<   if ($dstat)  { print STDOUT qq{<p><a href="#Dice score">Dice score</a></p>\n\n};};
642,644d813
<   if ($dstat) {
<       printscoretable('Dice score',\%dicescore,$cutoff);
<   }
685d853
<     my $defaultattrname='lemma'; #collocates are displayed by lemma
720d887
< 	print STDERR "$! for ",$cgiquery->param("knownwordsfile"); 
752c919
< #my $cqpsyntaxonly;
---
> my $cqpsyntaxonly;
763c930
< # 	and ($ruscorpus = new CWB::CL::Corpus $cname)) {
---
> # 	and ($ruscorpus = new CL::Corpus $cname)) {
820c987
<     my $conffile=shift || './tools/messages.conf';
---
>     my $conffile=shift || '/corpora/tools/messages.conf';
830a998,1006
> sub readmapfile {
>     my $conffile=shift || '/corpora/tools/corpusmap.conf';
>     if (-f $conffile) {
> 	{eval 
> 	     require $conffile;
> 	};
>     }
> }
> 
875,876c1051,1052
< Depending on the values of global variables llstat, mistat, dstat and tstat
< the procedure populates global hash variables %loglikescore, %miscore, %dicescore  and %tscore 
---
> Depending on the values of global variables llstat, mistat and tstat
> the procedure populates global hash variables %loglikescore, %miscore and %tscore 
