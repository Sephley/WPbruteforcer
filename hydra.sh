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
wget -q https://github.com/Sephley/Hydra/blob/main/wordlists/rockyou.txt.gz

echo -e "enter password to crack: "
read -r PASSWORD
#echo -e "$PASSWORD" | sudo tee -a ~/

echo -e "$GREEN""select the wordlist you would like to use""$NC"

# use pw-inspector to filter?
