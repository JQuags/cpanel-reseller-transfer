# cpanel-reseller-transfer
bash script to help transfer multiple cpanel accounts

I quickly wrote this script to easily run the backup process for all accounts of a reseller using WHM. This calls the backup process in cpanel for each account using the ftp/scp copy function. Once its done you need to manually restore accounts yourself in the folder you copied the accounts to.

An example to restore the account is something quick like

for i in *; do /scripts/restorepkg $i; done

Run the above command in the folder all the backup accounts were copied to.

The restore as well as the below script are best run in screen.

You need to manually create the domains file for the script below. You can do this by going to list accounts in WHM and at the bottom clicking the fetch csv option. Take all that data and create a file called domains on your server. Then run

cat domains | cut -d, -f1-3,10 | grep -v ^Domain, > domains2

This will format the file, calling in domains2 in a format the below script can use.
