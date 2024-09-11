#! /usr/bin/python
# author Bogdan Babych, Centre for Translation Studies, University of Leeds
# date 2008-10-14
'''
Tokenising a string, or a list of tuples, which may contain strings at top level.
Presenting the output in the form readable for Corpus Workbench (CWB) 
'''

import re
import sys
import os


class wordSplitter(object):
    '''
    splits a given string into words
    '''
    # def __init__(self, SToSplit, SFileNameCfg):
    def __init__(self, SToSplit, DRConfig):
        '''
        monotonic function:: operates on the same string, and adds new splits on top on existing ones
        '''
        if type(DRConfig) == dict:

            if DRConfig.has_key('splitcharacters') and DRConfig['splitcharacters'] != '':
                self.SSegsXML = self.splitStringByWord(SToSplit, sep = DRConfig['splitcharacters'])
                
            if DRConfig.has_key('splitboundaries') and DRConfig['splitboundaries'] != '':
                self.SSegsXML = self.splitStringByBoundary(self.SSegsXML, DRConfig['splitboundaries'])

            if DRConfig.has_key('splitafterbound') and DRConfig['splitafterbound'] != '':
                # self.SSegsXML = self.splitStringByBoundary(self.SSegsXML, DRConfig['splitafterbound'])
                self.SSegsXML = self.splitStringAfterBoundary(self.SSegsXML, DRConfig['splitafterbound'])
            
            if DRConfig == {}:
                self.SSegsXML = self.splitStringByWord(SToSplit)
                
            
            
        else:  ## if type(DRConfig) is not dict
            self.SSegsXML = self.splitStringByWord(SToSplit)
        
        # pass
    
    def __repr__(self):
        print self.SSegsXML
        # pass
    
    def __str__(self):
        # self.SSegsXML = self.SSegsXML.rstrip()
        return self.SSegsXML
        # pass    
    
    
    def splitStringByWord(self, SToSplit, sep = '([,\.:;\-\(\) \n])+'): ## can be used as a tokeniser as well..., sentence splitter ...
        '''
        define :: word boundary; and characters to remove ... >> more general way
        '''
        RPat = re.compile(sep, re.MULTILINE | re.DOTALL)
        LSegs = re.split(RPat, SToSplit)
        # i = 0
        SSplit = ''
        for SSeg in LSegs:
            if type(SSeg) == str: 
                SSeg = SSeg.strip()
                if SSeg == '': continue
                SSplit += SSeg + '\n'
        return SSplit
            
    #} splitStringByWord
    
    
    def splitStringByBoundary(self, SToSplit, Sep): ## can be used as a tokeniser as well..., sentence splitter ...
        '''
        splitting by characters or strings, leaving the boundary with the following word
        '''
        if re.search('^\(.+\)', Sep) == None:
            Sep1 = '(' + Sep + ')'
        else:
            Sep1 = Sep
            
        RPat = re.compile(Sep1, re.MULTILINE | re.DOTALL)
        LSegs = re.split(RPat, SToSplit)
        # i = 0
        SSplit = ''
        for SSeg in LSegs:
            if type(SSeg) == str: 
                SSeg = SSeg.strip()
                if SSeg == '': continue
                
                if re.match(Sep, SSeg):
                    SSplit += SSeg
                else:
                    SSplit += SSeg + '\n'
                    
        return SSplit
            
    
    
    def splitStringAfterBoundary(self, SToSplit, Sep): ## can be used as a tokeniser as well..., sentence splitter ...
        '''
        splitting by characters or strings, leaving the boundary with the preceding word
        '''
        if re.search('^\(.+\)', Sep) == None:
            Sep1 = '(' + Sep + ')'
        else:
            Sep1 = Sep
            
        RPat = re.compile(Sep1, re.MULTILINE | re.DOTALL)
        LSegs = re.split(RPat, SToSplit)
        # i = 0
        SSplit = ''
        for SSeg in LSegs:
            if type(SSeg) == str: 
                SSeg = SSeg.strip()
                if SSeg == '': continue
                
                if re.match(Sep, SSeg):
                    SSplit += SSeg
                else:
                    SSplit += '\n' + SSeg 
                    
        SSplit = SSplit.strip('\n')
        SSplit += '\n'
        return SSplit
            
    
    
    



