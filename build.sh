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



#echo "Generating R.java file..."
# $AAPT package -f -m -J src -M AndroidManifest.xml -S res -I $PLATFORM

echo "Compiling APK..."
javac -d obj -classpath src -bootclasspath $PLATFORM -source 1.7 -target 1.7 src/com/example/helloandroid/MainActivity.java
# javac -d obj -classpath src -bootclasspath $PLATFORM -source 1.7 -target 1.7 src/com/example/helloandroid/R.java

pwd 
ls -l
cd $PROJ/obj/com/example/helloandroid
pwd
ls -l
java MainActivity

pwd
ls -l
cd $PROJ




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



echo 
 $JAVA_HOME/bin/keytool -list -v -keystore $PROJ/signing_key.jks   -storepass "B395b39595"    
pwd
ls -l


# printf "B395b39595\n"  | $JAVA_HOME/bin/keytool -export -rfc -keystore $PROJ/signing_key.jks -alias alias -file $PROJ/signing_key.pem

# $JAVA_HOME/bin/java -jar $PROJ/pepk.jar --keystore=signing_key.jks --keystore-pass="B395b39595" --alias=alias --output=$PROJ/signing_key.zip  --encryptionkey=eb10fe8f7c7c9df715022017b00c6471f8ba8170b13049a11e6c09ffe3056a104a3bbe4ac5a955f4ba4fe93fc8cef27558a3eb9d2a529a2092761fb833b656cd48b9de6a     

 
 







# echo "signing_key.jks________\n"
# cat $PROJ/signing_key.jks
# echo "signing_key.jks________\n"




printf   "B395b39595" > $PROJ/password.txt
# echo $PROJ/p.txt

#base64 $PROJ/password.txt > $PROJ/passwordb64
#cat  $PROJ/passwordb64


#base64 -d $PROJ/passwordb64 > $PROJ/password.txt
#cat $PROJ/password.txt


#echo "keystore64___________\n"

# echo "$PASSWORDB64"  | base64 -D > $PROJ/password.txt
#echo "$KEYSTORE_JKS" | base64 -D > $PROJ/keystore.jks


#cat  $PROJ/keystore64
#echo "keystore.jks___________\n"
#base64 -d $PROJ/keystore64 > $PROJ/keystore.jks
#cat $PROJ/keystore.jks





#echo $PROJ/passwordb64.txt | base64 -d > $PROJ/password.txt





# base64 -d  $KEYSTORE_JKS > $PROJ/keystore.jks



# non work printf $KEYSTORE_JKS > $PROJ/keystore.jks



#cat $PASSWORDB64
# echo "keystore.jks_____________/n"
#cat $PROJ/keystore.jks
#echo  "____________/n"
#cd /home/runner/work/android-java-terminal/android-java-terminal/
#pwd
#ls -l
#chmod +x $PROJ/password.txt 
#cat $PROJ/password.txt

          
$APKSIGNER sign  --ks $PROJ/signing_key.jks   $PROJ/app/build/outputs/apk/release/hello.apk  < $PROJ/password.txt

# --ks my.keystore my-app.apk --ks-key-alias alias_name

$APKSIGNER verify -v  -v4-signature-file $PROJ/app/build/outputs/apk/release/hello.apk.idsig $PROJ/app/build/outputs/apk/release/hello.apk 
















echo "Making AAB..."

echo "Compile resourses..."
$AAPT2 compile --dir $PROJ/res/ -o $PROJ/obj/res.zip

echo "Link resourses..."
$AAPT2 link --proto-format -o $PROJ/obj/linked.zip -I $PLATFORM --manifest $PROJ/AndroidManifest.xml --java src $PROJ/obj/res.zip --auto-add-overlay

echo "Compile the Java sources to bytecode"
#javac -d obj -classpath src -bootclasspath $PLATFORM $PROJ/src/com/example/helloandroid/*.java
javac -d obj -classpath src -bootclasspath $PLATFORM -source 1.7 -target 1.7 src/com/example/helloandroid/MainActivity.java
echo "Convert the bytecode to Dex format (Dalvik Android virtual machine)"
$DX --dex --output=bin/classes.dex obj

echo "Combine the resources and the bytecode into a single bundle"
cd $JAVA_HOME/bin
pwd
ls -l

cd $PROJ/obj
$JAVA_HOME/bin/jar  xf $PROJ/obj/linked.zip resources.pb AndroidManifest.xml res
mkdir manifest dex 
mv AndroidManifest.xml manifest
cp ../bin/classes*.dex dex/ 
echo "jar cmf"
$JAVA_HOME/bin/jar cMf base.zip manifest dex res resources.pb

echo "Build the AAB"
wget https://github.com/google/bundletool/releases/download/1.11.2/bundletool-all-1.11.2.jar 
pwd
ls -l
echo "Java -jar bundletool"

$JAVA_HOME/bin/java -jar bundletool-all-1.11.2.jar build-bundle --modules=base.zip --output=../bin/hello.aab
cd $PROJ/bin
pwd
ls -l




echo "Sign AAB"
$JAVA_HOME/bin/jarsigner --help
cd $PROJ/bin
echo "jarsigner....."
cat $PROJ/password.txt
cat $PROJ/signing_key.jks
    

$JAVA_HOME/bin/jarsigner  -keystore $PROJ/signing_key.jks   -storepass "B395b39595"    $PROJ/bin/hello.aab mykey

$JAVA_HOME/bin/keytool -list -v -keystore $PROJ/signing_key.jks   -storepass "B395b39595"    




















