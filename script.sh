#!/bin/bash

OPT_LIZ_DEL=1

if [ "$(uname)" != "Darwin" ]; then
 echo "# your platform is not supported"
 exit 1
fi

if ! [[ -f "$(which hdiutil)" ]]; then
 echo "# error: hdiutil not found"
 exit 1
fi

if ! [[ -d /Applications/Google\ Chrome.app ]]; then
 echo "# error: chrome not found";
 exit 1
fi

# generate names
scriptname=$(basename -- $0)
THENAME=${scriptname%.*}
if [ "$THENAME" == "" ]; then 
 echo "# error: use .sh or something at the end of the script file, \"$scriptname\" won't work out 'cause script and folder will have same name";
 exit 1;
fi
echo "# using identifier: $THENAME"

echo_sep () {
 echo "==========================================="
}

open_ok () { 
 echo "# open chrome"
 echo_sep
 /Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome --user-data-dir="./$THENAME"
} 

or_die () {
 errcode=$?
 if [ $errcode -ne 0 ]; then 
  echo "# error, exit $errcode"
  exit $errcode
 fi
}

lizz_del () {
 item=$1
 echo "# lizzard delete: $item"
 rm -r "./$THENAME/$item"
}

if [ -d "$THENAME" ]; then 
 echo "# $THENAME folder exists, will try to use it" 
elif [ -f "$THENAME.dmg" ]; then 
   while [ 1 ]; do 
     echo "# $THENAME.dmg file found, attach"
     echo "- Enter password to decrypt $THENAME.dmg: "
     read -s thepass
     echo_sep
     echo $thepass | hdiutil attach -stdinpass "$THENAME.dmg"
     if [ $? -eq 0 ]; then 
       break;
     fi
   done;
   or_die
   echo "# copy contents into $THENAME"
   cp -r "/Volumes/$THENAME" .
   or_die
   echo "# detach volume"
   echo_sep
   hdiutil detach "/Volumes/$THENAME"
   or_die
   echo "# delete image"
   rm "$THENAME.dmg"
   or_die
else
  echo "# No folder Or no DMG, will init"
fi

if [ "$thepass" == "" ]; then
  echo "-Enter password to encrypt $THENAME.dmg: "
  read -s thepass
  echo "-Repeat: "
  read -s thepassRepeat
  if [ "$thepass" != "$thepassRepeat" ]; then 
    echo "# Passwords did not match"
    exit 1;
  fi
fi

echo_sep
open_ok

echo "# google chrome did terminate"
if [ $OPT_LIZ_DEL -eq 1 ]; then 
  echo "# will do lizzard delete of chrome sh1t, to thin dmg"
  lizz_del "GrShaderCache"
  lizz_del "Default/Cache"
  lizz_del "Default/Service Worker"
  lizz_del "Default/IndexedDB"
fi

echo "# encrypt folder"
echo_sep
echo $thepass | hdiutil create -encryption -stdinpass -srcfolder "$THENAME" "$THENAME.dmg"
or_die
echo "# delete folder"
rm -rf "$THENAME"
or_die
echo "# success"
echo "#"
ls -lahS $THENAME*
echo "#"
exit 0

