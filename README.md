# p202409expCWB
experiments with CWB

## local prototype : running via localhost + apache server
### A. Description of the installation / configuration steps:

(```./docs/cwb-mac.txt``` file contains  the output of these commands)

#### A.1. Installing CWB on local machine (instructions tested for Mac Sonoma 14.6.1 (23G93))

documentation on: https://cwb.sourceforge.io/install.php

command:

~~~
brew install cwb3
~~~


#### A.2. creating directories for the registry and data

~~~
/Users/bogdan/corpora
/opt/homebrew/share/cwb/registry
~~~

#### A.3. update cpan for installing perl libraries (required by old implementation)
~~~
cpan
~~~
output:
~~~
*** Remember to add these environment variables to your shell config
    and restart your shell before running cpan again ***

PATH="/Users/bogdan/perl5/bin${PATH:+:${PATH}}"; export PATH;
PERL5LIB="/Users/bogdan/perl5/lib/perl5${PERL5LIB:+:${PERL5LIB}}"; export PERL5LIB;
PERL_LOCAL_LIB_ROOT="/Users/bogdan/perl5${PERL_LOCAL_LIB_ROOT:+:${PERL_LOCAL_LIB_ROOT}}"; export PERL_LOCAL_LIB_ROOT;
PERL_MB_OPT="--install_base \"/Users/bogdan/perl5\""; export PERL_MB_OPT;
PERL_MM_OPT="INSTALL_BASE=/Users/bogdan/perl5"; export PERL_MM_OPT;

~~~

#### A.4. as indicated above, update the file ```.bash_profile ```

the results are in ```./docs/.bash_profile*``` files


#### A.5. install cpan CWB libraries:

~~~
cpan CWB
sudo cpan CWB::CL
sudo cpan CWB::Web
sudo cpan CWB::CQI
~~~

#### A.6. install and configure apache2 web server on localhost (for prototyping)

(output and links in file ```./docs/apache-run.txt```)

Location of apache files (configuartion and logs):

~~~
apache files:
    /Library/WebServer

apache configuration:
    /private/etc/apache2
(link:)
    /etc/apache2

/private/etc/apache2/users/bogdan.conf
/private/etc/apache2/httpd.conf
/private/var/log/apache2/access_log
/private/var/log/apache2/error_log

files for local websites:
    /Users/bogdan/Sites
~~~

Running / stopping apache:

~~~

sudo /usr/sbin/apachectl restart
apachectl configtest
sudo apachectl graceful
sudo /usr/sbin/apachectl -k restart

~~~

to test Apache:
type in a browser:

```http://localhost/```


To set up a secure html connection (shtml) for apache2, look it up, e.g.:
https://www.arubacloud.com/tutorial/how-to-enable-https-protocol-with-apache-2-on-ubuntu-20-04.aspx



#### A.7. test if cgi scripts can run, and configure if necessary:
copy the perl and python scripts from ```./docs/first.pl ; ./docs/firstpython.py``` into the executable directory:

```/Library/WebServer/CGI-Executables```

~~~
http://localhost/cgi-bin/first.pl
http://localhost/cgi-bin/firstpython.py
~~~

these scripts are in ```/src/Sites``` directory in this repository

if the cgi scripts do not run, e.g., you get the error message:

~~~
Internal Server Error
The server encountered an internal error or misconfiguration and was unable to complete your request.

Please contact the server administrator at you@example.com to inform them of the time this error occurred, and the actions you performed just before this error.

More information about this error may be available in the server error log.
~~~

and in the log file ```/private/var/log/apache2/error_log```:

~~~
[Tue Sep 03 11:49:06.228461 2024] [cgi:error] [pid 8783] [client ::1:61027] AH01215: (1)Operation not permitted: exec of '/Library/WebServer/CGI-Executables/first.pl' failed: /Library/WebServer/CGI-Executables/first.pl
[Tue Sep 03 11:49:06.229403 2024] [cgi:error] [pid 8783] [client ::1:61027] End of script output before headers: first.pl
[Tue Sep 03 11:57:08.426033 2024] [cgi:error] [pid 1516] [client ::1:61157] AH01215: (1)Operation not permitted: exec of '/Library/WebServer/CGI-Executables/first.pl' failed: /Library/WebServer/CGI-Executables/first.pl
[Tue Sep 03 11:57:08.426690 2024] [cgi:error] [pid 1516] [client ::1:61157] End of script output before headers: first.pl
[Tue Sep 03 11:57:09.524812 2024] [cgi:error] [pid 8783] [client ::1:61165] AH01215: (1)Operation not permitted: exec of '/Library/WebServer/CGI-Executables/firstpython.py' failed: /Library/WebServer/CGI-Executables/firstpython.py
[Tue Sep 03 11:57:09.525722 2024] [cgi:error] [pid 8783] [client ::1:61165] End of script output before headers: firstpython.py
[Tue Sep 03 11:57:11.977947 2024] [cgi:error] [pid 8784] [client ::1:61166] AH01215: (1)Operation not permitted: exec of '/Library/WebServer/CGI-Executables/firstpython.py' failed: /Library/WebServer/CGI-Executables/firstpython.py
[Tue Sep 03 11:57:11.978335 2024] [cgi:error] [pid 8784] [client ::1:61166] End of script output before headers: firstpython.py
[Tue Sep 03 11:57:31.008452 2024] [cgi:error] [pid 8782] [client ::1:61167] AH01215: (1)Operation not permitted: exec of '/Library/WebServer/CGI-Executables/first.pl' failed: /Library/WebServer/CGI-Executables/first.pl
[Tue Sep 03 11:57:31.009494 2024] [cgi:error] [pid 8782] [client ::1:61167] End of script output before headers: first.pl
[Tue Sep 03 11:57:32.982370 2024] [cgi:error] [pid 14195] [client ::1:61169] AH01215: (1)Operation not permitted: exec of '/Library/WebServer/CGI-Executables/first.pl' failed: /Library/WebServer/CGI-Executables/first.pl
[Tue Sep 03 11:57:32.983293 2024] [cgi:error] [pid 14195] [client ::1:61169] End of script output before headers: first.pl
~~~

, you can follow the steps under this link:  
https://discussions.apple.com/docs/DOC-250007792

-- also a copy in the local directory: ```./docs/DOC-250007792.html``` , or ./docs .pdf file.

Basically, you update configuration files for your apache web server, the page tells you how to do it for your local website in the home directory /Users/bogdan/Sites, not system-wide, but possibly you can adjust the correct lines also for the system-wide configuration (I haven't tried this).

Then the local files should work, so instead you put html files and run the scripts from:

~~~
http://localhost/~bogdan/
http://localhost/~bogdan/first.pl
http://localhost/~bogdan/firstpython.py
~~~

After this, the apache2 server is configured.

### B. Copy existing corpora to test cwb

The links to downloads of the demo corpora are here:  
https://cwb.sourceforge.io/install.php#other

Copies are also in the ```./corpora/``` directory in this repository


#### B.1. move the corpora to the directory where binary corpus data will be stored, e.g. ```~/corpora/``` & unpack them

~~~
cd ~/corpora
wget https://cwb.sourceforge.io/files/DemoCorpus-German-1.0.tar.gz
wget https://cwb.sourceforge.io/files/Dickens-1.0.tar.gz 
tar xvzf DemoCorpus-German-1.0.tar.gz
tar xvzf Dickens-1.0.tar.gz
~~~

#### B.2. create corpus registry directory, as specified during cwb installation process (stage A.1.)

Copy registry files from :
~~~
/Users/bogdan/corpora/Dickens-1.0/registry
/Users/bogdan/corpora/DemoCorpus-German/registry
~~~

to this corpus register directory:
~~~
/opt/homebrew/share/cwb/registry
~~~

#### B.3. edit registry files for each corpus in the corpus registry directory, so they point to the correct data directory for each corpus:

E.g.: in ```dickens``` file edit these lines, putting the right location of the HOME directory for the corpus and INFO file:

~~~
# path to binary data files
HOME /Users/bogdan/corpora/Dickens-1.0/data
# optional info file (displayed by "info;" command in CQP)
INFO /Users/bogdan/corpora/Dickens-1.0/data/.info
~~~

, and in the ```german-law``` file, change these lines:

~~~
HOME /Users/bogdan/corpora/DemoCorpus-German/data
INFO /Users/bogdan/corpora/DemoCorpus-German/data/.info
~~~


#### B.4. Test CWB in the command line
Now the CWB has the data and can be tested on them, so make sure this runs in your terminal in the command line:

~~~
cqp
[no corpus]>
~~~

The manual on using cqp interface is here:  
https://cwb.sourceforge.io/files/CQP_Manual.pdf

(it is also in the ./docs/ directory in this repository)

The cqp session:
~~~

Bogdans-MBP:~ bogdan$ cqp
[no corpus]> show corpora;
System corpora:
 D: DICKENS
 G: GERMAN-LAW
[no corpus]> DICKENS;
DICKENS> "preserve";
    42790: d dog-kennel are - a very <preserve> of butterflies , as I rem
   469137: cled in their orbits , to <preserve> inviolate a system of whi
   480711: e covered up - perhaps to <preserve> it for the son with whom
   547487: ghton , Sussex , ' and to <preserve> them in his desk with gre
   579253: e could do no better than <preserve> her image in his mind as
   791335: ions , and as I choose to <preserve> the decencies of life , s
   855396: atly relieved . I wish to <preserve> the good opinion of all h
  1151311: creature , barely able to <preserve> her sitting posture by st
  1161944: iss Louisa that you still <preserve> that bottle . Well ! If y
  1162727: it too strong , and so we <preserve> an understanding . I say
  1265120: aming countenance he will <preserve> for half-an-hour afterwar
  1294118: , in order that she might <preserve> that appearance of being
  1324634: to a trunk were charms to <preserve> its owner from sorrow and
  1421919: onal inducement to her to <preserve> the strictest silence reg
  1518169: ldly ; ' it would help to <preserve> habits of frugality , you
  1633852: is head , and prosper and <preserve> him . She was hurrying pa
  1648475: actions , and that we may <preserve> the self-respect which a
  1655346:  situated as Squeers , to <preserve> such a friend as himself-
  1751566: awing forth her dagger to <preserve> the one at the cost of th
  2038824: mposure I would desire to <preserve> ) , and your mother , are
  2123621:  destroy it , in order to <preserve> the property to his broth
  2330196:  exerting every muscle to <preserve> the advantage they have g
  2355400: ly open ? Nonsense . Just <preserve> the order for an autograp
  2377358: ardswoman is appointed to <preserve> order , and a similar reg
  2464296: l ineffectual attempts to <preserve> his perpendicular , the y
  2532203: eman , winking upon us to <preserve> silence , won a pair of g
  2532831: hey cannot do better than <preserve> and maintain - we say , a
  2533110: ife will be , to gain and <preserve> the esteem of your husban
  2547103: they are still careful to <preserve> their character for amiab
  2551743: ntle trot , the better to <preserve> the circulation , and bri
  2642877: id the Marquis , " I will <preserve> the honour and repose of
  2696198: . It was a hard matter to <preserve> the innocent deceit of wh
  2757818:  after several efforts to <preserve> his gravity , burst into
  2833250: yed himself to and fro to <preserve> his balance , and , looki
  2859861: nt to do , but meaning to <preserve> him or be killed herself
  2915948: h , but is constrained to <preserve> a decent solemnity , and
  3062070: nsport of frenzy . ' Lord <preserve> us ! ejaculated Mr. Pickw
  3224852: their arms around them to <preserve> them from danger . An ins
  3248360:  the table a good deal to <preserve> order ; then he had a con
  3299062: smiling , but managing to <preserve> his gravity , he drew for
  3305584: at the back of a chair to <preserve> his perpendicular . Mr. S
DICKENS> GERMAN-LAW;
GERMAN-LAW> "bewahren";
    55171: eiten Verschwiegenheit zu <bewahren> . Dies gilt nicht f�r Mit
   538194: instweilen vor Schaden zu <bewahren> . � 363 . ( 1 ) Anweisung
   646075: ngt , Verschwiegenheit zu <bewahren> ; � 138 des Strafgesetzbu
GERMAN-LAW> exit;
Bogdans-MBP:~ bogdan$

~~~

If this runs, the cqp is properly configured.

### C. Test CWB throught perl CGI API via the web interface
#### C.1. Copy the html files with a cgi form to your script directory (cgi-bin, or in my case: ~/Sites)

- copy the file ```dickens.html``` from the directory ```./src/Sites/``` in this repository.

- in browser put: ```http://localhost/~bogdan/dickens.html```

- copy the cgi perl script files from this repository /src/Sites/ to your local directory ~/Sites/

You may get the messages about missing libraries:

~~~
Software error:
Can't locate smallutils.pm in @INC (you may need to install the smallutils module) (@INC contains: /corpora/tools /Library/Perl/5.34/darwin-thread-multi-2level /Library/Perl/5.34 /Network/Library/Perl/5.34/darwin-thread-multi-2level /Network/Library/Perl/5.34 /Library/Perl/Updates/5.34.1/darwin-thread-multi-2level /Library/Perl/Updates/5.34.1 /System/Library/Perl/5.34/darwin-thread-multi-2level /System/Library/Perl/5.34 /System/Library/Perl/Extras/5.34/darwin-thread-multi-2level /System/Library/Perl/Extras/5.34) at /Library/WebServer/CGI-Executables/cqp.pl line 13.
BEGIN failed--compilation aborted at /Library/WebServer/CGI-Executables/cqp.pl line 13.
For help, please send mail to the webmaster (you@example.com), giving this error message and the time and date of the error.
~~~

To fix this:

https://stackoverflow.com/questions/48733474/cant-locate-gdbm-file-pm

~~~
cpan GDBM_File
~~~

or simply comment the line:
use GDBM_File




If there are any further problems with @INC variable:  

~~~
Software error:
Can't locate smallutils.pm in @INC (you may need to install the smallutils module) (@INC contains: /corpora/tools /Library/Perl/5.34/darwin-thread-multi-2level /Library/Perl/5.34 /Network/Library/Perl/5.34/darwin-thread-multi-2level /Network/Library/Perl/5.34 /Library/Perl/Updates/5.34.1/darwin-thread-multi-2level /Library/Perl/Updates/5.34.1 /System/Library/Perl/5.34/darwin-thread-multi-2level /System/Library/Perl/5.34 /System/Library/Perl/Extras/5.34/darwin-thread-multi-2level /System/Library/Perl/Extras/5.34) at /Library/WebServer/CGI-Executables/cqp.pl line 13.
BEGIN failed--compilation aborted at /Library/WebServer/CGI-Executables/cqp.pl line 13.
For help, please send mail to the webmaster (you@example.com), giving this error message and the time and date of the error.
~~~

Update the ```use lib ("/dir1", "/dir2");``` line in the script, to point to the location of the python tools used by the scripts..

https://stackoverflow.com/questions/2526804/how-is-perls-inc-constructed

Update any links and references in the scripts, which point to a different location

The structure of the scripts / files used here is the following:

Scripts and html files
~~~
/Users/bogdan/Sites/
    cqp.conf		cqp.pl.v01		dickens.html.v01	firstpython.py		index.html.en		jscript			tools
    cqp.pl			dickens.html		first.pl		grm-en.html		info.pl			query.log

/Users/bogdan/Sites/tools
    cqp.conf	cqpquery1.pm	messages.conf	smallutils.pm
~~~

#### C.2. Test queries, correct errors in the cgi scripts if any

put the search line, e.g.: (% means lemma)

question
acquit% 
...

test concordance and collocation functionality, showing contexts, etc.



### D. Compile a new corpus
#### D.1. Monolingual corpus

- Download some corpus data into a text file. The example is in in file:  
p202409expCWB/corpora101/plain-text-101.txt (these are OpenAI Whisper transcription of some German medical podcasts, around 150k words)

- (this step is optional; you can use it only if you need linguistic annotation, such as part-of-speech and lemma annotation):  
Download a part-of-speech TreeTagger from LancsBox:
http://corpora.lancs.ac.uk/lancsbox/download.php

- install and locate the TreeTagger, e.g.:  
```/Users/bogdan/LancsBox/resources/tagger```

- copy the file ```tree-tagger-german2.sh``` and ```stage01run-TreeTagger.sh``` to the directory ```/Users/bogdan/LancsBox/resources/tagger/bin```
and run the script ```stage01run-TreeTagger.sh``` (from the ```resources/tagger/bin``` directory)
``` ```

the output should look like:

~~~
bash-3.2$ ./tree-tagger-german2.sh </Users/bogdan/elisp/proj/p202409expCWB/corpora101/plain-text-101.txt >/Users/bogdan/elisp/proj/p202409expCWB/corpora101/med-podc-de102.vert
	reading parameters ...
	tagging ...
188000	 finished.
~~~

> alternatively, you can:  

- use the GitHub/colab tagger (TreeTagger or Stanza) on 
```https://github.com/iued-uni-heidelberg/corpustools/tree/main```

repositories / examples: 

https://github.com/iued-uni-heidelberg/corpustools/blob/main/S101lemDE.ipynb  
https://github.com/iued-uni-heidelberg/corpustools/blob/main/S101lemHYstanza.ipynb  

The output should be a 3-column file with the fields: word \t part-of-speech \t lemma, like here:   
Du	PPER	du  
hörst	VBFIN	hören  
den	ART	die  
Hormon	NN	Hormon  
Reset	NN	Reset  
Podcast	NN	Podcast  
.	$.	.  


> alternatively, you can download a local installation of spacy:

see help on: https://stackoverflow.com/questions/47295316/importerror-no-module-named-spacy-en

```sudo pip3 install spacy```  
```sudo python3 -m spacy download en```

(still doesn't work on my Mac)



After the 3-column .vert file is created: 

- create the data directory to put the compiled corpus, e.g.:
```mkdir /Users/bogdan/corpora/demo-podc-de``` 

-- run the corpus compilation script:  
```/Users/bogdan/elisp/proj/p202409expCWB/corpora101/stage02compile-corpus/run101-compile-corpus-med-podc-de102.sh```

the commands there use the cwb external scripts for corpus compilation:

~~~
cwb-encode -d /Users/bogdan/corpora/demo-podc-de -xsBC9 -c utf8 -R /opt/homebrew/share/cwb/registry/demo-podc-de -P pos -P lemma < ./med-podc-de102.vert
cwb-make -M 800 demo-podc-de

~~~

here the data directory, the encoding, registry file, the positional (and optionally -- strucural (via -S)) attributes are specified
After this commmand is complete, you can add the reference to the corpus into the search interface (html file), see example on

```demoTRN.html``` file in this repository under
``` p202409expCWB/src/Sites/ ```

you can query this corpus the same way how the demo corpora have been queried. All should work the same way, just type in your browser:  
```http://localhost/~bogdan/demoTRN.html ```



#### D.2. Bilingual parallel corpus

In the current implementation, CWB compiles two separate monolingual corpora and 'alignes' them using 'alignment attiributes', which use structural attributes, typically a 'segment' with an xml identifier attribute, e.g., ``` '<s id=101>' ```; the identifiers in the aligned segments need to be the same in both coprora. 

In this pipeline, the input should be in ```tmx``` (translation memory exchange) format. Some files can be donloaded from this website:

https://opus.nlpl.eu/results/en&de/corpus-result-table

Follow the steps (consequently run the scripts in ./stage03parallel-tmx)



possible error (solution: check the script files)
~~~
bash-3.2$ ./st03run-alignment-script.sh
bash-3.2$ ./st03run-alignment-script.sh
aligning demo-emea-de demo-emea-en
attributes:setup_attribute(): Warning:
  Attribute demo-emea-en of type Alignment Attribute already defined in corpus demo-emea-de
REGISTRY ERROR (/opt/homebrew/share/cwb/registry/demo-emea-de): Alignment attribute demo-emea-en declared twice -- semantic error
REGISTRY ERROR (/opt/homebrew/share/cwb/registry/demo-emea-de): Error parsing the main Registry structure.
cwb-align: can't open corpus demo-emea-de
demo-emea-de-demo-emea-en.align: No such file or directory
cwb-align-encode: can't read file demo-emea-de-demo-emea-en.align
attributes:setup_attribute(): Warning:
  Attribute demo-emea-de of type Alignment Attribute already defined in corpus demo-emea-en
REGISTRY ERROR (/opt/homebrew/share/cwb/registry/demo-emea-en): Alignment attribute demo-emea-de declared twice -- semantic error
REGISTRY ERROR (/opt/homebrew/share/cwb/registry/demo-emea-en): Error parsing the main Registry structure.
cwb-align: can't open corpus demo-emea-en
demo-emea-en-demo-emea-de.align: No such file or directory
cwb-align-encode: can't read file demo-emea-en-demo-emea-de.align

~~~


##### D.2.1. Downloading a parallel corpus in tmx format

This is an example of connecting Europarl corpus to the infrastructure.

- Download the corpus from https://object.pouta.csc.fi/OPUS-Europarl/v8/tmx/de-en.tmx.gz

- Extract it: ``` gunzip de-en.tmx.gz ```

##### D.2.2. Extracting lines from the tmx file

- in the download directory run  
``` /Users/bogdan/elisp/proj/p202410expCWB/corpora101/stage03parallel-tmx/st0301extract-text-from-tmx/extract-pairwise2.py de-en.tmx >demo-europarl-de-en-lines.txt ```

(adjusting the absolute or relative path for your source directory)

- the input looks like:

~~~
<?xml version="1.0" encoding="UTF-8" ?>
<tmx version="1.4">
<header creationdate="Sat Jun 29 17:46:50 2019"
          srclang="de"
          adminlang="de"
          o-tmf="unknown"
          segtype="sentence"
          creationtool="Uplug"
          creationtoolversion="unknown"
          datatype="PlainText" />
  <body>
    <tu>
      <tuv xml:lang="de"><seg>Ich erkläre die am Freitag, dem 17. Dezember unterbrochene Sitzungsperiode des Europäischen Parlaments für wiederaufgenommen, wünsche Ihnen nochmals alles Gute zum Jahreswechsel und hoffe, daß Sie schöne Ferien hatten.</seg></tuv>
      <tuv xml:lang="en"><seg>I declare resumed the session of the European Parliament adjourned on Friday 17 December 1999, and I would like once again to wish you a happy new year in the hope that you enjoyed a pleasant festive period.</seg></tuv>
    </tu>
    <tu>
      <tuv xml:lang="de"><seg>Wie Sie feststellen konnten, ist der gefürchtete "Millenium-Bug " nicht eingetreten. Doch sind Bürger einiger unserer Mitgliedstaaten Opfer von schrecklichen Naturkatastrophen geworden.</seg></tuv>
      <tuv xml:lang="en"><seg>Although, as you will have seen, the dreaded 'millennium bug' failed to materialise, still the people in a number of countries suffered a series of natural disasters that truly were dreadful.</seg></tuv>
    </tu>
    <tu>
      <tuv xml:lang="de"><seg>Im Parlament besteht der Wunsch nach einer Aussprache im Verlauf dieser Sitzungsperiode in den nächsten Tagen.</seg></tuv>
      <tuv xml:lang="en"><seg>You have requested a debate on this subject in the course of the next few days, during this part-session.</seg></tuv>
    </tu>

~~~


- the output should look like:

~~~
de 	Ich erkläre die am Freitag, dem 17. Dezember unterbrochene Sitzungsperiode des Europäischen Parlaments für wiederaufgenommen, wünsche Ihnen nochmals alles Gute zum Jahreswechsel und hoffe, daß Sie schöne Ferien hatten.
en 	I declare resumed the session of the European Parliament adjourned on Friday 17 December 1999, and I would like once again to wish you a happy new year in the hope that you enjoyed a pleasant festive period.

de 	Wie Sie feststellen konnten, ist der gefürchtete "Millenium-Bug " nicht eingetreten. Doch sind Bürger einiger unserer Mitgliedstaaten Opfer von schrecklichen Naturkatastrophen geworden.
en 	Although, as you will have seen, the dreaded 'millennium bug' failed to materialise, still the people in a number of countries suffered a series of natural disasters that truly were dreadful.

de 	Im Parlament besteht der Wunsch nach einer Aussprache im Verlauf dieser Sitzungsperiode in den nächsten Tagen.
en 	You have requested a debate on this subject in the course of the next few days, during this part-session.
~~~

##### D.2.2. Create monolingual files with segment IDs for tagging

- Run the script to create monolingual files for processing with TreeTagger or stanza/spacy:
``` python3 /Users/bogdan/elisp/proj/p202410expCWB/corpora101/stage03parallel-tmx/st0302lines2segments4tagging/005genFilesSegID.sh demo-europarl-de-en-lines.txt demo-europarl-de-en-lang- ```


(adjust absolute or relative path to the script accordingly)

Note: If the input file is in Moses format, this stage needs to be adjusted to create segment IDs from Moses input.


The output of the stage (for German) should look like:

~~~
<s id=1000001>
Ich erkläre die am Freitag, dem 17. Dezember unterbrochene Sitzungsperiode des Europäischen Parlaments für wiederaufgenommen, wünsche Ihnen nochmals alles Gute zum Jahreswechsel und hoffe, daß Sie schöne Ferien hatten.
</s>
<s id=1000002>
Wie Sie feststellen konnten, ist der gefürchtete "Millenium-Bug " nicht eingetreten. Doch sind Bürger einiger unserer Mitgliedstaaten Opfer von schrecklichen Naturkatastrophen geworden.
</s>
<s id=1000003>
Im Parlament besteht der Wunsch nach einer Aussprache im Verlauf dieser Sitzungsperiode in den nächsten Tagen.
</s>

~~~

##### D.2.3. Run a tagging tool (TreeTagger, Stanza/Spacy, TNT, etc)

- You will need to create a .vert file with 3 columns -- word, pos, lemma using one of these tools.

- for TreeTagger, you can run the following from the TreeTagger /bin/ directory (adjust the paths to the files):

~~~
# run from the bin/ Tree tagger directory
./tree-tagger-german-utf8.sh </Users/bogdan/corpora-sourse/europarl-en-de/demo-europarl-de-en-lang-de.txt >/Users/bogdan/corpora-sourse/europarl-en-de/demo-europarl-de-en-lang-de.vert
./tree-tagger-english-utf8.sh </Users/bogdan/corpora-sourse/europarl-en-de/demo-europarl-de-en-lang-en.txt >/Users/bogdan/corpora-sourse/europarl-en-de/demo-europarl-de-en-lang-en.txt
~~~

The output should look like this:

~~~

<s id=1000001>
Ich	PPER	ich
erkläre	VBFIN	erklären
die	ART	die
am	APPRART	an
Freitag	NN	Freitag
,	$,	,
dem	PRELS	die
17	CARD	17
.	$.	.
Dezember	NN	Dezember
unterbrochene	ADJA	unterbrochen
Sitzungsperiode	NN	Sitzungsperiode
des	ART	die
Europäischen	ADJA	europäisch
Parlaments	NN	Parlament
für	APPR	für
wiederaufgenommen	VBPP	wiederaufnehmen
,	$,	,
wünsche	VBFIN	wünschen


~~~

(note that the segment id tags are preserved)

.vert files are compled an aligned with the cwb tools


##### D.2.4. Compile both corpora, create alignment attributes

- create the data directories for BOTH monolingual corpora, e.g.:

~~~
mkdir /Users/bogdan/corpora/demo-europarl-ende-en
mkdir /Users/bogdan/corpora/demo-europarl-ende-de
~~~


- run the cwb corpus compilation tools from .vert sources

~~~
cwb-encode -d /Users/bogdan/corpora/demo-europarl-ende-en -xsBC9 -c utf8 -R /opt/homebrew/share/cwb/registry/demo-europarl-ende-en -P pos -P lemma -V s <demo-europarl-de-en-lang-en.vert
cwb-make -M 800 demo-europarl-ende-en
cwb-describe-corpus demo-europarl-ende-en

cwb-encode -d /Users/bogdan/corpora/demo-europarl-ende-de -xsBC9 -c utf8 -R /opt/homebrew/share/cwb/registry/demo-europarl-ende-de -P pos -P lemma -V s <demo-europarl-de-en-lang-de.vert
cwb-make -M 800 demo-europarl-ende-de
cwb-describe-corpus demo-europarl-ende-de

~~~

- the output on the screen will be:


~~~

============================================================
Corpus: demo-europarl-ende-en
============================================================

description:
registry file:  /opt/homebrew/share/cwb/registry/demo-europarl-ende-en
home directory: /Users/bogdan/corpora/demo-europarl-ende-en/
info file:      /Users/bogdan/corpora/demo-europarl-ende-en/.info
encoding:       utf8
size (tokens):  53914520

  3 positional attributes:
      word            pos             lemma

  1 structural attributes:
      s

  0 alignment  attributes:



============================================================
Corpus: demo-europarl-ende-de
============================================================

description:
registry file:  /opt/homebrew/share/cwb/registry/demo-europarl-ende-de
home directory: /Users/bogdan/corpora/demo-europarl-ende-de/
info file:      /Users/bogdan/corpora/demo-europarl-ende-de/.info
encoding:       utf8
size (tokens):  51376596

  3 positional attributes:
      word            pos             lemma

  1 structural attributes:
      s

  0 alignment  attributes:


~~~

- this means that the monolingual corpora has been created successfully, but they are still not aligned


##### D.2.5. Create the alignment attributes for the corpora

- You just need to add the 'alignment' attribute to each register file. To do this, run:

```/Users/bogdan/elisp/proj/p202410expCWB/corpora101/stage04compile-parallel/align-cwb-cp2reg.sh demo-europarl-ende-en demo-europarl-ende-de
```  
(adjust the path to the script file)

The result -- both registry files will change. For example, the German registry file will look like this:

~~~
##
## registry entry for corpus DEMO-EUROPARL-ENDE-DE
##

# long descriptive name for the corpus
NAME ""
# corpus ID (must be lowercase in registry!)
ID   demo-europarl-ende-de
# path to binary data files
HOME /Users/bogdan/corpora/demo-europarl-ende-de
# optional info file (displayed by "info;" command in CQP)
INFO /Users/bogdan/corpora/demo-europarl-ende-de/.info

# corpus properties provide additional information about the corpus:
##:: charset  = "utf8" # character encoding of corpus data
##:: language = "??"     # insert ISO code for language (de, en, fr, ...)


##
## p-attributes (token annotations)
##

ATTRIBUTE word
ATTRIBUTE pos
ATTRIBUTE lemma


##
## s-attributes (structural markup)
##

# <s> ... </s>
STRUCTURE s                    # [annotations]


# Yours sincerely, the Encode tool.
ALIGNED demo-europarl-ende-en
~~~

-- note the last line, which indicates alignment


##### D.2.6. Run the alignment script (might take a few minutes)


- Finally, run the cwb alignment script:

``` /Users/bogdan/elisp/proj/p202410expCWB/corpora101/stage04compile-parallel/align-cwb.sh demo-europarl-ende-en demo-europarl-ende-de
 ```

(adjust the path to the script)

The screen output will be:

~~~
aligning demo-europarl-ende-en demo-europarl-ende-de


~~~

The result -- alx files will be created in the data directory, e.g.:

```demo-europarl-ende-en.alx```

All scripts are in the directory

```/Users/bogdan/elisp/proj/p202410expCWB/corpora101/example-scripts-parallel-europarl```


##### D.2.7. Finally, add the refernces into your html file





