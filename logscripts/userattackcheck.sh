#!/bin/bash

#to run as cron at 10AM everyday:
#echo "0 10 * * * sudo bash FILEDIR/userattackcheck.sh" | crontab -
#where FILEDIR is the directory path where this file is stored
#special note, this will remove all other cron listings

if [ ! -f "userattackcheck.awk" ]
then
echo "Please download userattackcheck.awk and include in same directory"
exit
fi
gawk -f userattackcheck.awk "/var/log/auth.log"
