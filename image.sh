#!/bin/sh
target=$1
image_dir='../images/'
sed -i "" "s#/Users/fangcong/Library/Application Support/typora-user-images/#${image_dir}#g" ./md/${target}
mv /Users/fangcong/Library/Application\ Support/typora-user-images/* /Users/fangcong/source/study-log/images
