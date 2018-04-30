#!/bin/sh

#gson-2.8.3.jar available here : http://repo1.maven.org/maven2/com/google/code/gson/gson/2.8.3/

javac -cp gson-2.8.3.jar ./og/patch/DTM.java ./og/patch/HGTTile.java

~/Android/Sdk/build-tools/27.0.3/dx --dex --no-optimize --output=classes8.dex ./og/patch/DTM.class ./og/patch/HGTTile.class

java -jar baksmali-2.2.1.jar d classes8.dex

