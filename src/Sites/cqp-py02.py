#!/usr/bin/python
import cgi, sys, os, re, socket, time

'''
Created on 23 Sep 2024

@author: Bogdan Babych
'''

class runCgiCorpus(object):
	def __init__(self) -> None:
		self.writeHTMLheading()
		self.procForm()
		self.writeHTMLEnd()
        


	def writeHTMLheading(self):
		print('Content-type: text/html\n\n')
		print('<title>Python cgi script</title>\n')
		print('<h2>Selected corpora</h2>\n')

	
	def procForm(self):
		form = self.readFields()
		self.displayFieldsl(form)


	def readFields(self):
		"""
		the function reads form fields which will be used in class
		"""
		NameIPSuffix = 'IP-time-'
		# get remote IP address
		try:
			ClientIP = cgi.escape(os.environ["REMOTE_ADDR"])
		except:
			ClientIP = 'ERROR-default'
			print('clientIP unknown<br>\n')
		# get time
		try:
			ts = time.time()
		except:
			ts = '1000.01'
			print('time not found<br>\b')
		# get dictionary of fields	
		try:
			form = cgi.FieldStorage()
		except:
			print('field storage error<br>\n')
			form = { 'f1010tst' : 'edt' , 'f1020ref' : 'edt das ist ein klein haus' }

		return form


	def displayFieldsl(self, form):
		for el, val in form.items():
			sys.stdout.write('<pre>')
			sys.stdout.write(f'{el}\t{val}\n')
			sys.stdout.write('</pre>')


	def writeHTMLEnd(self):
		print('<p>Finished</p>')
			


if __name__ == '__main__':
	ORunBLEUpl = runCgiCorpus()