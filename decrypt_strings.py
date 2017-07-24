import base64
import sys
import re

# decrypt dji fw 4.1.4 strings by adding the decrypted version as comment to smali files
# - by nopcode, miek and bin4ry

key = 'I Love Android'

def decrypt(s):
	s = base64.decodestring(s)
	return ''.join([chr(ord(c) ^ ord(key[i%7*2])) for i,c in enumerate(s)])

if len(sys.argv) != 2:
	print "Decrypts base64 + silly encrpytion in 4.1.4 smali files. Original smali file is replaced!"
	print "Syntax: {0} <input.smali>".format(sys.argv[0])
	sys.exit(1)

base64_str_rex = re.compile('\s*const-string/jumbo\s*v[0-9]+\s*,\s*\"([^\"]*)\"\s*')
skip = 1


with open(sys.argv[1], "r") as fd:
	lines = list(fd)

with open(sys.argv[1], "w") as fd:	
	for l in lines:
		if (skip == 1):
			l = l.rstrip()
			match = base64_str_rex.match(l)
			if match:
				enc = match.group(1)
				dec = decrypt(enc)
				l = l.replace(enc,dec)
				#print(l)
				fd.write(l + "\n")
				skip += 1
			else:
				fd.write(l + "\n")
		else:
			l=""
			if (skip == 5):
				skip = 1
			else:
				skip += 1