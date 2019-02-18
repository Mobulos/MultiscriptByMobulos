test
##############################################################################
#################			 Auto-Update			##########################
##############################################################################
assad
#! /bin/bash

USER_NAME=Mobulos
REPO_NAME=MultiscriptByMobulos

if [ ! $1 ]; then
    echo 'Usage:'
    echo "$0 <github's username> <github's repository name> [stable ref] [destination dir] [excluded patterns]"
    echo
    echo 'The stable ref is optional and defaults to heads/master.'
    echo 'The destination dir is optional and defaults to current dir.'
    echo 'The excluded patterns are a list (enclosed in quotes) of patterns of files to be not overwritten.'
    echo
    exit 0
fi

if [ $3 ]; then
    STABLE_REF="$3"
else
    STABLE_REF='heads/master'
fi

LAST_COMMIT_FILE=/tmp/$USER_NAME.$REPO_NAME.`echo $STABLE_REF | tr '/' '_'`

if [ "$4" ]; then
    DEST_DIR="$4"
else
    DEST_DIR='.'
fi

if [ "$5" ]; then
    EXCLUDED_PAT="$5"
else
    EXCLUDED_PAT=''
fi

COMMIT_HASH=`curl https://api.github.com/repos/$USER_NAME/$REPO_NAME/git/refs/$STABLE_REF | grep 'sha'` || exit 1

function fetch_and_update() {
    # fetch new files
    curl "http://nodeload.github.com/$USER_NAME/$REPO_NAME/tarball/master" | tar -x || exit 1

    # remove patterns
    [ "$EXCLUDED_PAT" ] && cd $USER_NAME-$REPO_NAME-* && rm -rvf $EXCLUDED_PAT && cd ..

    # copy all files form repo to destination
    cp -rv $USER_NAME-$REPO_NAME-*/* $DEST_DIR || exit 1

    # delete temporary fetched repo
    rm -rf $USER_NAME-$REPO_NAME-*/ || exit 1

    # updates file with last commit
    echo "$COMMIT_HASH" > $LAST_COMMIT_FILE || exit 1
}

if [ -f $LAST_COMMIT_FILE ]; then
    LAST_COMMIT=`cat $LAST_COMMIT_FILE`

    if [ "$LAST_COMMIT" != "$COMMIT_HASH" ]; then
        fetch_and_update
    else
        echo "repo up to date."
    fi
else
    fetch_and_update
fi

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
