#!/bin/bash

scriptname=$(basename -- $0)
THENAME=${scriptname%%.*}
echo "# using identifier: $THENAME"

open_ok () { 
 echo "# open chrome"
 /Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome --user-data-dir="./$THENAME"
} 

or_die () {
 errcode=$?
 if [ $errcode -ne 0 ]; then 
  echo "# error, exit $errcode"
  exit $errcode
 fi
}

if [ -d "$THENAME" ]; then 
 echo "# $THENAME folder exists, will try to use it" 
elif [ -f "$THENAME.dmg" ]; then 
   echo "# $THENAME.dmg file found, attach"
   echo "- Enter password to decrypt $THENAME.dmg: "
   read -s thepass
   echo $thepass | hdiutil attach -stdinpass "$THENAME.dmg"
   or_die
   echo "# copy contents into $THENAME"
   cp -r "/Volumes/$THENAME" .
   or_die
   echo "# detach volume"
   hdiutil detach "/Volumes/$THENAME"
   or_die
   echo "# delete image"
   rm "$THENAME.dmg"
   or_die
else
  echo "# No folder Or no DMG, will init"
fi

if [ "$thepass" == "" ]; then
  echo "- Enter password to encrypt $THENAME.dmg: "
  read -s thepass
fi

echo "# Will open google chrome"
open_ok

echo "# google chrome did terminate"
echo "# encrypt folder"
echo $thepass | hdiutil create -encryption -stdinpass -srcfolder "$THENAME" "$THENAME.dmg"
or_die
echo "# delete folder"
rm -rf "$THENAME"
or_die
echo "# success"
exit 0

