#!/bin/sh
currTime=$(date +"%Y-%m-%d %T")
str="feat ${currTime}"
echo git add start
git add .
echo git commit start
git commit -m "${str}"
echo git push start
git push origin master