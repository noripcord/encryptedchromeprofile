# encryptedchromeprofile
Use this script to use or create a new google chrome profile that's saved as an encrypted file (.dmg) after you're done with it.

Works only in macOS.
## the name
of the script determines the name of the dmg and the profile folder. Script unpacks and packs in '.'

## install
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/noripcord/encryptedchromeprofile/main/install.sh)"

## use

./\<scriptname\>
  
  and chrome will open with the new profile. when the browser closes, the profile will be deleted from disk, not before saving all of the content in an encrypted .dmg file.
  
  
