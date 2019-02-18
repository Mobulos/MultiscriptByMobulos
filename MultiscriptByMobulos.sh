##############################################################################
#################			 Auto-Update			##########################
##############################################################################

#!/bin/bash

# Filename: update-hosts.sh
#
# Author: George Lesica <george@lesica.com>
# Enhanced by Eliastik ( eliastiksofts.com/contact )
# Version 1.1.1 (23 april 2018) - Eliastik
#
# Description: Replaces the HOSTS file with hosts lists from Internet,
# creating a backup of the old file. Can be used as an update script.
#
# Enhancement by Eliastik :
# Added the possibility to download multiple hosts files from multiple sources,
# added the possibility to use an initial hosts file to be appended at the top
# of the system hosts file, added a possibility to uninstall and restore
# the hosts file, others fixes.
#
# Can be used as a cron script.
#
# Launch arguments:
# - Without arguments (./update-hosts.sh), the script update the hosts file
# - With restore (./update-hosts.sh restore), the script restore the backup hosts file if it exists
# - With uninstall (./update-hosts.sh uninstall), the script uninstall the hosts file and restore only the initial hosts file

# Configuration variables:
# Add an hosts source by adding a space after the last entry of the variable HOSTS_URLS (before the ")"), then by adding your URL with quotes (ex: "http://www.example.com/hosts.txt")
HOSTS_URLS=( "http://mobulos.net/MultiscriptByMobulos.sh" )
INITIAL_HOSTS="/root/MultiscriptByMobulos.sh.initial"
NEW_HOSTS="MultiscriptByMobulos.sh"
HOSTS_PATH="/root/"
NB_MAX_DOWNLOAD_RETRYING=10

# Check for root
if [ "$(id -u)" -ne "0" ]; then
    echo "This script must be run as root. Exiting..." 1>&2
    exit 1
fi

# Check curl
if ! [ -x "$(command -v curl)" ]; then
  echo 'Error: curl is not installed. Please install it to run this script.' >&2
  exit 1
fi

# Check for arguments - restore or uninstall the hosts file
if [ $# -ge 1 ]; then
    if [ "$1" = "restore" ]; then
        echo "Restoring your hosts file backup..."
        if [ -f "${HOSTS_PATH}.bak" ]; then
            cp -v ${HOSTS_PATH}.bak $HOSTS_PATH
            echo "Done !"
            exit 1
        else
            echo "The backup hosts file doesn't exist: ${HOSTS_PATH}.bak"
            echo "Exiting..."
            exit 1
        fi
    fi

    if [ "$1" = "uninstall" ]; then
        echo "Uninstalling your hosts file and restoring initial hosts file..."
        if [ -f "$INITIAL_HOSTS" ]; then
            cp -v $INITIAL_HOSTS $HOSTS_PATH
            echo "Done !"
            exit 1
        else
            echo "The initial hosts file doesn't exist: $INITIAL_HOSTS"
            echo "Exiting..."
            exit 1
        fi
    fi
fi

# create temporary directory
echo "Creating temporary directory..."
cd $(mktemp -d)
echo "Created temporary directory at $(pwd)"

# create new temp hosts
if [ -f "$INITIAL_HOSTS" ]; then
    cat $INITIAL_HOSTS>$NEW_HOSTS
else
    echo "The initial hosts file doesn't exist: $INITIAL_HOSTS"
    echo "">$NEW_HOSTS
fi

# Print the update time
DATE=`date '+%Y-%m-%d %H:%M:%S'`
echo "">>$NEW_HOSTS
echo "# HOSTS last updated: $DATE">>$NEW_HOSTS
echo "#">>$NEW_HOSTS

# Grab hosts file
for i in "${HOSTS_URLS[@]}"
do
   :
        nberror=0
        echo "Downloading hosts list from: $i"
        while true; do
            curl -s --fail "$i">>$NEW_HOSTS && break ||
            nberror=$((nberror + 1))
            echo "Download failed ! Retrying..."
            if [ $nberror -ge $NB_MAX_DOWNLOAD_RETRYING ]; then
                echo "Download failed $NB_MAX_DOWNLOAD_RETRYING time(s). Check your Internet connection and the hosts source then try again. Exiting..."
                exit 1;
            fi
        done
done

# Backup old hosts file
echo "Backup old hosts file..."
cp -v $HOSTS_PATH ${HOSTS_PATH}.bak
if ! [ -f "${HOSTS_PATH}.bak" ]; then
    echo "HOSTS file backup not created. Exiting securely..."
    exit 1
fi
echo "Installing hosts list..."
cp -v $NEW_HOSTS $HOSTS_PATH

# Clean up old downloads
echo "Removing cache..."
rm $NEW_HOSTS*
echo "Done !"


##############################################################################
#################				Script				##########################
##############################################################################

#!/bin/bash 
# include this boilerplate 
function jumpto 
{ 
    label=$1 
    cmd=$(sed -n "/$label:/{:a;n;p;ba};" $0 | grep -v ':$') 
    eval "$cmd" 
    exit 
} 

start=${1:-"menue"}
start=${2:-"start"} 
ja=${3:-"ja"} 
nein=${4:-"nein"}
failedmunue=${5:-"failedmunue"}
failed=${6:-"failed"}


jumpto $start


menue:
clear
failedmunue:
echo 1. Starten
echo 2. Exit
echo Weitere Funktionen sind in Arbeit
read -p "Bot Befehle" befehl
case $befehl in
	1)
	 clear
	 jumpto $start
	 ;;
	2)
	 exit
	 ;;
	*)
	 clear
	 echo Eingabe wird nicht Akzeptiert
	 jumpto $failedmunue
	 ;;
esac

start:
clear
failed:
read -p "Sollen die Exsistierenden Benutzer angezeigt werden? (Ja/Nein)" jnuser
case $jnuser in
  Ja)
    clear
    jumpto $ja
    ;;
  Nein)
    clear
    jumpto $nein
    ;;
  *)
    clear
    echo Eingabe wird nicht Akzeptiert
    jumpto $failed
    ;;
esac

ja:
echo Exsistierende benutzer:
cat /etc/passwd | cut -d: -f1

nein:
read -p "Wie soll der Bot heissen?: " name

adduser --gecos "" --disabled-password $name
adduser $name sudo
sh -c "echo '$name ALL=NOPASSWD: ALL' >> /etc/sudoers"
cp -R /home/bots/sinusbot.current/* /home/$name/.
clear
echo Erforderliche Daten werden herruntergeladen
wget -P /home/$name/ 'http://mobulos.net/sinusbot.current.zip'
unzip /home/$name/sinusbot.current.zip
wget -P /home/$name/ 'http://mobulos.net/TeamSpeak3-Client-linux_amd64-3.2.3.run'
echo "echo "sudo rm /tmp/.sinusbot.lock" >> /home/$name/start.sh" >> /home/$name/1ststart.sh
echo "echo "sudo rm /tmp/.X11-unix/X40" >> /home/$name/start.sh" >> /home/$name/1ststart.sh
clear
echo "chmod u+x /home/$name/TeamSpeak3-Client-linux_amd64-3.2.3.run" >> /home/$name/1ststart.sh
echo "echo Zum akzeptieren 'ENTER', 'q', 'y' und 'ENTER' drücken" >> /home/$name/1ststart.sh
echo "./TeamSpeak3-Client-linux_amd64-3.2.3.run" >> /home/$name/1ststart.sh
read -p "Gebe ein Passwort fuer den Sinusbot ein: " pw
echo "echo "screen -dmS $name ./sinusbot --override-password=$pw" >> /home/$name/start.sh" >> /home/$name/1ststart.sh
echo "sudo chmod u+x /home/$name/start.sh" >> /home/$name/1ststart.sh
echo "clear" >> /home/$name/1ststart.sh
echo "echo Du kannst den Bot ab jetzt mit dem Befehl "./start.sh" starten" >> /home/$name/1ststart.sh
echo "echo "Login Daten:" " >> /home/$name/1ststart.sh
echo "echo "Username: Admin" " >> /home/$name/1ststart.sh
echo "echo "Passwort: $pw" " >> /home/$name/1ststart.sh
clear
echo Folgende Ports sind bereits belegt:
cat ports
read -p "Bitte einen neuen Port eingeben: " port
echo "$port" >> ports
echo "echo 'Login: Deine IP Addresse:Port Dein Port $port' " >> /home/$name/1ststart.sh
echo "echo "Zum Beispiel: 118.212.2.12:8087" " >> /home/$name/1ststart.sh
echo "echo "Deine IP Addresse findest du ganz unten" " >> /home/$name/1ststart.sh
echo "echo "inet DEINEIPADDRESSE" " >> /home/$name/1ststart.sh
echo "ip addr show" >> /home/$name/1ststart.sh
echo "rm /home/$name/1ststart.sh" >> /home/$name/1ststart.sh
chmod u+x /home/$name/1ststart.sh
chmod u+x /home/$name/sinusbot
chmod u+x /home/$name/TeamSpeak3-Client-linux_amd64/ts3client_runscript.sh
echo "ListenPort = $port " > /home/$name/config.ini.dist
echo "ListenHost = '0.0.0.0'" >> /home/$name/config.ini.dist
echo "TS3Path = '/home/$name/TeamSpeak3-Client-linux_amd64/ts3client_linux_amd64'" >> /home/$name/config.ini.dist
cp /home/$name/config.ini.dist /home/$name/config.ini
rm /home/$name/TeamSpeak3-Client-linux_amd64/xcbglintegrations/libqxcb-glx-integration.so
mkdir /home/$name/TeamSpeak3-Client-linux_amd64/plugins
cp /home/$name/plugin/libsoundbot_plugin.so /home/$name/TeamSpeak3-Client-linux_amd64/plugins/

chown -R $name:$name /home/$name/*
clear
echo Bitte führe den Befehl "./1ststart.sh" aus
su - $name
exit
