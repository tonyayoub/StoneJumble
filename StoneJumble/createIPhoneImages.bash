#!/bin/bash

name=`echo $1 | cut -f 1 -d '.'`
echo $name
newName="$name.iPhone.pdf"
echo $newName
cp $1 $newName
