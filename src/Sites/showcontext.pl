#!/usr/bin/perl
#CGI script for showing larger context for selected lines

# load needed modules
#use utf8;
use CGI;
use CGI::Carp qw/fatalsToBrowser/;
use CWB::CL;
# use lib("/corpora/tools");
use lib("./tools");
use smallutils;
# use cqpquery;
use cqpquery1;

$CGI::POST_MAX = 50 * 1024;			# avoid denial-of-service attacks
$CGI::DISABLE_UPLOADS = 1;			# (no file uploads, accept max. 50k of POST data)

readconffile();
readmessagefile();

$query = new CGI;
@cposlist=$query->param('cpos');
#@cposlist=qw/ZN-UA.48031.48031 ZN-UA.63756.63756/;
$totalexamples=scalar(@cposlist);

if ($contextsize=$query->param('contextsize')) {
    $contextsize=~s/\D+//g;
    $contextsizewords=min(500,$contextsize);
} else {
    $contextsizewords=70; # the default value
}

$charsize=$contextsizewords*6;
$sort1option="document";

# START PRINTING HTML OUTPUT!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

# first print an explicit HTTP header
print "Content-type: text/html\; charset=$encoding\n\n";
print qq{<html><head><meta http-equiv="Content-Type" content="text/html; charset=$encoding">\n};
print qq{<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
<head>
<meta http-equiv="content-type" content="text/html; charset=$encoding" />
<meta name="Author" content="Serge Sharoff, hacked by Marco Baroni, ripped by Emiliano Guevara" />
<meta name="Keywords" content="Web Corpus" />
<link href="/corpus.css" rel="stylesheet" type="text/css">
};

printf "<title>$messages{'exampleselection'}</title>\n", $totalexamples;

print qq{</head>\n<body>\n<div id="website">};

# print HTML htitle for each context
if ($totalexamples) {
  printf "<h2>$messages{'exampleselection'}</h2>\n",$totalexamples;
  showconcordance(\@cposlist,1)
} else {
    print $messages{'noexampleselection'}
}

# close page HTML
print qq{
</div>
</body>
<\html>\n};

