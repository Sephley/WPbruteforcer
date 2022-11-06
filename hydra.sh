#!/bin/bash

# ANSI escape Codes (for colored output, -e required on echo)
RED='\033[0;31m'
GREEN='\u001b[32m'
NC='\033[0m' # No Color

# install required packages
echo -e "downloading reqired packages..."
sudo apt install hydra
sudo apt install zenity

echo -e "$GREEN""downloading wordlists""$NC"
wget -q https://github.com/Sephley/Hydra/blob/main/wordlists/rockyou.txt.gz
#gzip -d rockyou.txt.gz 
wget -q https://github.com/Sephley/Hydra/blob/main/wordlists/10-million-password-list-top-1000000.txt

echo -e "enter password to crack: "
zenity --password
read -r PASSWORD
#echo -e "$PASSWORD" | sudo tee -a ~/

echo -e "enter username: "
read -r USERNAME

echo -e "$GREEN""select the wordlist you would like to use\n""$NC"
select d in */; do test -n "$d" && break; echo -e "$RED>>> Invalid Selection""$NC"; done
cd "$d" && pwd

hydra -l "$USERNAME" -P ""

# use pw-inspector to filter?
