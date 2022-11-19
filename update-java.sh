#!/bin/bash
#  ubuntu
# how to call
# sudo ./update-java https://download.java.net/java/GA/jdk19/877d6127e982470ba2a7faa31cc93d04/36/GPL/openjdk-19_linux-x64_bin.tar.gz
# requires sudo because of the move to /usr/lib/jvm
adjust_java_home(){
  file=$1
  new_java_home=$2
  old_value=$JAVA_HOME
  if [[ -f "$FILE" ]]; then
    echo "$FILE exists."
    # use double quotes so it can substitue vars
    # use a different  separator in sed - #, because the vars have paths in them
    sed -i -r "s#$old_value#$new_java_home#g" $FILE
  fi
}

pause(){
 read -s -n 1 -p "Press any key to continue . . ."
 echo ""
}

export DOWNLOAD_URL=$1
mkdir tmp
cd tmp
wget $DOWNLOAD_URL
archive=$(ls)
echo "The archive's name is $archive."
pause

echo "De-archiving ..."
tar -xf $archive
rm $archive
folder=$(ls)
echo "The archive was de-archived and the folder is $folder".
mv $folder /usr/lib/jvm/
echo "Moved to /usr/lib/jvm/$folder".
ls -l /usr/lib/jvm/
pause


cd ..
rm -rf tmp/
echo "Tmp folder removed."
echo "Existing setup of java alternatives: "
update-alternatives --query java
pause
# install
update-alternatives  --install /usr/bin/java java "/usr/lib/jvm/$folder/bin/java" 2082
# set default
update-alternatives --set java "/usr/lib/jvm/$folder/bin/java"
# at this point it should be used by the system
pause

if [[ -z ${JAVA_HOME} ]];
then
	echo "$JAVA_HOME is not set."
else
	echo "$JAVA_HOME was already set, needs to be adjusted."
  adjust_java_home /etc/profile.d/jdk.sh  /usr/lib/jvm/$folder/
  pause
  adjust_java_home /etc/profile.d/jdk.csh  /usr/lib/jvm/$folder/
  echo "After logout/login, JAVA_HOME should reflect the new value."
fi
