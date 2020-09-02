#!/bin/sh
currTime=$(date +"%Y-%m-%d %T")
message=$1
str="${message} by ${currTime}"
echo git add start
git add .
echo git commit start
git commit -m "${str}"
echo git push start
git push origin master