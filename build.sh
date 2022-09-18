#!/bin/bash

set -e
PROJ="/home/runner/work/android-java-terminal/android-java-terminal"
AAPT="/usr/local/lib/android/sdk/build-tools/31.0.0/aapt"
AAPT2="/usr/local/lib/android/sdk/build-tools/31.0.0/aapt2"
DX="/usr/local/lib/android/sdk/build-tools/30.0.0/dx"
ZIPALIGN="/usr/local/lib/android/sdk/build-tools/31.0.0/zipalign"
APKSIGNER="/usr/local/lib/android/sdk/build-tools/31.0.0/apksigner" 
PLATFORM="/usr/local/lib/android/sdk/platforms/android-31/android.jar"


echo "Cleaning..."
rm -rf obj/*
rm -rf src/com/example/helloandroid/R.java
mkdir bin



echo "Generating R.java file..."
$AAPT package -f -m -J src -M AndroidManifest.xml -S res -I $PLATFORM

echo "Compiling..."
javac -d obj -classpath src -bootclasspath $PLATFORM -source 1.7 -target 1.7 src/com/example/helloandroid/MainActivity.java
javac -d obj -classpath src -bootclasspath $PLATFORM -source 1.7 -target 1.7 src/com/example/helloandroid/R.java

echo "Translating in Dalvik bytecode..."
$DX --dex --output=classes.dex obj
pwd
ls -l



echo "Making APK..."
$AAPT package -f -m -F $PROJ/bin/hello.unaligned.apk -M $PROJ/AndroidManifest.xml -S $PROJ/res -I $PLATFORM
$AAPT add $PROJ/bin/hello.unaligned.apk classes.dex

$AAPT list $PROJ/bin/hello.unaligned.apk
cd $PROJ/bin
pwd
ls -l
unzip $PROJ/bin/hello.unaligned.apk -d staging   
cd $PROJ/bin/staging
pwd
ls -l
mkdir $PROJ/bin/staging/manifest/
cp AndroidManifest.xml $PROJ/bin/staging/manifest/ 

mkdir $PROJ/bin/staging/dex/
cp $PROJ/obj cd $PROJ/bin/staging/dex/ 
cd $PROJ/bin/staging/dex/
pwd
ls -l



cd $PROJ/bin/staging/
zip -r ../base.zip *
bundletool build-bundle --modules=base.zip --output=hello.aab
pwd
ls -l


echo "ZIPALIGNing APK..."
cd $PROJ/bin
$ZIPALIGN -p -f -v 4 $PROJ/bin/hello.unaligned.apk $PROJ/bin/hello.apk 
cp hello.apk  $PROJ/app/build/outputs/apk/release/
cd $PROJ/app/build/outputs/apk/release/
pwd
ls -l 







echo "Signing  APK..."
cd /home/runner/work/android-java-terminal/android-java-terminal/
echo $PASSWORDB64 | base64 -d > /home/runner/work/android-java-terminal/android-java-terminal/password.txt
echo $KEYSTORE_JKS| base64 -d > /home/runner/work/android-java-terminal/android-java-terminal/keystore.jks
cd /home/runner/work/android-java-terminal/android-java-terminal/
ls -l
chmod +x password.txt 
$APKSIGNER sign --ks   /home/runner/work/android-java-terminal/android-java-terminal/keystore.jks   /home/runner/work/android-java-terminal/android-java-terminal/app/build/outputs/apk/release/hello.apk  <  password.txt          
$APKSIGNER verify -v  -v4-signature-file /home/runner/work/android-java-terminal/android-java-terminal/app/build/outputs/apk/release/hello.apk.idsig /home/runner/work/android-java-terminal/android-java-terminal/app/build/outputs/apk/release/hello.apk 




