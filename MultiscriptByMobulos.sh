#!/bin/bash

#© Copyright 2019 – Urheberrechtshinweis
#
# Alle Inhalte, insbesondere Texte, sind urheberrechtlich geschützt. Das Urheberrecht liegt, soweit nicht ausdrücklich anders gekennzeichnet, bei Fabian Schmeltzer. Bitte fragen Sie mich, falls Sie die Inhalte dieses Internetangebotes verwenden möchten.
# Mail: Fabian@schmeltzer.info
#
# Wer gegen das Urheberrecht verstößt (z.B. Texte unerlaubt kopiert), macht sich gem. §§ 106 ff UrhG strafbar, wird zudem kostenpflichtig abgemahnt und muss Schadensersatz leisten (§ 97 UrhG).
#


############################################
################# CHANGE ###################
ver=3.2.8
dat=15.05.2021
filescript=MultiscriptByMobulos.sh
link=https://raw.githubusercontent.com/Mobulos/MultiscriptByMobulos/master/MultiscriptByMobulos.sh
############################################
############################################

#JumpTo Funktion init
function jumpto
{
    label=$1
    cmd=$(sed -n "/$label:/{:a;n;p;ba};" $0 | grep -v ':$')
    eval "$cmd"
    exit
}


#JumpTo Definitionen
menue=${1:-"menue"}
start=${2:-"start"}
failedmenue=${3:-"failedmenue"}
menue=${4:-"menue"}
install=${5:-"install"}
installall=${6:-"installall"}
delete=${7:-"delete"}
installscripts=${8:-"installscripts"}


# Farbcodes definieren
red=($(tput setaf 1))
green=($(tput setaf 2))
yellow=($(tput setaf 3))
reset=($(tput sgr0))



function error
{
    clear
    echo -n "$red"
    echo "FEHLER #$code"
    echo "$reset"
    echo "Bitte erstelle ein$yellow issue$reset auf Github: 'https://github.com/Mobulos/MultiscriptByMobulos/issues' und nenne den Fehlercode #$code"
    echo
    echo "Wenn du das Script weiterhin nutzen willst musst du follgende befehle eingeben:"
    echo "$red"
    echo "WARNUNG diese Befehle beenden alle screens und löschen alle Bots!!! Mache gegebenenfalls ein Backup der Bots!!!"
    echo -n "$yellow"
    echo "'pkill screen || rm -r /home/bot* || rm ports user'"
    echo "$reset"
    echo "Dannach kannst du das Script wie gewohnt starten"
    exit 0
}


#Farbcode beim start reseten
echo "$reset"

#Root Check
FILE="/tmp/out.$$"
GREP="/bin/grep"
if [ "$(id -u)" != "0" ]; then
   echo "Das Script muss als root gestartet werden." 1>&2
   exit 0
fi

#Erster start Check
clear
file="ports"
file2="user"
if [ ! -f "$file" ]
then
    #Port existiert nicht
    if [ ! -f "$file2" ]
	then
        #Port existiert nicht | User existiert nicht
		jumpto install
	else
        #Port existiert nicht | User existiert
        code="001"
        error
	fi
else
    #Port existiert
	if [ ! -f "$file2" ]
	then
        #Port existiert | User existiert nicht
        code="002"
        error
	else
        #Port existiert | User existiert
		jumpto menue
	fi
fi


install:
    apt-get update ||:
    apt-get install -y sudo
    apt-get update
    for i in bzip2 ca-certificates curl libasound2 libegl1 libglib2.0-0 libnss3 libpci3 libxcursor1 libxkbcommon0 libxslt1.1 libxss1 python screen sudo unzip update-ca-certificates wget x11vnc x11-xkb-utils xvfb
    do
        apt-get install -y $i
    done
    jumpto $installall


installall:
  clear
  read -n1 -p "Hast du Ubuntu 18.04? (Y|N) Falls du dir nicht sicher bist probiere es mit nein '(N)' " ubuntu
        case $ubuntu in
        Y|y|J|j)
            add-apt-repository universe
            apt-get update
        ;;
        n|N)
            apt-get install -y libglib2.0-0
        ;;
        esac
    touch ports
    touch user
    clear
    jumpto $menue



menue:
    clear

failedmenue:
    clear
    echo "$yellow########################################"
    read -t0.1
    echo "#####  SinusBot Script by Mobulos  #####"
    read -t0.1
    echo "########################################"
    read -t0.1
    echo
    echo "$reset"
    read -t0.1
    echo "Version: $ver"
    read -t0.1
    echo "Update vom: $dat"
    tmp=($(tput setaf 2)) && echo "$tmp"
    read -t0.1
    echo "  1. Bot installieren"
    tmp=($(tput setaf 3)) && echo -n "$tmp"
    read -t0.1
    echo "  2. Bot löschen"
    tmp=($(tput setaf 4)) && echo -n "$tmp"
    read -t0.1
    echo "  3. Scripts für den SinusBot installieren"
    tmp=($(tput setaf 5)) && echo -n "$tmp"
    read -t0.1
    echo "  4. Existierende nutzer anzeigen"
    tmp=($(tput setaf 6)) && echo -n "$tmp"
    read -t0.1
    echo "  5. Script Updaten"
    read -t0.1
    tmp=($(tput setaf 1))
    echo -n "$tmp"
    echo "  6. Exit"
    echo "$reset"
    read -n1 -p "Bot Befehle: " befehl
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
        jumpto $installscripts
        exit
    ;;
    4)
        clear
        echo "Folgende Benutzer exsistieren bereits:"
        echo
        cat user
        echo
        read -n1 -p "Drücke eine Taste, um fortzufahren."
        jumpto $menue
    ;;
  	5|u|U)
        clear
        echo "Dies kann einige Sekunden dauern!"
        read -t3 -n1
        clear
        rm $filescript
        wget $link
        chmod +x $filescript
        clear
        echo "Update abgeschlossen, du kannst das Script jetzt erneut starten."
        exit
  	;;
  	6)
        clear
        exit
  	;;
  	*)
        clear
        echo "Eingabe wird nicht Akzeptiert."
        read -t3 -n1
        jumpto $failedmenue
  	;;
    esac


start:
    clear
    for i in bot1 bot2 bot3 bot4 bot5 bot6 bot7 bot8 bot9 bot10 bot11 bot12 bot13 nan
    do
        if id "$i" &>/dev/null; then
            #user exsistiert 
            continue
            echo no
        elif [ "$i" == "nan" ]; then
            #Keine User mehr verfügbar
            clear
            code="003"
            error
        else
            user="$i"
            echo else
            break
        fi
    done
    name="$user"
    clear
    read -n1 -t3 -p "Der neue User heißt jetzt $name "
    echo
    adduser --gecos "" --disabled-password $name
    adduser $name sudo
    sh -c "echo '$name ALL=NOPASSWD: ALL' >> /etc/sudoers"
    clear
    echo "Erforderliche Daten werden herruntergeladen"
    wget -P /home/$name/ 'https://raw.githubusercontent.com/Mobulos/MultiscriptByMobulos/download/sinusbot.current.zip'
    sudo chown $name /var/run/screen/S-$name

    # TS-CLient
    wget -P /home/$name/ 'https://files.teamspeak-services.com/releases/client/3.5.3/TeamSpeak3-Client-linux_amd64-3.5.3.run'

    # TS-Client
    clear
    echo "$red"
    echo  "Bitte beachte, dass das Passwort local als ROH-Datei gespeichert wird."
    echo "$reset"
    read -p "Bitte erstelle ein Passwort fuer den Sinusbot: $reset" pw
    clear
    # Port
        for i in 8087 8088 8089 8090 8091 8092 8093 8094 8095 8096 8097 8098 9099 nan
    do
        if id "$i" &>/dev/null; then
            #user exsistiert 
            continue
        elif [ "$i" == "nan" ]; then
            code="004"
            error
        else
            port="$i"
            clear
            echo "Fuer den Bot wird der Port $yellow $port $reset genutzt"
            read -n1 -t3
            break
        fi
    done
    #1ststart.sh schreiben
    echo "sudo unzip /home/$name/sinusbot.current.zip" >> /home/$name/1ststart.sh
    echo "sudo rm /home/$name/sinusbot.current.zip" >> /home/$name/1ststart.sh
    echo "sudo mv sinusbot.current/* ." >> /home/$name/1ststart.sh
    echo "sudo rm -r sinusbot.current/" >> /home/$name/1ststart.sh
    echo "echo 'pkill screen' >> /home/$name/start.sh" >> /home/$name/1ststart.sh
    echo "echo 'screen -dmS delete sudo rm /tmp/.sinusbot.lock' >> /home/$name/start.sh" >> /home/$name/1ststart.sh
    echo "echo 'screen -dmS delete2 sudo rm /tmp/.X11-unix/X40' >> /home/$name/start.sh" >> /home/$name/1ststart.sh
    echo "echo 'pkill screen' >> /home/$name/stop.sh" >> /home/$name/1ststart.sh
    echo "echo 'clear' >> /home/$name/stop.sh" >> /home/$name/1ststart.sh
    echo "sudo chmod u+x /home/$name/TeamSpeak3-Client-linux_amd64-3.5.3.run" >> /home/$name/1ststart.sh
    echo "clear" >> /home/$name/1ststart.sh
    echo "echo Zum akzeptieren 'ENTER', 'q', 'y' und 'ENTER' drücken" >> /home/$name/1ststart.sh
    echo "echo" >> /home/$name/1ststart.sh
    echo "echo -----------------------------------------------------" >> /home/$name/1ststart.sh
    echo "/home/$name/TeamSpeak3-Client-linux_amd64-3.5.3.run" >> /home/$name/1ststart.sh
    echo "echo 'screen -dmS $name ./sinusbot --override-password=$pw' >> /home/$name/start.sh" >> /home/$name/1ststart.sh
    echo "sudo chmod u+x /home/$name/start.sh" >> /home/$name/1ststart.sh
    echo "clear" >> /home/$name/1ststart.sh
    echo "echo Du kannst den Bot ab jetzt mit dem Befehl './start.sh' starten" >> /home/$name/1ststart.sh
    echo "echo" >> /home/$name/1ststart.sh
    echo "echo Login Daten:" >> /home/$name/1ststart.sh
    echo "curl ifconfig.me;echo :$port" >> /home/$name/1ststart.sh
    echo "echo" >> /home/$name/1ststart.sh
    echo "echo Username:" >> /home/$name/1ststart.sh
    echo "echo 'admin'" >> /home/$name/1ststart.sh
    echo "echo" >> /home/$name/1ststart.sh
    echo "echo Passwort: " >> /home/$name/1ststart.sh
    echo "echo '$pw'" >> /home/$name/1ststart.sh
    echo "echo" >> /home/$name/1ststart.sh
    echo "port=$port" >> /home/$name/1ststart.sh
    echo "sudo chmod u+x /home/$name/stop.sh" >> /home/$name/1ststart.sh
    echo "sudo chmod 755 /home/$name/sinusbot" >> /home/$name/1ststart.sh
    echo "sudo chmod -R u+rwx /home/$name/TeamSpeak3-Client-linux_amd64" >> /home/$name/1ststart.sh
    echo "sudo chown -R $name:$name /home/$name" >> /home/$name/1ststart.sh
    echo "mv config2.ini.dist config.ini.dist" >> /home/$name/1ststart.sh
    echo "sudo cp config.ini.dist config.ini" >> /home/$name/1ststart.sh
    echo "sudo rm /home/$name/TeamSpeak3-Client-linux_amd64/xcbglintegrations/libqxcb-glx-integration.so" >> /home/$name/1ststart.sh
    echo "sudo mkdir /home/$name/TeamSpeak3-Client-linux_amd64/plugins" >> /home/$name/1ststart.sh
    echo "sudo cp /home/$name/plugin/libsoundbot_plugin.so /home/$name/TeamSpeak3-Client-linux_amd64/plugins/." >> /home/$name/1ststart.sh
    echo "sudo chown -R $name:$name /home/$name/*" >> /home/$name/1ststart.sh
    echo "rm /home/$name/1ststart.sh" >> /home/$name/1ststart.sh
    chmod u+x /home/$name/1ststart.sh
    pw=???

    #User Datei Eintrag
    echo "$name:$port" >> user

    #Port in Dateien eintragen
    echo "$port" >> ports
    echo "$port" >> /home/$name/port

    #Config schreiben
    echo "ListenPort = $port" > /home/$name/config2.ini.dist
    echo "ListenHost = '0.0.0.0'" >> /home/$name/config2.ini.dist
    echo "LogLevel = 10" >> /home/$name/config2.ini.dist
    echo "TS3Path = '/home/$name/TeamSpeak3-Client-linux_amd64/ts3client_linux_amd64'" >> /home/$name/config2.ini.dist
    echo "YoutubeDLPath = '/home/$name/youtube-dl'" >> /home/$name/config2.ini.dist

    chown -R $name:$name /home/$name/*
    clear
    cd /home/$name
    su $name -c /home/$name/1ststart.sh

    echo -n "$yellow"
    echo "Youtube Downloader installieren."
    echo -n "$reset"
    curl --progress-bar -L https://yt-dl.org/downloads/latest/youtube-dl -o /home/$name/youtube-dl
    chmod u+rx /home/$name/youtube-dl
    screen -dmS tmp /home/$name/youtube-dl -U
    su - $name
    exit

installscripts:
    clear
    echo "Bisher lassen sich follgende Scripts fuer den SinusBot installieren:"
    echo
    for i in Auto-Channel-Creator CountOnlineUsers expandingChannel slim-online-sheriff SpamControl Sticky_Channel Support-pp saveCPU nickCrashHelper registerNotificator
    do
        read -t0.2
        echo "  $i"
    done
    echo
    echo
    read -t0.5
    read -n1 -p "Willst du diese Scripts installieren? (Y|N) " scripts
    case $scripts in
    Y|y|J|j)
		clear
        echo "Exsistierende benutzer:"
        echo
        cat user
        echo
        read -n4 -p "Für welchen Bot sollen die Scripts installiert werden?: " name
        for i in Auto-Channel-Creator.js CountOnlineUsers.js expandingChannel.js slim-online-sheriff.js SpamControl.js Sticky_Channel.js Support-pp.js support.js saveCPU.js nickCrashHelper.js registerNotificator.js
        do
            rm /home/$name/scripts/$i
        done
        rm -r /home/$name/scripts/SpamControl
        wget -P /home/$name/scripts/ "https://raw.githubusercontent.com/Mobulos/MultiscriptByMobulos/download/scriptspack-latest.zip"
        echo "cd /home/$name/scripts/" >> /home/$name/scriptinstall.sh
        echo "sudo unzip /home/$name/scripts/scriptspack-latest.zip" >> /home/$name/scriptinstall.sh
        echo "sudo rm /home/$name/scripts/scriptspack-latest.zip" >> /home/$name/scriptinstall.sh
        echo "sudo rm /home/$name/scriptinstall.sh" >> /home/$name/scriptinstall.sh
        echo "clear" >> /home/$name/scriptinstall.sh
        clear
        sudo chmod 777 /home/$name/scriptinstall.sh
        clear
        echo "Ich kann zusätzlich noch Scripts löschen, die in den meisten Fällen nicht benötigt werden."
        echo "Diese Scripts würden gelöscht werden:"
        echo
        for i in advertising alonemode bookmark followme norecording rememberChannel welcome
        do
            echo "  $i"
            read -t0.2
        done
        echo "echo 'Die Scripts wurden nun installiert!'" >> /home/$name/scriptinstall.sh
        echo
        echo
        echo "Die Script können im nachhinein erneut installiert werden."
        read -n1 -p "Soll ich sie  LÖSCHEN? (Y|N)" scriptsdel
        case $scriptsdel in
            Y|y|J|j)
            clear
            for i in advertising.js alonemode.js bookmark.js followme.js norecording.js rememberChannel.js welcome.js
            do
                sudo rm /home/$name/scripts/$i
            done
            echo "echo Ausserdem wurden 'unnötige' Scripts entfernt!" >> /home/$name/scriptinstall.sh
            clear
            ;;
            n|N)
            echo "echo 'Es wurde keine weiteren Scripts gelöscht!'" >> /home/$name/scriptinstall.sh
            clear
            ;;
        esac
        echo "echo" >> /home/$name/scriptinstall.sh
        echo "echo Vergiss nicht, den Bot mit './start.sh' neuzustarten, um die änderungen zu übernehmen!" >> /home/$name/scriptinstall.sh
        echo "exit" >> /home/$name/scriptinstall.sh
        echo "Bitte gebe nun './scriptinstall.sh' ein um die installation abzuschließen!"
        su $name -c /home/$name/scriptinstall.sh
        su - $name
        exit
    ;;
    n|N)
        clear
        echo "Das Script wird nun beendet!"
        exit
    ;;
	esac
    exit





delete:
    echo "Exsistierende Benutzer:"
    cat user
    echo
    echo "Mögliche Eigabe: bot1"
    echo "Falsche Eingabe bot1:8087"
    echo
    read -n4 -p "Welchen Bot möchtest du löschen? " name
    killall -u $name
    clear
    cat /home/$name/port
    read -n4 -p "bitte gebe zur verifizierung die obenstehenden Zahlen ein: " ports
    grep -v "$name:$ports" user > user2
    mv user2 user
    grep -v "$ports" ports > ports2
    mv ports2 ports
    deluser $name
    rm -r /home/$name
    clear
    echo "Der User wurde gelöscht"
    exit 0
