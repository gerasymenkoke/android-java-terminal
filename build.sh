#!/bin/bash

set -e
PROJ="/home/runner/work/android-java-terminal/android-java-terminal"
AAPT="/usr/local/lib/android/sdk/build-tools/29.0.3/aapt"
DX="/usr/local/lib/android/sdk/build-tools/29.0.3/dx"
ZIPALIGN="/usr/local/lib/android/sdk/build-tools/29.0.3/zipalign"
APKSIGNER="/usr/local/lib/android/sdk/build-tools/29.0.3/apksigner" 
PLATFORM="/usr/local/lib/android/sdk/platforms/android-29/android.jar"


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

echo "Making APK..."



$AAPT package -f -m -F $PROJ/bin/hello.unaligned.apk -M $PROJ/AndroidManifest.xml -S $PROJ/res -I $PLATFORM
$AAPT add $PROJ/bin/hello.unaligned.apk classes.dex




$AAPT list $PROJ/bin/hello.unaligned.apk
cd $PROJ/bin
pwd
ls -l
cp hello.unaligned.apk  /home/runner/work/android-java-terminal/android-java-terminal/app/build/outputs/apk/release/
cd /home/runner/work/android-java-terminal/android-java-terminal/app/build/outputs/apk/release
cp /home/runner/work/android-java-terminal/android-java-terminal/Kostya.jks  /home/runner/work/android-java-terminal/android-java-terminal/app/build/outputs/apk/release/signingKey.jks
cd /home/runner/work/android-java-terminal/android-java-terminal/app/build/outputs/apk/release
pwd
ls -l

# printf 'B395b39595\nB395b39595\nA\nB\nC\nD\nE\nUA\nYes\n' | keytool -genkeypair -validity 365 -keystore mykey.keystore -keyalg RSA -keysize 2048 
# pwd
# ls -l
# cp $PROJ/bin/mykey.keystore /usr/local/lib/android/sdk/build-tools/29.0.3/mykey.keystore
#cd /usr/local/lib/android/sdk/build-tools/29.0.3
#pwd
# ls -l
#chmod +x mykey.keystore


#cd /opt/hostedtoolcache/Java_Adopt_jdk/18.0.2-9/x64


#printf 'B395b39595\nB395b39595\nA\nB\nC\nD\nE\nUA\nYes\n' |  keytool -genkey -alias tomcat -keyalg RSA -keystore keystore.jks  

#pwd
#ls -l


#$APKSIGNER sign --ks file:///opt/hostedtoolcache/Java_Adopt_jdk/18.0.2-9/x64keystore.jks $PROJ/bin/hello.apk
#$APKSIGNER  verify -v --print-certs *.apk


# $APKSIGNER sign --ks Kostya.jks $PROJ/bin/hello.apk




