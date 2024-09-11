#! /usr/bin/python3
# author Bogdan Babych, Centre for Translation Studies, University of Leeds
# date 2008-10-14
'''
The package contains classes to work with xml-like tags, without assuming any particular content structure, e.g.,
text divided into sentences ... 
'''

import re
import sys


class file2FlatXML(object):
    '''
    the class unites functionality of the other 2 classes in this package: fileReader and flatXML
    it returns the xml units and their attributes as a list of 2-tuples, (Dictionary of features and attributes, string between xml tags)  
    '''

    def __init__(self, SFileName, STagXML):
        '''
        SFileName = the file to read 
        STagXML = the top-level xml tag to split read units
        '''
        # sys.argv[1] ## typically read from command line
        self.LT2Data = [] # main data structure: list of 2-tuples: (Dictionary, String)
        self.main(SFileName, STagXML)
        # pass
    
    def __str__(self):
        pass
    
    def __repr__(self):
        pass
    
    def __getData__(self):
        return self.LT2Data
    
    
    def main(self, SFileName, STagXML):
        OFile = fileReader(SFileName)
        # OFile.__repr__()
        SInput = OFile.__str__()
        # OXML = flatXML(SInput, 'text')
        # OXML.__repr__()    

        OCorpusXML = flatXML(SInput, STagXML)
        self.LT2Data = OCorpusXML.LDataXML # copying the feature of FlatXML class to the main data structure
        #} main

#} class file2FlatXML



    


class fileReader(object):
    '''
    returning a string for a given file name
    '''
    def __init__(self, SFileName):
        self.SFile = self.readFile(SFileName)
    
    def __repr__(self):
        sys.stdout.write(self.SFile)
    
    def __str__(self):
        return self.SFile

    def __getData__(self):
        return self.SFile
    
    def readFile(self, SFileName):
        SFile = open(SFileName, 'r').read()
        return SFile
    # readFile() def:
     
    
    #
## end: class xmlFile(object)


class flatXML(object):
    '''
    returning a list of strings or tuples, delimited by specified tags
    '''
    def __init__(self, SInput, XTag):        
        self.LDataXML = self.xmlStr2tupleList(SInput, XTag)
        
    def __repr__(self):
        sys.stdout.write(self.LDataXML)
    
    def __str__(self):
        return self.LDataXML

    def __getData__(self):
        return self.LDataXML

    
    def xmlStr2tupleList(self, SInput, XTag):
        """
        for a given string and xml tag returns the list of 2-tuples:
        (Dictionary of Attributes, StringSeparated by Tag)        
        """
        SInterpolated = '<%s(.*?)>(.+?)</%s>' % (XTag, XTag) # has to be greedy ... 
        # SInterpolatedNoAttr = '<%s.*?>(.+?)</%s>' % (XTag)

        RPat = re.compile(SInterpolated, re.MULTILINE | re.DOTALL)
        
        LT2Matches = re.findall(RPat, SInput)
        
        
        LT2DataXML = []
        for SAttr, SContent in LT2Matches:            
            '''
            processing each item in the matched list
            '''
            LAttr = re.split(' ', SAttr.strip())
            DAttr = {}
            for SAttr1 in LAttr:
                # (SFeat, SVal) = SAttr1.split('=') # one attribute
                LFeatVal = re.split('=', SAttr1); 
                if len(LFeatVal) == 2:
                    SFeat = LFeatVal[0]; SVal = LFeatVal[1]
                    DAttr[SFeat] = SVal
            LT2DataXML.append((DAttr, SContent))
            # print DAttr, SContent
        # print LT2DataXML
        return LT2DataXML
    
        # return LT2Matches
        

