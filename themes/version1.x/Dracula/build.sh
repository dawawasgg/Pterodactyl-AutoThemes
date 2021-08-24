#!/bin/bash

set -e

########################################################
# 
#         Pterodactyl-AutoThemes Installation
#
#         Created and maintained by Ferks-FK
#
#            Protected by GPL 3.0 License
#
########################################################

#### Variables ####
SUPPORT_LINK="https://discord.gg/buDBbSGJmQ"


print_brake() {
  for ((n = 0; n < $1; n++)); do
    echo -n "#"
  done
  echo ""
}


hyperlink() {
  echo -e "\e]8;;${1}\a${1}\e]8;;\a"
}


#### Colors ####

GREEN="\e[0;92m"
YELLOW="\033[1;33m"
reset="\e[0m"
red='\033[0;31m'


#### OS check ####

check_distro() {
  if [ -f /etc/os-release ]; then
    . /etc/os-release
    OS=$(echo "$ID")
    OS_VER=$VERSION_ID
  elif type lsb_release >/dev/null 2>&1; then
    OS=$(lsb_release -si)
    OS_VER=$(lsb_release -sr)
  elif [ -f /etc/lsb-release ]; then
    . /etc/lsb-release
    OS=$(echo "$DISTRIB_ID")
    OS_VER=$DISTRIB_RELEASE
  elif [ -f /etc/debian_version ]; then
    OS="debian"
    OS_VER=$(cat /etc/debian_version)
  elif [ -f /etc/SuSe-release ]; then
    OS="SuSE"
    OS_VER="?"
  elif [ -f /etc/redhat-release ]; then
    OS="Red Hat/CentOS"
    OS_VER="?"
  else
    OS=$(uname -s)
    OS_VER=$(uname -r)
  fi

  OS=$(echo "$OS")
  OS_VER_MAJOR=$(echo "$OS_VER" | cut -d. -f1)
}


#### Install Dependencies ####

case "$OS" in
debian | ubuntu)
curl -sL https://deb.nodesource.com/setup_14.x | sudo -E bash - && apt-get install -y nodejs
;;

centos)
[ "$OS_VER_MAJOR" == "7" ] && curl -sL https://rpm.nodesource.com/setup_14.x | sudo -E bash - && sudo yum install -y nodejs yarn
[ "$OS_VER_MAJOR" == "8" ] && curl -sL https://rpm.nodesource.com/setup_14.x | sudo -E bash - && sudo dnf install -y nodejs yarn
;;
esac


#### Donwload Files ####
download_files() {
cd /var/www/pterodactyl/resources/scripts
curl -o user.css https://github.com/Ferks-FK/Pterodactyl-AutoThemes/blob/main/themes/version1.x/Dracula/user.css
rm -R index.tsx
curl -o index.tsx https://github.com/Ferks-FK/Pterodactyl-AutoThemes/blob/main/themes/version1.x/Dracula/index.tsx
cd
cd /var/www/pterodactyl/resources/views/layouts
rm -R admin.blade.php
curl -o admin.blade.php https://github.com/Ferks-FK/Pterodactyl-AutoThemes/blob/main/themes/version1.x/Dracula/admin.blade.php
}

#### Panel Production ####

production() {
DIR=/var/www/pterodactyl

if [ -d "$DIR" ]; then
echo
echo "**********************"
echo "* Producing panel... *"
echo "**********************"
echo
npm i -g yarn
cd /var/www/pterodactyl
yarn install
yarn add @emotion/react
yarn build:production
fi
}


bye() {
print_brake 25
echo
echo -e "* ${GREEN}The theme ${YELLOW}Dracula${GREEN} was successfully installed.${reset}"
echo -e "* ${GREEN}Thank you for using this script.${reset}"
echo -e "* ${GREEN}Support group: $(hyperlink "$SUPPORT_LINK")"
echo
}


#### Exec Script ####
download_files
production
bye

