#!/bin/bash
#===============================================================================
#
#          FILE:  get163.sh
# 
#         USAGE:  ./get163.sh TARGET_PAGE
# 
#   DESCRIPTION:  get pp.163.com's album
# 
#       OPTIONS:  ---
#  REQUIREMENTS:  ---
#          BUGS:  ---
#         NOTES:  ---
#        AUTHOR:  woohaha (), realwoohaha@gmail.com
#       COMPANY:  
#       VERSION:  1.1
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
	iconv -f gbk -t utf-8 $tmpDir -o $tmpDir
}

makePage(){
	echo '<!DOCTYPE html>' >> $1
	echo '<meta charset="utf-8">' >> $1
	echo "<title>$picSetTitle</title>" > $1
	echo "<h1>$picSetTitle</h1>" >> $1
	grep -Poh '(?<=src.{2})http:\/\/img\d.*?\.jpg(?=\"\ )' $tmpDir |sed 's/^http/<br><img\ src=\"http/g'|sed 's/jpg$/jpg\">/g'|tee -a $1
	echo -n '<br><a href="' >> $1
	echo -n $2 | sed 's/#.*//' >> $1
	echo '">source</a>' >> $1
}
getInfo(){
	picSetTitle=$(cat $tmpDir|grep -Poh '(?<=<title>).*(?=by)')
	htmPage="$HOME/163/${photographer}_${albumNum}.htm"
	makePage $htmPage $1
}



inilVar $1
getimage $1
getInfo $1

