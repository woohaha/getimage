#!/bin/bash

downloadTargetPage(){
}

getTitle(){
grep -P '(?<=<title>).*(?=<\/title>)' /tmp/$savedPage
}

grepImage(){
title=$(getTitle)
grep -Poh 'Exp.jpg' /tmp/$savedPage |sed 's/http/<img src=\"http/g'|sed 's/.jpg/.jpg\">/g'|tee -a $title.htm
}



downloadTargetPage
grepImage
moveToWww
