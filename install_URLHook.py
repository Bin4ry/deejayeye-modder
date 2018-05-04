#!/usr/bin/env python

import base64
import sys
import re
import os
import binascii

# install_URLHook.py by Matioupi
# install a hook call right before any java.net.URL constructor in order to intercept/log/change the url parameters
# the actual hook is implemented directly in Java code in the og/patchs package

def doHook(lines,args,ctor_type,content):
     if len(lines) > 0:
         i = 0
         for onematch in lines:
             try:
                print fname
                print "old code"
                print onematch
                print "new code"
                if ctor_type == 1:
                   new_str = args[i][0] + "invoke-static {" + args[i][2] + "}, Log/patch/URLHook;->checkURL_S(Ljava/lang/String;)Ljava/lang/String;\n"
                   new_str += args[i][0] + "move-result-object " + args[i][2] + "\n"
                elif ctor_type == 2:
                   new_str = args[i][0] + "invoke-static {" + args[i][2] + ", " + args[i][3] + "}, Log/patch/URLHook;->checkURL_SS(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;\n"
                   new_str += args[i][0] + "move-result-object " + args[i][3] + "\n"
                elif ctor_type == 3:
                   new_str = args[i][0] + "invoke-static {" + args[i][2] + ", " + args[i][3] + ", " + args[i][4] + "}, Log/patch/URLHook;->checkURL_SSS(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;\n"
                   new_str += args[i][0] + "move-result-object " + args[i][3] + "\n"
                elif ctor_type == 4:
                   new_str = args[i][0] + "invoke-static {" + args[i][2] + ", " + args[i][3] + ", " + args[i][4] + ", " + args[i][5] + "}, Log/patch/URLHook;->checkURL_SSIS(Ljava/lang/String;Ljava/lang/String;ILjava/lang/String;)Ljava/lang/String;\n"
                   new_str += args[i][0] + "move-result-object " + args[i][3] + "\n"
                else:
                   new_str = ""
                new_str += onematch
                print new_str                        
                content = content.replace(onematch,new_str,1)
             except binascii.Error as err:
                pass
             i = i+1
     return content

if len(sys.argv) != 2:
   print "Instrument URL : intercept all java.net.URL construct"
   print "Syntax: {0} <folder>".format(sys.argv[0])
   sys.exit(1)

path = sys.argv[1]
for directory, subdirectories, files in os.walk(path):
    for file in files:
      fname = os.path.join(directory, file)
      if fname.endswith('.smali'):

#       pat0 = re.compile('^(\s*const-string.*\s*v[0-9]+\s*,\s*\"[^\"]+\"\s*$\s*^.*invoke-static\s+\{v[0-9]+\},\s+Lcom/dji/f/a/a/b;->a\(Ljava/lang/String;\)Ljava/lang/String.*$\s*^.*move-result-object\s+v[0-9]+.*)$', re.MULTILINE|re.UNICODE)
#         pat00 = re.compile('(?:^(\s*)const-string.*\s*(v[0-9]+)\s*,\s*\"([^\"]+)\"\s*$\s*^.*invoke-static\s+\{v[0-9]+\},\s+Lcom/dji/f/a/a/b;->a\(Ljava/lang/String;\)Ljava/lang/String.*$\s*^.*move-result-object\s+(v[0-9]+).*$)', re.MULTILINE|re.UNICODE)

         # Construct with 1 String
         pat_S = re.compile('^(\s*invoke-direct.*\s*\{[v,p][0-9]+,\s+[v,p][0-9]+\},\s+Ljava/net/URL;-><init>\(Ljava/lang/String;\).*)$', re.MULTILINE|re.UNICODE)
         pat_S_args = re.compile('(?:^(\s*)invoke-direct.*\s*\{([v,p][0-9]+),\s+([v,p][0-9]+)\},\s+Ljava/net/URL;-><init>\(Ljava/lang/String;\).*$)', re.MULTILINE|re.UNICODE)

         # Construct with 2 Strings
         pat_SS = re.compile('^\s*invoke-direct.*\s*\{[v,p][0-9]+,\s+[v,p][0-9]+,\s+[v,p][0-9]+\},\s+Ljava/net/URL;-><init>\(Ljava/lang/String;Ljava/lang/String;\).*$', re.MULTILINE|re.UNICODE)
         pat_SS_args = re.compile('(?:(^\s*)invoke-direct.*\s*\{([v,p][0-9]+),\s+([v,p][0-9]+),\s+([v,p][0-9]+)\},\s+Ljava/net/URL;-><init>\(Ljava/lang/String;Ljava/lang/String;\).*$)', re.MULTILINE|re.UNICODE)

         # Construct with 3 String
         pat_SSS = re.compile('^\s*invoke-direct.*\s*\{[v,p][0-9]+,\s+[v,p][0-9]+,\s+[v,p][0-9]+,\s+[v,p][0-9]+\},\s+Ljava/net/URL;-><init>\(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;\).*$', re.MULTILINE|re.UNICODE)
         pat_SSS_args = re.compile('(?:(^\s*)invoke-direct.*\s*\{([v,p][0-9]+),\s+([v,p][0-9]+),\s+([v,p][0-9]+),\s+([v,p][0-9]+)\},\s+Ljava/net/URL;-><init>\(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;\).*$)', re.MULTILINE|re.UNICODE)

         # Construct with String, String, Integer, String
         pat_SSIS = re.compile('^\s*invoke-direct.*\s*\{[v,p][0-9]+,\s+[v,p][0-9]+,\s+[v,p][0-9]+,\s+[v,p][0-9]+,\s+[v,p][0-9]+\},\s+Ljava/net/URL;-><init>\(Ljava/lang/String;Ljava/lang/String;ILjava/lang/String;\).*$', re.MULTILINE|re.UNICODE)
         pat_SSIS_args = re.compile('(?:^(\s*)invoke-direct.*\s*\{([v,p][0-9]+),\s+([v,p][0-9]+),\s+([v,p][0-9]+),\s+([v,p][0-9]+),\s+([v,p][0-9]+)\},\s+Ljava/net/URL;-><init>\(Ljava/lang/String;Ljava/lang/String;ILjava/lang/String;\).*$)', re.MULTILINE|re.UNICODE)

         content = open(fname,'r').read()
         matches_S = re.findall(pat_S, content)
         matches_S_args = re.findall(pat_S_args, content)

         matches_SS = re.findall(pat_SS, content)
         matches_SS_args = re.findall(pat_SS_args, content)

         matches_SSS = re.findall(pat_SSS, content)
         matches_SSS_args = re.findall(pat_SSS_args, content)

         matches_SSIS = re.findall(pat_SSIS, content)
         matches_SSIS_args = re.findall(pat_SSIS_args, content)

         content = doHook(matches_S,matches_S_args,1, content)
         content = doHook(matches_SS,matches_SS_args,2, content)
         content = doHook(matches_SSS,matches_SSS_args,3, content)
         content = doHook(matches_SSIS,matches_SSIS_args,4, content)
         #print fname
         out = open(fname,'w')
         out.write(content)
         out.close()

