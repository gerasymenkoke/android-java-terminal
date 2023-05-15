#!/bin/bash

set -e



PROJ="/home/runner/work/android-java-terminal/android-java-terminal"
AAPT="/usr/local/lib/android/sdk/build-tools/31.0.0/aapt"
AAPT2="/usr/local/lib/android/sdk/build-tools/31.0.0/aapt2"
DX="/usr/local/lib/android/sdk/build-tools/30.0.0/dx"
ZIPALIGN="/usr/local/lib/android/sdk/build-tools/31.0.0/zipalign"
APKSIGNER="/usr/local/lib/android/sdk/build-tools/31.0.0/apksigner" 
PLATFORM="/usr/local/lib/android/sdk/platforms/android-31/android.jar"
JAVA_HOME="/opt/hostedtoolcache/Java_Adopt_jdk/16.0.1-9/x64"

cd $PROJ



echo "Cleaning..."
rm -rf obj/*
rm -rf src/com/example/helloandroid/R.java
mkdir bin



# echo "Generating R.java file..."
# $AAPT package -f -m -J src -M AndroidManifest.xml -S res -I $PLATFORM
# pwd
# ls -l



echo "Compiling APK..."
javac -d obj  -classpath src -bootclasspath $PLATFORM -source 1.7 -target 1.7 src/com/hellokostya/helloandroid/MainActivity.java
cd $PROJ/src/com/hellokostya/helloandroid/
pwd
ls -l
# javac -d obj -classpath src -bootclasspath $PLATFORM -source 1.7 -target 1.7 src/com/example/helloandroid/R.java



# cd /$PROJ/com/hellokostya/helloandroid/
#java com/hellokostya/helloandroid/MainActivity
pwd
ls -l




cd $PROJ




echo "Translating in Dalvik bytecode..."
$DX --dex --output=classes.dex obj
pwd
ls -l


echo "Making JAR..."


cd $PROJ

echo "Making APK..."
$AAPT package -f -m -F $PROJ/bin/hello.unaligned.apk -M $PROJ/AndroidManifest.xml -S $PROJ/res -I $PLATFORM
cp $PROJ/bin/hello.unaligned.apk $PROJ/bin/hello.unaligned-1.apk
$AAPT add $PROJ/bin/hello.unaligned.apk classes.dex

$AAPT list $PROJ/bin/hello.unaligned.apk
cd $PROJ/bin
pwd
ls -l

echo "ZIPALIGNing APK..."
cd $PROJ/bin
$ZIPALIGN -p -f -v 4 $PROJ/bin/hello.unaligned.apk $PROJ/bin/hello.apk 
cp hello.apk  $PROJ/app/build/outputs/apk/release/
cd $PROJ/app/build/outputs/apk/release/
pwd
ls -l 



echo "Signing  APK...."
cd /home/runner/work/android-java-terminal/android-java-terminal/



# printf "B395b39595\nB395b39595\nA\nB\nC\nD\nE\nUA\nYes\n" | $JAVA_HOME/bin/keytool -genkeypair -validity 200000 -keystore signing_key.jks -keyalg RSA -keysize 2048 -alias mykey

# printf "B395b39595\nB395b39595\nB395b39595\n" | $JAVA_HOME/bin/keytool -keypasswd -keystore signing_key.jks -alias alias
# $keytool -keypasswd -keystore keystorename -alias aliasname


# printf "Yes\n" | $JAVA_HOME/bin/keytool -importcert -file upload_cert.der    -keystore signing_key.jks -storepass "B395b39595"

# printf "B395b39595\nB395b39595\nYes\n" | $JAVA_HOME/bin/keytool -importcert -file upload_cert.der -validity 20000 -keystore signing_key.jks -keyalg RSA -keysize 2048 


# base64 -d $PROJ/signing_key64.txt > $PROJ/signing_key.jks




#echo 
# $JAVA_HOME/bin/keytool -list -v -keystore $PROJ/signing_key.jks   -storepass "B395b39595"    
#pwd
#ls -l







printf   "B395b39595" > $PROJ/password.txt



#> $PROJ/signing_key_64.jks


#base64  $PROJ/signing_key.jks > $PROJ/signing_key_64.jks
#echo signing_key_64.jks      
#echo ${{secrets.SIGNING_KEY_64_JKS}} | sed 's/./& /g'
#printf  $SIGNING_KEY_64_JKS

   


base64 -d SIGNING_KEY_64_JKS > $PROJ/signing_key.jks
cat  $PROJ/signing_key.jks

$APKSIGNER sign  --ks $PROJ/signing_key.jks   $PROJ/app/build/outputs/apk/release/hello.apk  < $PROJ/password.txt



$APKSIGNER verify -v  -v4-signature-file $PROJ/app/build/outputs/apk/release/hello.apk.idsig $PROJ/app/build/outputs/apk/release/hello.apk 

































