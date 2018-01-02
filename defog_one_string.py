#!/usr/bin/env python

import base64
import sys
import re
import os

# from work by nopcode, miek and bin4ry

key_414 = 'I Love Android'
key_415 = 'Y9*PI8B#gD^6Yhd1'
 
def decrypt(s,l):
	s = base64.decodestring(s)
	decr = ''.join([chr(ord(c) ^ ord(key[i%l*2])) for i,c in enumerate(s)])
	decr = decr.replace('\r', '').replace('\n', '').replace('"', '').replace('\\','')
	return decr

if len(sys.argv) != 3:
	print "UNFOG a string according to silly DJI scheme (for easy replacing with sed e.g. replacing external http adresses)"
	print "Syntax: {0} <key1 for 414 (1) or key2 for >=415 (2)> <string>".format(sys.argv[0])
	sys.exit(1)

if sys.argv[1] == '1':
    key=key_414
    klen=7
if sys.argv[1] == '2':
    key=key_415
    klen=8
l = sys.argv[2]
decr = decrypt(l,klen)
sys.stdout.write(decr)

