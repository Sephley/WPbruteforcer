#!/bin/bash

# ANSI escape Codes (for colored output, -e required on echo)
RED='\033[0;31m'
GREEN='\u001b[32m'
NC='\033[0m' # No Color

# install required packages
echo -e "downloading reqired packages..."
sudo apt install hydra
sudo apt install zenity

echo -e "$GREEN""downloading dictionaries""$NC"
wget -q https://raw.githubusercontent.com/danielmiessler/SecLists/master/Passwords/Common-Credentials/10-million-password-list-top-1000000.txt
wget -q https://github.com/praetorian-inc/Hob0Rules/raw/master/wordlists/rockyou.txt.gz

echo -e "enter password to crack: "
read -r PASSWORD
#echo -e "$PASSWORD" | sudo tee -a ~/

echo -e "$GREEN""select the wordlist you would like to use""$NC"

# use pw-inspector to filter?
