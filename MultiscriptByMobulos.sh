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
failedmunue=${5:-"failedmenue"}
failed=${6:-"failed"}
menue=${7:-"menue"}
install=${8:-"install"}
ubuntu=${9:-"ubuntu"}
noubuntu=${10:-"noubuntu"}
first=${11:-"first"}
installall=${12:-"installall"}

jumpto $install


install:
clear
read -p "Ist das dein erster start? (Ja/Nein) " first
case $first in
	Ja)
    sudo apt-get update && apt-get install -y x11vnc xvfb libxcursor1 ca-certificates bzip2 libnss3 libegl1-mesa x11-xkb-utils libasound2 update-ca-certificates
	jumpto $installall
    ;;
	
	Nein)
	jumpto $menue
	;;
	
esac

installall:
clear
read -p "Hast du Ubuntu 18.04? (Ja/Nein) Falls du dir nicht sicher bist probiere es mit 'Nein' " ubuntu
    case $ubuntu in
      Ja)
      add-apt-repository universe
      apt-get update
      clear
      jumpto $menue
      ;;

      Nein)
      apt-get install libglib2.0-0
      clear
      jumpto $menue
      ;;
    esac
	


menue:
clear
failedmenue:
echo 1. Starten
echo 2. Script Updaten
echo 3. Exit
echo Weitere Funktionen sind in Arbeit!
read -p "Bot Befehle: " befehl
case $befehl in
	1)
	 clear
	 jumpto $start
	 ;;
	2)
	 clear
	 rm MultiscriptByMobulos.sh
	 wget 'https://raw.githubusercontent.com/Mobulos/MultiscriptByMobulos/master/MultiscriptByMobulos.sh'
	 chmod +x MultiscriptByMobulos.sh
	 clear
	 echo Update abgeschlossen, du kannst das Script jetzt erneut starten!
	 exit
	 ;;
	3)
	 exit
	 ;;
	*)
	 clear
	 echo Eingabe wird nicht Akzeptiert
	 jumpto $failedmenue
	 ;;
esac

start:
clear
echo "Es muss ein Benutzer angelegt werden!"
failed:
read -p "Sollen die Exsistierenden Benutzer angezeigt werden? (Ja/Nein): " jnuser
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
echo Erforderliche Daten werden herruntergeladen

wget -P /home/$name/ 'http://mobulos.net/sinusbot.current.zip'
echo "sudo unzip /home/$name/sinusbot.current.zip" >> /home/$name/1ststart.sh
echo "sudo rm /home/$name/sinusbot.current.zip" >> /home/$name/1ststart.sh
echo "sudo mv sinusbot.current/* ." >> /home/$name/1ststart.sh
echo "sudo rm sinusbot.current/" >> /home/$name/1ststart.sh

wget -P /home/$name/ 'http://mobulos.net/TeamSpeak3-Client-linux_amd64-3.2.3.run'
echo "echo "sudo rm /tmp/.sinusbot.lock" >> /home/$name/start.sh" >> /home/$name/1ststart.sh
echo "echo "sudo rm /tmp/.X11-unix/X40" >> /home/$name/start.sh" >> /home/$name/1ststart.sh
echo "echo "echo Eventuelle Fehlermeldungen wirken sicht nicht auf den Startvorgang, und sollten IGNORIERT werden" >> /home/$name/start.sh" >> /home/$name/1ststart.sh

clear
echo "sudo chmod u+x /home/$name/TeamSpeak3-Client-linux_amd64-3.2.3.run" >> /home/$name/1ststart.sh
echo "clear" >> /home/$name/1ststart.sh
echo "echo Zum akzeptieren 'ENTER', 'q', 'y' und 'ENTER' drücken" >> /home/$name/1ststart.sh
echo "echo" >> /home/$name/1ststart.sh
echo "echo -----------------------------------------------------" >> /home/$name/1ststart.sh
echo "/home/$name/TeamSpeak3-Client-linux_amd64-3.2.3.run" >> /home/$name/1ststart.sh

read -p "Bitte erstelle ein Passwort fuer den Sinusbot: " pw
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
echo "echo" >> /home/$name/1ststart.sh
echo "echo" >> /home/$name/1ststart.sh
echo "ip addr show" >> /home/$name/1ststart.sh
chmod u+x /home/$name/1ststart.sh
echo "sudo chmod u+x /home/$name/sinusbot" >> /home/$name/1ststart.sh
echo "sudo chmod u+x /home/$name/TeamSpeak3-Client-linux_amd64/ts3client_runscript.sh" >> /home/$name/1ststart.sh

echo "ListenPort = $port " > /home/$name/config2.ini.dist
echo "ListenHost = '0.0.0.0'" >> /home/$name/config2.ini.dist
echo "TS3Path = '/home/$name/TeamSpeak3-Client-linux_amd64/ts3client_linux_amd64'" >> /home/$name/config2.ini.dist
echo "sudo chown -R $name:$name /home/$name" >> /home/$name/1ststart.sh
echo "mv config2.ini.dist config.ini.dist" >> /home/$name/1ststart.sh
echo "sudo cp config.ini.dist config.ini" >> /home/$name/1ststart.sh

echo "sudo rm /home/$name/TeamSpeak3-Client-linux_amd64/xcbglintegrations/libqxcb-glx-integration.so" >> /home/$name/1ststart.sh
echo "sudo mkdir /home/$name/TeamSpeak3-Client-linux_amd64/plugins" >> /home/$name/1ststart.sh
echo "sudo cp /home/$name/plugin/libsoundbot_plugin.so /home/$name/TeamSpeak3-Client-linux_amd64/plugins/" >> /home/$name/1ststart.sh
echo "sudo chown -R $name:$name /home/$name/*" >> /home/$name/1ststart.sh
echo "rm /home/$name/1ststart.sh" >> /home/$name/1ststart.sh

chown -R $name:$name /home/$name/*
clear
echo "Leider habe ich keinen Weg gefunden die Datei automatisch zu starten, daher:"
echo "Gebe  './1ststart.sh'  ein, um die Installation zu vervollständigen."
su - $name
exit
