#! /usr/bin/python3
# author Bogdan Babych, Centre for Translation Studies, University of Leeds
# date 2008-11-20

import sys
import re
from modFile2FlatXML import *

try:
    STagsToRemove = open('extract-pairwise2-tags2remove.txt', 'r').read()
    STagsToRemove = STagsToRemove.strip()
     
    
except:
    STagsToRemove = '<ut>.*?</ut>|<cf.*?>|</cf>|<.*?>'
    # pass


RTagsToRemove = re.compile(STagsToRemove, re.MULTILINE | re.DOTALL)


def normalise(SWithMarkup):
    SWithMarkup = re.sub('&apos;', '\'', SWithMarkup)
    SWithMarkup = re.sub('&quot;', '"', SWithMarkup)
    SWithMarkup = re.sub('&lt;', '<', SWithMarkup)
    SWithMarkup = re.sub('&gt;', '>', SWithMarkup)
    SWithMarkup = re.sub('\t', ' ', SWithMarkup)
    SWithMarkup = re.sub(RTagsToRemove, '', SWithMarkup)
    return SWithMarkup


def main():
    
    OFileWithSegments = file2FlatXML(sys.argv[1], 'tu')

    
    for DFeatures, STextXML in OFileWithSegments.__getData__():
        OTransUnit = flatXML(STextXML, 'tuv')

        for DFeaturesTUV, STextXML_TUV in OTransUnit.__getData__():
            # if DFeaturesTUV.has_key('lang'):
            if 'xml:lang' in DFeaturesTUV:
                SLangID = DFeaturesTUV['xml:lang']
                SLangID = SLangID.strip('"')
                
                OTUV = flatXML(STextXML_TUV, 'seg')
                sys.stdout.write(SLangID + ' \t')
                for DFeaturesSeg, STextXML_Seg in OTUV.__getData__():
                    STextXML_Seg = normalise(STextXML_Seg)
                
                    sys.stdout.write(STextXML_Seg)
                
                sys.stdout.write('\n')
        sys.stdout.write('\n')
        
   
## end main


main()





