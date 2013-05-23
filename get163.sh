#!/bin/bash
#===============================================================================
#
#          FILE:  get163.sh
# 
#         USAGE:  ./get163.sh 
# 
#   DESCRIPTION:  get pp.163.com's album
# 
#       OPTIONS:  ---
#  REQUIREMENTS:  ---
#          BUGS:  ---
#         NOTES:  ---
#        AUTHOR:  woohaha (), realwoohaha@gmail.com
#       COMPANY:  
#       VERSION:  1.0
#       CREATED:  05/23/2013 11:32:25 PM HKT
#      REVISION:  ---
#===============================================================================

inilVar(){
tmpDir="/tmp/$(date +%s)"
photographer=$(dirname $1 |awk -F\/ '{print $4}')
albumNum=$(basename $1|sed 's/\..*//')
}

getimage(){
	curl -o $tmpDir $1
}

getInfo(){
	picSetTitle=$(cat $tmpDir|grep -Poh '(?<=<title>).*(?=by)')
	htmPage="$HOME/163/${photographer}_${albumNum}.htm"
	echo "<title>$picSetTitle</title>" > $htmPage
	echo "<h1>$picSetTitle</h1>" >> $htmPage
	grep -Poh '(?<=src.{2})http:\/\/img\d.*?\.jpg(?=\"\ )' $tmpDir |sed 's/^http/<br><img\ src=\"http/g'|sed 's/jpg$/jpg\">/g'|tee -a $htmPage
	echo -n '<br><a href="' >> $htmPage
	echo -n $1 >> $htmPage
	echo '">source</a>' >> $htmPage
}


inilVar $1
getimage $1
getInfo $1

