#! /usr/bin/python
# author Bogdan Babych, Centre for Translation Studies, University of Leeds
# date 2008-10-15

import sys, re

def main():
    SFPrefix = sys.argv[2]
    SInput = open(sys.argv[1], 'r').read()
    LInput = re.split('\n\n', SInput)
    i=0
    for SAligned in LInput:
        i+=1
        k = 1000000 + i
        OpenTag = '<s id=' + str(k) + '>\n'
        CloseTag = '</s>\n'
        LLangs = re.split('\n', SAligned)
        for SLang in LLangs:
             
            # LTabSeparated = re.split('\t', SLang, 2)
            m = re.match('(.+?)\t(.*)', SLang, 2)


            SLangID = ''
            FileID = ''
            SData = ''

            try:
                SLangID = m.group(1)
                SData = m.group(2)
                
            except:
                SLangID = 'ERROR'
                SData = 'NONE'
            SData = OpenTag + SData + '\n' +CloseTag     
            '''
            if len(LTabSeparated) == 2:
                SLangID = LTabSeparated[0]
                SData = LTabSeparated[1]
                SData = OpenTag + SData + '\n' +CloseTag
            '''
            
            SLangID = SLangID.strip() 
            FileID = SLangID
            if FileID != '':
                FileName = SFPrefix + SLangID + '.txt'
                
                f = open(FileName, 'a')
                f.write(SData)




main()

