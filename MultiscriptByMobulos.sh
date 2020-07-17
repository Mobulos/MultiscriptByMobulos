#!/bin/bash
# Init

#© Copyright 2019 – Urheberrechtshinweis
#
# Alle Inhalte, insbesondere Texte, sind urheberrechtlich geschützt. Das Urheberrecht liegt, soweit nicht ausdrücklich anders gekennzeichnet, bei Fabian Schmeltzer. Bitte fragen Sie mich, falls Sie die Inhalte dieses Internetangebotes verwenden möchten.
# Mail: Fabian.schmeltzer77@outlook.de
#
# Wer gegen das Urheberrecht verstößt (z.B. Texte unerlaubt kopiert), macht sich gem. §§ 106 ff UrhG strafbar, wird zudem kostenpflichtig abgemahnt und muss Schadensersatz leisten (§ 97 UrhG).
#
##############################################################################
#################	            	 Script		          ##########################
##############################################################################


function jumpto
{
    label=$1
    cmd=$(sed -n "/$label:/{:a;n;p;ba};" $0 | grep -v ':$')
    eval "$cmd"
    exit
}

menue=${1:-"menue"}
start=${2:-"start"}
failedmunue=${5:-"failedmenue"}
menue=${7:-"menue"}
install=${8:-"install"}
ubuntu=${9:-"ubuntu"}
noubuntu=${10:-"noubuntu"}
first=${11:-"first"}
installall=${12:-"installall"}
log=${13:-"log"}
delete=${14:-"delete"}



FILE="/tmp/out.$$"
GREP="/bin/grep"
if [ "$(id -u)" != "0" ]; then
   echo "Das Script muss als root gestartet werden." 1>&2
   exit 1
fi




  clear
  file="ports"
  if [ ! -f "$file" ]
  then
      jumpto install
  fi
  jumpto menue



install:
  sudo apt-get update && apt-get install -y x11vnc && apt-get install -y xvfb && apt-get install -y libxcursor1 && apt-get install -y ca-certificates && apt-get install -y bzip2 && apt-get install -y libnss3 && apt-get install -y libegl1-mesa && apt-get install -y x11-xkb-utils && apt-get install -y libasound2 && apt-get install -y libpci3 && apt-get install -y libxslt1.1 && apt-get install -y libxkbcommon0 && apt-get install -y libglib2.0-0 && apt-get install -y libxss1 && apt-get install -y update-ca-certificates && apt-get install -y unzip && apt-get install -y screen && apt-get install -y python && apt-get install -y curl
  touch ports
  touch user
  clear
  jumpto $installall


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
  echo "Version: 2.7.2"
  echo
  echo "  1. Bot installieren"
  echo "  2. Bot löschen"
  echo "  3. Exsistierende nutzer anzeigen"
  echo "  4. Script Updaten"
  echo "  5. Update-Log"
  echo "  6. Exit"
  echo
  read -n 1 -p "Bot Befehle: " befehl
  case $befehl in
  	1)
  	 clear
  	 jumpto $start
  	 ;;
  	2)
  	 clear
  	 jumpto $delete
  	 ;;
    3)
     clear
     echo "Folgende Benutzer exsistieren bereits:"
     echo
     cat user
     echo
     read -p "Drücke eine Taste, um fortzufahren"
     jumpto $menue
     ;;
  	4)
     clear
     echo "BEENDE DAS SCRIPT UNTER KEINEN UMSTÄNDEN!"
     read -t 3
  	 clear
  	 rm MultiscriptByMobulos.sh
  	 wget 'https://raw.githubusercontent.com/Mobulos/MultiscriptByMobulos/master/MultiscriptByMobulos.sh'
  	 chmod +x MultiscriptByMobulos.sh
  	 clear
  	 echo "Update abgeschlossen, du kannst das Script jetzt erneut starten!"
  	 exit
  	 ;;
  	5)
  	 clear
  	 echo "Update vom 01.11.2019:"
     echo
     echo "Neues:"
     echo " TS3 Client Update."
     echo
  	 echo "Verbesserungen:"
  	 echo " Unnötige Berechtigungen entfernt."
     echo " Das Script ist nun nicht mehr von meinen Servern abhängig."
     echo " Folgen der Fehler beim Installieren von Paketen gelindert."
     echo
  	 echo "Behobene Fehler:"
     echo " Bot lies sich nicht mit dem Server verbinden."
     echo " TS3 download."
     echo
     read -p "Drücke eine Taste, um fortzufahren"
  	 jumpto $menue
  	 ;;
  	6)
    clear
  	 exit
  	 ;;
  	*)
  	 clear
  	 echo "Eingabe wird nicht Akzeptiert"
     read -t 3
  	 jumpto $failedmenue
  	 ;;
  esac

  start:
  clear
  echo "Es muss ein Benutzer angelegt werden!"
  echo "Exsistierende benutzer:"
  echo
  cat user
  echo
  read -p "Wie soll der Bot heissen?: " name

  adduser --gecos "" --disabled-password $name
  adduser $name sudo
  sh -c "echo '$name ALL=NOPASSWD: ALL' >> /etc/sudoers"
  echo "Erforderliche Daten werden herruntergeladen"

  wget -P /home/$name/ 'https://raw.githubusercontent.com/Mobulos/MultiscriptByMobulos_download/master/sinusbot.current.zip'
  echo "sudo unzip /home/$name/sinusbot.current.zip" >> /home/$name/1ststart.sh
  echo "sudo rm /home/$name/sinusbot.current.zip" >> /home/$name/1ststart.sh
  echo "sudo mv sinusbot.current/* ." >> /home/$name/1ststart.sh
  echo "sudo rm sinusbot.current/" >> /home/$name/1ststart.sh

  sudo chown $name /var/run/screen/S-$name
  # TS-CLient
  wget -P /home/$name/ 'https://files.teamspeak-services.com/releases/client/3.5.3/TeamSpeak3-Client-linux_amd64-3.5.3.run'
  echo "echo "screen -dmS delete sudo rm /tmp/.sinusbot.lock" >> /home/$name/start.sh" >> /home/$name/1ststart.sh
  echo "echo "screen -dmS delete2 sudo rm /tmp/.X11-unix/X40" >> /home/$name/start.sh" >> /home/$name/1ststart.sh
  echo "echo "pkill screen" >> /home/$name/stop.sh" >> /home/$name/1ststart.sh
  echo "echo "clear" >> /home/$name/stop.sh" >> /home/$name/1ststart.sh
  echo "echo "pkill screen" >> /home/$name/restart.sh" >> /home/$name/1ststart.sh
  echo "echo "./start.sh" >> /home/$name/restart.sh" >> /home/$name/1ststart.sh
  echo "echo "clear" >> /home/$name/restart.sh" >> /home/$name/1ststart.sh


  clear
  # TS-Client
  echo "sudo chmod u+x /home/$name/TeamSpeak3-Client-linux_amd64-3.5.3.run" >> /home/$name/1ststart.sh
  echo "clear" >> /home/$name/1ststart.sh
  echo "echo Zum akzeptieren 'ENTER', 'q', 'y' und 'ENTER' drücken" >> /home/$name/1ststart.sh
  echo "echo" >> /home/$name/1ststart.sh
  echo "echo -----------------------------------------------------" >> /home/$name/1ststart.sh
  # TS-Client
  echo "/home/$name/TeamSpeak3-Client-linux_amd64-3.5.3.run" >> /home/$name/1ststart.sh

  read -p "Bitte erstelle ein Passwort fuer den Sinusbot: " pw
  clear

  echo "Folgende Ports sind bereits belegt:"
  cat ports
  read -n 4 -p "Bitte einen neuen Port eingeben: " port

  clear
  echo "echo "screen -dmS $name ./sinusbot --override-password=$pw" >> /home/$name/start.sh" >> /home/$name/1ststart.sh
  echo "sudo chmod u+x /home/$name/start.sh" >> /home/$name/1ststart.sh
  echo "clear" >> /home/$name/1ststart.sh
  echo "echo Du kannst den Bot ab jetzt mit dem Befehl "./start.sh" starten" >> /home/$name/1ststart.sh
  echo "echo" >> /home/$name/1ststart.sh
  echo "echo Login Daten: " >> /home/$name/1ststart.sh
  echo "curl ifconfig.me;echo :$port" >> /home/$name/1ststart.sh
  echo "echo" >> /home/$name/1ststart.sh
  echo "echo Username:" >> /home/$name/1ststart.sh
  echo "echo "Admin" " >> /home/$name/1ststart.sh
  echo "echo" >> /home/$name/1ststart.sh
  echo "echo Passwort: " >> /home/$name/1ststart.sh
  echo "echo "$pw" " >> /home/$name/1ststart.sh
  echo "echo" >> /home/$name/1ststart.sh
  clear



  echo "$name:$port" >> user
  echo "$port" >> ports
  echo "$port" >> /home/$name/port
  echo "port=$port" >> /home/$name/1ststart.sh
  chmod u+x /home/$name/1ststart.sh
  echo "sudo chmod u+x /home/$name/stop.sh" >> /home/$name/1ststart.sh
  echo "sudo chmod u+x /home/$name/restart.sh" >> /home/$name/1ststart.sh
  echo "sudo chmod 755 /home/$name/sinusbot" >> /home/$name/1ststart.sh
  echo "sudo chmod -R u+rwx /home/$name/TeamSpeak3-Client-linux_amd64" >> /home/$name/1ststart.sh

  echo "ListenPort = $port " > /home/$name/config2.ini.dist
  echo "ListenHost = '0.0.0.0'" >> /home/$name/config2.ini.dist
  echo "LogLevel = 10" >> /home/$name/config2.ini.dist
  echo "TS3Path = '/home/$name/TeamSpeak3-Client-linux_amd64/ts3client_linux_amd64'" >> /home/$name/config2.ini.dist
  echo "YoutubeDLPath = '/home/$name/youtube-dl'" >> /home/$name/config2.ini.dist
  echo "sudo chown -R $name:$name /home/$name" >> /home/$name/1ststart.sh
  echo "mv config2.ini.dist config.ini.dist" >> /home/$name/1ststart.sh
  echo "sudo cp config.ini.dist config.ini" >> /home/$name/1ststart.sh

  echo "sudo rm /home/$name/TeamSpeak3-Client-linux_amd64/xcbglintegrations/libqxcb-glx-integration.so" >> /home/$name/1ststart.sh
  echo "sudo mkdir /home/$name/TeamSpeak3-Client-linux_amd64/plugins" >> /home/$name/1ststart.sh
  echo "sudo cp /home/$name/plugin/libsoundbot_plugin.so /home/$name/TeamSpeak3-Client-linux_amd64/plugins/." >> /home/$name/1ststart.sh
  echo "sudo chown -R $name:$name /home/$name/*" >> /home/$name/1ststart.sh
  echo "rm /home/$name/1ststart.sh" >> /home/$name/1ststart.sh

  chown -R $name:$name /home/$name/*
  clear
  cd /home/$name
  su $name -c /home/$name/1ststart.sh

  sudo curl -L https://yt-dl.org/downloads/latest/youtube-dl -o /home/$name/youtube-dl
  sudo chmod a+rx /home/$name/youtube-dl
  /home/$name/youtube-dl -U
  sudo chmod 777 /home/$name/youtube-dl


  su - $name
  exit

delete:
  echo "Exsistierende Benutzer:"
  cat user
  echo
  echo "Mögliche Eigabe: bot1"
  echo "Falsche Eingabe bot1:8087"
  echo
  read -p "Welchen Bot möchtest du löschen? " name
  killall -u $name
  clear
  cat /home/$name/port
  read -n 4 -p "bitte gebe zur verifizierung die obenstehenden Zahlen ein: " ports
  grep -v "$name:$ports" user > user2
  mv user2 user
  grep -v "$ports" ports > ports2
  mv ports2 ports
  deluser $name
  rm -r /home/$name
  clear
  echo Der User wurde gelöscht
  exit
