#!/usr/bin/perl
#CGI script for accessing CWB files
#die "unknown error\n"
use utf8;
use CGI;
use CGI::Carp qw/fatalsToBrowser/;
use Encode qw/encode decode/;
use GDBM_File;
use CQP;
use CL;
use Getopt::Long;
use lib("/corpora/tools");
use smallutils;
use paralcqpquery;

#use strict;

$CGI::POST_MAX = 50 * 1024; # avoid denial-of-service attacks (accept max. 50k of POST data)
$spammessagelimit=1000;
binmode( STDOUT, ":utf8" );

readconffile('/corpora/tools/cqp.conf');
readmessagefile('/corpora/tools/messages.conf');
readmapfile('/corpora/tools/corpusmap.conf');

$|=1;

$originalquery=""; # the search string
$parallel;

## gdbm functionality
$gdbmLocation = "/corpora/dict/gdbm";

$cgiquery = new CGI;

$corpuslist=uc(  $cgiquery->param("c") || $cgiquery->param("corpuslist") );
if ($corpuslist) { # CGI run
    $cqpsyntaxonly=$cgiquery->param("cqpsyntaxonly");
    $defaultattrname=$cgiquery->param("searchpositional") || $cgiquery->param("da") || $defaultattrname;

    @parallel=$cgiquery->param("parallel");
    $parallel=uc(join(',',@parallel));

    $originalquery= $cgiquery->param("q") || $cgiquery->param("searchstring");
    die if length($originalquery)>$spammessagelimit;
    $contextsize=$cgiquery->param("cs") || $cgiquery->param("contextsize")|| $contextsize;
    $sort1option=$cgiquery->param("sort1") || $cgiquery->param("s1");
    $sort2option=$cgiquery->param("sort2") || $cgiquery->param("s2");
    $terminate=$cgiquery->param("terminate") || $cgiquery->param("t") || $terminate;
    $terminate=min($terminate,$terminatemax);

    $transliterateout=$cgiquery->param("transliterateout");
    $transliteratein=$cgiquery->param("transliteratein");
    $showtranslations=$cgiquery->param("showtranslations");  # this is for interfacing a dictionary
    $annot=$cgiquery->param("annot");

    $collocationstat=(lc($cgiquery->param("searchtype") eq 'colloc'));
    $mistat=$cgiquery->param("mistat");
    $tstat=$cgiquery->param("tstat");
    $llstat=$cgiquery->param("llstat");
    $cutoff=$cgiquery->param("cutoff") || $cutoff;
    $collocspanleft=$cgiquery->param("collocspanleft") || $cgiquery->param("cleft");
    $collocspanright=$cgiquery->param("collocspanright") || $cgiquery->param("cright");
    $collocfilter=$cgiquery->param("collocfilter") || $cgiquery->param("cfilter");

    $learningrestrictlist=$cgiquery->param("learningrestrictlist");

    $encoding=$cgiquery->param("encoding") || $encoding;
    
    ## gdbm functionality 2009/06/17
    $transdict=$cgiquery->param("transdict") || $transdict;
    $showtransdict = $cgiquery->param("showtransdict") || $showtransdict;
    $transdicttop = $cgiquery->param("transdicttop") || $transdicttop;
    ## end : gdbm functionality    

#    $similaritysearch=$cgiquery->param("f");
    $debuglevel=$cgiquery->param('debuglevel') || $debuglevel;
} else { # non-CGI
    undef $cgiquery;
    
    ## added $transdict: gdbm functionality (last 3 parameters)
    GetOptions ('D=s' => \$corpuslist, 'parallel=s' => \$parallel, 'align=i' => \$showhorizontal, 'q=s' => \$originalquery, 's1=s' => \$sort1option, 's2=s' => \$sort2option, 'ini=s' => \$inifile, 'context=s' => \$contextsize, 
	'terminate=i' => \$terminate, 'coll=i' => \$collocationstat, 'vector=i' => \$maxvector, 'measure=s' => \$measure, 
	'leftspan=i' => \$collocspanleft, 'rightspan=i' => \$collocspanright, 'filter=s' => \$collocfilter, 'dictionary=s' => \$dictionary, 
	'span=i' => \$spansize, 'help' => \$help, 'transdict=s' => \$transdict, 'showtransdict=s' => \$showtransdict, 'transdicttop=s' => \$transdicttop);
    $corpuslist=uc($corpuslist);
    if ($parallel) {
	@parallel=split ',',$parallel;
    };


    if ($collocationstat) {
	$contextsizecl='1w';
	if ($measure) {
	    $mistat=$measure=~/M/;
	    $tstat=$measure=~/T/;
	    $llstat=$measure=~/L/;
	} else {
	    $llstat=1;
	}
    }
    if (-r $inifile) {
	require($inifile);
    }
}

open(STDLOG, ">>:utf8", "/corpora/query.log") or die "Cannot open the log file.";
print STDLOG "\n\n";

$starttime=scalar(localtime());
print STDLOG "Local time: $starttime; ";
$starttime=time();

if ($debuglevel) {
    open(DEBUGLOG, ">>:utf8", "/corpora/debug.log") or print STDLOG "Attempted write to debug failed: $!\n";
    printdebug("Local time:",scalar(localtime()),"; script $0\n");
};

$curlang=$corpuslang{$corpuslist} || 'en';

if ($curlang eq 'en') { # these are the standard source and target language corpora
    $dict=$dictionaryenru;
    $cname='BNC';
    $newcorpus='RRC';
} elsif  ($curlang eq 'ru') {
    $dict=$dictionaryruen;
    $cname='RRC';
    $newcorpus='BNC';
};

if ($learningrestrictlist) {
    $learningrestrictstr=getlearningrestrictlist($cgiquery);
}

($contextsize, $contexttype)=$contextsize=~/(\d+)\s*(\w*)/;
$contextsizewords=$contextsize;
if ($contexttype eq 's') {
    $contextsize=min($contextsize,3);
    $contextsizewords=$contextsize*15;
} elsif ($contexttype eq 'c') {
    $charsize=min($contextsize,150);
} else {
    $charsize=min($contextsize*6,30);
    $contexttype='word';
}

#get information about the query with appropriate guessing
$remote_host=getremotehost($cgiquery) if $cgiquery;
#die if $remote_host=~/primacom.net/;
# preprocess the query
#utest($originalquery);
if ($originalquery=~/\xC3[\x80-\xBF]/) {
    $latin1query=1;
    $searchtitle=decode('utf8',"$corpuslist: $originalquery");
    utf8::upgrade($originalquery);
} else {
    utf8::upgrade($originalquery);
    $originalquery=decode('utf8',$originalquery);
    $searchtitle="$corpuslist: $originalquery";
}


print "Content-type: text/html\; charset=$encoding\n\n";
print qq{<html><head><meta http-equiv="Content-Type" content="text/html; charset=$encoding">\n};
print qq{<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
<head>
<meta http-equiv="content-type" content="text/html; charset=$encoding" />
<meta name="Author" content="Serge Sharoff, hacked by Marco Baroni, ripped by Emiliano Guevara" />
<meta name="Keywords" content="Web Corpus" />
<title>$searchtitle</title>
<link href="corpus.css" rel="stylesheet" type="text/css">
};

print qq{</head>\n<body>\n<div id="website">};


## gdbm functionality 2009/06/17
if( $transdict and $showtransdict){
	my $dictname = "$gdbmLocation/$transdict.gdbm";
	if(tie(%gDBMf, "GDBM_File", $dictname, &GDBM_READER, 0660)){
		($transterms, $transtermsplainhash) = transdictlookup($originalquery);
		# @transterms = @$transterms;
		# $transstring = transdictlookup($originalquery);
		
		$transstring = join("\n<br><br>\n", @$transterms);
		
		## 2 lines for testing
		# @transtermsplainlist = sort keys(%$transtermsplainhash);
		# $transtermsplainstring = join(";", @transtermsplainlist);
		
		untie(%gDBMf);
		$decodedquery = $originalquery;
		utf8::decode($decodedquery);
		print "<br> \n Computed translations for: <strong> $decodedquery </strong> <br><br> \n $transstring <br><br>\n";
		# print $transstring ;	
	}else{
		# print qq{ Dictionary not found <br>}
	}	
} 
## end: gdbm functionality

$searchstring=makecqpquery($originalquery);

if ($collocationstat) {
    $terminate=0;
    $contextsize=1;
    $contexttype='word';
    if ($collocspan) {
	$collocspan=min($maxcollocspan,$collocspan);
	$collocspanleft=$collocspan unless defined $collocspanleft;
	$collocspanright=$collocspan unless defined $collocspanright;
    };
    if (($collocfilter) and ($collocfilter=~/\S/)){
	eval {$searchstring=~/$collocfilter/};
	if ($@) {
	    cqperror( $messages{'filter-error'}," $@\n");
	}
    } else {
	undef $collocfilter;
    }
} else {
    if ($terminate) {$searchstring.=" cut $terminate"};
}


print STDLOG "corpuslist=$corpuslist; \n";
print STDLOG "Using $learningrestrictlist known words per example. " if $learningrestrictlist;
print STDLOG "remote_host=$remote_host\n" unless $remote_host=~/leeds.ac.uk/;
print STDLOG "$searchstring"; # it'll be followed by the number of occurrences, if we do not die

#print STDOUT "<p><strong>Query</strong>:$searchstring</p>";

if ($originalquery=~/^\s*\[?\]?\s*$/) {
    print STDOUT $messages{'empty-condition'};
} elsif (($collocationstat) and ! (($mistat) or ($tstat) or ($llstat))) {
    print STDOUT $messages{'choose-score'};
} else { ## main logical chain: generation of concordances
    $cqpprocesstime=0;
    if ($corpuslist eq 'RU') {
	$numoccur+=processcorpus('RRC',$searchstring);
	$numoccur+=processcorpus('INTERNET-RU',$searchstring);
	$numoccur+=processcorpus('NEWS-RU',$searchstring);
    } elsif ($corpuslist eq 'EN') {
	$numoccur+=processcorpus('BNC',$searchstring);
	$numoccur+=processcorpus('NEWS-GB', $searchstring);
	$numoccur+=processcorpus('INTERNET-EN', $searchstring);
    } elsif ($corpuslist eq 'DE-WAC') {
	foreach $part (1 .. 10) {
	    $corpus = sprintf "DEWAC%02d", $part;
	    $numoccur+=processcorpus($corpus, $searchstring);
	}
    } else {
	@corpuslist=split ',', $corpuslist;
	foreach $corpus (@corpuslist) {
	    $numoccur+=processcorpus($corpus, $searchstring); # main function which generates concordance
	}
    };

    if ($errormessage) {
#the error message has been printed anyway
    } else {
	if ($collocationstat) {
	    print STDLOG "Colloc: left=$collocspanleft, right=$collocspanright, collocfilter=$collocfilter\n";
	    $numoccur=$totalpairs;
	    showcollocates();
	} elsif ($numoccur) {
		## BB: dbmf functionality: fork introduced for highlighting translations from GIZA++ dictionary
		if($showtransdict){ ## if we have a translation dictionary, from which we want to highlight computed translations...
			showconcordance(\@storecontexts,0,UNDEF,$transtermsplainhash); ## main function which displays concordance
		}else{ ## if we don't have translation dictionary, so we cannot highlight computed translations...
			showconcordance(\@storecontexts,0); ## main function which displays concordance
		}
	    
	}
	elsif ($learningrestrictlist) {  
	    printf $messages{'noknownwords'},$learningrestrictstr;
	} else {
	    # $searchstring = decode('utf8', $searchstring)
	    printf $messages{'notfound'}, $searchstring, $corpuslist, $curlang;
	};
	print STDLOG " occurred $numoccur time(s). ";
	$processtime=time()-$starttime;
	print STDLOG "Total process time: $processtime sec; CQP process time: $cqpprocesstime sec.\n";
    }
};

print STDOUT "</html>\n";
close(STDLOG);

sub utest {
$x=(utf8::is_utf8($_[0])) ? utf8 : noutf8;
print STDERR length($_[0]),": $x, $_[0]\n";
}

sub transdictlookup{
	my ($originalquery) = @_;
	my $transstring = "";
	my @transterms = ();
	my %transtermsplainlist = ();
	@queryterms = split(' ', $originalquery);
	


	foreach $queryterm (@queryterms){
		if ($queryterm eq ""){ next; }
		# utf8::encode($queryterm); ## the original query is not encoded at this stage
		if( exists $gDBMf{$queryterm} ){
			$translation = $gDBMf{$queryterm};
		}else{
			$translation = "Not found";
		}
	
		utf8::decode($translation);
		utf8::decode($queryterm);
		
		if($transdicttop >= 0){ # need to type in a negative number to go over the initial path -- no restrictions, no highlighting... all new functionality to be implemented here...
			@translationlist = split(' ', $translation);
			@translationlistsselect = ();
			foreach $utranslation (@translationlist){
				($word, $value) = split(':', $utranslation);
				if( $value >= $transdicttop){
					push(@translationlistsselect, $utranslation);
					$word =~ s/ +$//;
					# push(@transtermsplainlist, $word);
					$transtermsplainlist{$word}++;
				}else{
					last;
				}
				
			}
			$translationselectstring = join(' ', @translationlistsselect);
			$transentry = "<strong>$queryterm</strong> = $translationselectstring";
			
		}else{
			$transentry = "<strong>$queryterm</strong> = $translation";
			
		}
		push(@transterms, $transentry)	
	}		
		
	# $transstring = join("\n<br><br>\n", @transterms);
	return \@transterms, \%transtermsplainlist;
	
}
	
	


