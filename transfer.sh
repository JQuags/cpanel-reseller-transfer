#!/usr/bin/env bash

# Quick script to copy accounts from another cpanel server, with the reseller (not root password)
# This is just logging into cpanel to run the generate a full cpmove backup function in WHM


##
# Requires
##

## 1) logging into an account with the reseller password
## 2) the backup function working
## 3) getting the csv from list accounts and putting it in the right format


##
# Getting the csv
##

# Log into WHM as the reseller and go to list accounts. At the botton click 'Fetch CSV'
# Save it on the server you are copying it to, and call it 'domains'
# Run the below command
#cat domains | cut -d, -f1-3,10 | grep -v ^Domain, > domains2

# This is the WHM Password (resller pass)
HTTPPASS=whmpassword

# This is the WHM IP (server with the accounts now)
SERVER=IP.TRANSFERING.FROM

# This is the Remote FTP Username (ftp username)
FTPUSER=FTPUSERNAME

# This is the remote FTP Password (ftp password)
FTPPASS=ftppass

# This is the remote FTP IP (ftp IP address where accounts are going to)
FTPSERVER=ftp.server.ip

# This is the email address that gets notifications when the full backup is complete (your email address, the @ is %40)
MYEMAIL="email%40domain.com"

# backup type, possibilities are
# ftp
# passiveftp
# scp
TYPE=ftp;

# Port your ftp or scp port
PORT=21

# remote dir, default is %2F which is blank
# for scp follow format of %2Fhome%2Fusername for /home/username
REMOTEDIR=%2F;

# Sleep time in seconds (setting this too low could cause may backup processes to run at once)
sleep=200;

# you don't need to run this as root, but you may need to define a HOME
#export HOME=/root
export HOME=/home/yourusername

if [ ! -f domains2 ]; then
 echo 'Domains file missing';
 exit;
fi
# there is no error checking, so double check the above

for i in $(cat domains2 | cut -d\, -f3); do
 THEME=`cat domains2 | grep ,$i, | cut -d, -f4 | grep -v ^#`;
 curl -u $i:$HTTPPASS -k "https://$SERVER:2083/frontend/$THEME/backup/dofullbackup.html?dest=$TYPE&email=$MYEMAIL&server=$FTPSERVER&user=$FTPUSER&pass=$FTPPASS&port=$PORT&rdir=$REMOTEDIR"
 echo "Finished $i, Sleeping"
 sleep $sleep
done
