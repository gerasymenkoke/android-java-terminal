#!/bin/bash

set -e
PROJ="/home/runner/work/android-java-terminal/android-java-terminal"
AAPT="/usr/local/lib/android/sdk/build-tools/27.0.3/aapt"
DX="/usr/local/lib/android/sdk/build-tools/27.0.3/dx"
ZIPALIGN="/usr/local/lib/android/sdk/build-tools/27.0.3/zipalign"
APKSIGNER="/usr/local/lib/android/sdk/build-tools/27.0.3/apksigner" 
PLATFORM="/usr/local/lib/android/sdk/platforms/android-27/android.jar"
KEY="B395b39595"

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


# $AAPT package -f -m -F /bin/hello.unaligned.apk -M AndroidManifest.xml -S res -I $PLATFORM
# $AAPT add /bin/hello.unaligned.apk classes.dex


$AAPT list $PROJ/bin/hello.unaligned.apk

echo "Aligning and signing APK...."
pwd
ls -l
$APKSIGNER sign --ks-pass pass:B395b39595 --key-pass pass:B395b39555  $PROJ/bin/hello.apk


$ZIPALIGN -f 4 $PROJ/bin/hello.unaligned.apk bin/hello.apk

if [ "$1" == "test" ]; then
	echo "Launching..."
	adb install -r $PROJ/bin/hello.apk
	adb shell am start -n com.example.helloandroid/.MainActivity
fi
