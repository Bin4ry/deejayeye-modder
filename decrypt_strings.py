#!/usr/bin/env python

import base64
import sys
import re
import os

# decrypt dji fw 4.1.4 strings by adding the decrypted version as comment to smali files
# - by nopcode, miek and bin4ry

key_414 = 'I Love Android'
key_415 = 'Y9*PI8B#gD^6Yhd1'
 
def decrypt(s):
	s = base64.decodestring(s)
	decr = ''.join([chr(ord(c) ^ ord(key[i%7*2])) for i,c in enumerate(s)])
	decr = decr.replace('\r', '').replace('\n', '').replace('"', '').replace('\\','')
	return decr

if len(sys.argv) != 3:
	print "Decrypts base64 + silly encrpytion in DJI Go4 4.1.4 smali files. Adds decrypted string as comment. Original smali file is replaced!"
	print "Syntax: {0} <key1 for 414 (1) or key2 for 415 (2)> <folder>".format(sys.argv[0])
	sys.exit(1)

if sys.argv[1] == '1':
    key=key_414
if sys.argv[1] == '2':
    key=key_415
path = sys.argv[2]
for directory, subdirectories, files in os.walk(path):
    for file in files:
		fname = os.path.join(directory, file)
		if fname.endswith('.smali'):
			print(fname)
			base64_str_rex = re.compile('\s*const-string/jumbo\s*v[0-9]+\s*,\s*\"([^\"]*)\"\s*')
			skip = 1
			i = 0

			with open(fname, "r") as fd:
				lines = list(fd)

			with open(fname, "w") as fd:	
				for l in lines:
					i += 1
					if (skip == 1):
						l = l.rstrip()
						match = base64_str_rex.match(l)
						if match:
							next = lines[i+1]
							if "com/dji/k/a/a/b" in next:
								enc = match.group(1)
								dec = decrypt(enc)
								l = l.replace(enc,dec)
								#print(l)
								fd.write(l + "\n")
								skip += 1
							else:
								fd.write(l + "\n")
								skip = 1
						else:
							fd.write(l + "\n")
					
					else:
						l=""
						if (skip == 5):
							skip = 1
						else:
							skip += 1
				else:
					foo=""