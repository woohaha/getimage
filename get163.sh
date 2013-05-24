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
#       VERSION:  1.9
#       CREATED:  05/23/2013 11:32:25 PM HKT
#      REVISION:  ---
#===============================================================================

inilVar(){
tmpDir="/tmp/$(date +%s)"
photographer=$(dirname $1 |awk -F\/ '{print $4}')
albumNum=$(basename $1|sed 's/\..*//')
wwwRoot="$HOME/163"
}

getimage(){
	curl -o $tmpDir $1
	iconv -f gbk -t utf-8 $tmpDir -o $tmpDir
}

makePage(){
	echo '<!DOCTYPE html>' > $1
	echo '<meta charset="utf-8">' >> $1
	echo "<title>$picSetTitle</title>" >> $1
	echo "<h1>$picSetTitle</h1>" >> $1
	ls -Ud $wwwRoot/${htmPage}_file/* |sed 's/^/<br><img\ src=\"/g'|sed 's/jpg$/jpg\">/g' >> $1
	echo -n '<br><a href="' >> $1
	echo -n $2 | sed 's/#.*//' >> $1
	echo '">source</a>' >> $1
}
writeToIndex(){
	echo "<h3>$(date +%F)	" >> $wwwRoot/index.htm
	echo -n '<a href="' >> $wwwRoot/index.htm
	echo -n "$1" >> $wwwRoot/index.htm
	echo -n '">' >> $wwwRoot/index.htm
	echo -n "$2" >> $wwwRoot/index.htm
	echo -n '</a>' >> $wwwRoot/index.htm
	echo '</h3><br>' >> $wwwRoot/index.htm
}
getInfo(){
	picSetTitle=$(cat $tmpDir|grep -Poh '(?<=<title>).*(?=</title>)'|sed 's/\ by.*//')
	htmPage="${photographer}_${albumNum}.htm"
	makePage $wwwRoot/$htmPage $1
	writeToIndex $htmPage $picSetTitle
}
downloadImages(){
	grep -Poh '(?<=src.{2})http:\/\/img\d.*?\.jpg(?=\"\ )' $tmpDir |wget -i- -P $wwwRoot/${htmPage}_file/
}

cleanUp(){
	rm $tmpDir
}



inilVar $1
getimage $1
getInfo $1
cleanUp
