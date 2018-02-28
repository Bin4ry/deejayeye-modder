#!/usr/bin/env python

import base64
import sys
import re
import os
import binascii

# defog dji fw 4.1.4 strings by adding the defogged version as comment to smali files
# - by nopcode, miek and bin4ry

key_414 = 'I Love Android'
key_415 = 'Y9*PI8B#gD^6Yhd1'
 
def defog(s,l):
   s = base64.decodestring(s)
   decr = ''.join([chr(ord(c) ^ ord(key[i%l*2])) for i,c in enumerate(s)])
   decr = decr.replace("\\","\\\\")
   decr = decr.replace('\r', "\\r")
   decr = decr.replace('\n', "\\n")
   decr = decr.replace('\t', "\\t")
   decr = decr.replace('"', '\\"')
   return decr

if len(sys.argv) != 3:
   print "Defogs base64 + silly fogging in DJI Go4 4.1.4 smali files. Adds defogged string as comment. Original smali file is replaced!"
   print "Syntax: {0} <key1 for 414 (1) or key2 for >=415 (2)> <folder>".format(sys.argv[0])
   sys.exit(1)

if sys.argv[1] == '1':
    key=key_414
    klen=7
if sys.argv[1] == '2':
    key=key_415
    klen=8
path = sys.argv[2]
for directory, subdirectories, files in os.walk(path):
    for file in files:
      fname = os.path.join(directory, file)
      if fname.endswith('.smali'):
         pat1 = re.compile('^(\s*const-string.*\s*v[0-9]+\s*,\s*\"[^\"]+\"\s*$\s*^.*invoke-static\s+\{v[0-9]+\},\s+Lcom/dji/f/a/a/b;->a\(Ljava/lang/String;\)Ljava/lang/String.*$\s*^.*move-result-object\s+v[0-9]+.*)$', re.MULTILINE|re.UNICODE)
         pat2 = re.compile('(?:^(\s*)const-string.*\s*(v[0-9]+)\s*,\s*\"([^\"]+)\"\s*$\s*^.*invoke-static\s+\{v[0-9]+\},\s+Lcom/dji/f/a/a/b;->a\(Ljava/lang/String;\)Ljava/lang/String.*$\s*^.*move-result-object\s+(v[0-9]+).*$)', re.MULTILINE|re.UNICODE)
         content = open(fname,'r').read()
         matches1 = re.findall(pat1, content)
         matches2 = re.findall(pat2, content)
         if len(matches1) > 0:
             i = 0
             for onematch in matches1:
                 try:
                    defog_str = defog(matches2[i][2],klen)
                    if matches2[i][1] == matches2[i][3]:
                    #only one register used
                       new_str = matches2[i][0]+"const-string "+matches2[i][3]+', "'+defog_str+'"'
                    else:
                    #two register used : keep first fake string to avoid messing up number of locale registers
                       new_str = matches2[i][0]+"const-string "+matches2[i][1]+', "'+matches2[i][2] +'"\n'
                       new_str = new_str + matches2[i][0]+"const-string "+matches2[i][3]+','+' "'+defog_str+'"'
                    content = content.replace(onematch,new_str,1)
                 except binascii.Error as err:
                    pass
                 i = i+1
             print fname
             out = open(fname,'w')
             out.write(content)
             out.close()
