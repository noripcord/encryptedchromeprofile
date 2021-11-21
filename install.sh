#!/bin/bash

echo "Enter name of the profile: "
read name
if [ "$name" == "" ]; then 
 echo "# error: invalid name"
 exit 1;
fi
scriptname=$name.sh
echo "# will get script"
curl -fsSL https://raw.githubusercontent.com/noripcord/encryptedchromeprofile/main/script.sh > $scriptname
echo "# created $scriptname"
echo "# make executable"
chmod +x $scriptname
echo "# success"
exit 0

