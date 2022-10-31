#!/bin/bash

#ANSI escape Codes (for colored output, -e required on echo)
RED='\033[0;31m'
GREEN='\u001b[32m'
NC='\033[0m' # No Color

# install required packages
sudo apt install hydra

echo -e "enter password: "
read -r PASSWORD
#echo -e "$PASSWORD" | sudo tee -a ~/

echo -e $GREEN"enter the the number of the dictionaries you would like to use"$NC

# use pw-inspector to filter?
